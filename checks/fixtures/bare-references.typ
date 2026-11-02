#import "/content/book-style.typ": book-style
#import "/content/main-defs.typ": eq, point
#show: book-style
#counter(heading).update((1, 1, 0))
#point() <pt:bare-reference-target>
Утверждение с формулой.
#eq[$a=b$] <eq:bare-reference-target>
#pagebreak()
@pt:bare-reference-target

@eq:bare-reference-target
