#import "main-defs.typ": eq, idx, point, source, variant-eq
#import "statements.typ": named-statement
#import "diagrams/03-05b-taylor-circle.typ": taylor-circle

#source(294)
#point() <pt:power-series-fourier>
Убедимся в том, что степенной ряд можно рассматривать как некоторый аналог ряда
Фурье для функции $f(z)$. С этой целью заметим, что степени $(z-z_0)^n$ обладают
следующим *свойством ортогональности на каждой окружности* $abs(z-z_0)=rho$:
#eq[$
  integral_0^(2 pi) (z-z_0)^n lr((overline(z-z_0)))^m dif theta=0
  quad "при" n != m.
$] <eq:circle-power-orthogonality>
В самом деле, полагая $z=z_0+rho e^(i theta)$, будем иметь:
$ (z-z_0)^n lr((overline(z-z_0)))^m=rho^(m+n) e^(i(n-m)theta) $
и, следовательно,
$
  integral_0^(2 pi) (z-z_0)^n lr((overline(z-z_0)))^m dif theta
  =rho^(m+n) lr([(e^(i(n-m)theta))/(i(n-m))])_0^(2 pi)=0.
$

Пусть $rho$ удовлетворяет условиям: $0<rho<R$ ($R$ — радиус сходимости ряда).
Так как степенной ряд равномерно сходится на окружности $abs(zeta-z_0)=rho$,
лежащей в круге сходимости $K$, то на той же окружности будет равномерно
сходиться и ряд
$
  f(zeta) lr((overline(zeta-z_0)))^m
  =a_0 lr((overline(zeta-z_0)))^m+dots
  +a_n (zeta-z_0)^n lr((overline(zeta-z_0)))^m+dots
$
Интегрируя его почленно и принимая во внимание соотношения ортогональности
@eq:circle-power-orthogonality, получаем:
$
  integral_0^(2 pi) f(zeta) lr((overline(zeta-z_0)))^m dif theta
  =a_m integral_0^(2 pi) (zeta-z_0)^m lr((overline(zeta-z_0)))^m dif theta
  =2 pi rho^(2m) a_m.
$
Отсюда #eq[$
  a_m=1/(2 pi rho^(2m)) integral_0^(2 pi)
  f(zeta) lr((overline(zeta-z_0)))^m dif theta quad (m=0,1,2,dots),
$] <eq:orthogonal-power-coefficients>
#source(295)и следовательно, степенной ряд можно записать в виде #eq[$
  f(z)=sum_0^oo 1/(2 pi rho^(2m)) integral_0^(2 pi)
  f(zeta) lr((overline(zeta-z_0)))^m dif theta dot (z-z_0)^m.
$] <eq:orthogonal-power-expansion>

Итак, степенной ряд представляет собой разложение функции $f(z)$ в ряд по
многочленам $lr({(z-z_0)^m})$, ортогональным на каждой окружности с центром в
точке $z_0$.

В качестве одного из применений соотношений ортогональности
@eq:circle-power-orthogonality имеем:
$
  1/(2 pi) integral_0^(2 pi) abs(sum_0^n a_m (z-z_0)^m)^2 dif theta =
  \ =1/(2 pi) integral_0^(2 pi)
  sum_0^n a_m (z-z_0)^m dot sum_0^n overline(a_m) lr((overline(z-z_0)))^m
  dif theta =
  \ =1/(2 pi) integral_0^(2 pi)
  sum_(k,m=0)^n a_k overline(a_m) (z-z_0)^k lr((overline(z-z_0)))^m
  dif theta =
  \ =1/(2 pi) sum_(k,m=0)^n a_k overline(a_m)
  integral_0^(2 pi) (z-z_0)^k lr((overline(z-z_0)))^m dif theta
  =sum_0^n abs(a_m)^2 rho^(2m).
$
(Все интегралы, соответствующие $k != m$, суть нули.)

Итак,
$
  1/(2 pi) integral_0^(2 pi) abs(sum_0^n a_m (z-z_0)^m)^2 dif theta
  =sum_0^n abs(a_m)^2 rho^(2m).
