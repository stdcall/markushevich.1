#import "@preview/cetz:0.5.2"

#let exponential-reciprocal-relief() = cetz.canvas(
  length: 1mm,
  z: (-0.7, 0.7),
  {
    import cetz.draw: *
    set-style(
      stroke: 0.45pt,
      content: (
        padding: 1,
        wrap: text.with(top-edge: "bounds", bottom-edge: "bounds"),
      ),
      mark: (scale: 0.65, transform-shape: false, fill: black),
    )
    let extent-x = 1.8
    let extent-y = 1.3
    let ceiling = 5.5
    let mesh-epsilon = 0.004
    let position(x, y, height) = (18 * x, 11 * height, 16 * y)
    let surface(x, y) = {
      assert(x * x + y * y > 0)
      calc.exp(x / (x * x + y * y))
    }
    let visible-height(x, y) = {
      let exponent = x / (x * x + y * y)
      if exponent > calc.ln(ceiling) { ceiling } else { calc.exp(exponent) }
    }
    let profile(x, y) = position(x, y, visible-height(x, y))
    let samples(function, start, stop, count: 50) = range(count + 1).map(
      n => function(start + (stop - start) * n / count),
    )
    assert(calc.abs(surface(1, 0) - calc.e) < 0.000001)
    assert(calc.abs(surface(-1, 0) - 1 / calc.e) < 0.000001)
    assert(calc.abs(surface(0, 1) - 1) < 0.000001)

    let axis-head = (end: "stealth")
    line(position(-3, 0, 0), position(3, 0, 0))
    line(position(0, -2.2, 0), position(0, 2.2, 0))

    let levels = (
      0.12,
      0.25,
      0.4,
      0.6,
      0.8,
      1,
      1.25,
      1.5,
      1.8,
      2.1,
      2.4,
      2.7,
      3,
      3.3,
      3.6,
      3.9,
      4.2,
      4.5,
      4.8,
      5.1,
      5.5,
    )
    let meridians = (
      range(10, 180, step: 10).map(n => n * 1deg)
        + range(-80, 0, step: 10).map(n => n * 1deg)
    )
    let abscissae = (
      ..range(81).map(n => -extent-x + 2 * extent-x * n / 80),
      ..range(-30, 31).map(n => n * 0.008),
    )
      .sorted()
      .dedup()
    let cross-section(y) = abscissae
      .filter(x => y > 0 or x >= 0)
      .map(x => profile(x, y))

    let grid-band(back, front) = {
      line(
        ..cross-section(back),
        ..cross-section(front).rev(),
        close: true,
        fill: white,
        stroke: none,
      )
      let visible-back = calc.min(extent-y, back + (back - front) / 12)
      for height in levels {
        if height == 1 {
          line(position(0, visible-back, 1), position(0, front, 1))
        } else {
          let logarithm = calc.ln(height)
          let radius = 1 / (2 * calc.abs(logarithm))
          let start = calc.max(front, -radius)
          let stop = calc.min(visible-back, radius)
          if start < stop {
            for branch in (-1, 1) {
              let points = samples(
                y => {
                  let discriminant = calc.max(
                    0,
                    1 - 4 * logarithm * logarithm * y * y,
                  )
                  let x = (
                    (1 + branch * calc.sqrt(discriminant)) / (2 * logarithm)
                  )
                  if calc.abs(x) <= extent-x and (y > 0 or x >= 0) {
                    position(x, y, height)
                  } else { none }
                },
                start,
                stop,
                count: 12,
              )
              let run = ()
              for point in points + (none,) {
                if point == none {
                  if run.len() >= 2 { line(..run) }
                  run = ()
                } else { run.push(point) }
              }
            }
          }
        }
      }
      for direction in meridians {
        let sine = calc.sin(direction)
        let cosine = if direction == 90deg { 0 } else { calc.cos(direction) }
        let cap-radius = if cosine > 0 { cosine / calc.ln(ceiling) } else {
          none
        }
        let cap-y = if cap-radius != none { cap-radius * sine } else { none }
        let ys = range(9).map(i => front + (visible-back - front) * i / 8)
        if cap-y != none and front <= cap-y and cap-y <= visible-back {
          ys.push(cap-y)
        }
        let points = ys
          .sorted()
          .dedup()
          .map(y => {
            let radius = y / sine
            let x = radius * cosine
            if radius > 0 and calc.abs(x) <= extent-x {
              if y == cap-y {
                position(cap-radius * cosine, cap-y, ceiling)
              } else {
                let exponent = cosine / radius
                if exponent < calc.ln(ceiling) {
                  position(x, y, calc.exp(exponent))
                } else { none }
              }
            } else { none }
          })
        let run = ()
        for point in points + (none,) {
          if point == none {
            if run.len() >= 2 { line(..run) }
            run = ()
          } else { run.push(point) }
        }
      }
    }

    let ordinates = (
      ..range(36).map(n => extent-y * (1 - n / 35)),
      ..range(1, 20).map(n => 0.002 * n),
    )
      .filter(y => y >= mesh-epsilon)
      .sorted()
      .dedup()
      .rev()
    for (back, front) in ordinates.zip(ordinates.slice(1)) {
      grid-band(back, front)
    }
    let negative-ordinates = ordinates.map(y => -y).rev()
    for (back, front) in negative-ordinates.zip(negative-ordinates.slice(1)) {
      grid-band(back, front)
    }

    let wall(curve, count: 55) = {
      let top = samples(
        t => {
          let (x, y, height) = curve(t)
          position(x, y, height)
        },
        0,
        1,
      )
      let (x0, y0, _) = curve(0)
      let (x1, y1, _) = curve(1)
      line(
        position(x0, y0, 0),
        ..top,
        position(x1, y1, 0),
        close: true,
        fill: white,
      )
      for n in range(count + 1) {
        let (x, y, height) = curve(n / count)
        line(position(x, y, 0), position(x, y, height), stroke: 0.25pt)
      }
      line(..top)
    }
    wall(
      t => {
        let y = extent-y * (1 - t)
        (-extent-x, y, surface(-extent-x, y))
      },
      count: 30,
    )
    wall(t => {
      let x = -extent-x * (1 - t)
      (x, 0, if x == 0 { 0 } else { surface(x, 0) })
    })
    wall(t => (0, -extent-y * t, 1), count: 30)
    wall(t => {
      let x = extent-x * t
      (x, -extent-y, surface(x, -extent-y))
    })

    line(..samples(x => profile(x, extent-y), -extent-x, extent-x))
    line(..samples(y => profile(extent-x, y), -extent-y, extent-y))

    let cap-log = calc.ln(ceiling)
    let cap-radius = 1 / (2 * cap-log)
    let cap-outline = samples(
      t => position(
        cap-radius * (1 + calc.cos(t * 1rad)),
        cap-radius * calc.sin(t * 1rad),
        ceiling,
      ),
      0,
      2 * calc.pi,
      count: 100,
    )
    line(..cap-outline, close: true, fill: white)

    line(position(0, 0, 0), position(0, 0, ceiling + 0.45), mark: axis-head)
    content(position(0, 0, ceiling + 0.45), $u$, anchor: "east")
    line(position(2.8, 0, 0), position(3, 0, 0), mark: axis-head)
    content(position(3, 0, 0), $x$, anchor: "north")
    line(position(0, 1.8, 0), position(0, 2.2, 0), mark: axis-head)
    content(position(0, 2.2, 0), $y$, anchor: "south-east")
    for abscissa in (-2.9, -2.8) {
      line(
        position(abscissa - 0.1, 0, 0),
        position(abscissa, 0, 0),
        mark: axis-head,
      )
    }
    for ordinate in (-2.1, -2) {
      line(
        position(0, ordinate - 0.1, 0),
        position(0, ordinate, 0),
        mark: axis-head,
      )
    }
  },
)
