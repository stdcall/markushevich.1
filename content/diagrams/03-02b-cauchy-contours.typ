#import "@preview/cetz:0.5.2"

#let add(a, b) = a.zip(b).map(((x, y)) => x + y)
#let sub(a, b) = a.zip(b).map(((x, y)) => x - y)
#let mul(a, k) = a.map(x => x * k)
#let polar(r, angle) = (r * calc.cos(angle), r * calc.sin(angle))
#let rotated(p, angle) = (
  p.at(0) * calc.cos(angle) - p.at(1) * calc.sin(angle),
  p.at(0) * calc.sin(angle) + p.at(1) * calc.cos(angle),
)
#let ellipse-point(center, radii, angle) = add(center, (
  radii.at(0) * calc.cos(angle),
  radii.at(1) * calc.sin(angle),
))
#let samples(f, first, last, count: 100) = range(count + 1).map(i => f(
  first + (last - first) * i / count,
))
#let style() = cetz.draw.set-style(
  stroke: 0.45pt,
  content: (
    padding: 1,
    wrap: text.with(top-edge: "bounds", bottom-edge: "bounds"),
  ),
  mark: (fill: black, scale: 0.65, transform-shape: false),
)
#let axes(left, right, below, above) = {
  import cetz.draw: *
  line((-left, 0), (right, 0), mark: (end: "stealth"))
  line((0, -below), (0, above), mark: (end: "stealth"))
  content((right, 0), $x$, anchor: "north")
  content((0, above), $y$, anchor: "east")
}

#let fresnel-sector() = cetz.canvas(length: 1mm, {
  import cetz.draw: *
  style()
  let radius = 25
  let opening = 45deg
  let origin = (0, 0)
  let end = (radius, 0)
  let vertex = polar(radius, opening)
  axes(8, radius + 10, 8, radius + 4)
  line(origin, end, stroke: 0.8pt)
  arc(
    origin,
    start: 0deg,
    delta: opening,
    radius: radius,
    anchor: "origin",
    stroke: 0.8pt,
  )
  line(vertex, origin, stroke: 0.8pt)
  arc(
    origin,
    start: 12deg,
    delta: 20deg,
    radius: radius + 1.5,
    anchor: "origin",
    mark: (end: "stealth"),
  )
  let normal = polar(1.5, opening + 90deg)
  line(add(mul(vertex, 0.82), normal), add(mul(vertex, 0.35), normal), mark: (
    end: "stealth",
  ))
  content(add(mul(vertex, 0.65), mul(normal, 2)), $L$, anchor: "south")
  cetz.angle.angle(
    origin,
    end,
    vertex,
    radius: 7,
    label: $pi/4$,
    label-radius: 150%,
    mark: (start: "stealth", end: "stealth"),
  )
  cetz.decorations.flat-brace(
    (0, -1),
    (radius, -1),
    name: "radius",
    amplitude: 1.2,
    flip: true,
  )
  content("radius.content", $R$, anchor: "north")
  content(origin, $O$, anchor: "north-east")
  content(end, $A$, anchor: "north-west")
  content(vertex, $B$, anchor: "south")
})

#let gaussian-rectangle() = cetz.canvas(length: 1mm, {
  import cetz.draw: *
  style()
  let radius = 23
  let height = 16
  let vertices = (
    (-radius, 0),
    (radius, 0),
    (radius, height),
    (-radius, height),
  )
  axes(radius + 7, radius + 10, 7, height + 10)
  line(..vertices, close: true, stroke: 0.8pt)
  line((-4, 1.7), (4, 1.7), mark: (end: "stealth"))
  line((radius - 1.7, height * 0.25), (radius - 1.7, height * 0.7), mark: (
    end: "stealth",
  ))
  line((4, height - 1.7), (-4, height - 1.7), mark: (end: "stealth"))
  line((-radius + 1.7, height * 0.75), (-radius + 1.7, height * 0.3), mark: (
    end: "stealth",
  ))
  for (p, label, anchor) in vertices.zip(
    ($A(-R)$, $B(+R)$, $C(R + alpha i)$, $D(-R + alpha i)$),
    ("north", "north", "south", "south"),
  ) {
    content(p, label, anchor: anchor)
  }
  content((0, 0), $O$, anchor: "north-east")
  content((radius / 2, height - 2), $L$, anchor: "north")
})