$
Считая здесь $rho<R$, перейдем к пределу при $n -> oo$. Так как
последовательность
$ lr({sum_0^n a_m (z-z_0)^m}) $
образована из непрерывных функций и равномерно сходится на окружности
$abs(z-z_0)=rho$, то и последовательность непрерывных функций
$lr({abs(sum_0^n a_m (z-z_0)^m)})$ будет равномерно сходящейся на той же
окружности (см. замечания в конце п. @pt:uniform-function-families).
Следовательно, возможен предельный переход под знаком интеграла (соответствующий
в случае рядов почленному интегрированию), и мы #source(296)получаем:
$
  1/(2 pi) integral_0^(2 pi) abs(f(z_0+rho e^(i theta)))^2 dif theta =
  \ =lim_(n -> oo) 1/(2 pi) integral_0^(2 pi)
  abs(sum_0^n a_m (z-z_0)^m)^2 dif theta
  =lim_(n -> oo) sum_0^n abs(a_m)^2 rho^(2m).
$
Отсюда следует, во-первых, что ряд $sum_0^oo abs(a_m)^2 rho^(2m)$ сходится и,
во-вторых, что сумма его есть интеграл
$1/(2 pi) integral_0^(2 pi) abs(f(z))^2 dif theta$: #eq[$
  sum_0^oo abs(a_m)^2 rho^(2m)
  =1/(2 pi) integral_0^(2 pi) abs(f(z_0+rho e^(i theta)))^2 dif theta.
$] <eq:power-series-parseval>
Это соотношение аналогично равенству Парсеваля в теории рядов Фурье. Из
соотношения @eq:power-series-parseval вытекает, что интеграл
$ 1/(2 pi) integral_0^(2 pi) abs(f(z_0+rho e^(i theta)))^2 dif theta, $
представляющий среднее значение квадрата модуля аналитической функции $f(z)$ на
окружности $abs(z-z_0)=rho$, является неубывающей функцией $rho$. Следовательно,
всегда существует предел (конечный или бесконечный)
$
  lim_(rho -> R) 1/(2 pi) integral_0^(2 pi)
  abs(f(z_0+rho e^(i theta)))^2 dif theta.
$

Преобразуем выражения @eq:orthogonal-power-coefficients для коэффициентов
степенного ряда. С этой целью положим $zeta-z_0=rho e^(i theta)$; тогда будем
иметь: #eq[$
  a_m=1/(2 pi rho^m) integral_0^(2 pi) f(zeta) e^(-i m theta) dif theta.
$] <eq:power-coefficients-exponential>
С другой стороны, по интегральной теореме Коши:
$
  integral_(abs(zeta-z_0)=rho) f(zeta)(zeta-z_0)^(m-1) dif zeta=0
  quad (m>=1),
$
или
$
  integral_0^(2 pi) f(zeta) rho^(m-1) e^(i(m-1)theta)
  rho i e^(i theta) dif theta=0,
$
#source(297)и, наконец, #eq[$
  0=1/(2 pi rho^m) integral_0^(2 pi) f(zeta) e^(i m theta) dif theta
  quad (m>=1).
$] <eq:positive-circle-moments>
Складывая и вычитая @eq:power-coefficients-exponential и
@eq:positive-circle-moments, получаем: #eq[$
  a_m=1/(pi rho^m) integral_0^(2 pi) f(zeta) cos m theta dif theta
  \ =(-i)/(pi rho^m) integral_0^(2 pi) f(zeta) sin m theta dif theta
  quad (m>=1).
$] <eq:power-coefficients-trigonometric>
Пусть
$ a_m=alpha_m+i beta_m quad "и" f(zeta)=u(rho,theta)+i v(rho,theta); $
тогда из формул @eq:power-coefficients-trigonometric находим: #eq[$
  cases(
    display(
      rho^m alpha_m=1/pi integral_0^(2 pi)
      u(rho,theta) cos m theta dif theta
    ),
    display(
      quad =1/pi integral_0^(2 pi) v(rho,theta) sin m theta dif theta
      quad (m>=1) ","
    ),
    display(
      rho^m beta_m=1/pi integral_0^(2 pi)
      v(rho,theta) cos m theta dif theta
    ),
    display(quad =-1/pi integral_0^(2 pi) u(rho,theta) sin m theta dif theta.),
    reverse: #true,
  )
$] <eq:power-coefficients-real-imaginary>
Кроме того, формула @eq:power-coefficients-exponential при $m=0$ дает:
$
  alpha_0=1/(2 pi) integral_0^(2 pi) u(rho,theta) dif theta,
  quad beta_0=1/(2 pi) integral_0^(2 pi) v(rho,theta) dif theta.
$
Отсюда следует, что числа $alpha_0$, $rho^m alpha_m$ и $-rho^m beta_m$
($m=1,2,dots$) являются коэффициентами Фурье функции
$u(rho,theta)=op("Re") f(z_0+rho e^(i theta))$, а числа $beta_0$, $rho^m beta_m$
и $rho^m alpha_m$ — коэффициентами Фурье для функции
$v(rho,theta)=op("Im") f(z_0+rho e^(i theta))$.

