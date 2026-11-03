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
#let axes(
  origin,
  left,
  right,
  bottom,
  top,
  horizontal,
  vertical,
  plane,
  origin-offset: (0, 0),
) = {
  import cetz.draw: *
  line(add(origin, (left, 0)), add(origin, (right, 0)), mark: (end: "stealth"))
  line(add(origin, (0, bottom)), add(origin, (0, top)), mark: (end: "stealth"))
  content(add(origin, (right, 0)), horizontal, anchor: "north")
  content(add(origin, (0, top)), vertical, anchor: "east")
  content(add(origin, origin-offset), $O$, anchor: "north-east")
  content(add(origin, (right * 0.75, top)), plane, anchor: "south")
}

#let sine-relief() = cetz.canvas(length: 0.88mm, z: (0.8, 0.8), {
  import cetz.draw: *
  set-style(..drawing-style)
  set-style(content: (padding: 0.25))
  // The plotting window removes x < pi, y > 0 from the full rectangle.
  let start = -calc.pi / 2
  let corner = calc.pi
  let stop = 3 * calc.pi / 2
  let cap = 3
  let breadth = 2.4
  let surface(x, y) = calc.sqrt(
    calc.sin(x * 1rad) * calc.sin(x * 1rad) + sinh(y) * sinh(y),
  )
  let depth(x, height) = calc.ln(
    calc.sqrt(height * height - calc.sin(x * 1rad) * calc.sin(x * 1rad))
      + calc.sqrt(
        height * height - calc.sin(x * 1rad) * calc.sin(x * 1rad) + 1,
      ),
  )
  let point(x, y, u) = (13 * y, 8 * u, 12 * x)
  let height(x, y) = calc.min(surface(x, y), cap)
  let profile(x, y) = point(x, y, height(x, y))
  let cross-section(x, low, high) = samples(y => profile(x, y), low, high)
  let wall(x, low, high) = {
    line(
      point(x, low, 0),
      ..cross-section(x, low, high),
      point(x, high, 0),
      close: true,
      fill: white,
    )
    for i in range(81) {
      let y = low + (high - low) * i / 80
      line(point(x, y, 0), profile(x, y), stroke: 0.2pt)
    }
  }
  let roof(first, last, low, high, count) = {
    if high == 0 {
      let rim = (
        cross-section(first, low, high)
          + samples(x => profile(x, high), first, last).slice(1)
          + cross-section(last, low, high).rev().slice(1)
          + samples(x => profile(x, low), last, first).slice(1)
      )
      line(..rim, close: true, fill: white, stroke: none)
      for level in (1, 2, 3) {
        line(..samples(
          x => point(x, -depth(x, level), level),
          first,
          last,
          steps: 240,
        ))
      }
      for y in range(-3, 1).map(j => breadth * j / 3) {
        line(
          ..samples(x => profile(x, y), first, last, steps: 240),
          stroke: 0.35pt,
        )
      }
      for i in range(0, count + 1, step: 4) {
        line(..cross-section(first + (last - first) * i / count, low, high))
      }
    } else {
      for i in range(count).rev() {
        let a = first + (last - first) * i / count
        let b = first + (last - first) * (i + 1) / count
        line(
          ..cross-section(a, low, high),
          ..cross-section(b, low, high).rev(),
          close: true,
          fill: white,
          stroke: none,
        )
        let end = calc.min(last, b + (b - a) / 12)
        for level in (1, 2, 3) {
          for sign in (-1, 1) {
            if (sign < 0 and low < 0) or (sign > 0 and high > 0) {
              line(..samples(
                x => point(x, sign * depth(x, level), level),
                a,
                end,
              ))
            }
          }
        }
        for y in range(-3, 4).map(j => breadth * j / 3) {
          if low < y and y < high {
            line(..samples(x => profile(x, y), a, end), stroke: 0.35pt)
          }
        }
        if calc.rem(i + 1, 4) == 0 { line(..cross-section(b, low, high)) }
        line(profile(a, low), profile(b, low))
        line(profile(a, high), profile(b, high))
      }
    }
  }
  wall(stop, -breadth, breadth)
  roof(corner, stop, -breadth, breadth, 12)
  wall(corner, 0, breadth)
  roof(start, corner, -breadth, 0, 36)
  wall(start, -breadth, 0)
  let front = (
    samples(x => profile(x, 0), start, 0, steps: 40)
      + samples(x => profile(x, 0), 0, corner, steps: 80).slice(1)
  )
  line(
    point(start, 0, 0),
    ..front,
    point(corner, 0, 0),
    close: true,
    fill: white,
  )
  for x in (
    range(40).map(i => start * (1 - i / 40))
      + range(81).map(i => corner * i / 80)
  ) {
    line(point(x, 0, 0), profile(x, 0), stroke: 0.2pt)
  }
  line(..front)
  line(..cross-section(start, -breadth, 0))
  line(..cross-section(corner, 0, breadth))
  content(
    point(start, -0.8, surface(start, -0.8) - 0.45),
    $op("ch")$,
    anchor: "north",
    frame: "rect",
    fill: white,
    stroke: none,
  )
  content(
    point(calc.pi / 2, 0, 0.45),
    $op("sin")$,
    angle: 45deg,
    frame: "rect",
    fill: white,
    stroke: none,
  )
  content(
    point(corner, 0.9, surface(corner, 0.9) - 0.45),
    $op("sh")$,
    anchor: "north",
    frame: "rect",
    fill: white,
    stroke: none,
  )
  for (x, sign, level, offset) in (
    (calc.pi / 30, -1, 1, (0.5, 1.5)),
    (calc.pi / 5, -1, 2, (0, 1.5)),
    (23 * calc.pi / 20, 1, 1, (-1, 1)),
    (1.26 * calc.pi, 1, 2, (-2, 2)),
  ) {
    content(
      (rel: offset, to: point(x, sign * depth(x, level), level)),
      [#level],
      anchor: "south",
    )
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
  axes(
    (0, 0),
    -extent,
    extent,
    -height * 1.6,
    height * 1.7,
    $x$,
    $y$,
    $(z)$,
    origin-offset: (-2, -2),
  )
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
  line((measure-x, 0), (measure-x, height), mark: (
    start: "stealth",
    end: "stealth",
  ))
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
    add(add(right, times(cosine-image(chosen, 1.5), unit-w)), (-1, 2)),
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
    content(
      add(right, (
        x * unit + (if x < 0 { -1.5 } else { 0 }),
        if x < 0 { -4.5 } else { 0 },
      )),
      [#x],
      anchor: "north",
    )
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
  let unit-z = 3.1
  let unit-w = 15
  let right = (65, 0)
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
  axes((0, 0), -23, 44, -12, 27, $x$, $y$, $(z)$)
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
    line(
      z-chart(-2.3 * calc.pi, side * y0),
      z-chart(4.3 * calc.pi, side * y0),
      stroke: (
        dash: "dashed",
      ),
    )
  }
  line(z-chart(a, y0), z-chart(x2, y0))
  for k in (-2, -1, 1) {
    circle(z-chart(x0 + 2 * calc.pi * k, y0), radius: 0.4, fill: white)
  }
  for k in range(4) {
    circle(
      z-chart(-x0 + 2 * calc.pi * k, -y0),
      radius: 0.4,
      fill: if k in (1, 2) { black } else { white },
    )
  }
  for (x, y, label, offset) in (
    (x0, y0, $z_0$, (2.6, 3.2)),
    (x1, y1, $z_1$, (0, 4.5)),
    (x1, y0, $z_2$, (-4.7, -3.6)),
    (x2, y2, $z'$, (4.8, -1.5)),
    (x2, y0, $z''$, (4.8, 2.4)),
  ) {
    circle(z-chart(x, y), radius: 0.45, fill: white)
    content(add(z-chart(x, y), offset), label)
  }
  content(z-chart(a, top * 0.95), emph[I], anchor: "east")
  content(add(z-chart(x0, 0), (2.6, 1.8)), emph[II])
  content(add(z-chart(b, top), (0, 0.8)), emph[III], anchor: "west")
  content(add(z-chart((a + b) / 2, top), (0, 8)), $g$, anchor: "south")
  line(z-chart(a, top * 0.9), z-chart(a, top * 0.7), mark: (end: "stealth"))
  line(z-chart(a + (b - a) * 0.2, 0), z-chart(a + (b - a) * 0.5, 0), mark: (
    end: "stealth",
  ))
  line(z-chart(b, top * 0.65), z-chart(b, top * 0.85), mark: (end: "stealth"))
  let measure-a = add(z-chart(a, 0), (0, -3))
  let measure-b = add(z-chart(b, 0), (0, -3))
  line(measure-a, measure-b, mark: (start: "stealth", end: "stealth"))
  content((measure-a, 50%, measure-b), $h$, anchor: "north")

  for x in (a, b) {
    line(..samples(y => w-chart(x, y), 0, top), stroke: 0.7pt)
  }
  line(..samples(x => w-chart(x, 0), a, b), stroke: 0.7pt)
  line(..samples(x => w-chart(x, y0), a, b))
  line(..samples(y => w-chart(x1, y), y0, y1))
  line(..samples(y => w-chart(x2, y), y2, y0))
  line(..samples(y => w-chart(a, y), 1.3, 1.05, steps: 12), mark: (
    end: "stealth",
  ))
  line(..samples(y => w-chart(b, y), 1.05, 1.3, steps: 12), mark: (
    end: "stealth",
  ))
  line(
    add(w-chart(a + 0.15, 0), (0, 1)),
    add(w-chart(a + 0.45, 0), (0, 1)),
    mark: (end: "stealth"),
  )
  line(
    add(w-chart(2 * calc.pi + 0.65, 0), (0, -1.5)),
    add(w-chart(2 * calc.pi + 0.95, 0), (0, -1.5)),
    mark: (end: "stealth"),
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
    if x == -1 { circle(add(right, (unit-w * x, 0)), radius: 0.4, fill: white) }
    content(add(right, (unit-w * x, 0)), [#x], anchor: if x < 0 {
      "south"
    } else { "north" })
  }
  let alpha-coordinate = z-chart(a, y0)
  let beta-coordinate = w-chart(a, y0)
  content(add(alpha-coordinate, (-3, 3)), $alpha$)
  circle(beta-coordinate, radius: 0.45, fill: white)
  content(beta-coordinate, $beta$, anchor: "south-west")
  cetz.angle.angle(
    alpha-coordinate,
    z-chart(a, y0 - 0.2),
    z-chart(a + 0.2, y0),
    label: none,
    radius: 3,
    mark: (end: "stealth"),
  )
  let normal = (-calc.sin(a * 1rad) * cosh(y0), -calc.cos(a * 1rad) * sinh(y0))
  let tangent = (normal.at(1), -normal.at(0))
  cetz.angle.angle(
    beta-coordinate,
    add(beta-coordinate, tangent),
    add(beta-coordinate, normal),
    label: none,
    radius: 3,
    mark: (end: "stealth"),
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
