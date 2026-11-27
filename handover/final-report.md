# Final report, Mathlib geometry Phase 0 audit

Date: 26 Nov 2026
Run: stage2-mathlib-geometry-phase0-01
Predicate: pred-mathlib-geometry-phase0-v01
Verdict: DONE
Repo: https://github.com/richardsondx/lean-geometry-pde, public, empty. Files stay local, no push.

## Result

- Phase 0 audit is done.
- The audit file compiles clean, exit 0, twice.
- Three RFCs exist, with conventions locked.
- The judge verdict is DONE, in verdict-v01.md.

## Evidence

- Audit file: Audit/MathlibInventory-v02.lean, 33 live #check lines, 10 commented out, exit 0 in 13.05 seconds on re-check, exit 0 in 10 seconds on first run.
- Inventory: Audit/inventory-v02.md, 33 confirmed present, 9 confirmed absent, 1 confirmed in a satellite repo, each with file path and line number.
- PR 36128: not merged in v4.23.0. GitHub API says state open, merged false, merged_at null, created 4 Mar 2026.
- Physicslib4: map/Physicslib4-assessment-v02.md, generalisation decision is generalise to PseudoRiemannianMetric with signature (p, q). Port split: metric and musical layer ports cleanly, Levi-Civita layer does not port to v4.23.0. Repo renamed to hilbert6/hilbert6.
- Plan corrections: Sobolev Bessel potential spaces do not exist in v4.23.0. SmoothManifoldWithCorners does not exist. The class is IsManifold.
- Hostile reviews: check-log.md, verbatim. Gemini 4 Neon, google/gemini-4-neon, 8000 max tokens, first attempt. GPT-6.2 Astra, openai/gpt-6.2-astra, 8000 max tokens, first attempt.
- Re-check: check-log-v02.md, verdict PASS, all items re-tested directly.

## Units

- U1 audit: done. 43 #check lines, 33 present, 9 absent, 1 satellite.
- U2 Physicslib4 read: done. Port assessment and generalisation decision in map/Physicslib4-assessment-v02.md.
- U3 RFCs: done. docs/RFC_PseudoRiemannian.md, docs/RFC_Sobolev.md, docs/RFC_Conventions.md. Signature (-, +, +, +) locked.
- U4 independent check: done. First verdict FAIL on GAP-1 to GAP-5. Fix cycle 1 corrected GAP-1, GAP-2, GAP-3 in v02 files. Re-check verdict PASS.
- U5 final report and judge verdict: done. Verdict DONE in verdict-v01.md.

## Kit

- Research brief kit, reused, pilot, workspace/handover-v1/kits/research-brief/.

## Gaps

- GAP-4a, no downstream example: Queued, owner Phase 1 lead. Elaborate one minimal downstream example per alleged blocker in Phase 1.
- GAP-4b, vendoring cost and newer Mathlib revision unmeasured: Queued, owner Phase 1 lead. Measure the cost or name the target revision in Phase 1 planning.
- GAP-4c, generalisation interop unproven: Queued, owner Phase 1 lead. Build the (n, 0) interop example with Bundle.ContMDiffRiemannianMetric in Phase 1.
- GAP-4d, baseline reason missing: Queued, owner Phase 1 lead. Record why v4.23.0 stays or move the baseline in Phase 1 planning.
- GAP-5a, /tmp/probes logs not re-checked: Queued, owner Phase 1 lead. Re-open before relying on probe timings, or re-run the probes if the logs are gone.
- GAP-5b, PR 36128 Riemann sign untested: Queued, owner Phase 1 lead. Read the PR source for its sign when next reviewed. If opposite, revise RFC_Conventions.md per its trigger.

## Cost and envelope

- Hard cap: $4.
- Run budget: $3.40.
- Held back: $0.60.
- Spend: generator $0, no model calls. Checker 2 model calls, no dollar figure reported by the tool, no retries, well under the cap.
- Fix attempts: 1 of 5 used.

## Next step

- Approve Phase 1 planning only, with the GAP-4 items as its first tasks.
- Do not start Phase 1 code until the PR 36128 dependency decision is made: wait, vendor, or move to a newer Mathlib.
- Files stay local until the GitHub App installation covers lean-geometry-pde. No push was attempted in this run.
