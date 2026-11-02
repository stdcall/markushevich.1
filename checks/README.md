# Mathematical checks

`lean/Stereographic.lean` proves the real polynomial calculation in
§ 5.4, attached to the passage `pt:stereographic-conformality`.
Write `(a,b,c)=(ξ₀,η₀,ζ₀)` for the point of the unit sphere,
`(u,v,w)=(ξ′,η′,ζ′)` and `(p,q,r)=(ξ′₁,η′₁,ζ′₁)` for its two
tangent vectors. The hypotheses are the sphere equation and the two
orthogonality equations expressing tangency.

The first theorem gives an explicit polynomial certificate. The second
uses the three hypotheses to show that the scalar product of the
projected derivative numerators is `(1-c)²` times the original scalar
product. The third specializes both tangent vectors to the same vector.
The certificate is proved by `ring`; the other theorems use that identity
and their stated hypotheses.

This formalization covers the numerator algebra. It does not formalize
differentiation, division by `(1-c)²`, square roots, normalized angles or
the full conformality theorem. The latter steps require the point to
avoid the north pole (`c≠1`) and the tangent speeds to be nonzero.

`lean-proofs.json` pins Lean 4.35.0-rc2 and mathlib commit
`a218e50f981942cba4fd060faff7cae680805062`. It lists all three expected
declarations and the two imported modules. Each theorem has a
`#print axioms` command; the audit rejects warnings, omitted declarations,
`sorryAx` and axioms beyond `propext`, `Classical.choice`, `Quot.sound`.
When the mathematics of the attached passage changes, review the mapping
and proof together.

Use an existing checkout of the pinned mathlib with the required compiled
modules. From that checkout, compile the saved file directly:

```sh
lake env lean "$BOOK_PROJECT/checks/lean/Stereographic.lean"
```

From the book's root directory, the check command also
checks the pins, passage label, required modules, exact declaration list
and permitted axioms:

```sh
python scripts/check_lean.py --mathlib "$LEAN_MATHLIB"
```

The check uses the installed environment and does not install or build
dependencies.
