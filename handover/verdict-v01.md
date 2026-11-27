# Judge verdict, stage2-mathlib-geometry-phase0, unit U5

Date: 26 Nov 2026, evening EST. Judge: fresh context, no producer reasoning seen.
Predicate: pred-mathlib-geometry-phase0-v01.
Artifacts judged (v02 are current): Audit/MathlibInventory-v02.lean,
Audit/inventory-v02.md, map/Physicslib4-assessment-v02.md,
docs/RFC_PseudoRiemannian.md, docs/RFC_Sobolev.md, docs/RFC_Conventions.md.
Evidence: check-log.md (U4, FAIL, GAP-1 to GAP-5),
check-log-v02.md (re-check, PASS), PLAN.md.

## Verdict: DONE

Phase 0 meets the predicate. The audit is machine checked, every
uncertain item is resolved, the three RFCs lock the conventions, the
fresh checker re-opened every verdict-bearing source, and both hostile
reviews are recorded. The open method limits (GAP-4) and minors
(GAP-5) are recorded in writing with an owner and a next step. They
are Phase 1 work, not Phase 0 requirements, so they do not block DONE.

## Evidence per predicate item

1. Audit file with #check lines for every API in the plan, each item
marked confirmed present, confirmed absent, or confirmed in a named
satellite repo, with file path and line number: PASS.
- Audit/MathlibInventory-v02.lean, header line 19: 33 of 43 #check
lines compiled, 10 failed. Grep counts confirm 33 live lines and
10 commented-out lines.
- The file re-ran clean twice: check-log.md Check 1, exit 0 in
16.6s; check-log-v02.md Check 1, exit 0 in 13.05s.
- Audit/inventory-v02.md lines 17 to 18: totals 33 confirmed
present, 9 confirmed absent, 1 confirmed in a named satellite repo.
- The v01 checker verified all 33 present-item file and line
citations exactly by grep in the v4.23.0 tree, and confirmed every
absent name by zero-hit greps (check-log.md Check 2a). The v02
#check lines are unchanged from v01 (check-log-v02.md Check 1).

2. Three RFCs with conventions locked: PASS.
- docs/RFC_PseudoRiemannian.md line 6: decision to generalise to
one PseudoRiemannianMetric with signature (p, q), no parallel class.
- docs/RFC_Sobolev.md line 6: correction to the plan, and line 31:
design order, Bessel potential first, then W^{k,p} on domains,
then on manifolds, then weighted spaces.
- docs/RFC_Conventions.md line 12: signature (-, +, +, +) locked.
Lines 22 to 27: Riemann, Ricci, scalar, and Einstein signs locked.
Line 38: trigger states Phase 1 must follow Mathlib if PR 36128
defines the opposite Riemann sign when it lands.

3. Every uncertain item resolved, including PR 36128: PASS.
- PR 36128: Audit/inventory-v02.md line 78. Verdict NOT merged in
v4.23.0. GitHub API 26 Nov 2026: state open, merged false,
merged_at null, created 4 Mar 2026. None of its four names exists
anywhere in the v4.23.0 tree.
- Sobolev: the plan claim is wrong for v4.23.0. The file
Mathlib/Analysis/Distribution/Sobolev does not exist in the tree,
and no Sobolev space type exists there (inventory-v02.md,
Fourier/Sobolev section; RFC_Sobolev.md line 6).
- SmoothManifoldWithCorners is absent; the class is IsManifold.
AnalyticManifold is an 11-line deprecated shim.
- Hamilton satellite corrected in v02 (GAP-3): no release tagged
0.1.0 exists, commit 8bd406e35 is real, paper-time Lean 4.29.0,
current main Lean v4.35.0-rc3 (check-log-v02.md Check 4).
- Hilbert6 citations corrected against pinned commit
ddbe9da9b8118adb6fb3138af4a6d769c36e1f1a (GAP-1, GAP-2 fixed,
check-log-v02.md Checks 2 and 3).

