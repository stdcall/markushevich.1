#import "main-defs.typ": eq, idx, letter-eq, point, source
#import "statements.typ": named-statement, properties
#import "diagrams/03-02b-cauchy-contours.typ": (
  cancelling-annulus, contour-system, fresnel-sector, gaussian-rectangle,
  indented-semicircle,
)

#source(223)
#point() <pt:cauchy-integral-real-examples>
В первых работах Коши его теорема служила средством вычисления различных
определенных интегралов от функций действительного переменного (главным образом,
несобственных интегралов). Чтобы дать понятие об этих приложениях теоремы Коши,
вызвавших к жизни саму теорему, приведем три примера.

#properties(
  numbering: "1.",
  [*Интегралы Френеля:*
    $integral_0^infinity cos xi^2 dif xi$ и
    $integral_0^infinity sin xi^2 dif xi$.#idx("Интеграл", "Френеля")#idx(
      "Френеля интеграл",
    )

    Для вычисления этих, встречающихся в теории дифракции, интегралов рассмотрим
    вспомогательную функцию комплексного переменного $F(z) = e^(i z^2)$. Функцию
    эту можно рассматривать как сложную функцию $F(z) = phi[f(z)]$, где
    $f(z) = i z^2$ и $phi(zeta) = e^zeta$. Отсюда по правилам дифференцирования
    сложной функции следует, что $F(z)$ дифференцируема во всей плоскости,
    причем $(dif F(z))/(dif z) = 2 i z e^(i z^2)$. Следовательно, к ней
    применима интегральная теорема Коши.

    #figure(fresnel-sector(), caption: [], kind: image) <fig:fresnel-contour>

    Возьмем линию $L$ рис.~@fig:fresnel-contour в качестве контура
    интегрирования. Она состоит из отрезка $O A$ положительной полуоси, длиной
    $R$ ($R$ — произвольное положительное число), дуги $A B$ окружности радиуса
    $R$ с центром в начале координат и отрезка $B O$ биссектрисы первого
    координатного угла. Угол $A O B$ равен, таким образом, $pi/4$.

    В силу интегральной теоремы, интеграл $integral_L e^(i zeta^2) dif zeta$
    равен нулю:
    $
      integral_L e^(i zeta^2) dif zeta
      = integral_(O A) e^(i zeta^2) dif zeta
      + integral_(A B) e^(i zeta^2) dif zeta
      + integral_(B O) e^(i zeta^2) dif zeta = 0.
    $

    #source(224)
    На $O A$ $zeta$ равно действительному числу $xi$. Поэтому
    $dif zeta = dif xi$ и
    $
      J_1 lr((R)) = integral_(O A) e^(i zeta^2) dif zeta
      = integral_0^R e^(i xi^2) dif xi.
    $
    На $A B$ $zeta = R (cos phi + i sin phi)$, где $phi$ меняется в пределах от
    $0$ до $pi/4$. Поэтому
    $
      zeta^2 = R^2 (cos 2 phi + i sin 2 phi)
      quad lr((0 <= 2 phi <= pi/2)), \
      dif zeta = R (-sin phi + i cos phi) dif phi
      = i R (cos phi + i sin phi) dif phi
    $
    и
    $
      J_2 lr((R)) = integral_(A B) e^(i zeta^2) dif zeta = \
      = integral_0^(pi/4) exp[i R^2 (cos 2 phi + i sin 2 phi)]
      i R (cos phi + i sin phi) dif phi.
    $
    Наконец, на $B O$ $zeta = rho lr((cos pi/4 + i sin pi/4))$, где $rho$
    меняется от $R$ до $0$. Поэтому
    $
      zeta^2 = rho^2 lr((cos pi/2 + i sin pi/2)) = i rho^2,
      quad dif zeta = lr((cos pi/4 + i sin pi/4)) dif rho
    $
    и
    $
      J_3 lr((R)) = integral_(B O) e^(i zeta^2) dif zeta
      = integral_R^0 e^(-rho^2) lr((cos pi/4 + i sin pi/4)) dif rho = \
      = -lr((cos pi/4 + i sin pi/4)) integral_0^R e^(-rho^2) dif rho
      = -sqrt(2)/2 (1 + i) integral_0^R e^(-rho^2) dif rho.
    $
    Заставим $R$ неограниченно возрастать. $J_3 lr((R))$ будет стремиться при
    этом к пределу $-sqrt(2)/2 (1 + i) integral_0^infinity e^(-rho^2) dif rho
    = -sqrt(2 pi)/4 (1 + i)$, так как
    $integral_0^infinity e^(-rho^2) dif rho = sqrt(pi)/2$#footnote[
      В самом деле, #letter-eq[$
        integral_(-R)^R integral_(-R)^R e^(-xi^2 - eta^2) dif xi dif eta
        = lr((integral_(-R)^R e^(-xi^2) dif xi))^2
        = 4 lr((integral_0^R e^(-xi^2) dif xi))^2.
      $] <eq:gaussian-square-integral>
      Впишем в квадрат с центром в начале координат, со сторонами, параллельными
      осям координат и равными по длине $2 R$, круг $k$, а также опишем около
      этого квадрата круг $K$. Тогда в силу положительности подынтегральной
      функции
      $
        integral.double_k e^(-xi^2 - eta^2) dif xi dif eta
        < integral_(-R)^R integral_(-R)^R e^(-xi^2 - eta^2) dif xi dif eta
        < integral.double_K e^(-xi^2 - eta^2) dif xi dif eta,
      $
      или, заменяя прямоугольные декартовы координаты $xi$ и $eta$ полярными
      $rho$ и $phi$ и пользуясь формулой @eq:gaussian-square-integral, получим:
      $
        integral_0^(2 pi) integral_0^R e^(-rho^2) rho dif rho dif phi
        < 4 lr((integral_0^R e^(-xi^2) dif xi))^2
        < integral_0^(2 pi) integral_0^(R sqrt(2)) e^(-rho^2) rho dif rho dif
        phi.
      $
      Выполняя интегрирование и извлекая квадратный корень из всех членов
      неравенства, найдем:
      $
        sqrt(pi (1 - e^(-R^2))) < 2 integral_0^R e^(-xi^2) dif xi
        < sqrt(pi (1 - e^(-2 R^2))),
      $
      откуда
      $
        lim_(R -> infinity) 2 integral_0^R e^(-xi^2) dif xi = sqrt(pi)
        quad "или" quad integral_0^infinity e^(-xi^2) dif xi = sqrt(pi)/2.
      $
    ].

    #source(225)
    Покажем, что $J_2 lr((R)) -> 0$ при $R -> infinity$. Для этого оценим модуль
    $abs(J_2 lr((R)))$. Имеем:
    $
      abs(J_2 lr((R))) <= R integral_0^(pi/4)
      abs(exp[i R^2 (cos 2 phi + i sin 2 phi)])
      dot abs(cos phi + i sin phi) dif phi.
    $
    Здесь
    $ abs(exp[i R^2 (cos 2 phi + i sin 2 phi)]) = exp(-R^2 sin 2 phi) $
    и $abs(cos phi + i sin phi) = 1$; поэтому
    $ abs(J_2 lr((R))) <= R integral_0^(pi/4) exp(-R^2 sin 2 phi) dif phi. $
    Но $sin 2 phi >= 2/pi dot 2 phi$ при $0 <= 2 phi <= pi/2$#footnote[
      В самом деле, функция $f(alpha) = (sin alpha)/alpha$ убывает в интервале
      $lr((0, pi/2))$, так как ее производная
      $
        f' lr((alpha)) = (alpha cos alpha - sin alpha)/alpha^2
        = (cos alpha (alpha - op("tg") alpha))/alpha^2 < 0
      $
      при $0 < alpha < pi/2$. Поэтому $f(alpha) > f(pi/2)$, если $alpha < pi/2$,
      т.~е. $(sin alpha)/alpha > 2/pi$, или
      $ sin alpha > 2/pi alpha quad lr((0 < alpha < pi/2)). $
      Это неравенство переходит в равенство при $alpha = 0$ или $alpha = pi/2$.
    ].

    #source(226)
    Следовательно,
    $
      abs(J_2 lr((R))) <= R integral_0^(pi/4) exp lr((-4/pi R^2 phi)) dif phi
      = R lr((exp lr((-4/pi R^2 phi)))/(-4/pi R^2) |)_0^(pi/4) = \
      = pi/4 (1 - e^(-R^2))/R,
    $
    откуда и вытекает, что
    $ lim_(R -> infinity) J_2 lr((R)) = 0. $
    Наконец, рассмотрим
    $
      J_1 lr((R)) = integral_0^R e^(i xi^2) dif xi
      = integral_0^R cos xi^2 dif xi + i integral_0^R sin xi^2 dif xi.
    $
    Так как $J_1 lr((R)) + J_2 lr((R)) + J_3 lr((R)) = 0$ при любом $R$, то
    $J_1 lr((R)) = -J_2 lr((R)) - J_3 lr((R))$ и
    $
      lim_(R -> infinity) J_1 lr((R))
      = -lim_(R -> infinity) J_2 lr((R)) - lim_(R -> infinity) J_3 lr((R))
      = sqrt(2 pi)/4 (1 + i),
    $
    т.~е.
    $
      lim_(R -> infinity) lr(
        (integral_0^R cos xi^2 dif xi
          + i integral_0^R sin xi^2 dif xi)
      ) = sqrt(2 pi)/4 (1 + i).
    $
    Отсюда следует, во-первых, что существуют интегралы
    $
      integral_0^infinity cos xi^2 dif xi
      = lim_(R -> infinity) integral_0^R cos xi^2 dif xi
      \ "и" quad
      integral_0^infinity sin xi^2 dif xi
      = lim_(R -> infinity) integral_0^R sin xi^2 dif xi
    $
    и, во-вторых, что
    $
      integral_0^infinity cos xi^2 dif xi
      = integral_0^infinity sin xi^2 dif xi = sqrt(2 pi)/4.
    $
    <prop:fresnel-integrals>],
)

