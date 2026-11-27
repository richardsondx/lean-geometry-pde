# Judge verdict, stage2-mathlib-geometry-phase1-planning-01, unit U8

Date: 26 Nov 2026, evening EST. Judge: fresh context, did not write the artifacts, did not check them, did not fix them.
Predicate: pred-mathlib-geometry-phase1-planning-v01
Spec: stage1-package-phase1-planning-v01.md and stage2-manifest-phase1-planning-v01.md
Plan: ~/workspace/mathlib-geometry-plan-2026-11-26/PLAN.md
Work folder: ~/workspace/handover-mathlib-geometry-2026-11-26/

## Verdict: GAP

The planning docs are delivered and the local tree claims I spot-checked verify, but three predicate level pieces are missing: both hostile reviews, the live-source re-open of the baseline claims, and the signature ordering lock. DONE requires every unit U1-U6 delivered, U7 passed with the cross-review recorded, and no blocking gap carried. U7 is not passed and GAP-7 is still open, so the verdict is GAP. No gap was converted into a pass.

## What the judge verified independently

- Signature inconsistency, confirmed by direct read of the RFCs: docs/RFC_PseudoRiemannian.md lines 37-38 define (p, q) as p minus ones and q plus ones, lines 39-40 call Lorentzian the (1, 3) case, line 42 calls Riemannian the (n, 0) case. Under the lines 37-38 rule, (n, 0) means n minus ones, which is negative definite, not Riemannian. docs/RFC_Conventions.md line 78 calls LorentzianMetric the (1, 3) case and line 79 calls Riemannian the (n, 0) case, same inconsistency. Lines 11-14 of the same file lock (-, +, +, +), which is not in dispute. The amendment draft quotes all of these lines accurately and both RFCs are still untouched.
- GAP-5, confirmed by grep in the local Mathlib tree (commit 37df177aaa770670452312393d4e84aaad56e7b6, tag v4.23.0): the string Riemann returns 336 hits, case-insensitive Riemann curvature or Ricci returns 0 hits, Ricci returns 0 hits. The fixed wording in docs/MissingInventory.md matches.
- GAP-6, confirmed by grep in the same tree: expMap returns 192 hits tree-wide, 0 hits in Mathlib/Geometry/Manifold, 189 of them in Mathlib/NumberTheory/NumberField/CanonicalEmbedding/NormLeOne.lean. The fixed wording matches.
- GAP-3, confirmed: Mathlib/Geometry/Manifold/Riemannian holds only Basic.lean and PathELength.lean, and docs/ARCHITECTURE.md now imports PathELength in the operative line. The old Distance path appears only in the generator verification note.
- GAP-4, confirmed in part: docs/ARCHITECTURE.md line 14 now uses Mathlib.Geometry.Manifold.VectorBundle.CovariantDerivative.Basic. The LocalFrame import at line 32 is still unverified: 0 hits in the local tree and no file of that name in Mathlib/Geometry/Manifold/VectorBundle. It is carried as a Step 0 check, not a new gap.
- GAP-8, confirmed: both LaxMilgram and Gronwall files exist in the local tree, continuousLinearEquivOfBilin is defined at LaxMilgram.lean:102, and both imports now appear in the GeometricBase imports and dependency graph.
- Saved hostile-review prompts still exist unchanged at /tmp/u7probes/prompt-neon-review.md and /tmp/u7probes/prompt-astra-review.md.
- No hostile review reply exists anywhere in the run folder. No live-source re-open was recorded in either check log or the fix log.

## What passed

