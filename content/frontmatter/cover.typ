#let cover(volume: 1) = {
  let ink = rgb("e7e5d9")
  let field = rgb("303d3b")
  let line-fit(width, size, body, weight: "semibold", tracking: 0pt) = context {
    let letters = text(
      font: "EB Garamond",
      size: size,
      weight: weight,
      tracking: tracking,
      top-edge: "cap-height",
      bottom-edge: "baseline",
      body,
    )
    scale(x: width / measure(letters).width * 100%, reflow: true, letters)
  }

  page(
    width: 152mm,
    height: 220mm,
    margin: 0pt,
    fill: field,
    numbering: none,
    header: none,
    footer: none,
    background: none,
    foreground: none,
  )[
    #set text(font: "EB Garamond", fill: ink, lang: "ru")
    #set par(first-line-indent: 0pt, justify: false, leading: 0pt)
    #place(top + left, dx: 14mm, dy: 19mm)[
      #line-fit(65mm, 20pt, [А. И. МАРКУШЕВИЧ], weight: "bold")
    ]
    #place(top + left, dx: 76mm, dy: 34mm)[
      #box(width: 17mm, height: 14mm)[
        #place(top + left, curve(
          fill: ink,
          stroke: none,
          curve.move((0.3mm, 6.3mm)),
          curve.cubic((0.0mm, 3.7mm), (1.8mm, 2.8mm), (4mm, 2.8mm)),
          curve.line((11.2mm, 2.5mm)),
          curve.cubic((13.5mm, 2.4mm), (15.1mm, 1.6mm), (16.4mm, 0mm)),
          curve.line((16.8mm, 0.3mm)),
          curve.cubic((16.2mm, 2mm), (14.3mm, 3.3mm), (12.6mm, 3.6mm)),
          curve.line((4mm, 4.0mm)),
          curve.cubic((2.1mm, 4mm), (1.5mm, 4.3mm), (1mm, 6.3mm)),
          curve.close(),
        ))
        #for (x, stem-top) in (
          (3.1mm, 3.5mm),
          (7.7mm, 3.2mm),
          (12.1mm, 3mm),
        ) {
          place(top + left, curve(
            fill: ink,
            stroke: none,
            curve.move((x - 0.2mm, stem-top)),
            curve.line((x + 1.2mm, stem-top)),
            curve.line((x + 0.8mm, 12.1mm)),
            curve.cubic(
              (x + 0.8mm, 13mm),
              (x + 1.2mm, 13.1mm),
              (x + 2mm, 13.2mm),
            ),
            curve.line((x + 2mm, 13.6mm)),
            curve.line((x - 2mm, 13.6mm)),
            curve.line((x - 2mm, 13.2mm)),
            curve.cubic(
              (x - 0.9mm, 13.1mm),
              (x - 0.5mm, 12.9mm),
              (x - 0.5mm, 12.1mm),
            ),
            curve.close(),
          ))
        }
      ]
    ]
    #place(top + left, dx: 93mm, dy: 40.5mm)[
      #line-fit(39mm, 29pt, [ЕОРИЯ], tracking: 0.08em)
    ]
    #place(top + left, dx: 42mm, dy: 56.5mm)[
      #line-fit(90mm, 29pt, [АНАЛИТИЧЕСКИХ])
    ]
    #place(top + left, dx: 78mm, dy: 71.5mm)[
      #line-fit(54mm, 29pt, [ФУНКЦИЙ])
    ]
    #place(top + left, dx: 118mm, dy: 108.5mm)[
      #box(width: 16mm)[
        #align(center)[
          #text(
            size: 54pt,
            weight: "semibold",
            top-edge: "cap-height",
            bottom-edge: "baseline",
          )[#volume]
        ]
      ]
    ]
    #place(top + left, dx: 119mm, dy: 124mm)[
      #line-fit(14mm, 17pt, [ТОМ], weight: "semibold", tracking: 0.12em)
    ]
  ]
}
