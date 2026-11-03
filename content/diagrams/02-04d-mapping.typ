#import "@preview/cetz:0.5.2"

#let add(a, b) = a.zip(b).map(((x, y)) => x + y)
#let mul(a, k) = a.map(x => k * x)
#let polar(r, a) = (r * calc.cos(a), r * calc.sin(a))
#let product(a, b) = (
  a.at(0) * b.at(0) - a.at(1) * b.at(1),
  a.at(0) * b.at(1) + a.at(1) * b.at(0),
)
#let quotient(a, b) = mul(
  product(a, (b.at(0), -b.at(1))),
  1 / (b.at(0) * b.at(0) + b.at(1) * b.at(1)),
)
#let joukowski(z) = mul(add(z, quotient((1, 0), z)), 0.5)
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
  if xname != none {
    cetz.draw.content((xmax, 0), xname, anchor: "north")
  }
  if yname != none {
    cetz.draw.content((0, ymax), yname, anchor: "east")
  }
}
#let open-point(p, label, anchor: "north", label-offset: (0, 0)) = {
  cetz.draw.circle(p, radius: 0.45, fill: white)
  cetz.draw.content(add(p, label-offset), label, anchor: anchor)
}
#let hatch-caption(p, body, anchor: "center") = cetz.draw.content(
  p,
  body,
  anchor: anchor,
  frame: "rect",
  fill: white,
  stroke: none,
  padding: 0.18,
)
#let hatch(vertices, reverse: false, step: 1.3) = {
  // Pair all intersections, so nonconvex circular lunes are also filled.
  // The half-open edge convention counts a shared vertex only as needed.
  let polygon-hatch(vertices) = {
    let offsets = vertices.map(p => p.at(1) - p.at(0))
    let first = calc.floor(calc.min(..offsets) / step)
    let last = calc.ceil(calc.max(..offsets) / step)
    for k in range(first, last + 1) {
      let c = k * step
      let hits = ()
      for i in range(vertices.len()) {
        let a = vertices.at(i)
        let b = vertices.at(calc.rem(i + 1, vertices.len()))
        let da = a.at(1) - a.at(0)
        let db = b.at(1) - b.at(0)
        if (da <= c and c < db) or (db <= c and c < da) {
          let t = (c - da) / (db - da)
          hits.push(add(a, mul(add(b, mul(a, -1)), t)))
        }
      }
      hits = hits.sorted(key: p => p.at(0))
      assert(calc.rem(hits.len(), 2) == 0)
      for i in range(0, hits.len(), step: 2) {
        cetz.draw.line(hits.at(i), hits.at(i + 1), stroke: 0.2pt)
      }
    }
  }
  if reverse {
    cetz.draw.scope({
      cetz.draw.scale(x: -1)
      polygon-hatch(vertices.map(p => (-p.at(0), p.at(1))))
    })
  } else { polygon-hatch(vertices) }
}

#let joukowski-grid() = cetz.canvas(length: 1mm, {
  import cetz.draw: *
  style()
  let r = 17
  let radii = (0.27, 0.48, 0.70)
  for factor in radii + (1,) { circle((0, 0), radius: r * factor) }
  for k in range(16) { line((0, 0), polar(r, k * 22.5deg)) }
  axes(-r - 4, r + 7, -r - 5, r + 10, $x$, $y$)
  line((0, 0), (-5.1, -17.3), stroke: 0.25pt)
  content((-6, -20), $O$)
  content((r + 3, r + 6), $(z)$)
  content(polar(r, -65deg), $gamma$, anchor: "north")
  content(polar(0.59 * r, -11.25deg), $g$)
  for (angle, extra, gap, label) in (
    (45deg, 3, 18deg, $alpha$),
    (135deg, 6, 32deg, $pi - alpha$),
  ) {
    let radius = r + extra
    line(polar(r, angle), polar(radius, angle), stroke: (dash: "dashed"))
    arc(
      (0, 0),
      start: 0deg,
      delta: (angle - gap) / 2,
      radius: radius,
      anchor: "origin",
      mark: (start: "stealth"),
    )
    arc(
      (0, 0),
      start: (angle + gap) / 2,
      delta: (angle - gap) / 2,
      radius: radius,
      anchor: "origin",
      mark: (end: "stealth"),
    )
    content(polar(radius, angle / 2), label)
  }

  scope({
    translate((55, 0))
    let scale = 8.4
    for radius in radii {
      let points = range(129).map(j => mul(
        joukowski(
          polar(radius, j * 360deg / 128),
        ),
        scale,
      ))
      line(..points)
    }
    for k in (1, 2, 3, 5, 6, 7) {
      let angle = k * 22.5deg
      for sign in (-1, 1) {
        let points = range(81)
          .map(j => {
            let t = 0.99 - 0.82 * j / 80
            mul(joukowski(polar(t, sign * angle)), scale)
          })
          .filter(p => calc.abs(p.at(0)) <= 25 and calc.abs(p.at(1)) <= 24)
        line(..points)
      }
    }
    axes(-27, 30, -26, 28, $u$, $v$)
    line((-scale, 0), (scale, 0), stroke: 0.9pt)
    for focus in (-scale, scale) { line((focus, -0.6), (focus, 0.6)) }
    content((-1.7, 4.8), $O$)
    content((-scale - 2.47, 3.09), $-1$, anchor: "south")
    content((scale + 1.77, 2.39), $1$, anchor: "south")
    content((1.7, -4.8), $Gamma$)
    content((13, 18), $G$)
    content((23, 26), $(w)$)
  })
})