Иными словами, функции $u(rho,theta)$ и $v(rho,theta)$ обладают сопряженными
разложениями Фурье:
$
  u(rho,theta) tilde.op alpha_0
  +sum_1^oo rho^m lr((alpha_m cos m theta-beta_m sin m theta)),
  \ v(rho,theta) tilde.op beta_0
  +sum_1^oo rho^m lr((beta_m cos m theta+alpha_m sin m theta)).
$
Эти же ряды получаются, если в степенном ряде
$
  f(z_0+rho e^(i theta))=u(rho,theta)+i v(rho,theta) =
  \ =sum_0^oo a_m lr((z-z_0))^m
  =sum_0^oo (alpha_m+i beta_m)rho^m lr((cos m theta+i sin m theta))
$
#source(298)отделить действительную и мнимую части: #eq[$
  cases(
    display(
      u(rho,theta)=alpha_0
      +sum_1^oo (alpha_m rho^m cos m theta-beta_m rho^m sin m theta) ","
    ),
    display(
      v(rho,theta)=beta_0
      +sum_1^oo (beta_m rho^m cos m theta+alpha_m rho^m sin m theta).
    ),
    reverse: #true,
  )
$] <eq:conjugate-fourier-expansions>
Итак, _действительная и мнимая части степенного ряда представляют ряды Фурье для
действительной и мнимой частей суммы степенного ряда. Ряды эти являются
сопряженными друг с другом._

Покажем еще, как из равенства @eq:power-series-parseval можно вывести равенства
Парсеваля для функций $u(rho,theta)$ и $v(rho,theta)$.

Замечая, что
$ abs(f(z_0+rho e^(i theta)))^2=lr([u(rho,theta)])^2+lr([v(rho,theta)])^2, $
представим @eq:power-series-parseval в виде #eq[$
  1/(2 pi) integral_0^(2 pi) lr([u(rho,theta)])^2 dif theta
  +1/(2 pi) integral_0^(2 pi) lr([v(rho,theta)])^2 dif theta
  \ =sum_0^oo abs(a_m)^2 rho^(2m).
$] <eq:parseval-real-imaginary-sum>
С другой стороны, можно легко получить соотношение, дающее разность интегралов
$1/(2 pi) integral_0^(2 pi) lr([u(rho,theta)])^2 dif theta$ и
$1/(2 pi) integral_0^(2 pi) lr([v(rho,theta)])^2 dif theta$, если вспомнить, что
среднее арифметическое значений аналитической функции
$lr([f(z_0+rho e^(i theta))])^2$, принимаемых ею на окружности $abs(z-z_0)=rho$,
должно совпадать со значением ее в центре круга (п.
@pt:cauchy-integral-formula): #eq[$
  1/(2 pi) integral_0^(2 pi) lr([f(z_0+rho e^(i theta))])^2 dif theta
  =lr([f lr((z_0))])^2.
$] <eq:analytic-square-circle-mean>
Замечая, что
$
  lr([f(z_0+rho e^(i theta))])^2=lr([u(rho,theta)])^2
  -lr([v(rho,theta)])^2+2i u(rho,theta)v(rho,theta),
  \ lr([f lr((z_0))])^2=a_0^2=alpha_0^2-beta_0^2+2i alpha_0 beta_0,
$
и отделяя действительные части в равенстве @eq:analytic-square-circle-mean,
получим: #eq[$
  1/(2 pi) integral_0^(2 pi) lr([u(rho,theta)])^2 dif theta
  -1/(2 pi) integral_0^(2 pi) lr([v(rho,theta)])^2 dif theta
  \ =alpha_0^2-beta_0^2.
$] <eq:parseval-real-imaginary-difference>
#source(299)Складывая и вычитая почленно @eq:parseval-real-imaginary-sum и
@eq:parseval-real-imaginary-difference, находим, наконец:
$
  1/pi integral_0^(2 pi) lr([u(rho,theta)])^2 dif theta
  =alpha_0^2-beta_0^2+sum_0^oo abs(a_m)^2 rho^(2m)
  \ =2 alpha_0^2+sum_1^oo (alpha_m^2+beta_m^2)rho^(2m),
  \ 1/pi integral_0^(2 pi) lr([v(rho,theta)])^2 dif theta
  =beta_0^2-alpha_0^2+sum_0^oo abs(a_m)^2 rho^(2m)
  \ =2 beta_0^2+sum_1^oo (beta_m^2+alpha_m^2)rho^(2m).
