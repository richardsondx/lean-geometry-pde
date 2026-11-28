# Check log: stage2-mathlib-geometry-phase3-sobolev-slice-01 (verifier)

- Date: 28 Nov 2026. Verifier: independent, did not write the work.
- Run: stage2-mathlib-geometry-phase3-sobolev-slice-01.
- Predicate: pred-mathlib-geometry-phase3-sobolev-slice-v01.
- Baseline: Mathlib v4.36.0, commit fc4f59e577feb1a4956671bc04ac18aaaf8cd842.
- Cached Mathlib HEAD confirmed by `git rev-parse`: fc4f59e577feb1a4956671bc04ac18aaaf8cd842.
- Artifacts read only. No artifact file was edited. Probe file lived in /tmp only.
- Work copy: ~/workspace/handover-mathlib-geometry-2026-11-26/track-sobolev/lean-phase1/
- Note: `lake` was not on PATH in the exec shell; used `$HOME/.elan/bin` on PATH. First attempt without it failed with exit 69 (`flock: failed to execute lake: No such file or directory`). All runs below use the fixed PATH.

## Wall time per step

- `lake env lean PseudoRiemannian/SobolevSlice.lean`: 11 s, exit 0.
- `lake build`: 32 s, exit 0, 4652 jobs, "Build completed successfully".
- Probe with extra `#print axioms` (temp copy in /tmp): 14 s, exit 0.
- Audit line re-open (37 items, cached source): ~14 s.
- Audit negative greps (whole cached Mathlib tree): ~48 s.

## Per-check verdicts

- Check 1, lake build exits 0 with SobolevSlice.lean included: FAIL.
  - Evidence for: `lake build` exit 0, 32 s, 4652 jobs, "Build completed successfully".
  - Evidence for: direct `lake env lean PseudoRiemannian/SobolevSlice.lean` exit 0, 11 s, no errors, no warnings in output; the 13 in-file `#print axioms` lines printed.
  - Evidence against: SobolevSlice.lean is not part of the build. `grep -rn SobolevSlice` over the work copy (lean files and lakefile) returns nothing (exit 1). The root file PseudoRiemannian.lean imports only Metric, LeviCivita, MinkowskiTest, SphereTest, Showcase, SphereTestSpherical. `.lake/build/lib/lean/PseudoRiemannian/` contains olean files for KerrMetric, LeviCivita, Metric, MinkowskiTest, Showcase, SphereTest, SphereTestSpherical, and no SobolevSlice.olean. So a future `lake build` would not catch a regression in this file.
  - First missing step: add `import PseudoRiemannian.SobolevSlice` to PseudoRiemannian.lean (or otherwise add the module to the lib target), then re-run `lake build` and confirm SobolevSlice.olean appears.
- Check 2, no sorry, no admit, no axiom beyond propext, Classical.choice, Quot.sound: PASS, with one note.
  - `grep -rn sorry` on SobolevSlice.lean: no hits (exit 1). `grep -rn \badmit\b`: no hits (exit 1). No `axiom` declaration in the file (only a doc-comment mention on line 45).
  - Direct run printed all 13 in-file `#print axioms` lines, each exactly `[propext, Classical.choice, Quot.sound]`: HasWeakDeriv.unique, iff_integral, zero, add, smul; sobolev_norm_eq, nonneg, eq_zero, add_le, smul; sobolevSpace_complete, weakFunctional_apply, sobolevSpace_isClosed.
  - Note: two further theorems have no in-file `#print axioms` line, so the file's own line 45 claim ("Every new theorem below carries a #print axioms line") is inaccurate for them: memLp_locallyIntegrableOn (line 77) and HasWeakDeriv.congr_ae (line 93). Both were verified clean by probe instead: a temp copy in /tmp with the two prints appended ran exit 0 in 14 s and printed `[propext, Classical.choice, Quot.sound]` for both. Substance holds for all 15 theorems; the in-file coverage gap is listed below.
