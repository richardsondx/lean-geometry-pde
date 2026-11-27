# neon-log.md, stage2-mathlib-geometry-phase1-planning-01

Date: 26 Nov 2026. Model: google/gemini-4-neon, via
~/workspace/custom-connectors/custom.openrouter-chat/bin/or_chat.py,
prompt via stdin only, never argv.
Role: ARCHITECT. Neon authors U1 architecture, U3 baseline decision,
U6 missing inventory structure. Neon does not author the math content
(U2, U4, U5); Astra does that, see astra-log.md.
Cost: the tool prints assistant text only and reports no dollar figure,
so no dollar spend is claimed here. Do not invent one.
Marking: every block below is labeled VERBATIM NEON (exact reply text)
or PROMPT (exact prompt sent) or GENERATOR NOTE (my synthesis or
verification, not model output).

## Call 1: architecture core (U1)

- Model id: google/gemini-4-neon
- max_tokens: 16000
- Result: exit 0, reply returned but CUT OFF mid-sentence at the end of
  the `PseudoRiemannian.Musical` exports line. Completed by call 2.
  Reply length: 4237 bytes, 32 lines.

### PROMPT (call 1, verbatim)

You are the lead architect for Phase 1 planning of a Lean math library: a general pseudo-Riemannian metric layer for Mathlib, with Levi-Civita, curvature, and Ricci, plus the Sobolev and PDE base it needs. You called the Phase 0 audit a trivial grep session. Now you do the architecture yourself. Do not review a draft. Author it.

VERIFIED FACTS YOU MUST BUILD ON (checked 26 Nov 2026 against the local Mathlib v4.23.0 tree, commit 37df177aaa770670452312393d4e84aaad56e7b6, and live GitHub sources):

Present in Mathlib v4.23.0: ChartedSpace, IsManifold, ModelWithCorners, ContMDiff, TangentBundle, TangentSpace, VectorBundle, VectorField.mlieBracket, IsMIntegralCurve, LieGroup, Bundle.RiemannianBundle, Bundle.ContMDiffRiemannianMetric, IsContMDiffRiemannianBundle, IsRiemannianManifold, Manifold.riemannianEDist, Bochner integral, MemLp, Lp, Minkowski, Holder, Fubini, Tonelli, fourierIntegral, SchwartzMap, one Sobolev inequality (eLpNorm_le_eLpNorm_fderiv_one, an inequality not a space), NormedSpace, CompleteSpace, InnerProductSpace, NormedAddCommGroup, Picard-Lindelof, gronwallBound, Gronwall inequality.

