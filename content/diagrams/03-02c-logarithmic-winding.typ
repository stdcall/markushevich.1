#import "@preview/cetz:0.5.2"

#let add(a, b) = a.zip(b).map(((x, y)) => x + y)
#let sub(a, b) = a.zip(b).map(((x, y)) => x - y)
#let mul(a, k) = a.map(x => x * k)
#let samples(f, first, last, count: 120) = range(count + 1).map(i => f(
  first + (last - first) * i / count,
))

#let logarithmic-winding() = cetz.canvas(length: 1mm, {
  import cetz.draw: *
  set-style(
    stroke: 0.45pt,
    content: (
      padding: 0.7,
      wrap: text.with(top-edge: "bounds", bottom-edge: "bounds"),
    ),
    mark: (fill: black, scale: 0.65, transform-shape: false),
  )
  let radius = 34
  let inner-radius = 14
  let end-radius = 6
  let vertical = 1.2
  let end-angle = 1055deg
  let end-turn = -25deg
  let final-angle = 110deg
  let polar(r, t) = (r * calc.cos(t), vertical * r * calc.sin(t))
  let spiral(t) = polar(
    radius - (radius - inner-radius) * (t / end-angle),
    t,
  )
  let inner(t) = polar(
    inner-radius - (inner-radius - end-radius) * t,
    end-turn - 225deg * t + 170deg * calc.sin(180deg * t),
  )
  let turns = (0deg, 415deg, 780deg, end-angle)
  let points = (..turns.map(spiral), inner(1))
  let (a, b, c, d, e) = points
  assert(radius > inner-radius and inner-radius > end-radius)
  assert(calc.abs(end-angle - 225deg - final-angle - 720deg) < 0.000001deg)

  let upper-cut(target-angle, target-radius, t, curved: false) = {
    let fraction = if curved { 2 * t - t * t } else { t }
    polar(radius - (radius - target-radius) * fraction, target-angle * t)
  }
  let target-radius(t) = radius - (radius - inner-radius) * t / end-angle
  let cut-b(t) = upper-cut(55deg, target-radius(turns.at(1)), t)
  let cut-c(t) = upper-cut(60deg, target-radius(turns.at(2)), t)
  let cut-e(t) = upper-cut(final-angle, end-radius, t, curved: true)
  let cut-d(t) = {
    let control = ((d.at(0) + a.at(0)) / 2, 0)
    add(
      add(mul(d, (1 - t) * (1 - t)), mul(control, 2 * t * (1 - t))),
      mul(a, t * t),
    )
  }
  for cut in (cut-b, cut-c, cut-e) {
    line(
      ..samples(cut, 1, 0),
      stroke: (dash: "dashed"),
      mark: (
        end: "stealth",
      ),
    )
  }
  line(
    ..samples(cut-d, 0, 1),
    stroke: (dash: "dashed"),
    mark: (
      end: "stealth",
    ),
  )

  line((-31, 0), (radius + 7, 0), mark: (end: "stealth"))
  line((0, -30), (0, 43), mark: (end: "stealth"))
  content((radius + 7, 0), $x$, anchor: "north")
  content((0, 43), $y$, anchor: "east")

  line(..samples(spiral, 0deg, end-angle, count: 600), stroke: 0.8pt)
  line(..samples(inner, 0, 1, count: 250), stroke: 0.8pt)
  line(e, a, stroke: 0.8pt)
  for (first, last) in (
    (25deg, 43deg),
    (660deg, 680deg),
    (985deg, 1005deg),
  ) {
    line(
      ..samples(t => mul(spiral(t), 1.04), first, last, count: 20),
      mark: (end: "stealth"),
    )
  }
  line(..samples(t => mul(inner(t), 1.13), 0.68, 0.73, count: 20), mark: (
    end: "stealth",
  ))
  let vector = sub(a, e)
  let length = calc.sqrt(vector.map(x => x * x).sum())
  let below = mul((vector.at(1), -vector.at(0)), 1.4 / length)
  line(
    add(add(e, mul(vector, 0.43)), below),
    add(add(e, mul(vector, 0.58)), below),
    mark: (end: "stealth"),
  )

  circle((0, 0), radius: 2.5, stroke: (dash: "dashed"))
  arc(
    (0, 0),
    start: -60deg,
    delta: 50deg,
    radius: 3.6,
    anchor: "origin",
    mark: (end: "stealth"),
  )
  content((3.5, 3), $gamma$, anchor: "west")

  for (t, label) in ((145deg, $a$), (505deg, $b$), (865deg, $c$)) {
    content(spiral(t), label, anchor: "south-east")
  }
  content(inner(0.96), $d$, anchor: "east")
  content(add(e, mul(vector, 0.5)), $e$, anchor: "south")
  content(spiral(210deg), $L$, anchor: "north-east")
  for (p, label, anchor) in points.zip(
    ($A$, $B$, $C$, $D$, $E$),
    ("north", "south", "south", "north-west", "south-east"),
  ) {
    circle(p, radius: 0.45, fill: white)
    content(p, label, anchor: anchor)
  }
})
