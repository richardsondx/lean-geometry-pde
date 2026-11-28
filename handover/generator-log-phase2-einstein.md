# Generator log: stage2-mathlib-geometry-phase2-einstein-01 (U1-U4)

- Run: stage2-mathlib-geometry-phase2-einstein-01. Generator: subagent session dc751fbe.
- Start: Fri 2026-11-27 23:07 EST. Timebox: 6 hours wall (until ~05:07 EST 2026-11-28).
- Work copy: ~/workspace/handover-mathlib-geometry-2026-11-26/track-einstein/lean-phase1/
- Files written (only these): PseudoRiemannian/Einstein.lean (new), PseudoRiemannian.lean (one import line), this log.
- Baseline: Mathlib v4.36.0, Lean 4.36.0. Signature lock (p, q) = (3, 1), (-, +, +, +).

## Step log (wall time)

- 23:07 EST: read Metric.lean, LeviCivita.lean, MinkowskiTest.lean, SphereTestSpherical.lean in full; read track work copy listing and lakefile.
- 23:07-23:08 EST: Astra strategy call (see below). Exit 0, ~50 s.
- 23:07-00:08 EST: wrote U1-U3 (Einstein tensor def, vacuum equivalence, Minkowski G = 0). Check 1: flock lake build, 61m3s real, exit 1, mostly lock wait; trace proof timed out per-declaration and one Minkowski trace goal unsolved.
- ~00:08-00:15 EST: checks 2-3 (`lake env lean`, ~7-35 s each). Split the trace expansion into standalone `einstein_trace_sum`; U1-U3 clean, exit 0, axioms clean.
- ~00:15-00:26 EST: checks 4-10. Chunk A (helpers, factored metric, Koszul = explicit) clean after fixing Pi-form `.div`/`.mul`/`.sub` issues and the `hasDerivAt_inv` name collision. Chunk B (symbol fderiv table + eventual-equality transfer) clean after simp-normal-form fixes (state 1/r branches as `-((y 1)^2)⁻¹`, state plain sin*cos product).
- 00:26 EST: check 11, exit 1. Chunk C (Ricci + Einstein): 15 of 16 Ricci goals failed. Diagnosis: full `simp` unfolded `schGammaExplicit` inside fderiv lambdas before the fderiv table could match, and `simp only [Real.sin_sq]` errored with no progress on goals where sin^2 was already rewritten.
- 00:28 EST: check 12, exit 1. Two-pass simp (fderivs first, values second) fixed 14 of 16 goals. Remaining: Ric_tt (field_simp missed the `(-(M*2)+y 1)⁻¹` denominator, a simp-normalised form of `y 1 - 2M`) and Ric_theta theta (field_simp reintroduced sin^2, needs sin^2 to 1-cos^2 again).
- 00:30 EST: check 13, exit 1. Added variant nonvanishing facts (h2Ma, h2Mb, h2Mc) and `try simp only [Real.sin_sq]`, but `try tac <;> ring` parses as `try (tac <;> ring)`, so when simp only found no sin^2, ring never ran; 3 goals left as plain ring identities.
- 00:33 EST: check 14, exit 0. Parenthesised the try: `(try simp only [Real.sin_sq]) <;> ring`. All 30 theorems compile, no errors, no warnings, no sorry/admit, all axioms clean.
- 00:33 EST: started final flock lake build (background, session proc_eb981ce27a4f); log at /tmp/einstein-final-build.log.

## Astra strategy call

- Model: openai/gpt-6.2-astra
- Command: python3 ~/workspace/custom-connectors/custom.openrouter-chat/bin/or_chat.py --model openai/gpt-6.2-astra --max-tokens 8000, prompt via stdin from /tmp/astra-prompt-einstein.txt
- Prompt (verbatim): pasted the riemannComponents, ricciComponents, scalarCurvature definitions and the sphere Koszul pattern, and asked for (1) Schwarzschild metric and inverse components, (2) full Christoffel symbol table with signs, (3) fderiv lemmas needed per symbol, (4) proof structure for Ric = 0 on r > 2M, sin theta != 0, per-(j,l) vs full Riemann table, with cancellations per diagonal component, (5) algebra identities for field_simp/ring, (6) Lean risks and fixes.
- Result (verbatim): saved at /tmp/astra-einstein-reply.txt. Key points recorded here:
  - Metric diag(-f, 1/f, r^2, r^2 s^2), inverse diag(-1/f, f, 1/r^2, 1/(r^2 s^2)), f = 1 - 2M/r.
  - Nonzero symbols: Gamma^t_{tr}=Gamma^t_{rt}=M/(r^2 f); Gamma^r_{tt}=M f/r^2; Gamma^r_{rr}=-M/(r^2 f); Gamma^r_{theta theta}=-r f; Gamma^r_{phi phi}=-r f s^2; Gamma^theta_{r theta}=Gamma^theta_{theta r}=1/r; Gamma^theta_{phi phi}=-s c; Gamma^phi_{r phi}=Gamma^phi_{phi r}=1/r; Gamma^phi_{theta phi}=Gamma^phi_{phi theta}=c/s.
  - fderiv table: A=M/(r^2 f), A'=-2M/(r^3 f)-2M^2/(r^4 f^2); B=M f/r^2, B'=-2M f/r^3+2M^2/r^4; d_r(-r f)=-1; d_r(-r f s^2)=-s^2, d_theta(-r f s^2)=-2 r f s c; d_r(1/r)=-1/r^2; d_theta(-s c)=s^2-c^2; d_theta(c/s)=-1/s^2. Only -r f s^2 is mixed (r and theta).
  - Ricci: split the 16 (j,l) goals, not the 256 Riemann goals. Diagonal summand table given (each row sums to zero); off-diagonal vanish by parity / cancellation of (1/r)(c/s) products in the (r,theta) case.
  - Algebra: r>0 from M>0, r>2M; f=(r-2M)/r>0; r f=r-2M; f+r f'=1; 1-f=2M/r; A B=M^2/r^4; A r f=M/r; use s^2+c^2=1 explicitly.
  - Lean risks: pointwise table equality is not derivative equality, use eventual equality on the open chart neighbourhood as in the sphere proof; one-coordinate helper does not cover products of two coordinates, use product rule for -r f s^2 and r^2 s^2; simplify discrete indices before differentiating.