- Check 3, GAP-10 acceptance parameters fixed in docs/SobolevAcceptance-v01.md: PASS.
  - Dimension: R3 for embedding and weighted tests; 1 plus 3 Minkowski for wave test; slice on R^n general, n equal to 3 as acceptance case. All present.
  - Target exponent: q equal to 6 (H1 embedding, critical), q equal to 2 (wave energy), q equal to infinity after weighting (decay). All present.
  - Weight convention: unit weight, delta equal to 0, first two tests; weighted norm formula with bracket-x to the power minus 2 delta plus 2 order of alpha minus 3, bracket-x equal to sqrt(1 plus x squared). Present.
  - s: 1 (embedding), 1 and 0 (wave spatial orders), 2 (weighted). Present.
  - Delta: 0 first two tests, minus 1 weighted test (r to the minus 1 decay). Present.
  - Local regularity: embedding test first weak derivatives locally L2 plus global H1; wave test classical smooth compactly supported; weighted test u in H2 locally with finite weighted norm; slice u and each weak derivative in L2 on R^n, hence locally integrable. All present.
  - Poincare: none for whole-space tests, inhomogeneous norm, no zero mean; bounded-domain zero-mean or zero-boundary named as a later-run hypothesis, not assumed. Present.
  - Trace: none for whole-space tests, no boundary; bounded-domain Lipschitz-domain requirement named as a later-run hypothesis, not assumed. Present.
  - Acceptance tests stated in exact form (Test 1 L6 bound, Test 2 energy conservation, Test 3 weighted sup bound). Present. Doc states plainly the bridge is not proved and bounded-domain W12 is out of scope.
- Check 4, v4.36.0 Sobolev audit complete, file, line, source per item: PASS, with two trivial label notes.
  - All 37 cited items re-opened in the cached source at the baseline commit; every cited line shows the named declaration. Spot list: Sobolev.lean:72 `def besselPotential`, :152 `def MemSobolev`, :204 `theorem SchwartzMap.memSobolev`, :319 `theorem MemSobolev.lineDerivOp`, :347 `theorem MemSobolev.laplacian`; Distribution.lean:302 `def ofFun`, :372 `theorem ofFun_injective`, :268 `theorem lineDerivOp_apply_apply`, :234 `def lineDerivCLM`; TestFunction.lean:67 `structure TestFunction`, :562 `def lineDerivCLM`, :127 `protected theorem contDiff`, :128 `protected theorem hasCompactSupport`, :620 `lemma lineDerivOp_eq_lineDerivCLM`, :576 `lemma lineDerivCLM_apply`; SchwartzSpace/Basic.lean:1401 `theorem denseRange_toLpCLM`, :1384 `def toLpCLM`, :546 `def HasCompactSupport.toSchwartzMap`, :1335 `def toLp`, :1342 `theorem coeFn_toLp`; TemperedDistribution.lean:195 `def toTemperedDistributionCLM`; LpSpace/Basic.lean:89 `def Lp`, :831 `theorem MemLp.ofReal`, :189 `protected theorem memLp`; AEEqOfIntegral.lean:322 `theorem Lp.ae_eq_of_forall_setIntegral_eq`; PiLp.lean:794 `theorem norm_eq_of_L2`, :538 `theorem continuous_ofLp`; PiL2.lean:318 `abbrev EuclideanSpace.single`; L2Space.lean:136 `theorem inner_def`; ContinuousLinearMap/Basic.lean:669 `theorem isClosed_ker`; UniformEmbedding.lean:318 `instance IsClosed.completeSpace_coe`; Continuous.lean:90 `theorem Continuous.inner`; InnerProductSpace/Basic.lean:932 `theorem RCLike.inner_apply`, :73 `theorem inner_add_left`, :106 `theorem inner_smul_left`; Topology/Basic.lean:159 `theorem isClosed_iInter`; LocallyIntegrable.lean:359 `theorem MemLp.locallyIntegrable`.
  - Negative claims confirmed: `grep -rln HasWeakDeriv|HasDistribDeriv` over the cached Mathlib tree returns nothing; `grep -rn SobolevSpace` returns nothing; `BesselPotentialSpace` appears only in doc comments (Sobolev.lean lines 24 and 151, line 151 confirmed verbatim).
  - Note 1: audit labels TestFunction.lineDerivCLM_apply (line 576) a "theorem"; the source says `lemma`. Same declaration, immaterial.
  - Note 2: the audit's claim that Distribution.olean, TestFunction.olean, DerivNotation.olean, and Sobolev.olean were absent from the cache at run start cannot be checked retroactively; Sobolev.olean exists in the cache now, which is consistent with the claimed build-from-source, not proof of it. No shared-cache rebuild was done by this verifier.
