#import "main-defs.typ": eq, idx, point, source
#import "statements.typ": properties

#heading(level: 2)[
  Приложения теории вычетов к разложению функций в ряды. Интерполирование
] <sec:residue-series-interpolation>

#source(436)
#point() <pt:meromorphic-principal-parts-series>
Пусть $f(z)$ — однозначная аналитическая функция, не имеющая в конечной части
плоскости других особых точек, кроме полюсов.

Обозначим через $C$ какую-либо положительно ориентированную замкнутую жорданову
спрямляемую кривую, содержащую начало координат внутри и не проходящую через
полюсы функции $f(z)$, и пусть $z$ — точка внутри $C$, отличная от начала
координат
#source(437)
и полюсов. Вычислим интеграл типа Коши:
$ 1/(2 pi i) integral_C (f(zeta) dif zeta)/(zeta-z). $
Очевидно, полюсами функции $phi(zeta)=f(zeta)/(zeta-z)$ внутри $C$ являются
точка $zeta=z$ и все полюсы функции $f(z)$, лежащие внутри $C$. Обозначим те из
этих полюсов, которые отличны от нуля, через $beta_1,dots,beta_n$, а
соответствующие им главные части лорановских разложений функции $f(z)$ — через
$G_1 lr((z)),dots,G_n lr((z))$. Положим еще $beta_0=0$, считая $G_0 lr((z))$
равной главной части лорановского разложения функции $f(z)$ в окрестности точки
$z=0$, так что функция $G_0 lr((z))$ тождественно равна нулю, если $z=0$ есть
правильная точка для $f(z)$, и $G_0 lr((z))$ есть рациональная функция с
единственным полюсом в начале, если $z=0$ есть полюс функции $f(z)$.

Подсчитаем вычеты функции $phi(zeta)$ относительно точек $zeta=z$,
$beta_0,beta_1,dots,beta_n$. Получим прежде всего:
$ limits(op("Выч."))_(zeta=z) phi(zeta)=f(z). $
Далее, заменяя $f(zeta)$ в окрестности точки $beta_k$ соответствующим
лорановским разложением
$
  f(zeta)=A_(-gamma_k)^((k))/(zeta-beta_k)^(gamma_k)+dots
  +A_(-1)^((k))/(zeta-beta_k) \
  +A_0^((k))+A_1^((k))(zeta-beta_k)+dots
  =G_k lr((zeta))+P_k lr((zeta)),
$
где $G_k lr((zeta))$ и $P_k lr((zeta))$, соответственно, — главная и правильная
части разложения, и замечая, что при
$abs(zeta-beta_k)<abs(z-beta_k)$
$
  1/(zeta-z)=-1/((z-beta_k)-(zeta-beta_k))
  \
  =-1/(z-beta_k)-(zeta-beta_k)/(z-beta_k)^2-dots
  -(zeta-beta_k)^(gamma_k-1)/(z-beta_k)^(gamma_k)-dots,
$
находим, что член, содержащий $(zeta-beta_k)^(-1)$ в разложении
$phi(zeta)=f(zeta) 1/(zeta-z)$, равен
$
  -lr(
    [A_(-1)^((k))/(z-beta_k)+A_(-2)^((k))/(z-beta_k)^2+dots
      +A_(-gamma_k)^((k))/(z-beta_k)^(gamma_k)]
  ) 1/(zeta-beta_k)
  =-G_k lr((z)) 1/(zeta-beta_k).
$
Следовательно,
$ limits(op("Выч."))_(zeta=beta_k) phi(zeta)=-G_k lr((z)). $

#source(438)
Итак,
$
  1/(2 pi i) integral_C (f(zeta) dif zeta)/(zeta-z)
  =f(z)-sum_0^n G_k lr((z)),
$
или
#eq[$
  f(z)=sum_0^n G_k lr((z))
  +1/(2 pi i) integral_C (f(zeta) dif zeta)/(zeta-z).
$]
<eq:principal-parts-contour-formula>
Эту формулу можно было бы получить иным путем. А именно, заметим, что
$sum_0^n G_k lr((zeta))$ — рациональная функция, обращающаяся в нуль в
бесконечности; все полюсы ее лежат внутри $C$. Функция
$(sum_0^n G_k lr((zeta)))/(zeta-z)$ ($z$ лежит внутри $C$) обладает теми же
свойствами и в бесконечности имеет нуль по крайней мере второго порядка. Поэтому
ее вычет относительно бесконечно удаленной точки равен нулю, и, следовательно,
$ 1/(2 pi i) integral_C (sum_0^n G_k lr((zeta)))/(zeta-z) dif zeta=0, $
откуда
$
  1/(2 pi i) integral_C (f(zeta) dif zeta)/(zeta-z)
  =1/(2 pi i) integral_C (f(zeta)-sum_0^n G_k lr((zeta)))/(zeta-z) dif zeta.
