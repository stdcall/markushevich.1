#import "/content/book-style.typ": book-style
#import "/content/statements.typ": numbered-example, properties
#show: book-style

#numbered-example[
  Пример с длинными буквенными условиями.
  #properties(
    numbering: "а)",
    [Первое условие.
      #for n in range(40) [Строка первого условия #n. \ ]
      Конец первого условия.
    ],
    [Второе условие.
      #for n in range(40) [Строка второго условия #n. \ ]
      Конец второго условия.
    ],
    [Третье условие.
      #for n in range(40) [Строка третьего условия #n. \ ]
      Конец третьего условия.
    ],
  )
] <ex:long-properties>

Следующий обычный абзац.
