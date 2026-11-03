#import "@preview/cetz:0.5.2"

#let polar(radius, angle) = (
  radius * calc.cos(angle),
  radius * calc.sin(angle),
)
#let add(a, b) = a.zip(b).map(((x, y)) => x + y)
#let sub(a, b) = a.zip(b).map(((x, y)) => x - y)
#let mul(a, factor) = a.map(x => factor * x)
#let norm(a) = calc.sqrt(a.map(x => x * x).sum())
#let styles() = {
  cetz.draw.set-style(
    stroke: 0.5pt,
    content: (
      padding: 1,
      wrap: text.with(top-edge: "bounds", bottom-edge: "bounds"),
    ),
    mark: (scale: 0.65, transform-shape: false),
  )
}
#let point(at) = cetz.draw.circle(at, radius: 0.55, fill: white)

// The displayed domain is the union of a circular collar and the shown
// neighborhoods. Every point of the original boundary is covered.
#let cover-boundary(radius, collar, neighborhoods) = {
  let background = range(180).map(j => {
    let angle = j * 360deg / 180
    let bump = calc.max(0, -calc.sin(angle))
    (polar(radius, angle), collar + 6 * bump * bump)
  })
  let disks = background + neighborhoods
  range(721).map(j => {
    let direction = polar(1, j * 360deg / 720)
    let distance = radius + collar
    for (center, size) in disks {
      let projection = center.zip(direction).map(((x, y)) => x * y).sum()
      let discriminant = (
        size * size - radius * radius + projection * projection
      )
      if discriminant >= 0 {
        distance = calc.max(distance, projection + calc.sqrt(discriminant))
      }
    }
    mul(direction, distance)
  })
}
#let dimension(origin, endpoint, label) = {
  import cetz.draw: *
  line(origin, add(origin, mul(sub(endpoint, origin), 0.38)))
  line(add(origin, mul(sub(endpoint, origin), 0.61)), endpoint, mark: (
    end: "stealth",
    fill: black,
  ))
  content(add(origin, mul(sub(endpoint, origin), 0.5)), label)
}

#let regular-boundary-cover() = cetz.canvas(length: 1mm, {
  import cetz.draw: *
  styles()
  let radius = 28
  let collar = 3
  let a = polar(radius, 40deg)
  let b = polar(radius, 117deg)
  let c = polar(radius, 190deg)
  let neighborhoods = ((a, 10), (b, 7), (c, 4))
  line(
    ..cover-boundary(radius, collar, neighborhoods),
    close: true,
    stroke: 0.85pt,
  )
  circle((0, 0), radius: radius)
  for (center, size) in neighborhoods { circle(center, radius: size) }
  let z-prime = add(a, polar(6, 42deg))
  let z-double-prime = add(b, polar(4.5, 155deg))
  line(a, z-prime)
  line(b, z-double-prime)
  dimension((0, 0), polar(radius + collar, 90deg), $R_1$)
  dimension((0, 0), polar(radius, 273deg), $R$)
  for p in ((0, 0), a, b, c, z-prime, z-double-prime) { point(p) }
  content((0, 0), $z_0$, anchor: "west")
  content(a, $zeta'$, anchor: "north-east")
  content(b, $zeta''$, anchor: "north")
  content(z-prime, $z'$, anchor: "south-east")
  content(add(z-double-prime, (3.8, 1.4)), $z''$)
  content(polar(radius * 0.55, 150deg), $K$)
  content(polar(radius + 3, 230deg), $Gamma$)
  content(polar(radius + 3.5, 315deg), $D$)
})

// Clip each parallel hatch line analytically against every circular disk.
#let hatch(disks, direction: (0.2, 1), spacing: 1.25) = {
  import cetz.draw: *
  let unit = mul(direction, 1 / norm(direction))
  let normal = (-unit.at(1), unit.at(0))
  for j in range(-80, 81) {
    let base = mul(normal, j * spacing)
    let low = -1000
    let high = 1000
    for (center, radius) in disks {
      let relative = sub(base, center)
      let projection = relative.zip(unit).map(((x, y)) => x * y).sum()
      let disc = (
        projection * projection
          - norm(relative) * norm(relative)
          + radius * radius
      )
      if disc < 0 {
        low = 1
        high = 0
      } else {
        low = calc.max(low, -projection - calc.sqrt(disc))
        high = calc.min(high, -projection + calc.sqrt(disc))
      }
    }
    if low < high {
      line(add(base, mul(unit, low)), add(base, mul(unit, high)), stroke: 0.3pt)
    }
  }
}