#properties(
  after: [@prop:fresnel-integrals],
  numbering: "1.",
  [*Интеграл*
    $
      integral_(-infinity)^(+infinity) e^(-lambda x^2) cos (2 lambda alpha x)
      dif x
      quad (lambda > 0, alpha > 0).
    $

    #source(227)
    Для его вычисления будем интегрировать функцию $f(z) = e^(-lambda z^2)$ по
    контуру $L$ прямоугольника, изображенного на рис.~@fig:gaussian-contour. Так
    как эта функция дифференцируема во всей плоскости, то к ней применима
    интегральная теорема. Следовательно,
    $
      integral_L e^(-lambda zeta^2) dif zeta
      = integral_(A B) e^(-lambda zeta^2) dif zeta
      + integral_(B C) e^(-lambda zeta^2) dif zeta + \
      + integral_(C D) e^(-lambda zeta^2) dif zeta
      + integral_(D A) e^(-lambda zeta^2) dif zeta = 0.
    $

    #figure(gaussian-rectangle(), caption: [], kind: image)
    <fig:gaussian-contour>

    На $A B$
    $ zeta = x quad (-R <= x <= R) quad "и" quad dif zeta = dif x; $
    поэтому
    $
      J_1 = integral_(A B) e^(-lambda zeta^2) dif zeta
      = integral_(-R)^(+R) e^(-lambda x^2) dif x.
    $
    На $B C$
    $
      zeta = R + i y quad (0 <= y <= alpha),
      quad zeta^2 = R^2 + 2 i R y - y^2 quad "и" quad dif zeta = i dif y,
    $
    поэтому
    $
      J_2 = integral_(B C) e^(-lambda zeta^2) dif zeta
      = integral_0^alpha exp[-lambda (R^2 + i 2 R y - y^2)] i dif y = \
      = i integral_0^alpha exp[-lambda (R^2 - y^2)] exp(-2 R i y lambda) dif y.
    $
    На $C D$
    $
      zeta = x + i alpha quad (R >= x >= -R),
      quad zeta^2 = x^2 + 2 i alpha x - alpha^2 quad "и" quad dif zeta = dif x,
    $
    следовательно,
    $
      J_3 = integral_(C D) e^(-lambda zeta^2) dif zeta
      = integral_(+R)^(-R) exp[-lambda (x^2 + 2 i alpha x - alpha^2)] dif x = \
      = -e^(lambda alpha^2) integral_(-R)^(+R) exp(
        -lambda x^2 - 2 i alpha
        lambda x
      ) dif x = \
      = -e^(lambda alpha^2) integral_(-R)^(+R) e^(-lambda x^2)
      [cos (2 lambda alpha x) - i sin (2 lambda alpha x)] dif x.
    $
    Наконец, на $D A$
    $
      zeta = -R + i y quad (alpha >= y >= 0),
      quad zeta^2 = R^2 - 2 R i y - y^2 quad "и" quad dif zeta = i dif y;
    $

    #source(228)
    поэтому
    $
      J_4 = integral_(D A) e^(-lambda zeta^2) dif zeta
      = integral_alpha^0 exp[-lambda (R^2 - 2 R i y - y^2)] i dif y = \
      = -i integral_0^alpha exp[-lambda (R^2 - y^2)] exp(2 R i y lambda) dif y.
    $
    Заставим теперь $R$ неограниченно возрастать. Тогда интегралы $J_2$ и $J_4$
    будут стремиться к нулю. В самом деле,
    $
      abs(J_2) <= integral_0^alpha abs(exp[-lambda (R^2 - y^2)])
      abs(exp(-2 i R lambda y)) dif y
      = integral_0^alpha e^(-lambda (R^2 - y^2)) dif y.
    $
    При $R > alpha$ получаем:
    $
      abs(J_2) <= integral_0^alpha exp[-lambda (R^2 - alpha^2)] dif y
      = \
      = alpha exp[-lambda (R^2 - alpha^2)] -> 0 quad (R -> infinity).
    $
    Точно так же
    $
      abs(J_4) <= integral_0^alpha abs(exp[-lambda (R^2 - y^2)])
      abs(exp 2 i R lambda y) dif y = \
      = integral_0^alpha exp[-lambda (R^2 - y^2)] dif y -> 0
      quad (R -> infinity).
    $
    Интеграл $J_1$ при $R -> infinity$ будет стремиться к пределу
    $
      integral_(-infinity)^(+infinity) exp(-lambda x^2) dif x
      = 1/sqrt(lambda) integral_(-infinity)^(+infinity)
      exp[-(sqrt(lambda) x)^2] dif (sqrt(lambda) x) = sqrt(pi/lambda)
    $
    (так как $integral_(-infinity)^(+infinity) e^(-x^2) dif x = sqrt(pi)$; см.
    предыдущий пример).

    Наконец, из соотношения
    $ J_1 + J_2 + J_3 + J_4 = 0 $
    выводим:
    $
      e^(lambda alpha^2) integral_(-infinity)^(+infinity) e^(-lambda x^2)
      [cos (2 lambda alpha x) - i sin (2 lambda alpha x)] dif x = \
      = -lim_(R -> infinity) J_3
      = lim_(R -> infinity) J_1 + lim_(R -> infinity) J_2
      + lim_(R -> infinity) J_4 = sqrt(pi/lambda).
    $

    #source(229)
    Сравнивая в этом соотношении действительные части, получаем:
    $
      e^(lambda alpha^2) integral_(-infinity)^(+infinity)
      e^(-lambda x^2) cos (2 lambda alpha x) dif x = sqrt(pi/lambda),
    $
    т.~е.
    $
      integral_(-infinity)^(+infinity) e^(-lambda x^2) cos (2 lambda alpha x)
      dif x
      = sqrt(pi/lambda) e^(-lambda alpha^2).
    $
    <prop:gaussian-fourier-integral>],
)

