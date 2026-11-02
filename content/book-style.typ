#import "numbering.typ": heading-number
#import "main-defs.typ": object-location, reference-rules
#import "note-layout.typ": contains-note, keep-note-runs

#let prose-text(body) = {
  if body.has("label") and body.label == <run-in-point-number> { "" } else if (
    body.func() == text
  ) { body.text } else if body.has("children") {
    body.children.map(prose-text).join()
  } else if body.has("child") { prose-text(body.child) } else if (
    body.has("body") and body.func() != math.equation
  ) {
    prose-text(body.body)
  } else { "" }
}

#let contains-point-number(body) = {
  if body.has("label") and body.label == <run-in-point-number> {
    true
  } else if body.has("children") {
    body.children.any(contains-point-number)
  } else if body.has("child") {
    contains-point-number(body.child)
  } else if body.has("body") { contains-point-number(body.body) } else { false }
}

#let keep-short-introduction(it) = {
  if it.has("label") and it.label == <short-introduction> { return it }
  let words = prose-text(it.body).trim()
  let complete = words.match(regex("[.!?;][^\\p{L}\\p{N}]*$")) != none
  let introduction = (
    words.len() > 0 and words.clusters().len() <= 80 and not complete
  )
  let point-paragraph = contains-point-number(it.body)
  if introduction or point-paragraph {
    context {
      let indent = par.first-line-indent
      if point-paragraph or words.match(regex("^[A-ZА-ЯЁ]")) != none {
        let paragraph = [#par(
          first-line-indent: (
            amount: if type(indent) == dictionary { indent.amount } else {
              indent
            },
            all: true,
          ),
          it.body,
        ) <short-introduction>]
        if introduction { block(sticky: true, spacing: auto, paragraph) } else {
          paragraph
        }
      } else { block(sticky: true, spacing: auto, it) }
    }
  } else { it }
}

#let book-style(body) = {
  set page(
    width: 152mm,
    height: 220mm,
    margin: (x: 18mm, top: 20mm, bottom: 18mm),
    numbering: "1",
    number-align: center + bottom,
    header: counter(footnote).update(0),
  )
  set text(
    font: "Libertinus Serif",
    size: 11pt,
    lang: "ru",
    fill: rgb("202020"),
  )
  show math.equation: set text(font: "STIX Two Math")
  show math.equation.where(block: false): set text(
    top-edge: "bounds",
    bottom-edge: "bounds",
  )
  // Keep short expressions together while retaining native breaks in longer
  // inline equations and the natural bounds of their glyphs.
  show math.equation.where(block: false): it => context {
    if measure(it).width <= 4 * text.size { box(it) } else { it }
  }
  set par(
    justify: true,
    leading: 0.62em,
    first-line-indent: 1.2em,
    spacing: 0.9em,
  )
  show par: keep-short-introduction
  set heading(numbering: heading-number)
  set footnote(numbering: n => "*" * n + ")")
  set footnote.entry(clearance: 0.75em)
  show footnote.entry: it => {
    context metadata((
      kind: "footnote-placement",
      anchor-page: it.note.location().page(),
      entry-page: it.location().page(),
    ))
    it
  }
  show link: set text(fill: rgb("202020"))
  show regex("т\\. е\\."): [т.~е.]
  show regex("т\\. д\\."): [т.~д.]
  show regex("т\\. п\\."): [т.~п.]
  show regex("т\\. о\\."): [т.~о.]
  show regex("т\\. н\\."): [т.~н.]
  show regex("и\\. о\\."): [и.~о.]
  show regex("н\\. э\\."): [н.~э.]
  show regex("-[а-яё]{1,3}\\b"): it => it.text.replace("-", "‑")
  show heading.where(level: 1): it => {
    if it.numbering != none { pagebreak(weak: true) }
    set par(first-line-indent: 0pt, justify: false)
    block(width: 100%, above: 9mm, below: 8mm, align(center, [
      #if it.has("label") {
        metadata((kind: "heading-target", target: it.label))
      }
      #if it.numbering != none {
        text(size: 11pt)[Глава #context numbering(
            "I",
            counter(heading).get().first(),
          )]
        linebreak()
      }
      #text(size: 15pt, weight: "semibold", it.body)
    ]))
  }
  show heading.where(level: 2): it => {
    set par(first-line-indent: 0pt, justify: false)
    block(width: 100%, above: 7mm, below: 5mm, sticky: true, align(center, [
      #if it.has("label") {
        metadata((kind: "heading-target", target: it.label))
      }
      #if it.numbering != none {
        [§ #context counter(heading).get().at(1). ]
      }
      #strong(it.body)
    ]))
  }
  show heading.where(level: 3): it => {
    if it.numbering == none {
      set par(first-line-indent: 0pt, justify: false)
      block(width: 100%, above: 1em, below: 0.5em, sticky: true, strong(
        it.body,
      ))
    } else {
      counter(math.equation).update(0)
      counter(figure.where(kind: "theorem")).update(0)
      counter(figure.where(kind: "example")).update(0)
      context {
        let n = counter(heading).get()
        if it.has("label") {
          metadata((kind: "heading-target", target: it.label))
        }
        [#box(strong(n.slice(1, 3).map(str).join(".") + "."))
          <run-in-point-number>]
        h(0.4em)
      }
    }
  }
  show figure.where(kind: "theorem"): it => context {
    set align(left)
    let number = counter(figure.where(kind: "theorem"))
      .at(it.location())
      .first()
    block(width: 100%, above: 0.8em, below: 0.8em, breakable: true, [
      #strong[
        Теорема #number#if it.caption != none { [ (#it.caption.body)] }.
      ] #emph(it.body)
    ])
  }
  show figure.where(kind: "example"): it => context {
    set block(breakable: true)
    set align(left)
    let number = counter(figure.where(kind: "example"))
      .at(it.location())
      .first()
    if contains-note(it.body) {
      parbreak()
      v(0.8em, weak: true)
      [#strong[Пример #number.] #it.body]
      parbreak()
      v(0.8em, weak: true)
    } else {
      block(width: 100%, above: 0.8em, below: 0.8em, breakable: true, [
        #strong[Пример #number.] #it.body
      ])
    }
  }
  show outline: set par(first-line-indent: 0pt)
  show outline.entry: set block(breakable: false)
  show outline.entry: it => context {
    let destination = object-location(it.element)
    let pattern = destination.page-numbering()
    let page-number = counter(page).at(destination)
    let folio = if pattern == none { str(page-number.first()) } else {
      numbering(pattern, ..page-number)
    }
    link(destination, it.indented(it.prefix(), [
      #it.body()#h(0.5em)#box(width: 1fr, it.fill)#h(0.5em)#box(folio)
    ]))
  }
  show: reference-rules
  keep-note-runs(body)
}
