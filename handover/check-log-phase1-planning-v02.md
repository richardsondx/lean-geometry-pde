# U7 re-check log v02, stage2-mathlib-geometry-phase1-planning-01

Date: 26 Nov 2026, evening EST. Re-checker: independent, did not write the artifacts and did not fix them.
Work folder: ~/workspace/handover-mathlib-geometry-2026-11-26/
Spec: stage1-package-phase1-planning-v01.md, stage2-manifest-phase1-planning-v01.md, predicate pred-mathlib-geometry-phase1-planning-v01.
Baseline checked: Lean 4.23.0, Mathlib v4.23.0, local tree ~/workspace/kerr-stability-lean/kerr-mathlib/.lake/packages/mathlib, commit 37df177aaa770670452312393d4e84aaad56e7b6, tag v4.23.0, verified again by git rev-parse and git describe.
Fix attempts used so far: 1 of 5.
This re-check made no new model calls and no new API calls, per the task.

## Overall verdict: FAIL

The doc fixes in fix cycle 1 verify by grep, but the predicate is not met. The two hostile reviews are still missing, the live sources are still not re-opened, and the signature lock is still not made. Those three items are predicate level, not doc polish. The v4.36.0 and PR 36128 claims remain verified by the generator alone, not by an independent re-open.

## Method

Every tree claim below was re-checked by grep or file read in the local v4.23.0 tree. The fix log was not taken on trust. RFC lines were read with line numbers.

## Per-gap verdicts

### GAP-3: FIXED

ARCHITECTURE.md line 37 now imports Mathlib.Geometry.Manifold.Riemannian.PathELength, not the Distance path. The false claim about exact leaf paths verified in Step 0 is gone from the operative imports line. The Distance path now appears only in the generator verification note at lines 139 to 144, quoting what Neon wrote. Local check: Mathlib/Geometry/Manifold/Riemannian holds only Basic.lean and PathELength.lean.

### GAP-4: FIXED, with one path carried

ARCHITECTURE.md line 14 now uses Mathlib.Geometry.Manifold.VectorBundle.CovariantDerivative.Basic, with the VectorBundle segment present. The same correct path appears at lines 52 and 93.
Flagged extra path: Mathlib.Geometry.Manifold.VectorBundle.LocalFrame, in the Metric imports at line 32, returns 0 hits in the v4.23.0 tree, and no file of that name exists in Mathlib/Geometry/Manifold/VectorBundle. It is not in the verified v4.36.0 list in the docs. The fixer did not invent a replacement. It is flagged in the generator verification notes with an instruction to confirm it at Step 0 before any file uses it. Carried as an open Step 0 check under GAP-4, not a new gap on its own.

### GAP-5: FIXED

MissingInventory.md now says 0 hits for Riemann curvature or Ricci, and that the string Riemann returns 336 hits tree-wide, all Riemann-integral or Riemannian-adjective uses, none of them Riemann curvature.
Re-checked by grep: Riemann 336 hits, case-insensitive riemann curvature or ricci 0 hits, Ricci 0 hits.

### GAP-6: FIXED

MissingInventory.md now qualifies the claim: expMap returns 0 hits in Mathlib/Geometry/Manifold, so no geometric exponential map exists there, and tree-wide it returns 192 hits, 189 of them a number-field expMap in Mathlib/NumberTheory/NumberField/CanonicalEmbedding/NormLeOne.lean.
Re-checked by grep: 192 tree-wide, 0 in Geometry/Manifold, 189 in NormLeOne.lean, 3 in Mathlib/Analysis/SpecialFunctions/Complex/Circle.lean.

### GAP-7: STILL OPEN, draft accurate

The amendment draft at docs/SignatureOrdering-Amendment-Draft.md quotes the RFC lines accurately.
Verified line by line: RFC_PseudoRiemannian.md line 37 starts with the diag matrix text and line 38 ends with plus ones, lines 39 to 40 give Lorentzian as the signature (1, 3) case, line 42 gives Riemannian as the signature (n, 0) case. RFC_Conventions.md line 78 gives LorentzianMetric for the signature (1, 3) case, line 79 gives Riemannian as the signature (n, 0) case.
The draft proposes the lock (p, q) equals (pluses, minuses), Lorentzian (3, 1), Riemannian (n, 0). It lists the exact lines that would change: RFC_PseudoRiemannian.md lines 37 to 38 and 39 to 40, RFC_Conventions.md line 78. It lists the lines that need no change, and those check out: RFC_PseudoRiemannian.md lines 9 to 10 and 24 to 25 state the Riemannian (n, 0) case, line 42 is correct under the proposed lock, RFC_Conventions.md line 79 is correct under the lock, and lines 11 to 14 lock (-, +, +, +), which is not in dispute.
Both RFCs are untouched: they still contain the original (1, 3) lines at the quoted line numbers.
Still open because the lock decision belongs to Richardson with the Phase 1 lead, and it has not been made. No Phase 1 file is to be written until it is locked.

### GAP-8: FIXED

