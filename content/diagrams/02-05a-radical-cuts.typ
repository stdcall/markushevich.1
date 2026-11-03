#import "@preview/cetz:0.5.2"
#import "01-03a-sequences.typ": hatched-polygon

#let add(a, b) = a.zip(b).map(((x, y)) => x + y)
#let mul(a, k) = a.map(x => x * k)
#let polar(r, angle) = (r * calc.cos(angle), r * calc.sin(angle))
#let drawing-style() = cetz.draw.set-style(
  stroke: 0.45pt,
  content: (
    padding: 1.5,
    wrap: text.with(top-edge: "bounds", bottom-edge: "bounds"),
  ),
  mark: (fill: black, scale: 0.6, transform-shape: false),
)
#let point(p, body, anchor: "south") = {
  cetz.draw.content(
    p,
    body,
    anchor: anchor,
    frame: "rect",
    fill: white,
    stroke: none,
    padding: 0.3,
  )
  cetz.draw.circle(p, radius: 0.45, fill: white)
}
#let axes(
  origin,
  extent,
  horizontal,
  vertical,
  plane,
  origin-label: none,
  plane-side: -1,
) = {
  import cetz.draw: *
  line(add(origin, (-extent, 0)), add(origin, (extent, 0)), mark: (
    end: "stealth",
  ))
  line(add(origin, (0, -extent)), add(origin, (0, extent)), mark: (
    end: "stealth",
  ))
  content(add(origin, (extent, 0)), horizontal, anchor: "north")
  content(add(origin, (0, extent)), vertical, anchor: "east")
  content(add(origin, (plane-side * extent * 0.8, extent * 0.85)), plane)
  if origin-label != none {
    content(origin, origin-label, anchor: "north-east")
  }
}

#let branch-sectors() = cetz.canvas(length: 1mm, {
  import cetz.draw: *
  drawing-style()
  let n = 6
  let phase = -40deg
  let turn = 20deg
  let step = 360deg / n
  let r = 22
  let right = (61, 0)
  assert(0deg < turn and turn < step)
  for k in range(1, n + 1) {
    let start = phase + k * step
    scope({
      rotate(start)
      let hatch-turn = step / 2 + 45deg
      scope({
        rotate(hatch-turn)
        hatched-polygon(
          ((0, 0), polar(r, -hatch-turn), polar(r, step - hatch-turn)),
          step: 1.2,
        )
      })
      line((0, 0), polar(r, 0deg), polar(r, step), stroke: 0.7pt)
    })
    line((0, 0), polar(r + 5, start + turn), stroke: (dash: "dashed"))
    content(
      polar(r * 0.64, start + step / 2),
      if k == n { $g_n$ } else {
        $g_(#k)$
      },
      frame: "rect",
      fill: white,
      stroke: none,
      padding: 0.3,
    )
  }
  axes((0, 0), r + 7, $u$, $v$, $(w)$)
  content(
    polar(5, 230deg),
    $O$,
    frame: "rect",
    fill: white,
    stroke: none,
    padding: 0.25,
  )
  axes(right, r + 7, $x$, $y$, $(z)$, plane-side: 1)
  for k in range(1, n + 1) {
    let start = phase + k * step
    content(
      add(polar(r + 5, start + turn + step * 0.85), if k == 1 {
        (-6.5, -2)
      } else if k == 4 { (3, 0) } else { (0, 0) }),
      if k == n {
        $d_n$
      } else if k == n - 1 {
        $d_(n - 1)$
      } else { $d_(#k)$ },
    )
  }
  let ray-l = polar(r + 6, n * phase)
  let ray-m = polar(r + 6, n * (phase + turn))
  line(right, add(right, ray-l), stroke: 0.7pt)
  line(right, add(right, ray-m), stroke: (dash: "dashed"))
  content(add(right, ray-l), $L$, anchor: "east")
  content(add(right, ray-m), $M$, anchor: "east")
  content(add(right, polar(16, 35deg)), $G'$)
  content(add(right, polar(19, 240deg)), $D'$, anchor: "west")
})

#let winding-curve(angle) = {
  let r = 18 + 3 * calc.cos(2 * angle) + 2 * calc.sin(3 * angle)
  let p = polar(r, angle)
  (1.4 * p.at(0), p.at(1))
}
#let winding-arguments() = cetz.canvas(length: 1mm, {
  import cetz.draw: *
  drawing-style()
  set-style(content: (fill: none))
  let ak = (-8, -7)
  let al = (36, -7)
  let initial = winding-curve(50deg)
  let current = winding-curve(15deg)
  let curve = range(181).map(i => winding-curve(i * 2deg))
  line(..curve, close: true, stroke: 0.8pt)
  for start in (115deg, 310deg) {
    let arc = range(13).map(i => mul(winding-curve(start + i * 1.5deg), 1.06))
    line(..arc, mark: (end: "stealth"))
  }
  for origin in (ak, al) {
    line(origin, add(origin, (15, 0)), stroke: (dash: "dashed"))
    line(origin, initial, mark: if origin == ak { (end: "stealth") } else {
      none
    })
    line(
      origin,
      current,
      stroke: if origin == ak { (dash: "dashed") } else { 0.45pt },
      mark: if origin == ak { (end: "stealth") } else { none },
    )
    if origin == al {
      cetz.angle.angle(
        origin,
        add(origin, (1, 0)),
        current,
        radius: 5,
        mark: (end: "stealth"),
        label: $phi_l$,
        label-radius: 145%,
      )
    }
    cetz.angle.angle(
      origin,
      add(origin, (1, 0)),
      initial,
      radius: if origin == ak { 12 } else { 9 },
      mark: (end: "stealth"),
      name: if origin == ak { "initial-k" } else { "initial-l" },
      label: if origin == ak { none } else { $phi_l^((0))$ },
      label-radius: 145%,
    )
  }
  content("initial-k.end", $phi_k^((0))$, anchor: "south-east")
  let current-angle = calc.atan2(
    current.at(0) - ak.at(0),
    current.at(1) - ak.at(1),
  )
  line(
    ..range(241).map(i => add(ak, polar(
      6,
      (360deg + current-angle) * i / 240,
    ))),
    stroke: (dash: "dashed"),
    mark: (end: "stealth"),
  )
  content(add(ak, (-5, -2)), $phi_k$, anchor: "east")
  content(add(ak, (0, -3.2)), $a_k$)
  circle(ak, radius: 0.45, fill: white)
  content(add(al, (0, -3.2)), $a_l$)
  circle(al, radius: 0.45, fill: white)
  point(initial, $z_0$, anchor: "south")
  point(current, $z$, anchor: "south-west")
  content(mul(winding-curve(170deg), 0.82), $gamma$)
})

