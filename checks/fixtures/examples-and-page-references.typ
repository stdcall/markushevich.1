#import "/content/book-style.typ": book-style
#import "/content/main-defs.typ": eq, page-ref, point
#import "/content/statements.typ": (
  numbered-example, numbered-theorem, properties,
)
#show: book-style
#counter(heading).update((1, 1, 0))
#counter(page).update(7)
#point() <pt:examples-first>
Первый пункт.

#numbered-example[Первый пример.] <ex:first>
#numbered-theorem[Промежуточная теорема.] <thm:between-examples>
#numbered-example[Второй пример.] <ex:second>
#properties(numbering: "а)", [Первое условие. <prop:page-target>])
#eq[$ a = b $] <eq:examples-first>

#pagebreak()
#point() <pt:examples-next>
Следующий пункт.

#numbered-example[Следующий пример.] <ex:reset>
#eq[$ c = d $] <eq:examples-next>

Ссылки на примеры: @ex:first, @ex:second, @ex:reset.

Первая страница примера: #page-ref[@ex:first].

Следующая страница примера: #page-ref[@ex:reset].

Страница условия: #page-ref[@prop:page-target].
