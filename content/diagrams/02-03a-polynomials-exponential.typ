#import "@preview/cetz:0.5.2"

#let drawing-style = (
  stroke: 0.5pt,
  content: (
    padding: 1.1,
    wrap: text.with(top-edge: "bounds", bottom-edge: "bounds"),
  ),
  mark: (scale: 0.65, transform-shape: false, fill: black),
  angle: (mark: (start: "stealth", end: "stealth"), label-radius: 135%),
)

#let add(a, b) = a.zip(b).map(((x, y)) => x + y)
#let vector-scale(a, factor) = a.map(x => factor * x)
#let polar(radius, angle) = (radius * calc.cos(angle), radius * calc.sin(angle))
#let circle-arc(center, radius, start, end, ..args) = {
  cetz.draw.line(
    ..range(81).map(i => add(center, polar(
      radius,
      start + (end - start) * i / 80,
    ))),
    ..args,
  )
}
#let axes(origin, left: 9, right: 34, below: 9, above: 34) = {
  cetz.draw.line(add(origin, (-left, 0)), add(origin, (right, 0)), mark: (
    end: "stealth",
  ))
  cetz.draw.line(add(origin, (0, -below)), add(origin, (0, above)), mark: (
    end: "stealth",
  ))
}

#let power-sectors() = cetz.canvas(length: 1mm, {
  import cetz.draw: *
  set-style(..drawing-style)
  let exponent = 3
  let vertex = (5, 6)
  let image-origin = (75, 0)
  let first = 20deg
  let last = 40deg
  let radius = 1.45
  let ray-radius = 1.55
  let unit = 27
  let image-unit = 15
  axes((0, 0), right: 43, above: 35)
  let image-top = image-unit * calc.pow(ray-radius, exponent)
  axes(image-origin, left: 30, right: 30, above: image-top + 3)
  content((30, 34), $(z)$)
  content(add(image-origin, (24, 50)), $(w)$)
  content(vertex, $a$, anchor: "north-east")
  for i in range(7) {
    let angle = first + (last - first) * i / 6
    let weight = if i in (0, 6) { 0.85pt } else { 0.5pt }
    line(vertex, add(vertex, polar(unit * ray-radius, angle)), stroke: weight)
    line(
      image-origin,
      add(image-origin, polar(
        image-unit * calc.pow(ray-radius, exponent),
        exponent * angle,
      )),
      stroke: weight,
    )
  }
  for r in (0.45, 0.65, 0.85, 1.05, 1.25, radius) {
    circle-arc(vertex, unit * r, first, last)
    circle-arc(
      image-origin,
      image-unit * calc.pow(r, exponent),
      exponent * first,
      exponent * last,
    )
  }
  content(
    add(vertex, polar(unit * radius + 3, (first + last) / 2)),
    $g$,
    anchor: "west",
  )
  content(
    add(image-origin, polar(
      image-unit * calc.pow(radius, exponent) * 0.77,
      95deg,
    )),
    $d$,
  )
})

#let square-grid() = cetz.canvas(length: 1mm, {
  import cetz.draw: *
  set-style(..drawing-style)
  let left-origin = (0, -12)
  let right-origin = (64, 0)
  let unit = 7
  let image-unit = 1.65
  axes(left-origin, left: 9, right: 29, below: 10, above: 30)
  axes(right-origin, left: 23, right: 25, below: 38, above: 39)
  content(add(left-origin, (25, 29)), $(z)$)
  content(add(right-origin, (22, 34)), $(w)$)
  for c in (1, 2, 3) {
    line(add(left-origin, (unit * c, -7)), add(left-origin, (unit * c, 27)))
    line(add(left-origin, (-7, unit * c)), add(left-origin, (27, unit * c)))
    let bound = calc.min(calc.sqrt(c * c + 11), 22 / (2 * c))
    let samples = range(121).map(i => -bound + 2 * bound * i / 120)
    line(..samples.map(t => add(right-origin, vector-scale(
      (c * c - t * t, 2 * c * t),
      image-unit,
    ))))
    line(..samples.map(t => add(right-origin, vector-scale(
      (t * t - c * c, 2 * c * t),
      image-unit,
    ))))
  }
})

