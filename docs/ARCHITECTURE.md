# docs/ARCHITECTURE.md

Date: 26 Nov 2026. Run: stage2-mathlib-geometry-phase1-planning-01.
Author: Gemini 4 Neon, model google/gemini-4-neon, as architect.
Baseline recommended by Neon: move to Mathlib v4.36.0, see docs/BaselineDecision.md.
Status: planning only. No Lean code in this file. No proof claimed.

How to read this file: sections 1 to 6 are verbatim Neon output from calls 1 and 2 in neon-log.md.
The generator verification notes at the end are not Neon output. They record two errors
Neon made and one inconsistency Neon exposed in the Phase 0 artifacts.

# docs/ARCHITECTURE.md

Target baseline: upgrade the local Mathlib pin from v4.23.0 to v4.36.0 in Step 0. This consumes upstream `Mathlib.Geometry.Manifold.VectorBundle.CovariantDerivative.Basic`, `Mathlib.Analysis.Distribution.Sobolev`, and `Mathlib.Analysis.Distribution.TemperedDistribution` instead of duplicating them or importing unmerged PR 36128. Signature `(p, q)` denotes `p` positive and `q` negative eigenvalues, so Riemannian is `(n, 0)` and 4D Lorentzian `(-, +, +, +)` is `(3, 1)` with coordinate 0 timelike.

## 1. Module List

- `PseudoRiemannian.Metric`: enables constructing Riemannian `(n, 0)` and Lorentzian `(3, 1)` `(-, +, +, +)` metrics on `ContMDiff` manifolds from one signature-parameterized structure.
- `PseudoRiemannian.RiemannianInterop`: enables applying `IsRiemannianManifold`, `Manifold.riemannianEDist`, and tangent `InnerProductSpace` lemmas to `(n, 0)` metrics without duplicate instances.
- `PseudoRiemannian.Musical`: enables smooth index raising and lowering in the Koszul formula and metric contractions via bundle isomorphisms.
- `PseudoRiemannian.TensorContraction`: enables forming the Ricci tensor as a frame-independent trace of Riemann curvature and scalar curvature as a metric contraction of Ricci.
- `PseudoRiemannian.LeviCivita`: enables computing, in the Riemannian `(n, 0)` case, the unique torsion-free metric-compatible connection, with local Christoffel symbols defined in this module and checked against upstream only where the checker verified them (existence :359, uniqueness :255-258, gating :126, :156, :172), and, for indefinite `(p, q)` metrics, building that connection as a Phase 1 obligation (see the Per-Module Specification below).
- `PseudoRiemannian.Curvature`: enables computing the Riemann tensor, a (1, 3)-type tensor, `R(X, Y)Z = nabla_X nabla_Y Z - nabla_Y nabla_X Z - nabla_[X,Y] Z` and proving the first and second Bianchi identities.
- `PseudoRiemannian.RicciEinstein`: enables computing Ricci curvature, scalar curvature, the Einstein tensor `G = Ric - (1/2) R g`, and the contracted Bianchi law `div G = 0`.
- `Analysis.Sobolev.LocalDomain`: enables chart-level weak derivatives, `W^{k,p}(U)` norms on open Euclidean sets, Sobolev embedding into `C^m`, and Rellich-Kondrachov compactness.
- `Geometry.Manifold.SobolevSection`: enables chart-independent `W^{k,p}` spaces of bundle sections over compact manifolds for geometric PDE estimates.
- `Analysis.PDE.GeometricBase`: enables weak elliptic solvability for `(n, 0)` Laplace-Beltrami via `LaxMilgram` and energy bounds for `(n - 1, 1)` wave operators via `Gronwall`.

## 2. Per-Module Specification

