#let title-page() = page(
  width: 152mm,
  height: 220mm,
  margin: (x: 18mm, top: 22mm, bottom: 19mm),
  fill: white,
  numbering: "1",
  header: none,
  footer: none,
  background: none,
  foreground: none,
)[
  #set text(font: "Libertinus Serif", fill: black, lang: "ru")
  #set par(first-line-indent: 0pt, justify: false, leading: 0.5em)
  #align(center)[
    #text(size: 14pt, tracking: 0.08em)[А. И. МАРКУШЕВИЧ]

    #v(29mm)
    #text(size: 23pt, weight: "semibold", tracking: 0.02em)[
      ТЕОРИЯ \
      АНАЛИТИЧЕСКИХ \
      ФУНКЦИЙ
    ]

    #v(15mm)
    #text(size: 13pt, tracking: 0.12em)[ТОМ I]

    #v(6mm)
    #text(size: 16pt, tracking: 0.05em)[НАЧАЛА ТЕОРИИ]

    #v(12mm)
    #text(size: 11pt, tracking: 0.1em)[ИЗДАНИЕ ВТОРОЕ]

    #v(1fr)
    #text(size: 11pt, tracking: 0.08em)[МОСКВА • НАУКА • 1967]
  ]
]
