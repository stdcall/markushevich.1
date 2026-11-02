#import "/content/book-style.typ": book-style
#import "/content/main-defs.typ": eq, point, repeat-eq, variant-eq
#show: book-style
= Глава <ch:variants>
== Параграф <sec:variants>
#point() <pt:variants>
#eq[$ a = b $] <eq:base>
#variant-eq([@eq:base], primes: 1)[$ b = c $] <eq:first-variant>
#variant-eq([@eq:base], primes: 2)[$ c = d $] <eq:second-variant>
#repeat-eq([@eq:base])[$ a = c $] <eq:repeated>
#eq[$ d = e $] <eq:next>
Ссылки: @eq:base, @eq:first-variant, @eq:second-variant, @eq:repeated, @eq:next.
