#import "@preview/cetz:0.5.2"

#let drawing-style = (
  stroke: 0.5pt,
  content: (
    padding: 1,
    wrap: text.with(top-edge: "bounds", bottom-edge: "bounds"),
  ),
  mark: (scale: 0.6, transform-shape: false, fill: black),
)
#let sinh(x) = (calc.exp(x) - calc.exp(-x)) / 2
#let cosh(x) = (calc.exp(x) + calc.exp(-x)) / 2
#let cosine-image(x, y) = (
  calc.cos(x * 1rad) * cosh(y),
  -calc.sin(x * 1rad) * sinh(y),
)
#let add(a, b) = a.zip(b).map(((x, y)) => x + y)
#let times(p, factor) = p.map(x => x * factor)
#let samples(f, a, b, steps: 80) = range(steps + 1).map(n => f(
  a + (b - a) * n / steps,
))
#let axes(origin, left, right, bottom, top, horizontal, vertical, plane) = {
  import cetz.draw: *
  line(add(origin, (left, 0)), add(origin, (right, 0)), mark: (end: ">"))
  line(add(origin, (0, bottom)), add(origin, (0, top)), mark: (end: ">"))
  content(add(origin, (right, 0)), horizontal, anchor: "north")
  content(add(origin, (0, top)), vertical, anchor: "east")
  content(origin, $O$, anchor: "north-east")
  content(add(origin, (right * 0.75, top)), plane, anchor: "south")
}

#let sine-relief() = cetz.canvas(length: 1mm, z: (0.8, 0.8), {
  import cetz.draw: *
  set-style(..drawing-style)
  set-style(content: (frame: "rect", fill: white, stroke: none, padding: 0.25))
  let start = -calc.pi / 2
  let stop = calc.pi
  let cap = 3
  let surface(x, y) = calc.sqrt(
    calc.sin(x * 1rad) * calc.sin(x * 1rad) + sinh(y) * sinh(y),
  )
  let depth(x, height) = calc.ln(
    calc.sqrt(height * height - calc.sin(x * 1rad) * calc.sin(x * 1rad))
      + calc.sqrt(
        height * height - calc.sin(x * 1rad) * calc.sin(x * 1rad) + 1,
      ),
  )
  let breadth = 2.4
  let point(x, y, u) = (-13 * y, 8 * u + 4 * y, 12 * x)
  let draw-height(x, y) = calc.min(surface(x, y), cap)
  let profile(x, y) = point(x, y, draw-height(x, y))
  assert(calc.abs(surface(0, 0)) < 0.000001)
  assert(calc.abs(surface(calc.pi / 2, 0) - 1) < 0.000001)
  let cross-section(x) = samples(y => profile(x, y), -breadth, breadth)
  let wall(x) = {
    line(
      point(x, -breadth, 0),
      ..cross-section(x),
      point(x, breadth, 0),
      close: true,
      fill: white,
    )
    for i in range(81) {
      let y = -breadth + 2 * breadth * i / 80
      if x == start or y <= 0 {
        line(point(x, y, 0), profile(x, y), stroke: 0.2pt)
      }
    }
  }
  wall(stop)
  for i in range(32).rev() {
    let a = start + (stop - start) * i / 32
    let b = start + (stop - start) * (i + 1) / 32
    line(
      ..cross-section(a),
      ..cross-section(b).rev(),
      close: true,
      fill: white,
      stroke: 0.2pt + white,
    )
    for height in (1, 2, 3) {
      for side in (-1, 1) {
        line(..samples(x => point(x, side * depth(x, height), height), a, b))
      }
    }
    if calc.rem(i, 2) == 0 {
      line(..cross-section(a))
    }
    line(profile(a, -breadth), profile(b, -breadth))
    line(profile(a, breadth), profile(b, breadth))
  }
  wall(start)
  line(..cross-section(start))
  line(..cross-section(stop))
  line(..samples(x => profile(x, 0), start, stop))
  content(profile(start, -0.7), $op("ch")$, anchor: "north-west")
  content(profile(calc.pi / 3, 0), $op("sin")$, anchor: "south")
  content(profile(stop, -0.8), $op("sh")$, anchor: "north-west")
  for x in (0, calc.pi * 0.85) {
    for height in (1, 2) {
      content(point(x, depth(x, height), height), [#height], anchor: "south")
    }
  }
})