$
Но функция $f(zeta)-sum_0^n G_k lr((zeta))$ является аналитической во всех
точках внутри $C$; поэтому к последнему интегралу применима формула Коши, и мы
получаем:
$
  1/(2 pi i) integral_C (f(zeta) dif zeta)/(zeta-z)
  =1/(2 pi i) integral_C (f(zeta)-sum_0^n G_k lr((zeta)))/(zeta-z) dif zeta
  =f(z)-sum_0^n G_k lr((z)),
$
т.~е. формулу @eq:principal-parts-contour-formula.

Допустим, что существует последовательность не проходящих через полюсы функции
$f(z)$ замкнутых жордановых спрямляемых кривых $lr({C_m})$, из которых каждая
($C_m$) содержится внутри следующей ($C_(m+1)$) и внутренности которых при
достаточно
#source(439)
большом $m$ содержат любой заданный круг $abs(z)<R$, причем для кривых $C_m$
удовлетворяется следующее условие:
#eq[$ lim_(m->oo) 1/(2 pi i) integral_(C_m) (f(zeta) dif zeta)/(zeta-z)=0. $]
<eq:principal-parts-vanishing-integral>
Тогда число ненулевых полюсов функции $f(z)$, лежащих внутри $C_m$, будет
зависеть от $m$: $n=n_m$, и из формулы @eq:principal-parts-contour-formula
получим
#eq[$ f(z)=lim_(m->oo) sum_0^(n_m) G_k lr((z)), $]
<eq:principal-parts-limit>
т.~е. функция $f(z)$ представляется в виде предела последовательности сумм
главных частей ее лорановских разложений, относящихся к полюсам, лежащим внутри
$C_m$.

Условие @eq:principal-parts-vanishing-integral удовлетворяется, например, в
случае, когда
#eq[$ limits(overline(lim))_(m->oo) integral_(C_m) abs(f(zeta)) dif s<oo. $]
<eq:principal-parts-integral-bound>
В самом деле, обозначая через $r_m$ расстояние от начала координат до $C_m$
($r_m->oo$ при $m->oo$) и полагая, что $z$ принадлежит кругу $abs(z)<R$, получим
при $r_m>R$
$
  abs(1/(2 pi i) integral_(C_m) (f(zeta) dif zeta)/(zeta-z))
  <=1/(2 pi (r_m-R)) integral_(C_m) abs(f(zeta)) dif s->0
  quad "при" m->oo.
$
Из этой оценки видно, что при условии @eq:principal-parts-integral-bound
остаточный член формулы @eq:principal-parts-contour-formula стремится к нулю
равномерно относительно $z$, принадлежащего произвольному кругу $abs(z)<R$.
Поэтому последовательность @eq:principal-parts-limit равномерно сходится к
функции $f(z)$ в любом круге $abs(z)<R$.

Можно получить представление для $f(z)$, аналогичное @eq:principal-parts-limit,
при значительно более общих условиях. Именно, допустим, что вместо
@eq:principal-parts-integral-bound для последовательности кривых $lr({C_m})$ и
некоторого целого неотрицательного числа $p$ выполняется соотношение
#eq[$
  limits(overline(lim))_(m->oo)
  integral_(C_m) abs(f(zeta))/abs(zeta)^(p+1) dif s<oo.
$]
<eq:weighted-meromorphic-integral-bound>
Если предположить, что длины $l_m$ кривых $C_m$ растут не быстрее, чем
$lambda r_m$, где $lambda$ — некоторая постоянная (так будет во всех случаях,
когда $C_m$ являются кривыми, подобными относительно начала координат), то
найдем, что
$
  integral_(C_m) abs(f(zeta))/abs(zeta)^(p+1) dif s
  <=limits(max)_(C_m) abs(f(zeta)) l_m/r_m^(p+1)
  <=lambda (limits(max)_(C_m) abs(f(zeta)))/r_m^p.
$

#source(440)
Отсюда видно, что условие @eq:weighted-meromorphic-integral-bound будет
удовлетворяться, если выполнено более простое условие
#eq[$
  limits(overline(lim))_(m->oo)
  (limits(max)_(C_m) abs(f(zeta)))/r_m^p<oo,
$]
<eq:meromorphic-contour-growth>
допускающее бесконечный рост $limits(max)_(C_m) abs(f(zeta))$, но не более
быстрый, чем рост $r_m^p$.

