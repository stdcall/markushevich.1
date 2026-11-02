#import "main-defs.typ": eq, idx, point, source, variant-eq
#import "statements.typ": named-statement
#import "diagrams/04-02a-laurent-annulus.typ": laurent-annulus

== Ряд Лорана. Ряды Дирихле. Теорема Рунге
<sec:laurent-dirichlet-runge>

#source(380)
#point() <pt:laurent-series>
Среди классов рядов аналитических функций, отличных от степенных, наиболее
близкими к степенным по своему происхождению и свойствам являются ряды,
расположенные по целым отрицательным степеням $z-z_0$: #eq[$
  A_0+A_1 lr((z-z_0))^(-1)+A_2 lr((z-z_0))^(-2)+dots
  \ +A_n lr((z-z_0))^(-n)+dots
$] <eq:negative-power-series>
Полагая $zeta=1/(z-z_0)$, преобразуем @eq:negative-power-series ряд к виду:
#eq[$ A_0+A_1 zeta+A_2 zeta^2+dots+A_n zeta^n+dots. $]
<eq:negative-power-series-inversion>

#source(381)
Радиус сходимости последнего ряда есть
$R=1/(limits(overline(lim))_(n -> oo) root(n, abs(A_n)))$; если $R=0$, то ряд
@eq:negative-power-series-inversion сходится только в точке $zeta=0$; если
$0<R<oo$, то ряд абсолютно сходится в круге $abs(zeta)<R$ и расходится вне его;
наконец, если $R=oo$, то ряд абсолютно сходится в каждой конечной точке
плоскости. Отсюда в силу соотношения $abs(zeta)=1/abs(z-z_0)$ следует, что если
$overline(lim) root(n, abs(A_n))=oo$, то ряд @eq:negative-power-series
расходится в каждой конечной точке; если $0<overline(lim) root(n, abs(A_n))<oo$,
то он абсолютно сходится при $abs(z-z_0)>overline(lim) root(n, abs(A_n))$ и
расходится при $abs(z-z_0)<overline(lim) root(n, abs(A_n))$; наконец, если
$overline(lim) root(n, abs(A_n))=0$, то ряд абсолютно сходится во всех точках
плоскости, за исключением точки $z=z_0$. Иными словами, область сходимости ряда
@eq:negative-power-series есть _внешность круга_ радиуса
$r=limits(overline(lim))_(n -> oo) root(n, abs(A_n))$ с центром $z_0$, которая
при $r=oo$ вырождается в бесконечно удаленную точку, при $0<r<oo$ является
внешностью круга в собственном смысле слова и, наконец, при $r=0$ превращается
во всю плоскость, за исключением из нее точки $z=z_0$. Будем считать, что
$r=overline(lim) root(n, abs(A_n))<oo$; тогда действительно существует область
сходимости ряда @eq:negative-power-series $abs(z-z_0)>r$, которую мы обозначим
через $K$. Так как ряд @eq:negative-power-series-inversion сходится равномерно
на каждом замкнутом ограниченном множестве точек круга $k: abs(zeta)<R$ и
дробно-линейное преобразование $zeta=1/(z-z_0)$ переводит любое замкнутое
ограниченное множество точек области $K$ в некоторое замкнутое ограниченное
множество точек круга $k$, то ряд @eq:negative-power-series равномерно сходится
внутри области $K$. В этой области он определяет функцию $F(z)$: #variant-eq(
  [@eq:negative-power-series],
  primes: 1,
)[$
  F(z)=A_0+A_1 lr((z-z_0))^(-1)+dots+A_n lr((z-z_0))^(-n)+dots,
$] <eq:analytic-function-at-infinity>
аналитическую (по @thm:weierstrass-analytic-series[теореме Вейерштрасса]) во
всех конечных точках области $K$. В бесконечно удаленной точке $F(z)$ принимает
значение $A_0$: $F(oo)=A_0$. #metadata(none) <def:analytic-at-infinity>
Мы будем, по определению, называть функцию $F(z)$ _аналитической в бесконечно
удаленной точке_. Таким образом, аналитичность функции в бесконечно удаленной
точке будет характеризоваться наличием разложения вида
@eq:analytic-function-at-infinity, сходящегося в некоторой окрестности
бесконечно удаленной точки.

Рядом, обобщающим понятие ряда, расположенного только по целым неотрицательным
степеням $z-z_0$ (степенного ряда) или только по целым неположительным степеням
$z-z_0$, является _ряд Лорана_.
#source(382)
#idx("Лорана ряд", target: <eq:laurent-series>)#idx(
  "Ряд",
  "Лорана",
  target: <eq:laurent-series>,
)Так называется ряд вида #eq[$
  sum_(-oo)^(+oo) a_n lr((z-z_0))^n.