#properties(
  after: [@prop:gaussian-fourier-integral],
  numbering: "1.",
  [*Интеграл* $integral_0^infinity (sin xi)/xi dif xi$.

    Возьмем вспомогательную функцию $f(z) = e^(i z)/z$. Функция эта определена в
    области $G$, образованной всеми точками плоскости, исключая начало
    координат, и дифференцируема в этой области (в последнем убеждаемся прямым
    дифференцированием: $(dif f(z))/(dif z) = (e^(i z) (i z - 1))/z^2$).

    #figure(indented-semicircle(), caption: [], kind: image)
    <fig:dirichlet-contour>

    Беря контур интегрирования $L$, изображенный на рис.~@fig:dirichlet-contour
    (этот контур, как и все точки его внутренности, лежит в области $G$), найдем
    по интегральной теореме, примененной к функции $f(z) = e^(i z)/z$:
    $
      integral_L (e^(i zeta) dif zeta)/zeta
      = integral_(A B) (e^(i zeta) dif zeta)/zeta
      + integral_(B C D) (e^(i zeta) dif zeta)/zeta + \
      + integral_(D E) (e^(i zeta) dif zeta)/zeta
      + integral_(E F A) (e^(i zeta) dif zeta)/zeta = 0.
    $
    На $A B$ $zeta$ равно действительному числу $xi$. Поэтому
    $dif zeta = dif xi$ и интеграл
    $
      J_1 = integral_(A B) (e^(i zeta) dif zeta)/zeta
      = integral_r^R (e^(i xi) dif xi)/xi = \
      = integral_r^R (cos xi dif xi)/xi + i integral_r^R (sin xi dif xi)/xi.
    $
    На $B C D$ $zeta = R (cos phi + i sin phi)$ $(0 <= phi <= pi)$, поэтому
    $
      dif zeta = R (-sin phi + i cos phi) dif phi
      = i R (cos phi + i sin phi) dif phi
    $
    и
    $
      J_2 = integral_(B C D) (e^(i zeta) dif zeta)/zeta
      = \
      = integral_0^pi (exp[i R (cos phi + i sin phi)] i R (cos phi + i sin phi))
      /(R (cos phi + i sin phi)) dif phi = \
      = i integral_0^pi exp(i R cos phi - R sin phi) dif phi.
    $

    #source(230)
    На $D E$ $zeta$ равно действительному числу $xi$; поэтому
    $dif zeta = dif xi$ и
    $
      J_3 = integral_(D E) (e^(i zeta) dif zeta)/zeta
      = integral_(-R)^(-r) (e^(i xi) dif xi)/xi
      = integral_(-R)^(-r) (cos xi dif xi)/xi
      + i integral_(-R)^(-r) (sin xi dif xi)/xi.
    $
    Заменяя здесь переменную интегрирования $xi$ на $-xi$, получим:
    $
      J_3 = -integral_r^R (cos xi dif xi)/xi
      + i integral_r^R (sin xi dif xi)/xi.
    $
    Наконец, на $E F A$
    $ zeta = r (cos phi + i sin phi) quad (pi >= phi >= 0); $
    поэтому
    $ dif zeta = i r (cos phi + i sin phi) dif phi $
    и
    $
      J_4 = integral_(E F A) (e^(i zeta) dif zeta)/zeta
      = \
      = integral_pi^0 (exp[i r (cos phi + i sin phi)] i r (cos phi + i sin phi))
      /(r (cos phi + i sin phi)) dif phi = \
      = -i integral_0^pi exp(i r cos phi - r sin phi) dif phi.
    $
    Заставим $R$ неограниченно возрастать; при этом
    $ J_2 = i integral_0^pi exp(i R cos phi - R sin phi) dif phi $
    будет стремиться к нулю. В самом деле,
    $
      abs(J_2) = abs(integral_0^pi exp(i R cos phi - R sin phi) dif phi)
      <= \
      <= integral_0^pi abs(exp(i R cos phi - R sin phi)) dif phi = \
      = 2 integral_0^(pi/2) exp(-R sin phi) dif phi
      < 2 integral_0^(pi/2) exp lr((-R 2/pi phi)) dif phi = \
      = pi (1 - e^(-R))/R < pi/R,
    $
    откуда и следует, что $lim_(R -> infinity) J_2 = 0$.

    Пусть, наконец, $r$ стремится к нулю; найдем предел интеграла $J_4$, равного
    $ -i integral_0^pi exp(i r cos phi - r sin phi) dif phi. $

    #source(231)
    Так как функция $exp(i z)$ непрерывна в точке $z = 0$, где она обращается в
    единицу, то для любого $epsilon > 0$ можно указать такое
    $delta(epsilon) > 0$, что при $abs(z) = r < delta(epsilon)$ будет
    выполняться неравенство
    $ abs(exp(i z) - 1) = abs(exp(i r cos phi - r sin phi) - 1) < epsilon. $
    Отсюда вытекает, что
    $
      abs(J_4 - lr((-i integral_0^pi 1 dot dif phi)))
      = abs(integral_0^pi [exp(i r cos phi - r sin phi) - 1] dif phi)
      < pi epsilon,
    $
    т.~е.
    $ lim_(r -> 0) J_4 = -i integral_0^pi 1 dot dif phi = -pi i. $
    Возвращаясь к основному соотношению
    $ integral_L (e^(i zeta) dif zeta)/zeta = J_1 + J_2 + J_3 + J_4 = 0, $
    выводим из него: $J_1 + J_3 = -J_2 - J_4$ или, пользуясь указанными выше
    выражениями для $J_1$ и $J_3$:
    $ 2 i integral_r^R (sin xi dif xi)/xi = -J_2 - J_4. $
    При $R -> infinity$ и $r -> 0$ правая часть, как мы видели, стремится к
    пределу $-lim_(R -> infinity) J_2 - lim_(r -> 0) J_4 = pi i$. Следовательно,
    и левая часть стремится к тому же пределу:
    $ lim_(R -> infinity, r -> 0) 2 i integral_r^R (sin xi)/xi dif xi = pi i. $
    Обозначая $lim_(R -> infinity, r -> 0) integral_r^R (sin xi)/xi dif xi$,
    существование которого мы доказали, через
    $integral_0^infinity (sin xi)/xi dif xi$, получаем:
    $2 i integral_0^infinity (sin xi)/xi dif xi = pi i$, или окончательно
    $ integral_0^infinity (sin xi)/xi dif xi = pi/2. $
    <prop:dirichlet-sine-integral>],
)

