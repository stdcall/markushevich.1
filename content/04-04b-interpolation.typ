#import "main-defs.typ": eq, idx, petit, point, source, variant-eq
#import "statements.typ": properties
#import "bibliography-style.typ": bib-description

#petit[
  #point() <pt:hermite-interpolation>
  #source(450)
  Рассмотрим задачу о построении интерполяционного многочлена для данной
  аналитической функции $f(z)$. Задача заключается в том, чтобы по системе
  попарно различных точек
  $ z_1,z_2,dots,z_m, $
  принадлежащих области $G$, и по заданным в таком же количестве натуральным
  числам
  $ alpha_1,alpha_2,dots,alpha_m, quad alpha_1+alpha_2+dots+alpha_m=n>=m $
  построить многочлен $Pi(z)$, возможно более низкой степени, удовлетворяющий
  условиям
  $
    Pi(z_j)=f(z_j),dots,Pi^((alpha_j-1)) lr((z_j))
    =f^((alpha_j-1)) lr((z_j)) quad (j=1,2,dots,m).
  $
  Многочлен $Pi(z)$, удовлетворяющий этим условиям, называется #metadata(
    none,
  ) <def:interpolating-polynomial>_интерполяционным многочленом_ для $f(z)$,
  соответствующим точкам интерполяции $z_j$, с кратностями $alpha_j$
  $(j=1,2,dots,m)$.#idx(
    "Интерполяционный многочлен",
    target: <def:interpolating-polynomial>,
  )#idx("Многочлен", "интерполяционный", target: <def:interpolating-polynomial>)

  Если $Pi(z)$ — такой многочлен, то для разности
  $ R(z)=f(z)-Pi(z), $
  #source(451)
  представляющей, очевидно, аналитическую функцию в области $G$, имеем:
  $ R(z_j)=dots=R^((alpha_j-1)) lr((z_j))=0 quad (j=1,2,dots,m). $
  Следовательно, $R(z)$ имеет нуль в каждой из точек $z_j$, с кратностью, по
  меньшей мере равной $alpha_j$. Пусть $Pi_1 lr((z))$ — другой многочлен,
  удовлетворяющий условиям задачи. Соответствующая функция
  $ R_1 lr((z))=f(z)-Pi_1 lr((z)) $
  также будет иметь нули $z_1,dots,z_m$, с кратностями, не меньшими, чем
  $alpha_1,dots,alpha_m$; то же самое будет справедливым и для
  $ R(z)-R_1 lr((z))=Pi_1 lr((z))-Pi(z). $

  Итак, $Pi_1 lr((z))-Pi(z)$ есть многочлен, имеющий по крайней мере $n$ нулей:
  $z_1,z_2,dots,z_m$, с кратностями, не меньшими, чем
  $alpha_1,alpha_2,dots,alpha_m$, откуда следует, что $Pi_1 lr((z))-Pi(z)$
  делится на многочлен
  $ (z-z_1)^(alpha_1) dots (z-z_m)^(alpha_m)=omega(z) $
  степени $n$. Поэтому в случае, когда каждый из многочленов $Pi(z)$ и
  $Pi_1 lr((z))$ имеет степень ниже $n$, их разность должна быть тождественным
  нулем, т. е. среди многочленов степени ниже $n$ существует не более чем один
  многочлен, решающий поставленную задачу.

  Покажем, что такой многочлен действительно существует и может быть представлен
  в виде интеграла #eq[$
    Pi(z)=1/(2 pi i) integral_gamma f(zeta)/omega(zeta)
    (omega(zeta)-omega(z))/(zeta-z) dif zeta,
  $] <eq:hermite-interpolating-polynomial>
  где $gamma$ — какая-либо положительно ориентированная замкнутая жорданова
  спрямляемая кривая, лежащая в области $G$ вместе со своей внутренностью и
  содержащая внутри точки $z_1,dots,z_m$.

  В самом деле, если $omega(z)=sum_0^n A_k z^k$, то
  $
    (omega(zeta)-omega(z))/(zeta-z)
    =(sum_0^n A_k lr((zeta^k-z^k)))/(zeta-z)
    \
    =A_1+A_2 lr((zeta+z))+dots+A_n lr((zeta^(n-1)+dots+z^(n-1)))
    \
    =A_1+A_2 zeta+dots+A_n zeta^(n-1)
    +(A_2+A_3 zeta+dots+A_n zeta^(n-2))z+dots+A_n z^(n-1)
    \
    =B_(n-1) lr((zeta))+B_(n-2) lr((zeta))z+dots+B_0 lr((zeta))z^(n-1),
  $
  где $B_(n-1) lr((zeta)),B_(n-2) lr((zeta)),dots,B_0 lr((zeta))$ — многочлены
  относительно $zeta$, степени которых совпадают с их индексами. Следовательно,
  $Pi(z)$ можно представить в виде
  $
    Pi(z)=1/(2 pi i) integral_gamma f(zeta)/omega(zeta)
    sum_(k=0)^(n-1) B_(n-1-k) lr((zeta)) z^k dif zeta
    \
    =sum_(k=0)^(n-1) lr(
      (1/(2 pi i) integral_gamma
        f(zeta)/omega(zeta) B_(n-1-k) lr((zeta)) dif zeta)
    ) z^k
    =sum_(k=0)^(n-1) P_k z^k,
  $
  где
  $
    P_k=1/(2 pi i) integral_gamma f(zeta)/omega(zeta)
    B_(n-1-k) lr((zeta)) dif zeta quad (k=0,1,2,dots,n-1).
  $

  #source(452)
  Итак, формула @eq:hermite-interpolating-polynomial представляет многочлен
  степени не выше, чем $n-1$. Образуем разность $R(z)=f(z)-Pi(z)$. Если точка
  $z$ лежит внутри $gamma$, то $f(z)$ можно представить в виде
  $f(z)=1/(2 pi i) integral_gamma f(zeta)/(zeta-z) dif zeta$, и, следовательно,
  $R(z)$ можно преобразовать следующим образом: #eq[$
    R(z)=1/(2 pi i) integral_gamma f(zeta)/(zeta-z) dif zeta
    -1/(2 pi i) integral_gamma f(zeta)/omega(zeta)
    (omega(zeta)-omega(z))/(zeta-z) dif zeta
    \
    =1/(2 pi i) integral_gamma f(zeta)/(zeta-z)
    omega(z)/omega(zeta) dif zeta
  $] <eq:hermite-interpolation-remainder>
  или, наконец, #variant-eq([@eq:hermite-interpolation-remainder])[$
    R(z)=omega(z) 1/(2 pi i) integral_gamma
    f(zeta)/(zeta-z) (dif zeta)/omega(zeta).
  $] <eq:hermite-interpolation-remainder-factorized>

  Интеграл
  $
    1/(2 pi i) integral_gamma f(zeta)/(zeta-z) (dif zeta)/omega(zeta)
    =1/(2 pi i) integral_gamma (f(zeta)/omega(zeta))/(zeta-z) dif zeta,
  $
  очевидно, есть интеграл типа Коши и, следовательно, представляет функцию,
  аналитическую внутри $gamma$. Так как
  $omega(z)=(z-z_1)^(alpha_1) dots (z-z_m)^(alpha_m)$, то
  $
    R(z)/(z-z_j)^(alpha_j)
    =(z-z_1)^(alpha_1) dots (z-z_(j-1))^(alpha_(j-1))
    (z-z_(j+1))^(alpha_(j+1)) dots
    \
    dots (z-z_m)^(alpha_m) 1/(2 pi i) integral_gamma
    (f(zeta)/omega(zeta))/(zeta-z) dif zeta
  $
  представляет функцию, аналитическую в окрестности точки $z_j$ (и даже во всей
  внутренности кривой $gamma$). Поэтому $z=z_j$ является для $R(z)$ нулем
  порядка, по крайней мере равного $alpha_j$, а может быть, и более высокого. Но
  это означает, что
  $ R(z_j)=0,dots,R^((alpha_j-1)) lr((z_j))=0, $
  т. е.
  $
    f(z_j)=Pi(z_j),dots,f^((alpha_j-1)) lr((z_j))
    =Pi^((alpha_j-1)) lr((z_j)) quad (j=1,2,dots,m).
  $
  Итак, мы нашли интерполяционный многочлен @eq:hermite-interpolating-polynomial
  степени не выше $n-1$, решающий поставленную задачу. В силу сделанного выше
  замечания, это единственный из многочленов степени ниже $n$, удовлетворяющий
  условиям задачи.

  Формула @eq:hermite-interpolating-polynomial, дающая интерполяционный
  многочлен, и формула @eq:hermite-interpolation-remainder, выражающая разность
  $f(z)-Pi(z)$, т. е. дающая #metadata(
    none,
  ) <def:interpolation-remainder>_остаточный член_ $R(z)$
  _интерполяционной формулы_
  $ f(z)=Pi(z)+R(z), $
  называются #metadata(none) <def:hermite-interpolation-formulas>_формулами
  Эрмита_.#idx("Остаточный член", target: <def:interpolation-remainder>)#idx(
    "Эрмита формула",
    target: <def:hermite-interpolation-formulas>,
  )

  #point() <pt:interpolation-examples>
  Иллюстрируем значение полученных формул на нескольких примерах.
  #properties(
    [
      Пусть сначала $m=1$, так что мы имеем лишь одну точку интерполяции $z_1$
      кратности $alpha_1=n$. Речь идет об отыскании многочлена
      $Pi(z)=t_(n-1) lr((z))$
      #source(453)
      степени не выше $n-1$, удовлетворяющего условиям:
      $
        t_(n-1) lr((z_1))=f(z_1),quad t'_(n-1) lr((z_1))=f'(z_1),dots,
        t_(n-1)^((n-1)) lr((z_1))=f^((n-1)) lr((z_1)).
      $
      В данном случае $omega(z)=omega_n lr((z))=(z-z_1)^n$ и формула
      @eq:hermite-interpolating-polynomial дает:
      $
        t_(n-1) lr((z))=1/(2 pi i) integral_gamma f(zeta)/(zeta-z_1)^n
        ((zeta-z_1)^n-(z-z_1)^n)/(zeta-z) dif zeta.
      $
      Но #eq[$
        1/(zeta-z_1)^n ((zeta-z_1)^n-(z-z_1)^n)/(zeta-z)
        \
        =1/(zeta-z_1)^n [(zeta-z_1)^(n-1)
          +(zeta-z_1)^(n-2)(z-z_1)+dots+(z-z_1)^(n-1)]
        \
        =1/(zeta-z_1)+1/(zeta-z_1)^2 (z-z_1)
        +dots+1/(zeta-z_1)^n (z-z_1)^(n-1).
      $] <eq:hermite-taylor-kernel>
      Получим: #eq[$
        t_(n-1) lr((z))=sum_(k=0)^(n-1) 1/(2 pi i)
        integral_gamma f(zeta)/(zeta-z_1)^(k+1) dif zeta (z-z_1)^k
        \
        =sum_(k=0)^(n-1) (f^((k)) lr((z_1)))/(k!) (z-z_1)^k.
      $] <eq:taylor-interpolating-polynomial>
      Мы получили #metadata(
        none,
      ) <def:taylor-interpolating-polynomial>_интерполяционный многочлен
      Тейлора_, т. е. частичную сумму ряда Тейлора (что, конечно, и следовало
      ожидать с самого начала).#idx(
        "Интерполяционный многочлен",
        "Тейлора",
        target: <def:taylor-interpolating-polynomial>,
      )#idx(
        "Тейлора интерполяционный многочлен",
        target: <def:taylor-interpolating-polynomial>,
      ) Остаточный член @eq:hermite-interpolation-remainder-factorized имеет вид
      #eq[$
        R(z)=R_n lr((z))=1/(2 pi i) integral_gamma f(zeta)/(zeta-z)
        (z-z_1)^n/(zeta-z_1)^n dif zeta.
      $] <eq:taylor-interpolation-remainder>

      Это — #metadata(none) <def:taylor-interpolation-remainder>_остаточный член
      формулы Тейлора_.#idx(
        "Остаточный член",
        target: <def:taylor-interpolation-remainder>,
      ) В силу интегральной теоремы для системы контуров его значение не
      изменится, если интегрирование вести по какой-либо окружности
      $C_rho:abs(zeta-z_1)=rho$, где $rho$ меньше, чем расстояние $Delta$ от
      точки $z_1$ до границы области $G$ (в которой $f(z)$ является
      аналитической). Поэтому для точек $z$, лежащих внутри $C_rho$, имеем:
      $
        R_n lr((z))=1/(2 pi i) integral_(C_rho) f(zeta)/(zeta-z)
        (z-z_1)^n/(zeta-z_1)^n dif zeta
      $
      и#metadata(none) <def:taylor-remainder-bound>
      $
        abs(R_n lr((z)))<=rho M(rho)/(rho-abs(z-z_1))
        (abs(z-z_1)/rho)^n.
      $
      Так как $abs(z-z_1)/rho<1$, то $R_n lr((z))$ стремится к нулю при $n->oo$,
      откуда снова получается тот факт, что последовательность многочленов
      Тейлора $lr({t_(n-1) lr((z))})$ сходится к $f(z)$ внутри круга
      $abs(z-z_1)<Delta$, принадлежащего области аналитичности функции
      $f(z)$. <prop:interpolation-taylor>
    ],
    [
      Пусть $m=n$, так что мы имеем $n$ точек интерполяции $z_1,z_2,dots,z_n$,
      каждая кратности $1$ $(alpha_1=dots=alpha_n=1)$. Речь идет об отыскании
      многочлена $Pi(z)=l_(n-1) lr((z))$ степени не выше $n-1$, удовлетворяющего
      условиям:
      $
        l_(n-1) lr((z_1))=f(z_1),quad l_(n-1) lr((z_2))=f(z_2),dots,
        l_(n-1) lr((z_n))=f(z_n).
      $
      В данном случае
      $ omega(z)=omega_n lr((z))=(z-z_1)dots(z-z_n), $
      #source(454)
      и формула @eq:hermite-interpolating-polynomial дает: #eq[$
        l_(n-1) lr((z))=1/(2 pi i) integral_gamma f(zeta)/(omega_n lr((zeta)))
        (omega_n lr((zeta))-omega_n lr((z)))/(zeta-z) dif zeta.
      $] <eq:lagrange-interpolation-contour>

      Для вычисления этого интеграла проще всего воспользоваться теоремой о
      вычетах. Подынтегральная функция $phi(zeta)$, рассматриваемая как функция
      от $zeta$, может иметь лишь простые полюсы в точках $z_k$ $(k=1,dots,n)$.
      Точка $zeta=z$ не является для нее особой, так как многочлен
      $omega_n lr((zeta))-omega_n lr((z))$ делится на $zeta-z$. Для вычетов
      $phi(zeta)$ в точках $z_k$ получаем выражения:
      $
        limits(op("Выч."))_(zeta=z_k) phi(zeta)
        =f(z_k)/(omega'_n lr((z_k))) (omega_n lr((z)))/(z-z_k),
      $
      где $(omega_n lr((z)))/(z-z_k)
      =(z-z_1)dots(z-z_(k-1))(z-z_(k+1))dots(z-z_n)$ — многочлен относительно
      $z$ степени $n-1$.

      Следовательно, #eq[$
        l_(n-1) lr((z))=sum_(k=1)^n
        limits(op("Выч."))_(zeta=z_k) phi(zeta)
        =sum_(k=1)^n f(z_k)/(omega'_n lr((z_k)))
        (omega_n lr((z)))/(z-z_k).
      $] <eq:lagrange-interpolating-polynomial>
      Мы получили #metadata(
        none,
      ) <def:lagrange-interpolating-polynomial>_интерполяционный многочлен
      Лагранжа_ степени не выше $n-1$.#idx(
        "Интерполяционный многочлен",
        "Лагранжа",
        target: <def:lagrange-interpolating-polynomial>,
      )#idx(
        "Лагранжа интерполяционный многочлен",
        target: <def:lagrange-interpolating-polynomial>,
      ) Остаточный член соответствующей интерполяционной формулы имеет вид:
      #eq[$
        R_n lr((z))=1/(2 pi i) integral_gamma f(zeta)/(zeta-z)
        (omega_n lr((z)))/(omega_n lr((zeta))) dif zeta.
      $] <eq:lagrange-interpolation-remainder>
      Его поведение при $n->oo$ зависит от соотношения между распределением
      точек интерполяции $lr({z_n})$ внутри области $G$ и характером функции
      $f(z)$. <prop:interpolation-lagrange>
    ],
    [
      Интерполяционный многочлен Лагранжа можно записать в иной форме.
      Преобразуем выражение
      $
        sigma_n=1/(omega_n lr((zeta)))
        (omega_n lr((zeta))-omega_n lr((z)))/(zeta-z),
      $
      представляющее, как мы знаем, многочлен степени $n-1$ относительно $z$.

      При $n=1$ имеем:
      $ sigma_1=1/(zeta-z_1) ((zeta-z_1)-(z-z_1))/(zeta-z)=1/(zeta-z_1). $
      Рассмотрим разность
      $
        delta_k=sigma_(k+1)-sigma_k
        =1/(omega_(k+1) lr((zeta)))
        (omega_(k+1) lr((zeta))-omega_(k+1) lr((z)))/(zeta-z)
        -1/(omega_k lr((zeta)))
        (omega_k lr((zeta))-omega_k lr((z)))/(zeta-z);
      $
      так как
      $
        omega_(k+1) lr((zeta))=(zeta-z_(k+1)) omega_k lr((zeta))
        quad "и" quad
        omega_(k+1) lr((z))=(z-z_(k+1)) omega_k lr((z)),
      $
      то разность эту можно представить в следующем виде:
      $
        delta_k=((zeta-z_(k+1)) omega_k lr((zeta))
        -(z-z_(k+1)) omega_k lr((z))
        -(zeta-z_(k+1)) omega_k lr((zeta))
        +(zeta-z_(k+1)) omega_k lr((z)))
        /(omega_(k+1) lr((zeta)) lr((zeta-z)))
        \
        =((zeta-z) omega_k lr((z)))
        /(omega_(k+1) lr((zeta)) lr((zeta-z)))
        =(omega_k lr((z)))/(omega_(k+1) lr((zeta))).
      $

      #source(455)
      Полагая $delta_0=sigma_1=1/(zeta-z_1)=1/(omega_1 lr((zeta)))$, составим
      сумму $sum_(k=0)^(n-1) delta_k lr((zeta))$, получим:
      $
        sum_(k=0)^(n-1) delta_k lr((zeta))
        =sigma_1+sum_(k=1)^(n-1) (sigma_(k+1)-sigma_k)
        =sigma_n=1/(omega_1 lr((zeta)))
        +(omega_1 lr((z)))/(omega_2 lr((zeta)))
        +dots+(omega_(n-1) lr((z)))/(omega_n lr((zeta))).
      $
      Итак, #eq[$
        1/(omega_n lr((zeta)))
        (omega_n lr((zeta))-omega_n lr((z)))/(zeta-z)
        =1/(omega_1 lr((zeta)))+(omega_1 lr((z)))/(omega_2 lr((zeta)))
        +dots+(omega_(n-1) lr((z)))/(omega_n lr((zeta))).
      $] <eq:newton-interpolation-kernel>

      Очевидно, тождество @eq:hermite-taylor-kernel получится отсюда, если
      положить $z_1=dots=z_n$.

      Из равенства @eq:newton-interpolation-kernel следует, что интерполяционный
      многочлен Лагранжа $l_(n-1) lr((z))$ можно представить в виде #eq[$
        l_(n-1) lr((z))=1/(2 pi i) integral_gamma
        f(zeta)/(omega_n lr((zeta)))
        (omega_n lr((zeta))-omega_n lr((z)))/(zeta-z) dif zeta
        \
        =sum_0^(n-1) 1/(2 pi i) integral_gamma
        f(zeta)/(omega_(k+1) lr((zeta))) dif zeta omega_k lr((z)).
      $] <eq:newton-interpolating-polynomial-contour>
      В этом виде он носит название #metadata(
        none,
      ) <def:newton-interpolating-polynomial>_интерполяционного многочлена
      Ньютона_.#idx(
        "Интерполяционный многочлен",
        "Ньютона",
        target: <def:newton-interpolating-polynomial>,
      )#idx(
        "Ньютона интерполяционный многочлен",
        target: <def:newton-interpolating-polynomial>,
      ) Преимущество формулы @eq:newton-interpolating-polynomial-contour перед
      формулой @eq:lagrange-interpolating-polynomial заключается в том, что при
      переходе от $l_(n-1) lr((z))$ к $l_n lr((z))$ по формуле
      @eq:newton-interpolating-polynomial-contour достаточно присоединить к
      $l_(n-1) lr((z))$ лишь одно слагаемое вида
      $1/(2 pi i) integral_gamma f(zeta)/(omega_(n+1) lr((zeta)))
      dif zeta dot omega_n lr((z))$, тогда как формула
      @eq:lagrange-interpolating-polynomial требует не только увеличения
      количества слагаемых на одно, но и замену каждого прежнего слагаемого
      новым, отличным от прежнего.

      В частности, в случае, когда последовательность $lr({l_(n-1) lr((z))})$
      сходится к функции $f(z)$, мы вместо соотношения
      $ f(z)=lim_(n->oo) l_(n-1) lr((z)) $
      можем пользоваться, с учетом формулы
      @eq:newton-interpolating-polynomial-contour, следующим рядом: #eq[$
        f(z)=sum_0^oo 1/(2 pi i) integral_gamma
        f(zeta)/(omega_(k+1) lr((zeta))) dif zeta omega_k lr((z)).
      $] <eq:newton-interpolation-series-contour>
      Этот ряд называется #metadata(
        none,
      ) <def:newton-interpolation-series>_интерполяционным рядом Ньютона_.#idx(
        "Интерполяционный ряд",
        "Ньютона",
        target: <def:newton-interpolation-series>,
      )#idx(
        "Ньютона интерполяционный ряд",
        target: <def:newton-interpolation-series>,
      )#idx(
        "Ряд",
        "Ньютона интерполяционный",
        target: <def:newton-interpolation-series>,
      ) Очевидно, при $z_1=z_2=dots=z_n=dots$ $omega_(k+1) lr((zeta))$ переходит
      в $(zeta-z_1)^(k+1)$, $omega_k lr((z))$ — в $(z-z_1)^k$, и мы получаем ряд
      Тейлора: #eq[$
        f(z)=sum_0^oo 1/(2 pi i) integral_gamma f(zeta)/(zeta-z_1)^(k+1)
        dif zeta (z-z_1)^k,
      $] <eq:newton-series-taylor-special-case>
      как частный случай ряда Ньютона.

      Заметим, впрочем, что условия сходимости ряда
      @eq:newton-series-taylor-special-case нами установлены, тогда как общий
      вопрос о сходимости ряда Ньютона, т. е. изучение условий, при которых
      остаточный член ряда Ньютона (он же — остаточный член ряда Лагранжа)
      @eq:lagrange-interpolation-remainder стремится к нулю, когда $n$ стремится
      к бесконечности, требует особого исследования, учитывающего и
      распределение
      #source(456)
      точек интерполирования и поведение функции $f(z)$. Этот вопрос разработан
      А. О. Гельфондом.

      Остановимся еще на рассмотрении коэффициентов ряда Ньютона:
      $
        1/(2 pi i) integral_gamma f(zeta)/(omega_(k+1) lr((zeta)))
        dif zeta quad (k=0,1,2,dots).
      $
      В частном случае ряда Тейлора коэффициенты эти выражаются через
      производные от $f(z)$, а именно, представляются в виде
      $(f^((k)) lr((z_1)))/(k!)$. В общем случае они выражаются через
      _разделенные разности_ функции $f(z)$, относящиеся к точкам $lr({z_n})$.

      Чтобы получить нужное выражение для этих коэффициентов, воспользуемся
      теоремой о вычетах. Найдем: #eq[$
        1/(2 pi i) integral_gamma f(zeta)/(omega_(k+1) lr((zeta))) dif zeta
        =sum_(j=1)^(k+1) limits(op("Выч."))_(zeta=z_j)
        f(zeta)/(omega_(k+1) lr((zeta)))
        =sum_(j=1)^(k+1) f(z_j)/(omega'_(k+1) lr((z_j))),
      $] <eq:newton-coefficients-simple-nodes>
      где
      $
        omega'_(k+1) lr((z_j))
        =(z_j-z_1)dots(z_j-z_(j-1))(z_j-z_(j+1))dots(z_j-z_(k+1)).
      $
      В частности, при $k=1$ получаем:
      $
        1/(2 pi i) integral_gamma f(zeta)/(omega_2 lr((zeta))) dif zeta
        =f(z_1)/(z_1-z_2)+f(z_2)/(z_2-z_1)
        =(f(z_2)-f(z_1))/(z_2-z_1).
      $
      Назовем это выражение #metadata(
        none,
      ) <def:divided-difference>первой _разделенной разностью функции_ $f(z)$
      относительно точек $z_1$ и $z_2$ и обозначим его через
      $Delta^((1)) lr([f;z_1,z_2])$.#idx(
        "Разделенная разность",
        target: <def:divided-difference>,
      )#idx("Разность разделенная", target: <def:divided-difference>) Вообще,
      если _разделенная разность_ порядка $k-1$ уже определена, то мы назовем
      разделенной разностью порядка $k$ функции $f(z)$ относительно точек
      $z_1,z_2,dots,z_(k+1)$ выражение
      $
        (Delta^((k-1)) lr([f;z_2,dots,z_(k+1)])
        -Delta^((k-1)) lr([f;z_1,dots,z_k]))/(z_(k+1)-z_1)
        =Delta^((k)) lr([f;z_1,dots,z_k,z_(k+1)]).
      $
      Допустим, что уже доказано, что
      $
        1/(2 pi i) integral_gamma f(zeta)/(omega_k lr((zeta))) dif zeta
        =Delta^((k-1)) lr([f(z);z_1,dots,z_k])
      $
      для любой системы точек $z_1,dots,z_k$; покажем, что тогда #eq[$
        1/(2 pi i) integral_gamma f(zeta)/(omega_(k+1) lr((zeta))) dif zeta
        =Delta^((k)) lr([f(z);z_1,dots,z_k,z_(k+1)]).
      $] <eq:divided-difference-contour>
      В самом деле, по сделанному допущению имеем:
      $
        1/(2 pi i) integral_gamma
        f(zeta)/((zeta-z_1)dots(zeta-z_k)) dif zeta
        =Delta^((k-1)) lr([f(z);z_1,dots,z_k]),
      $
      $
        1/(2 pi i) integral_gamma
        f(zeta)/((zeta-z_2)dots(zeta-z_(k+1))) dif zeta
        =Delta^((k-1)) lr([f(z);z_2,dots,z_(k+1)]).
      $

      #source(457)
      Следовательно,
      $
        Delta^((k)) lr([f(z);z_1,dots,z_(k+1)])
        \
        =(Delta^((k-1)) lr([f(z);z_2,dots,z_(k+1)])
        -Delta^((k-1)) lr([f(z);z_1,dots,z_k]))/(z_(k+1)-z_1)
        \
        =1/(z_(k+1)-z_1) 1/(2 pi i) integral_gamma f(zeta)
        [1/((zeta-z_2)dots(zeta-z_(k+1)))
          -1/((zeta-z_1)dots(zeta-z_k))] dif zeta
        \
        =1/(z_(k+1)-z_1) 1/(2 pi i) integral_gamma f(zeta)
        ((zeta-z_1)-(zeta-z_(k+1)))
        /((zeta-z_1)dots(zeta-z_(k+1))) dif zeta
        =1/(2 pi i) integral_gamma f(zeta)/(omega_(k+1) lr((zeta))) dif zeta,
      $
      что и требовалось доказать. #metadata(
        none,
      ) <def:divided-difference-order-zero>Полагая еще
      $
        1/(2 pi i) integral_gamma (f(zeta) dif zeta)/(omega_1 lr((zeta)))
        =1/(2 pi i) integral_gamma f(zeta)/(zeta-z_1) dif zeta
        =f(z_1)=Delta^((0)) lr([f;z_1]),
      $
      представим интерполяционный многочлен Ньютона
      @eq:newton-interpolating-polynomial-contour в виде
      $
        l_(n-1) lr((z))=sum_(k=0)^(n-1)
        Delta^k lr([f(z);z_1,dots,z_(k+1)]) omega_k lr((z)).
      $

      В соответствии с этим интерполяционный ряд Ньютона принимает следующий
      вид:
      $ sum_(k=0)^oo Delta^k lr([f(z);z_1,dots,z_(k+1)]) omega_k lr((z)). $
      <prop:interpolation-newton>
    ],
    [
      В заключение рассмотрим интерполяционную задачу, в которой даны $m$
      различных точек: $z_1,dots,z_m$, с одинаковыми кратностями
      $alpha_1=dots=alpha_m=p$; число $p$ мы будем затем неограниченно
      увеличивать, не меняя самих точек интерполяции. Речь идет об отыскании
      многочлена $j_(m p-1) lr((z))$ степени не выше $m p-1$, удовлетворяющего
      условиям:
      $
        j_(m p-1) lr((z_k))=f(z_k),quad
        j'_(m p-1) lr((z_k))=f'(z_k),dots,
        j_(m p-1)^((p-1)) lr((z_k))=f^((p-1)) lr((z_k))
      $
      $(k=1,2,dots,m)$. Полагая
      $ (z-z_1)dots(z-z_m)=q(z), $
      имеем:
      $ omega_(m p) lr((z))=(z-z_1)^p dots(z-z_m)^p=[q(z)]^p, $
      и, следовательно,
      $
        j_(m p-1) lr((z))=1/(2 pi i) integral_gamma f(zeta)/[q(zeta)]^p
        ([q(zeta)]^p-[q(z)]^p)/(zeta-z) dif zeta.
      $

      #source(458)
      Преобразуем выражение $1/[q(zeta)]^p ([q(zeta)]^p-[q(z)]^p)/(zeta-z)$
      следующим образом:
      $
        1/[q(zeta)]^p ([q(zeta)]^p-[q(z)]^p)/(zeta-z)
        \
        =1/[q(zeta)]^p (q(zeta)-q(z))/(zeta-z)
        {[q(zeta)]^(p-1)+[q(zeta)]^(p-2) q(z)+dots+[q(z)]^(p-1)}
        \
        =(q(zeta)-q(z))/(zeta-z)
        {1/q(zeta)+q(z)/[q(zeta)]^2+dots+[q(z)]^(p-1)/[q(zeta)]^p}.
      $
      Тогда будем иметь: #eq[$
        j_(m p-1) lr((z))=sum_(n=0)^(p-1) 1/(2 pi i)
        integral_gamma f(zeta)/[q(zeta)]^(n+1)
        (q(zeta)-q(z))/(zeta-z) dif zeta [q(z)]^n.
      $] <eq:jacobi-interpolation-contour>
      Для дальнейших преобразований воспользуемся формулой
      @eq:newton-interpolation-kernel, в которой заменим $omega_n lr((z))$ на
      $q(z)$. Имеем:
      $
        1/[q(zeta)]^(n+1) (q(zeta)-q(z))/(zeta-z)
        =1/[q(zeta)]^n {1/q(zeta) (q(zeta)-q(z))/(zeta-z)}
        \
        =1/[q(zeta)]^n [1/(zeta-z_1)
          +(z-z_1)/((zeta-z_1)(zeta-z_2))
          +dots+((z-z_1)dots(z-z_(m-1)))
          /((zeta-z_1)(zeta-z_2)dots(zeta-z_m))],
      $
      откуда
      $
        1/(2 pi i) integral_gamma f(zeta)/[q(zeta)]^(n+1)
        (q(zeta)-q(z))/(zeta-z) dif zeta
        \
        =sum_(j=0)^(m-1) 1/(2 pi i) integral_gamma f(zeta)/[q(zeta)]^n
        (dif zeta)/((zeta-z_1)dots(zeta-z_(j+1)))
        (z-z_1)dots(z-z_j).
      $
      Мы получили многочлен $Q_n lr((z))$ степени не выше $m-1$, коэффициенты
      которого суть интегралы вида
      $1/(2 pi i) integral_gamma f(zeta)/[q(zeta)]^n
      (dif zeta)/((zeta-z_1)dots(zeta-z_(j+1)))$. Их выражения через значения
      функции $f(z)$ и ее производных в точках $z_1,dots,z_m$ можно было бы
      получить при помощи теоремы о вычетах.

      Возвращаясь к формуле @eq:jacobi-interpolation-contour, находим:
      $ j_(m p-1) lr((z))=sum_(n=0)^(p-1) Q_n lr((z)) [q(z)]^n; $
      этот многочлен называется #metadata(
        none,
      ) <def:jacobi-interpolating-polynomial>_интерполяционным многочленом
      Якоби_.#idx(
        "Интерполяционный многочлен",
        "Якоби",
        target: <def:jacobi-interpolating-polynomial>,
      )#idx(
        "Якоби интерполяционный многочлен",
        target: <def:jacobi-interpolating-polynomial>,
      )

      Рассмотрим остаточный член соответствующей интерполяционной формулы
      $
        R_(m p) lr((z))=1/(2 pi i) integral_gamma f(zeta)/(zeta-z)
        [q(z)]^p/[q(zeta)]^p dif zeta.
      $
      #metadata(none) <def:jacobi-contour-system>Для его оценки заметим, что на
      кривую $gamma$ наложены с самого начала только следующие ограничения:
      $gamma$ вместе со своей внутренностью
      #source(459)
      принадлежит области $G$, в которой функция $f(z)$ является аналитической,
      и содержит внутри все точки $z_1,dots,z_m$. Выберем в качестве кривой
      $gamma$ лемнискату $Lambda_rho$ с фокусами в точках $z_1,dots,z_m$:
      $ abs(q(z))=rho^m $
      (см. гл.~@ch:integrals-power-series, п.~@pt:maximum-modulus-principle). Мы
      знаем, что она содержит внутри себя точки $z_1,dots,z_m$, каково бы ни
      было $rho>0$. Пусть, далее, $rho_0>0$ — такое значение радиуса, что $f(z)$
      является однозначной и аналитической внутри $Lambda_(rho_0)$, и пусть
      $rho>0$ — произвольное положительное число, меньшее $rho_0$. Тогда для
      любого $rho'$, удовлетворяющего неравенствам $rho<rho'<rho_0$ и выбранного
      так, чтобы $q'(zeta)!=0$ на $Lambda_(rho')$ (это возможно, так как
      критических уровней конечное число), лемниската $Lambda_(rho')$
      принадлежит внутренности $Lambda_(rho_0)$ и содержит замкнутое множество
      $overline(G)_rho$, состоящее из внутренности лемнискаты $Lambda_rho$ и
      самой этой лемнискаты. Так как во всех точках $z in overline(G)_rho$
      выполняется неравенство
      $ abs(q(z))<=rho^m, $
      а в точках $zeta in Lambda_(rho')$ имеет место равенство
      $ abs(q(zeta))=rho'^m, $
      то, принимая в качестве $gamma$ лемнискату $Lambda_(rho')$ (при нескольких
      компонентах интеграл понимается как сумма интегралов по всем положительно
      ориентированным граничным кривым) и обозначая через $M(rho')$ максимум
      модуля $f(z)$ в ее точках, будем иметь:#metadata(
        none,
      ) <def:jacobi-interpolation-remainder-bound>
      $
        abs(R_(m p) lr((z)))<=1/(2 pi) M(rho')/delta(rho, rho')
        (rho/rho')^(m p) op("дл.") Lambda_(rho')
        quad (z in overline(G)_rho),
      $
      где через $delta(rho, rho')$ обозначено расстояние между $Lambda_rho$ и
      $Lambda_(rho')$.

      Из этой формулы видно, что $R_(m p) lr((z))$ при неограниченно
      возрастающем $p$ равномерно стремится к нулю на множестве
      $overline(G)_rho$. Так как
      $ R_(m p) lr((z))=f(z)-j_(m p-1) lr((z)) $
      и $rho$ можно выбрать сколь угодно близким к $rho_0$, то отсюда вытекает,
      что последовательность полиномов $j_(m p-1) lr((z))$ равномерно сходится
      внутри $Lambda_(rho_0)$ к функции $f(z)$:
      $
        f(z)=lim_(p->oo) j_(m p-1) lr((z))
        =lim_(p->oo) sum_(n=0)^(p-1) Q_n lr((z)) [q(z)]^n,
      $
      т. е. имеет место разложение в ряд
      #eq[$ f(z)=sum_0^oo Q_n lr((z)) [q(z)]^n. $]
      <eq:jacobi-interpolation-series>
      Ряд этот называется #metadata(
        none,
      ) <def:jacobi-interpolation-series>_интерполяционным рядом Якоби_.#idx(
        "Интерполяционный ряд",
        "Якоби",
        target: <def:jacobi-interpolation-series>,
      )#idx(
        "Якоби интерполяционный ряд",
        target: <def:jacobi-interpolation-series>,
      )#idx(
        "Ряд",
        "Якоби интерполяционный",
        target: <def:jacobi-interpolation-series>,
      )

      Итак, _всякая функция $f(z)$, аналитическая внутри лемнискаты
      $Lambda_(rho_0)$, с фокусами $z_1,dots,z_m$, может быть разложена в ряд
      Якоби @eq:jacobi-interpolation-series, равномерно сходящийся внутри
      $Lambda_(rho_0)$_.

      Напомним, что $q(z)=(z-z_1)dots(z-z_m)$ и
      $
        Q_n lr((z))=sum_(j=0)^(m-1) 1/(2 pi i) integral_gamma
        f(zeta)/[q(zeta)]^n (dif zeta)/((zeta-z_1)dots(zeta-z_(j+1)))
        (z-z_1)dots(z-z_j).
      $

      #source(460)
      В частном случае, когда $m=1$, имеем $q(z)=z-z_1$,
      $
        Q_n lr((z))=1/(2 pi i) integral_gamma
        f(zeta)/(zeta-z_1)^(n+1) dif zeta
        =(f^((n)) lr((z_1)))/(n!),
      $
      и ряд Якоби превращается в ряд Тейлора, а лемниската $Lambda_(rho_0)$ — в
      окружность $abs(z-z_1)=rho_0$.

      В случае, когда $m=2$, имеем: $q(z)=(z-z_1)(z-z_2)$ и
      $
        Q_n lr((z))=1/(2 pi i) integral_gamma
        f(zeta)/((zeta-z_1)^(n+1)(zeta-z_2)^n) dif zeta
        \
        +1/(2 pi i) integral_gamma
        f(zeta)/((zeta-z_1)^(n+1)(zeta-z_2)^(n+1)) dif zeta (z-z_1).
      $
      Применяя к каждому из интегралов теорему о вычетах и производя затем
      простые преобразования, получим:
      $ Q_0 lr((z))=(f(z_1)(z-z_2)-f(z_2)(z-z_1))/(z_1-z_2), $
      и при $n>=1$
      $
        Q_n lr((z))=1/(n!(z_1-z_2)^(n+1)) sum_(k=0)^n
        lambda_k/(z_1-z_2)^k
        [(-1)^k f^((n-k)) lr((z_1)) (z-(k z_1+n z_2)/(k+n))
          \
          -(-1)^n f^((n-k)) lr((z_2)) (z-(n z_1+k z_2)/(k+n))],
      $
      где
      $
        lambda_0=1,quad lambda_1=n(n+1),quad
        lambda_k=(n(n^2-1)dots[n^2-(k-1)^2](n+k))/(k!) quad (k>=2).
      $
      #metadata(none) <def:jacobi-symmetric-expansion>В частности, полагая
      $z_1=-z_2=a$, найдем, что каждая функция $f(z)$, аналитическая внутри
      лемнискаты $Lambda_(rho_0)$:
      $ abs((z-a)(z+a))=rho_0^2, $
      разлагается в ряд:
      $
        f(z)=(f(a)(z+a)-f(-a)(z-a))/(2a)
        \
        +sum_(n=1)^oo (z^2-a^2)^n/(n!(2a)^(n+1)) sum_(k=0)^n
        lambda_k/(2a)^k
        [(-1)^k f^((n-k)) lr((a)) (z+(n-k)/(n+k) a)
          \
          -(-1)^n f^((n-k)) lr((-a)) (z-(n-k)/(n+k) a)].
      $
      Полезно заметить, что пока внутренность лемнискаты $Lambda_(rho_0)$ не
      является связной (что будет при всех достаточно малых значениях $rho_0$),
      аналитическая функция $f(z)$ может определяться в каждой компоненте
      открытого множества, границей которого служит $Lambda_(rho_0)$, независимо
      от того, как она определяется в других компонентах того же множества. Так,
      например, в случае $m=2$ и $rho_0<=abs(a)$ лемниската
      $abs((z-a)(z+a))=rho_0^2$ ограничивает две односвязные области, не имеющие
      общих точек. Положим $f(z)$ равной постоянной $A$ в той из этих областей,
      которая содержит точку $-a$, и
      #source(461)
      равной постоянной $B$ в той области, которая содержит точку $a$. Тогда
      получим ряд:
      $
        (B+A)/2+z (B-A)/(2a)+(B-A)/(2a) sum_1^oo (-1)^n
        ((n+1)dots(2n-1)2n)/(n!) (z(z^2-a^2)^n)/(2^(2n) a^(2n)),
      $
      сходящийся в одной из двух областей, ограниченных лемнискатой, к
      постоянной $A$, а в другой — к $B$.

      Впрочем, последний результат легко получить и с помощью биномиального
      разложения. А именно, заменяя в формуле
      $
        (1+t)^(-1/2)=1+sum_1^oo (-1)^n
        ((n+1)dots(2n-1)2n)/(n!2^(2n)) t^n, quad abs(t)<1
      $
      $t$ на $(z^2-a^2)/a^2$, будем иметь внутри лемнискаты
      $abs(z^2-a^2)=abs(a)^2$:
      $ abs(t)=(abs(z^2-a^2))/(abs(a)^2)<1. $
      Следовательно,
      $
        plus.minus a/z=1+sum_1^oo (-1)^n ((n+1)dots(2n-1)2n)/(n!2^(2n))
        (z^2-a^2)^n/a^(2n),
      $
      где знак в левой части следует выбирать так, чтобы при $z=plus.minus a$
      получать единицу; поэтому в области, ограниченной лемнискатой и содержащей
      точку $-a$ (одна половина «восьмерки»), следует брать знак минус, а в
      области, ограниченной лемнискатой и содержащей точку $a$ (другая половина
      «восьмерки»), — знак плюс. Из найденного разложения следует, что
      $
        plus.minus (B-A)/2=(B-A)/(2a) z+(B-A)/(2a)
        sum_1^oo (-1)^n ((n+1)dots(2n-1)2n)/(n!2^(2n))
        (z(z^2-a^2)^n)/a^(2n),
      $
      откуда, наконец, и вытекает указанный выше результат.
      <prop:interpolation-jacobi>
    ],
  )

  Для изучения теории интерполяции мы отсылаем читателя к книгам:
  #bib-description("Goncharov1954") (гл.~I. Точечное интерполирование) и
  #bib-description("Gelfond1966").
]