$] <eq:laurent-series>
Ряд этот понимается как сумма двух рядов: #eq[$
  sum_0^oo a_n lr((z-z_0))^n quad "и" quad
  sum_1^oo a_(-m) lr((z-z_0))^(-m)
$] <eq:laurent-series-two-parts>
и рассматривается как сходящийся тогда и только тогда, когда сходятся оба ряда
@eq:laurent-series-two-parts. Итак, по определению:
$
  sum_(-oo)^(+oo) a_n lr((z-z_0))^n
  =lim_(nu -> oo) sum_0^nu a_n lr((z-z_0))^n
  +lim_(mu -> oo) sum_1^mu a_(-m) lr((z-z_0))^(-m),
$
или, что то же самое, #eq[$
  sum_(-oo)^(+oo) a_n lr((z-z_0))^n
  =lim_(nu -> oo \ mu -> oo) sum_(-mu)^nu a_n lr((z-z_0))^n.
$] <eq:laurent-series-independent-limits>
Здесь $mu$ и $nu$ стремятся к бесконечности независимо друг от друга. В
последнюю запись вкладывается следующий смысл: для любого $epsilon>0$ существует
такое $N(epsilon)$, что неравенство
$
  abs(
    sum_(-oo)^(+oo) a_n lr((z-z_0))^n
    -sum_(-mu)^nu a_n lr((z-z_0))^n
  )<epsilon
$
выполняется при $nu>N(epsilon)$ и $mu>N(epsilon)$.

В силу определения, свойства абсолютной и равномерной сходимости ряда Лорана
сводятся к соответствующим свойствам рядов @eq:laurent-series-two-parts.

Обозначим $limits(overline(lim))_(n -> oo) root(n, abs(a_n))$ через $lambda$ и
$limits(overline(lim))_(m -> oo) root(m, abs(a_(-m)))$ через $r$. Тогда первый
из рядов @eq:laurent-series-two-parts сходится абсолютно и равномерно внутри
области $G$, представляющей внутренность окружности
$Gamma: abs(z-z_0)=1/lambda=R$, и расходится во внешности этой окружности, а
второй из рядов @eq:laurent-series-two-parts сходится абсолютно и равномерно
внутри области $g$, представляющей внешность окружности $gamma: abs(z-z_0)=r$, и
расходится во внутренности этой окружности.

Области $G$ и $g$ имеют общие точки тогда и только тогда, когда выполняется
неравенство #eq[$ r<R. $] <eq:laurent-annulus-nonempty>
#metadata(none) <def:laurent-circular-annulus>
В этом случае общая часть областей $G$ и $g$ представляет _круговое кольцо_#idx(
  "Круговое кольцо",
  target: <def:laurent-circular-annulus>,
) $D$: #eq[$ r<abs(z-z_0)<R. $] <eq:laurent-convergence-annulus>

#source(383)
Внутри области @eq:laurent-convergence-annulus оба ряда сходятся абсолютно и
равномерно; следовательно, внутри этой области абсолютно и равномерно сходится и
ряд Лорана @eq:laurent-series, представляющий в $D$ некоторую аналитическую
функцию: #eq[$
  f(z)=sum_(-oo)^(+oo) a_n lr((z-z_0))^n, quad r<abs(z-z_0)<R.
$] <eq:laurent-series-sum>
В каждой точке, для которой $abs(z-z_0)<r$ или $abs(z-z_0)>R$, расходится один
из рядов @eq:laurent-series-two-parts, тогда как другой ряд продолжает
сходиться; отсюда следует, что в этих точках ряд Лорана расходится. Итак,
_область сходимости ряда Лорана есть круговое кольцо_ (при условии
@eq:laurent-annulus-nonempty). В дальнейшем, говоря о рядах Лорана, мы всегда
будем предполагать, что выполнено условие @eq:laurent-annulus-nonempty, без
которого не существует области сходимости ряда.

Если $r<rho<R$, то ряд @eq:laurent-series-sum равномерно сходится на окружности
$gamma: abs(z-z_0)=rho$; он будет равномерно сходиться на $gamma$ и после того,
как все члены будут умножены на $1/(2 pi i)(z-z_0)^(-k-1)$, где $k$ —
произвольное целое число. Интегрируя полученный ряд на $gamma$, найдем:
$
  1/(2 pi i) integral_gamma f(z)/(z-z_0)^(k+1) dif z
  =sum_(-oo)^(+oo) a_n 1/(2 pi i)
  integral_gamma (z-z_0)^(n-k-1) dif z.
$
Все интегралы в правой части, как показывает простое вычисление (следует
воспользоваться уравнением окружности $gamma: z=z_0+rho e^(i theta)$,
$0<=theta<=2 pi$), равны нулю, кроме одного, соответствующего $n=k$ и равного
$2 pi i$. Следовательно, #eq[$
  1/(2 pi i) integral_gamma f(z)/(z-z_0)^(k+1) dif z=a_k
  quad (k=0, plus.minus 1, plus.minus 2, dots).
