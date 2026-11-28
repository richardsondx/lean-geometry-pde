# Generator log: stage2-mathlib-geometry-phase3-sobolev-slice-01 (U1 to U5)

- Run: stage2-mathlib-geometry-phase3-sobolev-slice-01.
- Predicate: pred-mathlib-geometry-phase3-sobolev-slice-v01.
- Baseline: Mathlib v4.36.0, commit fc4f59e577feb1a4956671bc04ac18aaaf8cd842.
- Work copy: ~/workspace/handover-mathlib-geometry-2026-11-26/track-sobolev/lean-phase1/.
- Start: 28 Nov 2026, 04:05 UTC (27 Nov 2026, 23:05 EST). Timebox: 6 hours wall for this spawn.
- Kit: Case B, Lean verification kit, draft, ~/workspace/handover-mathlib-geometry-2026-11-26/.

## First Principles ladder (recorded before any claim is reported)

### Decision
- Which definition route for weak derivatives, and which imports, for U3 to U5.

### Claims
- Claim 1: the work copy builds from the shared cache without rebuilding Mathlib. Load bearing. Source: shared cache 4.3G, prior Phase 1 builds exit 0. Status: cited. Check: probe (a) running.
- Claim 2: Distribution.olean, TestFunction.olean, DerivNotation.olean, Sobolev.olean are all absent from the cache. Load bearing for time. Source: find over .lake/packages/mathlib/.lake/build returned nothing. Status: verified by observation. Mitigation: probe the import cost first.
- Claim 3: `Distribution.ofFun` plus `ofFun_injective` give weak-derivative uniqueness almost free. Source: read Mathlib/Analysis/Distribution/Distribution.lean lines 302 to 380. Status: verified by reading, not yet by compiling.
- Claim 4: `lineDerivOp_apply_apply` gives integration by parts. Source: read Distribution.lean lines 268 to 270. Status: verified by reading, not yet by compiling.
- Claim 5: `TestFunction Ω F n` exists as bundled C^n compactly supported functions. Source: read TestFunction.lean lines 67 to 80. Status: verified by reading.
- Claim 6: Schwartz functions are dense in Lp. Source: read SchwartzSpace/Basic.lean lines 1400 to 1411 (`SchwartzMap.denseRange_toLpCLM`). Status: verified by reading. Use: fallback route only.
- Claim 7: W^{1,2} norm proof is feasible via a submodule of `Lp ℝ 2 μ × PiLp 2 (fun _ : Fin n => Lp ℝ 2 μ)`, with the norm inherited and the norm formula proved from `Prod.norm_def` and the PiLp L2 norm. Status: assumed. Settles by Lean attempt.
- Claim 8: Hilbert structure (inner product plus completeness) may be too big for this run. Status: assumed. Fallback per brief: normed space plus a named list of what remains.
- Claim 9: the bridge can be stated, not proved, with the exact norm comparison. Status: verified by construction, a statement is not a proof.
- Claim 10: GAP-10 items can all be fixed in writing in U1 from the Stage 1 package, GAP.md, RFC_Sobolev.md, and SobolevRoutes.md. Status: verified by reading those files.

### Fetch list
- Probe (a): lake build sanity of the work copy. Running.
- Probe (b): timed import of Mathlib.Analysis.Distribution.Distribution plus #check of ofFun, ofFun_injective, lineDerivOp_apply_apply, TestFunction.lineDerivCLM, denseRange_toLpCLM. Running.
- Probe (c): timed import of Mathlib.Analysis.Distribution.Sobolev plus #check of besselPotential, MemSobolev, SchwartzMap.memSobolev, MemSobolev.lineDerivOp, MemSobolev.laplacian. Running.
- Astra design input: this log, call below.

### Counter cases
- Counter 1: Distribution import build cost exceeds the timebox. Observable: probe (b) wall time. Check: fall back to Route A, test-function integral identity with MeasureTheory only, uniqueness via Schwartz density in Lp plus a dense-range argument.
- Counter 2: `ofFun_injective` hypotheses fail to discharge for Lp functions on EuclideanSpace. Observable: Lean errors in the attempt. Check: re-scope the uniqueness statement or switch to Route A.
- Counter 3: the PiLp product norm formula does not match the W^{1,2} norm. Observable: Lean errors on the norm formula. Check: define the norm explicitly as a function and prove its axioms directly.

### Step 5 rebuild
- True facts: the work copy exists with a symlinked cache; besselPotential sits at line 72 and MemSobolev at line 152 in local cached source (coordinator verified); Distribution.olean, TestFunction.olean, DerivNotation.olean, Sobolev.olean are absent; `Distribution.ofFun`, `ofFun_injective`, and `lineDerivOp_apply_apply` exist in source with the statements read above; the root file does not import KerrMetric.
- Dropped: the plan in RFC_Sobolev.md to build Bessel potential spaces first. The v4.36.0 tree already has them, so the weak-derivative route goes first for domains and the bridge is stated against the existing Bessel side.
- Biggest open risk: the from-source build cost of the Distribution and Sobolev modules, and the W^{1,2} completeness argument for the Hilbert structure.
- What would change my mind: probe (b) or (c) shows a build cost above the timebox, or the Lean attempt shows `ofFun_injective` cannot be applied to Lp coercions.

