#import "@preview/cetz:0.5.2"

#let sum-point(a, b) = (a.at(0) + b.at(0), a.at(1) + b.at(1))
#let times-point(a, t) = (a.at(0) * t, a.at(1) * t)
#let dot-point(a, b) = a.at(0) * b.at(0) + a.at(1) * b.at(1)
#let polar-point(radius, angle) = (
  radius * calc.cos(angle),
  radius * calc.sin(angle),
)

#let bezier-point(a, b, c, d, t) = sum-point(
  sum-point(times-point(a, (1 - t) * (1 - t) * (1 - t)), times-point(
    c,
    3 * (1 - t) * (1 - t) * t,
  )),
  sum-point(times-point(d, 3 * (1 - t) * t * t), times-point(b, t * t * t)),
)

// A closed cardinal curve is specified by a small set of defining knots.
#let smooth-boundary(knots, samples: 16) = {
  let result = ()
  let count = knots.len()
  for j in range(count) {
    let a = knots.at(calc.rem(j - 1 + count, count))
    let b = knots.at(j)
    let c = knots.at(calc.rem(j + 1, count))
    let d = knots.at(calc.rem(j + 2, count))
    for q in range(samples) {
      let t = q / samples
      result.push((0, 1).map(k => (
        0.5
          * (
            2 * b.at(k)
              + (-a.at(k) + c.at(k)) * t
              + (2 * a.at(k) - 5 * b.at(k) + 4 * c.at(k) - d.at(k)) * t * t
              + (-a.at(k) + 3 * b.at(k) - 3 * c.at(k) + d.at(k)) * t * t * t
          )
      )))
    }
  }
  result
}

#let inside-boundary(points, p) = {
  let inside = false
  for j in range(points.len()) {
    let a = points.at(j)
    let b = points.at(calc.rem(j + 1, points.len()))
    if (a.at(1) > p.at(1)) != (b.at(1) > p.at(1)) {
      if (
        p.at(0)
          < a.at(0)
            + (b.at(0) - a.at(0)) * (p.at(1) - a.at(1)) / (b.at(1) - a.at(1))
      ) {
        inside = not inside
      }
    }
  }
  inside
}

#let cross-point(a, b) = a.at(0) * b.at(1) - a.at(1) * b.at(0)
#let meets-segment(a, b, c, d) = {
  let ab = sum-point(b, times-point(a, -1))
  let cd = sum-point(d, times-point(c, -1))
  let ca = sum-point(c, times-point(a, -1))
  let den = cross-point(ab, cd)
  if calc.abs(den) < 0.0000001 { false } else {
    let t = cross-point(ca, cd) / den
    let u = cross-point(ca, ab) / den
    0 <= t and t <= 1 and 0 <= u and u <= 1
  }
}

#let contains-box(points, low, high) = {
  let corners = (low, (high.at(0), low.at(1)), high, (low.at(0), high.at(1)))
  (
    corners.all(p => inside-boundary(points, p))
      and not range(points.len()).any(j => range(4).any(k => meets-segment(
        points.at(j),
        points.at(calc.rem(j + 1, points.len())),
        corners.at(k),
        corners.at(calc.rem(k + 1, 4)),
      )))
  )
}

// Pair all intersections; this also hatches nonconvex stepped polygons.
#let hatch-boundary(points, direction: (1, 1), step: 1.3) = {
  import cetz.draw: line
  let size = calc.sqrt(dot-point(direction, direction))
  let tangent = times-point(direction, 1 / size)
  let normal = (-tangent.at(1), tangent.at(0))
  let values = points.map(p => dot-point(p, normal))
  let start = calc.floor(calc.min(..values) / step)
  let stop = calc.ceil(calc.max(..values) / step)
  for k in range(start, stop + 1) {
    let offset = k * step
    let hits = ()
    for j in range(points.len()) {
      let a = points.at(j)
      let b = points.at(calc.rem(j + 1, points.len()))
      let va = dot-point(a, normal)
      let vb = dot-point(b, normal)
      if (va <= offset and offset < vb) or (vb <= offset and offset < va) {
        let t = (offset - va) / (vb - va)
        hits.push(sum-point(times-point(a, 1 - t), times-point(b, t)))
      }
    }
    hits = hits.sorted(key: p => dot-point(p, tangent))
    for j in range(0, hits.len() - 1, step: 2) {
      line(hits.at(j), hits.at(j + 1), stroke: 0.32pt)
    }
  }
}

