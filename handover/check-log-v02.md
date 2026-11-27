# U4 independent re-check log, stage2-mathlib-geometry-phase0, fix cycle 1 (v02 only)

Date: 26 Nov 2026, 18:09 EST (23:09 UTC). Checker: fresh re-checker, did not write v01 or v02 files, not the previous checker.
Work folder: ~/workspace/handover-mathlib-geometry-2026-11-26/
Files checked ONLY (v02):
- Audit/inventory-v02.md
- Audit/MathlibInventory-v02.lean
- map/Physicslib4-assessment-v02.md
Previous check log: check-log.md, read GAP-1 to GAP-5 only to know what to re-test; its conclusions were not trusted, all items below were re-tested directly.
Scope note: the 33 Mathlib-tree line citations were NOT re-grepped in this cycle; v02 states they are unchanged from v01 and the previous checker verified all 33 exactly. No model calls were made; direct checks only, cost $0.
No push, post, deploy, email, or Phase 1 code was written. No Kerr or Yang-Mills proof claim is made here. No mention of the forbidden domain anywhere in the v02 files (grep: 0 hits) or in this log.

## Final verdict: PASS

All five gaps from check-log.md are fixed as specified for fix cycle 1, or recorded as open where the fix was to record them: GAP-1 line citations now verify exactly against the pinned commit; GAP-2 toPseudoRiemannianMetric is located at the corrected file and lines; GAP-3 Hamilton release/Lean claims now verify; GAP-4 Method limits section exists and records the limits rather than claiming to fix them; GAP-5 minors are recorded as open in both v02 files. The Lean audit re-runs clean (exit 0). The v01 files were not edited.

## Check 1: Re-run `lake env lean` on Audit/MathlibInventory-v02.lean: PASS

Command run:
- `export PATH="$HOME/.elan/bin:$PATH"; cd ~/workspace/kerr-stability-lean/kerr-mathlib && time lake env lean ~/workspace/handover-mathlib-geometry-2026-11-26/Audit/MathlibInventory-v02.lean`
- Exit code: 0, first attempt (PATH included ~/.elan/bin from the start; no exit 127 this time).
- Wall time: real 0m13.050s, user 0m3.027s, sys 0m2.386s.
- Output: 33 `#check` results printed, no errors, no warnings on stderr.
- Counts confirmed by grep: `grep -c '^#check'` = 33 live lines; `grep -c '^-- #check'` = 10 commented-out lines; raw `grep -c '#check'` = 47 (includes 4 mentions in the file header prose).
- The v02 header claim "33 of 43 #check lines compiled, 10 failed" matches the re-run exactly.
- Diff v01 vs v02 lean file: only comments changed (header version note, probe-log note, Hamilton satellite comment). All `#check` lines are unchanged from v01.

## Check 2: Four corrected Hilbert6 line citations, pinned commit ddbe9da9b8118adb6fb3138af4a6d769c36e1f1a: PASS

Method: `curl -sL` on raw.githubusercontent.com at the pinned commit, read via stdout pipe (see note on /tmp below). Pinned commit itself verified via GitHub API: `https://api.github.com/repos/hilbert6/hilbert6/commits/ddbe9da9b8118adb6fb3138af4a6d769c36e1f1a` returns sha ddbe9da9b8118adb6fb3138af4a6d769c36e1f1a, date 2026-11-25T10:57:28Z, message "Merge pull request #66 from hilbert6/notes-cleanup". This matches the date and commit stated in Physicslib4-assessment-v02.md.

File 1: https://raw.githubusercontent.com/hilbert6/hilbert6/ddbe9da9b8118adb6fb3138af4a6d769c36e1f1a/Hilbert6/Spacetime/Basic.lean (177 lines, matches the assessment):
- Spacetime structure, cited line 119: line 119 is `structure Spacetime where`. PASS.
- lorentzSignature, cited line 76: line 76 is `def lorentzSignature : Fin 4 → Fin 4 → ℝ :=`. PASS.
- LorentzianAt, cited line 88: line 88 is `def LorentzianAt {V : Type*} [AddCommGroup V] [Module ℝ V]`. PASS.
- toPseudoRiemannianMetric in this file: grep finds it only in doc comments at lines 48 and 115, no definition. This matches the v02 correction note. PASS (as a negative check).