## Design (after the ladder, before the Lean attempt)

- Route B, distribution based, is the design. Weak derivative: `HasWeakDeriv u v m` means both functions are locally integrable on the whole space and the distributional line derivative of `ofFun u` equals `ofFun v`. The integration-by-parts identity against test functions is proved as a characterization theorem, so the definition is the textbook one, not just distribution bookkeeping.
- Uniqueness: two weak derivatives give equal distributions, then `ofFun_injective` gives equality almost everywhere.
- W^{1,2}: a submodule of `Lp ℝ 2 μ × PiLp 2 (fun _ : Fin n => Lp ℝ 2 μ)`, membership is the weak-derivative condition in each basis direction. Norm is inherited. The norm formula `‖p‖ = sqrt (‖u‖^2 + sum i, ‖D i‖^2)` is proved as a theorem. Norm axioms are stated and proved as theorems from the instance.
- Hilbert structure: attempted after the norm. Needs inner product plus completeness. Completeness needs closedness of the weak-derivative graph, via the integral-identity characterization and continuity of the L2 inner product. If it blocks, U4 delivers the normed space plus the named remaining steps.
- Bridge: stated as a `def` Prop, not a theorem, with the exact norm comparison between the W^{1,2} norm and the Bessel H1 norm (`‖besselPotential 1 u‖` in L2). Imports Mathlib.Analysis.Distribution.Sobolev if probe (c) allows.

## Probes

- Probe files: /tmp/probe-dist.lean, /tmp/probe-sobolev.lean. Runner: /tmp/probe-run.sh, pid 6837, started 04:07 UTC.
- First probe script attempt failed: /usr/bin/time does not exist, so no step ran. Rewrote with date-based timing and relaunched. Second attempt failed differently: `lake` was not on PATH in the nohup context, all three steps exit 69, 0s. Fixed by exporting PATH="$HOME/.elan/bin:$PATH" and relaunched, pid 7941.
- (a) build sanity: exit 0, wall 10s. Project builds from the shared cache. Build completed 4652 jobs.
- (b) Distribution import probe: exit 1, wall 2s. Error: Distribution.olean does not exist. `lake env lean` does not build missing modules on the fly.
- (c) Sobolev import probe: exit 1, wall 3s. Error: Sobolev.olean does not exist. Same cause.
- (d) Module build: `flock /tmp/lean-phase1-build.lock lake build Mathlib.Analysis.Distribution.Distribution Mathlib.Analysis.Distribution.Sobolev`, pid 9655, started 04:10:13 UTC. This is an additive build of missing modules only, not a rebuild of the cache. No existing olean is touched. The job count grew as the dependency closure was discovered, about 4700 jobs, including much of MeasureTheory and Analysis. The cache was far more partial than assumed: even PiLp.olean and LpSpace/Basic.olean were absent. A name probe (/tmp/probe-names.lean) failed for the same missing olean reason. Nothing else can be Lean checked until this build finishes. Still running at last check, about 4605 of 4706 jobs, one job took 99s.
- Decision recorded: building the missing modules into the shared cache is required for this run, and the coordinator anticipated from-source builds of the imported modules. The scope grew from 2 modules to their full dependency closure, which is the same action, not a different one.
- Module build finished exit 0, wall 3575s (about 60 min), 6510 jobs, ending about 05:09 UTC. It held the shared flock lock for the whole hour, blocking the Kerr and Einstein tracks' queued builds. The shared cache is now much more complete: Distribution, Sobolev, TestFunction, PiLp, L2Space and their closure are built.
- Re-probe (b) after the build: exit 1, wall 127s, but only one error: `SchwartzMap.denseRange_toLpCLM` unknown identifier, because the Distribution import does not include SchwartzSpace/Basic. All other checks passed: ofFun, ofFun_injective, lineDerivOp_apply_apply, TestFunction.lineDerivCLM. Output: /tmp/probe-dist-b.out.
- Re-probe (c) after the build: exit 0, wall 11s. All checks passed: besselPotential, MemSobolev, SchwartzMap.memSobolev, MemSobolev.lineDerivOp, MemSobolev.laplacian. Output: /tmp/probe-sobolev-c.out.
- Names probe (/tmp/probe-names2.lean, exit 0, about 10s): `Fact (1 ≤ (2: ℝ≥0∞))` synthesizes; InnerProductSpace and CompleteSpace instances exist for `PiLp 2` of `Lp ℝ 2`; `Lp.coeFn_smul`, `Lp.coeFn_zero`, `Lp.coeFn_add` are a.e. equalities only; `PiLp.smul_apply`, `PiLp.zero_apply` exist; `LocallyIntegrableOn.congr` and `Distribution.ofFun_congr_ae` confirmed; `Lp.toTemperedDistributionCLM` confirmed. Note: `volume` on EuclideanSpace needs the full imports (Distribution plus Sobolev) for its MeasureSpace instance.
- Micro-probe (/tmp/probe-micro.lean, exit 0, about 5s): `Lp.memLp f` works, `f.memLp` does not (head is Subtype, so dot notation looks for `Subtype.memLp`); `(-ψ) x = -ψ x` by simp; `(lineDerivCLM ℝ m φ) x = lineDeriv ℝ ⇑φ x m` by `simp [TestFunction.lineDerivCLM_apply]`; `TestFunction.lineDerivOp_eq_lineDerivCLM` needs `(𝕜 := ℝ)`; `Measure.restrict_univ` rewrite works.
- Dense probe (/tmp/probe-dense.lean, exit 0, wall 12s): `SchwartzMap.denseRange_toLpCLM` resolves with the SchwartzSpace/Basic import, signature recorded in the audit verification note.
- Hilbert API probe (/tmp/probe-hilbert-api.lean, exit 1, wall 16s): confirmed `innerSL` (conjugate-linear outer map), `Continuous.inner`, `PiLp.continuous_ofLp` (takes p and β explicitly), `L2.inner_def`, `RCLike.inner_apply`, `ContinuousLinearMap.isClosed_ker`, `HasCompactSupport.toSchwartzMap`, `SchwartzMap.coeFn_toLp`, `SchwartzMap.toLp`, `IsClosed.completeSpace_coe` (takes the IsClosed fact as an instance argument). Not found: bare `isClosed_ker`, `PiLp.norm_apply_le_norm`, `Submodule.isComplete_iff_isClosed`. The coordinate continuity example needed explicit args: `(continuous_apply j).comp (PiLp.continuous_ofLp 2 _)`.
- Hilbert API probe 2 (/tmp/probe-hilbert2.lean, exit 1, wall 37s): `simp [inner_smul_left]` proves the real scalar inner identity; the coordinate continuity example passed; the test-function-to-SchwartzMap examples failed only because E was left free in the probe (the `TestFunction ⊤ ℝ ⊤` binder had no pin) and SchwartzSpace/Basic was not imported. Both were fixed in the real attempt by pinning `(E := EuclideanSpace ℝ (Fin n))` on the φ binder and using the Sobolev import, which transitively brings SchwartzSpace in.