#let overlapping-continuations() = cetz.canvas(length: 1mm, {
  import cetz.draw: *
  styles()
  let radius = 28
  let collar = 3
  let a = polar(radius, 137deg)
  let b = polar(radius, 112deg)
  let disks = ((a, 9), (b, 7))
  line(..cover-boundary(radius, collar, disks), close: true, stroke: 0.85pt)
  hatch(disks)
  circle((0, 0), radius: radius)
  for (center, size) in disks { circle(center, radius: size) }
  dimension((0, 0), polar(radius + collar, 90deg), $R_1$)
  dimension((0, 0), polar(radius, 285deg), $R$)
  for p in ((0, 0), a, b) { point(p) }
  content((0, 0), $z_0$, anchor: "west")
  content(a, $zeta'$, anchor: "north")
  content(b, $zeta''$, anchor: "north-west")
  content(add(a, (-3.5, 4)), $U_(zeta')$)
  content(add(b, (0, 3.5)), $U_(zeta'')$)
  content(polar(radius * 0.55, 175deg), $K$)
  content(polar(radius + 3, 245deg), $Gamma$)
  content(polar(radius + 3.5, 320deg), $D$)
  let middle = mul(add(a, b), 0.5)
  let outward = mul(middle, 1 / norm(middle))
  let g-tip = add(middle, mul(outward, 3))
  let d-tip = sub(middle, mul(outward, 2))
  assert(disks.all(((center, radius)) => norm(sub(g-tip, center)) < radius))
  assert(disks.all(((center, radius)) => norm(sub(d-tip, center)) < radius))
  assert(norm(d-tip) < radius and norm(g-tip) > radius)
  let g-label = add(g-tip, (-5, 7))
  let d-label = add(d-tip, (6, -5))
  line(g-tip, g-label)
  line(d-tip, d-label)
  content(g-label, $g$, anchor: "south")
  content(d-label, $d$, anchor: "north-west")
})

#let shifted-element-circle() = cetz.canvas(length: 1mm, {
  import cetz.draw: *
  styles()
  let radius = 32
  let origin = (0, 0)
  let direction = polar(1, 52deg)
  let shifted = mul(direction, 17)
  let boundary-point = mul(direction, radius)
  let distance = radius - norm(shifted)
  let neighborhood = 11
  let new-radius = distance + neighborhood
  assert(calc.abs(norm(sub(boundary-point, shifted)) - distance) < 0.000001)
  assert(new-radius > distance)
  hatch(
    ((shifted, distance), (boundary-point, neighborhood)),
    direction: (1, 1),
  )
  circle(origin, radius: radius, stroke: 0.75pt)
  circle(shifted, radius: new-radius, stroke: 0.75pt)
  circle(shifted, radius: distance, stroke: (dash: "dashed"))
  circle(boundary-point, radius: neighborhood, stroke: (dash: "dashed"))
  line(origin, shifted, stroke: 0.85pt)
  for p in (origin, shifted, boundary-point) { point(p) }
  content(origin, $z_0$, anchor: "north-west")
  content(shifted, $z_1$, anchor: "north-west")
  content(
    add(boundary-point, (-1, -1)),
    $zeta$,
    anchor: "north",
    frame: "rect",
    fill: white,
    stroke: none,
    padding: 0.2,
  )
  content(add(boundary-point, (0, 3)), $U_zeta$, anchor: "south")
  content(add(shifted, polar(distance * 1.13, -15deg)), $gamma$)
  content(polar(radius * 0.58, 170deg), $K$)
})

#let logarithm-element-circles() = cetz.canvas(length: 1mm, {
  import cetz.draw: *
  styles()
  let unit = 21
  let top = (unit, unit)
  let bottom = (unit, -unit)
  let origin = (0, 0)
  let one = (unit, 0)
  let z = (unit * 0.83, unit * 0.65)
  let z-prime = (unit * 1.3, unit * 0.26)
  circle(top, radius: unit, stroke: 0.7pt)
  circle(bottom, radius: unit, stroke: 0.7pt)
  circle(bottom, radius: unit * calc.sqrt(2), stroke: 0.7pt)
  line(origin, (unit * 2.7, 0), mark: (end: "stealth", fill: black))
  line(origin, z, stroke: 0.85pt)
  line(origin, z-prime, stroke: 0.85pt)
  let angle-z = calc.atan2(z.at(0), z.at(1))
  let angle-prime = calc.atan2(z-prime.at(0), z-prime.at(1))
  assert(norm(sub(polar(norm(z), angle-z), z)) < 0.000001)
  assert(norm(sub(polar(norm(z-prime), angle-prime), z-prime)) < 0.000001)
  arc(
    origin,
    anchor: "origin",
    start: 0deg,
    stop: angle-z,
    radius: unit * 0.7,
    mark: (
      start: "stealth",
      fill: black,
      end: "stealth",
    ),
  )
  content(add(polar(unit, angle-z * 0.45), (0, 0.15)), $op("Arg")_1 z$)
  let spiral(t) = polar(unit * (0.32 - 0.06 * t), t * (360deg + angle-prime))
  line(..range(181).map(j => spiral(j / 180)), mark: (
    start: (symbol: "stealth", reverse: true),
    fill: black,
    end: (symbol: "stealth", reverse: true),
  ))
  content((-unit * 0.3, unit * 0.08), $op("Arg")_2 z'$, anchor: "east")
  for p in (origin, one, top, bottom, z, z-prime) { point(p) }
  content(origin, $0$, anchor: "south-east")
  content(one, $1$, anchor: "north")
  content(top, $z_0$, anchor: "west")
  content(bottom, $z'_0$, anchor: "west")
  content(z, $z$, anchor: "west")
  content(add(z-prime, (1.5, 7)), $z'$, anchor: "north-west")
  content((unit * 2.7, 0), $x$, anchor: "north")
  content(add(top, polar(unit * 1.06, 15deg)), $gamma$)
  content(add(bottom, polar(unit * 1.08, -5deg)), $gamma'$)
  content(add(bottom, polar(unit * 0.8, 140deg)), $K'$)
  content(add(bottom, polar(unit * 1.3, -115deg)), $K$)
})