### `PseudoRiemannian.Metric`
- Imports: `Mathlib.Geometry.Manifold.VectorBundle.Tangent`, `Mathlib.Geometry.Manifold.VectorBundle.LocalFrame`, `Mathlib.LinearAlgebra.BilinearForm.Properties`, `Mathlib.LinearAlgebra.QuadraticForm.Real`.
- Exports: `PseudoRiemannianMetric` (parameters `p q : Nat`, smoothness `n : WithTop ENat`, fields `val`, `symm`, `nondegenerate`, `hasSignature`, `contMDiff`), `LorentzianMetric` (`(n - 1, 1)` abbreviation), `SpacetimeMetric` (`(3, 1)` abbreviation), `PseudoRiemannianMetric.finrank_eq`, `PseudoRiemannianMetric.isLocallyConstant_signature`.
- Forbids: importing `Bundle.RiemannianBundle` or `Bundle.ContMDiffRiemannianMetric`; adding `pos` or `isVonNBounded` fields; fixing smoothness to `C-infinity`; registering `NormedAddCommGroup` or `InnerProductSpace` instances.

### `PseudoRiemannian.RiemannianInterop`
- Imports: `PseudoRiemannian.Metric`, `Mathlib.Geometry.Manifold.Riemannian.Basic`, `Mathlib.Geometry.Manifold.Riemannian.PathELength` (for `Bundle.ContMDiffRiemannianMetric` and `Manifold.riemannianEDist`; the v4.36.0 Riemannian directory holds only Basic.lean and PathELength.lean, and the PathELength path is to be re-confirmed at Step 0).
- Exports: `PseudoRiemannianMetric.pos_of_q_eq_zero`, `PseudoRiemannianMetric.isVonNBounded_of_q_eq_zero`, `PseudoRiemannianMetric.toContMDiffRiemannianMetric`, `Bundle.ContMDiffRiemannianMetric.toPseudoRiemannianMetric` (plain `def`, not an instance), scoped instances in namespace `PseudoRiemannian.Riemannian` for `Bundle.RiemannianBundle`, `IsContMDiffRiemannianBundle`, and `IsRiemannianManifold` (open decision, see below: these scoped instances are in tension with the existing Mathlib instance at VectorBundle/Riemannian.lean:264 and are not yet justified).
- Forbids: global `instance` declarations for `Bundle.RiemannianBundle`, `NormedAddCommGroup`, or `InnerProductSpace`; importing `CovariantDerivative`, curvature, or Sobolev modules.

### `PseudoRiemannian.Musical`
- Imports: `PseudoRiemannian.Metric`, `Mathlib.Geometry.Manifold.MFDeriv.Atlas`, `Mathlib.Geometry.Manifold.VectorBundle.SmoothSection`.
- Exports: `PseudoRiemannianMetric.flatEquiv` (`TM` to `T*M`), `PseudoRiemannianMetric.sharpEquiv` (`T*M` to `TM`), `PseudoRiemannianMetric.inverseMetric` (induced nondegenerate pairing on `T*M`), `flat_sharp`, `sharp_flat`, smooth bundle-isomorphism lemmas.
- Forbids: coordinate matrix inversion as primary definition; positive-definiteness assumptions; connections or curvature.

### `PseudoRiemannian.TensorContraction`
- Imports: `PseudoRiemannian.Metric`, `PseudoRiemannian.Musical`.
- Exports: `BundleEnd.trace` (frame-independent fiberwise trace on `End(TM)`), `Tensor.contract` (pairing one covariant and one contravariant slot), `PseudoRiemannianMetric.metricTrace` (contracting two covariant slots via `sharpEquiv` and `BundleEnd.trace`), smoothness of contracted sections, chart-level trace identity.
- Forbids: coordinate-dependent primary definitions; positive-definite inner product assumptions; connections or curvature.