$
Полученные соотношения, очевидно, представляют собой равенства Парсеваля для
функций $u(rho,theta)$ и $v(rho,theta)$.

#point() <pt:power-series-cauchy-estimates>
В п. @pt:power-series-taylor-uniqueness мы получили выражение коэффициентов
степенного ряда через производные от его суммы в центре круга сходимости $K$:
$ a_n=(f^((n)) lr((z_0)))/(n!) quad (n=0,1,2,dots). $
Но мы видели в п. @pt:cauchy-type-integral, что для любого $rho$, $0<rho<R$,
модули производных удовлетворяют неравенствам
$ abs(f^((n)) lr((z_0)))<=n! (M(rho))/(rho^n), $
где $M(rho)=limits(max)_(abs(z-z_0)=rho) abs(f(z))$. Отсюда вытекают следующие
*неравенства Коши для коэффициентов степенного ряда*:
#idx("Коши", "неравенство", target: <eq:cauchy-power-coefficients>)
#idx(
  "Степенной ряд",
  "неравенства Коши для коэффициентов",
  target: <eq:cauchy-power-coefficients>,
)
#eq[$ abs(a_n)<=(M(rho))/(rho^n) quad (n=0,1,2,dots). $]
<eq:cauchy-power-coefficients>
Из неравенств Коши следует, что все члены ряда $sum_0^oo abs(a_n)^2 rho^(2n)$
ограничены, а именно, что каждый из них не превосходит $lr([M(rho)])^2$. Однако
соотношение @eq:power-series-parseval позволяет утверждать значительно больше. А
именно, _ряд $sum_0^oo abs(a_n)^2 rho^(2n)$ сходится_ (при $rho<R$) _и вся сумма
его не превосходит той же самой границы $lr([M(rho)])^2$_. В самом деле, мы
имеем:
$
  sum_0^oo abs(a_n)^2 rho^(2n)
  =1/(2 pi) integral_0^(2 pi) abs(f(z_0+rho e^(i theta)))^2 dif theta.
$
Но
$
  1/(2 pi) integral_0^(2 pi) abs(f(z_0+rho e^(i theta)))^2 dif theta
  <=lr([M(rho)])^2,
$
#source(300)следовательно, #variant-eq([@eq:cauchy-power-coefficients])[$
  sum_0^oo abs(a_n)^2 rho^(2n)<=lr([M(rho)])^2.
$] <eq:cauchy-coefficient-square-bound>
#metadata(none) <thm:power-series-maximum-modulus>
Если допустить, что для некоторого $n=n_0>=0$ и для $rho$, $0<rho<R$, в
соотношениях Коши имеет место равенство
$ abs(a_(n_0))=(M(rho))/(rho^(n_0)), $
или
$ abs(a_(n_0))^2 rho^(2 n_0)=lr([M(rho)])^2, $
то из неравенства @eq:cauchy-coefficient-square-bound заключаем, что все
коэффициенты $a_n$ при $n != n_0$ равны нулю. Это означает, что степенной ряд
сводится к одному своему члену $a_(n_0)(z-z_0)^(n_0)$ и, следовательно,
$ f(z)=a_(n_0)(z-z_0)^(n_0). $
Итак, если исключить случай, когда степенной ряд сводится к одному своему члену
(коэффициенты всех прочих членов суть нули), то в соотношениях
@eq:cauchy-power-coefficients всегда имеет место строгий знак неравенства. В
частности, при $n=0$, получаем:
$ abs(a_0)=abs(f lr((z_0)))<M(rho), quad "если" f(z) equiv.not a_0, $
т. е. принцип максимума модуля в его окончательной форме для суммы степенного
ряда.

Так как производные аналитической функции могут быть представлены по формулам п.
@pt:cauchy-type-integral в виде интегралов
$
  f^((n)) lr((z_0))=(n!)/(2 pi i) integral_(abs(zeta-z_0)=rho)
  (f(zeta))/((zeta-z_0)^(n+1)) dif zeta quad (rho<R),
$
то для коэффициентов степенного ряда имеют место также следующие интегральные
выражения: #eq[$
  a_n=1/(2 pi i) integral_(abs(zeta-z_0)=rho)
  (f(zeta))/((zeta-z_0)^(n+1)) dif zeta quad (n=0,1,2,dots).
