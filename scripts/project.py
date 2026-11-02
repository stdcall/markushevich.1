"""Build the Typst edition and verify its PDF navigation and fonts."""

import argparse
import hashlib
import json
import os
from pathlib import Path
import re
import struct
import subprocess
import sys
import tempfile

import pymupdf
from check_layout import screen
from pypdf import PdfReader, PdfWriter
from pypdf.generic import ArrayObject, FloatObject, NameObject, NullObject

ROOT = Path(__file__).resolve().parents[1]
CONFIG = json.loads((ROOT / "config/project.json").read_text())


def run(args):
    result = subprocess.run(args, cwd=ROOT, capture_output=True, text=True)
    if result.returncode or re.search(r"^warning:", result.stderr, re.M):
        raise RuntimeError(result.stdout + result.stderr)
    return result.stdout


def cache():
    default = str(Path(tempfile.gettempdir()) / (ROOT.name + "-build-cache"))
    path = Path(os.environ.get("BOOK_CACHE", default)).expanduser()
    path.mkdir(parents=True, exist_ok=True)
    return path


def font_names():
    names = set()
    for directory in CONFIG["font_paths"]:
        for path in (ROOT / directory).iterdir():
            if path.suffix.lower() not in (".ttf", ".otf"):
                continue
            data = path.read_bytes()
            for index in range(struct.unpack_from(">H", data, 4)[0]):
                tag, _, table, _ = struct.unpack_from(">4sIII", data, 12 + index * 16)
                if tag != b"name":
                    continue
                _, count, strings = struct.unpack_from(">3H", data, table)
                for record in range(count):
                    platform, _, _, name_id, length, offset = struct.unpack_from(
                        ">6H", data, table + 6 + record * 12)
                    if name_id == 6:
                        start = table + strings + offset
                        names.add(data[start:start + length].decode(
                            "utf-16-be" if platform in (0, 3) else "latin-1"))
    assert names, "No bundled fonts"
    return names


def check_fonts(path):
    allowed = font_names()
    document = pymupdf.open(path)
    for page in document:
        for _, _, kind, name, _, encoding, *_ in page.get_fonts(full=True):
            name = re.sub(r"^[A-Z]{6}\+", "", name)
            if kind == "Type0":
                name = name.removesuffix("-" + encoding)
            assert name in allowed, f"Page {page.number + 1}: foreign font {name}"
        for span in page.get_texttrace():
            for codepoint, glyph, *_ in span["chars"]:
                assert glyph != 0, f"Page {page.number + 1}: missing glyph {codepoint}"
        assert not page.get_images(), f"Page {page.number + 1}: unexpected raster"
    document.close()


def normalize_outlines(raw, target, headings):
    reader = PdfReader(raw)
    writer = PdfWriter(raw, incremental=True)
    count = 0

    def walk(ref):
        nonlocal count
        while ref:
            node = ref.get_object()
            holder, key = node, "/Dest"
            if "/A" in node:
                holder = node["/A"].get_object()
                assert holder.get("/S") == "/GoTo"
                key = "/D"
            dest = holder[key].get_object()
            if isinstance(dest, str):
                dest = reader.named_destinations[dest].dest_array
            assert len(dest) == 5 and str(dest[1]) == "/XYZ"
            assert count < len(headings), "Outline has an unexpected heading"
            heading = headings[count]
            position = heading["position"]
            page = writer.pages[int(position["page"]) - 1]
            top = float(page.mediabox.height)
            if not heading["chapter"]:
                y = float(str(position["y"]).removesuffix("pt"))
                top -= max(0, y - 10)
            holder[NameObject(key)] = ArrayObject([
                page.indirect_reference, NameObject("/XYZ"), FloatObject(0),
                FloatObject(top), NullObject()])
            count += 1
            if node.get("/First"):
                walk(node["/First"])
            ref = node.get("/Next")

    if "/Outlines" in writer.root_object:
        walk(writer.root_object["/Outlines"].get("/First"))
    assert count == len(headings), "An outlined heading is absent from the PDF"
    assert "/OpenAction" not in writer.root_object
    writer.write(target)
    checked = PdfReader(target)
    assert len(reader.pages) == len(checked.pages)
    for before, after in zip(reader.pages, checked.pages):
        assert list(before.mediabox) == list(after.mediabox)
        assert list(before.cropbox) == list(after.cropbox)
        assert before.get_contents().get_data() == after.get_contents().get_data()
    records = []

    def validate(items):
        for item in items:
            if isinstance(item, list):
                validate(item)
                continue
            dest = item.dest_array
            assert str(dest[1]) == "/XYZ" and float(dest[2]) == 0
            assert isinstance(dest[4], NullObject)
            page = checked.get_destination_page_number(item)
            assert page is not None and 0 <= page < len(checked.pages)
            assert 0 <= float(dest[3]) <= float(checked.pages[page].mediabox.height)
            records.append({"title": item.title, "page": page + 1,
                            "top": float(dest[3]), "zoom": None})

    validate(checked.outline)
    assert len(records) == count
    return records


