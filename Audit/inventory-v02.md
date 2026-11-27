# Mathlib inventory, Phase 0 audit

Version v02, fix cycle 1, 26 Nov 2026. Changes from v01: the Hamilton
satellite entry is corrected (GAP-3); a "Method limits" section is added
(GAP-4); open minor items are recorded (GAP-5). All Mathlib-tree file and
line citations are unchanged from v01; the independent checker re-verified
all 33 of them exactly against the v4.23.0 tree.

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
  commit 8bd406e35 (message "Set package version to 0.1.0").
  Corrected in v02 (GAP-3): there is NO release tagged 0.1.0.
  GitHub releases for the repo, checked 26 Nov 2026 via the API,
  are v0.1.5, v0.1.4, v0.1.3, v0.1.2, v0.1.1, and arxiv-v1-preview
  (named "0.1.0 (arXiv v1 preview)"). The version string 0.1.0 is
  real, as a package version set in commit 8bd406e35, but it is not
  a release. Paper-time snapshot: Lean 4.29.0, Mathlib v4.29.0.
  Current main uses Lean v4.35.0-rc3 (lean-toolchain, checked
  26 Nov 2026).
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

## Method limits

Added in v02 (GAP-4). This section states plainly what the audit does
and does not establish. It does not fix the limits; it records them.

- Presence test is #check only. A passing #check shows the name
  resolves and typechecks under the imports in the audit file. It
  does not show the definition has the hypotheses, regularity,
  domain, or conclusion a downstream use needs, and it does not
  show the name is usable for the plan's intended application.
  No downstream example was elaborated in Phase 0.
- Absence is name-not-found in the v4.23.0 tree, not a proof that
  no equivalent exists under another name. The absent verdicts rest
  on a failing #check plus zero hits for the exact name in a tree
  grep. An equivalent construction under a different name is not
  ruled out. The commented-out failing lines are records, not
  rerunnable negative probes.
- "Blocked" for Levi-Civita means the named API is absent from
  v4.23.0. It does not mean no workaround exists: vendoring the
  covariant derivative layer, or targeting a newer Mathlib, are
  named options, and their cost was not measured. No minimal
  downstream example was exhibited that fails on the baseline API.
- The generalisation decision (one PseudoRiemannianMetric with
  signature (p, q), Riemannian as the (n, 0) case) is unproven
  until a downstream example exists. In particular, no example in
  Phase 0 shows the (n, 0) case interoperating with
  Bundle.ContMDiffRiemannianMetric without duplicate instances or
  lost lemmas.
- The baseline is v4.23.0 while the cited satellites run newer
  versions (Hamilton paper-time 4.29.0, current main 4.35.0-rc3;
  Hilbert6 pins Lean 4.35.0). No reason for staying on v4.23.0 is
  given in the Phase 0 artifacts.

## What this changes in the plan

- The Levi-Civita work in Phase 1 is blocked on PR 36128 merging,
  being vendored, or targeting a newer Mathlib. The metric and
  musical isomorphism work is not blocked. (See "Method limits"
  above for what "blocked" means here.)
- The Sobolev work in Phase 3 must first land the tempered
  distribution layer (or target a newer Mathlib that has it).
  The plan's claim that Bessel potential Sobolev spaces already
  exist in Mathlib is wrong for v4.23.0. (The inference that
  tempered distributions must come first, rather than a
  weak-derivative W^{k,p} route, is not demonstrated in Phase 0;
  see "Method limits".)
- The plan's claim that Mathlib has a `SmoothManifoldWithCorners`
  class is wrong for v4.23.0. The class is `IsManifold`.
  Analytic manifolds are a deprecated shim over `IsManifold`.

## Open items, minor (GAP-5)

- The /tmp/probes/ probe logs cited in the audit file header were
  not re-checked in fix cycle 1. /tmp was full at check time, and
  the logs were not re-opened. Owner: Phase 1 lead, if the probe
  timings are ever relied on.
- The PR 36128 Riemann sign (the trigger in docs/RFC_Conventions.md:
  if the PR defines the opposite Riemann sign when it lands, Phase 1
  must follow Mathlib) is untested. No source in the Phase 0 evidence
  states the PR's sign convention. Owner: Phase 1 lead, to check
  when the PR is next reviewed.