Сделав предположение, что условие @eq:weighted-meromorphic-integral-bound или
@eq:meromorphic-contour-growth выполнено, вернемся к соотношению
@eq:principal-parts-contour-formula и заменим в нем $(zeta-z)^(-1)$ под знаком
интеграла выражением
$
  1/(zeta-z)=1/zeta 1/(1-z/zeta)=1/zeta+z/zeta^2+dots+z^p/zeta^(p+1)
  +1/(zeta-z) z^(p+1)/zeta^(p+1).
$
Тогда будем иметь: #eq[$
  f(z)=sum_0^n G_k lr((z))+sum_0^p z^j/(2 pi i)
  integral_C f(zeta)/zeta^(j+1) dif zeta \
  +1/(2 pi i) integral_C f(zeta)/(zeta-z) z^(p+1)/zeta^(p+1) dif zeta.
$] <eq:meromorphic-kernel-decomposition>
Заметив, что функция $f(zeta)/zeta^(j+1)$ имеет своими полюсами внутри $C$ точки
$beta_0,beta_1,dots,beta_n$, положим
$
  limits(op("Выч."))_(zeta=beta_k) f(zeta)/zeta^(j+1)=A_k^((j))
  quad (j=0,1,dots,p).
$
Тогда получим:
$
  sum_(j=0)^p z^j/(2 pi i) integral_C f(zeta)/zeta^(j+1) dif zeta
  =sum_(j=0)^p (A_0^((j))+dots+A_n^((j))) z^j=sum_(k=0)^n P_k lr((z)),
$
где $P_k lr((z))$ — многочлены степени не выше $p$:
#eq[$ P_k lr((z))=A_k^((0))+A_k^((1)) z+dots+A_k^((p)) z^p. $]
<eq:meromorphic-correction-polynomial>
Итак, формулу @eq:meromorphic-kernel-decomposition можно переписать в виде #eq[$
  f(z)=sum_0^n lr([G_k lr((z))+P_k lr((z))])
  +1/(2 pi i) integral_C f(zeta)/(zeta-z) z^(p+1)/zeta^(p+1) dif zeta.
$] <eq:meromorphic-corrected-contour>
Заменяя здесь $C$ на $C_m$ и, следовательно, $n$ на $n_m$, получим, используя
условие @eq:weighted-meromorphic-integral-bound, что остаточный член этой
формулы
$ 1/(2 pi i) integral_(C_m) f(zeta)/(zeta-z) z^(p+1)/zeta^(p+1) dif zeta $
#source(441)
стремится к нулю, и притом равномерно относительно точек $z$, принадлежащих
любому фиксированному кругу: $abs(z)<R$. В самом деле, при $m$, настолько
большом, что $r_m>R$, имеем:
$
  abs(1/(2 pi i) integral_(C_m) f(zeta)/(zeta-z) z^(p+1)/zeta^(p+1) dif zeta)
  <=1/(2 pi) integral_(C_m) abs(f(zeta))/(abs(zeta)-abs(z))
  abs(z)^(p+1)/abs(zeta)^(p+1) dif s
  \
  <=R^(p+1)/(2 pi (r_m-R)) integral_(C_m) abs(f(zeta))/abs(zeta)^(p+1) dif s.
$
Но в силу условия @eq:weighted-meromorphic-integral-bound интегралы
$integral_(C_m) abs(f(zeta))/abs(zeta)^(p+1) dif s$ ограничены:
$ integral_(C_m) abs(f(zeta))/abs(zeta)^(p+1) dif s<M<oo. $
Следовательно,
$
  abs(1/(2 pi i) integral_(C_m) f(zeta)/(zeta-z) z^(p+1)/zeta^(p+1) dif zeta)
  <(M R^(p+1))/(2 pi (r_m-R))->0 quad "при" m->oo,
$
и мы получаем из формулы @eq:meromorphic-corrected-contour разложение
#eq[$ f(z)=lim_(m->oo) sum_0^(n_m) lr([G_k lr((z))+P_k lr((z))]), $]
<eq:meromorphic-corrected-limit>
равномерно сходящееся к $f(z)$ в каждом круге $abs(z)<R$. Это разложение можно
записать в виде ряда #eq[$
  f(z)=lr([G_0 lr((z))+P_0 lr((z))]) \
  +sum_(m=0)^oo lr(
    {lr([G_(n_m+1) lr((z))+P_(n_m+1) lr((z))])+dots \
      +lr([G_(n_(m+1)) lr((z))+P_(n_(m+1)) lr((z))])}
  ),
$] <eq:meromorphic-principal-parts-series>
где $n_0$ следует положить равным нулю.

