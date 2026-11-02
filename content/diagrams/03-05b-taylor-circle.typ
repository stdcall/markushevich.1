#import "@preview/cetz:0.5.2"

#let taylor-circle() = cetz.canvas(length: 1mm, {
  import cetz.draw: *
  set-style(
    stroke: 0.5pt,
    content: (
      padding: 1,
      wrap: text.with(top-edge: "bounds", bottom-edge: "bounds"),
    ),
    mark: (scale: 0.75, transform-shape: false),
  )
  let polar(radius, angle) = (
    radius * calc.cos(angle),
    radius * calc.sin(angle),
  )
  let norm(point) = calc.sqrt(point.map(x => x * x).sum())
  let rotation = -15deg
  let center = (5, -3)
  let axes = (36, 24)
  let boundary(t) = {
    let x = axes.at(0) * calc.cos(t)
    let y = axes.at(1) * calc.sin(t)
    (
      center.at(0) + x * calc.cos(rotation) - y * calc.sin(rotation),
      center.at(1) + x * calc.sin(rotation) + y * calc.cos(rotation),
    )
  }
  let steps = 720
  let candidates = range(steps).map(j => j * 360deg / steps)
  let nearest = candidates.sorted(key: t => norm(boundary(t))).first()
  let low = nearest - 360deg / steps
  let high = nearest + 360deg / steps
  for _ in range(45) {
    let left = low + (high - low) / 3
    let right = high - (high - low) / 3
    if norm(boundary(left)) < norm(boundary(right)) { high = right } else {
      low = left
    }
  }
  let distance = norm(boundary((low + high) / 2))
  let radius = 0.75 * distance
  assert(candidates.all(t => norm(boundary(t)) >= distance - 0.00001))
  assert(radius < distance)
  line(
    ..range(steps + 1).map(j => boundary(j * 360deg / steps)),
    close: true,
    stroke: 0.8pt,
  )
  circle((0, 0), radius: distance, stroke: (dash: "dashed"))
  circle((0, 0), radius: radius, stroke: 0.8pt)
  for (length, angle, label) in (
    (radius, 110deg, $rho$),
    (distance, 23deg, $Delta$),
  ) {
    line(polar(length * 0.36, angle), (0, 0), mark: (end: "straight"))
    line(polar(length * 0.64, angle), polar(length, angle), mark: (
      end: "straight",
    ))
    content(polar(length * 0.5, angle), label)
  }
  content((0, 0), $z_0$, anchor: "north")
  content(polar(radius * 0.65, 220deg), $z$)
  content(polar(radius * 0.8, 150deg), $gamma$)
  content(boundary(145deg).map(x => 0.9 * x), $G$)
})
