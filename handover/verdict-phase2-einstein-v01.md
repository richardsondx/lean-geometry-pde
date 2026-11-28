# Verdict phase2 Einstein v01

## Result

- Verdict: DONE
- Predicate: pred-mathlib-geometry-phase2-einstein-v01
- Run: stage2-mathlib-geometry-phase2-einstein-01
- Date: 28 Nov 2026
- Judge: fresh judge

- DONE means the predicate passes.
- DONE closes only this narrow predicate.
- DONE does not close the API job.
- DONE does not close divergence-free work.
- DONE does not close Kerr work.
- Divergence-free from Bianchi stays Queued.
- The API limitation below stays Queued.
- The run claims no Kerr content.

## Evidence

### Check 1: lake build exits 0

- I ran the build myself under flock.
- Command: flock /tmp/lean-phase1-build.lock lake build
- The build exits 0.
- The build reports 4654 jobs.
- The tail reads Build completed successfully.
- The output holds only module-system warnings.
- The olean file exists at 10957504 bytes.
- Checker evidence matches my run.

### Check 2: no sorry, axioms only propext, Classical.choice, Quot.sound

- I counted 30 theorems by grep.
- I counted 30 print axioms lines by grep.
- Grep finds no sorry in the file.
- Grep finds no admit in the file.
- The checker ran lake env lean on the file.
- That run exits 0 in 189 seconds.
- That run prints 30 depends on axioms lines.
- Each line reads propext, Classical.choice, Quot.sound.
- No other axiom appears.

### Check 3: Einstein tensor defined from Ricci and scalar curvature

- The file defines einsteinComponents at lines 50-58.
- The definition uses ricciComponents and scalarCurvature.
- The formula reads Ric minus one half R times g.
- The formula matches G_jl = Ric_jl - (1/2) R g_jl.

### Check 4: vacuum Einstein equations are stated

- The file defines vacuumEinsteinRicci at lines 60-64.
- The definition reads for all x j l, Ricci equals 0.
- The file defines vacuumEinsteinTensor at lines 66-71.
- The definition reads for all x j l, Einstein equals 0.
- The file proves Ric = 0 implies G = 0.
- The file proves G = 0 implies Ric = 0 in 4D.
- The reverse proof uses the trace hypothesis.
- Minkowski discharges the trace hypothesis.
- Minkowski proves the trace identity at lines 142-148.
- Minkowski proves the full equivalence at lines 150-158.

### Check 5: Minkowski Einstein tensor = 0 is proved

- The file proves minkowski_einstein_eq_zero at lines 160-163.
- The proof uses Minkowski Ricci zero and scalar zero.
- The checker confirms both lemmas live in MinkowskiTest.lean.

### Check 6: Schwarzschild Ric = 0 is proved on a regular chart

- The file proves schwarzschild_ricci_eq_zero at lines 612-641.
- The chart conditions read M > 0, r > 2M, sin theta != 0.
- The theorem covers every point on that chart.
- The theorem covers all 16 ordered component pairs.
- The metric equals the standard form by schMetric_brief_form.
- That lemma sits at lines 400-413.
- The symbols come from the Koszul formula.
- schKoszul_eq_explicit proves the symbols match the standard table.
- That lemma sits at lines 491-504.
- Astra confirms the neighborhood derivative transfer.
- The companion theorem proves G = 0 at lines 643-654.

### Core decision: the API limitation

- Both reviews agree on one core point.
- vacuumEinsteinTensor takes ginv outside its for all x.
- Both vacuum predicates quantify over all of R^4.
- Neither predicate carries a chart domain.
- Schwarzschild cannot instantiate either vacuum predicate.
- schwarzschild_einstein_eq_zero supplies schInvMetric M y pointwise.
- That supply sits at line 645 of the file.
- I ran grep myself and found no inverse identity lemma.
- schInvMetric has no proof that it inverts schMetric.
- That point still leaves Check 4 passing.
- Check 4 asks only that the file states the equations.
- The file states both forms.
- That point still leaves Check 6 passing.
- Check 6 asks only for Ric = 0 on a regular chart.
- The theorem proves exactly that.
- The predicate asks for no inverse lemma.
- The predicate asks for no chart domain object.
- The predicate asks for no bundled API.
- I add none of those asks now.
- Adding them would change the predicate.
- The API limit stays a Queued gap for the next job.

### Check 7: this ruling itself

- I am a fresh judge.
- I did not write Einstein.lean.
- I did not check Einstein.lean before.
- I did not fix Einstein.lean.
- I read the artifact, the check log, and both reviews.
- I did not read the generator log.
- I did not read the execution record.
- I ran my own build and my own greps.
- I rule DONE on this predicate only.

### Readability breaks in evidence

- These breaks do not change the substance verdict.
- check-log-phase2-einstein.md line 13 holds a 35 word sentence.
- That sentence breaks the 20 word limit.
- check-log-phase2-einstein.md line 30 holds a 32 word sentence.
- That sentence breaks the 20 word limit.
- check-log-phase2-einstein.md line 64 holds a sentence over 20 words.
- That sentence breaks the 20 word limit.
- astra-review-phase2-einstein.md line 9 holds a 21 word sentence.
- That sentence breaks the 20 word limit.
- neon-review-phase2-einstein.md line 12 holds a sentence over 20 words.
- That sentence breaks the 20 word limit.
- neon-review-phase2-einstein.md line 16 uses passive voice.
- The line reads schInvMetric is never proved to invert schMetric.

## Units

- Generator wrote Einstein.lean.
- Checker ran the build and axiom run.
- Astra reviewed the math.
- Neon reviewed the architecture.
- Judge ruled fresh on this predicate.

## Kit

- No new kit was created in this run.
- No kit file changed in this run.
- The Lean math formalization kit stays draft.

## Gaps

- Checks 1 to 6: owner checker, next step none, Fixed.
- API limitation: owner Phase 2 lead, Queued.
- Next step: make ginv a field and add a chart domain.
- Next step: bundle metric, inverse, and connection.
- Inverse proof: owner Phase 2 lead, Queued.
- Next step: prove schInvMetric inverts schMetric on the chart.
- Divergence-free from Bianchi: owner Phase 2 lead, Queued.
- Next step: build Bianchi machinery, then prove div G equals 0.
- Kerr content: owner Phase 2 lead, Queued.
- Next step: none in this predicate.

## Cost and envelope

- Judge made 0 model calls.
- Judge spent $0 on model calls.
- No run cost figure appears in the task.
- I record no run total.
- No predicate change was made.
- No scope change was made.
- Judge wall time is under 10 minutes.
- The build took about 95 seconds inside that time.

## Next step

- Next step: Phase 2 lead starts the API job.
- That job makes ginv a field.
- That job adds a chart domain.
- That job proves schInvMetric inverts schMetric.
- That job lands before Kerr work starts.
- Divergence-free stays queued behind Bianchi machinery.