#let cosine-preimages() = cetz.canvas(length: 1mm, {
  import cetz.draw: *
  set-style(..drawing-style)
  let phase = calc.pi / 3
  let log-modulus = -calc.pi
  let unit = 2.6
  let height = -log-modulus * unit
  let extent = 2.4 * 2 * calc.pi * unit
  axes((0, 0), -extent, extent, -height * 1.6, height * 1.7, $x$, $y$, $(z)$)
  for side in (-1, 1) {
    line(
      (-extent * 0.9, side * height),
      (extent * 0.9, side * height),
      stroke: 0.7pt,
    )
  }
  for k in range(-2, 3) {
    let point = ((phase + 2 * calc.pi * k) * unit, height)
    line((0, 0), point, stroke: (dash: "dashed"))
    circle(point, radius: 0.45, fill: white)
    content(point, $z'_(#k)$, anchor: "south")
  }
  for k in range(-2, 2) {
    let point = (-(phase + 2 * calc.pi * k) * unit, -height)
    line((0, 0), point, stroke: (dash: "dashed"))
    circle(point, radius: 0.45, fill: white)
    content(point, $z''_(#k)$, anchor: "north")
  }
  let measure-x = extent * 0.8
  line((measure-x, 0), (measure-x, height), mark: (start: ">", end: ">"))
  content((measure-x, height / 2), $-ln abs(tau)$, anchor: "west")
})

#let cosine-vertical-lines() = cetz.canvas(length: 1mm, {
  import cetz.draw: *
  set-style(..drawing-style)
  let unit-z = 5
  let unit-w = 10
  let right = (72, 0)
  let chosen = 7 * calc.pi / 4
  axes((0, 0), -18, 41, -22, 24, $x$, $y$, $(z)$)
  axes(right, -25, 25, -22, 24, $u$, $v$, $(w)$)
  let values = (
    (calc.pi, [I], "south"),
    (3 * calc.pi / 2, [II], "south-east"),
    (chosen, [III], "south-west"),
  )
  for (x, label, anchor) in values {
    line((x * unit-z, -17), (x * unit-z, 19), stroke: 0.7pt)
    content((x * unit-z, 19), emph(label), anchor: anchor)
  }
  for (x, label) in (
    (-calc.pi, $-pi$),
    (0, none),
    (calc.pi / 2, $pi/2$),
    (calc.pi, $pi$),
    (3 * calc.pi / 2, $(3pi)/2$),
    (2 * calc.pi, $2pi$),
  ) {
    circle((x * unit-z, 0), radius: 0.4, fill: white)
    if label != none {
      content((x * unit-z, 0), label, anchor: if x == calc.pi
        or x == 3 * calc.pi / 2 { "north-east" } else if x == 2 * calc.pi {
        "north-west"
      } else { "north" })
    }
  }
  line(add(right, (-24, 0)), add(right, (-unit-w, 0)), stroke: 0.7pt)
  line(add(right, (0, -22)), add(right, (0, 22)), stroke: 0.7pt)
  line(
    ..samples(
      t => add(right, times(cosine-image(chosen, t), unit-w)),
      -1.8,
      1.8,
    ),
    stroke: 0.7pt,
  )
  line(
    ..samples(
      t => {
        let p = cosine-image(chosen, t)
        add(right, times((-p.at(0), p.at(1)), unit-w))
      },
      -1.8,
      1.8,
    ),
    stroke: 0.7pt,
  )
  circle(add(right, (-unit-w, 0)), radius: 0.4, fill: white)
  content(add(right, (-unit-w, 0)), $-1$, anchor: "north-east")
  content(add(right, (-19, 0)), emph[I], anchor: "south")
  content(add(right, (0, 17)), emph[II], anchor: "west")
  content(
    add(right, times(cosine-image(chosen, 1.5), unit-w)),
    emph[III],
    anchor: "east",
  )
})