4. A fresh checker re-opened every cited file and source: PASS,
with one recorded exception.
- The v01 checker re-ran Lean, re-grepped all 33 tree citations,
and re-opened PR 36128, both arXiv papers, the Spacetime docs,
the Hilbert6 raw files, and the Hamilton repo (check-log.md
Checks 1, 2a, 2b).
- One docs page failed to open in the browser and was not retried;
its claims were verified from the raw source files instead
(check-log.md Check 2b item 7).
- The v02 re-checker re-ran Lean, re-fetched the pinned Hilbert6
files, and re-checked the Hamilton releases, commit, and toolchain
through the GitHub API (check-log-v02.md Checks 1 to 4).
- Exception: the /tmp/probes/ probe logs were not re-opened in
either cycle. Those logs hold probe timings only. No item verdict
rests on them, and every verdict-bearing source was re-opened.
The exception is recorded as GAP-5a below, Queued, owner Phase 1
lead.

5. Neon and Astra hostile review recorded with model id, prompt,
result: PASS.
- check-log.md line 139: Gemini 4 Neon, model id
google/gemini-4-neon, max tokens 8000, first attempt, exit 0.
- check-log.md line 172: GPT-6.2 Astra, model id
openai/gpt-6.2-astra, max tokens 8000, first attempt, exit 0.
- The prompt is recorded verbatim and both reviews are recorded
verbatim in check-log.md Check 3. Neither review falsified a
specific inventory fact. Both converge on method limits, which
v02 records in Audit/inventory-v02.md line 183, Method limits.

## Gaps, with owner and next step

- GAP-4a, no downstream example: no minimal example shows an
alleged blocker failing on the baseline API. Status: Queued.
Owner: Phase 1 lead. Next step: elaborate one minimal downstream
example per alleged blocker in Phase 1 before treating "blocked"
as a schedule fact.
- GAP-4b, vendoring cost and newer Mathlib revision unmeasured:
no vendoring cost was measured and no compatible newer revision
was identified. Status: Queued. Owner: Phase 1 lead. Next step:
measure the vendoring cost or name the target Mathlib revision
in Phase 1 planning.
- GAP-4c, generalisation interop unproven: no Phase 0 example
shows the (n, 0) case working with Bundle.ContMDiffRiemannianMetric
without duplicate instances or lost lemmas. Status: Queued.
Owner: Phase 1 lead. Next step: build the interop example in
Phase 1. The assessment states this plainly at
map/Physicslib4-assessment-v02.md line 260.
- GAP-4d, baseline reason missing: no reason is given for staying
on v4.23.0 while the cited satellites run 4.29.0 and 4.35.0-rc3.
Status: Queued. Owner: Phase 1 lead. Next step: record the reason
or move the baseline in Phase 1 planning.
- GAP-5a, probe logs not re-checked: the /tmp/probes/ logs cited
in the audit header were not re-opened in either check cycle.
Status: Queued. Owner: Phase 1 lead. Next step: re-open the logs
before relying on probe timings; if the logs are gone, re-run
the probes.
- GAP-5b, PR 36128 Riemann sign untested: no source in the Phase 0
evidence states the PR sign convention, so the trigger in
RFC_Conventions.md cannot be tested yet. Status: Queued. Owner:
Phase 1 lead. Next step: read the PR source for its Riemann sign
when the PR is next reviewed; if it is opposite, revise
RFC_Conventions.md per its trigger.

## Why GAP-4 does not block DONE

The Phase 0 predicate is an audit plus locked conventions. It never
required a downstream example, a vendoring cost, or a baseline
justification. Those are Phase 1 questions. The v02 artifacts state
the limits in writing instead of claiming them resolved, so no claim
in the deliverables overreaches the evidence. The generalisation
decision is a direction with stated fallbacks, not a proven result,
and the artifacts say so. Recording a limit honestly is not the same
as failing the predicate.

## Cost

Generator: $0. Checker: 2 model calls, Gemini 4 Neon and GPT-6.2
Astra, 8000 max tokens each, first attempt, no retries. The tool
reports no dollar figure, so no exact total is claimed. Two calls
with no retries sit well under the $4 hard cap.

## Forbidden content check

No Phase 1 code was written in this verdict. No proof claim is made
here. No forbidden domain is named in this file.

## Next step

Phase 0 is done. Phase 1 may start on approval, with GAP-4a to
GAP-4d and GAP-5a to GAP-5b queued to the Phase 1 lead. No push,
post, deploy, or email was done in this run.
