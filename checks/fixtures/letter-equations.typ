#import "/content/book-style.typ": book-style
#import "/content/main-defs.typ": eq, letter-eq
#show: book-style
#counter(heading).update((1, 1, 1))
#eq[$a=b$] <eq:ordinary-first>
Авторская сноска#footnote[
  #letter-eq[$c=d$] <eq:letter-first>
  #letter-eq[$e=f$] <eq:letter-second>
].
#eq[$g=h$] <eq:ordinary-next>
Ссылки: @eq:ordinary-first, @eq:letter-first, @eq:letter-second,
@eq:ordinary-next.
