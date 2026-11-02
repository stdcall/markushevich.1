#import "@preview/cetz:0.5.2"

#let plus(a, b) = (a.at(0) + b.at(0), a.at(1) + b.at(1))
#let minus(a, b) = (a.at(0) - b.at(0), a.at(1) - b.at(1))
#let times(a, b) = (
  a.at(0) * b.at(0) - a.at(1) * b.at(1),
  a.at(0) * b.at(1) + a.at(1) * b.at(0),
)
#let multiple(a, k) = (a.at(0) * k, a.at(1) * k)
#let magnitude(a) = calc.sqrt(a.at(0) * a.at(0) + a.at(1) * a.at(1))
#let quotient(a, b) = multiple(
  times(a, (b.at(0), -b.at(1))),
  1 / calc.pow(magnitude(b), 2),
)
#let polar(r, t) = (r * calc.cos(t), r * calc.sin(t))
#let root(a, n) = polar(
  calc.pow(magnitude(a), 1 / n),
  calc.atan2(a.at(0), a.at(1)) / n,
)
#let permutations = (
  (0, 1, 2),
  (0, 2, 1),
  (1, 0, 2),
  (1, 2, 0),
  (2, 0, 1),
  (2, 1, 0),
)

// Follow every inverse branch of P(z)=level·exp(it). Their union is the
// lemniscate; branch endpoints may join other branches after one turn.
#let inverse-contour(inverse, level, phase, count, steps: 480) = {
  let paths = range(count).map(_ => ())
  let previous = none
  for i in range(steps + 1) {
    let values = inverse(polar(level, phase + i * 360deg / steps))
    if previous != none {
      let orders = if count == 2 { ((0, 1), (1, 0)) } else { permutations }
      let best = orders
        .sorted(key: order => range(count)
          .map(j => calc.pow(
            magnitude(minus(previous.at(j), values.at(order.at(j)))),
            2,
          ))
          .sum())
        .first()
      values = best.map(j => values.at(j))
    }
    for j in range(count) { paths.at(j).push(values.at(j)) }
    previous = values
  }
  paths
}

#let diagram-style() = cetz.draw.set-style(
  stroke: 0.5pt,
  content: (
    padding: 1,
    wrap: text.with(top-edge: "bounds", bottom-edge: "bounds"),
  ),
)

#let cassini-ovals() = cetz.canvas(length: 1mm, {
  import cetz.draw: *
  diagram-style()
  let a = 1
  let inverse(w) = {
    let z = root(plus((a * a, 0), w), 2)
    (z, multiple(z, -1))
  }
  let ratios = (0.4, 0.5, 0.58, 0.75)
  let labels = ([а)], [б)], [в)], [г)])
  let scale = 15
  for (i, ratio) in ratios.enumerate() {
    let center = (0, -i * 35)
    let radius = 2 * a * ratio
    let level = radius * radius
    assert(
      (i == 0 and level < a * a)
        or (i == 1 and level == a * a)
        or (i == 2 and a * a < level and level < 2 * a * a)
        or (i == 3 and level > 2 * a * a),
    )
    for path in inverse-contour(inverse, level, 180deg, 2) {
      line(..path.map(z => plus(center, multiple(z, scale))))
    }
    for (j, focus) in ((-a, 0), (a, 0)).enumerate() {
      let at = plus(center, multiple(focus, scale))
      circle(at, radius: 0.35, fill: white)
      content(
        at,
        if j == 0 { $z_1$ } else { $z_2$ },
        anchor: if j == 0 { "east" } else { "west" },
        padding: 0.4,
      )
    }
    content(plus(center, (-34, 0)), emph(labels.at(i)), anchor: "east")
  }
})

#let three-focus-evolution() = cetz.canvas(length: 1mm, {
  import cetz.draw: *
  diagram-style()
  let foci = ((-1, -0.3), (0.1, 0.7), (0.9, -0.4))
  assert(magnitude(foci.fold((0, 0), plus)) < 0.00001)
  let p = plus(
    plus(times(foci.at(0), foci.at(1)), times(foci.at(0), foci.at(2))),
    times(foci.at(1), foci.at(2)),
  )
  let q = multiple(times(times(foci.at(0), foci.at(1)), foci.at(2)), -1)
  let polynomial(z) = plus(plus(times(times(z, z), z), times(p, z)), q)
  assert(foci.all(z => magnitude(polynomial(z)) < 0.00001))
  let curvature-numerator(z) = {
    let value = polynomial(z)
    let conjugate = (value.at(0), -value.at(1))
    let derivative = plus(multiple(times(z, z), 3), p)
    let first = times(derivative, conjugate)
    let second = times(multiple(z, 6), conjugate)
    let square = calc.pow(magnitude(derivative), 2)
    let fx = 2 * first.at(0)
    let fy = -2 * first.at(1)
    let fxx = 2 * (square + second.at(0))
    let fyy = 2 * (square - second.at(0))
    let fxy = -2 * second.at(1)
    fxx * fy * fy - 2 * fxy * fx * fy + fyy * fx * fx
  }
  let inverse(w) = {
    let constant = minus(q, w)
    let half = multiple(constant, -0.5)
    let discriminant = plus(times(half, half), multiple(
      times(times(p, p), p),
      1 / 27,
    ))
    let u = root(plus(half, root(discriminant, 2)), 3)
    if magnitude(u) < 0.000001 {
      u = root(minus(half, root(discriminant, 2)), 3)
    }
    let v = quotient(multiple(p, -1 / 3), u)
    range(3).map(k => plus(times(u, polar(1, k * 120deg)), times(v, polar(
      1,
      -k * 120deg,
    ))))
  }
  let critical = root(multiple(p, -1 / 3), 2)
  let critical-values = (
    polynomial(critical),
    polynomial(multiple(critical, -1)),
  ).sorted(key: magnitude)
  let lower = magnitude(critical-values.first())
  let upper = magnitude(critical-values.last())
  assert(0 < lower and lower < upper)
  let levels = (
    0.45 * lower,
    lower,
    (lower + upper) / 2,
    upper,
    1.35 * upper,
    4 * upper,
  )
  let labels = ([а)], [б)], [в)], [г)], [д)], [е)])
  let scale = 12
  for (i, level) in levels.enumerate() {
    let center = (
      if calc.rem(i, 2) == 0 { -30 } else { 30 },
      -calc.floor(i / 2) * 44,
    )
    let phase = if i == 1 {
      calc.atan2(critical-values.first().at(0), critical-values.first().at(1))
    } else if i == 3 {
      calc.atan2(critical-values.last().at(0), critical-values.last().at(1))
    } else { 0deg }
    let paths = inverse-contour(inverse, level, phase, 3)
    assert(paths.all(path => path.all(z => (
      calc.abs(magnitude(polynomial(z)) - level) < 0.00001
    ))))
    if i == 4 {
      assert(paths.any(path => path.any(z => curvature-numerator(z) < 0)))
    }
    if i == 5 {
      assert(paths.all(path => path.all(z => curvature-numerator(z) > 0)))
    }
    for path in paths {
      line(..path.map(z => plus(center, multiple(z, scale))))
    }
    for focus in foci {
      circle(plus(center, multiple(focus, scale)), radius: 0.32, fill: white)
    }
    let bottom = paths
      .map(path => path.map(z => z.at(1)).sorted().first())
      .sorted()
      .first()
    content(
      plus(center, (0, scale * bottom - 2)),
      emph(labels.at(i)),
      anchor: "north",
    )
  }
})