#source(232)
#point() <pt:cauchy-integral-multiply-connected>
Мы доказали интегральную теорему для функций аналитических в односвязных
областях. Легко видеть, что теорему эту, без оговорок, нельзя распространить на
неодносвязные области. Рассмотрим, например, функцию $f(z) = 1/z$,
дифференцируемую при любом $z != 0$. В качестве области $G$ здесь можно принять
всю конечную плоскость, исключая из нее начало координат. Очевидно, $G$ не
является односвязной областью, так как внутренность любой принадлежащей $G$
окружности $gamma$ с центром в начале координат не вся принадлежит $G$. Вместе с
тем $integral_gamma 1/z dif z = 2 pi i != 0$
(п.~@pt:complex-integral-properties,
пример~@prop:circular-cauchy-kernel-example).

Однако с некоторыми ограничениями, наложенными на кривые, интегральную теорему
можно применять и к неодносвязным областям $G$. Пусть, прежде всего, $L$ —
треугольник, принадлежащий области $G$ вместе со всеми своими внутренними
точками. Тогда для любой функции $f(z)$, однозначной и аналитической в
(неодносвязной) области $G$, к интегралу $integral_L f(z) dif z$ применимы все
рассуждения п.~@pt:cauchy-integral-proof, б) и, следовательно,
$integral_L f(z) dif z = 0$. К такому же выводу, со ссылкой на
п.~@pt:cauchy-integral-proof, в), мы придем и тогда, когда $L$ есть произвольная
замкнутая ломаная, принадлежащая $G$ и притом такая, что все многоугольные
области, ограниченные ею, также принадлежат $G$. Пусть, наконец, $L$ —
произвольная замкнутая спрямляемая кривая, принадлежащая области $G$. Рассмотрим
$integral_L f(z) dif z$. По лемме п.~@pt:polygonal-integral-approximation этот
интеграл можно с точностью до произвольно малого $epsilon > 0$ заменять
интегралами по ломаным $Lambda$, вписанным в $L$ и принадлежащим той же области
$G$. Если для таких ломаных с достаточно малыми звеньями ограниченные этими
ломаными многоугольные области принадлежат $G$, то соответствующие интегралы
обращаются в нуль, а следовательно, должен равняться нулю и интеграл вдоль $L$
(ср. п.~@pt:cauchy-integral-proof, г)).