#let boundary-ticks(points, inward: true, spacing: 1.4, depth: 0.9) = {
  import cetz.draw: line
  let distance = 0.0
  let next = spacing / 2
  for j in range(points.len()) {
    let a = points.at(j)
    let b = points.at(calc.rem(j + 1, points.len()))
    let v = sum-point(b, times-point(a, -1))
    let length = calc.sqrt(dot-point(v, v))
    while next < distance + length {
      let p = sum-point(a, times-point(v, (next - distance) / length))
      let normal = (-v.at(1) / length, v.at(0) / length)
      let test = sum-point(p, times-point(normal, 0.01))
      if inside-boundary(points, test) != inward {
        normal = times-point(normal, -1)
      }
      line(
        p,
        sum-point(p, sum-point(times-point(normal, depth), times-point(
          v,
          0.3 / length,
        ))),
        stroke: 0.32pt,
      )
      next += spacing
    }
    distance += length
  }
}

#let diagram-style() = {
  import cetz.draw: set-style
  set-style(
    stroke: 0.5pt,
    content: (
      padding: 0.03,
      wrap: text.with(top-edge: "bounds", bottom-edge: "bounds"),
    ),
    mark: (scale: 0.6, transform-shape: false),
  )
}

#let runge-grid() = cetz.canvas(length: 4.3mm, {
  import cetz.draw: *
  diagram-style()
  let left = smooth-boundary((
    (0.4, 7.2),
    (1.1, 7.6),
    (1.5, 6.7),
    (0.6, 5.2),
    (0.6, 4.3),
    (1.4, 3.6),
    (2.7, 4.3),
    (4, 4.5),
    (4.9, 4.5),
    (5.4, 5),
    (5.8, 6.5),
    (6.6, 7.1),
    (8, 7.6),
    (8.7, 8.5),
    (8.6, 10),
    (7.7, 11.5),
    (6.4, 12.6),
    (5.5, 12.8),
    (4.5, 12.5),
    (3.5, 11.7),
    (2.8, 10.7),
    (2.1, 9.2),
    (1.3, 8.5),
  ))
  let right = smooth-boundary((
    (8.5, 4.7),
    (8.7, 3.6),
    (10.2, 2.6),
    (12, 2),
    (14, 2),
    (16, 2.6),
    (16.6, 3.7),
    (16.3, 4.8),
    (15.4, 5.3),
    (13.9, 5.2),
    (13.6, 5.8),
    (13.9, 6.8),
    (14.6, 7.8),
    (14.3, 8.4),
    (13.2, 8.7),
    (11.8, 8.6),
    (10.4, 8),
    (9.4, 6.9),
    (8.7, 5.7),
  ))
  // Erode by the eight adjacent squares, exactly as in the text.
  let selected = ()
  for x in range(17) {
    for y in range(14) {
      if (left, right).any(p => contains-box(
        p,
        (x - 1, y - 1),
        (x + 2, y + 2),
      )) {
        selected.push((x, y))
      }
    }
  }
  assert(
    selected
      == (
        (3, 6),
        (3, 7),
        (4, 8),
        (4, 9),
        (5, 9),
        (5, 10),
        (6, 9),
        (11, 4),
        (11, 5),
      ),
  )
  for (x, y) in selected {
    hatch-boundary(((x, y), (x + 1, y), (x + 1, y + 1), (x, y + 1)), step: 0.15)
  }
  for x in range(18) { line((x, -0.3), (x, 14.3), stroke: 0.3pt) }
  for y in range(15) { line((-0.3, y), (17.4, y), stroke: 0.3pt) }
  line(..left, close: true, stroke: 0.7pt)
  line(..right, close: true, stroke: 0.7pt)
  for (p, label) in (
    ((2.4, 8.3), $O$),
    ((9.4, 5.5), $O$),
    ((5.5, 9.5), $O'$),
    ((3.5, 7), $O'$),
    ((11.5, 5), $O'$),
  ) {
    content(p, label, frame: "rect", fill: white, stroke: none)
  }
})

#let runge-moving-poles() = cetz.canvas(length: 1mm, {
  import cetz.draw: *
  diagram-style()
  let inner = (
    (0, 21),
    (34, 21),
    (34, 7),
    (44, 7),
    (44, -10),
    (23, -10),
    (23, -2),
    (14, -2),
    (14, 11),
    (0, 11),
  )
  let outer = (
    (-4, 7),
    (-4, 24),
    (1, 24),
    (1, 29),
    (17, 29),
    (17, 34),
    (23, 34),
    (23, 29),
    (38, 29),
    (38, 34),
    (43, 34),
    (43, 14),
    (51, 14),
    (51, -14),
    (20, -14),
    (20, -8),
    (12, -8),
    (12, 7),
  )
  hatch-boundary(inner)
  line(..inner, close: true)
  line(..outer, close: true)
  let top = (43, 25.5)
  let bottom = (51, -7)
  let endpoint = (85, 6.5)
  bezier(top, endpoint, (58, 7), (73, 13))
  bezier(bottom, endpoint, (60, -19), (72, 4))
  for p in (top, bottom, endpoint) { circle(p, radius: 0.55, fill: white) }
  content((26, 8), $overline(O)_n$)
  content((-0.2, 3.2), $Gamma_(n+1)$)
  content(sum-point(top, (1, 1.4)), $zeta_k^((n+1))$, anchor: "south-west")
  content(
    sum-point(bottom, (1, 1.2)),
    $zeta_(k')^((n+1))$,
    anchor: "south-west",
  )
  content(sum-point(endpoint, (1.5, 0)), $frak(z)$, anchor: "west")
})

