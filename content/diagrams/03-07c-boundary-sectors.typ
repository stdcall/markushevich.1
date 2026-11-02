#import "@preview/cetz:0.5.2"

#let plus(a, b) = a.zip(b).map(((x, y)) => x + y)
#let times(a, k) = a.map(x => x * k)
#let polar(r, a) = (r * calc.cos(a), r * calc.sin(a))
#let distance(a, b) = calc.sqrt(
  a.zip(b).map(((x, y)) => (x - y) * (x - y)).sum(),
)
#let picture-style() = cetz.draw.set-style(
  stroke: 0.5pt,
  content: (
    padding: 1,
    wrap: text.with(top-edge: "bounds", bottom-edge: "bounds"),
  ),
  mark: (fill: black, scale: 0.65, transform-shape: false),
)

#let abel-sector() = cetz.canvas(length: 1mm, {
  import cetz.draw: *
  picture-style()
  let radius = 25
  let wedge-angle = 35deg
  let secant-angle = 22deg
  let inner = calc.sin(wedge-angle)
  let middle = 0.81
  let a = (1, 0)
  let tangent(sign) = (
    calc.sin(wedge-angle) * calc.sin(wedge-angle),
    sign * calc.sin(wedge-angle) * calc.cos(wedge-angle),
  )
  let ray-circle(r) = {
    let projection = calc.cos(secant-angle)
    let root = calc.sqrt(
      r * r - calc.sin(secant-angle) * calc.sin(secant-angle),
    )
    (projection - root, projection + root).map(t => plus(a, polar(
      t,
      180deg - secant-angle,
    )))
  }
  let (b, bp) = ray-circle(middle)
  let e = ray-circle(inner).last()
  let c = (middle, 0)
  let cp = (-middle, 0)
  let d = (-1, 0)
  let f = tangent(1)
  let lower = tangent(-1)
  assert(inner < middle and middle < 1)
  let secant-product = distance(a, b) * distance(a, bp)
  let diameter-product = distance(a, c) * distance(a, cp)
  assert(calc.abs(secant-product - diameter-product) < 0.00001)
  assert(calc.abs(distance((0, 0), f) - inner) < 0.00001)
  assert(distance(a, b) / distance(a, c) < 2 / calc.cos(wedge-angle))
  let inside(p) = (
    p.at(0) <= 1
      and p.at(0) >= inner * inner
      and calc.abs(p.at(1)) <= calc.tan(wedge-angle) * (1 - p.at(0)) + 0.000001
      and p.at(0) * p.at(0) + p.at(1) * p.at(1) >= inner * inner - 0.000001
  )
  let slope = 1.5
  for intercept in range(-21, 22).map(i => i * 0.052) {
    let points = ()
    for sign in (-1, 1) {
      let x = (
        (intercept + sign * calc.tan(wedge-angle))
          / (slope + sign * calc.tan(wedge-angle))
      )
      points.push((x, slope * x - intercept))
    }
    let disc = inner * inner * (1 + slope * slope) - intercept * intercept
    if disc >= 0 {
      for sign in (-1, 1) {
        let x = (
          (slope * intercept + sign * calc.sqrt(disc)) / (1 + slope * slope)
        )
        points.push((x, slope * x - intercept))
      }
    }
    points = points.filter(inside).sorted(key: p => p.at(0))
    for i in range(points.len() - 1) {
      let midpoint = times(plus(points.at(i), points.at(i + 1)), 0.5)
      if inside(midpoint) {
        line(
          times(points.at(i), radius),
          times(points.at(i + 1), radius),
          stroke: 0.2pt,
        )
      }
    }
  }
  for r in (1, middle, inner) { circle((0, 0), radius: radius * r) }
  line(times(d, radius), times(a, radius))
  for sign in (-1, 1) {
    let endpoint = plus(a, polar(
      2 * calc.cos(wedge-angle),
      180deg - sign * wedge-angle,
    ))
    line(times(a, radius), times(endpoint, radius))
  }
  line(times(a, radius), times(bp, radius))
  arc(
    times(a, radius),
    start: 180deg - wedge-angle,
    stop: 180deg,
    radius: radius * 0.58,
    anchor: "origin",
    mark: (start: "<", end: ">"),
  )
  for p in ((0, 0), a, b, bp, c, cp, e, f, lower) {
    circle(times(p, radius), radius: 0.38, fill: white)
  }
  for (p, label, anchor) in (
    (a, $A$, "west"),
    (b, $B$, "south-west"),
    (bp, $B'$, "south-east"),
    (cp, $C'$, "north-east"),
    (d, $D$, "east"),
    (e, $E$, "north-east"),
    (f, $F$, "south-west"),
    ((0, 0), $O$, "north"),
  ) { content(times(p, radius), label, anchor: anchor) }
  content(
    times(plus(c, (0, -calc.tan(wedge-angle) * (1 - middle))), radius),
    $C$,
    anchor: "north",
  )
  content(
    plus(times(a, radius), polar(radius * 0.66, 180deg - wedge-angle / 2)),
    $theta$,
  )
  content((radius * (middle + inner) / 2, -radius * 0.12), $d_theta$)
})

#let fatou-sector() = cetz.canvas(length: 1mm, {
  import cetz.draw: *
  picture-style()
  let radius = 25
  let gap-size = 0.48
  let outer = 1 + gap-size / 2
  assert(gap-size / 2 * calc.sqrt(1 + outer) < gap-size)
  let sigma-start = 20deg
  let sigma-stop = 40deg
  let offset = 2 * calc.asin(gap-size / 4)
  let angles = (sigma-start - offset, sigma-stop + offset)
  let arc-points = angles.map(a => polar(radius, a))
  let ends = angles.map(a => polar(radius * outer, a))
  assert(
    calc.abs(
      distance(arc-points.first(), polar(radius, sigma-start))
        - radius * gap-size / 2,
    )
      < 0.00001,
  )
  assert(
    calc.abs(
      distance(arc-points.last(), polar(radius, sigma-stop))
        - radius * gap-size / 2,
    )
      < 0.00001,
  )
  circle((0, 0), radius: radius)
  for p in ends { line((0, 0), p) }
  arc(
    (0, 0),
    start: angles.first(),
    stop: angles.last(),
    radius: radius * outer,
    anchor: "origin",
  )
  arc(
    (0, 0),
    start: sigma-start,
    stop: sigma-stop,
    radius: radius,
    anchor: "origin",
    stroke: 1.5pt,
  )
  for angle in (sigma-start, sigma-stop) {
    line(polar(radius - 0.6, angle), polar(radius + 0.6, angle))
  }
  let dimension-angle = (sigma-start + sigma-stop) / 2
  line(
    polar(radius, dimension-angle),
    polar(radius * outer, dimension-angle),
    mark: (start: ">", end: ">"),
  )
  content(
    polar(radius * (1 + outer) / 2, dimension-angle),
    $rho/2$,
    anchor: "north-west",
  )
  cetz.decorations.brace(
    polar(radius, sigma-start),
    arc-points.first(),
    amplitude: 1.2,
    flip: true,
    name: "gap",
  )
  content("gap.content", $rho/2$, anchor: "south-east")
  content((0, 0), $O$, anchor: "east")
  content(arc-points.first(), $zeta_1$, anchor: "north-west")
  content(arc-points.last(), $zeta_2$, anchor: "south-east")
  content(ends.first(), $z_1$, anchor: "west")
  content(ends.last(), $z_2$, anchor: "south-west")
  content(polar(radius - 0.7, dimension-angle), $sigma$, anchor: "east")
})
