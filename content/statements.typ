#import "numbering.typ": list-number
#import "main-defs.typ": reference-target

#let named-statement(name, body) = block(
  width: 100%,
  above: 0.8em,
  below: 0.8em,
  breakable: true,
  [#strong(name + ".") #emph(body)],
)
#let theorem(body) = named-statement("Теорема", body)
#let numbered-theorem(body, name: none) = figure(
  kind: "theorem",
  supplement: [Теорема],
  numbering: "1",
  caption: name,
  body,
)
#let numbered-example(body) = figure(
  kind: "example",
  supplement: [Пример],
  numbering: "1",
  body,
)
#let lemma(body) = named-statement("Лемма", body)
#let definition(body) = named-statement("Определение", body)
#let property-label(body) = {
  if body.func() in (enum, enum.item, list, list.item, terms, terms.item) {
    return none
  }
  if (
    body.has("label")
      and (
        str(body.label).starts-with("prop:")
          or str(body.label).starts-with("ax:")
      )
  ) {
    body.label
  } else if body.has("children") {
    body.children.map(property-label).find(value => value != none)
  } else if body.has("child") { property-label(body.child) } else if (
    body.has("body")
  ) { property-label(body.body) } else { none }
}
#let property-data(base) = {
  let target = reference-target(base)
  assert(target != none)
  query(<property-target>).find(it => it.value.target == target).value
}
#let properties(start: 1, after: none, numbering: "1)", ..items) = {
  if after != none {
    return context properties(
      start: property-data(after).number + 1,
      numbering: numbering,
      ..items.pos(),
    )
  }
  enum(
    start: start,
    numbering: n => {
      let structured = type(numbering) == dictionary
      let fixed = if structured { numbering.kind == "axiom" } else {
        numbering.ends-with(".")
      }
      if fixed {
        box(
          width: if structured { 2.4em } else { 2em },
          align(right, list-number(numbering, n)),
        )
      } else { list-number(numbering, n) }
    },
    ..items
      .pos()
      .enumerate()
      .map(((index, body)) => enum.item([
        #let target = property-label(body)
        #if target != none {
          [#metadata((
            kind: "property-target",
            target: target,
            number: index + start,
            pattern: numbering,
          ))<property-target>]
        }#body
      ])),
  )
}
#let variant-property(base, body, primes: 1) = context {
  let data = property-data(base)
  properties(
    start: data.number,
    numbering: (kind: "property-variant", base: data.pattern, primes: primes),
    body,
  )
}
#let axioms(group, start: 1, ..items) = properties(
  start: start,
  numbering: (kind: "axiom", group: group),
  ..items.pos(),
)
#let proof(body) = block(
  width: 100%,
  above: 0.6em,
  below: 0.6em,
  breakable: true,
  [_Доказательство._ #body],
)
