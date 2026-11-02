#import "@preview/cetz:0.5.2"
#import "01-03a-sequences.typ": hatched-polygon

#let logarithm-strips() = cetz.canvas(length: 1mm, {
  import cetz.draw: *
  set-style(
    stroke: 0.45pt,
    content: (
      padding: 0.8,
      wrap: text.with(top-edge: "bounds", bottom-edge: "bounds"),
    ),
    mark: (fill: black, scale: 0.65, transform-shape: false),
  )
  let v0 = 65deg
  let theta0 = 30deg
  let u0 = -1
  let period = 2 * calc.pi
  let step = 9
  let vertical(v) = step * v / period
  let boundary(k) = vertical(v0 / 1rad + k * period)
  let argument0 = theta0 / 1rad + period
  assert(v0 / 1rad < argument0 and argument0 < v0 / 1rad + period)
  let left = -26
  let right = 27
  let low = boundary(-2)
  let high = boundary(3)
  let point-x = 20 * u0

  for k in range(-3, 4) {
    let bottom = calc.max(boundary(k), low - 0.65 * step)
    let top = calc.min(boundary(k + 1), high + 0.65 * step)
    group({
      let flip = if calc.rem(k, 2) == 0 { 1 } else { -1 }
      let phase = if flip == 1 { 0 } else { 2 * boundary(0) }
      scale(y: flip)
      translate((phase, 0))
      hatched-polygon(
        (
          (left - phase, flip * bottom),
          (right - phase, flip * bottom),
          (right - phase, flip * top),
          (left - phase, flip * top),
        ),
        step: 1.5,
      )
    })
    if -2 <= k and k <= 2 {
      content((right, (bottom + top) / 2), $g'_#k$, anchor: "east")
    }
  }
  line((point-x, low - 8), (point-x, high + 7), stroke: (
    dash: "dashed",
    thickness: 0.3pt,
  ))
  for k in range(-2, 4) {
    let y = boundary(k)
    line((left, y), (right, y))
  }
  line((left - 1, 0), (right + 7, 0), name: "u", mark: (end: "stealth"))
  line((0, low - 7), (0, high + 9), name: "v", mark: (end: "stealth"))
  for k in range(-2, 4) {
    let y = boundary(k)
    circle((0, y), radius: 0.4, fill: white)
    let name = if k == 0 { $v_0 i$ } else if k > 0 {
      $(v_0 + #(2 * k) pi) i$
    } else { $(v_0 - #(-2 * k) pi) i$ }
    content((0, y), name, anchor: if k == 0 { "south-west" } else {
      "north-west"
    })
  }
  for k in range(-2, 3) {
    let point-y = vertical(argument0 + k * period)
    assert(boundary(k) < point-y and point-y < boundary(k + 1))
    circle((point-x, point-y), radius: 0.45, fill: white)
    content((point-x, point-y), $w'_#k$, anchor: "north-west")
  }
  content("u.end", $u$, anchor: "north-east")
  content("v.end", $v$, anchor: "east")
  content((0, 0), $O$, anchor: "north-east")

  // The lower picture is the common exponential image of all five strips.
  // Its dashed circle is the image of the vertical line Re w = u0.
  let center = (0, low - 43)
  let radius = 18
  let image-scale = radius / calc.exp(u0)
  let exponential(u, v) = (
    center.at(0) + image-scale * calc.exp(u) * calc.cos(v * 1rad),
    center.at(1) + image-scale * calc.exp(u) * calc.sin(v * 1rad),
  )
  let hatch-radius = radius + 4
  for k in range(-18, 19) {
    let offset = k * 1.4
    if calc.abs(offset) < hatch-radius {
      let half = calc.sqrt(hatch-radius * hatch-radius - offset * offset)
      let factor = 1 / calc.sqrt(2)
      line(
        (
          center.at(0) + (offset - half) * factor,
          center.at(1) - (offset + half) * factor,
        ),
        (
          center.at(0) + (offset + half) * factor,
          center.at(1) - (offset - half) * factor,
        ),
        stroke: 0.2pt,
      )
    }
  }
  circle(center, radius: radius, stroke: (dash: "dashed"))
  line(
    (center.at(0) - 25, center.at(1)),
    (center.at(0) + 28, center.at(1)),
    name: "x",
    mark: (end: "stealth"),
  )
  line(
    (center.at(0), center.at(1) - 24),
    (center.at(0), center.at(1) + 27),
    name: "y",
    mark: (end: "stealth"),
  )
  content("x.end", $x$, anchor: "north-east")
  content("y.end", $y$, anchor: "east")
  content(center, $O$, anchor: "north-east")
  line(
    center,
    (
      center.at(0) + 26 * calc.cos(v0),
      center.at(1) + 26 * calc.sin(v0),
    ),
    name: "cut",
  )
  let image-point = exponential(u0, argument0)
  circle(image-point, radius: 0.45, fill: white)
  content(image-point, $z'_0$, anchor: "west")
  content((center.at(0) + 20, center.at(1) + 19), $G$)
  for k in range(-2, 3) {
    let point = exponential(u0, argument0 + k * period)
    assert(calc.abs(point.at(0) - image-point.at(0)) < 0.00001)
    assert(calc.abs(point.at(1) - image-point.at(1)) < 0.00001)
  }
})