$] <eq:power-coefficient-contour-formula>
Покажем, что эти формулы можно получить непосредственно из рассмотрения
степенного ряда. А именно, помножим все члены равномерно сходящегося на
окружности $abs(zeta-z_0)=rho$ ряда
$ f(zeta)=sum_0^oo a_m lr((zeta-z_0))^m $
#source(301)на $1/(2 pi i) 1/((zeta-z_0)^(n+1))$ и проинтегрируем почленно по
окружности $gamma: abs(zeta-z_0)=rho$; получим: #eq[$
  1/(2 pi i) integral_gamma (f(zeta))/((zeta-z_0)^(n+1)) dif zeta
  \ =sum_0^oo a_m 1/(2 pi i) integral_gamma (zeta-z_0)^(m-n-1) dif zeta.
$] <eq:power-coefficient-termwise-contour>
Но
$
  integral_gamma (zeta-z_0)^(m-n-1) dif zeta
  =integral_0^(2 pi) rho^(m-n-1) e^(i(m-n-1)theta) rho e^(i theta) i dif theta
  \ =i rho^(m-n) integral_0^(2 pi) e^(i(m-n)theta) dif theta;
$
если $m != n$, то этот интеграл, очевидно, равен нулю:
$
  i rho^(m-n) integral_0^(2 pi) e^(i(m-n)theta) dif theta
  =i rho^(m-n) lr([(e^(i(m-n)theta))/((m-n)i)])_0^(2 pi)=0;
$
при $m=n$ он равен $2 pi i$:
$ i integral_0^(2 pi) dif theta=2 pi i. $
Отсюда следует, что все слагаемые в правой части формулы
@eq:power-coefficient-termwise-contour, кроме одного, соответствующего $m=n$,
равны нулю, и мы получаем:
$
  1/(2 pi i) integral_gamma (f(zeta))/((zeta-z_0)^(n+1)) dif zeta=a_n
  quad (n=0,1,2,dots),
$
т. е. формулы @eq:power-coefficient-contour-formula.

Пользуясь интегральными выражениями для коэффициентов, полученными только что,
не опираясь на интегральную формулу Коши, можно дать вывод интегральной формулы
Коши для функции $f(z)$ (суммы степенного ряда), отличающийся от изложенного
ранее (п. @pt:cauchy-integral-formula). Подставим выражения
@eq:power-coefficient-contour-formula в степенной ряд. Будем иметь: #eq[$
  f(z)=sum_0^oo 1/(2 pi i) integral_gamma
  (f(zeta))/((zeta-z_0)^(n+1)) dif zeta (z-z_0)^n.
$] <eq:power-series-contour-reconstruction>
Ряд, стоящий в правой части, можно получить путем почленного интегрирования ряда
$sum_0^oo 1/(2 pi i) f(zeta) (z-z_0)^n/((zeta-z_0)^(n+1))$, равномерно
сходящегося на окружности $gamma: abs(zeta-z_0)=rho$, если $z$ — фиксированная
точка, лежащая внутри $gamma$. В самом деле, для модуля общего члена #source(
  302,
)ряда имеем оценку:
$
  abs(1/(2 pi i) f(zeta) (z-z_0)^n/((zeta-z_0)^(n+1)))
  <=1/(2 pi) (M(rho))/rho lr(((abs(z-z_0))/rho))^n,
$
где $M(rho)=max abs(f(zeta))$ и $abs(z-z_0)<rho$. Но, очевидно, справа стоит
общий член сходящегося числового ряда (геометрической прогрессии со знаменателем
$(abs(z-z_0))/rho<1$), откуда и следует равномерная сходимость рассматриваемого
ряда. Поэтому результат почленного интегрирования этого ряда должен совпадать с
интегралом от суммы ряда, и мы получаем:
$
  f(z)=1/(2 pi i) integral_gamma sum_0^oo
  f(zeta) (z-z_0)^n/((zeta-z_0)^(n+1)) dif zeta
  =1/(2 pi i) integral_gamma f(zeta) sum_0^oo
  (z-z_0)^n/((zeta-z_0)^(n+1)) dif zeta =
  \ =1/(2 pi i) integral_gamma f(zeta)
  (1/(zeta-z_0))/(1-(z-z_0)/(zeta-z_0)) dif zeta
  =1/(2 pi i) integral_gamma (f(zeta) dif zeta)/(zeta-z).
$
Мы пришли к интегральной формуле Коши для суммы степенного ряда.

Итак, интегральную формулу Коши можно получить из степенного ряда, если
представить его коэффициенты в виде интегралов, заменить, далее, сумму
интегралов от членов равномерно сходящегося ряда интегралом от суммы, и,
наконец, суммировать получившуюся под знаком интеграла геометрическую
прогрессию. Коши провел эти рассуждения в обратном порядке и нашел, что каждая
функция, представимая интегралом Коши, т. е. каждая аналитическая функция,
изображается степенным рядом. Докажем это замечательное предложение.