### `PseudoRiemannian.LeviCivita`
- Imports: `PseudoRiemannian.Metric`, `PseudoRiemannian.Musical`, `Mathlib.Geometry.Manifold.VectorBundle.CovariantDerivative.Basic`, `Mathlib.Geometry.Manifold.VectorBundle.CovariantDerivative.LeviCivita`.
- Exports: `IsMetricCompatible` for `(p, q)` metrics, `IsTorsionFree`, Koszul formula, `PseudoRiemannianMetric.leviCivita` (existence and uniqueness of the torsion-free metric-compatible connection in the Riemannian `(n, 0)` case, as supplied upstream; for indefinite `(p, q)` the connection is a Phase 1 build obligation, not an upstream export), `PseudoRiemannianMetric.christoffel` (chart symbols and transformation law, defined in this module; checked against upstream only where the checker verified them, existence :359, uniqueness :255-258, gating :126, :156, :172). Amended 27 Nov 2026, run stage2-mathlib-geometry-planning-docs-01: upstream v4.36.0 supplies Riemannian-only existence and uniqueness, Mathlib/Geometry/Manifold/VectorBundle/CovariantDerivative/LeviCivita.lean, existence `def leviCivitaConnection` at line 359, uniqueness theorem at lines 255-258, gated by `[RiemannianBundle]` at lines 126 and 156 and `[IsContMDiffRiemannianBundle]` at line 172 (verdict-phase1-planning-v02.md; check-log-phase1-planning-v03.md item 1). The indefinite case is a Phase 1 build obligation with a named route: generalise the Koszul construction, or port Hilbert6 `PseudoRiemannianMetric.exists_isLeviCivitaFor` (pinned commit ddbe9da, line 371, verified live in check-log-phase1-planning-v03.md item 4). Indefinite uniqueness is a separate explicit proof obligation, not supplied by Hilbert6 existence alone.
- Downstream note, 27 Nov 2026, fix cycle 2: `PseudoRiemannian.Curvature` and `PseudoRiemannian.RicciEinstein` depend on the Phase 1-built connection for indefinite signatures and are blocked until that construction exists, while the Riemannian `(n, 0)` case proceeds on the upstream connection.
- Forbids: importing PR 36128 or unmerged forks; claiming upstream existence or uniqueness for indefinite signatures; curvature definitions.

### `PseudoRiemannian.Curvature`
- Imports: `PseudoRiemannian.Metric`, `PseudoRiemannian.LeviCivita`.
- Exports: `riemannEnd` (`R(X, Y)Z = nabla_X nabla_Y Z - nabla_Y nabla_X Z - nabla_[X, Y] Z`), `C^infty`-multilinearity in `X, Y, Z`, `riemannCov` (all-covariant `(0, 4)` tensor via the metric), algebraic symmetries (antisymmetry in both pairs, pair swap), `firstBianchi`, `secondBianchi`.
- Forbids: trace operations (Ricci or scalar curvature); chart-only definitions of `R`; fixing dimension `n = 4`.

### `PseudoRiemannian.RicciEinstein`
- Imports: `PseudoRiemannian.Metric`, `PseudoRiemannian.Musical`, `PseudoRiemannian.TensorContraction`, `PseudoRiemannian.LeviCivita`, `PseudoRiemannian.Curvature`.
- Exports: `ricciTensor` (frame-independent trace of `Z -> R(Z, X)Y`), symmetry of `ricciTensor`, `scalarCurvature` (`metricTrace` of `ricciTensor`), `einsteinTensor` (`G = Ric - (1/2) R g`), `covariantDiv` (metric contraction of `nabla` on symmetric `(0, 2)` tensors), `contractedSecondBianchi` (`div G = 0`).
- Forbids: assuming Lorentzian signature or `n = 4`; coordinate-only proofs of `div G = 0`; Sobolev or PDE imports.

### Sobolev and Geometric PDE Modules

`Analysis.Sobolev.LocalDomain`
- Imports: `Mathlib.Analysis.Distribution.Sobolev`, `Mathlib.Analysis.Distribution.TemperedDistribution`.
- Exports: `LocalSobolevSpace` (`W^{k,p}(U)` on open sets `U` in `R^n`), norm and Banach completeness, diffeomorphism invariance on compactly contained open subsets.
- Forbids: manifold atlases, vector bundles, or metrics.