#let indented-semicircle() = cetz.canvas(length: 1mm, {
  import cetz.draw: *
  style()
  let radius = 26
  let inner = 12
  let origin = (0, 0)
  assert(0 < inner and inner < radius)
  axes(radius + 5, radius + 9, 7, radius + 8)
  arc(
    origin,
    start: 0deg,
    delta: 180deg,
    radius: radius,
    anchor: "origin",
    stroke: 0.8pt,
  )
  arc(
    origin,
    start: 0deg,
    delta: 180deg,
    radius: inner,
    anchor: "origin",
    stroke: 0.8pt,
  )
  line((-radius, 0), (-inner, 0), stroke: 0.8pt)
  line((inner, 0), (radius, 0), stroke: 0.8pt)
  arc(
    origin,
    start: 30deg,
    delta: 24deg,
    radius: radius - 1.6,
    anchor: "origin",
    mark: (end: "stealth"),
  )
  arc(
    origin,
    start: 145deg,
    delta: -28deg,
    radius: inner + 1.6,
    anchor: "origin",
    mark: (end: "stealth"),
  )
  for side in (-1, 1) {
    let middle = side * (radius + inner) / 2
    line((middle - 4, 1.4), (middle + 4, 1.4), mark: (end: "stealth"))
  }
  cetz.decorations.flat-brace(
    (0, 1.2),
    (inner, 1.2),
    name: "small",
    amplitude: 1.1,
  )
  content("small.content", $r$, anchor: "south")
  cetz.decorations.flat-brace(
    (0, -1.2),
    (radius, -1.2),
    name: "large",
    amplitude: 1.2,
    flip: true,
  )
  content("large.content", $R$, anchor: "north")
  for (p, label, anchor) in (
    ((inner, 1.5), $A$, "south-west"),
    ((radius, 0), $B$, "south-west"),
    ((0, radius), $C$, "south-west"),
    ((-radius, 0), $D$, "north"),
    ((-inner, 0), $E$, "north"),
    ((0, inner), $F$, "south-west"),
    (origin, $O$, "north-east"),
  ) {
    content(p, label, anchor: anchor)
  }
  circle(origin, radius: 0.45, fill: white)
})

#let ellipse-crossing(radii, offset) = {
  let rx = radii.at(0)
  let ry = radii.at(1)
  let aa = 1 / (rx * rx) + 1 / (ry * ry)
  let bb = 2 * offset / (ry * ry)
  let cc = offset * offset / (ry * ry) - 1
  let disc = bb * bb - 4 * aa * cc
  if disc < 0 { none } else {
    ((-bb - calc.sqrt(disc)) / (2 * aa), (-bb + calc.sqrt(disc)) / (2 * aa))
  }
}
#let ellipse-band(outer, inner, step: 1.2) = {
  import cetz.draw: *
  let bound = calc.sqrt(outer.at(0) * outer.at(0) + outer.at(1) * outer.at(1))
  for i in range(calc.floor(-bound / step), calc.ceil(bound / step) + 1) {
    let offset = i * step
    let wide = ellipse-crossing(outer, offset)
    if wide != none {
      let narrow = ellipse-crossing(inner, offset)
      let intervals = if narrow == none { (wide,) } else {
        ((wide.first(), narrow.first()), (narrow.last(), wide.last()))
      }
      for (a, b) in intervals {
        line((a, a + offset), (b, b + offset), stroke: 0.25pt)
      }
    }
  }
}
#let cancelling-annulus() = cetz.canvas(length: 1mm, {
  import cetz.draw: *
  style()
  let center = (0, 0)
  let boundary = (33, 17)
  let outer = (27, 12)
  let inner = (18, 6.5)
  let hole = (13, 4)
  let direction = 225deg
  let outer-curve(t) = ellipse-point(center, outer, t)
  let inner-curve(t) = ellipse-point(center, inner, t)
  ellipse-band(boundary, (31.4, 15.4))
  ellipse-band((14.4, 5.4), hole)
  circle(center, radius: boundary, stroke: 0.7pt)
  circle(center, radius: hole, stroke: 0.7pt)
  circle(center, radius: outer, stroke: 0.7pt)
  circle(center, radius: inner, stroke: 0.7pt)
  let first = outer-curve(direction)
  let last = inner-curve(direction)
  line(first, last, stroke: 0.7pt)
  for start in (135deg, 30deg, 265deg) {
    line(
      ..samples(
        t => mul(outer-curve(t), 1.035),
        start,
        start + 22deg,
        count: 15,
      ),
      mark: (end: "stealth"),
    )
  }
  for start in (145deg, 5deg) {
    line(
      ..samples(
        t => mul(inner-curve(t), 1.045),
        start,
        start - 25deg,
        count: 15,
      ),
      mark: (end: "stealth"),
    )
  }
  let vector = sub(last, first)
  let length = calc.sqrt(vector.map(x => x * x).sum())
  let normal = mul((-vector.at(1), vector.at(0)), 0.65 / length)
  let a = add(first, mul(vector, 0.2))
  let b = add(first, mul(vector, 0.8))
  line(add(a, normal), add(b, normal), mark: (end: "stealth"))
  line(sub(b, normal), sub(a, normal), mark: (end: "stealth"))
  content(
    (-outer.at(0) - 1, 0),
    $L$,
    anchor: "east",
    frame: "rect",
    fill: white,
    stroke: none,
  )
  content(
    (0, -(outer.at(1) + boundary.at(1)) / 2),
    $G$,
    frame: "rect",
    fill: white,
    stroke: none,
  )
})

