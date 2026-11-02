#import "@preview/cetz:0.5.2"

#let drawing-style() = cetz.draw.set-style(
  stroke: 0.45pt,
  content: (
    padding: 1.2,
    wrap: text.with(top-edge: "bounds", bottom-edge: "bounds"),
  ),
  mark: (fill: black, scale: 0.65, transform-shape: false),
  angle: (stroke: 0.4pt, mark: none),
  brace: (amplitude: 1.2, thickness: 0.12, content-offset: 1.4),
)

#let radial(radius, longitude, height: 0) = (
  radius * calc.cos(longitude),
  radius * calc.sin(longitude),
  height,
)

#let sphere-image(radius, plane-radius, longitude) = {
  let denominator = 1 + calc.pow(plane-radius, 2)
  radial(
    2 * radius * plane-radius / denominator,
    longitude,
    height: radius * (calc.pow(plane-radius, 2) - 1) / denominator,
  )
}

#let point-mark(p) = cetz.draw.mark(
  p,
  0deg,
  "o",
  anchor: "center",
  length: 0.8,
  width: 0.8,
  fill: white,
  scale: 1,
)

#let plane-annulus(radius, extent, azimuth, front: false) = {
  import cetz.draw: *
  let steps = 22
  let direction = if front { -1 } else { 1 }
  group({
    rotate(z: azimuth)
    on-xy({
      arc(
        (0, 0),
        start: if front { 180deg } else { 0deg },
        stop: if front { 360deg } else { 180deg },
        radius: extent,
        anchor: "origin",
      )
      for k in range(1, steps) {
        let ordinate = direction * extent * k / steps
        let outer = calc.sqrt(calc.pow(extent, 2) - calc.pow(ordinate, 2))
        let inner = if calc.abs(ordinate) < radius {
          calc.sqrt(calc.pow(radius, 2) - calc.pow(ordinate, 2))
        } else { 0 }
        for sign in (-1, 1) {
          line(
            (sign * inner, ordinate),
            (sign * outer, ordinate),
            stroke: 0.2pt,
          )
        }
      }
    })
  })
}