`Geometry.Manifold.SobolevSection`
- Imports: `PseudoRiemannian.Metric`, `PseudoRiemannian.LeviCivita`, `Analysis.Sobolev.LocalDomain`.
- Exports: `SobolevSection` (`W^{k,p}` norm on bundle sections via chart trivializations and partitions of unity), atlas-independence equivalence on compact domains, `H^k` Hilbert structure for Riemannian metrics.
- Forbids: PDE solvability theorems or Lorentzian energy estimates.

`Analysis.PDE.GeometricBase`
- Imports: `PseudoRiemannian.Metric`, `PseudoRiemannian.LeviCivita`, `PseudoRiemannian.TensorContraction`, `Geometry.Manifold.SobolevSection`, `Mathlib.Analysis.InnerProductSpace.LaxMilgram`, `Mathlib.Analysis.ODE.Gronwall`.
- Exports: `weakEllipticSolvability` (coercive bilinear form solvability on `H^1` sections via Lax-Milgram), `covariantLaplacian`, `waveEnergy`, `waveEnergyBound` (a priori hyperbolic energy inequality via Gronwall).
- Forbids: nonlinear Einstein evolution or gauge-fixing specifics.

### Dependency Graph
Direction: `A -> B` means `A` imports `B`.
- `PseudoRiemannian.RiemannianInterop -> PseudoRiemannian.Metric`
- `PseudoRiemannian.RiemannianInterop -> Mathlib.Geometry.Manifold.Riemannian.Basic`
- `PseudoRiemannian.RiemannianInterop -> Mathlib.Geometry.Manifold.Riemannian.PathELength`
- `PseudoRiemannian.Musical -> PseudoRiemannian.Metric`
- `PseudoRiemannian.TensorContraction -> PseudoRiemannian.Metric`
- `PseudoRiemannian.TensorContraction -> PseudoRiemannian.Musical`
- `PseudoRiemannian.LeviCivita -> PseudoRiemannian.Metric`
- `PseudoRiemannian.LeviCivita -> PseudoRiemannian.Musical`
- `PseudoRiemannian.LeviCivita -> Mathlib.Geometry.Manifold.VectorBundle.CovariantDerivative.Basic`
- `PseudoRiemannian.LeviCivita -> Mathlib.Geometry.Manifold.VectorBundle.CovariantDerivative.LeviCivita`
- `PseudoRiemannian.Curvature -> PseudoRiemannian.Metric`
- `PseudoRiemannian.Curvature -> PseudoRiemannian.LeviCivita`
- `PseudoRiemannian.RicciEinstein -> PseudoRiemannian.Metric`
- `PseudoRiemannian.RicciEinstein -> PseudoRiemannian.Musical`
- `PseudoRiemannian.RicciEinstein -> PseudoRiemannian.TensorContraction`
- `PseudoRiemannian.RicciEinstein -> PseudoRiemannian.LeviCivita`
- `PseudoRiemannian.RicciEinstein -> PseudoRiemannian.Curvature`
- `Analysis.Sobolev.LocalDomain -> Mathlib.Analysis.Distribution.Sobolev`
- `Analysis.Sobolev.LocalDomain -> Mathlib.Analysis.Distribution.TemperedDistribution`
- `Geometry.Manifold.SobolevSection -> PseudoRiemannian.Metric`
- `Geometry.Manifold.SobolevSection -> PseudoRiemannian.LeviCivita`
- `Geometry.Manifold.SobolevSection -> Analysis.Sobolev.LocalDomain`
- `Analysis.PDE.GeometricBase -> PseudoRiemannian.Metric`
- `Analysis.PDE.GeometricBase -> PseudoRiemannian.LeviCivita`
- `Analysis.PDE.GeometricBase -> PseudoRiemannian.TensorContraction`
- `Analysis.PDE.GeometricBase -> Geometry.Manifold.SobolevSection`
- `Analysis.PDE.GeometricBase -> Mathlib.Analysis.InnerProductSpace.LaxMilgram`
- `Analysis.PDE.GeometricBase -> Mathlib.Analysis.ODE.Gronwall`

