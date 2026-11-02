#import "@preview/cetz:0.5.2"

#let circle-domains() = cetz.canvas(length: 1mm, {
  import cetz.draw: *
  set-style(
    stroke: 0.5pt,
    content: (
      padding: 1,
      wrap: text.with(top-edge: "bounds", bottom-edge: "bounds"),
    ),
    mark: (fill: black, scale: 0.65, transform-shape: false),
  )
  let plus(a, b) = a.zip(b).map(((x, y)) => x + y)
  let polar(center, radius, angle) = plus(center, (
    radius * calc.cos(angle),
    radius * calc.sin(angle),
  ))
  let right = (58, 0)
  let axes(origin) = {
    line(plus(origin, (-9, 0)), plus(origin, (35, 0)), mark: (end: ">"))
    line(plus(origin, (0, -8)), plus(origin, (0, 34)), mark: (end: ">"))
  }
  axes((0, 0))
  axes(right)
  content((28, 34), $(z)$, anchor: "south")
  content(plus(right, (18, 34)), $(w)$, anchor: "south")

  let slope = 0.2
  let intercept = 12
  let boundary(x) = (x, intercept + slope * x)
  line(boundary(-6), boundary(32), name: "gamma")
  content(boundary(4), $gamma$, anchor: "north")
  content((7, 28), $g_1$)
  content((18, 5), $g_2$)
  content((0, 25), $z$, anchor: "east")
  content((0, 19), $z'$, anchor: "east")

  // This is the contradictory arc hypothesized in the proof, not the
  // inverse image of an actual Möbius map with the pictured endpoints.
  let arc-center = (11, 10)
  let arc-radius = 12
  let z1 = polar(arc-center, arc-radius, 65deg)
  let z2 = polar(arc-center, arc-radius, -10deg)
  assert(z1.at(1) > boundary(z1.at(0)).at(1))
  assert(z2.at(1) < boundary(z2.at(0)).at(1))
  arc-through(
    z1,
    polar(arc-center, arc-radius, 27.5deg),
    z2,
    stroke: (dash: "dashed"),
    name: "delta",
  )
  for (point, label, side) in (
    (z1, $z_1$, "south"),
    (z2, $z_2$, "north"),
  ) {
    circle(point, radius: 0.5, fill: white)
    content(point, label, anchor: side)
  }
  content("delta.mid", $delta$, anchor: "north-west")

  let center = plus(right, (6, 7))
  let radius = 14
  circle(center, radius: radius, name: "Gamma")
  content((name: "Gamma", anchor: 0deg), $Gamma$, anchor: "west")
  content(plus(center, (0, 3)), $G_1$)
  content(plus(center, (-10, 4)), $w$)
  content(plus(center, (0, -3)), $w'$)
  content(plus(center, (8, -1)), $w_1$)

  let outer = radius * 1.65
  let w1 = polar(center, outer, 150deg)
  let w2 = polar(center, outer, 50deg)
  content(w2, $G_2$, anchor: "north-west")
  assert(outer > radius)
  arc-through(
    w1,
    polar(center, outer, 100deg),
    w2,
    stroke: (dash: "dashed"),
    name: "Delta",
  )
  for (point, label, side) in (
    (w1, $w_1$, "east"),
    (w2, $w_2$, "south-west"),
  ) {
    circle(point, radius: 0.5, fill: white)
    content(point, label, anchor: side)
  }
  content("Delta.mid", $Delta$, anchor: "north")
})
