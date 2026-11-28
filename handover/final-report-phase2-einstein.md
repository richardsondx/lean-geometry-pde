# Final report: Phase 2 Einstein equations

- Run: stage2-mathlib-geometry-phase2-einstein-01.
- Predicate: pred-mathlib-geometry-phase2-einstein-v01.
- Date: 28 Nov 2026.
- Word meanings: pass means a check meets its bar. Fail means a check does not meet its bar. Done means a unit has a commit and its checks pass. Gap means work that remains. Check means the act of verification on the real artifact. Cost means money the run spent. Fixed means a gap is done, tested, and re-checked in the same run. Queued means a gap is recorded as the next job.

## Result

- Verdict: DONE.
- Predicate: pred-mathlib-geometry-phase2-einstein-v01.
- The file proves 30 theorems.
- The build exits 0.
- The axioms read only propext, Classical.choice, Quot.sound.
- DONE closes only this narrow predicate.
- DONE does not close the API job.
- DONE does not close divergence-free work.
- DONE does not close Kerr work.
- The run claims no Kerr content.

## Evidence

- Check 1 pass: the build exits 0.
- The build reports 4654 jobs.
- The build ran under flock.
- The olean file exists at 10957504 bytes.
- Check 2 pass: grep finds no sorry.
- Grep finds no admit.
- The file holds 30 theorems.
- The file holds 30 print axioms lines.
- Each line reads propext, Classical.choice, Quot.sound.
- The axiom run exits 0 in 189 seconds.
- Check 3 pass: einsteinComponents sits at lines 50-58.
- The formula reads Ric minus one half R times g.
- It uses ricciComponents and scalarCurvature.
- Check 4 pass: vacuumEinsteinRicci sits at lines 60-64.
- vacuumEinsteinTensor sits at lines 66-71.
- The file proves Ric = 0 implies G = 0.
- The file proves G = 0 implies Ric = 0 in 4D.
- Minkowski discharges the trace hypothesis at lines 142-148.
- Minkowski proves the full equivalence at lines 150-158.
- Check 5 pass: minkowski_einstein_eq_zero sits at lines 160-163.
- Check 6 pass: schwarzschild_ricci_eq_zero sits at lines 612-641.
- The chart conditions read M > 0, r > 2M, sin theta != 0.
- The theorem covers every point on that chart.
- The theorem covers all 16 ordered component pairs.
- schMetric_brief_form proves the metric equals the standard form.
- schKoszul_eq_explicit proves the symbols match the standard table.
- The checker ran every check itself.
- The checker reports all 6 checks pass.
- Astra reviewed the math.
- Neon reviewed the architecture.
- Both reviews sit verbatim in the run folder.
- The judge read the artifact, the check log, and both reviews.
- The judge ran its own build and greps.
- The judge rules DONE.
- The judge flags readability breaks in the check log and reviews.
- Those breaks do not change the substance verdict.
- The breaks sit in verbatim records.
- Verbatim records stay unchanged.

## Units

- U1 Einstein tensor: generator, done.
- U2 vacuum equations: generator, done.
- U3 Minkowski instance: generator, done.
- U4 Schwarzschild instance: generator, done.
- U1-U4 wall time: 1 h 27 min.
- Checker: independent checker, done.
- Checker wall time: about 6 min plus a 189 s axiom run.
- U5 hostile review: Astra and Neon, done.
- Astra review wall time: about 19 s.
- Neon review wall time: about 79 s.
- U6 final report and judge: coordinator and fresh judge, done.
- Judge wall time: about 3 min.

## Kit

- Kit: Case B, Lean verification kit, draft.
- Path: ~/workspace/handover-mathlib-geometry-2026-11-26/.
- What it is: compile exit 0 with no sorry, property tests, audit with file, line, and source, hostile review recorded verbatim.
- Proof status: draft.
- The kit passed three real task proofs before this run.
- This run is its fourth proof run.
- No new kit was created in this run.
- No proven field CLI exists for this work.
- Verification falls back to the predicate plus manual commands.
- The fallback commands are flock lake build, sorry grep, and print axioms.
- The draft kit is not presented as proven.

## Gaps

- Checks 1 to 6: Fixed.
- Owner: checker.
- Next step: none.
- API limitation: Queued.
- Owner: Phase 2 lead.
- The vacuum predicates take a constant ginv outside the quantifier.
- Neither predicate carries a chart domain.
- Schwarzschild cannot instantiate either vacuum predicate.
- schInvMetric has no proof that it inverts schMetric.
- Next step: make ginv a field.
- Next step: add a chart domain.
- Next step: bundle metric, inverse, and connection.
- Next step: prove schInvMetric inverts schMetric on the chart.
- The judge ruled this point fails neither Check 4 nor Check 6.
- Check 4 asks only that the file states the equations.
- Check 6 asks only for Ric = 0 on a regular chart.
- Divergence-free from Bianchi: Queued.
- Owner: Phase 2 lead.
- Next step: build Bianchi machinery.
- Next step: prove div G equals 0.
- Kerr vacuum instance: Queued.
- Owner: Phase 2 lead.
- Next step: none in this predicate.
- Kerr is a follow-up, not proved here.
- No gap in this run is presented as done.

## Cost and envelope

- Cap: $4 hard cap.
- Run budget: $3.40.
- Held back: $0.60.
- Spent: no tool in this run reports a dollar figure.
- or_chat.py prints no cost for its three calls.
- No spend total is recorded.
- No spend total is guessed.
- Fix cycles used: 0 of 5 after independent checking.
- The generator fixed three failing drafts before handover.
- The checker passed on its first run.
- No predicate change was made.
- No scope change was made.
- Run wall time: 1 h 43 min.
- Run start: 23:03 EST 27 Nov 2026.
- Run end: 00:46 EST 28 Nov 2026.

## Next step

- Next step: Phase 2 lead starts the API job.
- That job makes ginv a field.
- That job adds a chart domain.
- That job proves schInvMetric inverts schMetric.
- That job lands before Kerr work starts.
- Divergence-free stays queued behind Bianchi machinery.
- Integration and push need a separate approval.
- No file is pushed to the repo in this run.
