#import "@preview/cetz:0.5.2"

#let hatched-polygon(vertices, step: 1.4, slope: 1) = {
  let offset(p) = if slope == none { p.at(0) } else {
    p.at(1) - slope * p.at(0)
  }
  let offsets = vertices.map(offset)
  let first = calc.floor(calc.min(..offsets) / step)
  let last = calc.ceil(calc.max(..offsets) / step)
  for k in range(first, last + 1) {
    let c = k * step
    let hits = ()
    for i in range(vertices.len()) {
      let a = vertices.at(i)
      let b = vertices.at(calc.rem(i + 1, vertices.len()))
      let da = offset(a)
      let db = offset(b)
      if calc.abs(db - da) > 0.0001 {
        let t = (c - da) / (db - da)
        if 0 <= t and t <= 1 {
          let p = (
            a.at(0) + t * (b.at(0) - a.at(0)),
            a.at(1) + t * (b.at(1) - a.at(1)),
          )
          if not hits.any(q => (
            calc.abs(q.at(0) - p.at(0)) < 0.0001
              and calc.abs(q.at(1) - p.at(1)) < 0.0001
          )) {
            hits.push(p)
          }
        }
      }
    }
    if hits.len() == 2 {
      cetz.draw.line(hits.first(), hits.last(), stroke: 0.2pt)
    }
  }
}

#let diagram-style() = cetz.draw.set-style(
  stroke: 0.45pt,
  content: (
    padding: 1,
    wrap: text.with(top-edge: "bounds", bottom-edge: "bounds"),
  ),
  mark: (fill: black, scale: 0.7, transform-shape: false),
  brace: (amplitude: 1.2, thickness: 0.12, content-offset: 1.4),
)

#let nested-squares() = cetz.canvas(length: 1mm, {
  import cetz.draw: *
  diagram-style()
  let half-side = 23
  let d1 = ((-half-side, -half-side), (half-side, half-side))
  let d2 = ((-half-side, 0), (0, half-side))
  let d3 = ((-half-side / 2, half-side / 2), (0, half-side))
  let hatch = (
    d3.first(),
    (d3.last().at(0), d3.first().at(1)),
    d3.last(),
    (d3.first().at(0), d3.last().at(1)),
  )
  hatched-polygon(hatch)
  rect(..d1)
  rect(..d2)
  line((d2.first().at(0), half-side / 2), (0, half-side / 2))
  line((-half-side / 2, 0), (-half-side / 2, half-side))
  line((-half-side - 6, 0), (half-side + 11, 0), name: "x", mark: (
    end: "stealth",
  ))
  line((0, -half-side - 5), (0, half-side + 10), name: "y", mark: (
    end: "stealth",
  ))
  content("x.end", $x$, anchor: "north")
  content("y.end", $y$, anchor: "east")
  content((0, 0), $0$, anchor: "north-west")
  content((d3.first(), 50%, d3.last()), box(fill: white, inset: 0.15mm)[$D_3$])
  cetz.decorations.brace(
    (d3.first().at(0), 0),
    (0, 0),
    name: "horizontal",
    flip: true,
  )
  content("horizontal.content", $d_3$, anchor: "north")
  cetz.decorations.brace(
    (0, d3.first().at(1)),
    d3.last(),
    name: "vertical",
    flip: true,
  )
  content("vertical.content", $delta_3$, anchor: "west")
})

#let cauchy-circles() = cetz.canvas(length: 1mm, {
  import cetz.draw: *
  diagram-style()
  let unit = 1.5
  let z0 = (0, 0)
  let z1 = (36 * unit, -9 * unit)
  let radius = (
    calc.sqrt(
      calc.pow(z1.at(0) - z0.at(0), 2) + calc.pow(z1.at(1) - z0.at(1), 2),
    )
      / 3
  )
  let first-term = (2 * unit, 10 * unit)
  let second-term = (42 * unit, -7 * unit)
  circle(z0, radius: radius)
  circle(z1, radius: radius)
  line(z0, z1)
  line(first-term, second-term)
  for (p, label, side) in (
    (z0, $z_0$, "north-east"),
    (z1, $z_1$, "north"),
    (first-term, $w_(n_0)$, "north-east"),
    (second-term, $w_(n_0+p_0)$, "north-east"),
  ) {
    circle(p, radius: 0.4, fill: white)
    content(
      if p == second-term { (rel: (0, -10), to: p) } else { p },
      label,
      anchor: if p == second-term { none } else { side },
    )
  }
  cetz.decorations.brace(
    (z0, 100% / 3, z1),
    (z0, 200% / 3, z1),
    name: "gap",
    flip: true,
  )
  content("gap.content", $1/3 abs(z_1 - z_0)$, anchor: "north")
})

#let argument-sector() = cetz.canvas(length: 1mm, {
  import cetz.draw: *
  diagram-style()
  let argument-angle = 120deg
  let half-angle = 15deg
  let reach = 32
  let radial(angle, radius) = (
    radius * calc.cos(angle),
    radius * calc.sin(angle),
  )
  let origin = (0, 0)
  let w = radial(argument-angle, 25)
  let lower = radial(argument-angle - half-angle, reach)
  let upper = radial(argument-angle + half-angle, reach)
  let positive = radial(argument-angle - 90deg, reach)
  let negative = radial(argument-angle + 90deg, reach)
  hatched-polygon((origin, lower, upper))
  line((-29, 0), (33, 0), name: "x", mark: (end: "stealth"))
  line((0, -19), (0, 37), name: "y", mark: (end: "stealth"))
  content("x.end", $x$, anchor: "north")
  content("y.end", $y$, anchor: "east")
  line(negative, positive)
  line(origin, lower)
  line(origin, upper)
  line(origin, w)
  circle(w, radius: 0.4, fill: white)
  content(w, box(fill: white, inset: 0.15mm)[$w$], anchor: "south")
  cetz.angle.angle(
    origin,
    w,
    "x.end",
    direction: "cw",
    radius: 9,
    label: $phi$,
    label-radius: 12,
    mark: (end: "stealth"),
  )
  cetz.angle.angle(
    origin,
    negative,
    "x.end",
    direction: "cw",
    radius: 15,
    name: "wide",
    mark: (start: "stealth", end: "stealth"),
  )
  content("wide.arc.75%", $phi + pi/2$, anchor: "south-west")
  cetz.angle.angle(
    origin,
    positive,
    "x.end",
    direction: "cw",
    radius: 25,
    name: "small",
    mark: (start: "stealth", end: "stealth"),
  )
  content("small.arc.mid", $phi - pi/2$, anchor: "west")
  for (a, b) in ((upper, w), (w, lower)) {
    cetz.angle.angle(
      origin,
      a,
      b,
      direction: "cw",
      radius: 20,
      label: box(fill: white, inset: 0.15mm)[$epsilon$],
      label-radius: 23,
      mark: (start: "stealth", end: "stealth"),
    )
  }
})