#let cosine-horizontal-lines() = cetz.canvas(length: 1mm, {
  import cetz.draw: *
  set-style(..drawing-style)
  let right = (60, 0)
  let height = 0.6
  let unit = 13
  axes((0, 0), -15, 32, -11, 24, $x$, $y$, $(z)$)
  axes(right, -23, 25, -11, 24, $u$, $v$, $(w)$)
  line((-15, height * unit), (29, height * unit), stroke: 0.7pt)
  content((23, height * unit), emph[II], anchor: "south")
  content((23, 0), emph[I], anchor: "south")
  circle(
    right,
    radius: (unit * cosh(height), unit * sinh(height)),
    stroke: 0.7pt,
  )
  line(add(right, (-unit, 0)), add(right, (unit, 0)), stroke: 0.7pt)
  for x in (-1, 1) {
    line(add(right, (x * unit, -0.6)), add(right, (x * unit, 0.6)))
    content(add(right, (x * unit, 0)), [#x], anchor: "north")
  }
  content(add(right, (2, 0)), emph[I], anchor: "south-west")
  content(
    add(right, (unit * cosh(height) * 0.6, unit * sinh(height) * 0.8)),
    emph[II],
    anchor: "south",
  )
})

#let cosine-halfstrip-fold() = cetz.canvas(length: 1mm, {
  import cetz.draw: *
  set-style(..drawing-style)
  let a = 1.55 * calc.pi
  let b = 2.45 * calc.pi
  let top = 1.4
  let unit-z = 7.5
  let unit-w = 15
  let right = (85, 0)
  let z-chart(x, y) = (unit-z * x, 12 * y)
  let w-chart(x, y) = add(right, times(cosine-image(x, y), unit-w))
  let x0 = 1.92 * calc.pi
  let x1 = 1.72 * calc.pi
  let x2 = 2.28 * calc.pi
  let y0 = 0.8
  let y1 = 1.3
  let y2 = 0.5
  assert(b - a < 2 * calc.pi)
  assert(a < x1 and x1 < x0 and x0 < x2 and x2 < b)
  axes((0, 0), -2, 61, -12, 27, $x$, $y$, $(z)$)
  axes(right, -18, 28, -24, 30, $u$, $v$, $(w)$)
  line(
    z-chart(a, top),
    z-chart(a, 0),
    z-chart(b, 0),
    z-chart(b, top),
    stroke: 0.7pt,
  )
  line(z-chart(x1, y0), z-chart(x1, y1))
  line(z-chart(x2, y2), z-chart(x2, y0))
  line(z-chart(x0, 0), z-chart(x0, top))
  for side in (-1, 1) {
    line(z-chart(-0.5, side * y0), z-chart(b + 0.7, side * y0), stroke: (
      dash: "dashed",
    ))
  }
  line(z-chart(a, y0), z-chart(x2, y0))
  for x in (x0 - 2 * calc.pi, x0, x2 - 2 * calc.pi, x2) {
    circle(z-chart(x, y0), radius: 0.4, fill: white)
    let reflected = -x + 2 * calc.pi
    if reflected >= -0.5 and reflected <= b + 0.7 {
      circle(
        z-chart(reflected, -y0),
        radius: 0.4,
        fill: if x in (x0 - 2 * calc.pi, x0) { black } else { white },
      )
    }
  }
  for (x, y, label, anchor) in (
    (x0, y0, $z_0$, "south-east"),
    (x1, y1, $z_1$, "west"),
    (x1, y0, $z_2$, "north-west"),
    (x2, y2, $z'$, "north-east"),
    (x2, y0, $z''$, "south-east"),
  ) {
    circle(z-chart(x, y), radius: 0.45, fill: white)
    content(z-chart(x, y), label, anchor: anchor)
  }
  content(z-chart(a, top * 0.95), emph[I], anchor: "east")
  content(z-chart((a + b) / 2, 0), emph[II], anchor: "south")
  content(z-chart(b, top * 0.65), emph[III], anchor: "west")
  content(z-chart((a + b) / 2, top), $g$, anchor: "south")
  line(z-chart(a, top * 0.9), z-chart(a, top * 0.7), mark: (end: ">"))
  line(z-chart(a + (b - a) * 0.2, 0), z-chart(a + (b - a) * 0.5, 0), mark: (
    end: ">",
  ))
  line(z-chart(b, top * 0.65), z-chart(b, top * 0.85), mark: (end: ">"))
  let measure-a = add(z-chart(a, 0), (0, -3))
  let measure-b = add(z-chart(b, 0), (0, -3))
  line(measure-a, measure-b, mark: (start: ">", end: ">"))
  content((measure-a, 50%, measure-b), $h$, anchor: "north")

  for x in (a, b) {
    line(..samples(y => w-chart(x, y), 0, top), stroke: 0.7pt)
  }
  line(..samples(x => w-chart(x, 0), a, b), stroke: 0.7pt)
  line(..samples(x => w-chart(x, y0), a, b))
  line(..samples(y => w-chart(x1, y), y0, y1))
  line(..samples(y => w-chart(x2, y), y2, y0))
  line(..samples(y => w-chart(a, y), 1.3, 1.05, steps: 12), mark: (end: ">"))
  line(..samples(y => w-chart(b, y), 1.05, 1.3, steps: 12), mark: (end: ">"))
  line(
    add(w-chart(a + 0.15, 0), (0, 1)),
    add(w-chart(a + 0.45, 0), (0, 1)),
    mark: (end: ">"),
  )
  line(
    add(w-chart(2 * calc.pi + 0.65, 0), (0, -1.5)),
    add(w-chart(2 * calc.pi + 0.95, 0), (0, -1.5)),
    mark: (end: ">"),
  )
  content(w-chart(a, top), emph[I′], anchor: "south")
  content(w-chart(b, top), emph[III′], anchor: "north-east")
  content(w-chart((a + 2 * calc.pi) / 2, 0), emph[II′], anchor: "south")
  content(w-chart(x1 + 0.12, 1.45), $d$, anchor: "south-west")
  for (x, y, label, anchor) in (
    (x0, y0, $w_0$, "south-west"),
    (x1, y1, $w_1$, "west"),
    (x1, y0, $w_2$, "north-east"),
    (x2, y2, $w'$, "north-east"),
    (x2, y0, $w''$, "north-west"),
  ) {
    circle(w-chart(x, y), radius: 0.45, fill: white)
    content(w-chart(x, y), label, anchor: anchor)
  }
  for x in (-1, 1) {
    circle(add(right, (unit-w * x, 0)), radius: 0.4, fill: white)
    content(add(right, (unit-w * x, 0)), [#x], anchor: if x < 0 {
      "south"
    } else { "north" })
  }
  let alpha-coordinate = z-chart(a, y0)
  let beta-coordinate = w-chart(a, y0)
  content(alpha-coordinate, $alpha$, anchor: "south-east")
  content(beta-coordinate, $beta$, anchor: "south-west")
  cetz.angle.angle(
    alpha-coordinate,
    z-chart(a, y0 - 0.2),
    z-chart(a + 0.2, y0),
    label: none,
    radius: 3,
    mark: (end: ">"),
  )
  let normal = (-calc.sin(a * 1rad) * cosh(y0), -calc.cos(a * 1rad) * sinh(y0))
  let tangent = (normal.at(1), -normal.at(0))
  cetz.angle.angle(
    beta-coordinate,
    add(beta-coordinate, tangent),
    add(beta-coordinate, normal),
    label: none,
    radius: 3,
    mark: (end: ">"),
  )
})