- Cost: not billed to this log (run budget tracked by coordinator).

## Build log

- Check 1, flock lake build, 23:07-00:08 EST, 61m3s real (mostly lock wait), exit 1: per-declaration maxHeartbeats timeouts in the calc-based trace proof; one unsolved Minkowski trace goal. Log tail only, /tmp/einstein-check1.log.
- Checks 2-3, `lake env lean PseudoRiemannian/Einstein.lean`, exit 0 after the `einstein_trace_sum` split; U1-U3 clean. Logs /tmp/einstein-check2.log, /tmp/einstein-check3.log.
- Checks 4-5, exit 0: chunk A clean. Logs /tmp/einstein-check4.log, /tmp/einstein-check5.log.
- Checks 6-10, exit 0: chunk B clean. Logs /tmp/einstein-check6.log through /tmp/einstein-check10.log.
- Check 11, 00:26 EST, exit 1, ~62 s: chunk C, Ricci proof failed (see step log). Log /tmp/einstein-check11.log.
- Check 12, 00:28 EST, exit 1, ~77 s: 14 of 16 Ricci goals closed; Ric_tt and Ric_theta theta remained. Log /tmp/einstein-check12.log.
- Check 13, 00:30 EST, exit 1, ~56 s: 3 goals left, all plain ring identities, because `try` swallowed the ring step. Log /tmp/einstein-check13.log.
- Check 14, 00:33 EST, exit 0, ~82 s: whole file clean. Log /tmp/einstein-check14.log.
- Final, flock lake build, started 00:33 EST, finished 00:34 EST, exit 0, 4654 jobs, "Build completed successfully". Einstein module built in 41 s. Only linter warnings, all style-level (module doc-string header form, `show` vs `change`), same class as pre-existing files. Log /tmp/einstein-final-build.log.

## Axiom checks

- Check 14 (`lake env lean`, 00:33 EST, exit 0): all 30 theorems have `#print axioms` lines in the file (verified by grep: 30 theorems, 30 print lines, none missing). Every line reports `[propext, Classical.choice, Quot.sound]`, including `schwarzschild_ricci_eq_zero` and `schwarzschild_einstein_eq_zero`. No `sorryAx` anywhere.
- `grep -rn "sorry\|admit" PseudoRiemannian/Einstein.lean`: no matches.
- `grep -rn "itsdavis" PseudoRiemannian/Einstein.lean PseudoRiemannian.lean`: no matches.

## Deviations from the brief

- Metric and inverse are stated in factored form, not the brief's literal f-form: g = diag((2M-r)/r, r/(r-2M), r^2, r^2 sin^2 theta), ginv = diag(-r/(r-2M), (r-2M)/r, 1/r^2, 1/(r^2 sin^2 theta)). `schMetric_brief_form` proves these equal the brief's diag(-(1-2M/r), 1/(1-2M/r), r^2, r^2 sin^2 theta) on the chart, so the content matches the brief.
- The trace identity was split into a standalone lemma `einstein_trace_sum` because the single-declaration proof exceeded the per-declaration 200000 maxHeartbeats budget.
- `schwarzschild_einstein_eq_zero` is proved from `schwarzschild_ricci_eq_zero` (Ric = 0 gives scalar = 0, hence G = 0), not as a separate direct computation.
- Divergence-free of the Einstein tensor from Bianchi is not proved, as stated in the file header (Queued, needs general Bianchi machinery).

## Status

- U1 Einstein tensor definition: DONE, compiles clean.
- U2 vacuum equations (Ric = 0 and G = 0 forms, equivalence): DONE, compiles clean.
- U3 Minkowski Einstein = 0: DONE, compiles clean.
- U4 Schwarzschild Ric = 0 on a regular chart: DONE, compiles clean (check 14, exit 0, clean axioms).
- Final flock lake build: DONE, exit 0, 4654 jobs, finished 00:34 EST.
- Total wall time: 1 h 27 min (23:07 EST to 00:34 EST), inside the 6 h timebox.
