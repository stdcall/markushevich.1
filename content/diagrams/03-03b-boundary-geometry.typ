#import "@preview/cetz:0.5.2"

#let add(a, b) = a.zip(b).map(((x, y)) => x + y)
#let sub(a, b) = a.zip(b).map(((x, y)) => x - y)
#let mul(a, k) = a.map(x => x * k)
#let norm(a) = calc.sqrt(a.map(x => x * x).sum())
#let polar(r, angle) = (r * calc.cos(angle), r * calc.sin(angle))
#let cubic(a, b, c, d, t) = add(
  add(mul(a, calc.pow(1 - t, 3)), mul(b, 3 * t * calc.pow(1 - t, 2))),
  add(mul(c, 3 * t * t * (1 - t)), mul(d, calc.pow(t, 3))),
)
#let sample(f, a, b, n: 160) = range(n + 1).map(i => f(a + (b - a) * i / n))
#let content-style() = cetz.draw.set-style(
  stroke: 0.5pt,
  content: (
    padding: 1,
    wrap: text.with(top-edge: "bounds", bottom-edge: "bounds"),
  ),
  mark: (fill: black, scale: 0.65, transform-shape: false),
)
#let direction-arrow(f, t, offset: 1.4, length: 4) = {
  let p = f(t)
  let v = sub(f(t + 0.001), f(t - 0.001))
  v = mul(v, 1 / norm(v))
  let middle = add(p, mul((-v.at(1), v.at(0)), offset))
  cetz.draw.line(
    add(middle, mul(v, -length / 2)),
    add(middle, mul(v, length / 2)),
    mark: (end: ">"),
  )
}

#let boundary-deformation() = cetz.canvas(length: 1mm, {
  import cetz.draw: *
  content-style()
  let r = 22
  let a = polar(r, -30deg)
  let b = mul(a, -1)
  let entrance(t) = cubic(
    (-1.1 * r, -r),
    (-0.2 * r, -0.55 * r),
    (1.35 * r, -1.05 * r),
    a,
    t,
  )
  let middle(t) = cubic(a, (0.45 * r, -0.12 * r), (-0.45 * r, 0.12 * r), b, t)
  let exit(t) = cubic(
    b,
    (-1.6 * r, 1.2 * r),
    (0.3 * r, 1.1 * r),
    (1.1 * r, 0.7 * r),
    t,
  )
  assert(norm(middle(0.5)) < 0.00001)
  assert(range(1, 100).all(i => norm(middle(i / 100)) < r))
  circle((0, 0), radius: r)
  for f in (entrance, middle, exit) {
    line(..sample(f, 0, 1), stroke: 0.85pt)
  }
  direction-arrow(entrance, 0.1, offset: -1.5)
  direction-arrow(middle, 0.67, offset: 1.5)
  direction-arrow(exit, 0.93, offset: 1.5)
  for point in (a, b, (0, 0)) { circle(point, radius: 0.42, fill: white) }
  content(a, $A$, anchor: "west")
  content(b, $B$, anchor: "east")
  content((0, 0), $zeta_0$, anchor: "south")
  content(polar(r, -85deg), $a$, anchor: "north")
  content(polar(r, 95deg), $b$, anchor: "south")
  content(polar(r, -57deg), $C$, anchor: "north")
  content(entrance(0), $gamma$, anchor: "south")
  content((-0.15 * r, -0.4 * r), $g_1$)
  content((-0.05 * r, 0.4 * r), $g_2$)
})

#let non-tangential-approach() = cetz.canvas(length: 1mm, {
  import cetz.draw: *
  content-style()
  let r = 24
  let tangent-angle = 16deg
  let normal-angle = tangent-angle - 90deg
  let inner-opening = 66deg
  let outer-opening = 74deg
  let tangent = polar(1, tangent-angle)
  let normal = polar(1, tangent-angle + 90deg)
  let curve(t) = mul(
    add(
      mul(tangent, t),
      mul(normal, 0.12 * t * t * (calc.sin(15 * t * 1rad) + 0.8)),
    ),
    r,
  )
  let crossing(sign) = {
    let low = 0.8
    let high = 1.2
    for _ in range(45) {
      let mid = (low + high) / 2
      if norm(curve(sign * mid)) < r { low = mid } else { high = mid }
    }
    curve(sign * (low + high) / 2)
  }
  let a = crossing(1)
  let b = crossing(-1)
  let xi = curve(-0.58)
  let z = polar(0.55 * r, -121deg)
  assert(calc.abs(norm(a) - r) < 0.00001)
  assert(calc.abs(norm(b) - r) < 0.00001)
  assert(norm(xi) < r and norm(z) < r)
  assert(calc.abs(-121deg - normal-angle) < inner-opening)
  assert(0.12 * 1.2 * 1.8 < calc.tan(90deg - outer-opening))
  circle((0, 0), radius: r)
  for opening in (inner-opening, outer-opening) {
    for sign in (-1, 1) {
      let v = polar(1.25 * r, normal-angle + sign * opening)
      line(mul(v, -1), v, stroke: if opening == outer-opening {
        (dash: "dashed")
      } else { 0.5pt })
    }
  }
  line((0, 0), polar(1.08 * r, normal-angle), stroke: (dash: "dashed"))
  let secant = mul(xi, r / norm(xi))
  line(secant, mul(secant, -1))
  line((0, 0), z, xi)
  line(..sample(curve, -1.25, 1.2, n: 320), stroke: 0.85pt)
  for (opening, radius, label) in (
    (inner-opening, 0.6 * r, $theta$),
    (outer-opening, 0.79 * r, $theta_0$),
  ) {
    let gap = 14deg
    arc(
      (0, 0),
      start: normal-angle,
      delta: -(opening - gap) / 2,
      radius: radius,
      anchor: "origin",
      mark: (start: "<"),
    )
    arc(
      (0, 0),
      start: normal-angle - (opening + gap) / 2,
      delta: -(opening - gap) / 2,
      radius: radius,
      anchor: "origin",
      mark: (end: ">"),
    )
    content(polar(radius, normal-angle - opening / 2), label)
  }
  for point in ((0, 0), xi, z) { circle(point, radius: 0.42, fill: white) }
  content((0, 0), $zeta_0$, anchor: "south-east")
  content(xi, $zeta$, anchor: "north-east")
  content(z, $z$, anchor: "west")
  content(a, $A$, anchor: "south-west")
  content(add(b, mul(normal, 2.5)), $B$, anchor: "south-east")
  content(curve(1.13), $gamma$, anchor: "north")
  content(curve(0.63), $sigma_rho$, anchor: "north")
  content(curve(-0.78), $sigma_rho$, anchor: "south")
  content(polar(r, -60deg), $a$, anchor: "north")
  content(polar(r, 110deg), $b$, anchor: "south")
  content((0.46 * r, -0.35 * r), $g_(theta,rho)$)
})
