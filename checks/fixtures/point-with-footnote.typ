#import "/content/book-style.typ": book-style
#import "/content/main-defs.typ": petit, point
#show: book-style
#counter(heading).update((3, 3, 2))
#petit[
  #point() <pt:point-with-note>
  Короткий первый абзац с авторской сноской#footnote[Авторская сноска.].

  Следующий обычный абзац завершён.
]
