#set document(
  title: "Исправления. Теория аналитических функций. Том I",
  date: none,
)
#import "book-style.typ": book-style
#show: book-style
#heading(level: 1, numbering: none)[Исправления]
<front:corrections>

#for item in json("../corrections.json") {
  block(width: 100%, above: 1em, below: 0.5em, [
    #strong(item.location)

    #eval(item.original, mode: "markup") → #eval(
      item.corrected,
      mode: "markup",
    )#if item.corrected.trim().match(regex("[.!?…]$")) == none { [.] }

    #item.reason
  ])
}