#let exponential-grid() = cetz.canvas(length: 1mm, {
  import cetz.draw: *
  set-style(..drawing-style)
  let unit = 20
  let c = 0.8
  let angle-value = 60deg
  let ordinate = angle-value / 1rad
  let image-origin = (72, 0)
  let image-unit = 9
  let radius = image-unit * calc.exp(c)
  axes((0, 0), left: 12, right: 32, below: 14, above: 32)
  axes(image-origin, left: 29, right: 30, below: 25, above: 34)
  line((unit * c, -13), (unit * c, 32))
  line((-12, unit * ordinate), (29, unit * ordinate))
  line((unit * c + 1.5, -3), (unit * c + 1.5, 4), mark: (end: "stealth"))
  line((3, unit * ordinate + 1.5), (10, unit * ordinate + 1.5), mark: (
    end: "stealth",
  ))
  cetz.decorations.flat-brace(
    (0, -1),
    (unit * c, -1),
    name: "abscissa",
    amplitude: 1.0,
    flip: true,
  )
  content("abscissa.content", $c$, anchor: "north")
  cetz.decorations.flat-brace(
    (-1, 0),
    (-1, unit * ordinate),
    name: "ordinate",
    amplitude: 1.0,
  )
  content("ordinate.content", $c'$, anchor: "east")
  circle(image-origin, radius: radius)
  line(image-origin, add(image-origin, polar(34, angle-value)))
  line(
    add(image-origin, polar(26, angle-value)),
    add(image-origin, polar(32, angle-value)),
    mark: (end: "stealth"),
  )
  circle-arc(image-origin, radius + 1.5, 113deg, 140deg, mark: (end: "stealth"))
  line(
    image-origin,
    add(image-origin, polar(radius, 140deg)),
    name: "radius",
    mark: (end: "stealth"),
  )
  content("radius.mid", $e^c$, anchor: "south")
  cetz.angle.angle(
    image-origin,
    add(image-origin, (10, 0)),
    add(image-origin, polar(10, angle-value)),
    label: $c'$,
    radius: 10,
  )
  content((27, 31), $(z)$)
  content(add(image-origin, (28, 31)), $(w)$)
})

#let exponential-strip() = cetz.canvas(length: 0.8mm, {
  import cetz.draw: *
  set-style(..drawing-style)
  let first = 30deg
  let last = 115deg
  let lower = first / 1rad
  let upper = last / 1rad
  let unit = 16
  let image-origin = (82, 0)
  let image-unit = 14
  axes((0, 0), left: 20, right: 43, below: 6, above: 38)
  axes(image-origin, left: 18, right: 31, below: 7, above: 39)
  for i in range(5) {
    let y = lower + (upper - lower) * i / 4
    line((-19, unit * y), (41, unit * y), stroke: if i in (0, 4) {
      0.85pt
    } else { 0.5pt })
  }
  for i in range(8) {
    let x = 0.36 * (i - 2.6)
    line((unit * x, unit * lower), (unit * x, unit * upper))
  }
  for i in range(7) {
    let angle-value = first + (last - first) * i / 6
    line(image-origin, add(image-origin, polar(33, angle-value)), stroke: if i
      in (0, 6) { 0.85pt } else { 0.5pt })
  }
  for x in (0.1, 0.5, 0.8) {
    circle-arc(image-origin, image-unit * calc.exp(x), first, last)
  }
  line((34, unit * lower), (34, unit * upper), name: "width", mark: (
    start: "stealth",
    end: "stealth",
  ))
  content((rel: (9, 0), to: "width.mid"), $h$, anchor: "west")
  line((30, 0), (30, unit * lower), name: "height", mark: (
    start: "stealth",
    end: "stealth",
  ))
  content("height.mid", $phi_0$, anchor: "west")
  cetz.angle.angle(
    image-origin,
    add(image-origin, (10, 0)),
    add(image-origin, polar(10, first)),
    label: $phi_0$,
    radius: 12,
  )
  cetz.angle.angle(
    image-origin,
    add(image-origin, polar(10, first)),
    add(image-origin, polar(10, last)),
    name: "opening",
    radius: 18,
    label-radius: 100%,
  )
  content(
    add(image-origin, polar(
      image-unit * (calc.exp(0.5) + calc.exp(0.8)) / 2,
      first + (last - first) * 2.5 / 6,
    )),
    $h$,
  )
  content((-20, unit * (lower + upper) / 2), $g$, anchor: "east")
  content(add(image-origin, polar(36, 63deg)), $d$)
  content((37, 38), $(z)$)
  content(add(image-origin, (25, 37)), $(w)$)
})

