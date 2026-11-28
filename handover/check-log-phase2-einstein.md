# Check log: Handover run stage2-mathlib-geometry-phase2-einstein-01 (U1-U4)
Predicate: pred-mathlib-geometry-phase2-einstein-v01, checks 1-6
Verifier: independent checker (not the generator). Generator log NOT read.
Work copy: ~/workspace/handover-mathlib-geometry-2026-11-26/track-einstein/lean-phase1/
Shared project (diff only): ~/workspace/handover-mathlib-geometry-2026-11-26/lean-phase1/
Baseline: Mathlib v4.36.0, Lean 4.36.0. Signature lock (p,q)=(3,1), (-,+,+,+).
Started: Sat Nov 28 2026, 05:34 UTC (00:34 EST).

## Step timings (wall)
- 05:34 UTC: read Einstein.lean (668 lines), both root PseudoRiemannian.lean files.
- 05:34 UTC: grep/diff/counts (see below).
- 05:33-05:34 UTC: `flock /tmp/lean-phase1-build.lock lake build` — 43.9s, 4654 jobs, "Build completed successfully", exit 0 (PIPESTATUS captured in run; olean present).
- 05:37 UTC: standalone `lake env lean` axiom run started; first attempt interrupted by a service restart (~05:36 UTC) which also wiped /tmp logs; re-run launched 05:37 UTC, completed 05:40 UTC (189s wall, exit 0).

## Counts (run by verifier)
- Theorems in Einstein.lean: 30 (`grep -c "^theorem "` = 30).
- `#print axioms` lines: 30, one per theorem (lines 165-171, 506-512, 605-606, 655-668).
- `grep -rn "sorry\|admit" PseudoRiemannian/Einstein.lean`: no matches (exit 1).
- `grep -rn "itsdavis" PseudoRiemannian/Einstein.lean PseudoRiemannian.lean`: no matches (exit 1).

## Scope check
- `diff -u` shared root vs work-copy root: only difference is one added line `import PseudoRiemannian.Einstein` (diff exit 1 = differences found, as expected).
- `diff -rq --exclude=.lake` shared vs work copy: only `Only in ./PseudoRiemannian: Einstein.lean` and the root PseudoRiemannian.lean differ. No other file differs.
- No mention of itsdavis.com in either edited file (see grep above).

## Check 1: lake build exits 0 — PASS (evidence below, to be finalised in report)
- Command (from work copy, PATH incl. $HOME/.elan/bin): `flock /tmp/lean-phase1-build.lock lake build`
- Output tail: `✔ [4652/4654] Built PseudoRiemannian (3.3s)` / `Build completed successfully (4654 jobs).`
- Olean present: `.lake/build/lib/lean/PseudoRiemannian/Einstein.olean`, 10957504 bytes, Nov 28 05:33.
- Note: build output contains only linter/module-system warnings (pre-existing style warnings, incl. on Metric.lean and Einstein.lean imports); no errors. The build log was written to /tmp and lost in the 05:36 service restart; the exit-0 result and job count above were captured in the tool output of the build run itself.

## Check 2: no sorry/admit, axioms only propext/Classical.choice/Quot.sound — PASS
- Grep: no sorry/admit (see Counts).
- Standalone run (from work copy, under flock): `lake env lean PseudoRiemannian/Einstein.lean`, exit 0 (PIPESTATUS 0 0 0), 189s wall.
- Output: exactly 30 `depends on axioms` lines, one per theorem, and all 30 read `[propext, Classical.choice, Quot.sound]`; the grep for any line NOT matching those three axioms returned nothing (exit 1). No `error` lines.
- Theorem count 30 = `#print axioms` count 30 = axiom-output line count 30, and the 30 names match the 30 theorems in the file.

## Check 3: Einstein tensor defined from Ricci and scalar curvature — PASS
- Lines 50-58, `noncomputable def einsteinComponents (n : ℕ) (Γ ...) (g ...) (ginv ...) (x ...) (j l : Fin n) : ℝ := ricciComponents n Γ x j l - (1 / 2) * scalarCurvature n Γ ginv x * g x j l`
- i.e. `G_jl = Ric_jl - (1/2) R g_jl`, using `ricciComponents` and `scalarCurvature` from LeviCivita.lean (verified present there: ricciComponents line 109, scalarCurvature line 116, riemannComponents line 101).