$] <eq:laurent-coefficients>
Мы получили выражения для коэффициентов ряда Лорана через сумму этого ряда.
Отсюда следует, что если суммы рядов Лорана:
$
  f(z)=sum_(-oo)^(+oo) a_k lr((z-z_0))^k quad "и" quad
  phi(z)=sum_(-oo)^(+oo) b_k lr((z-z_0))^k,
$
сходящихся в круговых кольцах $D$ и $Delta$, содержащих одну и ту же окружность
$abs(z-z_0)=rho$, совпадают в точках этой окружности, то коэффициенты обоих
рядов попарно равны:
$ a_k=b_k quad (k=0, plus.minus 1, plus.minus 2, dots), $
т. е. ряды тождественны. В частности, ряды будут тождественными, если кольца $D$
и $Delta$ совпадают друг с другом и $f(z)=phi(z)$ во всех
#source(384)
точках кольца $D$. Из изложенного вытекает, что _разложения в ряд Лорана
обладают свойством единственности_.

Опираясь на свойство единственности, получим совершенно так же, как и в
п.~@pt:power-series-taylor-uniqueness главы @ch:integrals-power-series, что если
разложение $sum_(-oo)^(+oo) a_k z^k$ представляет четную функцию, то в нем равны
нулю все коэффициенты при нечетных степенях $z$, а если нечетную, то равны нулю
все коэффициенты при четных степенях.

Докажем следующее важное предложение.

#idx("Лорана теорема", target: <thm:laurent-expansion>)#named-statement(
  "Теорема Лорана",
)[
  Каждая функция $f(z)$, однозначная и аналитическая в круговом кольце
  $D: r<abs(z-z_0)<R$, представляется в этом кольце сходящимся рядом Лорана:
  $ f(z)=sum_(-oo)^oo a_n lr((z-z_0))^n. $
] <thm:laurent-expansion>

#figure(laurent-annulus(), caption: []) <fig:laurent-annulus>

Заметим, что в условиях этой теоремы кольцо может вырождаться в круг с выколотым
центром ($r=0$, $R<oo$), во внешность круга с выколотой бесконечно удаленной
точкой ($0<r$, $R=oo$) и, наконец, во всю плоскость с двумя выколотыми точками
$z_0$ и $oo$ ($r=0$ и $R=oo$). Указанные случаи не исключаются при дальнейшем
доказательстве.

