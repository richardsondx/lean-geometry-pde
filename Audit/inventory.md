# Mathlib inventory, Phase 0 audit

Date: 26 Nov 2026. Baseline: Lean 4.23.0, Mathlib v4.23.0.
Local tree: ~/workspace/kerr-stability-lean/kerr-mathlib/.lake/packages/mathlib
(Mathlib commit 37df177aaa770670452312393d4e84aaad56e7b6, tag v4.23.0).
Audit file: Audit/MathlibInventory.lean, 43 #check lines.
Method: each #check was run live with `lake env lean` against that tree.
Failing lines are commented out in the audit file with the exact error.
No name was invented or guessed.

Totals: 33 confirmed present, 9 confirmed absent, 1 confirmed in a
named satellite repo.

## Smooth manifolds

- ChartedSpace, confirmed present.
  Mathlib/Geometry/Manifold/ChartedSpace.lean, line 537.
  https://leanprover-community.github.io/mathlib4_docs/Mathlib/Geometry/Manifold/ChartedSpace.html
- IsManifold, confirmed present.
  Mathlib/Geometry/Manifold/IsManifold/Basic.lean, line 773.
- ModelWithCorners, confirmed present (a structure, not a class).
  Mathlib/Geometry/Manifold/IsManifold/Basic.lean, line 161.
- ContMDiff, confirmed present.
  Mathlib/Geometry/Manifold/ContMDiff/Defs.lean, line 188.
- TangentBundle, confirmed present (abbrev).
  Mathlib/Geometry/Manifold/IsManifold/Basic.lean, line 1023.
- TangentSpace, confirmed present.
  Mathlib/Geometry/Manifold/IsManifold/Basic.lean, line 1001.
- VectorBundle, confirmed present.
  Mathlib/Topology/VectorBundle/Basic.lean, line 349.
- VectorField.mlieBracket, confirmed present (Lie bracket of vector fields).
  Mathlib/Geometry/Manifold/VectorField/LieBracket.lean, line 72.
- IsMIntegralCurve, confirmed present (integral curves).
  Mathlib/Geometry/Manifold/IntegralCurve/Basic.lean, line 76.
- LieGroup, confirmed present.
  Mathlib/Geometry/Manifold/Algebra/LieGroup.lean, line 68.
- SmoothManifoldWithCorners, confirmed absent.
  Lean error: Unknown identifier `SmoothManifoldWithCorners`.
  The class is `IsManifold` in v4.23.0. No file in the tree defines
  this name.
- AnalyticManifold, confirmed absent.
  Lean error: Unknown identifier `AnalyticManifold`.
  Mathlib/Geometry/Manifold/AnalyticManifold.lean is an 11-line
  deprecated shim: "Analytic manifolds are deprecated, use
  `IsManifold I ω M`" (since 2025-04-13).

## Riemannian manifolds

- Bundle.RiemannianBundle, confirmed present.
  Mathlib/Topology/VectorBundle/Riemannian.lean, line 420.
- Bundle.ContMDiffRiemannianMetric, confirmed present.
  Mathlib/Geometry/Manifold/VectorBundle/Riemannian.lean, line 238.
- IsContMDiffRiemannianBundle, confirmed present.
  Mathlib/Geometry/Manifold/VectorBundle/Riemannian.lean, line 62.
- IsRiemannianManifold, confirmed present.
  Mathlib/Geometry/Manifold/Riemannian/Basic.lean, line 77.
- Manifold.riemannianEDist, confirmed present (extended distance
  from path length).
  Mathlib/Geometry/Manifold/Riemannian/PathELength.lean, line 205.
  https://leanprover-community.github.io/mathlib4_docs/Mathlib/Geometry/Manifold/Riemannian/Basic.html

## Covariant derivative and Levi-Civita, PR 36128

- CovariantDerivative, confirmed absent.
  Lean error: Unknown identifier `CovariantDerivative`.
- IsLeviCivitaConnection, confirmed absent.
  Lean error: Unknown identifier `IsLeviCivitaConnection`.
- LeviCivitaConnection, confirmed absent.
  Lean error: Unknown identifier `LeviCivitaConnection`.
- ChristoffelSymbol, confirmed absent.
  Lean error: Unknown identifier `ChristoffelSymbol`.
- PR 36128 verdict: NOT merged in v4.23.0. Two independent checks
  agree. (1) None of its names exist anywhere in the v4.23.0 tree
  (ripgrep over the whole tree returns zero hits). (2) GitHub API,
  26 Nov 2026: state open, merged false, merged_at null, created
  4 Mar 2026. PR: https://github.com/leanprover-community/mathlib4/pull/36128
  The PR adds CovariantDerivative, IsLeviCivitaConnection,
  LeviCivitaConnection, ChristoffelSymbol, and files under
  Mathlib/Geometry/Manifold/VectorBundle/CovariantDerivative/.
  That directory does not exist in v4.23.0.

## Satellite: Hamilton three-manifold project