#let runge-cuts() = cetz.canvas(length: 1mm, {
  import cetz.draw: *
  diagram-style()
  let left = smooth-boundary((
    (-48, -8),
    (-47, 0),
    (-37, 11),
    (-24, 17),
    (-7, 21),
    (3, 20),
    (4, 16),
    (1, 9),
    (12, 8),
    (16, 2),
    (14, -5),
    (3, -8),
    (-13, -8),
    (-29, -11),
    (-41, -13),
  ))
  let right = smooth-boundary((
    (39, -10),
    (39, 0),
    (44, 12),
    (53, 17),
    (61, 15),
    (62, 9),
    (56, 3),
    (53, -4),
    (50, -11),
    (44, -13),
  ))
  let hole-a = smooth-boundary((
    (-32, -6),
    (-32, -2),
    (-26, 3),
    (-19, 3),
    (-18, -1),
    (-23, -6),
    (-29, -8),
  ))
  let hole-b = smooth-boundary((
    (-10, -4),
    (-11, 0),
    (-7, 3),
    (2, 3),
    (6, 1),
    (5, -3),
    (-1, -4),
  ))
  let hole-c = smooth-boundary((
    (43, -8),
    (43, -3),
    (44, 0),
    (47, 1),
    (50, 1),
    (50, -4),
    (48, -8),
    (45, -9),
  ))
  for p in (left, right) {
    line(..p, close: true)
    boundary-ticks(p)
  }
  for p in (hole-a, hole-b, hole-c) {
    line(..p, close: true)
    boundary-ticks(p, inward: false)
  }
  // A compact set P with the attached branches shown in the original.
  let blob-a = smooth-boundary((
    (-15, 13),
    (-9, 17),
    (-3, 18),
    (0, 16),
    (-3, 14),
    (-9, 13),
  ))
  let blob-b = smooth-boundary((
    (48, 10),
    (50, 13),
    (55, 14),
    (58, 12),
    (57, 10),
    (52, 11),
  ))
  line(..blob-a, close: true, fill: black, stroke: none)
  line(..blob-b, close: true, fill: black, stroke: none)
  bezier((-15, 13), (-40, -4), (-33, 6), (-38, 1), stroke: 0.8pt)
  bezier((-15, 13), (-17, -6), (-22, 7), (-9, -1), stroke: 0.8pt)
  bezier((-9, 6), (10, 0), (-4, 6), (4, 5), stroke: 0.8pt)
  let left-fork = bezier-point((-15, 13), (-40, -4), (-33, 6), (-38, 1), 0.45)
  bezier(left-fork, (-36, -6), (-34, 0), (-35, -2), stroke: 0.8pt)
  let stem-fork = bezier-point((-15, 13), (-17, -6), (-22, 7), (-9, -1), 0.4)
  bezier(stem-fork, (-9, 6), (-15.5, 5.8), (-12, 5.6), stroke: 0.8pt)
  let right-fork = bezier-point((-9, 6), (10, 0), (-4, 6), (4, 5), 0.4)
  bezier(right-fork, (-12.5, -3), (-11, 5), (-14, 0), stroke: 0.8pt)
  bezier((56, 12), (41, 1), (57, 4), (44, 4), stroke: 0.8pt)
  bezier((56, 12), (51, 0), (61, 9), (55, 4), stroke: 0.8pt)
  let endpoint = (39, 0)
  let starts = ((12, 8), (5, -3), (-29, -8), (44, 0))
  bezier(starts.at(0), endpoint, (28, 9), (36, 6), stroke: (dash: "dashed"))
  bezier(starts.at(1), endpoint, (16, -15), (24, 6), stroke: (dash: "dashed"))
  bezier(starts.at(2), endpoint, (-38, -27), (20, -20), stroke: (
    dash: "dashed",
  ))
  line(starts.at(3), endpoint, stroke: (dash: "dashed"))
  for p in starts + (endpoint,) { circle(p, radius: 0.55, fill: white) }
  for (p, label) in (
    ((11, 11), $zeta_1$),
    ((7, -2), $zeta_2$),
    ((-30, -10), $zeta_3$),
    ((37.5, -2), $zeta_p$),
    ((48, -2), $zeta_(p-1)$),
    ((28, 6.3), $gamma_1$),
    ((21, -4.3), $gamma_2$),
    ((-3, -18), $gamma_3$),
    ((40.5, 4.2), $gamma_(p-1)$),
    ((30, 17), $G$),
    ((-34, -7.5), $O'$),
    ((41, 8), $O'$),
    ((-8, 11), $P$),
    ((-15, -3.5), $P$),
    ((53, 8.5), $P$),
  ) {
    content(p, label)
  }
})

