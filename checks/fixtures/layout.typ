#import "/content/book-style.typ": book-style
#show: book-style
#set page(
  width: 152mm,
  height: 110pt,
  margin: 10pt,
  numbering: none,
  header: none,
  footer: none,
)
Обычный абзац перед вводной фразой.

#if sys.inputs.at("test", default: "normal") != "normal" { v(50pt) }

#if sys.inputs.at("test", default: "normal") == "long" {
  [Переходя к произвольной дробно-линейной функции <cue>]
} else { [Так как <cue>] }
$ a^2 + b^2 = c^2. $ <formula>