def typst_args():
    return ["--root", str(ROOT), "--ignore-system-fonts",
            "--font-path", str(ROOT / "assets/fonts"),
            "--input", "stage=" + CONFIG["stage"]]


def point_number(value):
    return float(str(value).removesuffix("pt"))


def check_reference_targets(references):
    invalid = [item for item in references if item["matches"] != 1]
    if invalid:
        raise ValueError("Reference targets must be unique: "
                         + json.dumps(invalid, ensure_ascii=False))


def check_page_references(document, metadata):
    count = 0
    for record in metadata:
        value = record["value"]
        if not isinstance(value, dict) or value.get("kind") != "page-reference":
            continue
        source, target = value["position"], value["target-position"]
        x, y = point_number(source["x"]), point_number(source["y"])
        expected_y = max(0, point_number(target["y"]) - 8) - 10
        links = document[source["page"] - 1].get_links()
        assert any(
            link["kind"] == pymupdf.LINK_GOTO
            and link["page"] == target["page"] - 1
            and abs(link["to"].x) < 0.05
            and abs(link["to"].y - expected_y) < 0.05
            and abs(link["from"].x0 - x) < 0.05
            and link["from"].y0 - 0.05 <= y <= link["from"].y1 + 0.05
            for link in links
        ), ("Wrong page-reference destination", value["target"], source, target)
        count += 1
    return count


def source_files(root=ROOT, entry=None):
    config = json.loads((root / "config/project.json").read_text())
    pending = [root / (entry or config["entry"])]
    found = set()
    while pending:
        path = pending.pop().resolve()
        if path in found:
            continue
        found.add(path)
        text = path.read_text()
        for name in re.findall(r'#(?:include|import)\s+"([^@\"]+\.typ)"', text):
            child = root / name[1:] if name.startswith("/") else path.parent / name
            pending.append(child)
    return sorted(found)


def input_fingerprint(entry):
    files = set(source_files(entry=entry))
    files.update(ROOT.glob("*.bib"))
    files.update((ROOT / "config/project.json", ROOT / "corrections.json"))
    files.update(path for path in (ROOT / "assets").rglob("*") if path.is_file())
    return {
        str(path.relative_to(ROOT)): hashlib.sha256(path.read_bytes()).hexdigest()
        for path in sorted(files)
    }


def lint_sources():
    failures = []
    for path in source_files():
        if not re.match(r"\d\d-", path.name):
            continue
        text = path.read_text()
        for line, body in enumerate(text.splitlines(), 1):
            if len(body) > 80:
                failures.append(f"{path.name}:{line}: line exceeds 80 characters")
            if re.search(r"#(?:h|v|set|show)\b", body):
                failures.append(f"{path.name}:{line}: local layout rule")
        for match in re.finditer(r"#[A-Za-z][\w-]*([\[(])", text):
            opening = match.group(1)
            closing = ")" if opening == "(" else "]"
            depth, quoted, escaped = 1, False, False
            end = match.end()
            while end < len(text) and depth:
                char = text[end]
                if escaped:
                    escaped = False
                elif char == "\\":
                    escaped = True
                elif char == '"':
                    quoted = not quoted
                elif not quoted:
                    depth += (char == opening) - (char == closing)
                end += 1
            if depth == 0 and text[end:end + 1] == ";":
                line = text[:end].count("\n") + 1
                failures.append(f"{path.name}:{line}: escape the literal semicolon")
    if failures:
        raise ValueError("\n".join(failures))


