# Final report, Mathlib geometry Phase 1 planning, stage2-mathlib-geometry-phase1-planning-01

Date: 26 Nov 2026. Judge verdict: GAP. Full verdict: verdict-phase1-planning-v01.md in the same folder.

## Result

- Verdict is GAP, not DONE.
- The planning docs are delivered and the local tree claims spot-checked by the judge verify.
- Three predicate level pieces are still missing, so U7 is not passed.
- No gap was converted into a pass.

## Evidence

- Judge read the spec, the manifest, the plan, all six generator docs, the amendment draft, both check logs, and the fix log in full.
- Judge spot-checked by grep in the local Mathlib v4.23.0 tree, commit 37df177aaa770670452312393d4e84aaad56e7b6.
- Riemann returns 336 hits, Riemann curvature or Ricci returns 0 hits, matching the fixed inventory wording.
- expMap returns 192 hits tree-wide and 0 hits in Mathlib/Geometry/Manifold, matching the fixed wording.
- The Riemannian directory holds only Basic.lean and PathELength.lean, matching the fixed architecture imports.
- The LaxMilgram and Gronwall files exist, and continuousLinearEquivOfBilin is defined at LaxMilgram.lean:102.
- The RFCs still contain the original (1, 3) lines, and the amendment draft quotes them accurately.
- The saved hostile-review prompts still exist unchanged at /tmp/u7probes/prompt-neon-review.md and /tmp/u7probes/prompt-astra-review.md.
- No hostile review reply exists anywhere in the run folder.

## Units U1 to U8

- U1 architecture: delivered, docs/ARCHITECTURE.md, 10 modules with imports, exports, forbids, dependency graph, build order.
- U2 downstream examples: delivered, docs/DownstreamExamples.md, four examples, all four probes re-run by the checker and failing exactly as quoted.
- U3 baseline decision: delivered, docs/BaselineDecision.md, move to v4.36.0, PR 36128 vendoring cost measured at 13 files, 3,901 new lines, +307/-30 edited lines.
- U4 Sobolev routes: delivered, docs/SobolevRoutes.md, weak-derivative route versus Bessel potential route, bridge theorem named.
- U5 interop example: delivered, docs/InteropExample.md, (n, 0) case, instance conflicts named, lost lemmas named.
- U6 missing inventory: delivered, docs/MissingInventory.md, all 15 items covered, Lax-Milgram the one present item.
- U7 independent check: FAIL, both hostile reviews missing, live sources not re-opened.
- U8 final report and judge verdict: this report and verdict-phase1-planning-v01.md.

## Gaps with owners

- GAP-1 hostile reviews missing. Owner: checker (U7). Next step: re-run the two saved prompts unchanged when egress recovers, record both replies verbatim, answer each point raised.
- GAP-2 live sources not re-opened. Owner: checker (U7). Next step: re-run the GitHub API and contents checks for PR 36128 and v4.36.0 when egress recovers, record what verifies.
- GAP-3 wrong Riemannian path. Fixed. No further step.
- GAP-4 wrong CovariantDerivative path. Fixed, with the LocalFrame import carried as a Step 0 check. Owner: Phase 1 lead.
- GAP-5 wrong Riemann grep wording. Fixed. No further step.
- GAP-6 wrong expMap wording. Fixed. No further step.
- GAP-7 signature ordering lock. Owner: Richardson with the Phase 1 lead. Next step: lock (p, q) as (pluses, minuses), Lorentzian (3, 1), Riemannian (n, 0), amend both RFCs at the lines the draft lists.
- GAP-8 missing LaxMilgram and Gronwall imports. Fixed. No further step.
- GAP-9 scoped instances decision. Carried, owned by the Phase 1 lead. Next step: resolve before any Phase 1 file uses those instances.
- GAP-10 Phase 3 acceptance-test parameters. Carried, owned by the Phase 3 lead. Next step: fix the parameters in Phase 3.

## Cost

- Model calls: 12 attempts in total, 6 successful replies.
- Generator: 6 calls, 4 Neon and 2 Astra.
- Original checker: 4 attempts, 0 successes.
- Fix cycle 1: 2 attempts, 0 successes.
- Re-checker: 0 calls. Judge: 0 calls.
- The tool reports no dollar figure, so no dollar spend is claimed here.
- Hard cap $4, run budget $3.40, held back $0.60, per the spec.
- Fix attempts used: 1 of 5.

## Next step

- Wait for egress to recover, then re-run the two saved hostile-review prompts unchanged and the live-source checks.
- Ask Richardson to lock the signature ordering, then amend the two RFCs.
- Run a fresh re-check and a new judge verdict after those three pieces land.
- No push, post, repo edit, deploy, or email in this run.
