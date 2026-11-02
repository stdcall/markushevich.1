#import "/content/book-style.typ": book-style
#import "/content/main-defs.typ": point
#show: book-style
#outline(title: none)

Глава @ch:test, § @sec:test и пункт @pt:test.

= Проверка начала главы <ch:test>

== Проверка начала параграфа <sec:test>

#point() <pt:test>
Первый абзац достаточно длинен, чтобы занимать несколько строк: ссылка на
параграф должна вести к его заголовку, а ссылка на пункт — к началу этого
абзаца. Продолжение абзаца сохраняет несколько строк обычного книжного текста.
