#import "@preview/cetz:0.5.2"
#import "01-03a-sequences.typ": hatched-polygon

// All constructions use the unit Poincaré disk. Only the final drawing
// coordinates are multiplied by the common radius in millimetres.
#let radius = 21
#let add(a, b) = a.zip(b).map(((x, y)) => x + y)
#let mul(a, k) = a.map(x => k * x)
#let sub(a, b) = add(a, mul(b, -1))
#let dot(a, b) = a.zip(b).map(((x, y)) => x * y).sum()
#let norm(a) = calc.sqrt(dot(a, a))
#let unit(a) = mul(a, 1 / norm(a))
#let perp(a) = (-a.at(1), a.at(0))
#let polar(r, a) = (r * calc.cos(a), r * calc.sin(a))
#let conjugate(a) = (a.at(0), -a.at(1))
#let product(a, b) = (
  a.at(0) * b.at(0) - a.at(1) * b.at(1),
  a.at(0) * b.at(1) + a.at(1) * b.at(0),
)
#let quotient(a, b) = mul(product(a, conjugate(b)), 1 / dot(b, b))
#let from-origin(z, a, phase: 0deg) = {
  let w = product(z, polar(1, phase))
  quotient(add(w, a), add((1, 0), product(conjugate(a), w)))
}
#let p(z) = mul(z, radius)
#let determinant(a, b) = a.at(0) * b.at(1) - a.at(1) * b.at(0)
#let geodesic-data(a, b) = {
  let det = determinant(a, b)
  if calc.abs(det) < 0.000001 { none } else {
    let aa = (dot(a, a) + 1) / 2
    let bb = (dot(b, b) + 1) / 2
    let center = (
      (aa * b.at(1) - bb * a.at(1)) / det,
      (a.at(0) * bb - b.at(0) * aa) / det,
    )
    let r = calc.sqrt(dot(center, center) - 1)
    assert(calc.abs(dot(center, center) - r * r - 1) < 0.000001)
    (center: center, radius: r)
  }
}
#let geodesic-mid(a, b) = {
  let data = geodesic-data(a, b)
  if data == none { mul(add(a, b), 0.5) } else {
    add(data.center, mul(
      unit(add(sub(a, data.center), sub(b, data.center))),
      data.radius,
    ))
  }
}
#let ends(a, b) = {
  let data = geodesic-data(a, b)
  if data == none { (unit(sub(b, a)), mul(unit(sub(b, a)), -1)) } else {
    let base = mul(data.center, 1 / dot(data.center, data.center))
    let offset = mul(
      perp(data.center),
      data.radius / dot(data.center, data.center),
    )
    (add(base, offset), sub(base, offset))
  }
}
#let tangent(a, b) = {
  let data = geodesic-data(a, b)
  if data == none { unit(sub(b, a)) } else {
    let direction = unit(perp(sub(a, data.center)))
    if dot(direction, sub(b, a)) < 0 { mul(direction, -1) } else { direction }
  }
}
#let samples(a, b, count: 48) = {
  let data = geodesic-data(a, b)
  if data == none { (a, b) } else {
    let va = sub(a, data.center)
    let vb = sub(b, data.center)
    let start = calc.atan2(va.at(0), va.at(1))
    let sweep = calc.atan2(dot(va, vb), determinant(va, vb))
    range(count + 1).map(i => add(data.center, polar(
      data.radius,
      start + sweep * i / count,
    )))
  }
}
#let geo(a, b, stroke: 0.45pt, name: none) = {
  if geodesic-data(a, b) == none {
    cetz.draw.line(p(a), p(b), stroke: stroke, name: name)
  } else {
    cetz.draw.arc-through(
      p(a),
      p(geodesic-mid(a, b)),
      p(b),
      stroke: stroke,
      name: name,
    )
  }
}
#let full(a, b, stroke: 0.45pt) = {
  let (u, v) = ends(a, b)
  geo(u, v, stroke: stroke)
}
#let point(z, label, anchor: "south") = {
  cetz.draw.circle(p(z), radius: 0.45, fill: white)
  cetz.draw.content(p(z), label, anchor: anchor)
}
#let disk() = cetz.draw.circle((0, 0), radius: radius)
#let style() = cetz.draw.set-style(
  stroke: 0.45pt,
  mark: (fill: black, scale: 0.6, transform-shape: false),
  brace: (amplitude: 1, thickness: 0.1, content-offset: 1.1),
  content: (
    padding: 1,
    wrap: text.with(top-edge: "bounds", bottom-edge: "bounds"),
  ),
  angle: (radius: 3),
)
#let angle(a, b, c, label: none, radius: 3, mark: none) = cetz.angle.angle(
  p(a),
  p(add(a, mul(tangent(a, b), 0.25))),
  p(add(a, mul(tangent(a, c), 0.25))),
  label: label,
  direction: "near",
  label-radius: 160%,
  mark: mark,
  radius: radius,
)

