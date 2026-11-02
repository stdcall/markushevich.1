#let note-run-has-content(body) = {
  if body.func() in (footnote, metadata) { false } else if body.func() == text {
    body.text.trim() != ""
  } else if body.has("children") {
    body.children.any(note-run-has-content)
  } else if body.has("child") { note-run-has-content(body.child) } else {
    (
      body.func() == math.equation
        or (body.has("body") and note-run-has-content(body.body))
    )
  }
}
#let resumed-paragraph(body) = context {
  let indent = par.first-line-indent
  par(
    first-line-indent: (
      amount: if type(indent) == dictionary { indent.amount } else { indent },
      all: true,
    ),
    body,
  )
}
// Preserve native paragraph flow and label spans. Keep a heading or display
// with its footnote when a separate layout frame would detach the marker.
#let contains-note(body) = {
  if type(body) != content { return false }
  if body.func() == footnote { return true }
  if body.has("children") and body.children.any(contains-note) { return true }
  if body.has("child") and contains-note(body.child) { return true }
  body.has("body") and contains-note(body.body)
}
#let sequence = [].func()
#let heading-above(level, numbered: true) = if level == 2 { 7mm } else { 0.9em }
#let keep-note-runs(body) = {
  if body.has("label") or not contains-note(body) { return body }
  if body.func() != sequence {
    if body.has("child") {
      let fields = body.fields()
      let child = fields.remove("child")
      let styles = fields.remove("styles")
      return body.func()(keep-note-runs(child), styles, ..fields)
    }
    return body
  }
  let children = body.children
  let result = ()
  let ended-paragraph = false
  let resume-paragraph = false
  let i = 0
  let empty = [ ].func()
  let boundary(it) = {
    if it.func() == sequence { return it.children.any(boundary) }
    if it.has("child") { return boundary(it.child) }
    (
      it.func()
        in (
          parbreak,
          block,
          grid,
          table,
          figure,
          list,
          enum,
          terms,
          list.item,
          enum.item,
          terms.item,
          heading,
          pagebreak,
          colbreak,
        )
        or (it.func() == math.equation and it.block)
    )
  }
  while i < children.len() {
    let child = children.at(i)
    let grouped = false
    if (
      child.func() == heading
        and child
          .fields()
          .at(
            "level",
            default: child.fields().at("depth", default: 1),
          )
          in (2, 3)
    ) {
      let start = i + 1
      while (
        start < children.len()
          and (
            children.at(start).func() in (empty, parbreak)
          )
      ) { start += 1 }
      let stop = start
      while stop < children.len() and not boundary(children.at(stop)) {
        stop += 1
      }
      if (
        contains-note(child)
          or (
            child
              .fields()
              .at("level", default: child.fields().at("depth", default: 1))
              == 2
              and contains-note(sequence(children.slice(start, stop)))
          )
      ) {
        let level = child
          .fields()
          .at(
            "level",
            default: child.fields().at("depth", default: 1),
          )
        result.push(block(
          width: 100%,
          spacing: auto,
          above: heading-above(
            level,
            numbered: child.fields().at("numbering", default: auto) != none,
          ),
          breakable: false,
          sequence(children.slice(i, stop)) + parbreak(),
        ))
        ended-paragraph = note-run-has-content(sequence(children.slice(
          start,
          stop,
        )))
        i = stop
        grouped = true
      }
    }
    if not grouped and child.func() == math.equation and child.block {
      let stop = i + 1
      while stop < children.len() and not boundary(children.at(stop)) {
        stop += 1
      }
      let tail = sequence(children.slice(i + 1, stop))
      if contains-note(tail) {
        result.push(block(
          width: 100%,
          spacing: auto,
          breakable: false,
          sequence(
            children.slice(i, stop),
          ),
        ))
        ended-paragraph = note-run-has-content(tail)
        i = stop
        grouped = true
      }
    }
    if not grouped and not boundary(child) {
      let stop = i + 1
      while stop < children.len() and not boundary(children.at(stop)) {
        stop += 1
      }
      let run = sequence(children.slice(i, stop))
      if note-run-has-content(run) or contains-note(run) {
        result.push(if resume-paragraph { resumed-paragraph(run) } else { run })
        resume-paragraph = false
      } else {
        result.push(run)
      }
      i = stop
      grouped = true
    }
    if not grouped {
      if child.func() == parbreak {
        resume-paragraph = resume-paragraph or ended-paragraph
      } else {
        resume-paragraph = false
      }
      ended-paragraph = false
      result.push(keep-note-runs(child))
      i += 1
    }
  }
  sequence(result)
}
