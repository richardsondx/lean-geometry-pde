# Fix log: stage2-mathlib-geometry-phase3-sobolev-slice-01, fix cycle 1 of 5

- Date: 28 Nov 2026.
- Run: stage2-mathlib-geometry-phase3-sobolev-slice-01.
- Predicate: pred-mathlib-geometry-phase3-sobolev-slice-v01.
- Baseline: Mathlib v4.36.0.
- Checker result before fix: 6 pass, 1 fail. Check log: check-log-phase3-sobolev-slice.md.
- Scope: two files only, plus this log. No push, no post, no send, no deploy, no delete. No predicate change. No shared Mathlib cache rebuild.

## Gap 1: SobolevSlice.lean not part of the build, Fixed

- Change: added one line to the work-copy root only, `import PseudoRiemannian.SobolevSlice`, as the last line of track-sobolev/lean-phase1/PseudoRiemannian.lean. No other line in that file changed.
- Shared root untouched: ~/workspace/handover-mathlib-geometry-2026-11-26/lean-phase1/PseudoRiemannian.lean still has 6 lines and no SobolevSlice reference. Diff of shared root against work-copy root before the edit was empty; after the edit it shows exactly the one added import line.
- Verification: `lake build` exit 0, 6528 jobs, "Build completed successfully". SobolevSlice.olean now exists at track-sobolev/lean-phase1/.lake/build/lib/lean/PseudoRiemannian/SobolevSlice.olean, 749,136 bytes, dated 28 Nov 2026 05:34 UTC.
- Owner: generator. Next step for the fresh checker: re-run Check 1 and confirm the olean is produced by the build.

## Gap 2: two theorems lacked in-file #print axioms lines, Fixed

- Change: added two lines to track-sobolev/lean-phase1/PseudoRiemannian/SobolevSlice.lean, in the print block after HasWeakDeriv.unique: `#print axioms memLp_locallyIntegrableOn` and `#print axioms HasWeakDeriv.congr_ae`.
- Verification: `lake env lean PseudoRiemannian/SobolevSlice.lean` exit 0. All 15 in-file print lines now print exactly `[propext, Classical.choice, Quot.sound]`, including the two new ones:
  - `'memLp_locallyIntegrableOn' depends on axioms: [propext, Classical.choice, Quot.sound]`
  - `'HasWeakDeriv.congr_ae' depends on axioms: [propext, Classical.choice, Quot.sound]`
- The file line 45 claim that every new theorem carries a #print axioms line is now true: 15 theorems, 15 in-file print lines.
- No theorem statement, proof, or definition changed. No existing proved theorem was weakened.
- `grep -rn "sorry\|admit"` on SobolevSlice.lean: no matches. No mention of itsdavis.com in either edited file.
- Owner: generator. Next step for the fresh checker: re-run Check 2 on the fixed file.

## Deviation, recorded

- This fix edited SobolevSlice.lean in place instead of writing a new versioned file, because the predicate names SobolevSlice.lean by name, so a renamed v02 file would not satisfy Check 1 as written. The fresh checker re-runs all checks on the fixed file.

## Commands run, with exit codes

All run from ~/workspace/handover-mathlib-geometry-2026-11-26/track-sobolev/lean-phase1/, with `$HOME/.elan/bin` on PATH, under flock on /tmp/lean-phase1-build.lock:

- `diff -u <shared root> <work-copy root>` before edit: exit 0, no difference.
- `flock /tmp/lean-phase1-build.lock lake build`: exit 0, 6528 jobs, "Build completed successfully".
- `flock /tmp/lean-phase1-build.lock lake env lean PseudoRiemannian/SobolevSlice.lean`: exit 0, 15 print lines, all `[propext, Classical.choice, Quot.sound]`.
- `grep -rn "sorry\|admit" PseudoRiemannian/SobolevSlice.lean`: no matches (exit 1).
- `grep -rn "itsdavis" <both edited files>`: no matches (exit 1).
- Shared root check after fix: 6 lines, 0 SobolevSlice matches, unchanged.

Note: the build output carries pre-existing warnings from other modules (module system hints and a doc-string linter warning in Metric.lean). Those are warnings only, not errors, and no file outside the two listed was touched to address them.

## Timing table

- Pre-edit diff and baseline checks: about 1 minute, 00:33 EST.
- `lake build`: 59 s, started 05:34:00 UTC, exit 0.
- `lake env lean PseudoRiemannian/SobolevSlice.lean`: 51 s, started 05:34:59 UTC, exit 0.
- Post-fix grep and shared-root checks: under 1 minute.
- Total fix cycle wall time: about 4 minutes.

## Status

- Gap 1: Fixed.
- Gap 2: Fixed.
- No gap remains open from this checker result. The bridge proof, embeddings, trace, Poincare, weighted spaces, and bounded-domain W12 remain open by design and are not gaps in this slice.

## Kit

- Case B, Lean verification kit, draft, ~/workspace/handover-mathlib-geometry-2026-11-26/
