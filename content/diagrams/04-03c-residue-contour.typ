#import "@preview/cetz:0.5.2"

#let upper-semicircle-contour() = cetz.canvas(length: 1mm, {
  import cetz.draw: *
  set-style(
    stroke: 0.45pt,
    content: (
      padding: 0.8,
      wrap: text.with(top-edge: "bounds", bottom-edge: "bounds"),
    ),
    mark: (scale: 0.7, transform-shape: false, fill: black),
  )
  let radius = 21
  let origin = (0, 0)
  let left = (-radius, 0)
  let right = (radius, 0)
  let summit = (0, radius)
  line((-1.2 * radius, 0), (1.45 * radius, 0), mark: (end: "stealth"))
  line((0, -0.38 * radius), (0, 1.4 * radius), mark: (end: "stealth"))
  arc(
    origin,
    start: 0deg,
    stop: 180deg,
    radius: radius,
    anchor: "origin",
    stroke: 0.75pt,
  )
  content(left, $A$, anchor: "north-east")
  content(right, $B$, anchor: "north-west")
  content(summit, $C$, anchor: "south-west")
  content(origin, $O$, anchor: "north-east")
  content((1.45 * radius, 0), $x$, anchor: "west")
  content((0, 1.4 * radius), $y$, anchor: "east")
  cetz.decorations.flat-brace(
    origin,
    right,
    flip: true,
    amplitude: 2.7,
    content-offset: 1.2,
    name: "radius-brace",
  )
  content("radius-brace.content", $R$, anchor: "north")
})