#let cosine-halfstrip-grid() = cetz.canvas(length: 1mm, {
  import cetz.draw: *
  set-style(..drawing-style)
  let a = 1.3 * calc.pi
  let b = 1.85 * calc.pi
  let top = 1.7
  let unit-z = 7.2
  let unit-w = 8
  let right = (80, 0)
  let z-chart(x, y) = (x * unit-z, y * 12)
  let w-chart(x, y) = add(right, times(cosine-image(x, y), unit-w))
  assert(calc.pi < a and a < b and b < 2 * calc.pi)
  axes((0, 0), -5, 48, -6, 26, $x$, $y$, $(z)$)
  axes(right, -23, 25, -6, 26, $u$, $v$, $(w)$)
  for fraction in (0, 0.25, 0.5, 0.75, 1) {
    let x = a + fraction * (b - a)
    let stroke = if fraction in (0, 1) { 0.7pt } else { 0.35pt }
    line(z-chart(x, 0), z-chart(x, top), stroke: stroke)
    line(..samples(y => w-chart(x, y), 0, top), stroke: stroke)
  }
  for y in (0, 0.35, 0.75, 1.15, 1.55) {
    let stroke = if y == 0 { 0.7pt } else { 0.35pt }
    line(z-chart(a, y), z-chart(b, y), stroke: stroke)
    line(..samples(x => w-chart(x, y), a, b), stroke: stroke)
  }
})