#let segment-transport() = cetz.canvas(length: 1mm, {
  import cetz.draw: *
  style()
  disk()
  let b1 = 0.35
  let b2 = 0.62
  let a = (-0.45, 0.36)
  let ap = (-0.43, -0.52)
  let original(t) = from-origin((t, 0), a, phase: 29deg)
  let other(t) = from-origin((t, 0), ap, phase: 30deg)
  full(original(0), original(b1))
  full(other(0), other(b1))
  line(p((-1, 0)), p((1, 0)))
  point(original(0), $A$, anchor: "south-east")
  point(original(b1), $B$, anchor: "south")
  content(p(original(1)), $C$, anchor: "south-west")
  point(other(0), $A'$, anchor: "north-east")
  point(other(b1), $B'$, anchor: "north")
  point(other(b2), $B''$, anchor: "south")
  point((0, 0), $O$, anchor: "north-east")
  point((b1, 0), $B_1$, anchor: "north")
  point((b2, 0), $B_2$, anchor: "north")
  content(p((1, 0)), $R$, anchor: "north-west")
})

#let segment-addition() = cetz.canvas(length: 1mm, {
  import cetz.draw: *
  style()
  disk()
  let a = -0.48
  let c = 0.38
  let upper(t) = from-origin((t, 0), (-0.05, 0.47), phase: 4deg)
  let lower(t) = from-origin((t, 0), (-0.04, -0.48), phase: -4deg)
  full(upper(a), upper(c))
  full(lower(a), lower(c))
  line(p((-1, 0)), p((1, 0)))
  point(upper(a), $A$, anchor: "south")
  point(upper(0), $B$, anchor: "south")
  point(upper(c), $C$, anchor: "south")
  point(lower(a), $A'$, anchor: "north")
  point(lower(0), $B'$, anchor: "north")
  point(lower(c), $C'$, anchor: "north")
  point((a, 0), $A_1$, anchor: "south")
  content(p((a, 0)), $A_2$, anchor: "north")
  point((0, 0), $B_1$, anchor: "south")
  content(p((0, 0)), $O$, anchor: "north")
  point((c, 0), $C_1$, anchor: "south")
  content(p((c, 0)), $C_2$, anchor: "north")
})

#let lobachevsky-angle() = cetz.canvas(length: 1mm, {
  import cetz.draw: *
  style()
  let a = (-0.55, 0.30)
  let u = polar(1, 132deg)
  let v = polar(1, 84deg)
  let boundary = range(33).map(i => polar(1, 132deg - 48deg * i / 32))
  let region = samples(a, u) + boundary.slice(1) + samples(v, a).slice(1)
  hatched-polygon(region.map(p), step: 1.3)
  disk()
  for endpoint in (u, v) {
    let (first, second) = ends(a, endpoint)
    let opposite = if norm(sub(first, endpoint)) < 0.000001 { second } else {
      first
    }
    geo(a, opposite, stroke: (dash: "dashed"))
  }
  geo(a, u)
  geo(a, v)
  point(a, $A$, anchor: "north")
  point((0, 0), $O$, anchor: "north")
  content(p(geodesic-mid(a, u)), $h$, anchor: "north-east")
  content(p(geodesic-mid(a, v)), $k$, anchor: "west")
})