File 2: https://raw.githubusercontent.com/hilbert6/hilbert6/ddbe9da9b8118adb6fb3138af4a6d769c36e1f1a/Hilbert6/Geometry/PseudoRiemannian/Basic.lean (167 lines, matches the assessment):
- PseudoRiemannianMetric structure, cited line 59: line 59 is `structure PseudoRiemannianMetric where`. PASS.

All four GAP-1 citations verify exactly. GAP-1 is fixed.

## Check 3: Spacetime.toPseudoRiemannianMetric at lines 160-165 in PseudoRiemannian/Basic.lean, same pinned commit: PASS

Same pinned raw fetch as Check 2:
- Line 160: `def Spacetime.toPseudoRiemannianMetric (M : Spacetime) :`
- Line 161: `    Geometry.PseudoRiemannianMetric M.model M.Carrier where`
- Lines 162-165: `  val := M.val`, `  symm := M.symm`, `  nondegenerate := M.nondegenerate`, `  contMDiff := M.contMDiff`
- This matches the v02 citation "def at line 160, lines 160 to 165" exactly. GAP-2 is fixed.
- Supporting spot checks in the same file: `bijective_val` at line 81, `flatEquiv` at line 97, `contMDiff_flatEquiv_symm` at line 112, consistent with the assessment (it does not cite those line numbers, so they are recorded as supporting evidence only).

## Check 4: Hamilton releases, commit, and current main Lean version: PASS

All via GitHub API / raw fetch, 26 Nov 2026 evening EST:
- Releases list `https://api.github.com/repos/qinz1yang/differential-geometry/releases?per_page=20` returns tag_name v0.1.5, v0.1.4, v0.1.3, v0.1.2, v0.1.1, and arxiv-v1-preview (named "0.1.0 (arXiv v1 preview)"). No release tagged 0.1.0 exists.
- Tag lookups confirm the absence: `https://api.github.com/repos/qinz1yang/differential-geometry/releases/tags/0.1.0` returns HTTP 404; same for `releases/tags/v0.1.0`, HTTP 404.
- Commit 8bd406e35 is real: `https://api.github.com/repos/qinz1yang/differential-geometry/commits/8bd406e35` returns sha 8bd406e35c33a200e9b88895cf11ee8429194e15, message "Set package version to 0.1.0".
- Current main Lean version: `https://raw.githubusercontent.com/qinz1yang/differential-geometry/main/lean-toolchain` returns `leanprover/lean4:v4.35.0-rc3`.
- Repo check: `https://api.github.com/repos/qinz1yang/differential-geometry` returns full_name qinz1yang/differential-geometry, default_branch main.
- These match the corrected claims in both inventory-v02.md (Hamilton satellite entry) and Physicslib4-assessment-v02.md (GAP-3 correction) and in MathlibInventory-v02.lean (comment only). GAP-3 is fixed.

## Check 5: v01 files were not edited: PASS (with one stated limit)

Evidence, `stat` at 23:09 UTC 26 Nov 2026:
- Audit/MathlibInventory.lean: 2026-11-26 22:56:37 UTC, 5393 bytes, md5 eefa8f82436e1f89b7df40a3f7160550
- Audit/inventory.md: 2026-11-26 22:56:37 UTC, 8693 bytes, md5 dd2fd88d16dd5e0be88e2736c44aae7f
- map/Physicslib4-assessment.md: 2026-11-26 22:36:38 UTC, 10947 bytes, md5 952c8ab7f76117d401356bb30f412779
- All three v01 timestamps predate check-log.md (23:03:44 UTC) and all v02 files (23:05:36, 23:05:48, 23:06:00 UTC). No v01 file was written after the v01 check.
- Limit, stated plainly: no pre-v02 hash of the v01 files was on record in this task, so byte-identical content against an earlier hash could not be proven; the check rests on timestamps, sizes, and the absence of any write after v01 was checked. Within that limit, nothing indicates an edit.
- The v02 lean diff (Check 1) confirms the v02 file is a new file with comment-only changes, not an in-place edit of v01.

