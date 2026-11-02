#import "main-defs.typ": object-location

#let index-sort-key(path) = (
  lower(path.join(" ")).replace("ё", "е").replace(regex("^a-"), "а")
)

#let index-printed(path, previous) = {
  let parts = ()
  let shared = previous != none
  for (index, part) in path.enumerate() {
    if shared and index < previous.len() and part == previous.at(index) {
      parts.push("—")
    } else {
      parts.push(part)
      shared = false
    }
  }
  parts.join(", ")
}

#let index-locator(location, path) = box(context {
  let position = location.position()
  let folio = counter(page).at(location)
  let pattern = location.page-numbering()
  let shown = if pattern == none { str(folio.first()) } else {
    numbering(pattern, ..folio)
  }
  metadata((
    kind: "page-reference",
    target: "index:" + path.join(", "),
    position: here().position(),
    target-position: position,
  ))
  link((page: position.page, x: 0pt, y: calc.max(0pt, position.y - 8pt)), shown)
})

#let index-entries = context {
  let entries = (:)
  for mark in query(<index-mark>) {
    let path = mark.value.path
    let key = path.join("\u{1f}")
    let location = if mark.value.target == none { mark.location() } else {
      let matches = query(mark.value.target)
      assert(matches.len() == 1, message: "An index target must be unique")
      object-location(matches.first())
    }
    let record = entries.at(key, default: (path: path, at: ()))
    if record.at.all(it => it.page() != location.page()) {
      record.at.push(location)
    }
    entries.insert(key, record)
  }
  let previous = none
  let initial = none
  for entry in entries.values().sorted(key: it => index-sort-key(it.path)) {
    let letter = upper(index-sort-key(entry.path).clusters().first())
    if letter != initial {
      initial = letter
      previous = none
      block(above: 0.8em, below: 0.4em, sticky: true, strong(letter))
    }
    let locations = entry.at.sorted(key: it => it.page())
    block(above: 0pt, below: 0.3em, par(hanging-indent: 1.2em)[
      #index-printed(entry.path, previous)
      #locations.map(it => index-locator(it, entry.path)).join([, ])
    ])
    previous = entry.path
  }
}

#let subject-index() = {
  set par(first-line-indent: 0pt, justify: false, leading: 0.45em)
  set text(size: 10pt)
  columns(2, gutter: 8mm, index-entries)
}
