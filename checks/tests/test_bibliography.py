"""Compile bibliography data changes and inspect actual backlink targets."""

import json
from pathlib import Path
import re
import shutil
import subprocess
import tempfile
import unittest

import pymupdf

ROOT = Path(__file__).resolve().parents[2]
SAMPLE = '''#import "content/book-style.typ": book-style
#import "content/bibliography-style.typ": (
  bib-title, bib-description, bib-entry, bibliography,
)
#show: book-style
Первое упоминание #bib-title("Behnke1962").
Повторное упоминание #bib-title("Behnke1962").
Авторская сноска#footnote[#bib-description("Behnke1962")].
#pagebreak()
Второе упоминание: @bib:Behnke1962.
#pagebreak()
#bibliography[
  #bib-entry[#bib-description("Behnke1962", mention: false, full: true)]
  <bib:Behnke1962>
  #bib-entry[Внутренняя ссылка @bib:Behnke1962.] <bib:internal>
  #bib-entry[#bib-description("Milloux1953", mention: false, full: true)]
  <bib:Milloux1953>
  #bib-entry[#bib-description("Fatou1930", mention: false, full: true)]
  <bib:Fatou1930>
  #bib-entry[#bib-description("Kostrikin1986", mention: false, full: true)]
  <bib:Kostrikin1986>
  #bib-entry[#bib-description("Cauchy1882Integrales", mention: false, full: true)]
  <bib:Cauchy1882Integrales>
  #bib-entry[#bib-description("Cauchy1826Calcul", mention: false, full: true)]
  <bib:Cauchy1826Calcul>
  #bib-entry[#bib-description("Cauchy1826Exercices", mention: false, full: true)]
  <bib:Cauchy1826Exercices>
]
'''


class BibliographyTests(unittest.TestCase):
    def test_data_fields_and_deduplicated_backlinks(self):
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory)
            shutil.copytree(ROOT / "assets/fonts", root / "assets/fonts")
            (root / "content").mkdir()
            for name in ("book-style", "main-defs", "numbering", "note-layout",
                         "bibliography-data", "bibliography-style"):
                shutil.copy(ROOT / f"content/{name}.typ", root / "content")
            for name in ("references.bib", "editorial.bib"):
                shutil.copy(ROOT / name, root / name)
            (root / "sample.typ").write_text(SAMPLE)
            common = ["--root", str(root), "--ignore-system-fonts",
                      "--font-path", str(root / "assets/fonts")]

            def run(command, *arguments):
                result = subprocess.run(
                    ["typst", command, *common, *arguments], cwd=root,
                    capture_output=True, text=True, check=True,
                )
                self.assertEqual(result.stderr, "")
                return result.stdout

            run("compile", "sample.typ", "before.pdf")
            document = pymupdf.open(root / "before.pdf")
            text = " ".join(" ".join(page.get_text().split()) for page in document)
            self.assertIn("Gaston Julia", text)
            self.assertIn("P. Appell, É. Goursat", text)
            self.assertIn("Ch. XIII, ch. XIV", text)
            self.assertIn("Язык: немецкий", text)
            self.assertIn("Линейная алгебра и геометрия", text)
            self.assertIn("Première série", text)
            self.assertIn("с. 319–506", text)
            self.assertIn("с. 11–24", text)
            self.assertIn("1826–1829", text)
            self.assertNotIn("1826/1829", text)
            records = json.loads(run("eval", '''query(metadata).filter(it =>
              type(it.value) == dictionary and
              it.value.at("kind", default: none) == "page-reference"
            ).map(it => it.value)''', "--in", "sample.typ", "--format", "json"))
            self.assertEqual(len(records), 2)
            self.assertEqual([r["target-position"]["page"] for r in records], [1, 2])
            for record in records:
                source = record["position"]
                target = record["target-position"]
                expected_y = max(0, float(target["y"].removesuffix("pt")) - 8) - 10
                links = document[source["page"] - 1].get_links()
                self.assertTrue(any(
                    link["kind"] == pymupdf.LINK_GOTO
                    and link["page"] == target["page"] - 1
                    and abs(link["to"].y - expected_y) < 0.05
                    for link in links
                ))
            self.assertTrue(any(
                link.get("uri") == "https://doi.org/10.1007/978-3-662-01316-8"
                for page in document for link in page.get_links()
            ))
            original = (root / "references.bib").read_text()
            changed = original.replace(
                "title = {Theorie der analytischen Funktionen einer komplexen Veränderlichen}",
                "title = {Bibliography mutation probe}", 1,
            ).replace("doi = {10.1007/978-3-662-01316-8}",
                      "doi = {10.1234/mutation-probe}", 1)
            self.assertNotEqual(original, changed)
            (root / "references.bib").write_text(changed)
            run("compile", "sample.typ", "after.pdf")
            after = pymupdf.open(root / "after.pdf")
            self.assertIn("Bibliography mutation probe", " ".join(
                page.get_text() for page in after))
            self.assertTrue(any(
                link.get("uri") == "https://doi.org/10.1234/mutation-probe"
                for page in after for link in page.get_links()
            ))

    def test_all_records_have_literal_entries(self):
        keys = set(re.findall(r"@\w+\{(\w+),", (
            (ROOT / "references.bib").read_text()
            + (ROOT / "editorial.bib").read_text())))
        source = (ROOT / "content/80-bibliography.typ").read_text()
        labels = re.findall(r"<bib:(\w+)>", source)
        self.assertEqual(len(labels), len(keys))
        self.assertEqual(set(labels), keys)


if __name__ == "__main__":
    unittest.main()