- SmoothRiemannianMetric, confirmed in a named satellite repo,
  not in Mathlib.
  Lean error in Mathlib: Unknown identifier `SmoothRiemannianMetric`.
  Source: A Lean Formalization of Hamilton's Three-Manifold Theorem,
  arXiv 2608.21502, https://arxiv.org/abs/2608.21502 (HTML version
  confirms the identifier, many occurrences, e.g. `def LeviCivita
  (g : SmoothRiemannianMetric I M)`).
  Repo: https://github.com/qinz1yang/differential-geometry,
  release 0.1.0, commit 8bd406e35, Lean 4.29.0, Mathlib v4.29.0.
  The project builds Riemannian tensor calculus, the Levi-Civita
  connection, and Ricci flow evolution on top of the same
  CovariantDerivative API that PR 36128 would add to Mathlib.

## Measure, Lp, Bochner

- MeasureTheory.integral (Bochner integral), confirmed present.
  Mathlib/MeasureTheory/Integral/Bochner/Basic.lean, line 157.
- MeasureTheory.MemLp, confirmed present.
  Mathlib/MeasureTheory/Function/LpSeminorm/Defs.lean, line 112.
- MeasureTheory.Lp, confirmed present.
  Mathlib/MeasureTheory/Function/LpSpace/Basic.lean, line 84.
- MeasureTheory.eLpNorm_add_le (Minkowski, triangle inequality),
  confirmed present.
  Mathlib/MeasureTheory/Function/LpSeminorm/TriangleInequality.lean,
  line 48.
- MeasureTheory.MemLp.mul (Holder), confirmed present.
  Mathlib/MeasureTheory/Function/LpSeminorm/CompareExp.lean, line 319.
- MeasureTheory.integral_prod (Fubini), confirmed present.
  Mathlib/MeasureTheory/Integral/Prod.lean, line 460.
- MeasureTheory.lintegral_prod (Tonelli), confirmed present.
  Mathlib/MeasureTheory/Measure/Prod.lean, line 880.

## Fourier, Schwartz, tempered distributions, Sobolev

- VectorFourier.fourierIntegral (Fourier transform), confirmed present.
  Mathlib/Analysis/Fourier/FourierTransform.lean, line 77.
- SchwartzMap, confirmed present.
  Mathlib/Analysis/Distribution/SchwartzSpace.lean, line 76.
- TemperedDistribution, confirmed absent.
  Lean error: Unknown identifier `TemperedDistribution`.
  Zero hits for the name anywhere in the v4.23.0 tree.
- TemperedDistribution.MemSobolev, confirmed absent.
  Lean error: Unknown identifier `TemperedDistribution.MemSobolev`.
- BesselPotentialSpace, confirmed absent.
  Lean error: Unknown identifier `BesselPotentialSpace`.
  Zero hits for `BesselPotential` anywhere in the tree.
- MeasureTheory.eLpNorm_le_eLpNorm_fderiv_one (Sobolev inequality),
  confirmed present. This is an inequality, not a Sobolev space.
  Mathlib/Analysis/FunctionalSpaces/SobolevInequality.lean, line 437.
- Correction to the plan: the plan says Mathlib has Sobolev spaces
  as Bessel potential spaces in Mathlib/Analysis/Distribution/Sobolev.
  That file does not exist in v4.23.0, and no Sobolev space type
  exists in the tree. The arXiv paper the plan cites
  (arXiv 2510.24060, https://arxiv.org/html/2510.24060) describes
  work that has not landed in v4.23.0. See docs/RFC_Sobolev.md.
  https://leanprover-community.github.io/mathlib4_docs/Mathlib/Analysis/Distribution/Sobolev.html
  (that docs URL describes a newer Mathlib, not v4.23.0).

## Functional analysis

- NormedSpace, confirmed present.
  Mathlib/Analysis/Normed/Module/Basic.lean, line 40.
- CompleteSpace, confirmed present.
  Mathlib/Topology/UniformSpace/Cauchy.lean, line 361.
- InnerProductSpace, confirmed present.
  Mathlib/Analysis/InnerProductSpace/Defs.lean, line 102.
- NormedAddCommGroup, confirmed present.
  Mathlib/Analysis/Normed/Group/Basic.lean, line 209.
- Note: Mathlib has no `BanachSpace` class. Completeness is the
  `CompleteSpace` class plus `NormedSpace`. Hilbert space is
  `InnerProductSpace` plus `CompleteSpace`.

## ODE

- IsPicardLindelof, confirmed present.
  Mathlib/Analysis/ODE/PicardLindelof.lean, line 79.
- IsPicardLindelof.exists_eq_forall_mem_Icc_hasDerivWithinAt
  (Picard-Lindelof local existence), confirmed present.
  Mathlib/Analysis/ODE/PicardLindelof.lean, line 579.
- gronwallBound, confirmed present.
  Mathlib/Analysis/ODE/Gronwall.lean, line 39.
- le_gronwallBound_of_liminf_deriv_right_le (Gronwall inequality),
  confirmed present.
  Mathlib/Analysis/ODE/Gronwall.lean, line 97.

## What this changes in the plan

- The Levi-Civita work in Phase 1 is blocked on PR 36128 merging,
  being vendored, or targeting a newer Mathlib. The metric and
  musical isomorphism work is not blocked.
- The Sobolev work in Phase 3 must first land the tempered
  distribution layer (or target a newer Mathlib that has it).
  The plan's claim that Bessel potential Sobolev spaces already
  exist in Mathlib is wrong for v4.23.0.
- The plan's claim that Mathlib has a `SmoothManifoldWithCorners`
  class is wrong for v4.23.0. The class is `IsManifold`.
  Analytic manifolds are a deprecated shim over `IsManifold`.
