// Chapters, sections and points use the native hierarchical counter.
#let heading-number(..numbers) = {
  let n = numbers.pos()
  if n.len() == 1 {
    "Глава " + numbering("I", n.first())
  } else if n.len() == 2 {
    "§ " + str(n.at(1)) + "."
  } else {
    str(n.at(1)) + "." + str(n.at(2)) + "."
  }
}

#let formula-number(n) = context {
  let place = counter(heading).get()
  "(" + place.slice(1, 3).map(str).join(".") + ":" + str(n) + ")"
}

#let list-number(pattern, n) = if type(pattern) == dictionary {
  if pattern.kind == "property-variant" {
    let base = list-number(pattern.base, n)
    let ending = base.slice(-1)
    base.slice(0, -1) + "′" * pattern.primes + ending
  } else {
    assert(pattern.kind == "axiom")
    let subscripts = "₀₁₂₃₄₅₆₇₈₉".clusters()
    (
      pattern.group
        + str(n)
          .clusters()
          .map(
            it => subscripts.at(int(it)),
          )
          .join()
        + "."
    )
  }
} else if pattern == "а)" {
  "абвгдежзиклмнопрстуфхцчшщэюя".clusters().at(n - 1) + ")"
} else { numbering(pattern, n).replace("'", "′") }