def check_corrections():
    entries = json.loads((ROOT / "corrections.json").read_text())
    identifiers = [item["id"] for item in entries]
    assert len(identifiers) == len(set(identifiers)), "Repeated correction id"
    labels = {label for path in source_files()
              for label in re.findall(r"<([a-z][\w:.-]+)>", path.read_text())}
    for item in entries:
        assert set(item) == {"id", "target", "location", "original", "corrected", "reason"}
        assert all(isinstance(value, str) and value.strip() for value in item.values())
        assert item["target"] in labels, ("Missing correction target", item["id"])


def wrap_source(text):
    """Wrap token whitespace that Typstyle treats as an indivisible formula."""
    result = []
    in_math = False
    for original in text.splitlines():
        line = original.rstrip()
        heading_line = not in_math and line.lstrip().startswith("=")
        quoted, escaped = False, False
        for char in original:
            if escaped:
                escaped = False
            elif char == "\\":
                escaped = True
            elif char == '"':
                quoted = not quoted
            elif char == "$" and not quoted:
                in_math = not in_math
        indent = line[:len(line) - len(line.lstrip())]
        while len(line) > 80:
            quoted, escaped = False, False
            breaks = []
            for index, char in enumerate(line):
                if escaped:
                    escaped = False
                elif char == "\\":
                    escaped = True
                elif char == '"':
                    quoted = not quoted
                elif char == " " and not quoted and index > len(indent):
                    if not heading_line or line[index + 1:].startswith("<"):
                        breaks.append(index)
            choices = [index for index in breaks if index <= 80]
            if not choices:
                break
            boundary = choices[-1]
            result.append(line[:boundary])
            continuation = indent + ("// " if line.lstrip().startswith("//") else "")
            line = continuation + line[boundary + 1:].lstrip()
        result.append(line)
    return "\n".join(result) + "\n"


def format_sources(*, write=False):
    failures = []
    for path in source_files():
        formatted = path.read_text()
        for _ in range(6):
            result = subprocess.run(
                ["typstyle", "--line-width", "80", "--indent-width", "2",
                 "--wrap-text=fill"], input=formatted, cwd=ROOT,
                capture_output=True, text=True, check=True,
            )
            assert not result.stderr, result.stderr
            revised = wrap_source(result.stdout)
            if revised == formatted:
                break
            formatted = revised
        else:
            raise ValueError(f"Formatter did not converge: {path.name}")
        if path.read_text() != formatted:
            if write:
                path.write_text(formatted)
            else:
                failures.append(str(path.relative_to(ROOT)))
    if failures:
        raise ValueError("Run just fmt: " + ", ".join(failures))