Указанные условия являются достаточными для того, чтобы интеграл от
аналитической функции $integral_L f(z) dif z$, взятый вдоль замкнутой
спрямляемой кривой, принадлежащей неодносвязной области, был равен нулю. Нулевое
значение интеграла получается, например, тогда, когда $L$ принадлежит некоторой
односвязной области $g$, являющейся подобластью по отношению к $G$, но и не
только в этом случае. На рис.~@fig:annular-cancelling-contour изображена кривая
$L$, принадлежащая двусвязной области $G$. Очевидно, не существует односвязной
#source(233)подобласти области $G$, которая содержала бы $L$. Тем не менее, как
будет следовать из @thm:cauchy-contour-system[следующей теоремы для системы
  контуров], $integral_L f(z) dif z = 0$ для любой функции $f(z)$, аналитической
в области $G$.

#figure(cancelling-annulus(), caption: [], kind: image)
<fig:annular-cancelling-contour>

С помощью сделанных замечаний нетрудно доказать справедливость следующей
теоремы, которой мы неоднократно будем пользоваться.

#idx("Интегральная теорема Коши")#idx("Коши", "интегральная теорема")
#named-statement("Интегральная теорема для системы контуров")[
  Пусть $f(z)$ — однозначная и аналитическая функция в произвольной области $G$
  и $Gamma$, $gamma_1$, $gamma_2$, $dots$, $gamma_n$ — система замкнутых
  спрямляемых жордановых кривых, лежащих в области $G$ и удовлетворяющих
  следующим условиям:
  #properties(
    numbering: "а)",
    [кривые $gamma_k$ $(k = 1, 2, dots, n)$ принадлежат внутренности $Gamma$;],
    [для любого $k_0$ $(k_0 = 1, 2, dots, n)$ кривые $gamma_k$ при $k != k_0$
      лежат во внешности $gamma_(k_0)$;],
    [многосвязная область $g$, ограниченная кривыми $Gamma$, $gamma_1$, $dots$,
      $gamma_n$ (она получается, если из внутренности $Gamma$ исключить
      замкнутые области, ограниченные кривыми $gamma_k$, $k = 1, 2, dots, n$),
      принадлежит области $G$.],
  )
  При этих условиях имеет место равенство #eq[$
    integral_Gamma f(z) dif z
    = integral_(gamma_1) f(z) dif z + integral_(gamma_2) f(z) dif z
    + dots + integral_(gamma_n) f(z) dif z,
  $] <eq:cauchy-contour-system>
  где все интегралы берутся в одном и том же направлении, например так, что
  внутренности кривых остаются слева от наблюдателя, обходящего кривые в
  направлении интегрирования (положительное направление).
] <thm:cauchy-contour-system>