#let parallel-data = {
  let b = 0.37
  let center = (1 + b * b) / (2 * b)
  let top = (1 / center, calc.sqrt(1 - 1 / (center * center)))
  let bottom = conjugate(top)
  (b: b, center: center, rho: (1 - b * b) / (2 * b), top: top, bottom: bottom)
}
#let parallels() = cetz.canvas(length: 1mm, {
  import cetz.draw: *
  style()
  // Möbius image of the normalized configuration in the last drawing.
  let transform(z) = from-origin(z, (-0.30, 0.47), phase: 210deg)
  let a = transform((0, 0))
  let alpha = transform(parallel-data.bottom)
  let beta = transform(parallel-data.top)
  let boundary = range(65).map(i => polar(1, i * 360deg / 64))
  hatched-polygon(boundary.map(p), step: 1.4)
  // Clear the cap beyond the given line, leaving its complement hatched.
  let cap = samples(alpha, beta)
  let bb = calc.atan2(beta.at(0), beta.at(1))
  let sweep = calc.atan2(dot(beta, alpha), determinant(beta, alpha))
  let rim = range(49).map(i => polar(1, bb + sweep * i / 48))
  line(..(cap + rim.slice(1)).map(p), close: true, fill: white, stroke: none)
  disk()
  geo(alpha, beta)
  full(a, alpha)
  full(a, beta)
  // Its normalized diameter has |cos(theta)| < cos(arg(top)); thus its
  // ideal endpoints lie outside the cap and it cannot meet the given line.
  let extra = polar(1, -65deg)
  assert(calc.abs(extra.at(0)) < parallel-data.top.at(0))
  full(a, transform(extra), stroke: (dash: "dashed"))
  point(a, $A$, anchor: "north-east")
  point(alpha, $#sym.alpha$, anchor: "east")
  point(beta, $#sym.beta$, anchor: "east")
  point((0, 0), $O$, anchor: "north-west")
  point(transform(extra), $delta$, anchor: "south-west")
  let extra-ends = ends(a, transform(extra))
  point(
    extra-ends.find(x => norm(sub(x, transform(extra))) > 0.01),
    $gamma$,
    anchor: "south-west",
  )
  for endpoint in (alpha, beta) {
    let (first, second) = ends(a, endpoint)
    let other = if norm(sub(first, endpoint)) < 0.000001 { second } else {
      first
    }
    circle(p(other), radius: 0.45, fill: white)
  }
})

#let triangle-angle-sum() = cetz.canvas(length: 1mm, {
  import cetz.draw: *
  style()
  disk()
  let a = (0, 0)
  let b = polar(0.72, 239deg)
  let c = polar(0.72, 301deg)
  let (left, right) = ends(b, c)
  geo(left, right)
  line(p(a), p(left), stroke: (dash: "dashed"))
  line(p(a), p(right), stroke: (dash: "dashed"))
  line(p(a), p(unit(b)))
  line(p(a), p(unit(c)))
  line(p(b), p(c))
  angle(a, b, c, label: $alpha$, radius: 4)
  angle(b, c, a, label: $beta$, radius: 3)
  angle(c, a, b, label: $gamma$, radius: 3)
  point(a, $A$, anchor: "south")
  point(b, $B$, anchor: "east")
  point(c, $C$, anchor: "west")
  for e in (left, right) {
    point(e, if e.at(0) < 0 { $B'$ } else { $C'$ }, anchor: "north")
  }
})