### Build Order
1. `PseudoRiemannian.Metric`: `lake build` succeeds; `#print axioms` on Minkowski metric reports only standard Lean axioms.
2. `PseudoRiemannian.RiemannianInterop` and `PseudoRiemannian.Musical` (parallel): `lake build` succeeds; `#check` confirms positive-definite bridge to `Riemannian.Basic` plus `flat_sharp` and `sharp_flat`.
3. `PseudoRiemannian.TensorContraction`: `lake build` succeeds; `#check` confirms `metricTrace` of the metric equals manifold dimension and matches chart trace.
4. `PseudoRiemannian.LeviCivita`: `lake build` succeeds; `#check` confirms uniqueness and the Christoffel formula in the Riemannian `(n, 0)` case, checked against the upstream connection only where the checker verified it (existence :359, uniqueness :255-258, gating :126, :156, :172). For indefinite `(p, q)`, the connection is a construction obligation with its own prior build step (generalised Koszul construction, or the Hilbert6 port); that step must land before any `#check` of the indefinite case, since a `#check` cannot confirm a construction into existence.
5. `PseudoRiemannian.Curvature`: `lake build` succeeds; `#check` confirms `C^infty`-multilinearity of `riemannEnd`, symmetries of `riemannCov`, and both Bianchi identities.
6. `PseudoRiemannian.RicciEinstein`: `lake build` succeeds; `#check` and `#print axioms` confirm `ricciTensor` symmetry and `contractedSecondBianchi` (`div G = 0`) use only standard axioms.
7. `Analysis.Sobolev.LocalDomain`: `lake build` succeeds; `#check` confirms Banach completeness and compact-subset diffeomorphism invariance.
8. `Geometry.Manifold.SobolevSection`: `lake build` succeeds; `#check` confirms atlas-independence norm equivalence on compact manifolds.
9. `Analysis.PDE.GeometricBase`: `lake build` succeeds; `#check` and `#print axioms` confirm `weakEllipticSolvability` and `waveEnergyBound` typecheck against `SobolevSection` with only standard axioms.

### Open Decisions for Mathlib Reviewer
- Connection interface in `PseudoRiemannian.LeviCivita`:
  - Option A (extend upstream `CovariantDerivative.Basic` directly): lower duplication, higher refactor cost if upstream v4.36.0 lacks non-Riemannian hooks.
  - Option B (local typeclass plus equivalence bridge): faster initial build, higher maintenance and upstreaming friction.
- `LocalSobolevSpace` foundation:
  - Option A (restrict upstream `TemperedDistribution` Sobolev spaces): reuses `Mathlib.Analysis.Distribution.Sobolev` directly, adds boundary-extension work.
  - Option B (define distributional derivatives directly on open `U`): cleaner interior theory, duplicates distributional infrastructure.
- Scoped instances in `PseudoRiemannian.RiemannianInterop` (open, owned by the Phase 1 lead): the architecture exports scoped instances in namespace `PseudoRiemannian.Riemannian` for `Bundle.RiemannianBundle`, `IsContMDiffRiemannianBundle`, and `IsRiemannianManifold`, but the existing Mathlib instance at VectorBundle/Riemannian.lean:264 already registers `RiemannianBundle` (plus `IsContMDiffRiemannianBundle`) from any `ContMDiffRiemannianMetric`. The fix cycle could not resolve from the evidence whether the scoped instances create a second live registration path or are needed despite that instance, so no resolution is asserted here. The Phase 1 lead must decide, before any Phase 1 file registers instances: drop the scoped instances, or record exactly why each is needed, naming each instance. The converted metric is one registration path, not a guaranteed sole source. The registration instance at Mathlib/Geometry/Manifold/VectorBundle/Riemannian.lean:264-268 registers `RiemannianBundle E` from any `ContMDiffRiemannianMetric`, and `RiemannianBundle` is indexed by `E`, not by the metric, so two distinct `(n, 0)` metrics, or one converted metric plus an ambient `RiemannianBundle`, can collide in a typeclass diamond. The priority-80 scoped fiber instances at Mathlib/Topology/VectorBundle/Riemannian.lean:431 (`NormedAddCommGroup`) and :453 (`InnerProductSpace`) in v4.36.0 can also be shadowed where a default-priority fiber `NormedAddCommGroup` wins synthesis. This diamond and shadowing risk is an owned open design decision, owner Phase 1 lead, decision point named above. Sources: verdict-phase1-planning-v02.md (GAP-C); check-log-phase1-planning-v03.md item 7. See docs/InteropExample.md for the same open decision.