#let quartic-cuts() = cetz.canvas(length: 1mm, {
  import cetz.draw: *
  drawing-style()
  let k = 0.6
  let unit = 10
  let extent = 23
  for alternative in (false, true) {
    scope({
      if alternative { translate((57, 0)) }
      hatched-polygon(
        ((-extent, 0), (extent, 0), (extent, 10), (-extent, 10)),
        step: 1.4,
      )
      scope({
        scale(y: -1)
        hatched-polygon(
          ((-extent, 0), (extent, 0), (extent, 10), (-extent, 10)),
          step: 1.4,
        )
      })
      line((-extent - 2, 0), (extent + 3, 0), mark: (end: "stealth"))
      line((0, -13), (0, 15), mark: (end: "stealth"))
      let endpoints = (-1 / k, -1, 1, 1 / k)
      if alternative {
        line((-extent, 0), (-unit / k, 0), stroke: 0.9pt)
        line((-unit, 0), (unit, 0), stroke: 0.9pt)
        line((unit / k, 0), (extent, 0), stroke: 0.9pt)
      } else {
        line((-unit / k, 0), (-unit, 0), stroke: 0.9pt)
        line((unit, 0), (unit / k, 0), stroke: 0.9pt)
      }
      for (x, label) in endpoints.zip(($-1/k$, $-1$, $1$, $1/k$)) {
        content(
          (x * unit, if x > 0 { -1.7 } else { 0 }),
          label,
          anchor: "north",
          frame: "rect",
          fill: white,
          stroke: none,
          padding: 0.3,
        )
        line((x * unit, -0.45), (x * unit, 0.45))
      }
      content(
        (-1, -1.5),
        $O$,
        anchor: "north-east",
        frame: "rect",
        fill: white,
        stroke: none,
        padding: 0.18,
      )
      content((extent + 3, 0), $x$, anchor: "north")
      content((0, 15), $y$, anchor: "east")
      content((extent * 0.8, 14), $(z)$)
      content(
        (extent * 0.6, 7),
        if alternative { $G'$ } else { $G$ },
        frame: "rect",
        fill: white,
        stroke: none,
        padding: 0.3,
      )
    })
  }
})

#let cubic-cuts() = cetz.canvas(length: 1mm, {
  import cetz.draw: *
  drawing-style()
  let unit = 12
  let roots = ((-2, -0.5), (-0.5, 0.8), (2.5, -0.3))
  assert(roots.map(p => p.at(0)).sum() == 0)
  assert(calc.abs(roots.map(p => p.at(1)).sum()) < 0.000001)
  let (l1, l2, l3) = roots.map(p => mul(p, unit))
  let far = add(l3, (34, 15))
  scope({
    scale(y: -1)
    hatched-polygon(((-30, -18), (69, -18), (69, 14), (-30, 14)), step: 1.5)
  })
  line(l1, l2, stroke: 0.9pt, name: "first-cut")
  bezier(
    l3,
    far,
    add(l3, (3, 12)),
    add(far, (-20, -7)),
    stroke: 0.9pt,
    mark: (end: "stealth"),
    name: "second-cut",
  )
  point(l1, $ell_1$, anchor: "east")
  point(l2, $ell_2$, anchor: "west")
  point(l3, $ell_3$, anchor: "north-west")
  content(
    "first-cut.mid",
    $gamma_1$,
    anchor: "north-west",
    frame: "rect",
    fill: white,
    stroke: none,
    padding: 0.3,
  )
  content(
    (rel: (0, -1.5), to: "second-cut.mid"),
    $gamma_2$,
    anchor: "north",
    frame: "rect",
    fill: white,
    stroke: none,
    padding: 0.3,
  )
  content(
    add(far, (2, 2)),
    $(infinity)$,
    anchor: "west",
    frame: "rect",
    fill: white,
    stroke: none,
    padding: 0.18,
  )
})
