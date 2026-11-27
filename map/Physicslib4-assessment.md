# Physicslib4 pseudo-Riemannian assessment

Date: 26 Nov 2026. Baseline: Lean 4.23.0, Mathlib v4.23.0.
Sources read in full: the Spacetime docs page, and the three source files
listed below, fetched from the repository on 26 Nov 2026.

Note on names: the project was called Physicslib4 and its docs site is
still physicslib.github.io/physicslib4. The repository has been renamed
to hilbert6/hilbert6, and the current source uses namespace `Hilbert6`,
not `Physicslib4`. The docs page quoted here still shows the old
`Physicslib4` names. All file paths below are the current repository
paths. Repository: https://github.com/hilbert6/hilbert6, branch main.
The project pins Lean 4.35.0 and a Mathlib revision far newer than
v4.23.0 (lake-manifest.json, 26 Nov 2026).

## Files read

- Hilbert6/Spacetime/Basic.lean, 177 lines.
  Source: https://github.com/hilbert6/hilbert6/blob/main/Hilbert6/Spacetime/Basic.lean
- Hilbert6/Geometry/PseudoRiemannian/Basic.lean, 167 lines.
  Source: https://github.com/hilbert6/hilbert6/blob/main/Hilbert6/Geometry/PseudoRiemannian/Basic.lean
- Hilbert6/Geometry/PseudoRiemannian/LeviCivita.lean, 404 lines.
  Source: https://github.com/hilbert6/hilbert6/blob/main/Hilbert6/Geometry/PseudoRiemannian/LeviCivita.lean
- Docs: https://physicslib.github.io/physicslib4/docs/Physicslib4/Spacetime/Basic.html
  (crawled 23 Nov 2026).

## What Spacetime carries

`Hilbert6.Spacetime` (Spacetime/Basic.lean, structure at lines 125 to 177)
is a plain structure, not a typeclass. Its fields:

- `Carrier : Type*`, the points of the manifold.
- Topology, Hausdorff (`T2Space`), connected (`ConnectedSpace`) as
  instance fields.
- `ChartedSpace SpacetimeModel Carrier` with model space
  `SpacetimeModel`, an abbreviation for `EuclideanSpace ℝ (Fin 4)`.
- `model : ModelWithCorners ℝ SpacetimeModel SpacetimeModel`, usually
  the self model.
- `IsManifold model ∞ Carrier`, so the manifold is smooth.
- `model.Boundaryless`, so the manifold has no boundary.
- `tangent_findim`: every tangent space is finite dimensional.
- `val`: at each point, a continuous bilinear form
  `TangentSpace model x →L[ℝ] TangentSpace model x →L[ℝ] ℝ`.
- `symm`: the form is symmetric at every point.
- `nondegenerate`: the form is non-degenerate at every point.
- `lorentzian`: at every point, `LorentzianAt` holds.
- `contMDiff`: the metric is a smooth section of the bundle of
  continuous bilinear forms on the tangent bundle, in the same shape
  as `Bundle.ContMDiffRiemannianMetric.contMDiff`.

`Hilbert6.LorentzianAt` (lines 90 to 95) is the pointwise Lorentzian
condition: there is a basis of the tangent space whose Gram matrix is
`diag(-1, 1, 1, 1)`, given by `lorentzSignature` (lines 82 to 84).
Signature is (-, +, +, +). A vector is timelike when `g_x(v, v) < 0`.

What Spacetime does not carry: no time orientation, no causal
structure, no topology beyond the manifold topology. Those are
separate data, in separate files: `Spacetime.TimeOrientation`,
`Spacetime.alexandrovTopology`, `Spacetime.LorentzianSpacetime`,
and the files Causality.lean, CausalStructure.lean,
LorentzianSpacetime.lean, Minkowski.lean in Hilbert6/Spacetime/.

## What the pseudo-Riemannian API carries

