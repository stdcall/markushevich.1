"""Check the pinned Lean calculations without installing dependencies."""

import argparse
import json
import os
from pathlib import Path
import re
import subprocess

ROOT = Path(__file__).resolve().parents[1]
ALLOWED = {"propext", "Classical.choice", "Quot.sound"}
AXIOMS = re.compile(r"'([^']+)' (?:depends on axioms: \[([^\]]*)\]"
                    r"|does not depend on any axioms)")


def check(mathlib, lake_root=None):
    lake_root = lake_root or mathlib
    assert (lake_root / "lean-toolchain").read_text().strip() == (
        mathlib / "lean-toolchain").read_text().strip()
    manifest = json.loads((ROOT / "checks/lean-proofs.json").read_text())
    assert manifest["schema_version"] == 2
    assert (mathlib / "lean-toolchain").read_text().strip() == manifest["lean_toolchain"]
    revision = subprocess.check_output(
        ["git", "rev-parse", "HEAD"], cwd=mathlib, text=True).strip()
    assert revision == manifest["mathlib_commit"], "Unexpected mathlib revision"
    labels = {label for path in (ROOT / "content").rglob("*.typ")
              for label in re.findall(r"<([\w:.-]+)>", path.read_text())}
    files = set()
    declarations = set()
    for record in manifest["proofs"]:
        path = ROOT / record["file"]
        assert path.is_file() and path not in files
        files.add(path)
        assert record["passages"] and set(record["passages"]) <= labels
        for module in record["required_olean"]:
            assert (mathlib / ".lake/build/lib/lean" / module).is_file(), module
        expected = set(record["declarations"])
        assert expected and len(expected) == len(record["declarations"])
        assert not expected & declarations
        declarations |= expected
        result = subprocess.run(
            ["lake", "env", "lean", str(path)], cwd=lake_root,
            capture_output=True, text=True, timeout=120,
        )
        output = result.stdout + result.stderr
        assert result.returncode == 0, output
        assert not re.search(r"\b(?:warning|error|sorryAx)\b", output), output
        matches = AXIOMS.findall(output)
        assert len(matches) == len(expected), output
        assert {name for name, _ in matches} == expected, output
        for name, axioms in matches:
            used = {item.strip() for item in axioms.split(",") if item.strip()}
            assert used <= ALLOWED, (name, used)
        print(f"{record['file']}: {len(expected)} declarations checked")
    assert files == {path for path in (ROOT / "checks/lean").rglob("*.lean")
                     if ".lake" not in path.parts}


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--mathlib", type=Path, default=os.environ.get("LEAN_MATHLIB"))
    parser.add_argument("--lake-root", type=Path,
                        default=os.environ.get("LEAN_LAKE_ROOT"),
                        help="Lake project providing the compiled dependencies")
    arguments = parser.parse_args()
    if arguments.mathlib is None:
        parser.error("Set LEAN_MATHLIB or pass --mathlib with the pinned checkout")
    check(arguments.mathlib.expanduser().resolve(),
          arguments.lake_root.expanduser().resolve() if arguments.lake_root else None)