- Check 5, weak derivatives defined on R^n with uniqueness proved: PASS.
  - `HasWeakDeriv` is a def on `EuclideanSpace ℝ (Fin n) → ℝ` (line 71), via `Distribution.ofFun` and the distributional line derivative, with local integrability as a conjunct.
  - `HasWeakDeriv.unique` proved in the file (line 83), file compiles exit 0, axioms `[propext, Classical.choice, Quot.sound]` only. Domain matches: R^n, not another space.
- Check 6, W^{1,2} defined with its norm proved to be a norm: PASS.
  - `sobolevSpace` is a def, a submodule of the (n+1)-fold L2 PiLp product (line 166), components 0 and 1..n as function and weak derivatives in the basis directions.
  - `sobolev_norm_eq` gives the explicit norm formula (sqrt of squared L2 norm of u plus sum of squared L2 norms of derivatives), proved exit 0, axioms clean.
  - Norm axioms proved: sobolev_norm_nonneg, sobolev_norm_eq_zero, sobolev_norm_add_le, sobolev_norm_smul, all exit 0, axioms clean. Hilbert structure proved: sobolevSpace_isClosed, sobolevSpace_complete, plus instances sobolevInnerProductSpace and sobolevCompleteSpace (lines 414-425).
- Check 7, H^1 = W^{1,2} bridge stated with exact norm comparison and remaining steps listed: PASS.
  - `sobolevBridge` is a `def ... : Prop` (line 262), stated, not proved; no theorem claims it. Its doc comment lists 6 remaining steps in order (symbol read-off, L2-to-tempered identification, graph-to-tempered derivative, forward multiplier plus Plancherel, reverse multipliers, Plancherel norm formula).
  - Exact comparison in the statement: `‖h‖ = sqrt (‖u‖^2 + ((2 * Real.pi)^2)⁻¹ * sum_i ‖D_i‖^2)`, which matches the acceptance doc's `(2 pi) to the minus 2` factor and its Bessel-convention explanation. The acceptance doc states the same comparison as the formula to prove later, not a proved fact.

## No-weakening check

- Root file PseudoRiemannian.lean still imports only Metric, LeviCivita, MinkowskiTest, SphereTest, Showcase, SphereTestSpherical (6 lines, verified by read).
- `lake build` exit 0 across all 4652 jobs; no existing module failed. No baseline diff of the work copy was available to this verifier, so weakening is checked by build success plus the unchanged root import list, not by a file-by-file diff.

## Gaps

- Gap 1, SobolevSlice.lean not wired into the lake build (Check 1): Queued. Owner: generator. Next step: add `import PseudoRiemannian.SobolevSlice` to PseudoRiemannian.lean, re-run `lake build` under flock, confirm SobolevSlice.olean appears and the build still exits 0.
- Gap 2, two theorems lack in-file `#print axioms` lines (Check 2 note): Queued. Owner: generator. Next step: append `#print axioms memLp_locallyIntegrableOn` and `#print axioms HasWeakDeriv.congr_ae` to SobolevSlice.lean and re-run the direct lean check; expected output is `[propext, Classical.choice, Quot.sound]` for both, as already shown by probe.
- No other gaps found. The bridge proof, embeddings, trace, Poincare, weighted spaces, and bounded-domain W12 remain open by design and are not gaps in this slice; the docs state that plainly.

## Kit

- Case B, Lean verification kit, draft, ~/workspace/handover-mathlib-geometry-2026-11-26/.gf
