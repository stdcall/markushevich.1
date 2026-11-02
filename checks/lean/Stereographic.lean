import Mathlib.Basic.Real.Basic
import Mathlib.Tactic.Ring

/-!
# The polynomial calculation in § 5.4

Passage: `pt:stereographic-conformality`, the calculation of the scalar
product of two projected tangent vectors.

Notation: `(a, b, c)` is the book's `(ξ₀, η₀, ζ₀)`; `(u, v, w)` is
`(ξ′, η′, ζ′)` and `(p, q, r)` is `(ξ′₁, η′₁, ζ′₁)`, evaluated at the
common point. The unit-sphere equation gives `sphere`; differentiating
that equation along each curve gives `tangentX` and `tangentY`.
The components of the two projected derivatives have numerators
`((1-c)*u+a*w, (1-c)*v+b*w)` and
`((1-c)*p+a*r, (1-c)*q+b*r)`, respectively, and denominator `(1-c)^2`.

Only the real polynomial numerator identity and its norm-square
specialization are proved here. Differentiation, division by `(1-c)^2`,
square roots, angles, and the full conformality statement are not
formalized. The book's `c ≠ 1` and nonzero tangent-speed assumptions are
needed for the final normalized-angle calculation, but are not needed
for these polynomial identities. No conclusion is assumed as a hypothesis.
-/

set_option autoImplicit false

namespace Markushevich.Stereographic

/-- The difference is a polynomial combination of the three constraints. -/
theorem numerator_certificate (a b c u v w p q r : ℝ) :
    ((1 - c) * u + a * w) * ((1 - c) * p + a * r) +
      ((1 - c) * v + b * w) * ((1 - c) * q + b * r) -
      (1 - c) ^ 2 * (u * p + v * q + w * r) =
    w * r * (a ^ 2 + b ^ 2 + c ^ 2 - 1) +
      (1 - c) * r * (a * u + b * v + c * w) +
      (1 - c) * w * (a * p + b * q + c * r) := by
  ring

/-- The scalar-product numerator for two tangent vectors on the unit sphere. -/
theorem numerator_inner_product (a b c u v w p q r : ℝ)
    (sphere : a ^ 2 + b ^ 2 + c ^ 2 = 1)
    (tangentX : a * u + b * v + c * w = 0)
    (tangentY : a * p + b * q + c * r = 0) :
    ((1 - c) * u + a * w) * ((1 - c) * p + a * r) +
      ((1 - c) * v + b * w) * ((1 - c) * q + b * r) =
    (1 - c) ^ 2 * (u * p + v * q + w * r) := by
  apply sub_eq_zero.mp
  rw [numerator_certificate, sphere, tangentX, tangentY]
  ring

/-- The norm-square numerator is the specialization to the same vector. -/
theorem numerator_norm_sq (a b c u v w : ℝ)
    (sphere : a ^ 2 + b ^ 2 + c ^ 2 = 1)
    (tangent : a * u + b * v + c * w = 0) :
    ((1 - c) * u + a * w) ^ 2 +
      ((1 - c) * v + b * w) ^ 2 =
    (1 - c) ^ 2 * (u ^ 2 + v ^ 2 + w ^ 2) := by
  simpa only [pow_two] using
    numerator_inner_product a b c u v w u v w sphere tangent tangent

end Markushevich.Stereographic

#print axioms Markushevich.Stereographic.numerator_certificate
#print axioms Markushevich.Stereographic.numerator_inner_product
#print axioms Markushevich.Stereographic.numerator_norm_sq