Заметим, что утверждение этой теоремы становится тривиальным в случае
односвязной области $G$, так как в этом случае все интегралы в равенстве
@eq:cauchy-contour-system обращаются в нуль.

Для доказательства теоремы в общем случае проведем в области $G$ жордановы
спрямляемые дуги $delta'_1$, $delta'_2$, $dots$, $delta'_n$, $delta'_(n + 1)$,
соединяющие последовательно некоторую точку $z_0$ кривой $Gamma$ с точкой
$zeta_1$ на кривой $gamma_1$, далее некоторую точку $z_1 != zeta_1$ на $gamma_1$
с точкой $zeta_2$, лежащей на $gamma_2$, и т.~д., наконец, точку $z_n$ кривой
$gamma_n$ с точкой $zeta_0 != z_0$ кривой $Gamma$. Вообще говоря, эти дуги будут
частично выходить за пределы области $g$. Но их можно всегда заменить другими
дугами: $delta_1$, $delta_2$, $dots$, $delta_(n + 1)$, которые будут, за
исключением своих концов, принадлежать области $g$ целиком #source(234)
(рис.~@fig:cauchy-contour-cuts). Для этого выберем у каждой из соединяемых
границ короткий отрезок, один конец которого лежит на границе, а остальные точки
— в $g$. Свободные концы этих отрезков можно соединить ломаной, лежащей в $g$;
удаляя петли у полученной кривой, получим нужную жорданову спрямляемую дугу.
Концы новых дуг обозначим прежними буквами. Вообще говоря, различные дуги
$delta_k$ и $delta_m$ $(k != m)$ могут иметь при этом точки пересечения. Но их
всегда можно заменить другими дугами, удовлетворяющими поставленным условиям и
попарно не имеющими общих точек. Мы не останавливаемся на этом, предоставляя
читателю проведение всех необходимых рассуждений.