Absent in v4.23.0 (each confirmed by a failing Lean #check with error Unknown identifier, run 26 Nov 2026): CovariantDerivative, IsLeviCivitaConnection, LeviCivitaConnection, ChristoffelSymbol, TemperedDistribution, TemperedDistribution.MemSobolev, BesselPotentialSpace, SmoothRiemannianMetric, HasWeakDerivAt, any manifold Stokes theorem, any geodesic or exponential map, any Riemann or Ricci curvature, any Laplace-Beltrami operator, any W^{k,p} space on domains, any compact embedding (no Rellich), any elliptic/parabolic/hyperbolic PDE infrastructure. Present but flat-space only: laplacian on normed spaces (Mathlib/Analysis/InnerProductSpace/Laplacian.lean:135), divergence theorem for box integrals on Fin n -> R (Mathlib/Analysis/BoxIntegral/DivergenceTheorem.lean:258), Lax-Milgram for bilinear forms on Hilbert space (Mathlib/Analysis/InnerProductSpace/LaxMilgram.lean:102, continuousLinearEquivOfBilin). Exterior algebra exists as linear algebra only; no differential form type and no exterior derivative on manifolds exist.

PR 36128 (Levicivita minimal, by grunweg, created 4 Mar 2026) is still open and unmerged, mergeable false, last updated 19 Sep 2026. Its head (8968a1246) adds 4 new files (CovariantDerivative Prelim 1009 lines, Basic 1030, Torsion 338, LeviCivita 1158), 2 new helper files (Misc 152, Tensoriality 214), and edits 6 existing files (Mathlib.lean, MFDeriv/Atlas, MFDeriv/NormedSpace, VectorBundle/LocalFrame, VectorField/LieBracket, VectorField/Pullback). Its LeviCivita file is Riemannian-only, takes a RiemannianBundle instance, defines IsLeviCivitaConnection as a Prop, LeviCivitaConnection as a chosen connection, ChristoffelSymbol, and defines NO Riemann curvature at all, so it carries no Riemann sign to conflict with. BUT the same API has since landed in Mathlib by another route: CovariantDerivative/Basic.lean is absent in v4.24.0 through v4.27.0 and present in v4.29.0 and in v4.36.0 (latest release, 16 Nov 2026), where IsLeviCivitaConnection is a public structure with a Koszul formula lemma and a uniqueness theorem. The Sobolev Bessel layer also landed: Mathlib/Analysis/Distribution/Sobolev.lean and TemperedDistribution.lean exist on master and in v4.36.0, with TemperedDistribution.MemSobolev and besselPotential; they are absent in v4.29.0.

Hilbert6 (formerly Physicslib4, repo hilbert6/hilbert6, pinned commit ddbe9da, Lean 4.35.0, Mathlib rev 56a005855ea1) has: Spacetime structure (line 119) with LorentzianAt diag(-1,1,1,1); PseudoRiemannianMetric structure (line 59) with fields val, symm, nondegenerate, contMDiff, no signature parameter; musical isomorphisms bijective_val, flatEquiv, contMDiff_flatEquiv_symm; LeviCivita layer with Koszul formula, uniqueness, existence, leviCivita, but no curvature, no Ricci, no contraction API, smoothness fixed at C-infinity. Its LeviCivita file imports the PR 36128 Torsion file, so it does not build on v4.23.0.

LOCKED DECISIONS FROM PHASE 0 (do not reopen, build on them): one general PseudoRiemannianMetric with signature (p, q) as data, Riemannian as the (n, 0) case, no parallel class; signature (-, +, +, +) for relativity; Riemann R(X,Y)Z = nabla_X nabla_Y Z - nabla_Y nabla_X Z - nabla_[X,Y] Z; Ricci as trace Z maps to R(Z,X)Y; Einstein G = Ric - (1/2) R g; tensors as bundle sections, contraction as trace, raising and lowering only through musical isomorphisms.

YOUR OWN HOSTILE REVIEW POINTS YOU MUST NOW ANSWER IN THE ARCHITECTURE (not in prose about them, in the design itself): presence is not usability, so every module must state the exact downstream theorem or computation it enables; no module may exist only because a name exists. The (n, 0) case must show concretely how it interoperates with Bundle.ContMDiffRiemannianMetric: that structure has pos and isVonNBounded fields (a Lorentzian form fails both, since the set {v | g(v,v) < 1} contains the whole light cone), and its instance registers RiemannianBundle plus IsContMDiffRiemannianBundle, which in turn supplies the scoped NormedAddCommGroup and InnerProductSpace instances on tangent spaces and feeds IsRiemannianManifold and Manifold.riemannianEDist. Name where the single-instance rule lives so no duplicate RiemannianBundle instance can appear.

YOUR OUTPUT: the full text of docs/ARCHITECTURE.md. Structure it as: (1) module list with one line each saying what downstream theorem or computation it enables; (2) per module: imports (exact Mathlib modules or PR files), exports (definitions and theorems, named), forbids (what it must not depend on or define); (3) dependency graph in plain text (module A depends on module B); (4) the (n, 0) interop rule; (5) build order with what is checkable at each step; (6) open decisions left for the Mathlib reviewer, each with the cost of each option. Keep it planning only: no Lean code blocks with definitions or proofs, no sorry, no claim that anything is proved. Short plain bullets. No em dashes anywhere. No slogans. Under 1500 words.

### VERBATIM NEON REPLY (call 1, cut off at the end)

# docs/ARCHITECTURE.md

Target baseline: upgrade the local Mathlib pin from v4.23.0 to v4.36.0 in Step 0. This consumes upstream `Mathlib.Geometry.Manifold.CovariantDerivative.Basic`, `Mathlib.Analysis.Distribution.Sobolev`, and `Mathlib.Analysis.Distribution.TemperedDistribution` instead of duplicating them or importing unmerged PR 36128. Signature `(p, q)` denotes `p` positive and `q` negative eigenvalues, so Riemannian is `(n, 0)` and 4D Lorentzian `(-, +, +, +)` is `(3, 1)` with coordinate 0 timelike.

## 1. Module List

- `PseudoRiemannian.Metric`: enables constructing Riemannian `(n, 0)` and Lorentzian `(3, 1)` `(-, +, +, +)` metrics on `ContMDiff` manifolds from one signature-parameterized structure.
- `PseudoRiemannian.RiemannianInterop`: enables applying `IsRiemannianManifold`, `Manifold.riemannianEDist`, and tangent `InnerProductSpace` lemmas to `(n, 0)` metrics without duplicate instances.
- `PseudoRiemannian.Musical`: enables smooth index raising and lowering in the Koszul formula and metric contractions via bundle isomorphisms.
- `PseudoRiemannian.TensorContraction`: enables forming the Ricci tensor as a frame-independent trace of Riemann curvature and scalar curvature as a metric contraction of Ricci.
- `PseudoRiemannian.LeviCivita`: enables computing the unique torsion-free metric-compatible connection and local Christoffel symbols for arbitrary `(p, q)` metrics.
- `PseudoRiemannian.Curvature`: enables computing the `(1, 3)` Riemann tensor `R(X, Y)Z = nabla_X nabla_Y Z - nabla_Y nabla_X Z - nabla_[X,Y] Z` and proving the first and second Bianchi identities.
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
- Imports: `PseudoRiemannian.Metric`, `Mathlib.Geometry.Manifold.Riemannian.Basic`, `Mathlib.Geometry.Manifold.Riemannian.Distance` (exact v4.36.0 leaf paths verified in Step 0 for `Bundle.ContMDiffRiemannianMetric` and `Manifold.riemannianEDist`).
- Exports: `PseudoRiemannianMetric.pos_of_q_eq_zero`, `PseudoRiemannianMetric.isVonNBounded_of_q_eq_zero`, `PseudoRiemannianMetric.toContMDiffRiemannianMetric`, `Bundle.ContMDiffRiemannianMetric.toPseudoRiemannianMetric` (plain `def`, not an instance), scoped instances in namespace `PseudoRiemannian.Riemannian` for `Bundle.RiemannianBundle`, `IsContMDiffRiemannianBundle`, and `IsRiemannianManifold`.
- Forbids: global `instance` declarations for `Bundle.RiemannianBundle`, `NormedAddCommGroup`, or `InnerProductSpace`; importing `CovariantDerivative`, curvature, or Sobolev modules.

### `PseudoRiemannian.Musical`
- Imports: `PseudoRiemannian.Metric`, `Mathlib.Geometry.Manifold.MFDeriv.Atlas`, `Mathlib.Geometry.Manifold.VectorBundle.SmoothSection`.
- Exports: `PseudoRiemannianMetric.flatEquiv` (`TM` to `T*M`),

### GENERATOR NOTE (call 1)

- The reply ends mid-sentence at `flatEquiv` (`TM` to `T*M`),. The tool
  returned exit 0 with a truncated reply. Per the task rule for cut-off calls,
  one retry was made with a narrower prompt (call 2 below).
- Two errors in this reply, corrected in docs/ARCHITECTURE.md: the path
  `Mathlib.Geometry.Manifold.Riemannian.Distance` does not exist in v4.36.0
  (contents API 404; the directory holds only Basic.lean and PathELength.lean),
  and the header path `Mathlib.Geometry.Manifold.CovariantDerivative.Basic`
  is missing the VectorBundle segment.

## Call 2: architecture completion (U1, retry of call 1)

- Model id: google/gemini-4-neon
- max_tokens: 12000
- Result: exit 0, complete reply, 8675 bytes, 90 lines. Ends with a full
  section (open decisions). This is the one allowed retry after the call 1
  cut-off, with a narrower prompt.

### PROMPT (call 2, verbatim)

You are the same lead architect. Your architecture draft was cut off mid-sentence at the end of the `PseudoRiemannian.Musical` exports line ("Exports: `PseudoRiemannianMetric.flatEquiv` (`TM` to `T*M`),"). Complete ONLY the missing remainder, in the same format. Do not repeat sections 1, Metric, or RiemannianInterop.

Complete, in order:
1. Finish `PseudoRiemannian.Musical` (exports, forbids).
2. `PseudoRiemannian.TensorContraction`: imports, exports, forbids. It must enable Ricci as a frame-independent trace of Riemann and scalar curvature as a metric contraction of Ricci.
3. `PseudoRiemannian.LeviCivita`: imports (it consumes upstream Mathlib v4.36.0 `CovariantDerivative.Basic` and `CovariantDerivative.LeviCivita`, not PR 36128), exports, forbids. It must enable the unique torsion-free metric-compatible connection and Christoffel symbols for arbitrary (p, q) metrics.
4. `PseudoRiemannian.Curvature`: imports, exports, forbids. Riemann R(X,Y)Z = nabla_X nabla_Y Z - nabla_Y nabla_X Z - nabla_[X,Y] Z, first and second Bianchi identities.
5. `PseudoRiemannian.RicciEinstein`: imports, exports, forbids. Ricci, scalar curvature, Einstein tensor G = Ric - (1/2) R g, contracted Bianchi div G = 0.
6. `Analysis.Sobolev.LocalDomain`, `Geometry.Manifold.SobolevSection`, `Analysis.PDE.GeometricBase`: one short imports/exports/forbids line set each. They consume upstream v4.36.0 `Mathlib.Analysis.Distribution.Sobolev` and `TemperedDistribution`. They must enable chart-level W^{k,p} on open sets, W^{k,p} of bundle sections on manifolds, and weak elliptic solvability via Lax-Milgram plus wave energy bounds via Gronwall.
7. Dependency graph in plain text, one line per edge.
8. Build order, each step with what Lean check proves it done.
9. Open decisions for the Mathlib reviewer, each with the cost of each option. Include one item: the (p, q) ordering is disputed, Phase 0 locked (p, q) as (minuses, pluses) with Lorentzian (1, 3), your draft used (pluses, minuses) with Lorentzian (3, 1). State both and say the choice must be locked before any file is written.

Planning only: no Lean code blocks with definitions or proofs, no sorry, no claim anything is proved. Short plain bullets. No em dashes anywhere. No slogans. Under 900 words. Do not invent Mathlib file paths; use only paths already established: Mathlib.Geometry.Manifold.VectorBundle.CovariantDerivative.Basic, Mathlib.Geometry.Manifold.VectorBundle.CovariantDerivative.LeviCivita, Mathlib.Analysis.Distribution.Sobolev, Mathlib.Analysis.Distribution.TemperedDistribution, Mathlib.Geometry.Manifold.Riemannian.Basic, Mathlib.Geometry.Manifold.Riemannian.PathELength.

### VERBATIM NEON REPLY (call 2, complete)

`PseudoRiemannianMetric.sharpEquiv` (`T*M` to `TM`), `PseudoRiemannianMetric.inverseMetric` (induced nondegenerate pairing on `T*M`), `flat_sharp`, `sharp_flat`, smooth bundle-isomorphism lemmas.
- Forbids: coordinate matrix inversion as primary definition; positive-definiteness assumptions; connections or curvature.

### `PseudoRiemannian.TensorContraction`
- Imports: `PseudoRiemannian.Metric`, `PseudoRiemannian.Musical`.
- Exports: `BundleEnd.trace` (frame-independent fiberwise trace on `End(TM)`), `Tensor.contract` (pairing one covariant and one contravariant slot), `PseudoRiemannianMetric.metricTrace` (contracting two covariant slots via `sharpEquiv` and `BundleEnd.trace`), smoothness of contracted sections, chart-level trace identity.
- Forbids: coordinate-dependent primary definitions; positive-definite inner product assumptions; connections or curvature.

### `PseudoRiemannian.LeviCivita`
- Imports: `PseudoRiemannian.Metric`, `PseudoRiemannian.Musical`, `Mathlib.Geometry.Manifold.VectorBundle.CovariantDerivative.Basic`, `Mathlib.Geometry.Manifold.VectorBundle.CovariantDerivative.LeviCivita`.
- Exports: `IsMetricCompatible` for arbitrary `(p, q)` metrics, `IsTorsionFree`, Koszul formula, `PseudoRiemannianMetric.leviCivita` (existence and uniqueness of the torsion-free metric-compatible connection for any nondegenerate signature `(p, q)`), `PseudoRiemannianMetric.christoffel` (chart symbols and transformation law), compatibility with upstream Riemannian Levi-Civita in the positive-definite case.
- Forbids: importing PR 36128 or unmerged forks; restricting uniqueness to positive-definite metrics; curvature definitions.

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
- Imports: `PseudoRiemannian.Metric`, `PseudoRiemannian.LeviCivita`, `PseudoRiemannian.TensorContraction`, `Geometry.Manifold.SobolevSection`.
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

### Build Order
1. `PseudoRiemannian.Metric`: `lake build` succeeds; `#print axioms` on Minkowski metric reports only standard Lean axioms.
2. `PseudoRiemannian.RiemannianInterop` and `PseudoRiemannian.Musical` (parallel): `lake build` succeeds; `#check` confirms positive-definite bridge to `Riemannian.Basic` plus `flat_sharp` and `sharp_flat`.
3. `PseudoRiemannian.TensorContraction`: `lake build` succeeds; `#check` confirms `metricTrace` of the metric equals manifold dimension and matches chart trace.
4. `PseudoRiemannian.LeviCivita`: `lake build` succeeds; `#check` confirms uniqueness, Christoffel formula for arbitrary `(p, q)`, and agreement with upstream `CovariantDerivative.LeviCivita`.
5. `PseudoRiemannian.Curvature`: `lake build` succeeds; `#check` confirms `C^infty`-multilinearity of `riemannEnd`, symmetries of `riemannCov`, and both Bianchi identities.
6. `PseudoRiemannian.RicciEinstein`: `lake build` succeeds; `#check` and `#print axioms` confirm `ricciTensor` symmetry and `contractedSecondBianchi` (`div G = 0`) use only standard axioms.
7. `Analysis.Sobolev.LocalDomain`: `lake build` succeeds; `#check` confirms Banach completeness and compact-subset diffeomorphism invariance.
8. `Geometry.Manifold.SobolevSection`: `lake build` succeeds; `#check` confirms atlas-independence norm equivalence on compact manifolds.
9. `Analysis.PDE.GeometricBase`: `lake build` succeeds; `#check` and `#print axioms` confirm `weakEllipticSolvability` and `waveEnergyBound` typecheck against `SobolevSection` with only standard axioms.

### Open Decisions for Mathlib Reviewer
- Signature `(p, q)` ordering (disputed; must be locked before any file is written):
  - Option A (Phase 0 lock): `(p, q) = (minuses, pluses)`, Lorentzian is `(1, 3)`. Cost: differs from Sylvester `(pluses, minuses)` in algebra texts and makes Riemannian metrics `(0, n)`.
  - Option B (architecture draft): `(p, q) = (pluses, minuses)`, Lorentzian is `(3, 1)`. Cost: breaks Phase 0 artifacts and departs from `(1, n-1)` physics conventions, requiring Phase 0 edits.
- Connection interface in `PseudoRiemannian.LeviCivita`:
  - Option A (extend upstream `CovariantDerivative.Basic` directly): lower duplication, higher refactor cost if upstream v4.36.0 lacks non-Riemannian hooks.
  - Option B (local typeclass plus equivalence bridge): faster initial build, higher maintenance and upstreaming friction.
- `LocalSobolevSpace` foundation:
  - Option A (restrict upstream `TemperedDistribution` Sobolev spaces): reuses `Mathlib.Analysis.Distribution.Sobolev` directly, adds boundary-extension work.
  - Option B (define distributional derivatives directly on open `U`): cleaner interior theory, duplicates distributional infrastructure.

## Call 3: downstream examples and interop (math content, SUPERSEDED)

- Model id: google/gemini-4-neon
- max_tokens: 12000
- Result: exit 0, complete reply, 7695 bytes, 32 lines.
- Status: SUPERSEDED for the math content. This call was made before the
  role clarification. Under the role split, Astra authors U2, U4, U5 and
  Astra's versions are authoritative. Neon's draft below is kept in the log
  only. Verified facts in it were re-used in the Astra prompts.

### PROMPT (call 3, verbatim)

You are the same lead architect. Author two more sections for the Phase 1 plan. Use ONLY the verified facts below. Do not invent Mathlib file paths, line numbers, or Lean names. Where a fact is given, use it exactly.

VERIFIED FACTS, all checked 26 Nov 2026 against the local Mathlib v4.23.0 tree (commit 37df177aaa770670452312393d4e84aaad56e7b6) and live GitHub sources:

A. Four Lean probes run 26 Nov 2026 with `lake env lean` against the v4.23.0 tree, each failing with the exact error shown:
1. File importing Mathlib.Geometry.Manifold.VectorBundle.Riemannian, line `#check @CovariantDerivative`, error: Unknown identifier `CovariantDerivative`.
2. File importing Mathlib.Analysis.Distribution.SchwartzSpace, line `#check @TemperedDistribution.MemSobolev`, error: Unknown identifier `TemperedDistribution.MemSobolev`.
3. Same import, line `#check @HasWeakDerivAt`, error: Unknown identifier `HasWeakDerivAt`.
4. File importing Mathlib.Geometry.Manifold.Riemannian.Basic, line `#check @MeasureTheory.integral_stokes`, error: Unknown identifier `MeasureTheory.integral_stokes`.

B. Present in v4.23.0, with file and line: Bundle.ContMDiffRiemannianMetric, structure, Mathlib/Geometry/Manifold/VectorBundle/Riemannian.lean:238, fields inner, symm, pos (0 < inner b v v for v != 0), isVonNBounded (the set {v | inner b v v < 1} is von Neumann bounded), contMDiff. Bundle.RiemannianBundle, class, Mathlib/Topology/VectorBundle/Riemannian.lean:420, single field g : RiemannianMetric E. IsContMDiffRiemannianBundle, class, Mathlib/Geometry/Manifold/VectorBundle/Riemannian.lean:62. IsRiemannianManifold, class, Mathlib/Geometry/Manifold/Riemannian/Basic.lean:77, single field out: edist x y = riemannianEDist I x y. Manifold.riemannianEDist, Mathlib/Geometry/Manifold/Riemannian/PathELength.lean:205. The instance `instance (g : ContMDiffRiemannianMetric IB n F E) : RiemannianBundle E` plus `IsContMDiffRiemannianBundle IB n F E` is declared in VectorBundle/Riemannian.lean right after the structure. Two scoped instances (priority 80, Bundle namespace) in Topology/VectorBundle/Riemannian.lean give NormedAddCommGroup and InnerProductSpace on each fiber from a RiemannianBundle instance. The Lorentzian obstruction is recorded in the Hilbert6 source: the boundedness condition is false for a Lorentzian form, since the set {v | g(v,v) < 1} contains the whole light cone.

C. Hilbert6 LeviCivita file (404 lines, pinned commit ddbe9da) first import is Mathlib.Geometry.Manifold.VectorBundle.CovariantDerivative.Torsion, which does not exist in v4.23.0. It defines IsMetricCompatibleWith, IsLeviCivitaFor, koszul, uniqueness, koszulConnection, exists_isLeviCivitaFor, leviCivita. It defines no ChristoffelSymbol of its own and no curvature.

D. PR 36128 (open, unmerged, mergeable false) head adds CovariantDerivative structure (Basic.lean line 276), IsLeviCivitaConnection as a Prop (LeviCivita.lean line 199), LeviCivitaConnection as a chosen connection (line 859), ChristoffelSymbol (line 881), and NO Riemann curvature. The same API landed in Mathlib by another route: present in v4.29.0 and v4.36.0, absent in v4.24.0 through v4.28.0. In v4.36.0, IsLeviCivitaConnection is a public structure with a Koszul formula lemma and a uniqueness theorem.

YOUR OUTPUT, two sections, planning only, short plain bullets, no em dashes, no slogans, no Lean code blocks with definitions or proofs, under 1000 words:

SECTION 1, downstream examples. One minimal failing downstream example per alleged blocker, four in total: (1) Levi-Civita missing, (2) Sobolev Bessel route missing, (3) Hilbert6 Levi-Civita not portable, (4) PseudoRiemannianMetric generalisation interop. For each: state in prose the exact Lean statement that cannot be written or checked, name the probe or file and line where it fails using facts A to D above, and name the exact API that would unblock it. For (4), use fact B: name the instance conflicts (what breaks if a second RiemannianBundle instance is declared alongside the one derived from the (n, 0) metric) and the lost lemmas (what stops working if the (n, 0) metric is never registered as a RiemannianBundle: the fiber norm, the InnerProductSpace instance, IsRiemannianManifold, riemannianEDist).

SECTION 2, interop rule. State the rule for how the (n, 0) case interoperates with Bundle.ContMDiffRiemannianMetric without duplicate instances: the conversion must be a plain def, not an instance; the RiemannianBundle registration must come from exactly one place; scoped instances stay scoped. Name which fields of ContMDiffRiemannianMetric a (p, q) metric with p > 0 cannot supply (pos and isVonNBounded) and why (light cone argument from fact B).

### VERBATIM NEON REPLY (call 3, complete, superseded for math content)

SECTION 1. Downstream examples

1. Levi-Civita missing
- Unwritable statement: In a file importing `Mathlib.Geometry.Manifold.VectorBundle.Riemannian`, checking `#check @CovariantDerivative` or stating that a Riemannian bundle admits a unique Levi-Civita covariant derivative and associated Christoffel symbols.
- Failure point: Lean probe 1 (run 26 Nov 2026 against v4.23.0, commit `37df177aaa770670452312393d4e84aaad56e7b6`) imports `Mathlib.Geometry.Manifold.VectorBundle.Riemannian` and fails on `#check @CovariantDerivative` with `Unknown identifier CovariantDerivative`. This API is also absent in v4.24.0 through v4.28.0.
- Unblocking API: `CovariantDerivative` (`Basic.lean` line 276 in PR 36128), `IsLeviCivitaConnection` (`LeviCivita.lean` line 199 in PR 36128, and a public structure with a Koszul formula lemma and uniqueness theorem in v4.36.0), `LeviCivitaConnection` (`LeviCivita.lean` line 859), and `ChristoffelSymbol` (`LeviCivita.lean` line 881). PR 36128 itself is open, unmerged, and has mergeable false, while the same API is present in Mathlib v4.29.0 and v4.36.0 (without Riemann curvature).

2. Sobolev Bessel route missing
- Unwritable statement: In a file importing `Mathlib.Analysis.Distribution.SchwartzSpace`, checking `#check @TemperedDistribution.MemSobolev` or `#check @HasWeakDerivAt`, or stating that a tempered distribution belongs to a Sobolev space or has a weak derivative at a point.
- Failure point: Lean probes 2 and 3 (run 26 Nov 2026 against v4.23.0, commit `37df177aaa770670452312393d4e84aaad56e7b6`) both import `Mathlib.Analysis.Distribution.SchwartzSpace`. Probe 2 fails on `#check @TemperedDistribution.MemSobolev` with `Unknown identifier TemperedDistribution.MemSobolev`. Probe 3 fails on `#check @HasWeakDerivAt` with `Unknown identifier HasWeakDerivAt`.
- Unblocking API: `TemperedDistribution.MemSobolev` and `HasWeakDerivAt` available alongside `Mathlib.Analysis.Distribution.SchwartzSpace`.

3. Hilbert6 Levi-Civita not portable
- Unwritable statement: Importing the 404-line Hilbert6 LeviCivita file (pinned commit `ddbe9da`) into the v4.23.0 tree to use `IsMetricCompatibleWith`, `IsLeviCivitaFor`, `koszul`, `uniqueness`, `koszulConnection`, `exists_isLeviCivitaFor`, or `leviCivita`.
- Failure point: The first import of the Hilbert6 LeviCivita file (commit `ddbe9da`) is `Mathlib.Geometry.Manifold.VectorBundle.CovariantDerivative.Torsion`, which does not exist in v4.23.0 (matching probe 1 failing on `#check @CovariantDerivative`). In addition, that file defines no `ChristoffelSymbol` of its own and no curvature.
- Unblocking API: `Mathlib.Geometry.Manifold.VectorBundle.CovariantDerivative.Torsion` and the underlying covariant derivative API, or moving to Mathlib v4.29.0 or v4.36.0 where `CovariantDerivative`, `IsLeviCivitaConnection`, `LeviCivitaConnection`, and `ChristoffelSymbol` are present.

4. PseudoRiemannianMetric generalisation interop
- Unwritable statement: Constructing a `Bundle.ContMDiffRiemannianMetric` directly from a Lorentzian form, or using a signature `(n, 0)` metric from a general `(p, q)` structure together with Mathlib's Riemannian bundle and manifold distance API without colliding instances.
- Failure point: `Bundle.ContMDiffRiemannianMetric` (`Mathlib/Geometry/Manifold/VectorBundle/Riemannian.lean:238`) requires `pos` (`0 < inner b v v` for `v != 0`) and `isVonNBounded` (`{v | inner b v v < 1}` is von Neumann bounded). As recorded in the Hilbert6 source, `isVonNBounded` fails for a Lorentzian form because `{v | g(v,v) < 1}` contains the whole light cone.
- Instance conflicts: `Mathlib/Geometry/Manifold/VectorBundle/Riemannian.lean` already declares `instance (g : ContMDiffRiemannianMetric IB n F E) : RiemannianBundle E` and `IsContMDiffRiemannianBundle IB n F E` right after line 238, targeting `Bundle.RiemannianBundle` (`Mathlib/Topology/VectorBundle/Riemannian.lean:420`, single field `g : RiemannianMetric E`) and `IsContMDiffRiemannianBundle` (`Mathlib/Geometry/Manifold/VectorBundle/Riemannian.lean:62`). Declaring a second `RiemannianBundle E` instance alongside the one derived from the `(n, 0)` metric creates duplicate `RiemannianBundle E` instances, causing typeclass diamonds on `g : RiemannianMetric E` and breaking synthesis for the two scoped priority 80 `Bundle`-namespace instances in `Mathlib/Topology/VectorBundle/Riemannian.lean` (`NormedAddCommGroup` and `InnerProductSpace` on each fiber).
- Lost lemmas and API if never registered: If the `(n, 0)` metric is never registered as a `Bundle.RiemannianBundle`, downstream code loses the scoped priority 80 fiber `NormedAddCommGroup` (fiber norm) and `InnerProductSpace` instances from `Mathlib/Topology/VectorBundle/Riemannian.lean`, loses `IsContMDiffRiemannianBundle` (`Mathlib/Geometry/Manifold/VectorBundle/Riemannian.lean:62`), and cannot use `IsRiemannianManifold` (`Mathlib/Geometry/Manifold/Riemannian/Basic.lean:77`, field `out: edist x y = riemannianEDist I x y`) or `Manifold.riemannianEDist` (`Mathlib/Geometry/Manifold/Riemannian/PathELength.lean:205`).
- Unblocking API: A separate `(p, q)` metric structure omitting `pos` and `isVonNBounded`, paired with a plain `def` converting the `(n, 0)` case to `Bundle.ContMDiffRiemannianMetric` so Mathlib's existing `RiemannianBundle` instance supplies the fiber instances, `IsContMDiffRiemannianBundle`, `IsRiemannianManifold`, and `Manifold.riemannianEDist`.

SECTION 2. Interop rule

- Conversion as a plain `def`: The conversion from a `(n, 0)` metric to `Bundle.ContMDiffRiemannianMetric` (`Mathlib/Geometry/Manifold/VectorBundle/Riemannian.lean:238`) must be a plain `def`, never an `instance`.
- Single `RiemannianBundle` registration: Registration of `Bundle.RiemannianBundle` (`Mathlib/Topology/VectorBundle/Riemannian.lean:420`) and `IsContMDiffRiemannianBundle` (`Mathlib/Geometry/Manifold/VectorBundle/Riemannian.lean:62`) must come from exactly one place. Rely on Mathlib's existing `instance (g : ContMDiffRiemannianMetric IB n F E) : RiemannianBundle E` plus `IsContMDiffRiemannianBundle IB n F E` in `Mathlib/Geometry/Manifold/VectorBundle/Riemannian.lean` applied to the output of the plain `def`, and do not declare any second `RiemannianBundle` instance on the `(n, 0)` metric type.
- Scoped instances stay scoped: Keep the two scoped instances (priority 80, `Bundle` namespace) in `Mathlib/Topology/VectorBundle/Riemannian.lean`, which provide `NormedAddCommGroup` and `InnerProductSpace` on each fiber from a `RiemannianBundle` instance, strictly scoped. Do not re-declare them globally or add competing fiber norm or inner product instances.
- Downstream access preserved: Registering the `(n, 0)` metric through that single `Bundle.ContMDiffRiemannianMetric` path preserves access to the scoped fiber `NormedAddCommGroup` and `InnerProductSpace` instances, `IsContMDiffRiemannianBundle`, `IsRiemannianManifold` (`Mathlib/Geometry/Manifold/Riemannian/Basic.lean:77`), and `Manifold.riemannianEDist` (`Mathlib/Geometry/Manifold/Riemannian/PathELength.lean:205`) without duplicate instances.
- Fields unavailable for `(p, q)` with `p > 0`: A `(p, q)` metric with `p > 0` can supply `inner`, `symm`, and `contMDiff` of `Bundle.ContMDiffRiemannianMetric` (`Mathlib/Geometry/Manifold/VectorBundle/Riemannian.lean:238`), but cannot supply `pos` (`0 < inner b v v` for `v != 0`) or `isVonNBounded` (`{v | inner b v v < 1}` is von Neumann bounded).
- Light cone obstruction: As recorded in the Hilbert6 source for a Lorentzian form, the set `{v | g(v,v) < 1}` contains the whole light cone and is therefore not von Neumann bounded, falsifying `isVonNBounded`; nonzero vectors on the light cone also fail `pos` (`0 < inner b v v` for `v != 0`).

### GENERATOR NOTE (call 3)

- Neon's example 2 unblocking API names `HasWeakDerivAt` as if it exists
  upstream. That was not verified: HasWeakDerivAt was a probe name only, and
  no weak-derivative API was found by grep in v4.23.0 or by text search in
  master Sobolev.lean, DerivNotation.lean, or TemperedDistribution.lean.
  Astra's version (astra-log.md call 1) does not repeat this claim.
- Neon's "a (p, q) metric with p > 0 cannot supply pos and isVonNBounded"
  is corrected by Astra: with (n, 0) denoting positive signature, p > 0 alone
  is not an obstruction; mixed signature is the obstruction. Astra's version
  is authoritative for the math.

## Call 4: baseline decision and missing inventory (U3, U6)

- Model id: google/gemini-4-neon
- max_tokens: 12000
- Result: exit 0, complete reply, 7970 bytes, 40 lines. Ends with a full
  section (hyperbolic PDE infrastructure).

### PROMPT (call 4, verbatim)

You are the ARCHITECT (Gemini 4 Neon), not the mathematician. Author two more sections for the Phase 1 plan: the baseline decision (U3) and the missing-inventory structure (U6). Use ONLY the verified facts below. Do not invent file paths, line numbers, or Lean names. Do not write math content (downstream examples, Sobolev routes, interop proofs); another model authors those.

VERIFIED FACTS, checked 26 Nov 2026:

BASELINE AND PR 36128:
- Local baseline is Lean 4.23.0, Mathlib v4.23.0, commit 37df177aaa770670452312393d4e84aaad56e7b6.
- PR 36128 (Levicivita minimal, by grunweg, created 4 Mar 2026) is still open, merged false, mergeable false, last updated 19 Sep 2026, head 8968a1246e09fbe77e70282027173874e5c3f437, base master.
- PR file list (13 files, GitHub API): 4 new CovariantDerivative files (Prelim 1009 lines, Basic 1030, Torsion 338, LeviCivita 1158); 2 new helper files (Misc 152, Tensoriality 214); 6 modified files (Mathlib.lean +6, MFDeriv/Atlas +41, MFDeriv/NormedSpace +21, VectorBundle/LocalFrame +95/-3, VectorField/LieBracket +123/-23, VectorField/Pullback +21/-4); plan.mde +12.
- Dependency depth beyond the first import: Prelim imports 10 Mathlib modules (SmoothSection, Tangent, MFDeriv/FDeriv, MFDeriv/SpecificFunctions, BumpFunction, Notation, Misc, Tensoriality, LieBracket, IsManifold/InteriorBoundary). Misc and Tensoriality are NEW files inside the PR, so vendoring must include them. Basic imports Prelim plus the same 10. Torsion imports Basic only. LeviCivita imports InnerProductSpace/Dual, Torsion, VectorBundle/Riemannian, Util/PrintSorries. The 6 modified files carry diffs that vendoring must also port; the largest edits are VectorField/LieBracket (+123/-23) and VectorBundle/LocalFrame (+95/-3).
- The PR defines NO Riemann curvature at all, so it carries no Riemann sign to reconcile with the locked convention. Its LeviCivita file is Riemannian-only and takes a RiemannianBundle instance.
- The same covariant derivative API landed in Mathlib by another route: absent in v4.24.0 through v4.28.0 (contents API 404 each), present in v4.29.0 and v4.36.0. In v4.36.0, CovariantDerivative is a structure (Basic.lean:366) and IsLeviCivitaConnection is a public structure with a Koszul formula lemma and a uniqueness theorem.
- The Sobolev Bessel layer also landed upstream: Mathlib/Analysis/Distribution/Sobolev.lean and TemperedDistribution.lean exist on master and in v4.36.0 (with TemperedDistribution.MemSobolev and besselPotential), absent in v4.29.0 (contents API 404 for Sobolev.lean at v4.29.0).
- Latest Mathlib release is v4.36.0, published 16 Nov 2026.
- Satellites: Hilbert6 pins Lean 4.35.0 and Mathlib rev 56a005855ea1; Hamilton three-manifold project paper-time snapshot Lean 4.29.0 / Mathlib v4.29.0, current main Lean v4.35.0-rc3.

MISSING INVENTORY (all greps run 26 Nov 2026 over the whole v4.23.0 Mathlib tree):
- Differential forms: absent as a type, 0 hits for a DifferentialForm definition; exterior algebra and alternating maps exist only as linear algebra, no hits in Geometry/Manifold for ContinuousAlternatingMap.
- Exterior derivative: absent, 0 hits; only ExteriorPower and ExteriorAlgebra in linear algebra.
- Volume forms: only flat-space volumeForm, Mathlib/Analysis/InnerProductSpace/Orientation.lean:166; no manifold volume form.
- Manifold integration: absent; no volume measure on manifolds; only the Bochner integral on measure spaces.
- Stokes theorem: absent as a manifold theorem; flat box divergence theorem present, Mathlib/Analysis/BoxIntegral/DivergenceTheorem.lean:258 (hasIntegral_GP_divergence_of_forall_hasDerivWithinAt).
- Geodesics: absent; no Geodesic definition, no expMap; the only matches for "geodesic" are false positives in combinatorics and group theory.
- Curvature: absent; 0 hits for Riemann or Ricci.
- Laplace-Beltrami operators: absent as such; flat laplacian present, Mathlib/Analysis/InnerProductSpace/Laplacian.lean:135 (def laplacian), laplacianWithin at line 124.
- Weak derivatives: absent; 0 hits for HasWeakDeriv, WeakDeriv, HasDistribDeriv; the Distribution directory holds only AEEqOfIntegralContDiff.lean, FourierSchwartz.lean, SchwartzSpace.lean.
- W^{k,p} spaces on domains: absent; only Sobolev inequality theorems, Mathlib/Analysis/FunctionalSpaces/SobolevInequality.lean (eLpNorm_le_eLpNorm_fderiv_one at line 437).
- Compact embeddings: absent; 0 hits for Rellich or CompactEmbedding.
- Lax-Milgram: PRESENT, Mathlib/Analysis/InnerProductSpace/LaxMilgram.lean:102 (continuousLinearEquivOfBilin).
- Elliptic, parabolic, hyperbolic PDE infrastructure: absent; no Mathlib/Analysis/PDE directory; the word hits for elliptic/parabolic/hyperbolic are unrelated complex analysis and special functions.
- Present context, already audited: SchwartzMap, Fourier transform, Lp spaces, one Sobolev inequality, Picard-Lindelof, Gronwall.

YOUR OUTPUT, two sections, planning only, short plain bullets, no em dashes, no slogans, no Lean code blocks with definitions or proofs, under 1200 words:

SECTION 1, baseline decision (U3). Recommend stay on v4.23.0 or name a target revision, with a reason. Give the vendoring cost for PR 36128 in lines and in what must be ported beyond the first import (new files, helper files, edited-file diffs). Give the PR dependency depth as a short chain. State what moving to v4.29.0 fixes and what it leaves open, and what moving to v4.36.0 fixes and what it leaves open. Answer GAP-4b (vendoring cost and newer revision unmeasured) and GAP-4d (baseline reason missing) by name. State the GAP-5b answer: the PR defines no curvature, so the Riemann sign trigger in RFC_Conventions cannot fire on this PR.

SECTION 2, missing inventory structure (U6). For each item in this exact list, give present, absent, or satellite, with the file path and line number from the facts above: differential forms, exterior derivative, volume forms, manifold integration, Stokes theorem, geodesics, curvature, Laplace-Beltrami operators, weak derivatives, W^{k,p} spaces on domains, compact embeddings, Lax-Milgram, elliptic PDE infrastructure, parabolic PDE infrastructure, hyperbolic PDE infrastructure. For each absent item, name the nearest present neighbour that a Phase 1 or Phase 3 build can start from (for example flat laplacian for Laplace-Beltrami, box divergence theorem for Stokes). Do not claim any of these items exist in a newer Mathlib unless the facts above say so.

### VERBATIM NEON REPLY (call 4, complete)

## Section 1: Baseline Decision (U3)

* **Target revision recommendation (answers GAP-4d):** Move from the local baseline (Lean 4.23.0, Mathlib v4.23.0, commit `37df177aaa770670452312393d4e84aaad56e7b6`) to Mathlib v4.36.0 (latest release, published 16 Nov 2026). Do not stay on v4.23.0 with a vendored PR 36128, and do not stop at v4.29.0.
* **Reason for target baseline (answers GAP-4d):** Mathlib v4.36.0 supplies both the upstream covariant derivative / Levi-Civita API and the upstream Sobolev Bessel distribution layer without carrying a large, unmerged backport. It also aligns closely with active satellite branches (Hilbert6 on Lean 4.35.0, Mathlib rev `56a005855ea1`; Hamilton three-manifold current main on Lean v4.35.0-rc3).
* **PR 36128 vendoring cost (answers GAP-4b):** PR 36128 (`Levicivita minimal`, created 4 Mar 2026, last updated 19 Sep 2026, head `8968a1246e09fbe77e70282027173874e5c3f437`, base `master`) remains open, `merged` false, and `mergeable` false. Vendoring it onto v4.23.0 requires porting 13 files (3,901 new Lean lines plus +307 / -30 edited lines across core Mathlib files):
  * 4 new `CovariantDerivative` files (3,535 lines): `Prelim` (1,009), `Basic` (1,030), `Torsion` (338), `LeviCivita` (1,158).
  * 2 new helper files required by the PR (366 lines): `Misc` (152), `Tensoriality` (214).
  * 6 modified Mathlib files whose diffs must be ported (+307 / -30 lines): `VectorField/LieBracket` (+123 / -23), `VectorBundle/LocalFrame` (+95 / -3), `MFDeriv/Atlas` (+41), `MFDeriv/NormedSpace` (+21), `VectorField/Pullback` (+21 / -4), `Mathlib.lean` (+6).
  * 1 non-code file: `plan.mde` (+12).
* **PR 36128 dependency depth:**
  * `LeviCivita` -> `Torsion` (plus `InnerProductSpace/Dual`, `VectorBundle/Riemannian`, `Util/PrintSorries`).
  * `Torsion` -> `Basic`.
  * `Basic` -> `Prelim` (plus the same 10 Mathlib modules imported by `Prelim`).
  * `Prelim` -> 10 modules: new helpers `Misc` and `Tensoriality`, modified `VectorField/LieBracket`, plus `SmoothSection`, `Tangent`, `MFDeriv/FDeriv`, `MFDeriv/SpecificFunctions`, `BumpFunction`, `Notation`, and `IsManifold/InteriorBoundary` (with remaining diffs in `MFDeriv/Atlas`, `MFDeriv/NormedSpace`, `VectorBundle/LocalFrame`, `VectorField/Pullback`, and `Mathlib.lean`).
* **Moving to v4.29.0 (answers GAP-4b):**
  * Fixes: includes the upstream covariant derivative API (absent in v4.24.0 through v4.28.0), eliminates PR 36128 vendoring, and matches the Hamilton three-manifold paper-time snapshot (Lean 4.29.0 / Mathlib v4.29.0).
  * Leaves open: `Mathlib/Analysis/Distribution/Sobolev.lean` is absent (404 at v4.29.0), leaving the Sobolev Bessel layer missing; trails Hilbert6 (Lean 4.35.0) and Hamilton current main (Lean v4.35.0-rc3); leaves the v4.23.0 missing-inventory items unverified or absent.
* **Moving to v4.36.0 (answers GAP-4b):**
  * Fixes: includes the upstream covariant derivative API (`CovariantDerivative` structure at `Basic.lean:366`; public `IsLeviCivitaConnection` structure with Koszul formula lemma and uniqueness theorem) and the upstream Sobolev Bessel layer (`Mathlib/Analysis/Distribution/Sobolev.lean` and `TemperedDistribution.lean`, including `TemperedDistribution.MemSobolev` and `besselPotential`), with zero PR 36128 vendoring cost.
  * Leaves open: requires upgrading across 13 releases from local v4.23.0, reconciling minor toolchain skew with satellites pinned at Lean 4.35.0 / v4.35.0-rc3, and re-auditing the absent geometry and PDE inventory items on v4.36.0.
* **Riemann sign trigger check (answers GAP-5b):** PR 36128 defines no Riemann curvature at all; its `LeviCivita` file is Riemannian-only and takes a `RiemannianBundle` instance. Because no curvature is defined, the PR carries no Riemann sign convention, and the Riemann sign trigger in `RFC_Conventions` cannot fire on this PR.

## Section 2: Missing Inventory Structure (U6)

* **Audit scope:** All statuses below come from the 26 Nov 2026 grep audit over the full Mathlib v4.23.0 tree. None of these 15 items are verified as satellite deliverables. Newer-Mathlib presence is noted only where explicitly verified above (`CovariantDerivative` / `IsLeviCivitaConnection` in v4.29.0 and v4.36.0; `Sobolev.lean` / `TemperedDistribution.lean` in v4.36.0).
* **Differential forms:** absent (0 hits for a `DifferentialForm` definition; 0 hits in `Geometry/Manifold` for `ContinuousAlternatingMap`). Nearest present neighbour: `ExteriorAlgebra`, `ExteriorPower`, and alternating maps in linear algebra.
* **Exterior derivative:** absent (0 hits). Nearest present neighbour: `ExteriorPower` and `ExteriorAlgebra` in linear algebra.
* **Volume forms:** absent on manifolds. Nearest present neighbour: flat-space `volumeForm` at `Mathlib/Analysis/InnerProductSpace/Orientation.lean:166`.
* **Manifold integration:** absent (no volume measure on manifolds). Nearest present neighbour: Bochner integral on measure spaces.
* **Stokes theorem:** absent as a manifold theorem. Nearest present neighbour: flat box divergence theorem `hasIntegral_GP_divergence_of_forall_hasDerivWithinAt` at `Mathlib/Analysis/BoxIntegral/DivergenceTheorem.lean:258`.
* **Geodesics:** absent (no `Geodesic` definition, no `expMap`; matches for "geodesic" are combinatorics and group theory false positives). Nearest present neighbour: Picard-Lindelof and Gronwall (plus `CovariantDerivative` / `IsLeviCivitaConnection` on upgrade to v4.29.0 or v4.36.0).
* **Curvature:** absent (0 hits for `Riemann` or `Ricci`). Nearest present neighbour: manifold vector-field and bundle modules (`Tangent`, `SmoothSection`, `VectorField/LieBracket`), plus `CovariantDerivative` (`Basic.lean:366`) and `IsLeviCivitaConnection` on upgrade to v4.29.0 or v4.36.0.
* **Laplace-Beltrami operators:** absent as such. Nearest present neighbour: flat `laplacian` at `Mathlib/Analysis/InnerProductSpace/Laplacian.lean:135` and `laplacianWithin` at `Mathlib/Analysis/InnerProductSpace/Laplacian.lean:124`.
* **Weak derivatives:** absent (0 hits for `HasWeakDeriv`, `WeakDeriv`, or `HasDistribDeriv`). Nearest present neighbour: v4.23.0 `Distribution` directory (`AEEqOfIntegralContDiff.lean`, `FourierSchwartz.lean`, `SchwartzSpace.lean`), `SchwartzMap`, and Fourier transform (plus `TemperedDistribution.lean` on upgrade to v4.36.0).
* **W^{k,p} spaces on domains:** absent. Nearest present neighbour: Sobolev inequality `eLpNorm_le_eLpNorm_fderiv_one` at `Mathlib/Analysis/FunctionalSpaces/SobolevInequality.lean:437` and Lp spaces (v4.36.0 adds `Mathlib/Analysis/Distribution/Sobolev.lean` with `TemperedDistribution.MemSobolev` and `besselPotential`, not verified as domain W^{k,p} spaces).
* **Compact embeddings:** absent (0 hits for `Rellich` or `CompactEmbedding`). Nearest present neighbour: `Mathlib/Analysis/FunctionalSpaces/SobolevInequality.lean:437` (`eLpNorm_le_eLpNorm_fderiv_one`) and Lp spaces.
* **Lax-Milgram:** present, `continuousLinearEquivOfBilin` at `Mathlib/Analysis/InnerProductSpace/LaxMilgram.lean:102`.
* **Elliptic PDE infrastructure:** absent (no `Mathlib/Analysis/PDE` directory; "elliptic" hits are unrelated complex analysis and special functions). Nearest present neighbour: Lax-Milgram (`Mathlib/Analysis/InnerProductSpace/LaxMilgram.lean:102`) and flat `laplacian` / `laplacianWithin` (`Mathlib/Analysis/InnerProductSpace/Laplacian.lean:135`, `:124`).
* **Parabolic PDE infrastructure:** absent (no `Mathlib/Analysis/PDE` directory; "parabolic" hits are unrelated complex analysis and special functions). Nearest present neighbour: flat `laplacian` (`Mathlib/Analysis/InnerProductSpace/Laplacian.lean:135`), Picard-Lindelof, Gronwall, `SchwartzMap`, and Fourier transform.
* **Hyperbolic PDE infrastructure:** absent (no `Mathlib/Analysis/PDE` directory; "hyperbolic" hits are unrelated complex analysis and special functions). Nearest present neighbour: flat `laplacian` (`Mathlib/Analysis/InnerProductSpace/Laplacian.lean:135`), Picard-Lindelof, Gronwall, `SchwartzMap`, and Fourier transform.

### GENERATOR NOTE (call 4)

- Neon's line counts re-checked by the generator against the PR files API:
  3,901 new lines (3,535 plus 366), +307 / -30 edited lines. Correct.
- Landing window re-checked: CovariantDerivative/Basic.lean 404 at v4.24.0
  through v4.28.0, 200 at v4.29.0 and v4.36.0. Sobolev.lean 404 at v4.29.0,
  200 at v4.36.0 and on master.
