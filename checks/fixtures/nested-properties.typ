#import "/content/book-style.typ": book-style
#import "/content/statements.typ": properties
#show: book-style
#properties(
  numbering: "а)",
  [Первый этап.],
  [Второй этап содержит внутренние свойства:
    #properties(
      [Первое внутреннее свойство. <prop:inner-first>],
      [Второе внутреннее свойство. <prop:inner-second>],
    )],
)
Ссылки на внутренние свойства: @prop:inner-first, @prop:inner-second.
