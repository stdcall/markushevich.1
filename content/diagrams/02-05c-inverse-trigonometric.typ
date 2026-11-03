#import "@preview/cetz:0.5.2"

#let add(a, b) = a.zip(b).map(((x, y)) => x + y)
#let mul(a, k) = a.map(x => k * x)
#let norm(a) = calc.sqrt(a.at(0) * a.at(0) + a.at(1) * a.at(1))
#let polar(r, a) = (r * calc.cos(a), r * calc.sin(a))
#let product(a, b) = (
  a.at(0) * b.at(0) - a.at(1) * b.at(1),
  a.at(0) * b.at(1) + a.at(1) * b.at(0),
)
#let square-root(z) = {
  let absolute = norm(z)
  (
    calc.sqrt((absolute + z.at(0)) / 2),
    (if z.at(1) < 0 { -1 } else { 1 }) * calc.sqrt((absolute - z.at(0)) / 2),
  )
}
#let inverse-pair(z) = {
  let radical = square-root(add(product(z, z), (-1, 0)))
  let first = add(z, mul(radical, -1))
  let second = add(z, radical)
  assert(norm(first) < 1 and norm(second) > 1)
  assert(norm(add(product(first, second), (-1, 0))) < 0.000001)
  (first, second)
}
#let style() = cetz.draw.set-style(
  stroke: 0.45pt,
  content: (
    padding: 1,
    wrap: text.with(top-edge: "bounds", bottom-edge: "bounds"),
  ),
  mark: (fill: black, scale: 0.65, transform-shape: false),
)
#let axes(xmin, xmax, ymin, ymax, xname, yname) = {
  cetz.draw.line((xmin, 0), (xmax, 0), mark: (end: "stealth"))
  cetz.draw.line((0, ymin), (0, ymax), mark: (end: "stealth"))
  cetz.draw.content((xmax, 0), xname, anchor: "north")
  cetz.draw.content((0, ymax), yname, anchor: "east")
}
#let inverse-neighborhoods() = cetz.canvas(length: 1mm, {
  import cetz.draw: *
  style()
  let z0 = (0.80, 0.32)
  let rho = 0.18
  let zscale = 30
  axes(-7, 31, -10, 33, $x$, $y$)
  content((28, 30), $(z)$)
  content((0, 0), $O$, anchor: "north-east")
  circle(mul(z0, zscale), radius: rho * zscale)
  content(mul(z0, zscale), $z_0$, anchor: "south")
  line(mul(z0, zscale), mul(add(z0, polar(rho, 225deg)), zscale), mark: (
    end: "stealth",
  ))
  circle(mul(z0, zscale), radius: 0.4, fill: white)

  scope({
    translate((62, 0))
    let tscale = 25
    let centers = inverse-pair(z0)
    let preimages = range(129).map(j => inverse-pair(add(z0, polar(
      rho,
      j * 360deg / 128,
    ))))
    let curves = (
      preimages.map(it => it.first()),
      preimages.map(it => it.last()),
    )
    let radii = (
      0.90 * (1 - norm(centers.first())),
      0.94 * (norm(centers.last()) - 1),
    )
    assert(z0.at(1) > rho)
    let radical-lower-bound = calc.sqrt(
      (norm(add(z0, (-1, 0))) - rho) * (norm(add(z0, (1, 0))) - rho),
    )
    assert(rho / radical-lower-bound < radii.first())
    assert(
      rho * (1 + (norm(z0) + rho) / radical-lower-bound) < radii.last(),
    )
    for i in range(2) {
      assert(
        curves
          .at(i)
          .all(t => (
            norm(add(t, mul(centers.at(i), -1))) < radii.at(i)
          )),
      )
    }
    assert(norm(centers.first()) + radii.first() < 1)
    assert(norm(centers.last()) - radii.last() > 1)
    circle((0, 0), radius: tscale)
    axes(-29, 44, -30, 47, $u$, $v$)
    content((40, 44), $(t)$)
    content((0, 0), $O$, anchor: "north-east")
    for i in range(2) {
      let center = mul(centers.at(i), tscale)
      arc(
        center,
        start: 25deg,
        delta: 310deg,
        radius: tscale * radii.at(i),
        anchor: "origin",
      )
      line(..curves.at(i).map(t => mul(t, tscale)))
      let prime = if i == 0 { $t'_0$ } else { $t''_0$ }
      content(center, prime)
      let outer = if i == 0 { $U'$ } else { $U''$ }
      content(add(center, (radii.at(i) * tscale, 0)), outer)
      let curve = if i == 0 { $gamma'$ } else { $gamma''$ }
      let left-curve = calc.min(..curves.at(i).map(t => t.at(0))) * tscale
      let left-neighborhood = center.at(0) - radii.at(i) * tscale
      content(
        ((left-curve + left-neighborhood) / 2, center.at(1)),
        curve,
      )
    }
  })
})

// Liang–Barsky clipping keeps separate arcs when a parametric image leaves
// the chosen finite window. The defining curve itself is never deformed.
#let clipped-segment(a, b, xmin, xmax, ymin, ymax) = {
  let delta = add(b, mul(a, -1))
  let lower = 0
  let upper = 1
  let valid = true
  for (p, q) in (
    (-delta.at(0), a.at(0) - xmin),
    (delta.at(0), xmax - a.at(0)),
    (-delta.at(1), a.at(1) - ymin),
    (delta.at(1), ymax - a.at(1)),
  ) {
    if calc.abs(p) < 0.00000001 {
      if q < 0 { valid = false }
    } else if p < 0 { lower = calc.max(lower, q / p) } else {
      upper = calc.min(upper, q / p)
    }
  }
  if valid and lower <= upper {
    (add(a, mul(delta, lower)), add(a, mul(delta, upper)))
  } else { none }
}
#let logarithmic-ray-images() = cetz.canvas(length: 1mm, {
  import cetz.draw: *
  style()
  let xmin = -5
  let xmax = 5.5
  let ymax = 7.2
  let scale = 7
  for k in range(1, 6) {
    let theta = k * calc.pi / 6
    let curve = range(901).map(j => {
      let logarithm = -8 + 11.5 * j / 900
      let r = calc.exp(logarithm)
      (
        r * calc.cos(theta * 1rad) + logarithm,
        r * calc.sin(theta * 1rad) + theta,
      )
    })
    for i in range(curve.len() - 1) {
      let segment = clipped-segment(
        curve.at(i),
        curve.at(i + 1),
        xmin,
        xmax,
        0,
        ymax,
      )
      if segment != none { line(..segment.map(p => mul(p, scale))) }
    }
  }
  line(
    (xmin * scale, calc.pi * scale),
    (-scale, calc.pi * scale),
    stroke: 0.9pt,
  )
  axes(xmin * scale - 1, xmax * scale + 2, -4, ymax * scale + 2, $u$, $v$)
  content((0, 0), $O$, anchor: "north-east")
})
