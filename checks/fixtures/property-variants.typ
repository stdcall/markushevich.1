#import "/content/book-style.typ": book-style
#import "/content/statements.typ": properties, variant-property
#show: book-style
#properties(
  numbering: "а)",
  [Первое свойство.],
  [Второе свойство.],
  [Третье свойство.],
  [Базовое свойство. <prop:base>],
)
#variant-property([@prop:base], [Эквивалентная форма. <prop:variant>])
#properties(
  numbering: "а)",
  after: [@prop:base],
  [Следующее свойство. <prop:next>],
)
Ссылки: @prop:base, @prop:variant, @prop:next.

Описание: @prop:base[базовое свойство].
