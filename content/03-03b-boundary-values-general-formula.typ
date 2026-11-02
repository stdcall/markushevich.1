#import "main-defs.typ": eq, idx, petit, point, source
#import "statements.typ": properties
#import "bibliography-style.typ": bib-description
#import "diagrams/03-03b-boundary-geometry.typ": (
  boundary-deformation, non-tangential-approach,
)

#petit[
  #source(254)
  #point() <pt:cauchy-boundary-analytic-density>
  Здесь мы займемся вопросом о *граничных значениях* интеграла типа Коши.
  Основные результаты, сюда относящиеся, были получены русским математиком Ю. В.
  Сохоцким в 1873 г.#footnote[
    #bib-description("Sokhotskii1873").
  ]. При самых общих предположениях относительно кривой (спрямляемость) и
  функции (суммируемость в смысле Лебега) этот вопрос был изучен в работах В. В.
  Голубева и И. И. Привалова#footnote[
    #bib-description("Golubev1916"). #bib-description("Privalov1919"). См. также
    монографию: #bib-description("Privalov1950").
  ].

  В трудах Н. И. Мусхелишвили и его школы разработаны приложения интеграла типа
  Коши к задачам механики, в особенности к теории упругости#footnote[
    #bib-description("Muskhelishvili1922"). См. также монографию
    #bib-description("Muskhelishvili1962").
  ].

  Пусть сначала $F(z)=1/(2 pi i) integral_L (f(zeta) dif zeta)/(zeta-z)$ есть
  интеграл Коши. Тогда в области $g$, внутренней к кривой $L$, $F(z)$ совпадает
  с функцией $f(z)$, аналитической во всех точках некоторой области $G$,
  содержащей и $L$ и $g$. Поэтому, если $zeta_0$ — какая-либо точка на $L$, то
  $F(z)=f(z)$ стремится к пределу $f lr((zeta_0))$, когда $z$ стремится к
  $zeta_0$ изнутри $L$. Во внешности кривой $L$ интеграл Коши обращается в нуль
  (см. п. @pt:cauchy-integral-formula). Поэтому, когда $z$ стремится к точке
  $zeta_0$, оставаясь во внешности кривой $L$, интеграл Коши стремится к
  пределу, равному нулю.

  Итак, для интеграла Коши в каждой точке $zeta_0$ кривой $L$ существуют
  граничные значения, равные $f lr((zeta_0))$ изнутри $L$ и $0$ извне $L$.

  Будем теперь рассматривать интеграл типа Коши
  $1/(2 pi i) integral_gamma (phi(zeta))/(zeta-z) dif zeta$ при следующих
  частных предположениях:
  #properties(
    numbering: "а)",
    [$gamma$ является жордановой спрямляемой кривой,],
    [функция $phi(zeta)$ является аналитической в некоторой окрестности каждой
      точки кривой $gamma$.],
  )
  Покажем, что при этих условиях также существуют два граничных значения
  интеграла в каждой точке $zeta_0 in gamma$, отличной от концов $gamma$. В
  отличие #source(255)от случая интеграла Коши, значения эти не будут выражаться
  непосредственно через $phi lr((zeta_0))$. Однако их разность в точке $zeta_0$
  будет равна $phi lr((zeta_0))$ (если взять надлежащим образом одно из них за
  уменьшаемое, а другое за вычитаемое). Следовательно, здесь обнаруживается та
  же закономерность, что и в случае интеграла Коши, где разность внутреннего и
  внешнего граничных значений есть $f lr((zeta_0))-0=f lr((zeta_0))$.

  Переходя к доказательству, возьмем окрестность $U$ точки $zeta_0$ так, чтобы
  функция $phi(z)$ была аналитической в $U$, и проведем окружность $C$ с центром
  в $zeta_0$, содержащуюся в $U$ и имеющую столь малый радиус, чтобы среди точек
  кривой $gamma$, предшествующих $zeta_0$ и следующих за $zeta_0$ (в направлении
  интегрирования), имелись точки, лежащие на $C$. Тогда, отправляясь от точки
  $zeta_0$ сначала в направлении обхода кривой $gamma$ до первой точки $B$
  пересечения $gamma$ с окружностью $C$, а затем от той же точки $zeta_0$ в
  противоположном направлении также до первой точки $A$ пересечения $gamma$ с
  окружностью $C$, получим дугу $overparen(A B) subset gamma$, содержащую точку
  $zeta_0$ и принадлежащую внутренности $C$, за исключением своих концов $A$ и
  $B$, лежащих на $C$. Точки $A$ и $B$ делят окружность $C$ на две дуги $A a B$
  и $A b B$, которые вместе с дугой $A B$, принадлежащей $gamma$, образуют две
  замкнутые жордановы кривые $gamma_1$ ($A B a A$) и $gamma_2$ ($A B b A$), с
  внутренностями $g_1$ и $g_2$, лежащими внутри $C$ (рис.
  @fig:cauchy-boundary-deformation).
  #figure(
    boundary-deformation(),
    caption: [],
    supplement: [Рис.],
    numbering: "1",
  )
  <fig:cauchy-boundary-deformation>

  Заметим, что наши обозначения выбраны так, что область $g_1$ лежит слева от
  наблюдателя, двигающегося по $A B$ в направлении интегрирования, а область
  $g_2$ — справа от него. Пусть теперь точка $z in g_1$ стремится к пределу
  $zeta_0$. Так как $z$ лежит во внешности кривой $gamma_2$, которая вместе со
  своей внутренностью $g_2$ принадлежит области $U$, где $phi(zeta)$ является
  аналитической, то по интегральной теореме Коши
  $ 1/(2 pi i) integral_(gamma_2) (phi(zeta))/(zeta-z) dif zeta = 0, $
  т. е.
  $
    1/(2 pi i) integral_(A B) (phi(zeta) dif zeta)/(zeta-z)
    = 1/(2 pi i) integral_(A b B) (phi(zeta) dif zeta)/(zeta-z).
  $
  Отсюда следует, что для точек $z in g_1$ мы не изменим значения интеграла
  $ F(z)=1/(2 pi i) integral_gamma (phi(zeta) dif zeta)/(zeta-z), $
  если вместо дуги $A B$ будем вести интегрирование по дуге окружности $A b B$.
  Итак, в области $g_1$ имеем: #eq[$
    F(z)=1/(2 pi i) integral_(gamma'+A b B)
    (phi(zeta) dif zeta)/(zeta-z),
  $] <eq:cauchy-boundary-left-deformation>
  где $gamma'$ получается из $gamma$ путем удаления дуги $A B$.

  #source(256)Но $gamma'+A b B$ есть спрямляемая кривая (быть может, не
  жорданова), и, следовательно, интеграл @eq:cauchy-boundary-left-deformation
  есть интеграл типа Коши, который в силу п. @pt:cauchy-type-integral должен
  представлять аналитическую функцию $Phi_1 lr((z))$ в любой окрестности точки
  $zeta_0$, не содержащей точек кривой $gamma'+A b B$, причем в точках этой
  окрестности, принадлежащих $g_1$, $Phi_1 lr((z))$, как показывает равенство
  @eq:cauchy-boundary-left-deformation, совпадает с $F(z)$. Следовательно, #eq[$
    lim_(z -> zeta_0 \ z in g_1) F(z)
    = lim_(z -> zeta_0 \ z in g_1) Phi_1 lr((z))
    = Phi_1 lr((zeta_0)) = 1/(2 pi i) integral_(gamma'+A b B)
    (phi(zeta) dif zeta)/(zeta-zeta_0).
  $] <eq:cauchy-boundary-left-value>
  Совершенно так же для точек области $g_2$ мы можем написать: #eq[$
    F(z)=1/(2 pi i) integral_(gamma'+A a B)
    (phi(zeta) dif zeta)/(zeta-z),
  $] <eq:cauchy-boundary-right-deformation>
  где стоящий в правой части интеграл типа Коши представляет в окрестности
  $zeta_0$ некоторую аналитическую функцию $Phi_2 lr((z))$, совпадающую с $F(z)$
  в точках этой окрестности, принадлежащих $g_2$. Отсюда следует, что #eq[$
    lim_(z -> zeta_0 \ z in g_2) F(z)
    = lim_(z -> zeta_0 \ z in g_2) Phi_2 lr((z))
    = Phi_2 lr((zeta_0)) = 1/(2 pi i) integral_(gamma'+A a B)
    (phi(zeta) dif zeta)/(zeta-zeta_0).
  $] <eq:cauchy-boundary-right-value>
  Итак, мы установили существование двух граничных значений интеграла типа Коши
  в произвольной точке $zeta_0$ спрямляемой кривой и нашли их значения
  @eq:cauchy-boundary-left-value и @eq:cauchy-boundary-right-value. Одно из них,
  соответствующее стремлению $z$ к $zeta_0$ по области $g_1$, примыкающей к дуге
  $overparen(A B) subset gamma$ слева по направлению интегрирования, можно
  назвать левым, а другое — правым граничным значением и обозначить их
  соответственно через $F_(upright("Л")) lr((zeta_0))$
  @eq:cauchy-boundary-left-value и $F_(upright("П")) lr((zeta_0))$
  @eq:cauchy-boundary-right-value.

  Из формул @eq:cauchy-boundary-left-value и @eq:cauchy-boundary-right-value
  следует, что
  $
    F_(upright("Л")) lr((zeta_0))-F_(upright("П")) lr((zeta_0))
    = 1/(2 pi i) integral_(A b B - A a B)
    (phi(zeta) dif zeta)/(zeta-zeta_0)
    = 1/(2 pi i) integral_C (phi(zeta) dif zeta)/(zeta-zeta_0).
  $
  В силу сделанных нами предположений полученный интеграл есть интеграл Коши,
  образованный для функции $phi(z)$ и окружности $C$. По интегральной формуле
  Коши, его значение равно $phi lr((zeta_0))$. Итак, #eq[$
    F_(upright("Л")) lr((zeta_0))-F_(upright("П")) lr((zeta_0))
    = phi lr((zeta_0)),
  $] <eq:cauchy-boundary-analytic-jump>
  что мы и утверждали.

  В виде примера рассмотрим интеграл типа Коши
  $ F(z)=1/(2 pi i) integral_Delta (dif x)/(x-z), $
  где $Delta$ представляет сегмент действительной оси $-1<=x<=1$ (интегрирование
  ведется в направлении возрастания $x$), и возьмем для простоты $zeta_0=0$.
  Здесь $phi(zeta)=1$ является функцией, аналитической во всей плоскости.
  Следовательно, мы ничем не стеснены в выборе окружности $C$ с центром в точке
  $0$, кроме единственного условия, что на $C$ должны находиться точки отрезка
  $Delta$, предшествующие точке $0$ и следующие за ней. Выберем в качестве $C$
  единичную окружность. Тогда дуга $A B$ совпадет со всем сегментом $Delta$ и
  дуги окружности $A b B$ и $A a B$ будут, соответственно, нижней и верхней
  полуокружностями.

  #source(257)В формуле @eq:cauchy-boundary-analytic-jump мы должны иметь для
  разности граничных значений интеграла типа Коши:
  $ F_(upright("Л")) lr((0))-F_(upright("П")) lr((0))=phi(0)=1. $
  Что касается каждого из них в отдельности, то формула
  @eq:cauchy-boundary-left-value дает:
  $
    F_(upright("Л")) lr((0))=1/(2 pi i) integral_(overparen(A b B))
    (dif zeta)/zeta = 1/(2 pi i) integral_pi^(2 pi)
    (e^(i theta) i dif theta)/(e^(i theta))=1/2,
  $
  и формула @eq:cauchy-boundary-right-value:
  $
    F_(upright("П")) lr((0))=1/(2 pi i) integral_(overparen(A a B))
    (dif zeta)/zeta = 1/(2 pi i) integral_pi^0
    (e^(i theta) i dif theta)/(e^(i theta))=-1/2.
  $

  #point() <pt:sokhotski-boundary-formulas>
  Относительно полученного в предыдущем пункте результата
  @eq:cauchy-boundary-analytic-jump можно сделать то существенное возражение,
  что он выведен в предположении аналитичности функции $phi(zeta)$, тогда как в
  приложениях часто бывает важен случай, когда $phi(zeta)$ не является
  аналитической функцией.

  В связи с этим мы дадим здесь другое доказательство того же факта, приводящее
  вместе с тем к важным формулам для $F_(upright("Л")) lr((zeta_0))$ и
  $F_(upright("П")) lr((zeta_0))$, отличным от формул
  @eq:cauchy-boundary-left-value и @eq:cauchy-boundary-right-value.

  Пусть $gamma$, по-прежнему, — жорданова спрямляемая кривая и $phi(zeta)$ —
  функция, непрерывная на $gamma$. Рассматривая $zeta$ как функцию длины дуги
  $s$, отсчитываемой от начальной точки $gamma$:
  $ zeta=lambda(s), quad 0<=s<=l quad (l "— длина" gamma), $
  предположим, что в некоторой точке $zeta_0=lambda lr((s_0))$ ($0<s_0<l$)
  существует конечная и отличная от нуля производная
  $lambda' lr((s_0))$#footnote[
    В теории функций действительного переменного доказывается, что всюду в
    интервале $(0,l)$, за исключением, быть может, множества точек меры нуль,
    $lambda' lr((s))$ существует, причем $abs(lambda' lr((s)))=1$. См.,
    например, #bib-description("ValleePoussin0000"), п.~359.
  ].

  Допустим далее, что существуют числа $K>0$ и $alpha>0$ такие, что при
  $zeta != zeta_0$
  #eq[$ abs(phi(zeta)-phi lr((zeta_0))) < K abs(zeta-zeta_0)^alpha. $]
  <eq:sokhotski-holder-condition>
  Легко видеть, что при сделанных предположениях несобственный интеграл
  #eq[$
    I_0=1/(2 pi i) integral_gamma
    (phi(zeta)-phi lr((zeta_0)))/(zeta-zeta_0) dif zeta
  $]
  <eq:sokhotski-absolute-remainder-integral>
  абсолютно сходится. Чтобы убедиться в этом, условимся обозначать дугу кривой
  $gamma$, соответствующую определенному сегменту изменения длины дуги
  $s: a<=s<=b$, символом $[a,b]$. Тогда для любой дуги $[a,b]$, не содержащей
  точки $zeta_0$ (пусть, для определенности, $s_0<a<b$), будем иметь, в силу
  @eq:sokhotski-holder-condition:
  $
    1/(2 pi) integral_([a,b])
    abs((phi(zeta)-phi lr((zeta_0)))/(zeta-zeta_0)) dif s
    < K/(2 pi) integral_([a,b]) abs(zeta-zeta_0)^(alpha-1) dif s.
  $

  #source(258)По предположению
  $lim_(s -> s_0) abs((zeta-zeta_0)/(s-s_0))=abs(lambda' lr((s_0))) != 0$,
  откуда вытекает, что
  $abs((zeta-zeta_0)/(s-s_0)) > 1/2 abs(lambda' lr((s_0)))$
  при $0<abs(zeta-zeta_0)<rho$; если же $abs(zeta-zeta_0)>=rho$, то
  $abs((zeta-zeta_0)/(s-s_0))>rho/l$. Итак, $abs((zeta-zeta_0)/(s-s_0))>c>0$ при
  всех $zeta in gamma$, $zeta != zeta_0$. Отсюда следует, что
  $
    abs(
      1/(2 pi i) integral_([a,b])
      (phi(zeta)-phi lr((zeta_0)))/(zeta-zeta_0) dif zeta
    )
    < K' integral_a^b (s-s_0)^(alpha-1) dif s
    = K' ((b-s_0)^alpha-(a-s_0)^alpha)/alpha -> 0
  $
  при $a$ и $b -> s_0$. Итак, интеграл @eq:sokhotski-absolute-remainder-integral
  абсолютно сходится.

  Обращаясь к интегралу типа Коши
  $ F(z)=1/(2 pi i) integral_gamma (phi(zeta))/(zeta-z) dif zeta, $
  представим его в виде
  #eq[$
    F(z)=1/(2 pi i) integral_gamma
    (phi(zeta)-phi lr((zeta_0)))/(zeta-z) dif zeta
    +1/(2 pi i) integral_gamma (phi lr((zeta_0)))/(zeta-z) dif zeta
  $]
  <eq:sokhotski-density-decomposition>
  и покажем, что
  #eq[$
    lim_(z -> zeta_0) 1/(2 pi i) integral_gamma
    (phi(zeta)-phi lr((zeta_0)))/(zeta-z) dif zeta=I_0.
  $]
  <eq:sokhotski-remainder-boundary-limit>
  #metadata(none) <def:non-tangential-approach>
  При этом мы будем предполагать, что $z$ стремится к $zeta_0$, оставаясь внутри
  произвольного угла $g_theta$, раствора меньшего $2theta<pi$, с вершиной в
  точке $zeta_0$ и биссектрисой, совпадающей с нормалью к кривой в этой точке.
  Такого рода стремление $z$ к $zeta_0$ характеризуют как «_стремление по
  некасательным к $gamma$ путям_». В частности, этому условию удовлетворяет
  стремление точки $z$ по нормалям к $gamma$. Легко видеть, что в достаточно
  малой окрестности точки $zeta_0$ ни одна точка кривой $gamma$ не попадает
  внутрь фиксированного угла $g_theta$ (а также внутрь вертикального с ним
  угла). Действительно, допустим противное. Тогда должна существовать
  последовательность точек $zeta_n=lambda lr((s_n)) in gamma$, лежащих внутри
  $g_theta$ (или внутри вертикального с ним угла) и сходящихся к $zeta_0$. При
  этом мы можем считать, что $lr({s_n})$ также сходится, т. е.
  $lim_(n -> oo) s_n=s'$, откуда следует, что $lim_(n -> oo) zeta_n=lambda(s')$.
  Но, с другой стороны, $lim_(n -> oo) zeta_n=zeta_0=lambda lr((s_0))$; в силу
  того, что $gamma$ жорданова кривая (и $zeta_0$ отлична от ее концов),
  заключаем, что $s'=s_0$. Поэтому векторы $zeta_n-zeta_0$ должны по направлению
  стремиться к касательной в точке $zeta_0$ и, следовательно, не могут все
  оставаться внутри угла $g_theta$.

  Пусть $theta$ — число, удовлетворяющее условию $0<theta<pi/2$; фиксируем
  $theta_0$, $theta<theta_0<pi/2$ и рассмотрим окрестность $abs(z-zeta_0)<rho$
  такую, что ни одна точка кривой $gamma$, лежащая в этой окрестности, не
  принадлежит углу $g_(theta_0)$ (а также углу, вертикальному с ним), и пусть
  $g_(theta,rho)$ — часть угла $g_theta$, принадлежащая указанной окрестности.
  Продолжая $gamma$ от точки $zeta_0$ в двух направлениях до первых точек $A$ и
  $B$ пересечения с окружностью $abs(z-zeta_0)=rho$, получим дугу
  $ sigma_rho=[s_0-epsilon', s_0+epsilon''] subset gamma. $

  #source(259)Очевидно, для любых точек $z in g_(theta,rho)$ и
  $zeta in sigma_rho$ будем иметь:
  $ (abs(z-zeta_0))/(abs(z-zeta)) < csc(theta_0-theta) $
  (рис. @fig:sokhotski-nontangential-angle). Поэтому
  $
    A=abs(
      I_0-1/(2 pi i) integral_gamma
      (phi(zeta)-phi lr((zeta_0)))/(zeta-z) dif zeta
    ) =
    \ = abs(
      1/(2 pi i) integral_gamma
      lr([phi(zeta)-phi lr((zeta_0))])
      (zeta_0-z)/((zeta-z)(zeta-zeta_0)) dif zeta
    ) <=
    \ <= abs(
      1/(2 pi i) integral_(gamma-sigma_rho)
      lr([phi(zeta)-phi lr((zeta_0))])
      (zeta_0-z)/((zeta-z)(zeta-zeta_0)) dif zeta
    ) +
    \ +csc(theta_0-theta) 1/(2 pi) integral_(sigma_rho)
    abs((phi(zeta)-phi lr((zeta_0)))/(zeta-zeta_0)) dif s = i_1+i_2.
  $
  Если $epsilon$ — произвольное положительное число, то $rho$ можно считать
  столь малым, чтобы $i_2$ было меньше, чем $epsilon/2$; фиксируем это значение
  $rho$. Далее
  #figure(
    non-tangential-approach(),
    caption: [],
    supplement: [Рис.],
    numbering: "1",
  )
  <fig:sokhotski-nontangential-angle>
  заметим, что расстояние $delta_0$ точки $zeta_0$ до дуги $gamma-sigma_rho$
  положительно; поэтому $abs(zeta-zeta_0)>=delta_0>0$, если
  $zeta in gamma-sigma_rho$, и $abs(zeta-z)>=delta_0-abs(zeta_0-z)$. Поэтому при
  $abs(z-zeta_0)<delta_0/2$ будем иметь:
  $
    i_1 <= 1/pi (abs(zeta_0-z))/(delta_0^2)
    integral_(gamma-sigma_rho) abs(phi(zeta)-phi lr((zeta_0))) dif s <=
    \ <= (abs(zeta_0-z))/(pi delta_0^2)
    integral_gamma abs(phi(zeta)-phi lr((zeta_0))) dif s,
  $
  откуда при всех $z$, достаточно близких к $zeta_0$, получим: $i_1<epsilon/2$.
  Итак, $A<epsilon$ при всех $z$, достаточно близких к $zeta_0$ и принадлежащих
  $g_(theta,rho)$, т. е. соотношение @eq:sokhotski-remainder-boundary-limit
  доказано для $z$, стремящихся к $zeta_0$ по некасательным к $gamma$ путям.

  #source(260)Рассмотрим теперь второй из интегралов в правой части равенства
  @eq:sokhotski-density-decomposition. Очевидно это — интеграл типа Коши с
  постоянной, а следовательно, аналитической функцией $phi(zeta)$
  ($=phi lr((zeta_0))$). При этом он представляет одно из значений
  $(phi lr((zeta_0)))/(2 pi i) op("Ln") (Q-z)/(P-z)$, где $P$ — начальная, а $Q$
  — конечная точки кривой $gamma$. Однако мы не будем пользоваться этим
  последним замечанием, но сошлемся на результаты предыдущего пункта, в силу
  которых
  #eq[$
    f_(upright("Л")) lr((zeta_0))=1/(2 pi i)
    integral_(gamma'+A b B) (phi lr((zeta_0)) dif zeta)/(zeta-zeta_0),
    quad f_(upright("П")) lr((zeta_0))=1/(2 pi i)
    integral_(gamma'+A a B) (phi lr((zeta_0)) dif zeta)/(zeta-zeta_0).
  $]
  <eq:sokhotski-constant-density-boundaries>
  Сопоставляя @eq:sokhotski-density-decomposition,
  @eq:sokhotski-remainder-boundary-limit и
  @eq:sokhotski-constant-density-boundaries, заключаем, что при гипотезах
  относительно $gamma$, $phi(zeta)$ и $zeta_0 in gamma$, формулированных в этом
  пункте, существуют граничные значения $F_(upright("Л")) lr((zeta_0))$ и
  $F_(upright("П")) lr((zeta_0))$ интеграла типа Коши, выраженные формулами:
  #eq[$
    F_(upright("Л")) lr((zeta_0))=1/(2 pi i) integral_gamma
    (phi(zeta)-phi lr((zeta_0)))/(zeta-zeta_0) dif zeta
    +1/(2 pi i) integral_(gamma'+A b B)
    (phi lr((zeta_0)) dif zeta)/(zeta-zeta_0),
  $]
  <eq:sokhotski-left-regularized-value>
  #eq[$
    F_(upright("П")) lr((zeta_0))=1/(2 pi i) integral_gamma
    (phi(zeta)-phi lr((zeta_0)))/(zeta-zeta_0) dif zeta
    +1/(2 pi i) integral_(gamma'+A a B)
    (phi lr((zeta_0)) dif zeta)/(zeta-zeta_0).
  $]
  <eq:sokhotski-right-regularized-value>
  Вычитая почленно @eq:sokhotski-right-regularized-value из
  @eq:sokhotski-left-regularized-value, получаем:
  #eq[$
    F_(upright("Л")) lr((zeta_0))-F_(upright("П")) lr((zeta_0))
    =1/(2 pi i) integral_(abs(zeta-zeta_0)=rho)
    (phi lr((zeta_0)) dif zeta)/(zeta-zeta_0)=phi lr((zeta_0)).
  $]
  <eq:sokhotski-holder-jump>
  Мы получили эту формулу, совпадающую с формулой
  @eq:cauchy-boundary-analytic-jump, не предполагая аналитичности функции
  $phi(zeta)$.

  Преобразуем @eq:sokhotski-left-regularized-value и
  @eq:sokhotski-right-regularized-value к более простому виду, а именно,
  перепишем @eq:sokhotski-left-regularized-value следующим образом:
  #eq[$
    F_(upright("Л")) lr((zeta_0))=1/(2 pi i) integral_(gamma')
    (phi(zeta)-phi lr((zeta_0)))/(zeta-zeta_0) dif zeta
    +1/(2 pi i) integral_(sigma_rho)
    (phi(zeta)-phi lr((zeta_0)))/(zeta-zeta_0) dif zeta +
    \ +1/(2 pi i) integral_(gamma')
    (phi lr((zeta_0)))/(zeta-zeta_0) dif zeta
    +1/(2 pi i) integral_(A b B)
    (phi lr((zeta_0)))/(zeta-zeta_0) dif zeta
    =1/(2 pi i) integral_(gamma') (phi(zeta))/(zeta-zeta_0) dif zeta +
    \ +1/(2 pi i) integral_(sigma_rho)
    (phi(zeta)-phi lr((zeta_0)))/(zeta-zeta_0) dif zeta
    +1/(2 pi i) integral_(A b B)
    (phi lr((zeta_0)))/(zeta-zeta_0) dif zeta.
  $]
  <eq:sokhotski-principal-value-decomposition>
  При $rho -> 0$ второй из интегралов правой части формулы
  @eq:sokhotski-principal-value-decomposition стремится к нулю (в силу
  установленной выше сходимости интеграла
  @eq:sokhotski-absolute-remainder-integral). Третий интеграл может быть записан
  в виде $(phi lr((zeta_0)))/(2 pi i)
  limits(op("Изм"))_(A b B) op("Ln")(zeta-zeta_0)$ и (так как
  $op("Ln")(zeta-zeta_0)=ln rho+i op("Arg")(zeta-zeta_0)$) совпадает с
  $
    (phi lr((zeta_0)))/(2 pi) limits(op("Изм"))_(A b B) op("Arg")(zeta-zeta_0)
    =(phi lr((zeta_0)))/(2 pi) ("дл." A b B)/rho.
  $

  #source(261)Но дуга $sigma_rho in gamma$ с концами $A$ и $B$ может быть
  заключена, по предыдущему, в сколь угодно узкие вертикальные углы с общей
  вершиной $zeta_0$ и биссектрисой, совпадающей с касательной к $gamma$ в точке
  $zeta_0$. Поэтому точки $A$ и $B$ стремятся при $rho -> 0$ соответственно к
  двум точкам пересечения этой касательной с окружностью $abs(zeta-zeta_0)=rho$,
  откуда следует, что
  $
    lim_(rho -> 0) 1/(2 pi i) integral_(A b B)
    (phi lr((zeta_0)) dif zeta)/(zeta-zeta_0)
    =(phi lr((zeta_0)))/(2 pi) pi=(phi lr((zeta_0)))/2.
  $
  Так как левая часть формулы @eq:sokhotski-principal-value-decomposition от
  $rho$ не зависит, то мы заключаем, что существует также #eq[$
    lim_(rho -> 0) 1/(2 pi i) integral_(gamma')
    (phi(zeta) dif zeta)/(zeta-zeta_0),
  $] <eq:cauchy-principal-value-limit>
  который мы обозначим через
  $1/(2 pi i) integral'_gamma (phi(zeta) dif zeta)/(zeta-zeta_0)$#footnote[
    Заметим, что интеграл
    $1/(2 pi i) integral_gamma (phi(zeta) dif zeta)/(zeta-zeta_0)$, вообще
    говоря, расходится. Символ
    $1/(2 pi i) integral'_gamma (phi(zeta) dif zeta)/(zeta-zeta_0)$
    выбран лишь для обозначения предела @eq:cauchy-principal-value-limit,
    существование которого мы установили. Этот предел называется
    *главным значением интеграла*
    $1/(2 pi i) integral_gamma (phi(zeta) dif zeta)/(zeta-zeta_0)$
    (в смысле Коши).
    #idx("Главное значение", "интеграла")
    #idx("Интеграл", "главное значение")
  ].

  Итак, окончательно получаем:
  #eq[$
    F_(upright("Л")) lr((zeta_0))=1/(2 pi i) integral'_gamma
    (phi(zeta) dif zeta)/(zeta-zeta_0)+1/2 phi lr((zeta_0)).
  $]
  <eq:sokhotski-left-formula>
  Отсюда и из формулы @eq:sokhotski-holder-jump следует, что
  #eq[$
    F_(upright("П")) lr((zeta_0))=1/(2 pi i) integral'_gamma
    (phi(zeta) dif zeta)/(zeta-zeta_0)-1/2 phi lr((zeta_0)).
  $]
  <eq:sokhotski-right-formula>
  Формулы эти, имеющие важные приложения к механике, были впервые получены Ю. В.
  Сохоцким при предположениях, совпадающих с предположениями настоящего пункта,
  и поэтому называются *формулами Сохоцкого*.
  #idx("Сохоцкого формулы", target: <eq:sokhotski-left-formula>)

  #point() <pt:generalized-cauchy-formula>
  Формулу Коши можно получить как частный случай более общей формулы,
  справедливой для функций, вообще говоря, неаналитических.

  Пусть $Delta$ — область, ограниченная конечным числом замкнутых жордановых
  кусочно-гладких кривых: $Gamma$ (внешний контур), $gamma_1,dots,gamma_n$
  (внутренние контуры), $F(z)=P(x,y)+i Q(x,y)$ — функция непрерывная с частными
  производными первого порядка в замкнутой области $Delta$. Все контуры
  ориентируем положительно. Тогда, применяя #source(262)формулу Грина, получим:
  #eq[$
    integral_Gamma F(z) dif z
    - sum_(j=1)^n integral_(gamma_j) F(z) dif z =
    \ = integral_Gamma P dif x-Q dif y
    +i integral_Gamma Q dif x+P dif y
    \ - sum_(j=1)^n lr(
      [integral_(gamma_j) P dif x-Q dif y
        +i integral_(gamma_j) Q dif x+P dif y]
    ) =
    \ = integral.double_Delta lr(
      [-( (partial Q)/(partial x)
          +(partial P)/(partial y))
        +i((partial P)/(partial x)-(partial Q)/(partial y))]
    ) dif x dif y
    =2i integral.double_Delta (partial F)/(partial overline(z)) dif x dif y
  $]
  <eq:complex-green-formula>
  (здесь $(partial F)/(partial overline(z))$ — формальная производная, см. п.
  @pt:dalambert-euler-conditions). Фиксируем $z_0 in Delta$ и исключим из
  $Delta$ окрестность $abs(z-z_0)<epsilon$, радиус которой меньше расстояния от
  $z_0$ до границы области $Delta$. Получим область $Delta_epsilon$, граница
  которой состоит из $Gamma$, $gamma_1,dots,gamma_n$ и окружности
  $gamma_epsilon: abs(z-z_0)=epsilon$. Применим формулу
  @eq:complex-green-formula к функции $Phi(z)=(F(z))/(z-z_0)$; получим:
  $
    integral_Gamma (F(z) dif z)/(z-z_0)
    -sum_(j=1)^n integral_(gamma_j) (F(z) dif z)/(z-z_0)
    -integral_(gamma_epsilon) (F(z) dif z)/(z-z_0)
    =2i integral.double_(Delta_epsilon) (partial)/(partial overline(z))
    lr([(F(z))/(z-z_0)]) dif x dif y =
    \ =2i integral.double_(Delta_epsilon)
    lr(
      [(partial F)/(partial overline(z)) 1/(z-z_0)
        +F(z) (partial)/(partial overline(z)) (1/(z-z_0))]
    ) dif x dif y =
    \ =2i integral.double_(Delta_epsilon)
    (partial F)/(partial overline(z)) 1/(z-z_0) dif x dif y,
  $
  ($(partial)/(partial overline(z)) (1/(z-z_0))=0$, так как $1/(z-z_0)$ —
  функция, аналитическая в области $Delta_epsilon$).

  При $epsilon -> 0$ получим:
  $
    lim_(epsilon -> 0) integral_(gamma_epsilon) (F(z) dif z)/(z-z_0)
    =2 pi i F lr((z_0)),
    quad lim_(epsilon -> 0) integral.double_(Delta_epsilon)
    (partial F)/(partial overline(z)) 1/(z-z_0) dif x dif y
    =integral.double_Delta (partial F)/(partial overline(z))
    1/(z-z_0) dif x dif y
  $
  и, следовательно,
  #eq[$
    F lr((z_0))=1/(2 pi i) integral_Gamma (F(z) dif z)/(z-z_0)
    -sum_(j=1)^n 1/(2 pi i) integral_(gamma_j) (F(z) dif z)/(z-z_0)
    \ -1/pi integral.double_Delta
    (partial F)/(partial overline(z)) 1/(z-z_0) dif x dif y.
  $]
  <eq:generalized-cauchy-formula>
  Это и есть искомая общая формула. В ней сумма интегралов типа Коши
  $
    1/(2 pi i) integral_Gamma (F(z) dif z)/(z-z_0)
    -sum_(j=1)^n 1/(2 pi i) integral_(gamma_j) (F(z) dif z)/(z-z_0)
    =Psi lr((z_0))
  $
  является аналитической функцией $z_0$.

  #source(263)Следовательно, функция
  $
    F lr((z_0))-Psi lr((z_0))=-1/pi integral.double_Delta
    (partial F)/(partial overline(z)) 1/(z-z_0) dif x dif y
  $
  подобно $F lr((z_0))$ непрерывна вместе с частными производными первого
  порядка в области $Delta$, причем
  $
    (partial)/(partial overline(z_0)) lr(
      [-1/pi integral.double_Delta
        (partial F)/(partial overline(z)) 1/(z-z_0) dif x dif y]
    )
    =(partial)/(partial overline(z_0)) lr([F lr((z_0))-Psi lr((z_0))])
    =(partial F)/(partial overline(z_0)).
  $
  В случае, когда $F(z)$ есть функция, аналитическая в области $Delta$,
  формальная производная $(partial F)/(partial overline(z)) equiv 0$ и формула
  @eq:generalized-cauchy-formula переходит в интегральную формулу Коши:
  $
    F lr((z_0))=1/(2 pi i) integral_Gamma (F(z) dif z)/(z-z_0)
    -sum_(j=1)^n 1/(2 pi i) integral_(gamma_j) (F(z) dif z)/(z-z_0).
  $
]