- U1 architecture: docs/ARCHITECTURE.md delivered, 10 modules with imports, exports, forbids, dependency graph, build order, open decisions. Two wrong paths fixed in fix cycle 1 and verified by the re-checker and by this judge.
- U2 downstream examples: docs/DownstreamExamples.md delivered, four examples with probes and errors. The checker re-ran all four probes and they fail exactly as quoted. Example 4 has no failing probe, which the doc states plainly; whether it satisfies the Stage 1 wording stays open inside GAP-1 because the Neon review meant to rule on it never ran.
- U3 baseline decision: docs/BaselineDecision.md delivered, move to v4.36.0 recommended, PR 36128 vendoring cost measured at 13 files, 3,901 new lines, +307/-30 edited lines. The numbers rest on the generator alone until GAP-2 is closed.
- U4 Sobolev routes: docs/SobolevRoutes.md delivered, weak-derivative route versus Bessel potential route, each tied to specific Phase 3 statements, bridge theorem named, false dichotomy corrected.
- U5 interop example: docs/InteropExample.md delivered, (n, 0) case against Bundle.ContMDiffRiemannianMetric, instance conflicts named, lost lemmas named, plain-def conversion rule, light-cone obstruction.
- U6 missing inventory: docs/MissingInventory.md delivered, all 15 items covered with file and line, Lax-Milgram the one present item. Two literal grep wordings fixed in fix cycle 1 and verified by the re-checker and by this judge.
- Forbidden content: no em dash character, no forbidden domain string, no Lean code blocks, no Phase 1 Lean code in the six docs.

## What failed

- U7 independent check: FAIL in the original check log and FAIL again in the re-check log. The fresh checker re-opened the local tree claims, but the two hostile reviews do not exist and the live sources were not re-opened. U7 as specified requires the hostile review recorded with model id, prompt, and result. Without it, U7 is incomplete by definition.
- GAP-7 signature ordering: still open. The draft is accurate and ready, the RFCs are untouched, and the lock decision belongs to Richardson with the Phase 1 lead. No Phase 1 file can be written until it is locked, because the architecture module exports assume (pluses, minuses) while the Phase 0 lock says the opposite.

## Gaps, with owner and next step

- GAP-1, hostile reviews missing. Owner: checker (U7). Next step: re-run the two saved prompts at /tmp/u7probes/prompt-neon-review.md and /tmp/u7probes/prompt-astra-review.md unchanged when egress recovers, record both replies verbatim with model id, max_tokens, and outcome, and answer each point raised. Evidence: 6 failed attempts in total, 4 in the original check (Neon twice, Astra twice, both failed at the HTTPS CONNECT tunnel) and 2 in fix cycle 1 (one per model, same failure). Both retries allowed in the original check were used.
- GAP-2, live sources not re-opened. Owner: checker (U7). Next step: re-run the GitHub API and contents checks when egress recovers and record what verifies and what does not, covering PR 36128 status and files, the v4.36.0 release date, the CovariantDerivative landing window, Sobolev.lean presence at v4.36.0, the master Sobolev.lean line numbers, the Hilbert6 LeviCivita first import at pinned commit ddbe9da, and the v4.36.0 Riemannian directory contents. Until then the v4.36.0 and PR 36128 claims rest on the generator alone.
- GAP-3, fixed. Owner: generator. No further step. Path corrected to PathELength, false verification claim removed.
- GAP-4, fixed, with one carried sub-item. Owner: generator. Next step: confirm whether Mathlib.Geometry.Manifold.VectorBundle.LocalFrame exists under that name on v4.36.0 at Step 0 before any file uses it, and correct the import if it does not.
- GAP-5, fixed. Owner: generator. No further step. Wording now says 0 hits for Riemann curvature or Ricci, with the 336 Riemann hits explained.
- GAP-6, fixed. Owner: generator. No further step. Wording now qualifies expMap as 0 hits in Mathlib/Geometry/Manifold.
- GAP-7, signature ordering lock. Owner: Richardson with the Phase 1 lead. Next step: Richardson locks (p, q) = (pluses, minuses), Lorentzian (3, 1), Riemannian (n, 0), and the two RFCs are amended at the exact lines the draft lists: docs/RFC_PseudoRiemannian.md lines 37-38 and 39-40, docs/RFC_Conventions.md line 78. Lines 42, 9-10, 24-25 in RFC_PseudoRiemannian.md and line 79 in RFC_Conventions.md need no change under the proposed lock.
- GAP-8, fixed. Owner: generator. No further step. LaxMilgram and Gronwall imports added to GeometricBase and to the dependency graph.
- GAP-9, scoped instances, carried as an open decision. Owner: Phase 1 lead. Next step: before any Phase 1 file uses those scoped instances, drop them and rely on the existing registration at VectorBundle/Riemannian.lean:257 as the sole source, or record exactly why they are needed despite it, naming each instance. This is recorded in both docs/ARCHITECTURE.md and docs/InteropExample.md with owner and options. It does not block DONE on its own.
- GAP-10, Phase 3 acceptance-test parameters, carried. Owner: Phase 3 lead. Next step: fix dimension, target exponent, weight convention, s, delta, local regularity, and the Poincare and trace hypotheses in Phase 3. Not a fail item on its own.