## Check 4: vacuum equations in Ric=0 and G=0 forms, equivalence — PASS (proved, not merely stated)
- `vacuumEinsteinRicci` def, lines 60-64: `∀ x j l, ricciComponents n Γ x j l = 0`.
- `vacuumEinsteinTensor` def, lines 66-71: `∀ x j l, einsteinComponents n Γ g ginv x j l = 0`.
- Forward: `ricci_zero_implies_einstein_zero`, lines 74-87 (any n).
- Reverse (4D, needs trace identity): `einstein_zero_implies_ricci_zero`, lines 111-132, via `einstein_trace_sum` lines 89-109; hypothesis `htrace : ∀ x, ∑ j, ∑ l, ginv j l * g x j l = 4`.
- Full equivalence proved for Minkowski: `minkowski_vacuum_iff`, lines 150-158, using `minkowski_trace_identity` lines 142-148.
- Status: equivalence is PROVED (general forward direction + 4D reverse under the trace hypothesis, instantiated for Minkowski).

## Check 5: Minkowski Einstein tensor = 0 proved — PASS
- `minkowski_einstein_eq_zero`, lines 160-163: `einsteinComponents 4 (flatChristoffel 4) minkowskiMetric.constantComponents minkowskiInverseComponents x j l = 0`, proved by `simp [einsteinComponents, minkowski_ricci_eq_zero, minkowski_scalar_eq_zero]` (both cited lemmas verified present in MinkowskiTest.lean lines 63 and 69).

## Check 6: Schwarzschild Ric = 0 on a regular chart — PASS (with notes below)
- `schwarzschild_ricci_eq_zero`, lines 612-641.
- Exact chart conditions as stated: `(M : ℝ) (hM : 0 < M) (y : Fin 4 → ℝ) (hr : 2 * M < y 1) (hs : Real.sin (y 2) ≠ 0) (j l : Fin 4)`, conclusion `ricciComponents 4 (schKoszulGamma M) y j l = 0`.
- Coordinates: (t, r, theta, phi) = indices 0,1,2,3; so conditions are M > 0, r > 2M, sin theta ≠ 0. `r ≠ 0` and `r - 2M ≠ 0` are derived inside the proof (sch_chart_r_ne_zero / sch_chart_r_sub_ne_zero), not assumed.
- Metric: `schMetric`, lines 378-388: `diag((2M - r)/r, r/(r - 2M), r^2, r^2 sin^2 theta)`, factored form.
- Standard-form equality IS proved: `schMetric_brief_form`, lines 400-413, proves `schMetric M y i j` equals `diag(-(1 - 2M/r), 1/(1 - 2M/r), r^2, r^2 sin^2 theta)` given `y 1 ≠ 0` and `y 1 - 2M ≠ 0`.
- Symbols are Koszul-derived, not merely asserted: `schKoszulGamma` lines 482-489; `schKoszul_eq_explicit` lines 491-504 proves it equals the standard table `schGammaExplicit` (lines 459-480) on the chart.
- Companion: `schwarzschild_einstein_eq_zero`, lines 643-654, same chart conditions, `G = 0`.
- Note: the factored form is the form actually used in the proof; the file proves it equals the brief's standard form (schMetric_brief_form), so the factored form is not an unverified rewrite.

## Deviations / notes
- One deviation from the brief's workflow, not from the predicate: the first standalone `lake env lean` run was interrupted by a service restart and /tmp logs were wiped; the build evidence above comes from the tool output of the build run itself, not a surviving log file. The axiom run was re-launched and is awaited.
- No Lean file was edited. Generator log was not read. No push/post/send/deploy/delete.

## Verdict (final)
- Checks 1, 2, 3, 4, 5, 6: ALL PASS. No failures, no gaps.
- Scope check: PASS (root diff is the single Einstein import line; only other difference is the new Einstein.lean; no itsdavis.com mention).
- Total wall time: ~6 minutes of verifier work plus the 189s axiom run (05:34-05:40 UTC); the 2-hour timebox was not approached.
