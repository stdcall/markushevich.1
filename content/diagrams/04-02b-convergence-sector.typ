#import "@preview/cetz:0.5.2"

#let add-points(a, b) = a.zip(b).map(((x, y)) => x + y)
#let polar-point(r, a) = (r * calc.cos(a), r * calc.sin(a))
#let dirichlet-sector() = cetz.canvas(length: 1mm, {
  import cetz.draw: *
  set-style(
    stroke: 0.5pt,
    content: (
      padding: 1,
      wrap: text.with(top-edge: "bounds", bottom-edge: "bounds"),
    ),
    mark: (fill: black, scale: 0.65, transform-shape: false),
  )
  let vertex = (13, 22)
  let cone-angle = 42deg
  let boundary-ends = (2, 40).map(height => (
    vertex.first() + calc.abs(height - vertex.at(1)) / calc.tan(cone-angle),
    height,
  ))
  let query-point = (34, 30)
  let projection = (query-point.first(), vertex.at(1))
  let point-angle = calc.atan2(
    query-point.first() - vertex.first(),
    query-point.at(1) - vertex.at(1),
  )
  assert(0deg < point-angle and point-angle < cone-angle)
  assert(query-point.first() > vertex.first())
  line((-4, 0), (43, 0))
  line((0, -5), (0, 44))
  line((38, 0), (41, 0), mark: (end: "stealth"))
  line((0, 39), (0, 42), mark: (end: "stealth"))
  line((vertex.first(), -5), (vertex.first(), 44))
  for p in boundary-ends { line(vertex, p, stroke: 0.85pt) }
  line(vertex, (38, vertex.at(1)), stroke: (dash: "dashed"))
  line(vertex, query-point, stroke: (dash: "dashed"))
  line(query-point, projection, stroke: (dash: "dashed"))
  arc(
    vertex,
    start: 0deg,
    stop: cone-angle,
    radius: 10,
    anchor: "origin",
    mark: (start: "stealth", end: "stealth"),
  )
  for p in (vertex, query-point) { circle(p, radius: 0.38, fill: white) }
  content((0, 0), $O$, anchor: "north-east")
  content((43, 0), $x$, anchor: "north")
  content((0, 44), $y$, anchor: "east")
  content(vertex, $z_0$, anchor: "east")
  content(query-point, $z$, anchor: "west")
  content(
    (0.5 * (vertex.first() + query-point.first()), vertex.at(1)),
    $x-x_0$,
    anchor: "north",
  )
  content(add-points(vertex, polar-point(12, 0.77 * cone-angle)), $theta$)
  content((31, 12), $g_theta$)
})
