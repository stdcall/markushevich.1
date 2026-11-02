#set document(
  title: "Теория аналитических функций. Том I. Начала теории",
  author: "А. И. Маркушевич",
  date: none,
)
#import "frontmatter/cover.typ": cover
#import "frontmatter/title.typ": title-page
#import "book-style.typ": book-style
#cover(volume: 1)
#counter(page).update(1)
#title-page()
#show: book-style
#include "external-targets.typ"
#counter(page).update(3)
#heading(level: 1, numbering: none, outlined: false)[Оглавление]
#outline(title: none, depth: 2)
#pagebreak()
#include "00-prefaces.typ"
#include "01-01-subject.typ"
#include "01-02-complex-numbers.typ"
#include "01-03a-sets-limits.typ"
#include "01-03b-series.typ"
#include "01-03c-set-function-limits.typ"
#include "01-03d-continuity.typ"
#include "01-04a-connected-open.typ"
#include "01-04b-boundaries-compactness.typ"
#include "01-05a-infinity-stereographic.typ"
#include "01-05b-conformal-sphere.typ"
#include "02-01-derivative.typ"
#include "02-02-conformal-geometry.typ"
#include "02-03a-polynomials-exponential.typ"
#include "02-03b-trigonometric-functions.typ"
#include "02-04a-rational-mobius.typ"
#include "02-04b-three-points-symmetry.typ"
#include "02-04c-lobachevsky.typ"
#include "02-04d-joukowski-trigonometric.typ"
#include "02-05a-inverse-radical-surfaces.typ"
#include "02-05b-logarithm-general-powers.typ"
#include "02-05c-inverse-trigonometric.typ"
#include "03-01-rectifiable-curves-integrals.typ"
#include "03-02a-cauchy-integral-theorem.typ"
#include "03-02b-cauchy-consequences.typ"
#include "03-02c-primitives-logarithmic-integral.typ"
#include "03-03a-cauchy-integral-derivatives.typ"
#include "03-03b-boundary-values-general-formula.typ"
#include "03-04a-uniform-function-series.typ"
#include "03-04b-function-families-infinite-products.typ"
#include "03-05a-power-series-radius-uniqueness.typ"
#include "03-05b-fourier-cauchy-expansions.typ"
#include "03-06a-identity-and-a-points.typ"
#include "03-06b-maximum-modulus-principle.typ"
#include "03-06c-singularities-of-analytic-elements.typ"
#include "03-07a-power-series-expansion-methods.typ"
#include "03-07b-division-of-power-series.typ"
#include "03-07c-boundary-convergence-of-power-series.typ"
#include "04-01-compactness-principle.typ"
#include "04-02a-laurent-series.typ"
#include "04-02b-dirichlet-series.typ"
#include "04-02c-runge-theorem.typ"
#include "04-03a-isolated-singularities.typ"
#include "04-03b-singularities-at-infinity.typ"
#include "04-03c-residues-argument-principle.typ"
#include "04-04a-meromorphic-series.typ"
#include "04-04b-interpolation.typ"
#include "04-05a-lagrange-inversion.typ"
#include "04-05b-implicit-functions.typ"
#include "80-bibliography.typ"
#include "90-index.typ"