#figure(contour-system(), caption: [], kind: image) <fig:cauchy-contour-cuts>

Начальные и конечные точки дуг $delta_1$, $delta_2$, $dots$, $delta_(n + 1)$
разобьют каждую из кривых $Gamma$, $gamma_1$, $dots$, $gamma_n$ на две части,
которые мы будем обозначать теми же буквами, что и всю кривую, но с одним или
двумя штрихами наверху: $Gamma'$, $Gamma''$; $gamma'_1$, $gamma''_1$, $dots$,
$gamma'_n$, $gamma''_n$. Началом дуг $Gamma'$ и $Gamma''$ мы будем считать
начало $z_0$ дуги $delta_1$, а концом — конец $zeta_0$ дуги $delta_(n + 1)$;
началом дуг $gamma'_1$ и $gamma''_1$ — конец $zeta_1$ дуги $delta_1$, а концом —
начало $z_1$ дуги $delta_2$ и т.~д.; наконец, началом дуг $gamma'_n$ и
$gamma''_n$ — конец $zeta_n$ дуги $delta_n$, а концом — начало $z_n$ дуги
$delta_(n + 1)$. Дуги $Gamma'$ и $Gamma''$; $gamma'_1$ и $gamma''_1$; $dots$;
$gamma'_n$ и $gamma''_n$ образуют вместе с $delta_1$, $delta_2$, $dots$,
$delta_(n + 1)$ две замкнутые жордановы спрямляемые кривые. Одна из них,
$Lambda'$, будет образована, например, дугами $Gamma'$, $-delta_(n + 1)$,
$-gamma'_n$, $-delta_n$, $dots$, $-gamma'_1$, $-delta_1$, а другая, $Lambda''$,
— дугами $-Gamma''$, $delta_1$, $gamma''_1$, $dots$, $delta_n$, $gamma''_n$,
$delta_(n + 1)$.