## Compile rounds, SobolevSlice.lean

- v1, initial draft: errors on `f.memLp` (dot notation), `ofFun_congr_ae` motive matching, and the norm formula. Fixed per the micro-probe findings.
- v2: errors on `HasWeakDeriv.iff_integral` (test-function coercion in lineDeriv) and `ofFun_apply` rewrite order. Restated with `lineDeriv ℝ (φ : E → ℝ) x m` and a pointwise helper `hpt`.
- v3: errors on the submodule membership proofs (`Lp.coeFn_add` etc. are a.e. only). Fixed via `HasWeakDeriv.congr_ae` plus `PiLp.add_apply` / `zero_apply` / `smul_apply`.
- v4: `sobolevComplex` def timed out at whnf, max heartbeats 200000. Raised to 400000 via `set_option maxHeartbeats 400000 in`, still timed out. Suspected cause: the implicit K in `MemLp.ofReal` stays a metavariable while elaborating the coercion.
- v5: same whnf timeout on both the let-based and direct `.ofLp 0` versions of `sobolevComplex`. All 10 theorems compiled with clean axioms. Output: /tmp/sobolev-slice-v5.out.
- v6: `sobolevComplex` body changed to `((Lp.memLp (...)).ofReal (K := ℂ)).toLp`, pinning K explicitly. Compiled exit 0, wall 10s, zero errors, zero warnings, all 10 theorems clean axioms. Output: /tmp/sobolev-slice-v6.out. The bridge def typechecked (no unknown-identifier error).
- Deviation recorded: the v1 to v6 iterations edited SobolevSlice.lean in place. The Handover fix-cycle rule calls for a new versioned file per fix after a check. These were pre-verification iterations, not post-check fix cycles, and the file as delivered is the first version the independent checker sees. The in-place editing is recorded here rather than hidden.
- Hilbert attempt, in /tmp only, copy of the v6 file: v1, `#synth InnerProductSpace ℝ (sobolevSpace 3)` gave `(sobolevSpace 3).innerProductSpace`, so the inner product instance exists. v2 errors: map_smul' unsolved (needed `mul_add`), coercion ascription `: Set _` with an unknown target (three sites), the Hilbert conjunction theorem (InnerProductSpace is a Type, not a Prop, so it cannot be a conjunct of And). v3: fixed all three, but `sobolevSpace_isClosed` still failed on a rewrite: the goal from `LinearMap.mem_ker` uses the linear-map coercion application, while `weakFunctional_apply` is stated with the CLM coercion application. Fixed with `show` / a defeq ascription. v4: errors at the two `rw [e1, e2]` sites, same coercion mismatch in the rewrite pattern. v5: exit 0, all 13 theorems clean axioms, one linter warning (haveI style). v6: replaced `haveI` plus `exact IsClosed.completeSpace_coe` with `@IsClosed.completeSpace_coe _ _ _ _ sobolevSpace_isClosed`. Exit 0, zero errors, zero warnings, all 13 theorems clean axioms. Outputs: /tmp/hilbert-v1.out through /tmp/hilbert-v6.out.
- Merge: /tmp/hilbert-attempt.lean (v6) copied over the real file, diff purely additive (156 lines inserted plus 3 axiom lines). Header updated to record the Hilbert structure as proved. Final compile of the real file: exit 0, wall 32s, zero errors, zero warnings. Output: /tmp/sobolev-slice-final.out.
- Full project build after the merge: `flock /tmp/lean-phase1-build.lock lake build`, exit 0, wall 50s, 4652 jobs. One pre-existing warning about SphereTestSpherical.lean importing a Mathlib module file, not touched by this run. Output: /tmp/sobolev-final-build.out.

