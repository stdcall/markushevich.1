#import "@preview/cetz:0.5.2"
#import "01-03a-sequences.typ": hatched-polygon

#let simply-connected-examples() = cetz.canvas(length: 1mm, {
  import cetz.draw: *
  set-style(
    stroke: 0.5pt,
    content: (
      padding: 1.2,
      wrap: text.with(top-edge: "bounds", bottom-edge: "bounds"),
    ),
  )
  let height = 18
  let width = 36
  let gap = 12
  let vertex = (height + gap, 0)
  let upper-ray = (vertex.at(0) + height * 0.8, height)
  let lower-ray = (vertex.at(0) + width, 0)
  let strip-left = lower-ray.at(0) + gap
  let strip-right = strip-left + width * 0.85
  let lower-bottom = -height - gap
  let lower-top = lower-bottom + height * 0.9

  hatched-polygon(((0, 0), (height, height), (0, height)))
  line((0, 0), (height, height))
  content((height / 3, 0), emph[а)], anchor: "north")

  hatched-polygon((vertex, upper-ray, lower-ray))
  line(upper-ray, vertex, lower-ray)
  content((vertex, 50%, lower-ray), emph[б)], anchor: "north")

  hatched-polygon((
    (strip-left, 0),
    (strip-right, 0),
    (strip-right, height),
    (strip-left, height),
  ))
  line((strip-left, 0), (strip-right, 0))
  line((strip-left, height), (strip-right, height))
  content(((strip-left + strip-right) / 2, 0), emph[в)], anchor: "north")

  hatched-polygon((
    (vertex.at(0), lower-bottom),
    (lower-ray.at(0), lower-bottom),
    (lower-ray.at(0), lower-top),
    (vertex.at(0), lower-top),
  ))
  line(
    (lower-ray.at(0), lower-bottom),
    (vertex.at(0), lower-bottom),
    (vertex.at(0), lower-top),
    (lower-ray.at(0), lower-top),
  )
  content(
    ((vertex.at(0) + lower-ray.at(0)) / 2, lower-bottom),
    emph[г)],
    anchor: "north",
  )
})