#let sphere-projection() = cetz.canvas(length: 1mm, {
  import cetz.draw: *
  drawing-style()
  let radius = 27
  let tilt = -68deg
  let azimuth = 35deg
  let extent = 1.65 * radius
  let plane-radius = 1.5
  let origin = (0, 0, 0)
  let north = (0, 0, radius)
  let south = (0, 0, -radius)
  let plane-point = radial(radius * plane-radius, azimuth)
  let image-point = sphere-image(radius, plane-radius, azimuth)
  assert(
    calc.abs(
      image-point.map(x => x * x).sum() - radius * radius,
    )
      < 0.0001,
  )

  ortho(x: tilt, y: 0deg, z: -azimuth, sorted: false, {
    plane-annulus(radius, extent, azimuth)
  })
  circle((0, 0), radius: radius, fill: white, stroke: none)
  ortho(x: tilt, y: 0deg, z: -azimuth, sorted: false, {
    plane-annulus(radius, extent, azimuth, front: true)
    group({
      rotate(z: azimuth)
      on-xy({
        arc(
          origin,
          start: 0deg,
          stop: 180deg,
          radius: radius,
          anchor: "origin",
          stroke: (dash: "dashed"),
        )
        arc(
          origin,
          start: 180deg,
          stop: 360deg,
          radius: radius,
          anchor: "origin",
        )
      })
    })
    for longitude in (0deg, 90deg, azimuth) {
      let horizon = calc.atan(
        calc.tan(-tilt) * calc.sin(longitude - azimuth),
      )
      group({
        rotate(z: longitude)
        on-xz({
          arc(
            (0, 0),
            start: horizon,
            stop: horizon + 180deg,
            radius: radius,
            anchor: "origin",
          )
          arc(
            (0, 0),
            start: horizon + 180deg,
            stop: horizon + 360deg,
            radius: radius,
            anchor: "origin",
            stroke: (dash: "dashed"),
          )
        })
      })
    }
    let negative-visible = (0, 0, -radius / calc.sin(-tilt))
    line((0, 0, -1.22 * radius), negative-visible)
    line(
      negative-visible,
      (0, 0, 1.22 * radius),
      stroke: (dash: "dashed"),
    )
    line(north, (0, 0, 1.22 * radius), mark: (end: "stealth"))
    content((0, 0, 1.22 * radius), $zeta$, anchor: "south")
    for (direction, label) in ((0deg, $x$), (90deg, $y$)) {
      let end = radial(1.32 * radius, direction)
      line(radial(-extent, direction), radial(-radius, direction))
      line(
        radial(-radius, direction),
        radial(radius, direction),
        stroke: (dash: "dashed"),
      )
      line(radial(radius, direction), end, mark: (end: "stealth"))
      content(end, label, anchor: "north-west")
    }
    line(north, image-point, stroke: (dash: "dashed"))
    line(image-point, plane-point)
    for direction in (0deg, 90deg, 180deg, 270deg) {
      point-mark(radial(radius, direction))
    }
    for (p, label, anchor) in (
      (north, $P$, "west"),
      (south, $P'$, "west"),
      (origin, $O$, "north-west"),
      (plane-point, $A$, "south"),
      (image-point, $A'$, "south"),
    ) {
      point-mark(p)
      content(p, label, anchor: anchor)
    }
    content(radial(-1.5 * radius, azimuth), $Pi$, anchor: "south")
    let cap-longitude = -100deg
    let cap-latitude = 50deg
    let cap-angle = 8deg
    group({
      rotate(z: cap-longitude)
      rotate(y: 90deg - cap-latitude)
      on-xy(z: radius * calc.cos(cap-angle), {
        let cap-radius = radius * calc.sin(cap-angle)
        circle((0, 0), radius: cap-radius)
        for k in range(-4, 5) {
          let ordinate = cap-radius * k / 5
          let half-width = calc.sqrt(
            cap-radius * cap-radius - ordinate * ordinate,
          )
          line(
            (-half-width, ordinate),
            (half-width, ordinate),
            stroke: 0.2pt,
          )
        }
      })
    })
    let cap-point = radial(
      radius * calc.cos(cap-latitude),
      cap-longitude,
      height: radius * calc.sin(cap-latitude),
    )
    point-mark(cap-point)
    content(cap-point, $M'$, anchor: "south-west")
  })
  circle((0, 0), radius: radius)
})

#let projection-coordinates() = cetz.canvas(length: 1mm, {
  import cetz.draw: *
  drawing-style()
  let radius = 34
  let longitude = 45deg
  let latitude = 30deg
  let plane-radius = calc.tan(45deg + latitude / 2)
  let origin = (0, 0, 0)
  let north = (0, 0, radius)
  let plane-point = radial(radius * plane-radius, longitude)
  let image-point = sphere-image(radius, plane-radius, longitude)
  let foot = radial(radius * calc.cos(latitude), longitude)
  assert(calc.abs(image-point.at(2) - radius * calc.sin(latitude)) < 0.0001)

  ortho(x: -72deg, y: 0deg, z: -longitude, sorted: false, {
    line(origin, plane-point)
    line(north, plane-point)
    line(origin, image-point)
    line(foot, image-point)
    line(origin, (0, 0, 1.28 * radius), mark: (end: "stealth"))
    content((0, 0, 1.28 * radius), $zeta$, anchor: "south")
    for (direction, label) in ((0deg, $x$), (90deg, $y$)) {
      let end = radial(2.4 * radius, direction)
      line(origin, end, mark: (end: "stealth"))
      content(end, label, anchor: "north-west")
    }
    for (p, label, anchor) in (
      (origin, $O$, "north-east"),
      (north, $P$, "south-west"),
      (plane-point, $A$, "south-west"),
      (image-point, $A'$, "south-west"),
      (foot, $B$, "north"),
    ) {
      content(p, label, anchor: anchor)
    }
    content(plane-point, $z$, anchor: "north")
    content((origin, 50%, image-point), $1$, anchor: "south-east")
    on-xy({
      cetz.angle.angle(
        origin,
        (radius, 0),
        radial(radius, longitude),
        direction: "ccw",
        radius: 0.55 * radius,
        label: $lambda$,
        label-radius: 0.68 * radius,
      )
    })
    group({
      rotate(z: longitude)
      on-xz({
        let north-local = (0, radius)
        let plane-local = (radius * plane-radius, 0)
        let image-local = (
          radius * calc.cos(latitude),
          radius * calc.sin(latitude),
        )
        cetz.angle.angle(
          (0, 0),
          plane-local,
          image-local,
          direction: "ccw",
          radius: 0.27 * radius,
          name: "latitude",
          label-radius: 0.65 * radius,
        )
        content("latitude.label", $phi$, anchor: "north")
        cetz.angle.angle(
          north-local,
          (0, 0),
          plane-local,
          direction: "ccw",
          radius: 0.2 * radius,
          label: $pi/4 + phi/2$,
          label-radius: 0.38 * radius,
        )
        cetz.decorations.brace((0, 0), north-local, name: "unit-radius")
        content("unit-radius.content", $1$, anchor: "east")
      })
    })
  })
})