`Hilbert6.Geometry.PseudoRiemannianMetric`
(PseudoRiemannian/Basic.lean, structure at lines 83 to 99) is a
smooth family of symmetric, non-degenerate continuous bilinear forms
on the tangent spaces of a manifold modelled on `(E, H)` with model
`I`. Its fields are `val`, `symm`, `nondegenerate`, `contMDiff`.
It imposes no signature at all. Riemannian and Lorentzian metrics
are both examples. `Spacetime.toPseudoRiemannianMetric`
(lines 156 to 167) builds one from a spacetime by forgetting the
Lorentzian condition.

Musical isomorphisms (same file):

- `PseudoRiemannianMetric.bijective_val`: at each point,
  `v ↦ g_x(v, ·)` is bijective, hence an isomorphism from the
  tangent space onto its dual. The proof uses non-degeneracy for
  injectivity and finite dimension for surjectivity.
- `PseudoRiemannianMetric.flatEquiv`: the flat map as a continuous
  linear equivalence `T_xM ≃L[ℝ] (T_xM →L[ℝ] ℝ)`.
- `PseudoRiemannianMetric.contMDiff_flatEquiv_symm`: the inverse
  flat map `x ↦ ♭_x⁻¹` is a smooth section of `Hom(T*M, TM)`.

Levi-Civita (PseudoRiemannian/LeviCivita.lean, 404 lines):

- `CovariantDerivative.IsMetricCompatibleWith`: the Leibniz rule
  `X g(σ, τ) = g(∇_X σ, τ) + g(σ, ∇_X τ)`, with `g` in place of
  the inner product in Mathlib's Riemannian version.
- `CovariantDerivative.IsLeviCivitaFor`: torsion-free and metric
  compatible, a structure with two fields.
- `CovariantDerivative.IsLeviCivitaFor.koszul`: the Koszul formula.
- `CovariantDerivative.IsLeviCivitaFor.uniqueness`: two Levi-Civita
  connections agree on differentiable vector fields.
- `PseudoRiemannianMetric.koszulConnection`: an explicit connection
  built from the Koszul formula and the musical isomorphism.
- `PseudoRiemannianMetric.exists_isLeviCivitaFor`: every
  pseudo-Riemannian metric has a Levi-Civita connection.
- `PseudoRiemannianMetric.leviCivita`: the chosen connection, with
  `isLeviCivitaFor_leviCivita` recording that it satisfies the
  two conditions.

The file states Christoffel symbols only in a doc comment
(the formula `Γ^ρ_μν = ½ g^ρσ(∂_μ g_σν + ∂_ν g_σμ - ∂_σ g_μν)`).
It defines no `ChristoffelSymbol` of its own.

## What is missing for Mathlib

- No signature parameter. The general structure imposes no signature,
  and the Lorentzian condition lives only in the 4d `Spacetime`
  structure as a pointwise basis condition. Mathlib needs a metric
  with signature (p, q) as data, so that Lorentzian is the (3, 1)
  case and Riemannian is the (n, 0) case.
- No curvature. There is no Riemann tensor, no Ricci tensor, no
  scalar curvature, no Bianchi identity, no Einstein tensor in
  these files.
- No tensor contraction API. Traces and contractions are not built.
- No causality in the metric layer. Causal curves, global
  hyperbolicity, and Cauchy surfaces live in the Spacetime files,
  not in the general metric API.
- Smoothness is fixed at C^∞. The structure hardcodes `∞`.
  Mathlib style parameterises the smoothness `n`.
- The metric is a plain structure, not a typeclass, and there is
  no bundled `LorentzianMetric` type.
- No Sobolev spaces, no PDE tools, no energy estimates. Those are
  out of scope for this layer.

## Port assessment

Split verdict: the metric and musical isomorphism layer ports
cleanly, the Levi-Civita layer does not port to v4.23.0 as written.

