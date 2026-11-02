#import "@preview/cetz:0.5.2"

#let local-argument-branch() = cetz.canvas(length: 1mm, {
  import cetz.draw: *
  set-style(
    stroke: 0.5pt,
    mark: (fill: black),
    content: (
      padding: 1,
      wrap: text.with(top-edge: "bounds", bottom-edge: "bounds"),
    ),
    angle: (mark: (end: ">", scale: 0.6)),
  )
  let origin = (0, 0)
  let center = (43, 21)
  let radius = 12
  let other = (center.at(0) - radius * 0.3, center.at(1) + radius * 0.45)
  let norm(p) = calc.sqrt(p.at(0) * p.at(0) + p.at(1) * p.at(1))
  assert(radius < norm(center))
  assert(
    norm((other.at(0) - center.at(0), other.at(1) - center.at(1))) < radius,
  )
  let axis = (center.at(0) + radius, 0)
  line(origin, axis, stroke: (dash: "dashed"))
  circle(center, radius: radius)
  for (point, label, argument-label, angle-radius) in (
    (center, $z$, $Phi$, 14),
    (other, $z_1$, $Phi_1$, 8),
  ) {
    line(origin, point)
    circle(origin, radius: angle-radius, stroke: (dash: "dashed"))
    cetz.angle.angle(origin, axis, point, radius: angle-radius)
    circle(point, radius: 0.5, fill: white)
    content(point, label, anchor: "west")
    content((0, -angle-radius), argument-label, anchor: "north")
  }
  content(origin, $O$, anchor: "east")
})