#let runge-rectangles() = cetz.canvas(length: 42mm, {
  import cetz.draw: *
  diagram-style()
  // One unit cell; all widths and gaps follow the author's n-dependent data.
  let n-size = 3
  let a = 1 / (3 * n-size)
  let rectangles = ((a, a, 1 - a, 1 - a),)
  for x in (0, 1) {
    for y in (0, 1) {
      rectangles.push((x - a / 2, y - a / 2, x + a / 2, y + a / 2))
    }
    rectangles.push((a, x - a / 2, 1 - a, x + a / 2))
    rectangles.push((x - a / 2, a, x + a / 2, 1 - a))
  }
  assert(rectangles.len() == 9)
  for (x0, y0, x1, y1) in rectangles {
    let boundary = ((x0, y0), (x1, y0), (x1, y1), (x0, y1))
    hatch-boundary(boundary, direction: (1, -1), step: 0.027)
    line(..boundary, close: true)
  }
  line((0, 0), (1, 0), (1, 1), (0, 1), close: true, stroke: (
    thickness: 0.35pt,
    dash: "dashed",
  ))
  let arrow = (symbol: ">", fill: black)
  // Long dimensions have their filled tips at the outer extension lines.
  for x in (a, 1 - a) { line((x, 1 - a), (x, 1.14), stroke: 0.3pt) }
  line((a, 1.12), (0.39, 1.12), mark: (start: arrow))
  line((0.63, 1.12), (1 - a, 1.12), mark: (end: arrow))
  content((0.51, 1.12), $1-2/(3n)$)
  for y in (a, 1 - a) { line((1 - a, y), (1.18, y), stroke: 0.3pt) }
  line((1.12, a), (1.12, 0.39), mark: (start: arrow))
  line((1.12, 0.63), (1.12, 1 - a), mark: (end: arrow))
  content((1.12, 0.51), $1-2/(3n)$, angle: 90deg)
  // Short dimensions: both heads are outside the measured interval.
  for x in (0, 1) {
    for side in (-1, 1) {
      let end-x = x + side * a / 2
      line((end-x, -a / 2), (end-x, -0.19), stroke: 0.3pt)
      line((end-x + side * 0.065, -0.17), (end-x, -0.17), mark: (end: arrow))
    }
    content((x, -0.20), $1/(3n)$, anchor: "north")
  }
  for (y0, y1) in ((a / 2, a), (1 - a, 1 - a / 2)) {
    for (y, side) in ((y0, -1), (y1, 1)) {
      line((1 + a / 2, y), (1.22, y), stroke: 0.3pt)
      line((1.19, y + side * 0.06), (1.19, y), mark: (end: arrow))
    }
    content((1.22, (y0 + y1) / 2), $1/(6n)$, anchor: "west")
  }
})

