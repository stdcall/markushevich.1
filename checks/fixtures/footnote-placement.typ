#import "/content/book-style.typ": book-style
#show: book-style
#set page(
  width: 152mm,
  height: 180pt,
  margin: 10pt,
  numbering: none,
  header: none,
  footer: none,
)
Начало страницы.
#v(100pt)
#if sys.inputs.at("test", default: "heading") == "heading" {
  heading(level: 2, outlined: false)[Вводный раздел]
} else {
  [$ a^2 + b^2 = c^2. $]
}
Начало абзаца с авторской сноской#footnote[Текст проверяемой сноски.],
который переходит на следующую страницу целиком.