В силу построения, внутренности кривых $Lambda'$ и $Lambda''$ лежат в области
$g$ и, следовательно, принадлежат области $G$. Поэтому к ним применима
интегральная теорема Коши
$
  integral_(Lambda') f(z) dif z = 0 quad "и" quad integral_(Lambda'') f(z) dif z
  = 0.
$

#source(235)
Складывая почленно полученные равенства и замечая, что части интегралов по дугам
$delta_k$ и $-delta_k$ $(k = 1, 2, dots, n + 1)$ взаимно уничтожаются, а части
интегралов по парам дуг $Gamma'$, $-Gamma''$, $-gamma'_1$, $gamma''_1$, $dots$,
$-gamma'_n$, $gamma''_n$ дадут интегралы $integral_Gamma f(z) dif z$,
$integral_(-gamma_1) f(z) dif z$, $dots$, $integral_(-gamma_n) f(z) dif z$,
получаем:
$
  integral_Gamma f(z) dif z + integral_(-gamma_1) f(z) dif z
  + dots + integral_(-gamma_n) f(z) dif z = 0,
$
или
$
  integral_Gamma f(z) dif z = integral_(gamma_1) f(z) dif z
  + dots + integral_(gamma_n) f(z) dif z.
$
Это и есть нужный результат.