#let circle-intersection(a, b, c, d) = {
  let first = geodesic-data(a, b)
  let second = geodesic-data(c, d)
  let delta = sub(second.center, first.center)
  let distance = norm(delta)
  let axis = unit(delta)
  let along = (
    (
      first.radius * first.radius
        - second.radius * second.radius
        + distance * distance
    )
      / (2 * distance)
  )
  let height = calc.sqrt(first.radius * first.radius - along * along)
  let base = add(first.center, mul(axis, along))
  let candidates = (
    add(base, mul(perp(axis), height)),
    sub(base, mul(perp(axis), height)),
  )
  candidates.find(x => norm(x) < 1)
}
#let equal-angle-triangles() = cetz.canvas(length: 1mm, {
  import cetz.draw: *
  style()
  // These are the two hypothetical unequal configurations used in the
  // contradiction. No equal-angle claim is encoded in their coordinates.
  for crossing in (true, false) {
    scope({
      if not crossing { translate((54, 0)) }
      disk()
      let a = (0, 0)
      let ray = polar(1, 237deg)
      let b = (-0.42, 0)
      let b1 = (-0.68, 0)
      let c = mul(ray, if crossing { 0.72 } else { 0.43 })
      let c1 = mul(ray, if crossing { 0.43 } else { 0.72 })
      if crossing {
        let d = circle-intersection(b, c, b1, c1)
        for triple in ((b, d, b1), (c, d, c1)) {
          let (x, y, z) = triple
          hatched-polygon(
            (
              samples(x, y) + samples(y, z).slice(1) + samples(z, x).slice(1)
            ).map(p),
            step: 1.2,
          )
        }
        point(d, $D$, anchor: "east")
      } else {
        hatched-polygon(
          (
            samples(b, b1)
              + samples(b1, c).slice(1)
              + samples(c, c1).slice(1)
              + samples(c1, b).slice(1)
          ).map(p),
          step: 1.2,
        )
        full(b1, c, stroke: (dash: "dashed"))
      }
      line(p((-1, 0)), p(a))
      line(p(a), p(ray))
      full(b, c)
      full(b1, c1)
      point(a, $A$, anchor: "west")
      point(b, $B$, anchor: "south")
      point(b1, $B_1$, anchor: "north")
      point(c, $C$, anchor: "east")
      point(c1, $C_1$, anchor: "west")
      content((0, -radius - 3), if crossing { [а)] } else { [б)] })
    })
  }
})

#let parallel-angle() = cetz.canvas(length: 1mm, {
  import cetz.draw: *
  style()
  let transform(z) = from-origin(z, (-0.27, 0.44), phase: 210deg)
  let a = transform((0, 0))
  let b = transform((parallel-data.b, 0))
  let alpha = transform(parallel-data.bottom)
  let beta = transform(parallel-data.top)
  disk()
  geo(alpha, beta)
  full(a, alpha)
  full(a, beta)
  full(a, b)
  angle(a, alpha, b, radius: 3, mark: (end: ">"))
  angle(a, b, beta, radius: 3, mark: (end: ">"))
  point(a, $A$, anchor: "north-west")
  point(b, $B$, anchor: "south-east")
  point(alpha, $#sym.alpha$, anchor: "south-east")
  point(beta, $#sym.beta$, anchor: "north-east")
  let (u, v) = ends(a, b)
  let gamma = if u.at(0) < v.at(0) { u } else { v }
  point(gamma, $#sym.gamma$, anchor: "east")
  for boundary in (alpha, beta, gamma) {
    let (first, second) = ends(a, boundary)
    let other = if norm(sub(first, boundary)) < 0.000001 { second } else {
      first
    }
    circle(p(other), radius: 0.45, fill: white)
  }
  content(p(geodesic-mid(alpha, beta)), $a$, anchor: "east")
})

#let parallel-angle-normalized() = cetz.canvas(length: 1mm, {
  import cetz.draw: *
  style()
  disk()
  let a = (0, 0)
  let b = (parallel-data.b, 0)
  let c = (parallel-data.center, 0)
  let top = parallel-data.top
  let bottom = parallel-data.bottom
  assert(calc.abs(dot(top, top) - 1) < 0.000001)
  assert(calc.abs(dot(sub(top, c), top)) < 0.000001)
  line(p((-1.3, 0)), p(add(c, (0.2, 0))))
  geo(top, bottom)
  line(p(a), p(top))
  line(p(a), p(bottom))
  line(p(top), p(c))
  angle(a, top, b, radius: 4, mark: (end: ">"))
  content(p(mul(top, 0.45)), $Pi(delta)$, anchor: "south-east")
  cetz.decorations.brace(
    add(p(a), (0, -1)),
    add(p(b), (0, -1)),
    name: "base-length",
    flip: true,
  )
  content(add(p(mul(b, 0.9)), (0, -2.4)), $b'$, anchor: "north")
  cetz.decorations.brace(p(top), p(c), name: "radius-length")
  content("radius-length.content", $rho$, anchor: "south-west")
  content(p(a), $A'$, anchor: "south-east")
  content(p(b), $B'$, anchor: "south-west")
  content(p(c), $C'$, anchor: "south-west")
  content(p(top), $beta'$, anchor: "south-west")
  content(p(bottom), $alpha'$, anchor: "north-west")
  content(p(geodesic-mid(b, bottom)), $a'$, anchor: "north-west")
})
