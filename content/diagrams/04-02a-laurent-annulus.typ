#import "@preview/cetz:0.5.2"

#let polar(radius, angle) = (
  radius * calc.cos(angle),
  radius * calc.sin(angle),
)

#let laurent-annulus() = cetz.canvas(length: 1mm, {
  import cetz.draw: *
  set-style(
    stroke: 0.5pt,
    content: (
      padding: 1,
      wrap: text.with(top-edge: "bounds", bottom-edge: "bounds"),
    ),
    mark: (scale: 0.65, transform-shape: false),
  )
  let origin = (0, 0)
  let inner = 7.5
  let inner-prime = 10
  let outer-prime = 19
  let outer = 22
  let z-radius = 14
  let z-angle = 166deg
  let rho-size = 3
  let z = polar(z-radius, z-angle)
  assert(inner < inner-prime and inner-prime < z-radius - rho-size)
  assert(z-radius + rho-size < outer-prime and outer-prime < outer)

  circle(origin, radius: inner)
  circle(origin, radius: outer)
  for radius in (inner-prime, outer-prime) {
    circle(origin, radius: radius, stroke: (dash: "dashed"))
  }
  circle(z, radius: rho-size)
  content(z, $z$)
  content((z.at(0), z.at(1) - rho-size), $gamma_rho$, anchor: "north")

  for (radius, angle, label) in ((inner, 122deg, $r$), (outer, 228deg, $R$)) {
    let middle = radius * 0.58
    line(origin, polar(middle - 1.6, angle))
    line(polar(middle + 1.6, angle), polar(radius, angle), mark: (
      end: "stealth",
      fill: black,
    ))
    content(polar(middle, angle), label)
  }
  circle(origin, radius: 0.5, fill: white)
  content(origin, $z_0$, anchor: "west")
  content(polar(outer-prime - 2, 35deg), $Gamma_(R')$)
  content(polar(inner-prime + 3.7, -48deg), $Gamma_(r')$)
})