#let contour-system() = cetz.canvas(length: 1mm, {
  import cetz.draw: *
  style()
  let outer(t) = rotated((49 * calc.cos(t), 22 * calc.sin(t)), 20deg)
  let first(t) = add((-29, -9), rotated(
    (8 * calc.cos(t), 5 * calc.sin(t)),
    20deg,
  ))
  let middle(t) = add((-1, 1), rotated(
    (6 * calc.cos(t) - 3 * calc.cos(2 * t), 10 * calc.sin(t)),
    -15deg,
  ))
  let last(t) = add((22, 9), rotated(
    (10 * calc.cos(t), 6 * calc.sin(t) + 2.1 * calc.sin(2 * t)),
    20deg,
  ))
  let curves = (first, middle, last)
  let lower-labels = ($gamma'_1$, $gamma'_2$, $gamma'_n$)
  let upper-labels = ($gamma''_1$, $gamma''_2$, $gamma''_n$)
  let entry = curves.map(f => f(180deg))
  let exit = curves.map(f => f(0deg))
  let starts = (outer(180deg), ..exit)
  let ends = (..entry, outer(0deg))
  let bridge(a, b, t) = {
    let dx = b.at(0) - a.at(0)
    let c1 = add(a, (0.3 * dx, 0))
    let c2 = sub(b, (0.3 * dx, 0))
    add(
      add(mul(a, calc.pow(1 - t, 3)), mul(c1, 3 * t * calc.pow(1 - t, 2))),
      add(mul(c2, 3 * t * t * (1 - t)), mul(b, t * t * t)),
    )
  }
  line(..samples(outer, 0deg, 360deg, count: 240), close: true, stroke: 0.8pt)
  for (k, f) in curves.enumerate() {
    line(..samples(f, 0deg, 360deg, count: 160), close: true, stroke: 0.8pt)
    let lower-arrow = if k == 1 { (330deg, 250deg) } else { (300deg, 270deg) }
    for (a, b) in ((145deg, 115deg), lower-arrow) {
      let center = if k == 0 { (-29, -9) } else if k == 1 { (-1, 1) } else {
        (22, 9)
      }
      line(
        ..samples(
          t => add(center, mul(sub(f(t), center), 1.13)),
          a,
          b,
          count: 20,
        ),
        mark: (end: "stealth"),
      )
    }
    content(add(f(85deg), (0, 3)), upper-labels.at(k), anchor: "south")
    content(
      add(f(270deg), (0, if k == 0 { -3 } else { -6 })),
      lower-labels.at(k),
      anchor: "north",
    )
  }
  for (a, b) in ((78deg, 100deg), (260deg, 282deg)) {
    line(..samples(t => mul(outer(t), 1.045), a, b, count: 20), mark: (
      end: "stealth",
    ))
  }
  content(add(outer(95deg), (0, 3)), $Gamma''$, anchor: "south")
  content(add(outer(275deg), (0, -3)), $Gamma'$, anchor: "north")
  for (k, (a, b)) in starts.zip(ends).enumerate() {
    assert(a.at(0) < b.at(0))
    line(..samples(t => bridge(a, b, t), 0, 1, count: 50))
    let p = bridge(a, b, 0.27)
    let q = bridge(a, b, 0.73)
    let vector = sub(q, p)
    let length = calc.sqrt(vector.map(x => x * x).sum())
    let normal = mul((-vector.at(1), vector.at(0)), 0.7 / length)
    line(add(p, normal), add(q, normal), mark: (end: "stealth"))
    line(sub(q, normal), sub(p, normal), mark: (end: "stealth"))
    content(
      add(sub(bridge(a, b, 0.5), mul(normal, 4)), if k == 1 { (-3, -4) } else {
        (0, 0)
      }),
      if k == 3 { $delta_(n + 1)$ } else { $delta_(#(k + 1))$ },
      anchor: "north",
    )
  }
  for (p, label, anchor) in (
    (add(starts.first(), (-2, 0)), $z_0$, "east"),
    (add(entry.first(), (-1, 2)), $zeta_1$, "south-east"),
    (add(exit.first(), (0, 5)), $z_1$, "south"),
    (add(entry.at(1), (-4, 2)), $zeta_2$, "south-east"),
    (add(exit.last(), (1, 2)), $z_n$, "south-west"),
    (add(ends.last(), (2, 0)), $zeta_0$, "west"),
  ) {
    content(p, label, anchor: anchor)
  }
})