#idx(
  "Коши",
  "теорема о разложимости в степенной ряд",
  target: <thm:cauchy-power-expansion>,
)
#idx(
  "Степенной ряд",
  "теорема Коши о разложимости",
  target: <thm:cauchy-power-expansion>,
)
#named-statement(
  "Теорема Коши о разложимости аналитической функции в степенной ряд",
)[
  Пусть $f(z)$ — функция, однозначная и аналитическая в области $G$, $z_0$ —
  произвольная (конечная) точка области $G$ и $Delta$ — расстояние от $z_0$ до
  границы этой области. Тогда существует степенной ряд, расположенный по
  степеням $z-z_0$, сходящийся в круге $K: abs(z-z_0)<Delta$ и представляющий в
  этом круге функцию $f(z)$: #eq[$
    f(z)=sum_0^oo a_n lr((z-z_0))^n.
  $] <eq:cauchy-analytic-power-expansion>
] <thm:cauchy-power-expansion>
(Заметим, что граница области $G$ может сводиться к единственной бесконечно
удаленной точке. В этом случае $Delta$ следует считать равным бесконечности.)

Обращаясь к доказательству теоремы, возьмем произвольную точку $z in K$ и опишем
из $z_0$, как из центра, окружность $gamma$: #source(303)$abs(zeta-z_0)=rho$,
где $0<=abs(z-z_0)<rho<Delta$ (рис. @fig:taylor-expansion-circle). По
интегральной формуле Коши будем иметь:
$ f(z)=1/(2 pi i) integral_gamma (f(zeta))/(zeta-z) dif zeta. $
Чтобы получить отсюда ряд, расположенный по степеням $z-z_0$, будем
рассматривать $1/(zeta-z)$ как сумму геометрического ряда со знаменателем
$(z-z_0)/(zeta-z_0)$, модуль которого:
$abs((z-z_0)/(zeta-z_0))=(abs(z-z_0))/rho=theta<1$. С этой целью представим
$1/(zeta-z)$ в виде #eq[$
  1/(zeta-z)=1/(zeta-z_0-(z-z_0))
  =1/(zeta-z_0) 1/(1-(z-z_0)/(zeta-z_0))
  =1/(zeta-z_0)+(z-z_0)/((zeta-z_0)^2) +
  \ +(z-z_0)^2/((zeta-z_0)^3)+dots
  +(z-z_0)^n/((zeta-z_0)^(n+1))+dots
  =sum_0^oo (z-z_0)^n/((zeta-z_0)^(n+1)).
$] <eq:geometric-cauchy-kernel>
Так как для всех точек $zeta$, принадлежащих $gamma$, модуль общего члена
последнего ряда есть:
$ abs((z-z_0)^n/((zeta-z_0)^(n+1)))=1/rho theta^n quad (0<=theta<1), $
то ряд @eq:geometric-cauchy-kernel равномерно сходится на $gamma$ (относительно
$zeta in gamma$). Равномерно будет сходиться также и ряд, получаемый из
@eq:geometric-cauchy-kernel путем умножения на функцию $1/(2 pi i) f(zeta)$,
ограниченную по модулю на $gamma$, т. е. ряд #eq[$
  1/(2 pi i) (f(zeta))/(zeta-z)
  =sum_0^oo 1/(2 pi i) (f(zeta))/((zeta-z_0)^(n+1)) (z-z_0)^n.
$] <eq:cauchy-kernel-function-series>
Отсюда следует, что ряд @eq:cauchy-kernel-function-series можно почленно
интегрировать на $gamma$. Выполняя интегрирование, получим: #eq[$
  f(z)=1/(2 pi i) integral_gamma (f(zeta) dif zeta)/(zeta-z)
  =sum_0^oo a_n lr((z-z_0))^n,
$] <eq:cauchy-local-power-representation>
где #eq[$
  a_n=1/(2 pi i) integral_gamma (f(zeta) dif zeta)/((zeta-z_0)^(n+1))
  =(f^((n)) lr((z_0)))/(n!).
$] <eq:cauchy-taylor-contour-coefficients>
Мы получили разложение аналитической функции в степенной ряд (ряд Тейлора). Из
самого способа его получения ($z$ — произвольная точка круга $K$) следует, что
ряд этот сходится в любой точке круга $K: abs(z-z_0)<Delta$.

