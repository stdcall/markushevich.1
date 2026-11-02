#import "@preview/cetz:0.5.2"
#import "01-03a-sequences.typ": hatched-polygon

#let circle-orientation() = cetz.canvas(length: 1mm, {
  import cetz.draw: *
  set-style(
    stroke: 0.5pt,
    content: (
      padding: 1,
      wrap: text.with(top-edge: "bounds", bottom-edge: "bounds"),
    ),
    mark: (fill: black, scale: 0.65, transform-shape: false),
    angle: (radius: 4, mark: (end: ">")),
  )
  let plus(a, b) = a.zip(b).map(((x, y)) => x + y)
  let times(a, factor) = a.map(x => x * factor)
  let polar(radius, angle) = (
    radius * calc.cos(angle),
    radius * calc.sin(angle),
  )
  let multiply(a, b) = (
    a.at(0) * b.at(0) - a.at(1) * b.at(1),
    a.at(0) * b.at(1) + a.at(1) * b.at(0),
  )
  let divide(a, b) = {
    let denominator = b.at(0) * b.at(0) + b.at(1) * b.at(1)
    times(multiply(a, (b.at(0), -b.at(1))), 1 / denominator)
  }
  let radius = 18
  let pole-angle = 247.5deg
  let direction = polar(1, 240deg)
  let normal = multiply(direction, (0, 1))
  let z-angles = (-90deg, 180deg, 225deg)
  let z-points = z-angles.map(angle => polar(radius, angle))
  let cayley(z) = {
    let rotated = multiply(times(z, 1 / radius), polar(1, -pole-angle))
    multiply((0, 1), divide(plus((1, 0), rotated), plus((1, 0), times(
      rotated,
      -1,
    ))))
  }
  let center-image = cayley(z-points.at(1))
  let right = (40, 0)
  let image(z) = plus(right, times(
    multiply(direction, plus(cayley(z), times(center-image, -1))),
    4,
  ))
  let w-points = z-points.map(image)

  // The hatching leaves the centre clear, as in the printed drawing.
  // Every chord endpoint is calculated from the two concentric radii.
  let inner = radius * 0.48
  let hatch-direction = polar(1, -45deg)
  let hatch-normal = multiply(hatch-direction, (0, 1))
  for k in range(-12, 13) {
    let offset = k * 1.45
    if calc.abs(offset) < radius {
      let half = calc.sqrt(radius * radius - offset * offset)
      let base = times(hatch-normal, offset)
      if calc.abs(offset) < inner {
        let gap = calc.sqrt(inner * inner - offset * offset)
        for (a, b) in ((-half, -gap), (gap, half)) {
          line(
            plus(base, times(hatch-direction, a)),
            plus(base, times(hatch-direction, b)),
            stroke: 0.2pt,
          )
        }
      } else {
        line(
          plus(base, times(hatch-direction, -half)),
          plus(base, times(hatch-direction, half)),
          stroke: 0.2pt,
        )
      }
    }
  }
  circle((0, 0), radius: radius, name: "gamma")
  circle((0, 0), radius: 0.45, fill: white)
  content((name: "gamma", anchor: 90deg), $gamma$, anchor: "south")
  content((5, 3), $g$)

  let width = 13
  let lower = plus(w-points.last(), times(direction, 4))
  let upper = plus(w-points.first(), times(direction, -4))
  hatched-polygon((
    lower,
    upper,
    plus(upper, times(normal, width)),
    plus(lower, times(normal, width)),
  ))
  line(lower, upper, name: "Gamma")
  content(upper, $Gamma$, anchor: "south-east")
  content(plus(right, times(normal, 18)), $G$)

  for (index, z) in z-points.enumerate() {
    let w = w-points.at(index)
    let relative = plus(w, times(right, -1))
    assert(
      calc.abs(relative.at(0) * normal.at(0) + relative.at(1) * normal.at(1))
        < 0.00001,
    )
    circle(z, radius: 0.5, fill: white)
    circle(w, radius: 0.5, fill: white)
    content(z, $z_#(index + 1)$, anchor: if index == 0 { "north" } else {
      "east"
    })
    content(w, $w_#(index + 1)$, anchor: if index == 1 { "south-west" } else {
      "north-west"
    })
  }
  let start = z-points.at(1)
  let end = plus(start, (radius * 0.5, 0))
  line(start, end, mark: (end: ">"), name: "delta")
  content("delta.mid", $delta$, anchor: "south")
  cetz.angle.angle(start, plus(start, (0, -8)), end)

  let mid = plus(start, (radius * 0.25, 0))
  arc-through(
    image(start),
    image(mid),
    image(end),
    mark: (end: ">"),
    name: "Delta",
  )
  content("Delta.end", $Delta$, anchor: "west")
  cetz.angle.angle(right, plus(right, times(direction, 8)), plus(right, times(
    normal,
    8,
  )))
  let inward = plus(image(end), times(right, -1))
  assert(inward.at(0) * normal.at(0) + inward.at(1) * normal.at(1) > 0)
})
