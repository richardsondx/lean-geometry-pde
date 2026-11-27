# astra-log.md, stage2-mathlib-geometry-phase1-planning-01

Date: 26 Nov 2026. Model: openai/gpt-6.2-astra, via
~/workspace/custom-connectors/custom.openrouter-chat/bin/or_chat.py,
prompt via stdin only, never argv.
Role: MATHEMATICIAN. Astra authors U2 downstream failing examples, U4
Sobolev routes, U5 interop math, and the statements each architecture
module must serve. Astra's versions are authoritative for the math content.
Neon authors the architecture (U1, U3, U6 structure), see neon-log.md.
Cost: the tool prints assistant text only and reports no dollar figure,
so no dollar spend is claimed here. Do not invent one.
Marking: every block below is labeled VERBATIM ASTRA (exact reply text)
or PROMPT (exact prompt sent) or GENERATOR NOTE (my synthesis or
verification, not model output).

## Call 1: downstream examples and interop math (U2, U5)

- Model id: openai/gpt-6.2-astra
- max_tokens: 12000
- Result: exit 0, complete reply, 3674 bytes, 12 lines. Ends with a full
  sentence on the light-cone obstruction.

### PROMPT (call 1, verbatim)

You are the MATHEMATICIAN (GPT-6.2 Astra) for Phase 1 planning of a Lean math library: a general pseudo-Riemannian metric layer for Mathlib, with Levi-Civita, curvature, and Ricci, plus the Sobolev and PDE base it needs. You author the math content. Another model authors the architecture; do not write architecture, module lists, or dependency graphs. Use ONLY the verified facts below. Do not invent Mathlib file paths, line numbers, or Lean names.

VERIFIED FACTS, all checked 26 Nov 2026 against the local Mathlib v4.23.0 tree (commit 37df177aaa770670452312393d4e84aaad56e7b6) and live GitHub sources:

A. Four Lean probes run 26 Nov 2026 with `lake env lean` against the v4.23.0 tree, each failing with the exact error shown:
1. File importing Mathlib.Geometry.Manifold.VectorBundle.Riemannian, line `#check @CovariantDerivative`, error: Unknown identifier `CovariantDerivative`.
2. File importing Mathlib.Analysis.Distribution.SchwartzSpace, line `#check @TemperedDistribution.MemSobolev`, error: Unknown identifier `TemperedDistribution.MemSobolev`.
3. Same import, line `#check @HasWeakDerivAt`, error: Unknown identifier `HasWeakDerivAt`.
4. File importing Mathlib.Geometry.Manifold.Riemannian.Basic, line `#check @MeasureTheory.integral_stokes`, error: Unknown identifier `MeasureTheory.integral_stokes`.

B. Present in v4.23.0, with file and line: Bundle.ContMDiffRiemannianMetric, structure, Mathlib/Geometry/Manifold/VectorBundle/Riemannian.lean:238, fields inner, symm, pos (0 < inner b v v for v != 0), isVonNBounded (the set {v | inner b v v < 1} is von Neumann bounded), contMDiff. Bundle.RiemannianBundle, class, Mathlib/Topology/VectorBundle/Riemannian.lean:420, single field g : RiemannianMetric E. IsContMDiffRiemannianBundle, class, Mathlib/Geometry/Manifold/VectorBundle/Riemannian.lean:62. IsRiemannianManifold, class, Mathlib/Geometry/Manifold/Riemannian/Basic.lean:77, single field out: edist x y = riemannianEDist I x y. Manifold.riemannianEDist, Mathlib/Geometry/Manifold/Riemannian/PathELength.lean:205. The instance `instance (g : ContMDiffRiemannianMetric IB n F E) : RiemannianBundle E` plus `IsContMDiffRiemannianBundle IB n F E` is declared in VectorBundle/Riemannian.lean right after the structure. Two scoped instances (priority 80, Bundle namespace) in Topology/VectorBundle/Riemannian.lean give NormedAddCommGroup and InnerProductSpace on each fiber from a RiemannianBundle instance. The Lorentzian obstruction is recorded in the Hilbert6 source: the boundedness condition is false for a Lorentzian form, since the set {v | g(v,v) < 1} contains the whole light cone.

C. Hilbert6 LeviCivita file (404 lines, pinned commit ddbe9da) first import is Mathlib.Geometry.Manifold.VectorBundle.CovariantDerivative.Torsion, which does not exist in v4.23.0. It defines IsMetricCompatibleWith, IsLeviCivitaFor, koszul, uniqueness, koszulConnection, exists_isLeviCivitaFor, leviCivita. It defines no ChristoffelSymbol of its own and no curvature.