Теорема доказана полностью.

#source(304)Эта теорема имеет большое принципиальное значение. Она показывает,
что функция $f(z)$ комплексного переменного, дифференцируемая в некоторой
области $G$ (ибо таково было принятое нами определение аналитической функции
комплексного переменного), изображается степенным рядом, расположенным по
степеням $z-z_0$ в окрестности любой точки $z_0$ области $G$. Именно этим
свойством и оправдывается самое наименование дифференцируемых в области функций
комплексного переменного — *аналитическими функциями*#idx(
  "Аналитическая функция",
)#idx("Функция", "аналитическая").
#figure(taylor-circle(), caption: [], supplement: [Рис.], numbering: "1")
<fig:taylor-expansion-circle>

Для функций действительного переменного, или более общо, для функций,
определенных на некоторой линии $Gamma$ (например, на жордановой кривой в
расширенной плоскости), подобное свойство не имеет места. Функция,
дифференцируемая и даже бесконечно дифференцируемая на $Gamma$, может и не
представляться степенным рядом ни в одной из окрестностей точек на $Gamma$ и,
следовательно, не быть аналитической. Поэтому, применяя понятие аналитической
функции к функциям, определенным на жордановых кривых (например, функциям
действительного переменного), следует опираться не на требование
дифференцируемости, а на требование представимости функции степенными рядами.

Так как степенной ряд
$ sum_0^oo a_n lr((z-z_0))^n=sum_0^oo (f^((n)) lr((z_0)))/(n!) (z-z_0)^n, $
представляющий функцию $f(z)$ в окрестности точки $z_0$, сходится, по
доказанному в теореме Коши, в круге $abs(z-z_0)<Delta$, то его радиус сходимости
$R$ должен быть не меньше, чем $Delta$:
$ R>=Delta. $
Записывая это неравенство в виде $1/R<=1/Delta$ и заменяя $1/R$ по формуле Коши
— Адамара через $limits(overline(lim))_(n -> oo) root(n, abs(a_n))
=limits(overline(lim))_(n -> oo) root(n, (abs(f^((n)) lr((z_0))))/(n!))$,
получаем уже знакомое нам неравенство Коши — Адамара
@eq:cauchy-hadamard-inequality:
$
  limits(overline(lim))_(n -> oo) root(n, (abs(f^((n)) lr((z_0))))/(n!))
  <=1/Delta.
$

#source(305)Из теоремы Коши вытекает, в частности, что степенные ряды,
представляющие целую функцию, сходятся к ней во всей плоскости. В самом деле,
целая функция является аналитической в области $G$, совпадающей со всей
плоскостью, так что расстояние $Delta$ от любой точки $z_0$ до границы этой
области $G$ следует считать равным бесконечности.

Пусть $f(z)$ — целая функция и $z_0$ — какая-либо точка плоскости. Тогда будем
иметь:
#eq[$ f(z)=a_0+a_1 lr((z-z_0))+dots+a_n lr((z-z_0))^n+dots, $]
<eq:entire-function-power-series>
где
$
  a_n=(f^((n)) lr((z_0)))/(n!)
  =1/(2 pi i) integral_(abs(zeta-z_0)=rho)
  (f(zeta) dif zeta)/((zeta-z_0)^(n+1)).
$
Ряд этот, как только что было замечено, сходится к $f(z)$ во всей плоскости. Для
коэффициентов ряда имеем оценки Коши:
#eq[$ abs(a_n)<=(M(rho))/(rho^n) quad (n=0,1,2,dots), $]
<eq:entire-cauchy-coefficients>
где
$ M(rho)=limits(max)_(abs(z-z_0)=rho) abs(f(z)). $
В нашем случае $rho$ можно брать сколь угодно большим. Отсюда следует, что
_если модуль целой функции $f(z)$ ограничен во всей плоскости, т. е.
$M(rho)<=M<oo$ при всех $rho$, то $f(z) equiv upright("const")$._
<thm:liouville>
В этом утверждении заключается *теорема Лиувилля*#idx(
  "Лиувилля теорема",
  target: <thm:liouville>,
), имеющая многочисленные применения в различных вопросах теории функций.

Для ее доказательства заменим в неравенствах @eq:entire-cauchy-coefficients
$M(rho)$ на $M$ и выпишем эти неравенства только для натуральных значений
индекса $n$:
$ abs(a_n)<=M/(rho^n) quad (n=1,2,3,dots). $
Произвольно фиксируя $n$, заставим $rho$ неограниченно возрастать; в пределе
получим:
$ abs(a_n)<=0, quad "т. е." a_n=0 quad "при" n=1,2,dots $
Из соотношения @eq:entire-function-power-series следует поэтому, что $f(z)=a_0$
при любом $z$, т. е. $f(z) equiv upright("const")$, что и требовалось доказать.

