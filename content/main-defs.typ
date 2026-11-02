#import "numbering.typ": formula-number, list-number

#let source(n, printed: none) = context {
  metadata((
    kind: "source",
    file-page: n,
    printed-page: if printed == none { str(n - 5) } else { str(printed) },
    position: here().position(),
  ))
}

#let point() = heading(level: 3, outlined: false, supplement: none, [])

#let page-ref(body) = {
  set ref(form: "page")
  body
}

#let branch-root(n, radicand, branch) = math.attach(
  if n == 2 or n == $2$.body { math.sqrt(radicand) } else {
    math.root(n, radicand)
  },
  bl: branch,
)
#let aroot(n, radicand) = branch-root(n, radicand, $+$)

#let author-signature(body) = block(
  width: 100%,
  above: 0.6em,
  below: 0.8em,
  align(right, emph(body)),
)

#let petit(body) = {
  set text(size: 9.5pt)
  set par(leading: 0.52em, spacing: 0.75em)
  body
}

#let eq(body) = math.equation(
  block: true,
  numbering: formula-number,
  number-align: right + horizon,
  if body.func() == math.equation { body.body } else { body },
)

#let reference-target(body) = {
  if body.func() == ref { body.target } else if body.has("children") {
    body.children.map(reference-target).find(it => it != none)
  } else { none }
}

#let letter-equation-tag = metadata((kind: "letter-equation"))
#let letter-equations = math.equation.where(supplement: letter-equation-tag)
#let letter-equation-number(element) = {
  (
    "("
      + list-number(
        "а)",
        counter(letter-equations).at(element.location()).first(),
      )
  )
}

#let equation-number(element) = {
  let supplement = element.supplement
  if type(supplement) == content and supplement.func() == metadata {
    let variant = supplement.value
    if variant.kind == "equation-variant" {
      let base = query(variant.base).first()
      equation-number(base).slice(0, -1) + "′" * variant.primes + ")"
    } else if variant.kind == "letter-equation" {
      letter-equation-number(element)
    } else { panic("Unexpected equation supplement") }
  } else {
    let place = counter(heading).at(element.location())
    let number = counter(math.equation).at(element.location()).first()
    "(" + place.slice(1, 3).map(str).join(".") + ":" + str(number) + ")"
  }
}

#let variant-eq(base, body, primes: 1) = {
  let target = reference-target(base)
  assert(target != none and primes >= 0)
  math.equation(
    block: true,
    numbering: _ => context {
      let number = equation-number(query(target).first()).slice(0, -1)
      number + "′" * primes + ")"
    },
    supplement: metadata((
      kind: "equation-variant",
      base: target,
      primes: primes,
    )),
    number-align: right + horizon,
    {
      counter(math.equation).update(n => n - 1)
      if body.func() == math.equation { body.body } else { body }
    },
  )
}

#let repeat-eq(base, body) = variant-eq(base, body, primes: 0)

#let letter-eq(body) = math.equation(
  block: true,
  supplement: letter-equation-tag,
  numbering: _ => context {
    "(" + list-number("а)", counter(letter-equations).get().first())
  },
  number-align: right + horizon,
  {
    counter(math.equation).update(n => n - 1)
    if body.func() == math.equation { body.body } else { body }
  },
)

#let idx(..path, target: none) = {
  assert(
    path.named().len() == 0,
    message: "Index terms are separate positional string arguments",
  )
  let path = path.pos()
  assert(
    path.len() > 0 and path.all(it => type(it) == str),
    message: "Index terms are separate string arguments",
  )
  [#metadata((kind: "index-mark", path: path, target: target))<index-mark>]
}

#let editorial-note-counter = counter("editorial-note")
#let ed-note(body) = {
  editorial-note-counter.step()
  context {
    let mark = "*" + str(editorial-note-counter.get().first()) + ")"
    footnote(numbering: _ => mark)[#body~— _Прим.~ред._]
    counter(footnote).update(n => n - 1)
  }
}

#let object-location(element) = {
  let anchors = if element.has("label") {
    query(metadata.where(value: (
      kind: "heading-target",
      target: element.label,
    )))
  } else { () }
  if anchors.len() > 0 { return anchors.first().location() }
  let properties = if element.has("label") {
    query(<property-target>).filter(it => it.value.target == element.label)
  } else { () }
  if properties.len() > 0 { properties.first().location() } else {
    element.location()
  }
}

#let bibliography-scope = state("bibliography-scope", false)

#let reference-rules(body) = {
  show ref: it => context {
    sym.wj
    if str(it.target).starts-with("bib:") and not bibliography-scope.get() {
      [#metadata((kind: "bib-mention", key: str(it.target).slice(4)))
        <bib-mention>]
    }
    let properties = query(<property-target>).filter(record => (
      record.value.target == it.target
    ))
    if properties.len() > 0 and it.form != "page" {
      let target = properties.first()
      let shown = if it.supplement not in (auto, none, []) {
        it.supplement
      } else {
        text(
          weight: "semibold",
          style: "normal",
          list-number(target.value.pattern, target.value.number).trim(
            ".",
            at: end,
          ),
        )
      }
      link(target.location(), shown)
    } else if it.element == none {
      text(weight: "semibold", "?")
    } else if (
      it.element.func() == metadata
        and type(it.element.value) == dictionary
        and it.element.value.at("kind", default: none) == "external-target"
    ) {
      assert(it.form != "page", message: "An external volume has no page here.")
      if it.supplement not in (auto, none, []) { it.supplement } else {
        text(weight: "semibold", it.element.value.number)
      }
    } else if it.form == "page" {
      let loc = object-location(it.element)
      let position = loc.position()
      let folio = counter(page).at(loc)
      let pattern = loc.page-numbering()
      let shown = if pattern == none { str(folio.first()) } else {
        numbering(pattern, ..folio)
      }
      box(context {
        metadata((
          kind: "page-reference",
          target: str(it.target),
          position: here().position(),
          target-position: position,
        ))
        link(
          (page: position.page, x: 0pt, y: calc.max(0pt, position.y - 8pt)),
          shown,
        )
      })
    } else if it.supplement not in (auto, none, []) {
      link(object-location(it.element), it.supplement)
    } else {
      let element = it.element
      let display = if element.func() == heading {
        let n = counter(heading).at(element.location())
        if element.level == 1 { numbering("I", n.first()) } else if (
          element.level == 2
        ) { str(n.at(1)) } else { n.slice(1, 3).map(str).join(".") }
      } else if element.func() == math.equation {
        equation-number(element)
      } else if element.func() == figure {
        str(
          counter(figure.where(kind: element.kind))
            .at(element.location())
            .first(),
        )
      } else if (
        element.func() == metadata and str(it.target).starts-with("def:")
      ) {
        counter(heading).at(element.location()).slice(1, 3).map(str).join(".")
      } else {
        return it
      }
      link(object-location(element), text(
        weight: "semibold",
        style: "normal",
        display,
      ))
    }
  }
  body
}