def build(*, corrections=False):
    entry = CONFIG["corrections_entry"] if corrections else CONFIG["entry"]
    inputs = input_fingerprint(entry)
    output = CONFIG["corrections_output"] if corrections else CONFIG["output"]
    output = ROOT / output
    raw = cache() / (output.stem + ".raw.pdf")
    args = typst_args()
    run(["typst", "compile", *args, entry, str(raw)])
    expression = """{
      let marks = query(metadata).map(it => (
        value: it.value, position: it.location().position(),
      ))
      let heads = query(heading).filter(it => it.outlined).map(it => (
        target: if it.has("label") { str(it.label) } else { none },
        position: it.location().position(),
        chapter: it.level == 1 and it.numbering != none,
      ))
      let references = query(ref).map(it => (
        target: str(it.target), matches: query(it.target).len(),
      ))
      (metadata: marks, headings: heads, references: references)
    }"""
    evaluated = json.loads(run([
        "typst", "eval", *args, expression, "--in", entry, "--format", "json"]))
    check_reference_targets(evaluated["references"])
    current_inputs = input_fingerprint(entry)
    if inputs != current_inputs:
        changed = sorted(name for name in inputs.keys() | current_inputs.keys()
                         if inputs.get(name) != current_inputs.get(name))
        raise RuntimeError("Build inputs changed during compilation; rebuild: "
                           + ", ".join(changed))
    footnotes = [record["value"] for record in evaluated["metadata"]
                 if isinstance(record["value"], dict)
                 and record["value"].get("kind") == "footnote-placement"]
    assert all(item["anchor-page"] == item["entry-page"] for item in footnotes), footnotes
    anchors = {
        str(mark["value"]["target"]).strip("<>"): mark["position"]
        for mark in evaluated["metadata"]
        if isinstance(mark.get("value"), dict)
        and mark["value"].get("kind") == "heading-target"
    }
    for heading in evaluated["headings"]:
        key = str(heading["target"]).strip("<>")
        if key in anchors:
            heading["position"] = anchors[key]
    temporary = cache() / (output.stem + ".checked.pdf")
    outlines = normalize_outlines(raw, temporary, evaluated["headings"])
    check_fonts(temporary)
    labels = PdfReader(temporary).page_labels
    if not corrections:
        assert labels[:2] == ["", "1"], "Cover and title page labels"
        assert labels[2:] == [str(n) for n in range(3, len(labels) + 1)]
    document = pymupdf.open(temporary)
    page_references = check_page_references(document, evaluated["metadata"])
    layout_report = screen(document, cover=not corrections)
    (cache() / (output.stem + ".layout.json")).write_text(
        json.dumps(layout_report, ensure_ascii=False, indent=2) + "\n")
    for page in document:
        assert page.get_text().strip(), f"Empty page {page.number + 1}"
        for link in page.get_links():
            if link["kind"] == pymupdf.LINK_GOTO:
                assert 0 <= link["page"] < len(document), link
    report = {
        "source_sha256": hashlib.sha256(json.dumps(
            inputs, sort_keys=True).encode()).hexdigest(),
        "pdf_sha256": hashlib.sha256(temporary.read_bytes()).hexdigest(),
        "pages": len(document), "outlines": outlines,
        "stage": CONFIG["stage"], "viewer_click_test": False,
        "page_references": page_references,
        "references": len(evaluated["references"]),
    }
    document.close()
    output.parent.mkdir(parents=True, exist_ok=True)
    output.write_bytes(temporary.read_bytes())
    (cache() / (output.stem + ".checks.json")).write_text(
        json.dumps(report, ensure_ascii=False, indent=2) + "\n")
    if not corrections:
        metadata = evaluated["metadata"]
        seen_sources = set()
        unique_metadata = []
        for record in metadata:
            value = record.get("value")
            if isinstance(value, dict) and value.get("kind") == "source":
                number = value["file-page"]
                if number in seen_sources:
                    continue
                seen_sources.add(number)
            unique_metadata.append(record)
        (cache() / "document.json").write_text(json.dumps({
            "metadata": unique_metadata}, ensure_ascii=False, indent=2) + "\n")
    checksums = []
    for pdf in sorted(output.parent.glob("*.pdf")):
        checksums.append(hashlib.sha256(pdf.read_bytes()).hexdigest() + "  " + pdf.name)
    (output.parent / "SHA256SUMS").write_text("\n".join(checksums) + "\n")
    print(f"{output}: {report['pages']} pages, {len(outlines)} bookmarks")


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("command", choices=(
        "build", "check", "fmt", "corrections"))
    args = parser.parse_args()
    if args.command == "fmt":
        format_sources(write=True)
        return
    if args.command == "check":
        format_sources()
        lint_sources()
        check_corrections()
        for tool, version in CONFIG["tool_versions"].items():
            flag = "-V" if tool == "tinymist" else "--version"
            assert version in run([tool, flag]), (tool, version)
        run([sys.executable, "-m", "unittest", "discover", "-s", "checks/tests"])
        run([sys.executable, "scripts/check_lsp.py"])
        if os.environ.get("LEAN_MATHLIB"):
            run([sys.executable, "scripts/check_lean.py"])
        elif CONFIG["stage"] == "final":
            raise ValueError("Set LEAN_MATHLIB to check the pinned calculations")
        build()
        build(corrections=True)
        return
    build(corrections=args.command == "corrections")


if __name__ == "__main__":
    main()