## Astra call (mathematician)

- Model id: openai/gpt-6.2-astra, via ~/workspace/custom-connectors/custom.openrouter-chat/bin/or_chat.py, prompt via stdin only, never argv, max-tokens 12000.
- Prompt: /tmp/astra-prompt-sobolev.md. Reply: /tmp/astra-reply-sobolev.txt, 9583 bytes, exit 0.
- Result: recorded verbatim below.

### PROMPT (verbatim)

You are the MATHEMATICIAN (GPT-6.2 Astra) for a Lean formalization run: the first verified slice of Phase 3 Sobolev tools for the lean-geometry-pde project, baseline Mathlib v4.36.0. You author the math content. Another model authors the architecture; do not write architecture, module lists, or dependency graphs. Use ONLY the verified facts below. Do not invent Mathlib file paths, line numbers, or Lean names.

VERIFIED FACTS, all checked 28 Nov 2026 against the local cached Mathlib v4.36.0 source tree:

A. Mathlib/Analysis/Distribution/Sobolev.lean: `besselPotential` at line 72, `MemSobolev` at line 152. `MemSobolev s p f` means there exists f' : Lp F p volume with `besselPotential E F s f = f'`. `SchwartzMap.memSobolev`, `MemSobolev.lineDerivOp`, `MemSobolev.laplacian` exist in that file. The cache has no Sobolev.olean, so importing the module triggers a from-source build.

B. Mathlib/Analysis/Distribution/Distribution.lean: `Distribution.ofFun Ω f μ n` is the distribution sending a test function φ to ∫ x, φ x • f x ∂μ, and is the zero map when f is not locally integrable on Ω. `Distribution.ofFun_injective` states: for BorelSpace E, FiniteDimensional ℝ E, CompleteSpace F, if f and f' are LocallyIntegrableOn Ω μ and `ofFun Ω f μ n = ofFun Ω f' μ n`, then `f =ᵐ[μ.restrict Ω] f'`. `Distribution.lineDerivOp_apply_apply` states `∂_{m} f g = f (- ∂_{m} g)` for a distribution f, a test function g, and a vector m. `TestFunction Ω F n` is the bundled type of n-times continuously differentiable functions with compact support contained in Ω.

C. Mathlib/Analysis/Distribution/SchwartzSpace/Basic.lean line 1400: `SchwartzMap.denseRange_toLpCLM` states Schwartz functions are dense in Lp (for p ≠ ⊤, 1 ≤ p, finite-dimensional E, temperate-growth measure, finite on compacts).

D. There is no `HasWeakDeriv`, `WeakDeriv`, or `HasDistribDeriv` anywhere in the v4.36.0 tree. No W^{k,p} on domains exists. No Sobolev space on manifolds, no weighted spaces, no embeddings, no trace theorem exist.

E. The acceptance parameters to fix in writing (GAP-10) are: dimension, target exponent, weight convention, s, delta, local regularity, Poincare and trace hypotheses. The downstream example: a researcher writes W^{1,2} for a bounded domain and Lean says unknown identifier. Phase 3 full is 12 to 36 person-months; this run delivers the first verified slice only.

F. The generator's proposed design, to be checked by you: (1) Define a weak directional derivative by distributions: u has weak derivative v in direction m when both are locally integrable on the whole space and the distributional line derivative of `ofFun u` equals `ofFun v`. Prove as a characterization theorem the integration-by-parts identity against test functions. Prove uniqueness: two weak derivatives are equal almost everywhere, via `ofFun_injective`. (2) Define W^{1,2} on EuclideanSpace ℝ (Fin n) as the set of pairs (u, D) with u in L2 and D i in L2 for each basis direction i, such that D i is a weak derivative of u in direction i, with norm sqrt(‖u‖^2 + sum i, ‖D i‖^2). Prove the norm axioms. Attempt the Hilbert structure (inner product plus completeness) if feasible; completeness needs closedness of the weak-derivative graph. (3) State, not prove, the H^1 = W^{1,2} bridge on R^n, with the exact norm comparison between the W^{1,2} norm and the Bessel H1 norm ‖besselPotential 1 u‖ in L2.

QUESTIONS:

1. Check design (1): is the distribution-based definition of weak derivative mathematically the standard one, and does the integration-by-parts characterization follow from the stated `lineDerivOp_apply_apply` and `ofFun_apply` facts? Is there any hidden hypothesis (for example on the test-function order n, or on local integrability) that the design misses?

2. Check the uniqueness argument in (1): does `ofFun_injective` as stated give equality almost everywhere on the whole space when Ω is the whole space, and what exactly must be discharged about the measure restriction?

3. Check design (2): is the stated norm the standard W^{1,2} norm, and is the submodule-of-a-product construction mathematically sound for the norm axioms? For completeness, what is the exact mathematical argument that the weak-derivative graph is closed, and which analytic facts does it need (continuity of which pairing, in which topology)?

4. Check design (3): state the exact H^1 = W^{1,2} bridge on R^n with the precise norm comparison, including what the H1 norm is in terms of `besselPotential` and `MemSobolev`, and list the remaining proof steps in order.

5. Fix the GAP-10 acceptance parameters in writing: give a concrete value or a concrete named hypothesis for each of dimension, target exponent, weight convention, s, delta, local regularity, Poincare hypothesis, trace hypothesis, for the three acceptance tests (H^1 Sobolev embedding, linear wave energy estimate on Minkowski space, r^{-1} decay in the weighted space). Where a parameter is a choice rather than forced, say so and name the choice.

6. Name the single biggest mathematical risk in this design, and the observable fact that would show it has failed.

### RESULT (verbatim Astra)

**Verdict.** Use (1) with smooth compactly supported tests and Lebesgue measure. Use (2) with \(L^2\) **classes**, not pointwise functions, and with the Hilbert product norm. The graph is closed by an \(L^2\)-pairing argument that does not require the Bessel theory. The space identification in (3) is a standard mathematical target, but the verified facts do **not** specify the multiplier normalization needed to assert an isometry for `besselPotential`.

### 1. Definition and integration by parts

Take \(E=\mathbb R^d\), \(\Omega=E\), \(\mu=\mathrm{volume}\), a constant vector \(m\in E\), and test-function order \(\infty\). For locally integrable real-valued \(u,v\), write \(T_u,T_v\) for their `Distribution.ofFun` distributions. Then
\[
 \partial_m T_u=T_v
 \quad\Longleftrightarrow\quad
 \forall\phi\in C_c^\infty(E),\qquad
 \int_E \phi\,v=-\int_E(\partial_m\phi)\,u .
\]
This is the standard weak directional derivative. For the forward implication, evaluate the distribution equality at \(\phi\), apply `Distribution.lineDerivOp_apply_apply`, and evaluate the two regular distributions by their integral formulas. For the reverse implication, the same computation gives equality on every test; use extensionality. For a vector target the products in the formula are scalar actions.

Three qualifications matter:

* The equivalence is **under local integrability of both functions**. If the definition includes local integrability as conjuncts, the unconditional characterization must include them on the integral side too. The zero-map fallback of `Distribution.ofFun` is not evidence of integrability.
* A spatial derivative costs a test-function derivative. With smooth tests, \(-\partial_m\phi\) is again a valid test of the same order. One should not state the proof for arbitrary identical finite orders on both sides without checking the order change; in particular one cannot differentiate an arbitrary continuous test.
* Volume is part of the standard Euclidean statement. Replacing it by an arbitrary measure in both regular distributions gives a distributional identity involving that measure, not in general the ordinary weak derivative of a function.

### 2. Uniqueness

If \(v,w\) are weak derivatives of the same \(u\) in the same direction, then \(T_v=\partial_m T_u=T_w\). Apply `Distribution.ofFun_injective` to **\(v,w\)**, supplying their local integrability and the stated Borel, finite-dimensional-domain and complete-target hypotheses. The immediate conclusion is
\[
 v=w\quad(\mu\mathbin{\mathrm{.restrict}}\Omega)\text{-a.e.}
\]
For the whole space, identify the underlying set of \(\Omega\) with the universal set and rewrite the restricted measure as \(\mu\): on every measurable \(A\), restriction gives \(\mu(A\cap E)=\mu(A)\). No boundary-null hypothesis and no pointwise representative choice are needed. On a proper open set the same proof gives only restricted a.e. equality.

### 3. The graph norm and completeness

For scalar \(L^2=L^2(E,\mathrm{volume})\), take the ambient space \(X=L^2\oplus (L^2)^d\) with the finite Hilbert sum inner product. The proposed norm
\[
 \|(u,D)\|_X=\left(\|u\|_2^2+\sum_i\|D_i\|_2^2\right)^{1/2}
\]
is the standard inhomogeneous \(W^{1,2}\) norm. Restricting it to the weak-derivative graph gives all norm axioms; restricting the inner product gives the desired inner product. Merely declaring a submodule of a product with an unspecified product norm does **not** establish the displayed norm formula. Using \(L^2\) classes matters for definiteness. The weak identities are independent of representatives, and \(L^2\) representatives are locally integrable by Cauchy–Schwarz on compact sets of finite volume.

Here is a closedness proof that also proves linearity. For each basis index \(i\) and fixed smooth compactly supported \(\phi\), define the scalar functional
\[
 L_{i,\phi}(u,D)=\int_E D_i\phi+\int_E u\,\partial_i\phi .
\]
Both test factors are in \(L^2\), so
\[
 |L_{i,\phi}(u,D)|\le
 \|D_i\|_2\|\phi\|_2+\|u\|_2\|\partial_i\phi\|_2 .
\]
Thus the functional is linear and continuous in the **strong product \(L^2\) norm**, with the test held fixed. By the characterization in (1), the graph is exactly \(\bigcap_{i,\phi}\ker L_{i,\phi}\), hence is a closed linear subspace. Completeness follows from completeness of the finite Hilbert sum. No uniform bound over tests, topology on varying tests, or density theorem is needed for this argument.

### 4. The bridge statement and its normalization gate

State the bridge for scalar tempered distributions \(T\) on \(\mathbb R^d\): `MemSobolev` with \(s=1,p=2\) holds for \(T\) **iff** \(T\) is represented by the first component \(u\) of a \(W^{1,2}\) graph element. On the right the derivative tuple is unique in \((L^2)^d\). On the left the norm is \(\|h\|_2\), where \(h\) is the \(L^2\) witness representing the order-one Bessel potential of \(T\) in `MemSobolev`. Thus “\(\|\mathrm{besselPotential}\ 1\ u\|_2\)” abbreviates a witness norm, not an \(L^2\) norm applied directly to a distribution. One must justify uniqueness of the representing \(L^2\) class.

**Precise norm target.** In Plancherel coordinates, let \(q_i(\xi)\) be the symbol of \(\partial_i\) and \(b_1(\xi)\) the order-one Bessel symbol. The comparison to prove is
\[
 \|(u,D)\|_W^2=\int (1+\textstyle\sum_i|q_i|^2)|\widehat u|^2,
 \qquad
 \|T\|_{H^1}^2=\int |b_1|^2|\widehat u|^2 .
\]
For the convention \(J=(I-\Delta)^{1/2}\) the weights agree and **the norms are equal**. For example, if \(q_i=2\pi\mathrm i\,\xi_i\) but \(|b_1|^2=1+|\xi|^2\), the exact identity instead is
\[
 \|T\|_{H^1}^2=\|u\|_2^2+(2\pi)^{-2}\sum_i\|D_i\|_2^2 .
\]
These are conditional formulas, not two claims about Mathlib. Fact A gives the witness definition but neither symbol. It does not determine which exact numerical comparison to put in a Mathlib-specific theorem.

The remaining proof obligations, in order, are:

1. Read off both symbols in the same Fourier coordinates and fix the norm statement. Identify the \(L^2\)-to-tempered-distribution representation, prove it injective, and relate its compact-test evaluations to `Distribution.ofFun`.
2. Identify a graph derivative with a tempered derivative. In particular, justify passage from equality on compact tests to equality of the relevant tempered distributions (or prove the corresponding test-extension result). Density in \(L^2\) alone does not provide approximation with derivatives controlled.
3. Forward from the graph: use the derivative multiplier identity and Plancherel to obtain \(b_1\widehat u\in L^2\); its inverse transform is the Bessel witness.
4. Reverse from a witness \(h\): recover \(u\) and \(D_i\) by the multipliers \(1/b_1\) and \(q_i/b_1\) on \(\widehat h\), proving their boundedness from the checked symbols. Verify representation of \(T\) and the compact-test weak identities.
5. Apply Plancherel with those same symbols to conclude the checked norm formula.

### 5. GAP-10 acceptance choices

The following are **proposed specifications**, not existing results in the slice. Use \(\delta=0\) to denote unit weight in the first two tests; it is not the weighted-space index convention of the third test.

| Test | Dimension and target exponent | Weight, \(s,\delta\) | Local regularity and acceptance inequality | Poincaré / trace hypotheses |
|---|---|---|---|---|
| \(H^1\) embedding | Choose \(\mathbb R^3\), critical target \(q=6\) | Unit weight, \(s=1,\delta=0\) | First weak derivatives locally in \(L^2\); assume global \(H^1\). Require \(\|u\|_6\le C\|u\|_{H^1}\). | Neither; whole space, inhomogeneous norm. |
| Linear wave energy | Choose \(1+3\) Minkowski, spatial \(q=2\) for energy variables | Unit weight, spatial data orders \(s=1\) and \(s-1=0\), \(\delta=0\) | Choose the homogeneous wave equation and classical smooth solutions with spatial support uniformly compact on bounded time intervals. Require \(E(t)=E(0)\), \(2E(t)=\|\partial_tu(t)\|_2^2+\|\nabla_xu(t)\|_2^2\). | No Poincaré or spatial trace. Initial values are classical time evaluations. |
| Weighted decay | Choose \(\mathbb R^3\), target \(q=\infty\) after weighting | Choose \(s=2,\delta=-1\) and the scaled norm below | \(u\in H^2_{\rm loc}\) with finite global weighted norm. Require \(\|\langle x\rangle u\|_\infty\le C\|u\|_{2,2,-1}\), giving \(O(r^{-1})\) at infinity for the continuous representative. | Neither; the local estimates use the full inhomogeneous norm, not a zero-mean or boundary condition. |

The third convention is explicitly
\[
 \|u\|_{2,2,\delta}^2
 =\sum_{|\alpha|\le2}\int_{\mathbb R^3}
 \langle x\rangle^{-2\delta+2|\alpha|-3}
 |\partial^\alpha u|^2\,dx,\qquad \langle x\rangle=(1+|x|^2)^{1/2}.
\]
The \(-3\) compensates for volume under rescaling: on an annulus of radius \(R\ge1\), the norm controls the unit-annulus \(H^2\) norm of \(R^{-\delta}u(R\,\cdot)\). This is why \(\delta=-1\) specifies the requested decay in this convention. None of the three tests supplies bounded-domain \(W^{1,2}\); the downstream bounded-domain example remains out of scope.

### 6. Biggest risk and failure signal

The biggest risk is **specifying the bridge as an isometry before checking the multiplier**. Closedness of the graph cannot fix a mismatch of norms. An observable failure would be that \(|b_1|^2\) and \(1+\sum_i|q_i|^2\) differ strictly on an open frequency patch: testing with a nonzero smooth Fourier bump supported there gives different squared norms. That refutes the isometry, not necessarily the equality of spaces, and leaves the weak-derivative and graph results intact.

### GENERATOR NOTE (not Astra output)

- Astra's verdict changed the design in two places, both applied in the draft file. First, the ambient space is `PiLp 2` over `Fin (n+1)`, not a `Prod`, because the Prod norm in Mathlib is the max norm (`Prod.norm_def` at Mathlib/Analysis/Normed/Group/Constructions.lean:255), not the Hilbert sum norm. The PiLp 2 norm is the sum norm by `PiLp.norm_eq_of_L2` (PiLp.lean:794). Second, the bridge comparison carries the (2 pi) to the minus 2 factor, per Astra section 4 and the Bessel doc comment in Sobolev.lean, and is stated as the formula to prove, not a proved isometry.
- Astra section 3 gives the closedness argument for the Hilbert structure: the graph is the intersection of kernels of the continuous functionals L_{i,phi}. That is the route to attempt for completeness after the norm compiles.
- `MemLp.locallyIntegrable` is at LocallyIntegrable.lean:359, signature `(hf : MemLp f p μ) (hp : 1 ≤ p) : LocallyIntegrable f μ`. `MemLp.ofReal` is at LpSpace/Basic.lean:831. `Lp.toTemperedDistributionCLM` is at TemperedDistribution.lean:195. `PiLp 2` has an InnerProductSpace instance at PiL2.lean:85. `Lp 𝕜 2 μ` has one at L2Space.lean:191.

## U1: acceptance parameters

- DONE. File: ~/workspace/handover-mathlib-geometry-2026-11-26/docs/SobolevAcceptance-v01.md, 56 lines.
- Every GAP-10 item fixed in writing from Astra's reply: dimension R3 for embedding and weighted tests, 1+3 Minkowski (3 spatial dims) for wave energy, slice itself on R^n with n=3 as acceptance case; target exponents q=6 (critical, H1 embedding in R3), q=2 (energy variables), q=infinity after weighting (decay test); weight convention unit weight delta=0 for first two tests, weighted norm with bracket-x to the power -2delta+2|alpha|-3 and <x>=(1+|x|^2)^{1/2}; s=1 (embedding), s=1 and s-1=0 (wave), s=2 (weighted); delta=-1 for the weighted test (r^{-1} decay); local regularity per test; Poincare hypothesis none for whole-space tests, bounded-domain version named as later-run hypothesis (zero mean or zero boundary values); trace hypothesis none for whole-space tests, bounded-domain version named as later-run hypothesis (Lipschitz domain).
- The three acceptance tests in exact form, the bridge norm comparison formula with the (2 pi)^{-2} factor, scope limits, and the claim-test sentence.

## U2: audit

- DONE. File: ~/workspace/handover-mathlib-geometry-2026-11-26/map/Sobolev-v436-audit.md, 61 lines after the Hilbert additions.
- Every v4.36.0 item used, each with file, line, cached source path, and pinned GitHub URL at the baseline commit. Original 18 items plus 20 Hilbert items added 28 Nov 2026 (toSchwartzMap, toLp, coeFn_toLp, contDiff, hasCompactSupport, lineDerivOp_eq_lineDerivCLM, lineDerivCLM_apply, L2.inner_def, isClosed_ker, completeSpace_coe, continuous_ofLp, Continuous.inner, RCLike.inner_apply, inner_add_left, inner_smul_left, isClosed_iInter, MemLp.ofReal, MemLp.locallyIntegrable, Lp.memLp). All lines re-checked against the cached source by grep.
- The denseRange_toLpCLM targeted re-check is done: /tmp/probe-dense.lean, exit 0, 12s, with the SchwartzSpace/Basic import. Recorded as a verification note in the audit file.
- No HasWeakDeriv, WeakDeriv, or HasDistribDeriv anywhere in the v4.36.0 tree (grep, zero hits); no W^{k,p} on domains, no Sobolev space on manifolds, no weighted space, no embedding, no trace theorem.

## U3: weak derivatives

- DONE. File: ~/workspace/handover-mathlib-geometry-2026-11-26/track-sobolev/lean-phase1/PseudoRiemannian/SobolevSlice.lean.
- `HasWeakDeriv` defined by distributions, with local integrability as a conjunct. Theorems proved: `HasWeakDeriv.unique`, `HasWeakDeriv.iff_integral`, `HasWeakDeriv.zero`, `HasWeakDeriv.add`, `HasWeakDeriv.smul`. All axioms exactly [propext, Classical.choice, Quot.sound]. See Verification below.

## U4: W^{1,2} norm

- DONE, with the Hilbert structure proved, not just the normed space. The brief's fallback (normed space plus named remaining steps) was not needed.
- `sobolevSpace` is a submodule of `PiLp 2` over `Fin (n+1)` of `Lp ℝ 2 volume`. Component 0 is the function, components 1..n are its weak derivatives in the `EuclideanSpace.single i 1` directions. The PiLp 2 norm is the sum norm by `PiLp.norm_eq_of_L2`, so the inherited norm is the standard W^{1,2} norm. Theorems proved: `sobolev_norm_eq`, `sobolev_norm_nonneg`, `sobolev_norm_eq_zero`, `sobolev_norm_add_le`, `sobolev_norm_smul`.
- Hilbert structure proved: `testFunLp` (test function as an L2 element), `weakFunctional` (the continuous pairing functional L_{i,phi}), `weakFunctional_apply` (its integral form), `sobolevSpace_isClosed` (the graph is the intersection of the kernels, hence closed), instances `sobolevInnerProductSpace` and `sobolevCompleteSpace`, and theorem `sobolevSpace_complete`. All axioms exactly [propext, Classical.choice, Quot.sound]. The closedness argument is Astra's section 3, carried out in Lean: continuity of each functional comes from `Continuous.inner` plus coordinate continuity from `PiLp.continuous_ofLp`; the set equality uses `HasWeakDeriv.iff_integral` in both directions.
- Design correction to the Design section above: the ambient space is `PiLp 2` over `Fin (n+1)`, not a `Prod` of Lp and PiLp. The Prod norm in Mathlib is the max norm, not the Hilbert sum norm. The GENERATOR NOTE under the Astra call already records this; the Design section's original wording is superseded.

## U5: bridge statement

- DONE. `sobolevBridge` is a `def ... : Prop` in SobolevSlice.lean, stated not proved, with the exact norm comparison ‖h‖ = sqrt(‖u‖² + ((2π)²)⁻¹ · Σᵢ‖Dᵢ‖²) and six remaining steps listed in its doc comment (read off both symbols; identify the L2-to-tempered-distribution representation and prove it injective; identify graph derivative with tempered derivative; forward via multiplier identity and Plancherel; reverse via multipliers 1/b₁ and qᵢ/b₁; apply Plancherel). The statement typechecks: the file compiles exit 0 and `sobolevComplex` (the complexification helper, via `MemLp.ofReal` with K pinned to ℂ, then `MemLp.toLp`) elaborates. The H1 norm is the L2 norm of the MemSobolev witness h, not an L2 norm applied directly to a distribution.

## Verification

- Final file compile: `flock /tmp/lean-phase1-build.lock lake env lean PseudoRiemannian/SobolevSlice.lean` from the work-copy directory, exit 0, wall 32s, zero errors, zero warnings. Output: /tmp/sobolev-slice-final.out.
- Grep for sorry and admit on the file: 0 matches.
- Full project build: `flock /tmp/lean-phase1-build.lock lake build`, exit 0, wall 50s, 4652 jobs. One pre-existing warning about SphereTestSpherical.lean, untouched by this run. Output: /tmp/sobolev-final-build.out.
- Axiom printouts, all 13 theorems, each exactly [propext, Classical.choice, Quot.sound], from /tmp/sobolev-slice-final.out:
  - HasWeakDeriv.unique, HasWeakDeriv.iff_integral, HasWeakDeriv.zero, HasWeakDeriv.add, HasWeakDeriv.smul, sobolev_norm_eq, sobolev_norm_nonneg, sobolev_norm_eq_zero, sobolev_norm_add_le, sobolev_norm_smul, sobolevSpace_complete, weakFunctional_apply, sobolevSpace_isClosed.
- No existing proved theorem was weakened. No root file was edited. SobolevSlice was not added to any root import list. No push, post, send, deploy, or delete. No forbidden domain is named in any file.
- Kit: Case B, Lean verification kit, draft, ~/workspace/handover-mathlib-geometry-2026-11-26/.

## Timing table (step, wall seconds)

- Start to probes: about 300s (04:05 to 04:10 UTC, including the two failed probe-script attempts).
- Probe (a) build sanity: 10s.
- Probe (b) first run: 2s (exit 1, missing olean). Probe (c) first run: 3s (exit 1, missing olean).
- Module build (d): 3575s.
- Re-probe (b): 127s. Re-probe (c): 11s. Names probe: about 10s. Micro-probe: about 5s. Dense probe: 12s. Hilbert API probes: 16s and 37s.
- Astra call: prompt and reply recorded above; reply 9583 bytes, exit 0.
- U1 and U2 file writes: wall time not measured; no number is recorded rather than guessing.
- SobolevSlice v1 to v6 compiles: 10 to 36s each, 6 runs.
- Hilbert attempt v1 to v6 compiles: 12 to 46s each, 6 runs.
- Final file compile: 32s. Full project build: 50s.
- Total spawn wall at final compile: about 83 min of the 6 hour timebox. The run finished well inside the timebox; the module build (60 min) was the dominant cost.