#let circle-arc-image() = cetz.canvas(length: 1mm, {
  import cetz.draw: *
  style()
  let unit = 11
  let theta = 35deg
  let center = 1 / calc.tan(theta)
  let radius = calc.sqrt(1 + center * center)
  circle((0, unit * center), radius: unit * radius)
  axes(-24, 24, -8, 39, $x$, $y$)
  content((21, 36), $(z)$)
  open-point((0, unit * center), [])
  open-point((-unit, 0), $-1$, label-offset: (-1.5, -1.5))
  open-point((unit, 0), $1$)
  let direction = polar(1, theta)
  line((unit, 0), add((unit, 0), mul(direction, 13)), mark: (end: "stealth"))
  cetz.angle.angle(
    (unit, 0),
    (unit + 12, 0),
    add((unit, 0), mul(direction, 12)),
    radius: 7,
    label: $#sym.theta$,
    label-radius: 145%,
    mark: (start: "stealth", end: "stealth"),
  )
  content(
    (unit * radius * 0.78 + 2, unit * (center + radius * 0.63) + 1),
    $gamma$,
  )
  content((3, unit * (center - radius) - 1), $gamma$, anchor: "north")

  scope({
    translate((57, 0))
    // The image arc is the circle through -1,+1 and J(i(h+sqrt(1+h²)))=ih.
    let image-center = (center * center - 1) / (2 * center)
    let image-radius = calc.sqrt(1 + image-center * image-center)
    circle(
      (0, unit * image-center),
      radius: unit * image-radius,
      stroke: 0.25pt,
    )
    arc-through((-unit, 0), (0, unit * center), (unit, 0), stroke: 0.6pt)
    axes(-18, 22, -11, 28, $u$, $v$)
    content((21, 26), $(w)$)
    open-point((0, unit * image-center), [])
    open-point((-unit, 0), $-1$, label-offset: (-1.5, -2))
    open-point((unit, 0), $1$, label-offset: (1.5, -2))
    let direction = polar(1, 2 * theta)
    line((unit, 0), add((unit, 0), mul(direction, 14)), mark: (end: "stealth"))
    cetz.angle.angle(
      (unit, 0),
      (unit + 12, 0),
      add((unit, 0), mul(direction, 12)),
      radius: 7,
      label: $2 #sym.theta$,
      label-radius: 145%,
      mark: (start: "stealth", end: "stealth"),
    )
    content((3, unit * center + 1), $delta$, anchor: "south")
  })
})

#let halfplane-image() = cetz.canvas(length: 1mm, {
  import cetz.draw: *
  style()
  let r = 18
  let upper = range(49).map(j => polar(r, j * 180deg / 48))
  hatch(((-23, 0), (23, 0), (23, 24), (-23, 24)))
  hatch(upper, reverse: true)
  circle((0, 0), radius: r)
  axes(-25, 27, -23, 29, $x$, $y$)
  open-point((-r, 0), $-1$, label-offset: (-2.5, -1.5))
  open-point((r, 0), $1$, label-offset: (2.5, -1.5))
  hatch-caption((7, 7), $k_1$)
  content((7, -8), $k_2$)
  hatch-caption((20, 17), $K_2$)
  scope({
    translate((60, 0))
    hatch(((-23, 0), (23, 0), (23, 24), (-23, 24)))
    hatch(((-23, -18), (23, -18), (23, 0), (-23, 0)))
    hatch(((-23, -18), (23, -18), (23, 0), (-23, 0)), reverse: true)
    axes(-25, 27, -23, 29, $u$, $v$)
    hatch-caption((-18, -1), $-1$, anchor: "north")
    hatch-caption((18, -1), $1$, anchor: "north")
    line((-23, 0), (-18, 0), stroke: 0.85pt)
    line((18, 0), (23, 0), stroke: 0.85pt)
  })
})

