#import "@preview/cetz:0.5.2"

#let drawing-style = (
  stroke: 0.5pt,
  content: (
    padding: 1.2,
    wrap: text.with(top-edge: "bounds", bottom-edge: "bounds"),
  ),
  mark: (fill: black, scale: 0.65, transform-shape: false),
  angle: (mark: (start: ">", end: ">"), label-radius: 130%),
)

#let polar(radius, angle) = (radius * calc.cos(angle), radius * calc.sin(angle))
#let add(a, b) = a.zip(b).map(((x, y)) => x + y)
#let mul(a, b) = (
  a.at(0) * b.at(0) - a.at(1) * b.at(1),
  a.at(0) * b.at(1) + a.at(1) * b.at(0),
)
#let vector-scale(a, factor) = a.map(x => factor * x)
#let inverse(a) = {
  let norm-square = a.at(0) * a.at(0) + a.at(1) * a.at(1)
  (a.at(0) / norm-square, -a.at(1) / norm-square)
}

#let isometric-circle() = cetz.canvas(length: 1mm, {
  import cetz.draw: *
  set-style(..drawing-style)
  let center = (0, 0)
  let determinant = 256
  let coefficient = 1
  let radius = calc.sqrt(calc.abs(determinant)) / calc.abs(coefficient)
  let outer = radius * 1.7
  circle(center, radius: radius, name: "isometric")
  circle(center, radius: outer, name: "constant")
  line((-outer - 10, 0), center)
  for (index, angle) in (28deg, 40deg, 56deg).enumerate() {
    line(center, polar(outer * 1.7, angle), name: "ray-" + str(index))
  }
  circle(center, radius: 0.65, fill: white)
  content((name: "isometric", anchor: 125deg), $gamma$, anchor: "north-west")
  content(
    (name: "constant", anchor: 142deg),
    $abs(L'(z)) = "const"$,
    anchor: "south-east",
  )
  content(polar(radius * 0.55, -62deg), $abs(L'(z)) > 1$)
  content(polar(outer + 9, -10deg), $abs(L'(z)) < 1$)
  content(
    (name: "ray-0", anchor: 65%),
    $op("Arg") L'(z) = "const"$,
    angle: 28deg,
    anchor: "south-west",
  )
  line(
    (name: "isometric", anchor: 82deg),
    (rel: (0, 16)),
    name: "leader",
  )
  content("leader.end", emph([Изометрическая\ окружность]), anchor: "south")
})

#let conformality-at-pole() = cetz.canvas(length: 1mm, {
  import cetz.draw: *
  set-style(..drawing-style)
  set-style(angle: (mark: (start: "stealth", end: "stealth")))
  let unit = 12
  let pole-coordinate = (0.7, 0.7)
  let rotation = 110deg
  let directions = (40deg, 85deg)
  let curvature = 0.12
  let endpoint = 1.8
  let right = (62, 0)
  let curve(s, index) = mul(polar(1, directions.at(index)), (
    s,
    if index == 0 { -curvature * s * s } else { curvature * s * s },
  ))
  let z-plane(p) = vector-scale(add(pole-coordinate, p), unit)
  let reciprocal-image(p) = mul(polar(1, -rotation), p)
  let zeta-plane(p) = add(right, vector-scale(reciprocal-image(p), unit))
  let w-plane(p) = add(right, vector-scale(inverse(reciprocal-image(p)), unit))
  let axes(origin) = {
    line(add(origin, (-10, 0)), add(origin, (36, 0)), mark: (end: "stealth"))
    line(add(origin, (0, -16)), add(origin, (0, 36)), mark: (end: "stealth"))
  }
  axes((0, 0))
  axes(right)
  content((0, 34), $(z)$, anchor: "east")
  content(add(right, (7, 30)), $(w)$, anchor: "east")
  content(add(right, (31, -3)), $(zeta)$, anchor: "north")
  let pole = z-plane((0, 0))
  for index in (0, 1) {
    let direction = polar(1, directions.at(index))
    let end = curve(endpoint, index)
    let control = vector-scale(direction, endpoint / 2)
    bezier(
      pole,
      z-plane(end),
      z-plane(control),
      name: "gamma-" + str(index),
      mark: (end: "stealth"),
    )
    bezier(
      right,
      zeta-plane(end),
      zeta-plane(control),
      name: "image-" + str(index),
      mark: (end: "stealth"),
    )
    line(
      pole,
      z-plane(vector-scale(direction, endpoint)),
      name: "tangent-" + str(index),
    )
    line(
      right,
      zeta-plane(vector-scale(direction, endpoint)),
      name: "image-tangent-" + str(index),
    )
    let samples = range(101).map(n => {
      let s = 0.32 + n * (0.65 - 0.32) / 100
      w-plane(curve(s, index))
    })
    line(..samples, name: "unbounded-" + str(index), mark: (end: "stealth"))
    content(
      (name: "gamma-" + str(index), anchor: 75%),
      if index == 0 { $gamma_1$ } else { $gamma_2$ },
      anchor: if index == 0 { "north" } else { "east" },
    )
    content(
      (name: "image-" + str(index), anchor: "end"),
      if index == 0 { $Gamma'_1$ } else { $Gamma'_2$ },
      anchor: if index == 0 { "north" } else { "north-west" },
    )
    content(
      (name: "unbounded-" + str(index), anchor: 50%),
      if index == 0 { $Gamma_1$ } else { $Gamma_2$ },
      anchor: "north-west",
    )
  }
  content(pole, $delta$, anchor: "north")
  cetz.angle.angle(
    pole,
    "tangent-0.end",
    "tangent-1.end",
    label: $theta$,
    radius: 11,
  )
  cetz.angle.angle(
    right,
    "image-tangent-0.end",
    "image-tangent-1.end",
    label: $theta$,
    radius: 14,
  )
})