Пусть $z$ — какая-либо точка кольца $D$. Образуем новое кольцо $D'$:
$ r'<abs(zeta-z_0)<R', $
лежащее внутри первоначального и содержащее точку $z$
(рис.~@fig:laurent-annulus). Чтобы построить его, достаточно взять:
$ r<r'<abs(z-z_0)<R'<R. $
Пусть еще $abs(zeta-z)=rho$ — окружность с центром в $z$, лежащая внутри $D'$.
Так как
$ phi(zeta)=f(zeta)/(zeta-z) $
является аналитической функцией от $zeta$ в области $D$, исключая точку
$zeta=z$, то по интегральной теореме Коши для системы контуров
(п.~@pt:cauchy-integral-multiply-connected главы @ch:integrals-power-series)
будем иметь: #eq[$
  1/(2 pi i) integral_(Gamma_(R')) f(zeta)/(zeta-z) dif zeta
  =1/(2 pi i) integral_(Gamma_(r')) f(zeta)/(zeta-z) dif zeta
  \ +1/(2 pi i) integral_(gamma_rho) f(zeta)/(zeta-z) dif zeta,
$] <eq:laurent-cauchy-three-contours>

#source(385)
где $Gamma_(R')$, $Gamma_(r')$ и $gamma_rho$ обозначают соответственно
окружности:
$ abs(zeta-z_0)=R', quad abs(zeta-z_0)=r' quad "и" quad abs(zeta-z)=rho, $
проходимые при интегрировании в направлении против часовой стрелки. Но последний
интеграл в формуле @eq:laurent-cauchy-three-contours есть интеграл Коши и,
следовательно, равен $f(z)$. Поэтому #eq[$
  f(z)=1/(2 pi i) integral_(Gamma_(R')) f(zeta)/(zeta-z) dif zeta
  -1/(2 pi i) integral_(Gamma_(r')) f(zeta)/(zeta-z) dif zeta.
$] <eq:laurent-cauchy-annulus>
Представим $1/(zeta-z)$ под знаком первого интеграла ($zeta in Gamma_(R')$) в
виде суммы геометрического ряда со знаменателем $(z-z_0)/(zeta-z_0)$, модуль
которого
$ abs((z-z_0)/(zeta-z_0))=abs(z-z_0)/R'=theta<1. $
Получим: #eq[$
  1/(zeta-z)=1/(zeta-z_0-(z-z_0))
  =1/(zeta-z_0) 1/(1-(z-z_0)/(zeta-z_0))
  \ =sum_0^oo (z-z_0)^n/(zeta-z_0)^(n+1).
$] <eq:laurent-outer-geometric-expansion>
Так как для всех точек $zeta$, принадлежащих $Gamma_(R')$, модуль общего члена
последнего ряда есть
$ abs((z-z_0)^n/(zeta-z_0)^(n+1))=1/R' theta^n quad (0<theta<1), $
то ряд @eq:laurent-outer-geometric-expansion равномерно сходится на $Gamma_(R')$
(относительно $zeta$). Равномерно будет сходиться также и ряд, получаемый из
@eq:laurent-outer-geometric-expansion путем умножения на функцию
$1/(2 pi i) f(zeta)$ (ограниченную по модулю на $Gamma_(R')$):
$
  1/(2 pi i) f(zeta)/(zeta-z)
  =sum_0^oo 1/(2 pi i) f(zeta)/(zeta-z_0)^(n+1) (z-z_0)^n.
$
Отсюда следует, что последний ряд можно почленно интегрировать на $Gamma_(R')$.
Получим: #eq[$
  1/(2 pi i) integral_(Gamma_(R')) f(zeta)/(zeta-z) dif zeta
  =sum_0^oo a_n lr((z-z_0))^n,
$] <eq:laurent-regular-part-integral>
где #eq[$
  a_n=1/(2 pi i) integral_(Gamma_(R')) (f(zeta) dif zeta)
  /(zeta-z_0)^(n+1) quad (n=0,1,2,dots).
$] <eq:laurent-nonnegative-coefficients>

#source(386)
Итак, первый из интегралов в правой части равенства @eq:laurent-cauchy-annulus
мы разложили в сходящийся ряд по неотрицательным степеням $z-z_0$.

Обращаясь ко второму интегралу в правой части равенства
@eq:laurent-cauchy-annulus, представим $-1/(zeta-z)$ ($zeta in Gamma_(r')$) как
сумму геометрического ряда со знаменателем $(zeta-z_0)/(z-z_0)$, модуль которого
$ abs((zeta-z_0)/(z-z_0))=r'/abs(z-z_0)=theta.alt<1. $
Получим: #eq[$
  -1/(zeta-z)=1/(z-z_0) 1/(1-(zeta-z_0)/(z-z_0))
  =sum_0^oo (zeta-z_0)^n/(z-z_0)^(n+1).
$] <eq:laurent-inner-geometric-expansion>
Замечая, что этот ряд также сходится равномерно на $Gamma_(r')$, умножая все
члены его на $1/(2 pi i) f(zeta)$ и интегрируя почленно, находим: #eq[$
  -1/(2 pi i) integral_(Gamma_(r')) f(zeta)/(zeta-z) dif zeta
  =sum_1^oo a_(-n) lr((z-z_0))^(-n),
$] <eq:laurent-principal-part-integral>
где #eq[$
  a_(-n)=1/(2 pi i) integral_(Gamma_(r')) (f(zeta) dif zeta)
  /(zeta-z_0)^(-n+1) quad (n=1,2,dots).
$] <eq:laurent-negative-coefficients>
Итак, второй интеграл в правой части равенства @eq:laurent-cauchy-annulus мы
представили в виде суммы сходящегося ряда, расположенного по отрицательным
степеням $z-z_0$.

Подставляя найденные разложения @eq:laurent-regular-part-integral и
@eq:laurent-principal-part-integral в правую часть равенства
@eq:laurent-cauchy-annulus, получаем разложение функции $f(z)$ в ряд Лорана для
произвольной точки $z in D$: #eq[$
  f(z)=sum_0^oo a_n lr((z-z_0))^n+sum_1^oo a_(-n) lr((z-z_0))^(-n)
  \ =sum_(-oo)^(+oo) a_n lr((z-z_0))^n.
$] <eq:laurent-expansion-combined>
Коэффициенты этого разложения вычисляются частью по формулам
@eq:laurent-nonnegative-coefficients, частью по формулам
@eq:laurent-negative-coefficients. Беря произвольную окружность
$Gamma: abs(z-z_0)=lambda$, где $r<lambda<R$, убеждаемся с помощью интегральной
теоремы Коши для случая системы контуров, что каждый из них можно вычислять,
выполняя интегрирование по окружности $Gamma$: #eq[$
  a_n=1/(2 pi i) integral_Gamma (f(zeta) dif zeta)/(zeta-z_0)^(n+1)
  quad (n=0, plus.minus 1, plus.minus 2, dots).
$] <eq:laurent-coefficients-general-contour>

#source(387)
Этот результат вполне согласуется с полученным нами ранее (см. формулы
@eq:laurent-coefficients).