#let runge-radial-sectors() = cetz.canvas(length: 1mm, {
  import cetz.draw: *
  diagram-style()
  let unit = 29
  let radii = (0.25, 0.45, 0.70, 0.76, 0.79, 0.85, 0.88, 0.93, 0.96).map(r => (
    unit * r
  ))
  assert(radii.windows(2).all(pair => pair.at(0) < pair.at(1)))
  let disk = range(160).map(j => polar-point(radii.at(0), j * 360deg / 160))
  hatch-boundary(disk, direction: (0, 1), step: 0.65)
  line(..disk, close: true)
  for n in (1, 2) {
    for (inner-index, outer-index, start, stop) in (
      (4 * n - 3, 4 * n - 2, -135deg, 135deg),
      (4 * n - 1, 4 * n, 45deg, 315deg),
    ) {
      let inner-size = radii.at(inner-index)
      let outer-size = radii.at(outer-index)
      let outside = range(145).map(j => polar-point(
        outer-size,
        start + (stop - start) * j / 144,
      ))
      let inside = range(145).map(j => polar-point(
        inner-size,
        stop - (stop - start) * j / 144,
      ))
      let boundary = outside + inside
      hatch-boundary(boundary, direction: (0, 1), step: 0.65)
      line(..boundary, close: true)
    }
  }
  circle((0, 0), radius: unit)
  for angle in (45deg, 135deg) {
    line(polar-point(unit, angle), polar-point(unit, angle + 180deg), stroke: (
      thickness: 0.35pt,
      dash: "dashed",
    ))
  }
  for (p, label) in (
    ((0, -3.5), $0$),
    ((0, 3.5), $B_0$),
    ((0, 16), $B_1$),
    ((18.1, 13.1), $B_1$),
    ((20.7, 7.1), $B_2$),
    ((-27, 17), $B_2$),
  ) {
    content(p, label, frame: "rect", fill: white, stroke: none)
  }
  line((-25.3, 16), polar-point((radii.at(7) + radii.at(8)) / 2, 145deg))
  let first-end = polar-point((radii.at(3) + radii.at(4)) / 2, 45deg)
  line(first-end, sum-point(first-end, (1, -1)))
  let second-inner = polar-point(radii.at(5), 22deg)
  line(second-inner, sum-point(second-inner, (-1, -1)))
})
