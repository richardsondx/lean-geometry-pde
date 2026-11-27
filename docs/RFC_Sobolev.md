# RFC: Sobolev spaces in Mathlib

Date: 26 Nov 2026. Status: draft for Phase 0. No Lean code in this file.
Definitions are stated in prose only. Phase 3 code waits on approval.

## Correction to the plan

The plan says Mathlib has Sobolev spaces as Bessel potential spaces
in Mathlib/Analysis/Distribution/Sobolev, with `MemSobolev` and
`BesselPotentialSpace`. That is wrong for v4.23.0. The file does not
exist in the v4.23.0 tree, and no name matching `MemSobolev`,
`BesselPotential`, or `TemperedDistribution` appears anywhere in
the tree. See Audit/inventory.md. The plan's Sobolev section was
written against a newer Mathlib or against the arXiv paper
(arXiv 2510.24060) rather than the v4.23.0 tree.

What v4.23.0 actually has:

- `SchwartzMap`, the Schwartz functions, present.
- `VectorFourier.fourierIntegral`, the Fourier transform, present.
- `MeasureTheory.MemLp` and `MeasureTheory.Lp`, present, with
  Holder and Minkowski.
- One Sobolev-type result: `MeasureTheory.eLpNorm_le_eLpNorm_fderiv_one`,
  a Sobolev inequality bounding an Lp norm by a derivative norm,
  in Mathlib/Analysis/FunctionalSpaces/SobolevInequality.lean.
  That is an inequality, not a Sobolev space.
- No tempered distributions, no Bessel potential spaces, no
  W^{k,p} on domains, no Sobolev spaces on manifolds, no weighted
  spaces, no embeddings, no trace theorem.

## Design, in order

Build in this order. Each step is usable before the next lands.

1. Bessel potential spaces on flat space first. A tempered
   distribution u is in H^{s,p} when its Bessel potential is in
   Lp. This needs the tempered distribution layer first
   (arXiv 2510.24060), since v4.23.0 does not have it. Prove:
   Schwartz functions lie in every H^{s,p}; derivatives lower
   the order by 1; the Laplacian lowers it by 2.
2. W^{k,p} on open subsets of R^n, through weak derivatives.
   Integer order k first, then fractional s. Prove: Poincare
   inequality, Sobolev embeddings for the cases claimed, trace
   theorem for the boundary.
3. Sobolev spaces of tensor fields on a manifold. Define through
   local coordinates with a partition of unity, and prove the
   definition does not depend on the choices. Embeddings and the
   divergence theorem on Lorentzian domains come here.
4. Weighted Sobolev spaces H^s_delta for asymptotic flatness,
   last. They are the hardest and the least reusable. A test:
   a function decaying like r^{-1} at infinity lies in the
   claimed weighted space.

## Definitions, in prose

- H^{s,p} on R^n: Bessel potential spaces, defined through the
  Fourier transform. s is real, p is in [1, infinity].
- W^{k,p} on a domain: functions whose weak derivatives up to
  order k are in Lp. k is a natural number. The weak derivative
  is defined by integration against test functions.
- W^{k,p} on a manifold: sections of a tensor bundle whose
  coordinate representatives are in W^{k,p} on every chart,
  with a partition of unity making the norm well defined.
- Weighted H^s_delta: H^s functions with a stated decay rate
  at infinity, measured against a radial weight.

## Open questions

- Definition route: Bessel potential first, as above, or weak
  derivatives first with Bessel proved equivalent later? Bessel
  first is the current choice, because the Fourier machinery
  already exists in Mathlib and the arXiv 2510.24060 layer
  follows that route.
- Which p range to support first: p in (1, infinity) covers the
  energy estimates. p = 1 and p = infinity have edge cases and
  can wait.
- Integer versus fractional order: integer k first for W^{k,p}
  on domains, fractional s through Bessel for H^s. The two
  families must be proved to agree where they overlap.
- Manifold definition: local coordinates with partitions of
  unity, or intrinsic bundle sections with a connection? The
  coordinate route is the current choice. It is concrete and
  matches the PDE literature. The intrinsic route is cleaner
  but needs the Levi-Civita connection first.
- Dependence on the tempered distribution layer: Phase 3 cannot
  start step 1 until that layer lands in Mathlib or is vendored.
  Targeting a newer Mathlib may resolve this without new work.

## What would change the decision

- If the tempered distribution layer lands in Mathlib with a
  different definition of H^{s,p} than Bessel potential, adopt
  the landed definition. Do not maintain a parallel one.
- If the weak derivative route proves shorter than Bessel for
  the domain case, build W^{k,p} on domains first and treat
  H^s as the Bessel specialisation. The order of steps 1 and 2
  can swap. The manifold and weighted steps stay last.
- If embeddings and trace theorems prove too long for one phase,
  split Phase 3: spaces first, embeddings and trace second.
  The wave energy estimate is the acceptance test either way.