## Verdict conflicts resolved

- Re-checker ruling on GAP-1 and GAP-2, accepted: the predicate cannot be DONE with these two carried, because U7 requires a fresh checker re-opening every claim with the hostile review recorded, and the v4.36.0 and PR 36128 baseline claims rest on the generator alone. Carrying them would change what DONE means, and no predicate change was approved.
- Re-checker ruling on GAP-9, accepted: a named, owned open decision with clear options does not block DONE on its own for a planning predicate. It must still be resolved before any Phase 1 file uses the scoped instances.
- Re-checker ruling on GAP-10, accepted: carried to the Phase 3 lead, not a fail item on its own.
- Re-checker ruling on the GAP-4 LocalFrame sub-item, accepted: carried as a Step 0 check, not a new gap on its own.
- Original checker note that example 4 has no failing probe, left open: the doc is honest about it, and the ruling on whether it satisfies the Stage 1 wording belongs to the Neon hostile review, which never ran. It stays open inside GAP-1.

## Exact conditions that would turn GAP into DONE

1. Egress recovers, and the two saved hostile-review prompts at /tmp/u7probes/prompt-neon-review.md and /tmp/u7probes/prompt-astra-review.md are re-run unchanged, one Neon review of Astra math and one Astra review of Neon architecture. Both replies are recorded verbatim with model id, max_tokens, and outcome, and each point raised is answered in the docs or in a check log.
2. The live-source checks are re-run when egress recovers, and the results are recorded: PR 36128 status and files, v4.36.0 release date, CovariantDerivative landing window, Sobolev.lean presence at v4.36.0, master Sobolev.lean line numbers, Hilbert6 LeviCivita first import at ddbe9da, v4.36.0 Riemannian directory contents. Anything that does not verify is corrected in the docs.
3. Richardson locks the signature ordering with the Phase 1 lead, (p, q) = (pluses, minuses), Lorentzian (3, 1), Riemannian (n, 0), and docs/RFC_PseudoRiemannian.md and docs/RFC_Conventions.md are amended at the exact lines listed under GAP-7.
4. A fresh re-check confirms conditions 1 to 3, confirms the carried items are still owned and recorded (GAP-9 with the Phase 1 lead, GAP-10 with the Phase 3 lead, LocalFrame path confirmed at Step 0), and a new judge verdict in fresh context returns DONE.
5. No predicate, cost, or scope change is needed for conditions 1 to 4. Fix attempts used so far: 1 of 5, so 4 remain.

## Cost and calls

- Generator: 6 model calls, 4 Neon (google/gemini-4-neon) and 2 Astra (openai/gpt-6.2-astra), all returned replies.
- Original checker: 4 model call attempts, 0 successes.
- Fix cycle 1: 2 model call attempts, 0 successes.
- Re-checker: 0 model calls.
- Judge (this verdict): 0 model calls.
- Total: 12 model call attempts, 6 successful replies. The tool reports no dollar figure, so no dollar spend is claimed here and no figure is invented. Hard cap $4, run budget $3.40, held back $0.60, per the spec.
- Fix attempts used: 1 of 5. No push, post, repo edit, deploy, or email in this run.