## Generator verification notes (not Neon output)

- Wrong path, fixed in fix cycle 1: Neon wrote `Mathlib.Geometry.Manifold.Riemannian.Distance`
  and claimed its v4.36.0 leaf paths were verified in Step 0. That file does not exist
  in v4.36.0 (contents API 404, 26 Nov 2026). The v4.36.0 Riemannian directory holds
  only Basic.lean and PathELength.lean, and riemannianEDist is still in PathELength.lean.
  The RiemannianInterop imports line now uses PathELength.lean and no longer carries
  the false verification claim. The dependency graph above uses the correct PathELength.lean path, as Neon wrote
  in its second call.
- Wrong path, fixed in fix cycle 1: Neon's first call header wrote
  `Mathlib.Geometry.Manifold.CovariantDerivative.Basic`, missing the VectorBundle
  segment. The correct path is
  `Mathlib.Geometry.Manifold.VectorBundle.CovariantDerivative.Basic`, as Neon wrote
  in its second call and as verified on the v4.36.0 tag. The header now uses the correct path.
- LocalFrame path, verified on v4.36.0 (amended 27 Nov 2026, run stage2-mathlib-geometry-planning-docs-01): the Metric imports list
  `Mathlib.Geometry.Manifold.VectorBundle.LocalFrame`. That module had 0 hits
  in the local v4.23.0 tree, which was the flag in fix cycle 1. It is verified
  to exist on v4.36.0 at Mathlib/Geometry/Manifold/VectorBundle/LocalFrame.lean
  (check-log-phase1-planning-v03.md item 6), so that Step 0 sub-item is closed
  and no replacement path is needed. The other imports in this file were checked in fix cycle 1 against the local
  v4.23.0 tree: Tangent, SmoothSection, MFDeriv.Atlas, BilinearForm.Properties,
  QuadraticForm.Real, Riemannian.Basic, and Riemannian.PathELength all exist there.
  The CovariantDerivative, Sobolev, and TemperedDistribution paths are v4.36.0
  target paths, absent in v4.23.0 by design, verified by the generator on the
  v4.36.0 tag per docs/BaselineDecision.md.
- Step 0 import-check gate, noted 27 Nov 2026, run stage2-mathlib-geometry-planning-docs-01: no Lean import check of the documented imports against pinned v4.36.0 has run. The v4.36.0 inventory in these docs rests on grep, API, and source reads. The audit re-run failed because the local olean cache is partial (ChartedSpace.olean and MDifferentiable.olean missing; a Metric.lean check timed out at 300s). The owned Step 0 gate is to run the import check with a full olean cache before any Phase 1 file uses the imports, owner Phase 1 lead. Sources: verdict-phase1-planning-v02.md (GAP-F); check-log-phase1-planning-v03.md, audit re-run section.
- Signature ordering, locked 26 Nov 2026: the lock is (p, q) = (pluses, minuses), Lorentzian (3, 1), Riemannian (n, 0). The RFCs were amended at docs/RFC_PseudoRiemannian.md lines 37-40 and docs/RFC_Conventions.md line 78. The earlier open-conflict note in this file is withdrawn; the stale Open Decisions item above was removed in the same amendment (27 Nov 2026, run stage2-mathlib-geometry-planning-docs-01). Source: verdict-phase1-planning-v02.md, condition 3.
- Statements each module must serve: the math author (Astra) states them in
  docs/DownstreamExamples.md, docs/SobolevRoutes.md, and docs/InteropExample.md.
  The module list above states the downstream theorem or computation each module
  enables, as Neon's hostile review demanded.