Полагая $z_0=0$ и вычисляя производные различных порядков от элементарных
функций: $exp z$, $sin z$, $cos z$, $op("sh") z$, $op("ch") z$, читатель легко
получит для них следующие сходящиеся во всей плоскости #source(306)разложения:
$
  exp z=sum_0^oo z^n/(n!), quad sin z=sum_1^oo (-1)^(n-1) z^(2n-1)/((2n-1)!),
  \ cos z=sum_0^oo (-1)^n z^(2n)/((2n)!),
  quad op("sh") z=sum_1^oo z^(2n-1)/((2n-1)!),
  quad op("ch") z=sum_0^oo z^(2n)/((2n)!).
$
Остановимся на степенных разложениях однозначных ветвей простейших многозначных
функций. Рассмотрим прежде всего однозначную ветвь $ln z$, определяемую
посредством условия $ln 1=0$ в области $G$, границей которой служит
неположительная часть действительной оси: $x<=0$, $y=0$ (ветвь эта может быть
представлена в виде $ln z=ln abs(z)+i arg z$, где $abs(arg z)<pi$). Так как
$(ln z)'=1/z$, то $(ln z)^((k))=(-1)^(k-1) ((k-1)!)/(z^k)$, и, следовательно,
разложение $ln z$ по степеням $z-1$ имеет вид
$ ln z=sum_0^oo ((ln z)_(z=1)^((k)))/(k!) (z-1)^k, $
или
$ ln z=sum_1^oo (-1)^(k-1) (z-1)^k/k. $
Расстояние $Delta$ от точки $z_0=1$ до границы области $G$ равно единице.
Поэтому найденным разложением можно пользоваться при $abs(z-1)<1$. Заменяя здесь
$z-1$ на $z$, получим степенной ряд для $ln(1+z)$, сходящийся при $abs(z)<1$:
$ ln(1+z)=sum_1^oo (-1)^(k-1) z^k/k quad (abs(z)<1). $
$ln(1+z)$ является однозначной ветвью функции $op("Ln")(1+z)$, определяемой
условием $lr([op("Ln")(1+z)])_(z=0)=ln 1=0$ в области $G$, границей которой
служит часть действительной оси: $x<=-1$, $y=0$.

Рассмотрим, далее, функцию $z^alpha$, где $alpha$ — произвольное комплексное
число. Это — многозначная (в случае, когда $alpha$ не есть целое число) функция,
выражающаяся через показательную функцию и логарифм при помощи соотношения
$z^alpha=exp(alpha op("Ln") z)$.

Выделим однозначную ветвь $phi(z)$ этой функции в той области, в которой выше
определена $ln z$, посредством условия $phi(1)=1$. Эту ветвь можно представить в
виде
$ phi(z)=exp(alpha ln z), $
#source(307)откуда
$
  phi' lr((z))=alpha exp(alpha ln z) dot 1/z
  \ =alpha exp(alpha ln z) dot exp(-ln z)=alpha exp lr([(alpha-1)ln z])
$
и, далее,
$
  phi^((k)) lr((z))=alpha(alpha-1)dots(alpha-k+1)exp lr([(alpha-k)ln z])
  quad (k=1,2,dots).
$
В точке $z=1$ производные принимают значения
$phi^((k)) lr((1))=alpha(alpha-1)dots(alpha-k+1)$ и, следовательно, разложение
$phi(z)$ по степеням $z-1$ имеет вид
$ phi(z)=sum_0^oo (alpha(alpha-1)dots(alpha-k+1))/(k!) (z-1)^k. $
Оно имеет место, как и в предыдущем примере, при $abs(z-1)<1$. Заменяя здесь
$z-1$ на $z$, получим разложение для $phi(z+1)$ в ряд по степеням $z$. Пользуясь
вместо $phi(z+1)$ привычным обозначением $(1+z)^alpha$ (понимаемым как
обозначение однозначной в области $G$ функции $exp lr([alpha ln(1+z)])$),
получаем:
$
  (1+z)^alpha=sum_0^oo (alpha(alpha-1)dots(alpha-k+1))/(k!) z^k
  quad (abs(z)<1).
$

Это — *биномиальная формула*#idx("Биномиальная формула"), установленная здесь
для самого общего случая, когда показатель степени есть произвольное комплексное
число.