Заметим, что первые члены последовательности @eq:meromorphic-corrected-limit или
ряда @eq:meromorphic-principal-parts-series обращаются в $oo$ в точках
$beta_0,dots,beta_(n_m)$, т.~е. там, где обращается в $oo$ функция $f(z)$.
Поэтому равномерную сходимость ряда @eq:meromorphic-principal-parts-series нужно
понимать как равномерную сходимость того ряда, который получается из данного
после отбрасывания нескольких первых членов, имеющих полюсы в круге $abs(z)<R$.

#metadata(none) <def:partial-fraction-expansion>
Разложения вида @eq:meromorphic-corrected-limit (в частности,
@eq:principal-parts-limit или @eq:meromorphic-principal-parts-series) называются
разложениями $f(z)$ на _простейшие дроби_#idx(
  "Разложение на простейшие дроби",
  target: <def:partial-fraction-expansion>,
).

#point() <pt:trigonometric-partial-fractions>
Изложенный нами метод разложения функций в ряды принадлежит Коши. Применим его к
нескольким частным примерам, имеющим важное значение.

#source(442)
#properties(
  [_Разложение $op("sec") z$_<prop:secant-partial-fractions>#idx(
      "Секанс",
      target: <prop:secant-partial-fractions>,
    ). В качестве $C_m$ выберем контуры квадратов с центрами в точке $z=0$ и
    сторонами, параллельными осям координат и равными по длине $2m pi$. На
    сторонах квадратов, параллельных мнимой оси, имеем $z=plus.minus m pi+i y$,
    и, следовательно:
    $
      abs(op("sec") z)=1/abs(cos(plus.minus m pi+i y))
      =1/abs(cos i y)=1/(op("ch") y).
    $
    На сторонах квадратов, параллельных действительной оси, имеем
    $z=x plus.minus i m pi$, и, следовательно (см. формулы
    @eq:trigonometric-modulus-bounds гл.~второй),
    $ abs(op("sec") z)=1/abs(cos(x plus.minus i m pi))<=1/(op("sh") m pi). $
    Из этих неравенств получаем для интеграла
    $integral_(C_m) abs(op("sec") zeta) dif s$ оценку:
    $
      integral_(C_m) abs(op("sec") zeta) dif s
      <2 integral_(-m pi)^(m pi) (dif y)/(op("ch") y)+(4m pi)/(op("sh") m pi).
    $
    Так как интеграл $integral_(-oo)^(+oo) (dif y)/(op("ch") y)$ сходится и
    $(4m pi)/(op("sh") m pi)->0$ при $m->oo$, то условие
    @eq:principal-parts-integral-bound, а следовательно, и условие
    @eq:principal-parts-vanishing-integral выполнено. Поэтому в данном случае
    можно пользоваться формулой @eq:principal-parts-limit. Внутри $C_m$ функция
    $op("sec") z=1/(cos z)$ имеет полюсы вида $(2j-1) pi/2$, где $-m+1<=j<=m$;
    все они являются простыми, так как нули $cos z$ — простые. Очевидно,
    $
      limits(op("Выч."))_(z=(2j-1) pi/2) op("sec") z
      =-1/sin((2j-1) pi/2)=(-1)^j,
    $
    и следовательно, главная часть $op("sec") z$ в окрестности точки
    $z=(2j-1) pi/2$ есть $G_j lr((z))=(-1)^j/(z-(2j-1) pi/2)$. Заметим еще, что
    $z=0$ не является полюсом для $op("sec") z$ и, следовательно,
    соответствующую главную часть следует считать равной нулю. Из формулы
    @eq:principal-parts-limit находим:
    $
      op("sec") z=lim_(m->oo) sum_(j=-m+1)^m (-1)^j/(z-(2j-1) pi/2)
      \
      =lim_(m->oo) lr(
        [sum_(j=1)^m (-1)^j/(z-(2j-1) pi/2)
          +sum_(j=-m+1)^0 (-1)^j/(z-(2j-1) pi/2)]
      ).
    $

    #source(443)
    Заменим во второй из сумм под знаком предела $j$ на $1-k$. Получим, что $k$
    будет изменяться в пределах от $1$ до $m$, и, следовательно,
    $
      op("sec") z=lim_(m->oo) lr(
        [sum_(j=1)^m (-1)^j/(z-(2j-1) pi/2)
          \
          +sum_(k=1)^m (-1)^(k+1)/(z+(2k-1) pi/2)]
      ).
    $
    Поэтому, меняя обозначение $k$ на $j$, найдем:
    $
      op("sec") z=lim_(m->oo) lr(
        [sum_(j=1)^m (-1)^j/(z-(2j-1) pi/2)
          \
          +sum_(j=1)^m (-1)^(j+1)/(z+(2j-1) pi/2)]
      )
      \
      =lim_(m->oo) sum_1^m (-1)^j ((2j-1) pi)/(z^2-(2j-1)^2 pi^2/4).
    $
    Мы пришли к разложению $op("sec") z$ в ряд
    #eq[$ op("sec") z=sum_1^oo (-1)^j ((2j-1) pi)/(z^2-(2j-1)^2 pi^2/4). $]
    <eq:secant-partial-fractions>
    Из способа получения этого ряда (частный случай формулы
    @eq:principal-parts-limit при условии @eq:principal-parts-integral-bound)
    вытекает, что он равномерно сходится в каждом круге $abs(z)<R$ (причем,
    чтобы говорить о сходимости ряда, из него следует исключить несколько первых
    членов, имеющих полюсы в данном круге).
  ],
  [_Разложение $op("ctg") z$_<prop:cotangent-partial-fractions>#idx(
      "Котангенс",
      target: <prop:cotangent-partial-fractions>,
    ). В качестве $C_m$ выберем контуры квадратов с центрами в точке $z=0$ и со
    сторонами, параллельными осям координат и равными по длине $(2m+1) pi$.
    Тогда на сторонах квадратов, параллельных мнимой оси,
    $ z=plus.minus (m+1/2) pi+i y, $
    и, следовательно,
    $
      abs(op("ctg") z)
      =abs(
        (cos lr([plus.minus (m+1/2) pi+i y]))/(sin lr(
          [plus.minus (m+1/2)
            pi+i y]
        ))
      )
      =abs((sin(i y))/(cos(i y)))=abs((e^y-e^(-y))/(e^y+e^(-y)))<1.
    $
    На сторонах квадратов, параллельных действительной оси,
    $ z=x plus.minus i(m+1/2) pi, $

    #source(444)
    и, следовательно (см. формулы @eq:trigonometric-modulus-bounds главы
    второй),
    $
      abs(op("ctg") z)
      =abs(
        (cos lr([x plus.minus i(m+1/2) pi]))/(sin lr(
          [x plus.minus i(m+1/2)
            pi]
        ))
      )
      <=(op("ch") (m+1/2) pi)/(op("sh") (m+1/2) pi)
      \
      =(1+e^(-(2m+1) pi))/(1-e^(-(2m+1) pi))
      <=(1+e^(-pi))/(1-e^(-pi))=(e^pi+1)/(e^pi-1).
    $
    Итак, на сторонах квадратов $C_m$ модуль $abs(op("ctg") z)$ удовлетворяет
    неравенству
    $ abs(op("ctg") z)<=(e^pi+1)/(e^pi-1). $
    Поэтому условие @eq:meromorphic-contour-growth, а следовательно, и условие
    @eq:weighted-meromorphic-integral-bound, выполняется при $p=0$, и мы можем
    пользоваться формулой @eq:meromorphic-corrected-limit.

    Внутри $C_m$ функция $op("ctg") z=(cos z)/(sin z)$ имеет полюсы:
    $0,plus.minus pi,dots,plus.minus m pi$, причем все они являются простыми,
    так как все нули $sin z$ суть простые. Очевидно,
    $ limits(op("Выч."))_(z=k pi) op("ctg") z=(cos k pi)/(cos k pi)=1, $
    поэтому главная часть $G_k lr((z))$ разложения $op("ctg") z$ в окрестности
    точки $z=k pi$ равна $1/(z-k pi)$.

    Многочлены $P_k lr((z))$ (см. формулу @eq:meromorphic-correction-polynomial)
    в данном случае суть многочлены степени не выше $p=0$:
    $
      P_k lr((z))=A_k^((0))
      =limits(op("Выч."))_(zeta=k pi) (op("ctg") zeta)/zeta.
    $
    Но функция $(op("ctg") zeta)/zeta$, очевидно, четная. Поэтому ее разложение
    в ряд Лорана в окрестности начала координат содержит только четные степени
    $zeta$, и, следовательно,
    $ limits(op("Выч."))_(zeta=0) (op("ctg") zeta)/zeta=0. $
    Далее, точки $zeta=k pi$ $(k!=0)$ являются простыми полюсами для
    $(op("ctg") zeta)/zeta$. Поэтому
    $
      limits(op("Выч."))_(zeta=k pi) (op("ctg") zeta)/zeta
      =(cos k pi)/(k pi cos k pi)=1/(k pi).
    $
    Итак,
    $ P_0 lr((z))=0, quad P_k lr((z))=1/(k pi) quad (k!=0), $

    #source(445)
    следовательно, по формуле @eq:meromorphic-corrected-limit: #eq[$
      op("ctg") z=lim_(m->oo) lr(
        [1/z
          +sum_(k=1)^m lr((1/(z-k pi)+1/(k pi)))
          +sum_(k=1)^m lr((1/(z+k pi)-1/(k pi)))]
      )
      \
      =lim_(m->oo) lr([1/z+sum_(k=1)^m lr((1/(z-k pi)+1/(z+k pi)))])
      \
      =1/z+sum_(k=1)^oo lr((1/(z-k pi)+1/(z+k pi))).
    $] <eq:cotangent-partial-fractions>
    Мы получили разложение $op("ctg") z$ на простейшие дроби. Как следует из
    самого способа получения этой формулы (из общей формулы
    @eq:meromorphic-corrected-limit), ряд @eq:cotangent-partial-fractions
    равномерно сходится в любом круге $abs(z)<R$, если исключить из него
    конечное число членов, имеющих полюсы в этом круге.

    Переписав соотношение @eq:cotangent-partial-fractions в виде
    $ op("ctg") z-1/z=sum_(k=1)^oo lr((1/(z-k pi)+1/(z+k pi))), $
    проинтегрируем его почленно вдоль произвольной кривой $L$, выходящей из
    начала координат и не проходящей через точки $pi k$
    $(k=plus.minus 1,plus.minus 2,dots)$. Получим:
    $
      integral_0^z lr((op("ctg") z-1/z)) dif z
      =sum_(k=1)^oo op("Ln") lr([(k pi-z)/(k pi) dot (k pi+z)/(k pi)])
      =sum_(k=1)^oo op("Ln") lr((1-z^2/(k^2 pi^2))),
    $
    где в правой части стоят вполне определенные значения логарифмов, а именно,
    значения, представляющие величины соответствующих интегралов:
    $
      op("Ln") lr((1-z^2/(k^2 pi^2)))
      =integral_0^z lr((1/(z-k pi)+1/(z+k pi))) dif z.
    $
    Интеграл в левой части равен одному из значений $op("Ln") lr(((sin z)/z))$.
    Итак,
    $
      op("Ln") lr(((sin z)/z))=lim_(n->oo) sum_1^n op("Ln") lr(
        (1-z^2/(k^2
          pi^2))
      ),
    $
    откуда
    $ (sin z)/z=lim_(n->oo) product_1^n lr((1-z^2/(k^2 pi^2))), $

    #source(446)
    что записывают обычно при помощи символа бесконечного произведения:
    #eq[$ sin z=z product_1^oo lr((1-z^2/(k^2 pi^2))). $]
    <eq:sine-infinite-product>
    Мы получили разложение $sin z$ в бесконечное произведение. К этому же
    разложению мы придем в главе @ch:entire-meromorphic-functions[седьмой],
    исходя из более общих соображений.
  ],
  [_Разложения $op("csc") z$ и
    $op("tg") z$_<prop:cosecant-tangent-partial-fractions>#idx(
      "Косеканс",
      target: <prop:cosecant-tangent-partial-fractions>,
    ). Из разложений для $op("sec") z$ и $op("ctg") z$ немедленно получаются
    разложения для $op("csc") z$ и $op("tg") z$. В самом деле,
    $op("csc") z=op("sec") lr((pi/2-z))$. Поэтому из найденной выше формулы
    $ op("sec") z=lim_(m->oo) sum_(j=-m+1)^m (-1)^j/(z-(2j-1) pi/2) $
    находим:
    $
      op("csc") z=lim_(m->oo) sum_(j=-m+1)^m (-1)^j/(pi/2-z-(2j-1) pi/2)
      \
      =lim_(m->oo) sum_(j=-m+1)^m (-1)^j/(-pi(j-1)-z)
      \
      =lim_(m->oo) sum_(j=-m+1)^m (-1)^(j-1)/(pi(j-1)+z).
    $
    Заменяя $j-1$ на $k$, будем иметь:
    $
      op("csc") z=lim_(m->oo) sum_(k=-m)^(m-1) (-1)^k/(z+k pi) \
      =lim_(m->oo) lr(
        [1/z-lr((1/(z-pi)+1/(z+pi)))
          +lr((1/(z-2pi)+1/(z+2pi)))-dots
          \
          +(-1)^(m-1) lr((1/(z-(m-1) pi)+1/(z+(m-1) pi)))
          +(-1)^m 1/(z-m pi)]
      ).
    $
    Добавим в квадратных скобках еще один член: $(-1)^m 1/(z+m pi)$, предел
    которого равен нулю (равномерно относительно $z$, принадлежащих
    произвольному кругу $abs(z)<R$). Получим:
    $
      op("csc") z=lim_(m->oo) lr(
        [1/z-(2z)/(z^2-pi^2)
          +(2z)/(z^2-(2pi)^2)-dots+(-1)^m (2z)/(z^2-(m pi)^2)]
      )
      \
      =1/z+sum_1^oo (-1)^k (2z)/(z^2-(k pi)^2).
    $
    Это и есть нужный результат.

    #source(447)
    #metadata(none) <def:tangent-partial-fractions>
    Аналогично, для $op("tg") z$#idx(
      "Тангенс",
      target: <def:tangent-partial-fractions>,
    ) имеем: $op("tg") z=op("ctg") lr((pi/2-z))$, поэтому из найденной выше
    формулы
    $ op("ctg") z=lim_(m->oo) lr([1/z+sum_1^m lr((1/(z-k pi)+1/(z+k pi)))]) $
    получаем:
    $
      op("tg") z=lim_(m->oo) lr(
        [1/(pi/2-z)
          +sum_1^m lr((1/(pi/2-z-k pi)+1/(pi/2-z+k pi)))]
      )
      \
      =lim_(m->oo) lr(
        [lr((1/(pi/2-z)+1/(-pi/2-z)))
          +lr((1/(3pi/2-z)+1/(-3pi/2-z)))+dots
          \
          +lr((1/((2m-1) pi/2-z)+1/(-(2m-1) pi/2-z)))
          +1/((2m+1) pi/2-z)]
      ).
    $
    Отбросив в квадратных скобках член $1/((2m+1) pi/2-z)$, предел которого
    равен нулю, найдем:
    $
      op("tg") z=lim_(m->oo) sum_1^m (-2z)/(z^2-(2k-1)^2 pi^2/4)
      =sum_1^oo (-2z)/(z^2-(2k-1)^2 pi^2/4).
    $
    Это и есть искомое разложение для $op("tg") z$.
  ],
  [Из найденных разложений легко получить, в частности, лорановские разложения
    тригонометрических функций в окрестности начала координат, которые мы раньше
    находили посредством деления рядов (гл.~третья,
    п.~@pt:power-series-division). <prop:trigonometric-taylor-coefficients>

    Рассмотрим $op("sec") z$. Эта функция является аналитической в круге
    $abs(z)<pi/2$ и, следовательно, допускает в нем разложение в ряд Тейлора.
    Формула @eq:secant-partial-fractions представляет эту функцию в виде суммы
    ряда
    $
      op("sec") z=sum_1^oo (-1)^j ((2j-1) pi)/(z^2-(2j-1)^2 pi^2/4)
      \
      =sum_1^oo (-1)^j lr([1/(z-(2j-1) pi/2)-1/(z+(2j-1) pi/2)]),
    $
    равномерно сходящегося в каждом круге, в частности, внутри круга
    $abs(z)<pi/2$. Поэтому, опираясь на @thm:weierstrass-analytic-series[теорему
      Вейерштрасса]
    #source(448)
    о равномерно сходящихся рядах аналитических функций, тейлоровские
    коэффициенты $op("sec") z$ можно получить путем сложения соответствующих
    коэффициентов тейлоровских разложений каждой из функций, стоящих в
    квадратных скобках в правой части последней формулы (см. гл.~3,
    п.~@pt:power-series-expansion-methods). Но
    $
      (-1)^j lr([1/(z-(2j-1) pi/2)-1/(z+(2j-1) pi/2)])
      \
      =-(-1)^j lr(
        [sum_0^oo z^k/lr([(2j-1) pi/2])^(k+1)
          +sum_0^oo ((-1)^k z^k)/lr([(2j-1) pi/2])^(k+1)]
      )
      \
      =2(-1)^(j-1) sum_0^oo z^(2m)/lr([(2j-1) pi/2])^(2m+1)
      quad (abs(z)<(2j-1) pi/2).
    $
    Здесь коэффициенты при нечетных степенях равны нулю, а коэффициент при
    $z^(2m)$ $(m=0,1,2,dots)$ равен
    $
      (2(-1)^(j-1))/lr([(2j-1) pi/2])^(2m+1)
      =2 lr((2/pi))^(2m+1) (-1)^(j-1)/(2j-1)^(2m+1).
    $
    Поэтому тейлоровские коэффициенты в разложении $op("sec") z$ при нечетных
    степенях $z$ равны нулю (что, очевидно, можно было видеть сразу, так как
    $op("sec") z$ — четная функция), а при четных степенях $z^(2m)$
    представляются в виде рядов:
    $ 2 lr((2/pi))^(2m+1) sum_1^oo (-1)^(j-1)/(2j-1)^(2m+1). $
    Итак,
    $
      op("sec") z=sum_0^oo lr(
        [2 lr((2/pi))^(2m+1)
          sum_1^oo (-1)^(j-1)/(2j-1)^(2m+1)]
      ) z^(2m).
    $
    Вспомним, что в гл.~3, п.~@pt:power-series-division, то же разложение было
    получено в другой форме:
    $ op("sec") z=sum_0^oo (-1)^m E_(2m)/((2m)!) z^(2m), $
    где $E_(2m)$ — целые числа, называемые эйлеровыми
    $(E_0=1,E_2=-1,E_4=5,E_6=-61,dots)$. Из сравнения коэффициентов обоих рядов
    получаем равенства:
    $
      2 lr((2/pi))^(2m+1) sum_1^oo (-1)^(j-1)/(2j-1)^(2m+1)
      =(-1)^m E_(2m)/((2m)!) quad (m=0,1,2,dots),
    $

    #source(449)
    в частности:
    $
      sum_1^oo (-1)^(j-1)/(2j-1)=E_0/2 pi/2=pi/4, \
      sum_1^oo (-1)^(j-1)/(2j-1)^3=-E_2/(2 dot 2!) lr((pi/2))^3=pi^3/32, \
      sum_1^oo (-1)^(j-1)/(2j-1)^5=E_4/(2 dot 4!) lr((pi/2))^5=(5pi^5)/1536, \
      dots
    $

    Рассмотрим еще функцию $op("ctg") z-1/z$, аналитическую в круге $abs(z)<pi$.
    Чтобы вычислить коэффициенты ее тейлоровского разложения, воспользуемся
    формулой @eq:cotangent-partial-fractions, из которой вытекает следующее
    представление этой функции в виде ряда:
    $ op("ctg") z-1/z=sum_(j=1)^oo lr((1/(z-j pi)+1/(z+j pi))). $
    Для каждого слагаемого этой суммы имеем следующее тейлоровское разложение:
    $
      1/(z-j pi)+1/(z+j pi)
      =-sum_(k=0)^oo z^k/(j pi)^(k+1)
      +sum_(k=0)^oo (-1)^k z^k/(j pi)^(k+1)
      \
      =-2sum_1^oo z^(2m-1)/(j pi)^(2m) quad (abs(z)<pi j).
    $
    Поэтому тейлоровские коэффициенты при четных степенях $z$ в разложении
    функции $op("ctg") z-1/z$ равны нулю (что сразу же следует из нечетности
    этой функции), а при нечетных степенях $z^(2m-1)$ представляются в виде
    рядов
    $
      -2sum_(j=1)^oo 1/(j pi)^(2m)
      =-2/pi^(2m) sum_(j=1)^oo 1/j^(2m) quad (m=1,2,dots).
    $
    Следовательно,
    $
      op("ctg") z-1/z=sum_(m=1)^oo lr([-2/pi^(2m) sum_(j=1)^oo 1/j^(2m)])
      z^(2m-1).
    $

    #source(450)
    В главе третьей, п.~@pt:power-series-division, то же разложение было
    получено в иной форме:
    $ op("ctg") z-1/z=sum_(m=1)^oo (-1)^m (2^(2m) B_(2m))/((2m)!) z^(2m-1). $
    Из сравнения двух разложений вытекает, что
    $ 2/pi^(2m) sum_(j=1)^oo 1/j^(2m)=(-1)^(m-1) (2^(2m) B_(2m))/((2m)!). $
    Так как левая часть этого равенства положительна, то и правая должна быть
    положительной, т.~е. $(-1)^(m-1) B_(2m)>0$. Отсюда следует, что бернуллиевы
    числа $B_(2m)$ $(m=1,2,3,dots)$ должны иметь чередующиеся знаки (в гл.~3,
    п.~@pt:power-series-division мы видели, что
    $B_2=1/6,B_4=-1/30,B_6=1/42,dots$).

    Из найденного соотношения следуют, в частности, следующие равенства:
    $
      sum_(j=1)^oo 1/j^2=B_2/(2 dot 2!) (2pi)^2=pi^2/6, \
      sum_(j=1)^oo 1/j^4=-B_4/(2 dot 4!) (2pi)^4=pi^4/90, \
      sum_(j=1)^oo 1/j^6=B_6/(2 dot 6!) (2pi)^6=pi^6/945, \
      dots
    $
  ],
)