D. PR 36128 (open, unmerged, mergeable false) head adds CovariantDerivative structure (Basic.lean line 276), IsLeviCivitaConnection as a Prop (LeviCivita.lean line 199), LeviCivitaConnection as a chosen connection (line 859), ChristoffelSymbol (line 881), and NO Riemann curvature. The same API landed in Mathlib by another route: present in v4.29.0 and v4.36.0, absent in v4.24.0 through v4.28.0. In v4.36.0, IsLeviCivitaConnection is a public structure with a Koszul formula lemma and a uniqueness theorem.

E. Note on names: HasWeakDerivAt was a probe name used to test for a weak-derivative API; it does not exist in v4.23.0, and no weak-derivative API was found by grep under any name checked (HasWeakDeriv, WeakDeriv, HasDistribDeriv all return 0 hits in the v4.23.0 tree). Do not assert that HasWeakDerivAt exists in any newer Mathlib; that was not verified.

YOUR OUTPUT, two sections, planning only, short plain bullets, no em dashes, no slogans, no Lean code blocks with definitions or proofs, under 1000 words:

SECTION 1, downstream examples. One minimal failing downstream example per alleged blocker, four in total: (1) Levi-Civita missing, (2) Sobolev Bessel route missing, (3) Hilbert6 Levi-Civita not portable, (4) PseudoRiemannianMetric generalisation interop. For each: state in prose the exact Lean statement that cannot be written or checked, name the probe or file and line where it fails using facts A to D above, and name the exact API that would unblock it. For (4), name the instance conflicts (what breaks if a second RiemannianBundle instance is declared alongside the one derived from the (n, 0) metric) and the lost lemmas (what stops working if the (n, 0) metric is never registered as a RiemannianBundle: the fiber norm, the InnerProductSpace instance, IsRiemannianManifold, riemannianEDist).

SECTION 2, interop math. State the rule for how the (n, 0) case interoperates with Bundle.ContMDiffRiemannianMetric without duplicate instances: the conversion must be a plain def, not an instance; the RiemannianBundle registration must come from exactly one place; scoped instances stay scoped. Name which fields of ContMDiffRiemannianMetric a (p, q) metric with p > 0 cannot supply (pos and isVonNBounded) and why (light cone argument from fact B).

### VERBATIM ASTRA REPLY (call 1, complete)

**Section 1. Downstream examples**

- **Levi-Civita.** Given a smooth finite-dimensional Riemannian metric, state that there exists a unique torsion-free, metric-compatible covariant derivative on the tangent bundle. In v4.23.0, probe A1 stops at the type of the witness: `#check @CovariantDerivative` reports `Unknown identifier` after importing `Mathlib.Geometry.Manifold.VectorBundle.Riemannian`. The later API supplies `CovariantDerivative`, the predicate `IsLeviCivitaConnection`, and the chosen `LeviCivitaConnection`; v4.36.0 also has the uniqueness theorem. This example does not require curvature.
- **Sobolev, Bessel route.** For a tempered distribution \(u\) on \(\mathbb R^d\), state that \(u\) belongs to \(H^0\) if and only if its Fourier transform is represented by an \(L^2\) function. Probe A2 fails on `#check @TemperedDistribution.MemSobolev` after importing `Mathlib.Analysis.Distribution.SchwartzSpace`. The requested API is `TemperedDistribution.MemSobolev` with the Bessel characterization: at order \(s\), the distribution \((1+|\xi|^2)^{s/2}\widehat u\) is represented by an \(L^2\) function. Order zero is the minimal test; it needs no weak-derivative API.
- **Hilbert6 portability.** Under the hypotheses of the pinned Hilbert6 construction, state that its chosen `leviCivita` satisfies `IsLeviCivitaFor` for the input metric. Checking that statement against v4.23.0 stops before either name is defined: the first import of the Hilbert6 LeviCivita file at `ddbe9da` is `Mathlib.Geometry.Manifold.VectorBundle.CovariantDerivative.Torsion`, absent in that tree. The immediate unblocker is the compatible covariant-derivative and torsion API expected by that import. The file itself supplies `koszulConnection`, `exists_isLeviCivitaFor`, and `leviCivita`.
- **Metric interop.** Given a smooth finite-dimensional metric \(g\) of signature \((n,0)\), state that the squared fiber norm obtained through its Riemannian registration equals \(g_b(v,v)\). This is a conversion and instance-coherence obligation, not a recorded failed probe. The target is `Bundle.ContMDiffRiemannianMetric` at `Mathlib/Geometry/Manifold/VectorBundle/Riemannian.lean:238`; its registration follows the structure. A second `Bundle.RiemannianBundle` alongside that registration gives competing choices of metric and hence of fiber `NormedAddCommGroup` and `InnerProductSpace`. Typeclass search choosing one does not make both norms definitionally equal. With no registration, neither the fiber norm nor the `InnerProductSpace` is supplied **by this metric**. For a tangent metric, results about `Manifold.riemannianEDist` and the `IsRiemannianManifold` equality then cannot be used through this metric either. Registration alone does not prove that equality.