#let exponential-spiral() = cetz.canvas(length: 0.9mm, {
  import cetz.draw: *
  set-style(..drawing-style)
  let slope = 2
  let intercept = -0.5
  let unit = 12
  let image-origin = (75, 0)
  let image-unit = 8
  let last = 1.4
  let image(t) = add(image-origin, polar(
    image-unit * calc.exp(t),
    (slope * t + intercept) * 1rad,
  ))
  axes((0, 0), left: 16, right: 31, below: 17, above: 39)
  axes(image-origin, left: 28, right: 32, below: 17, above: 40)
  for y in range(1, 6) {
    line((-15, y * 7), (29, y * 7))
  }
  line(
    (-0.45 * unit, (slope * -0.45 + intercept) * unit),
    (1.7 * unit, (slope * 1.7 + intercept) * unit),
    name: "original",
    stroke: 0.85pt,
    mark: (start: "stealth", end: "stealth"),
  )
  let cross-y = 14
  let cross-x = (cross-y / unit - intercept) / slope * unit
  cetz.angle.angle(
    (cross-x, cross-y),
    (cross-x + 10, cross-y),
    (cross-x + 10, cross-y + slope * 10),
    name: "original-angle",
    radius: 6,
  )
  content("original-angle.label", $op("arc tg") a$, anchor: "west")
  let selected-direction = 45deg
  let directions = (15deg, 45deg, 75deg, 105deg, 135deg)
  for direction in directions {
    line(
      add(image-origin, polar(28, direction + 180deg)),
      add(image-origin, polar(28, direction)),
    )
  }
  line(image-origin, add(image-origin, polar(28, 345deg)))
  line(
    ..range(501).map(i => image(-7 + (last + 7) * i / 500)),
    name: "spiral",
    stroke: 0.9pt,
    mark: (end: "stealth"),
  )
  let t = (selected-direction / 1rad - intercept) / slope
  let p = image(t)
  let direction = (slope * t + intercept) * 1rad
  let tangent = add(p, polar(
    13 * calc.sqrt(1 + slope * slope),
    direction + calc.atan(slope),
  ))
  line(p, tangent, mark: (end: "stealth"))
  cetz.angle.angle(
    p,
    add(p, polar(15, direction)),
    tangent,
    name: "image-angle",
    radius: 8,
  )
  content("image-angle.label", $op("arc tg") a$, anchor: "west")
  content(add(image-origin, polar(11, 240deg)), $O$)
  content(add(image-origin, (32, 0)), $u$, anchor: "north")
  content(add(image-origin, (0, 40)), $v$, anchor: "east")
  content((27, 39), $(z)$)
  content(add(image-origin, (24, 39)), $(w)$)
})

#let exponential-power-limit() = cetz.canvas(length: 0.85mm, {
  import cetz.draw: *
  set-style(..drawing-style)
  let exponent = 2
  let opening = 42deg
  let unit = 12.5
  let vertex = (-exponent * unit, 0)
  let image-origin = (58, 0)
  let image-radius = 36
  axes((0, 0), left: exponent * unit + 3, right: 34, below: 5, above: 28)
  axes(image-origin, left: 14, right: 39, below: 5, above: 28)
  for i in range(8) {
    let direction = opening / exponent * i / 7
    let start = if i in (0, 7) { 0 } else { 0.2 }
    line(
      add(vertex, polar(51 * start, direction)),
      add(vertex, polar(51, direction)),
      stroke: if i in (0, 7) { 0.85pt } else { 0.5pt },
    )
  }
  for i in range(9) {
    let direction = opening * i / 8
    let start = if i in (0, 8) { 0 } else { 0.2 }
    line(
      add(image-origin, polar(image-radius * start, direction)),
      add(image-origin, polar(image-radius, direction)),
      stroke: if i in (0, 8) { 0.85pt } else { 0.5pt },
    )
  }
  cetz.angle.angle(
    image-origin,
    add(image-origin, (10, 0)),
    add(image-origin, polar(10, opening)),
    radius: 16,
  )
  content(add(image-origin, polar(image-radius + 4, 27deg)), $h$)
  let height = exponent * unit * calc.tan(opening / exponent)
  cetz.decorations.flat-brace(
    (1, 0),
    (1, height),
    name: "height",
    amplitude: 1.0,
    flip: true,
  )
  content((-21, 17), $n op("tg") h/n$, anchor: "west")
  content((0, height + 2), $B_n$, anchor: "south-west")
  content(vertex, $A_n$, anchor: "south-east")
  content((0, 0), $O$, anchor: "north-east")
  content(image-origin, $O$, anchor: "north-east")
  content((34, 0), $x$, anchor: "north")
  content((0, 28), $y$, anchor: "east")
  content(add(image-origin, (39, 0)), $u$, anchor: "north")
  content(add(image-origin, (0, 28)), $v$, anchor: "east")
  content((24, 29), $(z)$)
  content(add(image-origin, (29, 29)), $(w)$)
})