## Check 6: Method limits section exists and GAP-5 minors are recorded as open: PASS

- Audit/inventory-v02.md, line 183: `## Method limits`, followed by five bullets recording that #check presence is a weak test, absence is name-not-found not proof of no equivalent, "blocked" means the named API is absent (vendoring / newer Mathlib unmeasured), the PseudoRiemannianMetric generalisation is unproven without a downstream interoperability example, and no reason is given for staying on v4.23.0 while satellites run 4.29.0 / 4.35.0-rc3. GAP-4 is recorded, not claimed fixed, which is what fix cycle 1 specified.
- Audit/inventory-v02.md, line 233: `## Open items, minor (GAP-5)`, recording both minors as open: (a) /tmp/probes/ probe logs not re-checked in fix cycle 1, owner Phase 1 lead; (b) PR 36128 Riemann sign untested, owner Phase 1 lead.
- map/Physicslib4-assessment-v02.md, line 266: `## Open items, minor (GAP-5)`, recording the same two minors as open.
- map/Physicslib4-assessment-v02.md, line 264 and the generalisation section, point back to inventory-v02.md "Method limits" for the unproven generalisation. Consistent across both v02 files.

## Additional notes

- /tmp write gate still active at check time: `curl -o /tmp/h6-spacetime.lean` returned HTTP 200 with SIZE 2756 but wrote 0 bytes ("Failure writing output to destination"). This is the same sandbox write-gate behaviour recorded in check-log.md for /tmp. All remote fetches in this re-check were therefore read via stdout pipe, with no file writes. This also corroborates, rather than resolves, the GAP-5 /tmp/probes item: the probe logs were not re-opened in this cycle either.
- Forbidden-content spot check on the v02 files: grep for the forbidden domain string returns 0 hits; grep for Kerr / Yang-Mills returns 0 hits in both v02 markdown files. No proof claim for a new result appears in the v02 files.
- GAP-4 remains an open judge question in substance (the limits are recorded, the underlying method gaps are not resolved in Phase 0). That is the intended v02 outcome, not a fail for this fix cycle.

## Per-item summary

- Check 1, Lean re-run on MathlibInventory-v02.lean: PASS. Exit 0, 13.05s, 33 live #check lines, 10 commented out.
- Check 2, Hilbert6 four line citations at pinned commit ddbe9da9b8118adb6fb3138af4a6d769c36e1f1a: PASS. Lines 119, 76, 88, 59 all exact.
- Check 3, Spacetime.toPseudoRiemannianMetric lines 160-165: PASS. Definition and four fields match exactly.
- Check 4, Hamilton releases / commit / Lean version: PASS. No 0.1.0 release (404), releases v0.1.1-v0.1.5 plus arxiv-v1-preview, commit 8bd406e35 real, main Lean v4.35.0-rc3.
- Check 5, v01 files not edited: PASS (timestamp evidence; no pre-v02 hash on record, limit stated).
- Check 6, Method limits section and GAP-5 open items: PASS. Section at inventory-v02.md line 183; GAP-5 open items at inventory-v02.md line 233 and assessment-v02.md line 266.

## Verdict restated

U4 re-check, fix cycle 1: PASS. GAP-1, GAP-2, and GAP-3 are fixed and re-verified against the pinned sources; GAP-4 is recorded in the new Method limits section; GAP-5 minors are recorded as open in both v02 files; the Lean audit re-runs clean; the v01 files were not edited.
