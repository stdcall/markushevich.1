"""Select PDF pages for visual review; findings are advisory."""

import re

import pymupdf

NUMBER = re.compile(r"^\(\d+\.\d+:\d+[′″‴]*\)$")
BEGINNING = re.compile(r"^(?:Глава\s+[IVX]+|§|Теорема|Лемма|\d+\.\d+\.)")


def screen(document, *, cover=False):
    findings = []
    side = 18 * 72 / 25.4
    for page in document:
        if cover and page.number == 0:
            continue
        lines = [line for block in page.get_text("dict")["blocks"]
                 for line in block.get("lines", [])]
        body = []
        for line in lines:
            text = "".join(span["text"] for span in line["spans"]).strip()
            rect = pymupdf.Rect(line["bbox"])
            if rect.y0 < 48 or rect.y1 > page.rect.height - 45:
                continue
            body.append((text, rect, line["spans"]))
            if rect.x0 < side - 18 or rect.x1 > page.rect.width - side + 6:
                findings.append(dict(page=page.number + 1, kind="margin",
                                     text=text, bbox=list(rect)))
            if BEGINNING.match(text) and rect.y0 > page.rect.height - 80:
                findings.append(dict(page=page.number + 1, kind="low-beginning",
                                     text=text, bbox=list(rect)))
        intervals = [(rect.y0, rect.y1) for _, rect, _ in body]
        for drawing in page.get_drawings():
            rect = drawing["rect"]
            if 48 <= rect.y0 <= rect.y1 <= page.rect.height - 45:
                intervals.append((rect.y0, rect.y1))
        merged = []
        for top, bottom in sorted(intervals):
            if merged and top <= merged[-1][1] + 1:
                merged[-1][1] = max(bottom, merged[-1][1])
            else:
                merged.append([top, bottom])
        for first, second in zip(merged, merged[1:]):
            if second[0] - first[1] > 72:
                findings.append(dict(page=page.number + 1, kind="large-gap",
                                     top=first[1], bottom=second[0]))
        if merged and merged[-1][1] < page.rect.height - 160:
            findings.append(dict(page=page.number + 1, kind="short-page",
                                 bottom=merged[-1][1]))
        for text, number, _ in body:
            if not NUMBER.fullmatch(text.replace(" ", "")):
                continue
            for other_text, other, _ in body:
                if other is number or not other_text:
                    continue
                intersection = number & other
                if intersection.width > 0.5 and intersection.height > 1:
                    findings.append(dict(page=page.number + 1,
                                         kind="equation-number-overlap",
                                         number=text, text=other_text))
    return dict(advisory=True, pages_checked=len(document), findings=findings,
                pages_requiring_review=sorted({row["page"] for row in findings}))
