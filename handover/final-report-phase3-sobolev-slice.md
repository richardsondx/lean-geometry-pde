# Final report: Phase 3 Sobolev first slice

- Run: stage2-mathlib-geometry-phase3-sobolev-slice-01.
- Predicate: pred-mathlib-geometry-phase3-sobolev-slice-v01.
- Date: 28 Nov 2026.
- Baseline: Mathlib v4.36.0, commit fc4f59e577feb1a4956671bc04ac18aaaf8cd842.
- Work copy: ~/workspace/handover-mathlib-geometry-2026-11-26/track-sobolev/lean-phase1/.

## Words used in this file

- Slice means SobolevSlice.lean, 444 lines.
- Bridge means sobolevBridge, a Prop at Slice line 262.
- Witness means the L2 function h in the Bridge.
- Bessel witness means the L2 function inside MemSobolev.
- PASS means a check holds on the artifact.
- FAIL means a check does not hold on the artifact.
- GAP means the predicate is not met.
- DONE means the predicate is met.
- Fixed means a gap is done, tested, and re-checked in this run.
- Queued means work remains, with an owner and a next step.

## Result

- Verdict: DONE, fix cycle 2, verdict v02, 28 Nov 2026.
- Checks 1 through 8 pass.
- First missing step: none.
- DONE closes only this narrow predicate.
- The v01 verdict was GAP, with Checks 4, 7, and 8 failing.
- Fix cycle 2 repaired all three failing checks.
- This slice closes weak derivatives on R^n, with uniqueness proved.
- This slice closes W^{1,2} on R^n, with its norm proved.
- This slice closes the Hilbert structure of W^{1,2} on R^n.
- This slice does not close the H^1 = W^{1,2} bridge.
- This slice does not close embeddings, trace, or Poincare.
- This slice does not close weighted spaces or bounded domains.
- This slice does not close Phase 3.
- Phase 3 full is 12 to 36 person-months, per the stage 1 package.

## Evidence

- Build: `flock /tmp/lean-phase1-build.lock lake build` exits 0, 6528 jobs, "Build completed successfully".
- Olean: SobolevSlice.olean exists, 749,136 bytes, dated 28 Nov 2026 05:34:55 UTC, 59 seconds newer than the source.
- Axioms: direct `lake env lean` exits 0, 15 print lines, each exactly [propext, Classical.choice, Quot.sound].
- Sorry: grep for sorry and admit returns no matches.
- Root: shared root has 6 lines, no SobolevSlice reference, unchanged.
- Root: work-copy root differs by exactly one added line, `import PseudoRiemannian.SobolevSlice`.
- Check 3: the acceptance doc fixes every GAP-10 item in writing.
- Check 5: HasWeakDeriv is a def at Slice line 71, uniqueness proved at line 83.
- Check 6: sobolevSpace is a def at Slice line 166, norm formula at line 203, four norm axioms at lines 218, 222, 226, 231.
- Check 4 fail: the audit omits 8 identifiers the Slice uses directly.
- The 8 names are Distribution.ofFun_apply, ofFun_congr_ae, ofFun_add, ofFun_smul, ofFun_zero, and MeasureTheory.Lp.coeFn_add, coeFn_zero, coeFn_smul.
- The judge grepped the Slice and the audit for each name.
- Each name occurs in the Slice and returns no match in the audit.
- Check 7 fail: the judge read the Bridge at Slice lines 262 to 271.
- The Bridge quantifies only over x in sobolevSpace n.
- The MemSobolev conjunct never mentions h.
- The norm conjunct is the only limit on h.
- Any scaled unit L2 vector meets the norm conjunct.
- The norm formula is present as text.
- Its subject h is not the Bessel witness.
- A proof of this Prop would not prove the norm identity.
- The Bridge states no reverse direction, no iff, and no uniqueness of the derivative tuple.
- Reviews: Astra review and Neon review are recorded verbatim, with prompts saved.
- Astra file: astra-review-phase3-sobolev-slice.md, model openai/gpt-6.2-astra, max-tokens 12000.
- Neon file: neon-review-phase3-sobolev-slice.md, model google/gemini-4-neon, max-tokens 16000.
- Astra strongest flaw: the Bridge does not state the advertised bridge.
- Neon strongest flaw: monolithic, non-parameterized core definitions.
- Verdict: verdict-phase3-sobolev-slice-v01.md, fresh judge, unit U7.
- Fix cycle 2: fix log fix-log-phase3-sobolev-slice-cycle4.md, check log check-log-phase3-sobolev-slice-cycle4.md, verdict verdict-phase3-sobolev-slice-v02.md.
- Cycle 2 build: lake build exits 0, 6528 jobs, Slice at job 6525 of 6528.
- Cycle 2 bridge: h tied to the Bessel witness at Slice lines 271-272, norm comparison on that h at lines 276-278, forward only.
- Cycle 2 audit: all 8 identifiers present with file, line, and source, plus 7 more field API items, audit now 46 entries.
- Cycle 2 Test 3: square-root form, scaling re-check recorded.
- Check log v01: 6 pass, 1 fail, Check 1, build wiring.
- Check log v02: 6 pass, 1 fail, Check 4, false BesselPotentialSpace claim.
- Check log v03: 6 pass, 1 fail, Check 4, six wrong "Items used" entries.
- Check log v04: 7 pass, 0 fail, no gaps.
- The judge found two fails the v04 checker missed, Checks 4 and 7.
- Fix log cycle 1: work-copy root import added, two print lines added.
- Fix log cycle 2: BesselPotentialSpace sentence corrected, embedding sentence corrected.
- Fix log cycle 3: six audit entries corrected, besselPotential labeled transitive.