#let tangent-relief() = cetz.canvas(length: 1mm, {
  import cetz.draw: *
  style()
  let limit = 4.2
  // |tan(x+iy)|²=(cosh(2y)-cos(2x))/(cosh(2y)+cos(2x)).
  let surface(x, y) = {
    let hyperbolic = (calc.exp(2 * y) + calc.exp(-2 * y)) / 2
    let denominator = hyperbolic + calc.cos(2 * x * 1rad)
    if denominator <= 0 { none } else {
      calc.sqrt(
        (hyperbolic - calc.cos(2 * x * 1rad)) / denominator,
      )
    }
  }
  // Only the displayed solid is cut; none denotes a pole of the function.
  let height(x, y) = {
    let value = surface(x, y)
    if value == none { limit } else { calc.min(limit, value) }
  }
  let project(x, y, z) = (17 * x + 10 * y, 7 * y + 13 * z)
  let nx = 54
  let ny = 48
  // Display an L-shaped portion, leaving the zero visible in its cutout.
  let xmin = -calc.pi
  let xmax = calc.pi / 2
  let ymax = 1.65
  let vertex(i, j) = {
    let x = xmin + (xmax - xmin) * i / nx
    let y = -ymax + 2 * ymax * j / ny
    let z = height(x, y)
    (point: project(x, y, z), depth: 130 * x - 221 * y + 119 * z)
  }
  let cells = ()
  for i in range(nx) {
    for j in range(ny) {
      if i >= 36 and j < ny / 2 { continue }
      let vertices = ((i, j), (i + 1, j), (i + 1, j + 1), (i, j + 1)).map((
        (i, j),
      ) => vertex(i, j))
      cells.push((
        vertices: vertices.map(it => it.point),
        depth: vertices.map(it => it.depth).sum() / 4,
      ))
    }
  }
  // Test a section point against the exact roof along the viewing ray.
  let visible(x, y, level) = {
    let hyperbolic = (calc.exp(2 * y) + calc.exp(-2 * y)) / 2
    let sine-h = (calc.exp(2 * y) - calc.exp(-2 * y)) / 2
    let cosine = calc.cos(2 * x * 1rad)
    let denominator = level * calc.pow(hyperbolic + cosine, 2)
    let dx = 2 * hyperbolic * calc.sin(2 * x * 1rad) / denominator
    let dy = 2 * cosine * sine-h / denominator
    if 119 - 130 * dx + 221 * dy <= 0 { false } else {
      let far = calc.min((xmax - x) / 130, (y + ymax) / 221)
      far = calc.min(far, calc.max(-x / 130, y / 221))
      let clear = true
      for j in range(1, 65) {
        let t = far * j / 64
        if height(x + 130 * t, y - 221 * t) > level + 119 * t + 0.000001 {
          clear = false
          break
        }
      }
      clear
    }
  }
  let label-ends = ()
  let sections = ()
  for level in (1, 2, 3, 4) {
    let label-end = none
    let curves = if level == 1 {
      (-3 * calc.pi / 4, -calc.pi / 4).map(x => range(129).map(j => (
        x,
        -ymax + 2 * ymax * j / 128,
      )))
    } else {
      let q = (level * level - 1) / (level * level + 1)
      let reach = 0.5 * calc.ln((level + 1) / (level - 1))
      (
        range(257).map(j => {
          let angle = j * 360deg / 256
          let y = reach * calc.sin(angle)
          let hyperbolic = (calc.exp(2 * y) + calc.exp(-2 * y)) / 2
          let delta = 0.5 * calc.acos(calc.min(1, q * hyperbolic)) / 1rad
          let sign = if calc.cos(angle) >= 0 { 1 } else { -1 }
          (-calc.pi / 2 + sign * delta, y)
        }),
      )
    }
    for curve in curves {
      let shown = curve.map(((x, y)) => visible(x, y, level))
      for ((x, y), is-visible) in curve.zip(shown) {
        if is-visible {
          let p = project(x, y, level)
          if label-end == none or p.at(0) < label-end.at(0) {
            label-end = p
          }
        }
      }
      for j in range(curve.len() - 1) {
        if not shown.at(j) or not shown.at(j + 1) { continue }
        let ends = curve.slice(j, j + 2)
        sections.push(ends.map(((x, y)) => project(x, y, level)))
      }
    }
    assert(label-end != none)
    label-ends.push((level, label-end))
  }
  // The drawing's pedestal lies below the zero of the function.
  // The front and right curtains do not alter the surface or its domain.
  let pedestal = -0.55
  let wall(side) = {
    let points = range(121).map(j => {
      let t = j / 120
      if side == "front" {
        (xmin - xmin * t, -ymax)
      } else if side == "inner" {
        (0, -ymax + ymax * t)
      } else if side == "real" {
        (xmax * t, 0)
      } else { (xmax, ymax * t) }
    })
    let roof = points.map(((x, y)) => project(x, y, height(x, y)))
    let base = points.map(((x, y)) => project(x, y, pedestal))
    line(..roof, ..base.rev(), close: true, fill: white, stroke: 0.4pt)
    for (x, y) in points {
      line(project(x, y, pedestal), project(x, y, height(x, y)), stroke: 0.2pt)
    }
  }
  for cell in cells.sorted(key: it => it.depth) {
    line(..cell.vertices, close: true, fill: white, stroke: 0.18pt)
  }
  for section in sections { line(..section, stroke: 0.5pt) }
  wall("right")
  wall("real")
  wall("inner")
  wall("front")
  // The three boundary/central curves carry their original function names.
  let real-curve = range(161).map(j => {
    let x = xmax * j / 160
    project(x, 0, height(x, 0))
  })
  let middle = range(81).map(j => {
    let y = -ymax + ymax * j / 80
    project(0, y, height(0, y))
  })
  let side = range(81).map(j => {
    let y = ymax * j / 80
    project(xmax, y, height(xmax, y))
  })
  line(..real-curve, stroke: 0.55pt)
  line(..middle, stroke: 0.55pt)
  line(..side, stroke: 0.55pt)
  content(project(0, -0.7, pedestal), $op("th")$, anchor: "north")
  let real-mark = calc.atan(2.5) / 1rad
  content(
    project(real-mark, 0, height(real-mark, 0)),
    $op("tg")$,
    anchor: "east",
  )
  content(project(xmax, 0.35, height(xmax, 0.35)), $op("cth")$, anchor: "west")
  // Place each number beside its own level, outside the dense mesh.
  for (level, endpoint) in label-ends {
    if level == 1 {
      content(add(project(-calc.pi / 4, ymax, 1), (0, 1)), $1$, anchor: "south")
    } else {
      content(add(endpoint, (-1, 0)), $#level$, anchor: "east")
    }
  }
})