ARCHITECTURE.md GeometricBase imports at line 79 now include Mathlib.Analysis.InnerProductSpace.LaxMilgram and Mathlib.Analysis.ODE.Gronwall, and both edges appear in the dependency graph at lines 111 to 112.
Verified: both files exist in the local tree. continuousLinearEquivOfBilin is defined at LaxMilgram.lean:102. Gronwall.lean defines gronwallBound at line 39 and the gronwallBound theorems.

### GAP-9: CARRIED as an open decision, acceptable for the planning predicate

Recorded as an open decision in both files. ARCHITECTURE.md line 38 annotates the scoped instances as an open decision, and the Open Decisions entry at line 135 names the tension, the owner (Phase 1 lead), and the two options: drop the scoped instances and rely on the existing registration, or record exactly why they are needed. InteropExample.md has the same open decision section, naming the same owner and options.
Instance lines verified by grep: Mathlib/Geometry/Manifold/VectorBundle/Riemannian.lean:257 is the instance from any ContMDiffRiemannianMetric, Mathlib/Topology/VectorBundle/Riemannian.lean:431 and :442 are the scoped priority 80 instances, with the NormedAddCommGroup type at line 432 and the InnerProductSpace type at line 443.
Ruling for the judge: recording this as an open decision owned by the Phase 1 lead is acceptable for this planning predicate, and it does not block DONE on its own. Planning allows a named open decision with an owner and clear options, and the tension is now explicit in both files instead of hidden. It must be resolved before any Phase 1 file uses those scoped instances.

### GAP-1: STILL OPEN, egress

Both hostile reviews are still missing. No reply was obtained in either run.
Checker evidence from check-log-phase1-planning.md: 4 attempts, 0 replies. Neon (google/gemini-4-neon) twice and Astra (openai/gpt-6.2-astra) twice, each with max tokens 8000, prompt via stdin, both failed at the HTTPS CONNECT tunnel with remote end closed without response. Both retries allowed in that check were used.
Fixer evidence from fix-log-cycle1.md: 1 attempt per model, no retries, both failed at the tunnel. Neon timed out after 120 seconds, Astra failed with remote end closed without response. No reply was appended.
The saved prompts remain at /tmp/u7probes/prompt-neon-review.md and /tmp/u7probes/prompt-astra-review.md for a later run when egress recovers.
This re-check made no new model calls, per the task, so nothing here cures the gap.

### GAP-2: STILL OPEN, egress

No live source was re-opened in either run.
Checker evidence: GitHub API batch for PR 36128 and the v4.36.0 release returned empty bodies, then connectivity probes to openrouter.ai and api.github.com returned HTTP 000 with timeout. Browser reads of the PR and release pages failed with a network grant error and were not repeated.
Fixer evidence: one curl batch for PR 36128 and the v4.36.0 release, plus connectivity probes, all four calls returned HTTP 000, batch exited 28 on timeout.
Consequence, stated plainly: the generator's v4.36.0 and PR 36128 claims remain verified by the generator alone, not by an independent re-open. That includes PR 36128 status and files, the v4.36.0 release date, the CovariantDerivative landing window, Sobolev.lean presence at v4.36.0, the master Sobolev.lean line numbers, the Hilbert6 LeviCivita first import at pinned commit ddbe9da, and the v4.36.0 Riemannian directory contents.

### GAP-10: CARRIED

Phase 3 acceptance-test parameters remain unfixed (dimension, target exponent, weight convention, s, delta, local regularity, Poincare and trace hypotheses). Carried to the Phase 3 lead, as the docs already record. Not changed in this cycle, not a fail item on its own.

## Ruling on GAP-1 and GAP-2 for the judge

The predicate cannot be DONE with GAP-1 and GAP-2 carried. It must be GAP until egress recovers.
Reason: the stage 1 package defines U7 as a fresh checker re-opening every claim, with the hostile review recorded with model id, prompt, and result. Without the two cross-reviews, the independent check is incomplete by definition, and without re-opening the live sources, the baseline decision rests on the generator alone. Carrying those two gaps would change what DONE means for this run, and no predicate change was approved. The fix is to re-run the two saved prompts unchanged and the live-source checks when egress recovers, then record both replies verbatim with model id, max tokens, and outcome, and answer each point raised.

## Forbidden content check on the fixed docs

Scanned ARCHITECTURE.md, MissingInventory.md, InteropExample.md, and SignatureOrdering-Amendment-Draft.md: no em dash character, no forbidden domain string, no apology word, no Lean code blocks. No Phase 1 Lean code was added. No push, post, repo edit, deploy, or email in this re-check.

## What remains open

- GAP-1: both hostile reviews, waiting on egress recovery.
- GAP-2: live-source re-open of PR 36128 and v4.36.0, waiting on egress recovery.
- GAP-7: signature ordering lock, waiting on Richardson with the Phase 1 lead.
- GAP-9: scoped instances decision, carried, owned by the Phase 1 lead, to be resolved before any Phase 1 file uses those instances.
- GAP-10: Phase 3 parameters, carried to the Phase 3 lead.
- GAP-4 sub-item: LocalFrame import path, confirm at Step 0 before any file uses it.

## Cost

- Model calls in this re-check: 0, per the task. No API calls.
- Fix attempts used so far: 1 of 5.
