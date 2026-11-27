# RFC: Conventions

Date: 26 Nov 2026. Status: draft for Phase 0, conventions locked
unless a stated trigger fires. No Lean code in this file.

Rule: every file header in Phases 1 to 5 repeats these conventions.
A wrong sign choice early forces a rewrite of every later file,
so the choices below are locked in writing now.

## Signature

Signature is (-, +, +, +). One timelike direction, three spacelike
directions. A tangent vector v is timelike when g(v, v) < 0,
null when g(v, v) = 0, spacelike when g(v, v) > 0.

Why: it is the convention of Wald's General Relativity, of the
Hilbert6 Spacetime definition (`LorentzianAt` uses
diag(-1, 1, 1, 1)), and of the Kerr literature the stability
statement will cite. The general API is parameterised by (p, q),
so the signature choice is a specialisation, not a restriction.

## Riemann and Ricci signs

Locked choice:

- Riemann: R(X, Y)Z = ∇_X ∇_Y Z - ∇_Y ∇_X Z - ∇_[X,Y] Z.
- Ricci: Ric(X, Y) = trace of the map Z ↦ R(Z, X)Y.
- Scalar: R = trace of Ric, that is, the trace of the Ricci
  operator.
- Einstein: G = Ric - (1/2) R g.

Why: with this choice the round sphere has positive Ricci
curvature, which matches the geometric literature and the
Hamilton three-manifold project. It is also the choice under
which the Einstein equations read G + Λg = 8πT with the usual
signs for positive energy density.

Trigger: if Mathlib's PR 36128 Levi-Civita API, when it lands,
defines Riemann curvature with the opposite sign, Phase 1 must
follow Mathlib, not this RFC. A project-local sign that fights
Mathlib's is worse than changing the lock. If that trigger fires,
this RFC is revised and every file header is updated in the same
pass.

## Tensor contraction

- Tensors are sections of tensor bundles built from the tangent
  bundle and its dual, not bare multilinear maps on coordinates.
- Contraction is the trace of an endomorphism, stated
  index-free wherever possible. Index notation is used only in
  coordinate computations, and every indexed computation states
  its chart and its index positions.
- Raising and lowering use the musical isomorphisms (flat and
  sharp) of the metric, never a bare matrix inverse.
- The metric compatibility condition is ∇g = 0, stated as the
  Leibniz rule in RFC_PseudoRiemannian.md.

Why: index-free statements survive a change of chart, and the
trace formulation makes the Ricci definition a one-line
consequence of the Riemann definition. The Hamilton project and
Hilbert6 both use this shape.

## Sobolev design

Summary only. The full design is in docs/RFC_Sobolev.md.

- Bessel potential spaces H^{s,p} on flat space first.
- Then W^{k,p} on domains through weak derivatives.
- Then Sobolev spaces of tensor fields on manifolds.
- Weighted spaces H^s_delta last.
- Embeddings, Poincare, and trace theorems are proved as the
  spaces land, not deferred to a separate phase.

## Naming

- `PseudoRiemannianMetric` for the general metric with
  signature (p, q).
- `LorentzianMetric` for the signature (3, 1) case.
- Riemannian is the signature (n, 0) case of the same structure.
- `flatEquiv` and `sharp` for the musical isomorphisms.
- `leviCivita` for the Levi-Civita connection of a metric.
- `riemannCurvature`, `ricciTensor`, `scalarCurvature`,
  `einsteinTensor` for the curvature API, pending Mathlib
  reviewer input on exact names.

## Open questions

- Exact Lean names for the curvature API. The names above are
  proposals. Mathlib reviewers decide the final names.
- Whether the signature (p, q) is a field of the metric structure
  or a separate predicate. See RFC_PseudoRiemannian.md.
- Whether the Riemann sign in PR 36128, when it lands, matches
  the lock above. This is the one trigger that revises this RFC.

## What would change these decisions

- A Mathlib reviewer decision overrides any convention here.
  Record the override in this file with the date and the
  reviewer.
- New evidence that the Kerr stability literature uses the
  opposite Ricci sign in the papers Phase 5 will cite would
  reopen the sign lock, with the cost stated (a rewrite of
  every curvature file).
- Nothing else changes the signature. (-, +, +, +) is the
  standard for general relativity, and the general API carries
  (p, q) anyway.