#let tangent-strip-lune() = cetz.canvas(length: 1mm, {
  import cetz.draw: *
  style()
  let x0 = 0.25
  let h = 0.60
  let scale = 21
  hatch((
    (scale * x0, -29),
    (scale * (x0 + h), -29),
    (scale * (x0 + h), 29),
    (scale * x0, 29),
  ))
  line((scale * x0, -29), (scale * x0, 29))
  line((scale * (x0 + h), -29), (scale * (x0 + h), 29))
  axes(-10, 30, -29, 32, none, none)
  content((scale * x0, 0), $x_0$, anchor: "south-east")
  content((scale * (x0 + h), 0), $x_0 + h$, anchor: "south-west")
  hatch-caption((scale * (x0 + h / 2), 18), $g$)
  content((24, 29), $(z)$)
  scope({
    translate((57, 0))
    let theta1 = 2 * x0 * 1rad
    let theta2 = 2 * (x0 + h) * 1rad
    let image(t, theta) = {
      if t == 0 { (0, 1) } else if t == 1 { (0, -1) } else {
        let z = polar(calc.tan(t * 90deg), theta)
        product((0, -1), quotient(add(z, (-1, 0)), add(z, (1, 0))))
      }
    }
    let first = range(81).map(j => mul(image(j / 80, theta1), scale))
    let second = range(81).map(j => mul(image(j / 80, theta2), scale))
    hatch(first + second.rev().slice(1))
    line(..first)
    line(..second)
    axes(-4, 29, -26, 29, none, none)
    content((25, 27), $(w)$)
    hatch-caption((11, 8), $G$)
    content((0, scale), $i$, anchor: "east")
    content((0, -scale), $-i$, anchor: "east")
    let origin = (0, -scale)
    let lower = add(origin, polar(13, 90deg - theta2))
    let upper = add(origin, polar(13, 90deg - theta1))
    line(origin, lower, stroke: (dash: "dashed"), mark: (end: "stealth"))
    line(origin, upper, stroke: (dash: "dashed"), mark: (end: "stealth"))
    cetz.angle.angle(
      origin,
      lower,
      upper,
      radius: 8,
      name: "lune-opening",
      label-radius: 140%,
      mark: (start: "stealth", end: "stealth"),
    )
    hatch-caption("lune-opening.label", $2 h$)
  })
})
