#import "bibliography-data.typ": bibliography-data
#import "main-defs.typ": bibliography-scope

#let languages = (
  russian: "русский",
  english: "английский",
  french: "французский",
  german: "немецкий",
  romanian: "румынский",
)

#let bib-mention(key) = context {
  if not bibliography-scope.get() {
    [#metadata((kind: "bib-mention", key: key))<bib-mention>]
  }
}

#let bib-names(value) = (
  value
    .split(" and ")
    .map(name => {
      let parts = name.split(", ")
      if parts.len() == 2 { parts.at(1) + " " + parts.first() } else { name }
    })
    .join(", ")
)

#let bib-title(key, short: false) = {
  let entry = bibliography-data.at(key)
  bib-mention(key)
  quote(block: false, if short { entry.shorttitle } else { entry.title })
}

#let bib-authors(key, surnames: false) = {
  let authors = bibliography-data.at(key).author
  if surnames {
    authors.split(" and ").map(it => it.split(", ").first()).join(" и ")
  } else { bib-names(authors) }
}

#let bib-backlinks(key) = context {
  let mentions = query(<bib-mention>).filter(it => it.value.key == key)
  let seen = ()
  let pages = ()
  for mention in mentions {
    let loc = mention.location()
    if loc.page() in seen { continue }
    seen.push(loc.page())
    let position = loc.position()
    let folio = counter(page).at(loc)
    let pattern = loc.page-numbering()
    let shown = if pattern == none { str(folio.first()) } else {
      numbering(pattern, ..folio)
    }
    pages.push(box(context {
      metadata((
        kind: "page-reference",
        target: "bib:" + key,
        position: here().position(),
        target-position: position,
      ))
      link(
        (page: position.page, x: 0pt, y: calc.max(0pt, position.y - 8pt)),
        shown,
      )
    }))
  }
  if pages.len() > 0 { [ #text(size: 9pt)[\[#pages.join(", ")\]]] }
}

#let bib-description(key, mention: true, full: false) = {
  let entry = bibliography-data.at(key)
  if mention { bib-mention(key) }
  bib-names(entry.author)
  [, #emph(entry.title)]
  if "subtitle" in entry { [. #entry.subtitle] }
  if "maintitle" in entry { [. #emph(entry.maintitle)] }
  if "booktitle" in entry {
    [, в кн.: ]
    if "bookauthor" in entry { [#bib-names(entry.bookauthor). ] }
    emph(entry.booktitle)
  }
  if "series" in entry { [, #entry.series] }
  if "volume" in entry { [, т.~#entry.volume] }
  if "part" in entry {
    if entry.at("parttype", default: none) == "fascicule" {
      [, вып.~#entry.part]
    } else { [, ч.~#entry.part] }
  }
  if "edition" in entry { [, изд.~#entry.edition] }
  if "translator" in entry { [, пер.~#bib-names(entry.translator)] }
  if "editor" in entry { [, под ред.~#bib-names(entry.editor)] }
  if "location" in entry { [, #entry.location.split(" and ").join(" — ")] }
  if "publisher" in entry { [, #entry.publisher] }
  if "date" in entry { [, #entry.date.replace("/", "–")] } else if (
    "year" in entry
  ) {
    [, #entry.year]
  }
  if "pages" in entry { [, с.~#entry.pages.replace("--", "–")] }
  if full and "note" in entry { [. #entry.note] }
  if full and "origlanguage" in entry {
    [. Язык оригинала: #languages.at(entry.origlanguage)]
  }
  if full and "language" in entry {
    [. Язык: #languages.at(entry.language)]
  }
  if "doi" in entry {
    [. #link("https://doi.org/" + entry.doi)[doi:#entry.doi]]
  }
  if full { [.#bib-backlinks(key)] }
}

#let bib-entry(body) = figure(
  kind: "bibliography",
  supplement: none,
  numbering: "1",
  caption: none,
  body,
)

#let bibliography(body) = {
  pagebreak(weak: true)
  bibliography-scope.update(true)
  show figure.where(kind: "bibliography"): it => context {
    set align(left)
    set par(first-line-indent: 0pt, hanging-indent: 1.5em, justify: false)
    let number = counter(figure.where(kind: "bibliography"))
      .at(it.location())
      .first()
    block(width: 100%, above: 0.7em, below: 0pt, breakable: true)[
      #number. #it.body
    ]
  }
  body
  bibliography-scope.update(false)
}