Clean port: PseudoRiemannian/Basic.lean and Spacetime/Basic.lean.
They use only stable Mathlib APIs: `ContMDiff` bundle sections,
`TangentSpace`, continuous linear maps, `ModelWithCorners`,
`IsManifold`. The smoothness idiom is the same shape as
`Bundle.ContMDiffRiemannianMetric.contMDiff`, so Mathlib's bundle
lemmas apply directly. The reason `ContMDiffRiemannianMetric`
itself is not reused is recorded in the source: it carries `pos`
and `isVonNBounded`, and the boundedness condition is false for a
Lorentzian form, since the set `{v | g(v, v) < 1}` contains the
whole light cone.

Blocked port: PseudoRiemannian/LeviCivita.lean. Its first import is
`Mathlib.Geometry.Manifold.VectorBundle.CovariantDerivative.Torsion`,
and it builds on Mathlib's `CovariantDerivative`, `CovariantDerivative.torsion`,
and the Levi-Civita API of PR 36128. None of those names exist in
Mathlib v4.23.0 (see Audit/inventory.md). The repository pins Lean
4.35.0 and a newer Mathlib revision that contains that API. So
Phase 1 has a hard dependency: either PR 36128 (or its successor)
merges into Mathlib first, or the covariant derivative layer is
vendored into the staging repo, or Phase 1 targets a newer Mathlib
than v4.23.0. Porting the Levi-Civita file without its foundation
is not a port, it is a rewrite.

The Hamilton three-manifold project (arXiv 2608.21502, repo
https://github.com/qinz1yang/differential-geometry, release 0.1.0,
Lean 4.29.0, Mathlib v4.29.0) is a second, independent proof that
the pattern works: it builds its own `SmoothRiemannianMetric`,
Levi-Civita connection, and Ricci flow on top of the same
`CovariantDerivative` API. It is a satellite, not a Mathlib layer,
and it also depends on a Mathlib newer than v4.23.0.

## Generalisation decision

Decision: generalise. Build one general `PseudoRiemannianMetric`
with signature (p, q) as data, and make the Riemannian metric the
signature (n, 0) case. Do not build a parallel class.

Reasons:

- The Levi-Civita proof never uses positivity. The Koszul formula,
  uniqueness, and existence go through for any non-degenerate
  symmetric form. Hilbert6 proves this in practice: its general
  layer imposes no signature at all.
- One proof serves every signature. A parallel class would duplicate
  the bundle-section smoothness idiom, the musical isomorphisms,
  and the whole Koszul construction.
- Mathlib review asks for general statements, not physics-specific
  ones. A Lorentzian-only layer would be sent back for
  generalisation. Building the general case first is the review
  requirement, not a preference.
- The Riemannian case is recovered exactly: signature (n, 0) plus
  the positivity that follows from the signature. Existing
  Riemannian results keep their statements, with the metric
  supplied as the (n, 0) case.

How the migration goes, in outline: introduce the general structure
with a signature field (a pair of naturals (p, q) with p + q equal
to the fibre dimension, plus the existence of a basis with Gram
matrix diag(-1, ..., -1, 1, ..., 1)). Prove the musical
isomorphisms and Levi-Civita once, for the general structure.
Then re-express `Bundle.ContMDiffRiemannianMetric` as the
(n, 0) case, keeping its current name and statements working.
The exact refactor shape (replace the structure versus wrap it)
is a Phase 1 implementation choice for the Mathlib reviewer.
The direction is fixed: one general structure, Riemannian as a
special case.

What would change this decision:

- If Mathlib reviewers require the Riemannian API to stay
  byte-identical and refuse any refactor of
  `ContMDiffRiemannianMetric`, the fallback is a parallel class
  that shares lemmas with the Riemannian layer where possible.
  That fallback costs a duplicated Levi-Civita proof and should
  be recorded as a cost, not treated as free.
- If stating signature as data proves unworkable, for example for
  infinite-dimensional model spaces where p + q has no meaning,
  the fallback is a signature-free structure plus a separate
  `HasSignature p q` predicate on finite-dimensional fibres.
  The generalisation direction stays, only the encoding changes.
- If PR 36128 is closed without merging and no successor appears,
  the Levi-Civita dependency must be vendored or rebuilt, and
  the Phase 1 effort estimate moves to the top of its range.
  That changes the schedule, not the generalisation decision.
