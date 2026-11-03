#import "@preview/cetz:0.5.2"

#let add(a, b) = a.zip(b).map(((x, y)) => x + y)
#let sub(a, b) = a.zip(b).map(((x, y)) => x - y)
#let mul(a, t) = a.map(x => x * t)
#let mix(a, b, t) = add(a, mul(sub(b, a), t))
#let cross(a, b) = a.at(0) * b.at(1) - a.at(1) * b.at(0)
#let intersection(a, b, c, d) = {
  let direction = sub(b, a)
  let other = sub(d, c)
  mix(a, b, cross(sub(c, a), other) / cross(direction, other))
}
#let center(points) = mul(points.fold((0, 0), add), 1 / points.len())
#let style() = cetz.draw.set-style(
  stroke: 0.55pt,
  content: (
    padding: 1,
    wrap: text.with(top-edge: "bounds", bottom-edge: "bounds"),
  ),
  mark: (fill: black, scale: 0.65, transform-shape: false),
)
#let arrow(a, b, offset: 0, length: 4, at: 0.5) = {
  let delta = sub(b, a)
  let norm = calc.sqrt(delta.map(x => x * x).sum())
  let unit = mul(delta, 1 / norm)
  let normal = (-unit.at(1), unit.at(0))
  let middle = add(mix(a, b, at), mul(normal, offset))
  cetz.draw.line(
    add(middle, mul(unit, -length / 2)),
    add(middle, mul(unit, length / 2)),
    mark: (end: "stealth"),
  )
}
#let hatch(vertices, reverse: false) = {
  let sign = if reverse { -1 } else { 1 }
  let offsets = vertices.map(p => p.at(1) - sign * p.at(0))
  let step = 1.1
  let first = calc.floor(calc.min(..offsets) / step)
  let last = calc.ceil(calc.max(..offsets) / step)
  for k in range(first, last + 1) {
    let level = k * step
    let hits = ()
    for i in range(vertices.len()) {
      let a = vertices.at(i)
      let b = vertices.at(calc.rem(i + 1, vertices.len()))
      let da = a.at(1) - sign * a.at(0)
      let db = b.at(1) - sign * b.at(0)
      if (da <= level and level < db) or (db <= level and level < da) {
        hits.push(mix(a, b, (level - da) / (db - da)))
      }
    }
    hits = hits.sorted(key: p => p.at(0))
    assert(calc.rem(hits.len(), 2) == 0)
    for i in range(0, hits.len(), step: 2) {
      cetz.draw.line(hits.at(i), hits.at(i + 1), stroke: 0.25pt)
    }
  }
}

#let triangle-subdivision() = cetz.canvas(length: 1mm, {
  import cetz.draw: *
  style()
  let a = (0, 0)
  let b = (40, 0)
  let c = (32, 24)
  let ab = mix(a, b, 0.5)
  let bc = mix(b, c, 0.5)
  let ca = mix(c, a, 0.5)
  line(a, b, c, close: true)
  line(ab, bc, ca, close: true)
  let triangles = ((ab, b, bc), (ca, bc, c), (a, ab, ca), (ab, bc, ca))
  let labels = (
    $L^upright("I")$,
    $L^upright("II")$,
    $L^upright("III")$,
    $L^upright("IV")$,
  )
  for (triangle, label) in triangles.zip(labels) {
    for i in range(3) {
      arrow(triangle.at(i), triangle.at(calc.rem(i + 1, 3)), offset: 1)
    }
    content(center(triangle), label)
  }
  content(ca, $L$, anchor: "south-east")
})

#let convex-polygon() = cetz.canvas(length: 1mm, {
  import cetz.draw: *
  style()
  let vertices = ((18, 0), (34, 4), (33, 25), (27, 32), (5, 25), (0, 7))
  let labels = ($A_0$, $A_1$, $A_2$, $A_3$, $A_(n-2)$, $A_(n-1)$)
  let anchors = ("north", "west", "west", "south", "south-east", "east")
  line(..vertices, close: true)
  for i in range(vertices.len()) {
    arrow(
      vertices.at(i),
      vertices.at(calc.rem(i + 1, vertices.len())),
      offset: -1.8,
    )
    content(vertices.at(i), labels.at(i), anchor: anchors.at(i))
  }
  for i in (2, 3, 4) { line(vertices.first(), vertices.at(i)) }
  arrow(vertices.at(2), vertices.first(), offset: -1.2)
  arrow(vertices.first(), vertices.at(3), offset: -1.2)
})

#let nonconvex-polygon() = cetz.canvas(length: 1mm, {
  import cetz.draw: *
  style()
  let a = (0, 18)
  let h = (2, 2)
  let g = (42, 0)
  let d = (52, 15)
  let c = mix(a, d, 0.35)
  let j = mix(h, g, 0.25)
  let b = add(c, sub(c, j))
  let f = add(g, sub(g, d))
  let e = (56, -10)
  let k = intersection(h, g, d, e)
  let faces = ((a, c, b), (a, h, j, c), (c, j, g, d), (g, k, d), (g, f, e, k))
  for (i, face) in faces.enumerate() {
    hatch(face, reverse: calc.rem(i, 2) == 0)
  }
  line(a, h, g, f, e, d, c, b, close: true)
  line(a, c, j)
  line(g, d)
  line(g, k)
  for (start, end) in (
    (a, h),
    (h, g),
    (g, f),
    (f, e),
    (e, k),
    (k, d),
    (d, c),
    (c, b),
    (b, a),
  ) { arrow(start, end, offset: -1.6, length: 5) }
  arrow(a, c, offset: -0.7, length: 4, at: 0.2)
  arrow(k, g, offset: 1.2, length: 4, at: 0.6)
  arrow(g, k, offset: 1.2, length: 4, at: 0.7)
})

#let self-intersecting-polygon() = cetz.canvas(length: 1mm, {
  import cetz.draw: *
  style()
  let a0 = (45, 3)
  let a1 = (8, 34)
  let a2 = (14, 10)
  let a3 = (22, 35)
  let a4 = (0, 8)
  let a5 = (20, 13)
  let a6 = (8, -11)
  let a7 = intersection(a5, a6, a0, add(a0, (-1, 0)))
  let b = intersection(a0, a1, a2, a3)
  line(a0, b, a3, a4, a5, a7, a0)
  line(b, a1, a2, b, stroke: (dash: "dashed"))
  line(a7, a6, stroke: (dash: "dashed"))
  for point in (a3, a4, a5, a6, a7) {
    circle(point, radius: 0.4, fill: white)
  }
  for (point, label, anchor) in (
    (a0, $A_0$, "west"),
    (a1, $A_1$, "south"),
    (a2, $A_2$, "north-east"),
    (a3, $A_3$, "south"),
    (a4, $A_4$, "east"),
    (a5, $A_5$, "west"),
    (a6, $A_6$, "north"),
    (a7, $A_7$, "north-west"),
    (a7, $C$, "east"),
    (add(b, (1, 1.5)), $B$, "west"),
  ) { content(point, label, anchor: anchor) }
})