**Section 2. Interop math**

- Convert the \((n,0)\) metric to `Bundle.ContMDiffRiemannianMetric` by a plain definition, not an instance. Retain `inner`, `symm`, and `contMDiff`; positive definiteness gives `pos`, and in finite dimension the positive-definite unit ball is bounded, giving `isVonNBounded`.
- Use the existing registration from that converted metric as the sole source of `Bundle.RiemannianBundle`, with the existing `IsContMDiffRiemannianBundle` instance. Keep the two priority-80 fiber instances in the `Bundle` scope.
- With \((n,0)\) denoting positive signature, **\(p>0\) alone is not an obstruction**. For mixed signature \(p,q>0\), a negative vector violates `pos`. A nonzero null vector \(v\) violates `isVonNBounded`: the entire line \(tv\) lies in \(\{w\mid g(w,w)<1\}\), since \(g(tv,tv)=0\) for every real \(t\). This is the light-cone obstruction, not a failure of smoothness or symmetry.

### GENERATOR NOTE (call 1)

- Astra's correction to the earlier Neon draft: with (n, 0) denoting positive
  signature, p > 0 alone is not an obstruction. The obstruction is mixed
  signature. Astra's version is authoritative for the math.
- Astra's "probe A1" is generator probe 1, "probe A2" is generator probe 2.
  Both probes were run by the generator with the exact errors quoted.

## Call 2: Sobolev routes (U4)

- Model id: openai/gpt-6.2-astra
- max_tokens: 12000
- Result: exit 0, complete reply, 3981 bytes, 21 lines. Ends with a full
  sentence on the v4.23.0 ordering.

### PROMPT (call 2, verbatim)

You are the MATHEMATICIAN (GPT-6.2 Astra) for Phase 1 planning of a Lean math library. Author the Sobolev routes section (U4). Another model authors the architecture; do not write architecture, module lists, or dependency graphs. Use ONLY the verified facts below. Do not invent Mathlib file paths, line numbers, or Lean names.

VERIFIED FACTS, checked 26 Nov 2026:

A. In Mathlib v4.23.0: no TemperedDistribution, no TemperedDistribution.MemSobolev, no BesselPotentialSpace, no W^{k,p} space on domains, no weak-derivative API under any name checked (HasWeakDeriv, WeakDeriv, HasDistribDeriv all return 0 hits in the whole tree; the probe name HasWeakDerivAt fails with Unknown identifier). Present: SchwartzMap, VectorFourier.fourierIntegral, MeasureTheory.MemLp and Lp with Holder and Minkowski, and one Sobolev inequality, MeasureTheory.eLpNorm_le_eLpNorm_fderiv_one, Mathlib/Analysis/FunctionalSpaces/SobolevInequality.lean:437, which is an inequality, not a space.

B. In Mathlib v4.36.0 and on master: Mathlib/Analysis/Distribution/Sobolev.lean and TemperedDistribution.lean exist, with TemperedDistribution.besselPotential, TemperedDistribution.MemSobolev (s : R) (p : R>=0inf), and theorems: Schwartz functions lie in every Sobolev space (SchwartzMap.memSobolev), derivatives lower the order by 1 (MemSobolev.lineDerivOp), the Laplacian lowers it by 2 (MemSobolev.laplacian). No text matching "weak" appears in master Sobolev.lean, DerivNotation.lean, or TemperedDistribution.lean, and no SobolevSpace file exists. So on either baseline the weak-derivative W^{k,p} route is a build, not a consume; only the Bessel route is consumable, and only on v4.36.0, not on v4.23.0 or v4.29.0.

C. Phase 3 acceptance tests from the plan: (1) H^1 functions on R^n satisfy the Sobolev embedding, proved in Lean for the cases claimed; (2) the linear wave equation on Minkowski space has an energy estimate, proved in Lean; (3) a function decaying like r^{-1} at infinity lies in the claimed weighted space, proved in Lean. Phase 3 definitions: W^{k,p} on open subsets of R^n through weak derivatives, H^s through the Bessel potential, Sobolev embeddings, Poincare inequality, trace theorem, weighted Sobolev spaces H^s_delta for asymptotic flatness, Sobolev spaces of tensor fields on a manifold, energy currents and divergence theorem on Lorentzian domains, Gronwall and basic energy estimates for the linear wave equation.

D. The Phase 0 false dichotomy, now corrected: missing TemperedDistribution does NOT force Phase 3 to build tempered distributions first. Standard W^{k,p} spaces can be defined via weak derivatives or completion without Bessel potential spaces. The two routes are not either/or; each serves different statements.

