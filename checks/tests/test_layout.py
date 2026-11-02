"""Regressions for paragraph continuations and visible heading targets."""

import json
from pathlib import Path
import subprocess
import sys
import tempfile
import unittest

import pymupdf

ROOT = Path(__file__).resolve().parents[2]
sys.path.insert(0, str(ROOT / "scripts"))
from project import (check_page_references, check_reference_targets,
                     normalize_outlines, typst_args)


def typst(command, *arguments):
    result = subprocess.run(
        ["typst", command, *typst_args(), *arguments], cwd=ROOT,
        capture_output=True, text=True,
    )
    assert result.returncode == 0, result.stderr
    assert not result.stderr, result.stderr
    return result.stdout


class LayoutTests(unittest.TestCase):
    def test_long_properties_inside_example_do_not_overlap_or_lose_text(self):
        with tempfile.TemporaryDirectory() as directory:
            output = Path(directory) / "properties.pdf"
            typst("compile", "checks/fixtures/example-with-long-properties.typ",
                  str(output))
            document = pymupdf.open(output)
            text = "\n".join(page.get_text() for page in document)
            self.assertEqual(text.count("Строка"), 120)
            previous = (0, 0)
            for name in ("первого", "второго", "третьего"):
                starts = [(n, rect.y0) for n, page in enumerate(document)
                          for rect in page.search_for(f"Строка {name} условия 0.")]
                ends = [(n, rect.y0) for n, page in enumerate(document)
                        for rect in page.search_for(f"Конец {name} условия.")]
                self.assertEqual(len(starts), 1)
                self.assertEqual(len(ends), 1)
                self.assertGreater(starts[0], previous)
                self.assertGreater(ends[0], starts[0])
                previous = ends[0]
            following = [(n, rect.y0) for n, page in enumerate(document)
                         for rect in page.search_for("Следующий обычный абзац.")]
            self.assertEqual(len(following), 1)
            self.assertGreater(following[0], previous)

    def test_examples_keep_notes_on_marker_pages_and_preserve_paragraphs(self):
        fixture = "checks/fixtures/examples-with-footnotes.typ"
        records = json.loads(typst("eval", '''(
          notes: query(footnote.entry).map(it => (
            anchor: it.note.location().page(), entry: it.location().page())),
          examples: query(figure.where(kind: "example")).map(it =>
            counter(figure.where(kind: "example")).at(it.location()).first()),
          equations: query(math.equation.where(block: true)).filter(it =>
            it.numbering != none).len(),
        )''', "--in", fixture, "--format", "json"))
        self.assertEqual(len(records["notes"]), 3)
        self.assertTrue(all(note["anchor"] == note["entry"]
                            for note in records["notes"]))
        self.assertEqual(records["examples"], [1, 2, 3])
        self.assertEqual(records["equations"], 3)
        with tempfile.TemporaryDirectory() as directory:
            output = Path(directory) / "examples.pdf"
            typst("compile", fixture, str(output))
            document = pymupdf.open(output)
            for phrase, indent in (("Следующий настоящий абзац", 1.2 * 11),
                                   ("Следовательно, наш интеграл", 0)):
                rectangles = [rect for page in document
                              for rect in page.search_for(phrase)]
                self.assertEqual(len(rectangles), 3)
                for rect in rectangles:
                    self.assertAlmostEqual(rect.x0, 18 * 72 / 25.4 + indent,
                                           delta=0.05)

    def test_named_index_term_is_rejected(self):
        result = subprocess.run([
            "typst", "compile", *typst_args(),
            "checks/fixtures/invalid-index-argument.typ", "-",
        ], cwd=ROOT, capture_output=True)
        self.assertNotEqual(result.returncode, 0)
        self.assertIn(b"Index terms are separate positional string arguments",
                      result.stderr)

    def test_point_with_footnote_retains_its_paragraph_indent(self):
        with tempfile.TemporaryDirectory() as directory:
            output = Path(directory) / "point.pdf"
            typst("compile", "checks/fixtures/point-with-footnote.typ", str(output))
            document = pymupdf.open(output)
            number = document[0].search_for("3.3.")
            self.assertEqual(len(number), 1)
            self.assertAlmostEqual(number[0].x0, 18 * 72 / 25.4 + 1.2 * 9.5,
                                   delta=0.05)
            following = document[0].search_for("Следующий обычный абзац")
            self.assertEqual(len(following), 1)
            self.assertAlmostEqual(following[0].x0, number[0].x0, delta=0.05)

    def test_notes_preserve_paragraph_flow_and_display_alignment(self):
        with tempfile.TemporaryDirectory() as directory:
            output = Path(directory) / "flow.pdf"
            typst("compile", "checks/fixtures/note-paragraph-flow.typ", str(output))
            document = pymupdf.open(output)
            self.assertEqual(len(document), 1)
            page = document[0]
            for phrase in ("Второй обычный абзац", "Третий обычный абзац",
                           "Следующий настоящий абзац"):
                rects = page.search_for(phrase)
                self.assertEqual(len(rects), 1)
                self.assertAlmostEqual(rects[0].x0, 10 + 1.2 * 11, delta=0.05)
            formulas = [pymupdf.Rect(span["bbox"])
                        for block in page.get_text("dict")["blocks"]
                        if block["type"] == 0 for line in block["lines"]
                        for span in line["spans"]
                        if span["text"].replace(" ", "") == "𝑎=𝑏."]
            self.assertEqual(len(formulas), 2)
            self.assertAlmostEqual(formulas[0].x0, formulas[1].x0, delta=0.05)
            self.assertAlmostEqual((formulas[0].x0 + formulas[0].x1) / 2,
                                   130, delta=0.05)

    def test_inline_math_has_clearance_and_keeps_its_suffix(self):
        with tempfile.TemporaryDirectory() as directory:
            output = Path(directory) / "inline.pdf"
            typst("compile", "checks/fixtures/inline-math.typ", str(output))
            document = pymupdf.open(output)
            page = document[0]
            spans = [span for block in page.get_text("dict")["blocks"]
                     if block["type"] == 0 for line in block["lines"]
                     for span in line["spans"]]
            previous = page.search_for("Предыдущая строка обычного текста.")[0]
            following = page.search_for("Следующая строка последовательности.")[0]
            prime = next(span for span in spans if span["text"] == "′")
            index = next(span for span in spans if span["text"] == "𝑘")
            self.assertGreater(prime["bbox"][1], previous.y1 + 2)
            self.assertLess(index["bbox"][3], following.y0 - 2)
            base = next(span for span in spans if span["text"] == "𝑛")
            suffix = next(span for span in spans if span["text"].startswith("‑му"))
            self.assertAlmostEqual(base["origin"][1], suffix["origin"][1],
                                   delta=0.05)
            self.assertTrue(any(span["text"] == "𝑛→∞" for span in spans))

    def test_long_introduction_can_break_before_formula(self):
        fixture = "checks/fixtures/long-introduction.typ"
        positions = json.loads(typst("eval", '''(<cue>, <formula>).map(target =>
          query(target).first().location().position())''',
            "--in", fixture, "--format", "json"))
        self.assertEqual(positions[0]["page"], 1)
        self.assertEqual(positions[1]["page"], 2)

    def test_examples_reset_without_changing_other_counters(self):
        fixture = "checks/fixtures/examples-and-page-references.typ"
        records = json.loads(typst("eval", '''query(figure.where(kind: "example"))
          .map(it => counter(figure.where(kind: "example"))
            .at(it.location()).first())''',
            "--in", fixture, "--format", "json"))
        self.assertEqual(records, [1, 2, 1])
        with tempfile.TemporaryDirectory() as directory:
            output = Path(directory) / "examples.pdf"
            typst("compile", fixture, str(output))
            document = pymupdf.open(output)
            text = " ".join(page.get_text() for page in document)
            for marker in ("Пример 1.", "Пример 2.", "Теорема 1.",
                           "(1.1:1)", "(1.2:1)",
                           "Первая страница примера: 7.",
                           "Следующая страница примера: 8.",
                           "Страница условия: 7."):
                self.assertIn(marker, " ".join(text.split()))
            titles = [rect for page in document
                      for rect in page.search_for("Пример")]
            self.assertEqual(len(titles), 3)
            for title in titles:
                self.assertAlmostEqual(title.x0, 18 * 72 / 25.4, delta=0.05)

    def test_native_page_references_use_printed_folio_and_real_target(self):
        fixture = "checks/fixtures/examples-and-page-references.typ"
        records = json.loads(typst("eval", '''query(metadata).filter(it =>
          type(it.value) == dictionary and
          it.value.at("kind", default: none) == "page-reference")
          .map(it => (value: it.value))''',
            "--in", fixture, "--format", "json"))
        self.assertEqual(len(records), 3)
        with tempfile.TemporaryDirectory() as directory:
            raw, output = [Path(directory) / name
                           for name in ("raw.pdf", "checked.pdf")]
            typst("compile", fixture, str(raw))
            normalize_outlines(raw, output, [])
            document = pymupdf.open(output)
            self.assertEqual(check_page_references(document, records), 3)

    def test_external_volume_has_no_local_page_reference(self):
        result = subprocess.run([
            "typst", "eval", *typst_args(), "query(ref)", "--in",
            "checks/fixtures/external-page-reference.typ", "--format", "json",
        ], cwd=ROOT, capture_output=True, text=True)
        self.assertNotEqual(result.returncode, 0)
        self.assertIn("An external volume has no page here", result.stderr)

    def test_external_references_do_not_link_to_number_metadata(self):
        with tempfile.TemporaryDirectory() as directory:
            output = Path(directory) / "external.pdf"
            typst("compile", "checks/fixtures/external-references.typ", str(output))
            document = pymupdf.open(output)
            text = " ".join(page.get_text() for page in document)
            self.assertIn("пятую", text)
            self.assertIn("6.2", text)
            self.assertFalse(any(page.get_links() for page in document))

    def test_unresolved_reference_cannot_pass_target_validation(self):
        expression = '''query(ref).map(it => (
          target: str(it.target), matches: query(it.target).len()))'''
        records = json.loads(typst(
            "eval", expression, "--in", "checks/fixtures/unresolved-reference.typ",
            "--format", "json"))
        with self.assertRaisesRegex(ValueError, "pt:missing"):
            check_reference_targets(records)

    def test_reference_only_paragraph_preserves_pdf_links(self):
        with tempfile.TemporaryDirectory() as directory:
            output = Path(directory) / "bare-references.pdf"
            typst("compile", "checks/fixtures/bare-references.typ", str(output))
            document = pymupdf.open(output)
            self.assertEqual(len(document), 2)
            links = [link for link in document[1].get_links()
                     if link["kind"] == pymupdf.LINK_GOTO]
            self.assertEqual(len(links), 2)
            self.assertTrue(all(link["page"] == 0 for link in links))
            self.assertEqual(len({round(link["to"].y, 2) for link in links}), 2)

    def test_nested_properties_keep_their_own_labels(self):
        fixture = "checks/fixtures/nested-properties.typ"
        records = json.loads(typst("eval", '''query(<property-target>).map(it =>
          (target: str(it.value.target), number: it.value.number))''',
            "--in", fixture, "--format", "json"))
        self.assertEqual(records, [
            {"target": "prop:inner-first", "number": 1},
            {"target": "prop:inner-second", "number": 2}])
        with tempfile.TemporaryDirectory() as directory:
            output = Path(directory) / "nested-properties.pdf"
            typst("compile", fixture, str(output))
            text = " ".join(page.get_text() for page in pymupdf.open(output))
            self.assertIn("1), 2).", " ".join(text.split()))

    def test_letter_equations_in_note_keep_separate_counter(self):
        with tempfile.TemporaryDirectory() as directory:
            output = Path(directory) / "letter-equations.pdf"
            typst("compile", "checks/fixtures/letter-equations.typ", str(output))
            document = pymupdf.open(output)
            text = " ".join(page.get_text() for page in document)
            for marker in ("(а)", "(б)", "(1.1:1)", "(1.1:2)"):
                self.assertEqual(text.count(marker), 2, text)

    def test_property_variant_and_continuation_follow_base(self):
        with tempfile.TemporaryDirectory() as directory:
            output = Path(directory) / "properties.pdf"
            typst("compile", "checks/fixtures/property-variants.typ", str(output))
            document = pymupdf.open(output)
            text = " ".join(page.get_text() for page in document)
            for marker in ("г)", "г′)", "д)"):
                self.assertEqual(text.count(marker), 2, text)
            self.assertIn("Описание: базовое свойство.", " ".join(text.split()))

    def test_pushed_footnote_stays_with_its_marker(self):
        fixture = "checks/fixtures/footnote-placement.typ"
        expression = '''query(metadata).filter(it =>
          type(it.value) == dictionary and
          it.value.at("kind", default: none) == "footnote-placement"
        ).map(it => it.value)'''
        for mode in ("heading", "equation"):
            with self.subTest(mode=mode):
                records = json.loads(typst(
                    "eval", "--input", "test=" + mode, expression,
                    "--in", fixture, "--format", "json"))
                self.assertEqual(len(records), 1)
                self.assertEqual(records[0]["anchor-page"], 2)
                self.assertEqual(records[0]["entry-page"], 2)

    def test_axiom_groups_and_references(self):
        with tempfile.TemporaryDirectory() as directory:
            output = Path(directory) / "axioms.pdf"
            typst("compile", "checks/fixtures/axioms.typ", str(output))
            document = pymupdf.open(output)
            text = " ".join(page.get_text() for page in document)
            for number in ("I₁", "I₂", "III₄"):
                self.assertEqual(text.count(number), 2, text)

    def test_short_point_keeps_run_in_number_aligned(self):
        targets = json.loads(typst("eval", '''query(metadata).filter(it =>
          type(it.value) == dictionary and
          it.value.at("kind", default: none) == "heading-target" and
          str(it.value.target).starts-with("pt:")
        ).map(it => it.location().position())''',
            "--in", "checks/fixtures/run-in-points.typ", "--format", "json"))
        self.assertEqual(len(targets), 3)
        self.assertEqual(len({target["x"] for target in targets}), 1)
        self.assertAlmostEqual(float(targets[0]["x"].removesuffix("pt")),
                               18 * 72 / 25.4 + 1.2 * 11, delta=0.05)

    def test_equation_variants_keep_base_number_and_counter(self):
        with tempfile.TemporaryDirectory() as directory:
            output = Path(directory) / "variants.pdf"
            typst("compile", "checks/fixtures/equation-variants.typ", str(output))
            document = pymupdf.open(output)
            text = " ".join(page.get_text() for page in document)
            self.assertEqual(text.count("(1.1:1)"), 4, text)
            for number in ("(1.1:1′)", "(1.1:1′′)", "(1.1:2)"):
                self.assertEqual(text.count(number), 2, text)

    def test_short_introduction_stays_with_formula(self):
        fixture = "checks/fixtures/layout.typ"
        expression = """(<cue>, <formula>).map(target =>
          query(target).first().location().position())"""
        for mode in ("break", "long"):
            positions = json.loads(typst(
                "eval", "--input", "test=" + mode, expression,
                "--in", fixture, "--format", "json",
            ))
            self.assertEqual(positions[0]["page"], positions[1]["page"])
            self.assertEqual(positions[0]["page"], 2)
        with tempfile.TemporaryDirectory() as directory:
            output = Path(directory) / "layout.pdf"
            typst("compile", fixture, str(output))
            document = pymupdf.open(output)
            cue = document[0].search_for("Так как")
            self.assertEqual(len(cue), 1)
            self.assertAlmostEqual(cue[0].x0, 10 + 1.2 * 11, delta=0.05)

    def test_heading_links_and_outlines_use_visible_targets(self):
        fixture = "checks/fixtures/navigation.typ"
        expression = """query(metadata).filter(it =>
          type(it.value) == dictionary and
          it.value.at("kind", default: none) == "heading-target"
        ).map(it => (target: str(it.value.target),
          position: it.location().position()))"""
        targets = json.loads(typst(
            "eval", expression, "--in", fixture, "--format", "json",
        ))
        self.assertEqual(len(targets), 3)
        with tempfile.TemporaryDirectory() as directory:
            raw, output = [Path(directory) / name
                           for name in ("raw.pdf", "checked.pdf")]
            typst("compile", fixture, str(raw))
            records = normalize_outlines(raw, output, [
                {"position": target["position"], "chapter": index == 0}
                for index, target in enumerate(targets[:2])
            ])
            document = pymupdf.open(output)
            links = [link for page in document for link in page.get_links()
                     if link["kind"] == pymupdf.LINK_GOTO]
            for target in targets:
                position = target["position"]
                y = float(position["y"].removesuffix("pt")) - 10
                self.assertTrue(any(
                    link["page"] == position["page"] - 1
                    and abs(link["to"].y - y) < 0.05 for link in links
                ), target["target"])
            self.assertEqual(records[0]["page"], targets[0]["position"]["page"])
            self.assertAlmostEqual(records[0]["top"], document[1].rect.height,
                                   delta=0.05)


if __name__ == "__main__":
    unittest.main()