## Units

- U1, acceptance parameters: PASS, docs/SobolevAcceptance-v01.md.
- U2, audit: FAIL, used items are missing, see Check 4.
- U3, weak derivatives: PASS, def and uniqueness proof in the Slice.
- U4, W^{1,2} norm: PASS, def and norm proof in the Slice.
- U5, bridge statement: FAIL, see Check 7.
- U6, hostile reviews: PASS, both reviews recorded verbatim.
- U7, final report and judge: DONE, verdict v02 file is the ruling.

## Kit

- Kit: Case B, Lean verification kit, draft.
- Kit path: ~/workspace/handover-mathlib-geometry-2026-11-26/.
- Kit design: compile exit 0 with no sorry, property tests, audit with file, line, and source, hostile review recorded verbatim.
- Kit proof status: draft, not proven across many tasks.
- Verification fallback: no proven field CLI exists for this work.
- Verification used the predicate plus the exact manual commands in the manifest.
- No separate kit budget line exists.
- The run cap covers the kit.

## Gaps

- G1, Bridge Witness is disconnected from the Bessel witness: Closed in fix cycle 2. The Bridge now states h equals the order 1 Bessel potential of the complexified distribution, with the norm formula on that h.
- G2, audit omits directly used identifiers: Closed in fix cycle 2. All 8 identifiers are present with file, line, and source, plus 7 more field API items.
- G3, monolithic non-parameterized core definitions: Queued.
  - Owner: generator.
  - Next step: design a parameterized W^{k,p} carrier with order, exponent, domain, and weight as parameters, before weighted H^2 work starts.
  - Next step: or record a written decision to rewrite sobolevSpace from scratch for that work.
- G4, weighted acceptance Test 3 is false as written: Closed in fix cycle 2. Test 3 now uses the square root of the weighted sum, with the scaling re-check recorded.
- G5, bridge has no reverse direction and no uniqueness: Closed in fix cycle 2. The bridge is forward only, and the acceptance doc matches.
- G6, bridge proof, embeddings, trace, Poincare, weighted spaces, bounded domains: Queued.
  - Owner: future run.
  - Next step: none in this run, these are out of scope by design.
- G7, BesselPotentialSpace API and Fourier lemmas are not audited: Queued.
  - Owner: generator.
  - Next step: inspect the BesselPotentialSpace bundled API as an alternative bridge target.
  - Next step: then list the Plancherel and multiplier lemmas needed for bridge steps 1 to 6.
- G8, Check 8 fails because this verdict is GAP: Closed in fix cycle 2. The fresh judge rules DONE in verdict v02.
- G9, stale besselPotential grep note in the audit: Queued.
  - Owner: generator.
  - Next step: correct the parenthetical to state the name now appears at Slice lines 248 and 271.
  - Next step: then re-check the audit text for other stale line numbers.

## Cost and envelope

- Hard cap: $4.
- Run budget: $3.40.
- Held back sum: $0.60.
- Fix attempts used: 4 of 5.
- Fix attempts remaining: 1.
- No dollar figure was reported by any tool in this run.
- Timebox: 10 hours wall.
- Run start: 28 Nov 2026, 04:05 UTC.
- Judge verdict v01: 28 Nov 2026, 06:00 UTC.
- Judge verdict v02: 28 Nov 2026, 06:37 UTC.
- Spawns used: 14, 11 in the first run and 3 in fix cycle 2.
- Model calls used: 3 (generator Astra design call, Astra review, Neon review).
- No push, no post, no send, no deploy, no delete happened in this run.
- The shared root file was never edited.
- No other track's files were edited.

## Next step

- The integration gate may now add the root import.
- Push still needs a separate approval.
- Correct the stale besselPotential note before the next audit use.
- Then close this run, and queue the bridge proof for a future run.