YOUR OUTPUT: docs/SobolevRoutes.md content. For each route (weak-derivative W^{k,p} and Bessel potential H^{s,p}), state: what it is in one paragraph, what it needs that exists today and what must be built, and the specific Phase 3 statement it must serve, naming the theorem, its hypotheses, and what it is used for, drawn from fact C. Say plainly which route serves which statement, and where the two routes must be proved to agree. State the ordering consequence: which route comes first on the v4.36.0 baseline and why, and what changes if the baseline stays on v4.23.0. Planning only, short plain bullets, no em dashes, no slogans, no Lean code blocks with definitions or proofs, under 900 words. Do not assert that a weak-derivative API name exists in any Mathlib version.

### VERBATIM ASTRA REPLY (call 2, complete)

# U4. Sobolev routes

## Weak-derivative route: \(W^{k,p}(\Omega)\)

- For an open set \(\Omega\subseteq\mathbb R^n\) and a nonnegative integer \(k\), require \(u\) and its weak derivatives through order \(k\) to belong to \(L^p(\Omega)\). A weak derivative is specified by an integration-by-parts identity against smooth test functions compactly supported in \(\Omega\). This definition does not require tempered distributions.
- **Available and missing:** v4.23.0 has `MeasureTheory.MemLp`, `Lp`, Hölder and Minkowski. `MeasureTheory.eLpNorm_le_eLpNorm_fderiv_one` is an inequality for functions with a derivative, not a definition of \(W^{k,p}\). On either baseline, build the weak-derivative formulation and the domain space.
- **Phase 3 use:** Use this route for the **Poincaré inequality** and **trace theorem** on domains. For Poincaré, state the domain and normalization hypotheses under which a derivative bound controls the function. For trace, state the domain and regularity hypotheses under which a boundary value is defined and controlled. Phase 3 names both theorems but does not fix these hypotheses.
- **Energy estimate (acceptance test 2):** Use weak first derivatives for the finite-energy formulation. The theorem is an energy estimate for a solution of the **linear wave equation on Minkowski space**. Specify the data and solution regularity in the claimed case. The space expresses integrability of derivatives; the estimate itself still needs the energy-current and divergence argument on the Lorentzian domain, with Gronwall as needed.

## Bessel potential route: \(H^{s,p}(\mathbb R^n)\)

- Measure real-order regularity of a tempered distribution by requiring its Bessel potential of order \(s\) to be represented by an \(L^p\) function. Use \(p=2\) for \(H^s\). This is a whole-space definition, not a definition of weak derivatives on open subsets.
- **Available and missing:** On v4.36.0, use `TemperedDistribution.besselPotential` and `TemperedDistribution.MemSobolev`. `SchwartzMap.memSobolev` supplies Schwartz examples; `MemSobolev.lineDerivOp` and `MemSobolev.laplacian` lower the order by one and two, respectively. These results do not supply the Phase 3 embedding. On v4.23.0, `SchwartzMap` and `VectorFourier.fourierIntegral` are available, but the tempered-distribution and Bessel Sobolev ingredients must be supplied to take this route.
- **Sobolev embedding (acceptance test 1):** State the theorem for \(u\in H^1(\mathbb R^n)\) in the Bessel sense. Fix the dimension and target integrability exponent for each claimed case, then prove the corresponding integrability bound. Fact C does not specify the cases.
- **Weighted membership (acceptance test 3):** The target is membership in \(H^s_\delta\) for a function with \(r^{-1}\) decay at infinity, for use in asymptotic flatness. Build the weighted definition and specify the weight convention, \(s,\delta\), local regularity and any derivative decay needed in the claimed case. Unweighted Bessel membership is not this test, and a decay rate at infinity alone does not specify Sobolev regularity.

## Agreement and order

- **Required bridge:** On \(\mathbb R^n\), prove agreement of weak \(W^{1,2}\) with Bessel \(H^1\), including the norm comparison needed to transfer an estimate. Use it when a weak-derivative embedding is invoked for the Bessel acceptance test, or a weak energy bound is stated in \(H^1\) terms. This does not identify a space on an arbitrary open domain with a whole-space Bessel space.
- **v4.36.0:** Take the Bessel route first for the whole-space \(H^1\) statement because its membership predicate and order-lowering results are usable. Build the weak route for domain and energy statements, then prove the bridge.
- **v4.23.0:** Start with weak \(W^{k,p}\) using the existing \(L^p\) tools. Domain and integer-order work need not wait for tempered distributions. The Bessel definition and the bridge remain obligations for the planned \(H^s\) formulation.

### GENERATOR NOTE (call 2)

- Astra does not assert any weak-derivative API name exists upstream, as
  instructed. The weak route is framed as a build on either baseline.
- Astra notes the plan does not fix the dimension, target exponent, or weight
  convention for the Phase 3 acceptance tests. Those stay open choices.
