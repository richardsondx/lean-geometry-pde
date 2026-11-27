# RFC: Pseudo-Riemannian metric in Mathlib

Date: 26 Nov 2026. Status: draft for Phase 0. No Lean code in this file.
Definitions are stated in prose only. Phase 1 code waits on approval.

## Decision

Generalise. Build one general pseudo-Riemannian metric type with
signature (p, q) as data, and make the Riemannian metric the
signature (n, 0) case. Do not build a parallel class.

## Why this decision

- The Levi-Civita proof never uses positivity. The Koszul formula,
  uniqueness, and existence hold for any non-degenerate symmetric
  form. The Hilbert6 project proves this in practice: its general
  layer imposes no signature at all.
- One proof serves every signature. A parallel class would duplicate
  the bundle-section smoothness idiom, the musical isomorphisms,
  and the whole Koszul construction.
- Mathlib review asks for general statements, not physics-specific
  ones. A Lorentzian-only layer would be sent back for
  generalisation.
- The Riemannian case is recovered exactly: signature (n, 0) plus
  the positivity that follows from the signature.

Full evidence and port assessment:
map/Physicslib4-assessment.md.

## Definitions, in prose

- A pseudo-Riemannian metric on a manifold M modelled on (E, H)
  with model I is a smooth family of symmetric, non-degenerate
  continuous bilinear forms on the tangent spaces, together with a
  signature (p, q): a pair of naturals with p + q equal to the
  fibre dimension, witnessed by a basis at each point whose Gram
  matrix is diag(-1, ..., -1, 1, ..., 1) with p plus ones and q
  minus ones.
- A Lorentzian metric is the signature (3, 1) case on a
  four-dimensional manifold, with the (-, +, +, +) convention
  locked in docs/RFC_Conventions.md.
- A Riemannian metric is the signature (n, 0) case. Positivity
  is a consequence of the signature, not separate data.
- The musical isomorphisms: flat sends a tangent vector v to the
  covector g(v, .), and sharp is its inverse. Both are smooth in
  the base point.
- The Levi-Civita connection is the unique torsion-free connection
  compatible with the metric, proved unique through the Koszul
  formula. It is built from Mathlib's covariant derivative API
  (see Dependencies).
- The Riemann curvature, Ricci tensor, and scalar curvature are
  defined from the Levi-Civita connection with the sign convention
  locked in docs/RFC_Conventions.md. The Bianchi identities are
  theorems, not definitions.

## What is ported, what is built

- Ported from Hilbert6: the metric structure shape, the
  bundle-section smoothness idiom, the musical isomorphisms and
  the smoothness of the inverse, the Koszul construction of the
  Levi-Civita connection.
- Built new: the signature (p, q) parameter, which Hilbert6 does
  not carry; the Riemann, Ricci, and scalar curvature API, which
  Hilbert6 does not have; the migration of the existing Riemannian
  API to the (n, 0) case.
- Smoothness is parameterised by n in the Mathlib style, not
  fixed at C^∞ as Hilbert6 does.

## Dependencies

- Hard dependency: Mathlib PR 36128 (Levi-Civita minimal, by
  grunweg) or its successor. Status on 26 Nov 2026: open, not
  merged (GitHub API: state open, merged false, merged_at null,
  created 4 Mar 2026). None of its names (`CovariantDerivative`,
  `IsLeviCivitaConnection`, `LeviCivitaConnection`,
  `ChristoffelSymbol`) exist in Mathlib v4.23.0. See
  Audit/inventory.md. Phase 1 cannot start the Levi-Civita work
  until this API lands, is vendored into the staging repo, or
  Phase 1 targets a newer Mathlib.
- The metric and musical isomorphism work does not depend on
  PR 36128 and can start first.

## Open questions

- Signature encoding: as data in the structure (a (p, q) field
  plus a basis witness), or as a separate `HasSignature p q`
  predicate on a signature-free structure? Data is the current
  choice. It makes Lorentzian and Riemannian into plain
  specialisations. It costs a basis witness at every point.
- Migration shape: is `Bundle.ContMDiffRiemannianMetric` replaced
  by the (n, 0) case, or kept and wrapped? The direction is fixed
  (one general structure). The exact refactor shape is a Phase 1
  choice for the Mathlib reviewer.
- Finite dimension: the signature needs p + q to equal the fibre
  dimension. The design assumes finite-dimensional model spaces.
  Infinite-dimensional manifolds are out of scope for Phase 1.
- Time orientation and causality are separate data, not part of
  the metric. They belong to a later phase, following the
  Hilbert6 split.

## What would change the decision

- If Mathlib reviewers require the Riemannian API to stay
  byte-identical, the fallback is a parallel class sharing
  lemmas where possible. That costs a duplicated Levi-Civita
  proof. Record the cost, do not pretend it is free.
- If signature as data proves unworkable, fall back to a
  signature-free structure plus a `HasSignature` predicate.
  The generalisation direction stays, only the encoding changes.
- If PR 36128 is closed without merging, the Levi-Civita
  dependency must be vendored or rebuilt, and Phase 1 effort
  moves to the top of its range. That changes the schedule,
  not the generalisation decision.
