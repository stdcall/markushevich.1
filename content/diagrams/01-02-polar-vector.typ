#import "@preview/cetz:0.5.2"

#let polar-vector() = cetz.canvas(length: 1mm, {
  import cetz.draw: *
  set-style(
    stroke: 0.45pt,
    content: (
      padding: 1,
      wrap: text.with(top-edge: "bounds", bottom-edge: "bounds"),
    ),
    mark: (fill: black, scale: 0.7, transform-shape: false),
    brace: (amplitude: 1.3, thickness: 0.13, content-offset: 1.1),
    angle: (radius: 6, label-radius: 12),
  )
  let origin = (0, 0)
  let z = (32, 19)
  let projection = (z, "|-", origin)
  line((-3, 0), (41, 0), name: "x-axis", mark: (end: "stealth"))
  line((0, -4), (0, 26), name: "y-axis", mark: (end: "stealth"))
  line(origin, z, name: "vector", mark: (end: "stealth"))
  line(z, projection)
  content(origin, $0$, anchor: "north-east")
  content("x-axis.end", $x$, anchor: "north")
  content("y-axis.end", $y$, anchor: "east")
  content("vector.mid", $z$, anchor: "north-west")
  cetz.angle.angle(
    origin,
    z,
    "x-axis.end",
    direction: "cw",
    label: $arg z$,
    mark: (
      end: "stealth",
    ),
  )
  cetz.decorations.brace(origin, projection, name: "x-brace", flip: true)
  content("x-brace.content", $x$, anchor: "north")
  cetz.decorations.brace(projection, z, name: "y-brace", flip: true)
  content("y-brace.content", $y$, anchor: "west")
  cetz.decorations.brace(origin, z, name: "r-brace")
  content("r-brace.content", $abs(z)$, anchor: "south-east")
})
