# Verdict: Phase 3 Sobolev first slice, fix cycle 2

- Run: stage2-mathlib-geometry-phase3-sobolev-slice-01.
- Predicate: pred-mathlib-geometry-phase3-sobolev-slice-v01.
- Judge: fresh judge, unit U7, fix cycle 2.
- Date: 28 Nov 2026.
- Baseline: Mathlib v4.36.0, commit fc4f59e577feb1a4956671bc04ac18aaaf8cd842.
- Fix attempts used: 4 of 5, with 1 remaining.

## Words used in this file

- Slice means SobolevSlice.lean, 452 lines.
- Bridge means sobolevBridge, a Prop at line 268.
- Witness means the L2 function h in the Bridge.
- Bessel witness means the L2 function inside MemSobolev.
- MemSobolev means TemperedDistribution.MemSobolev 1 2.
- Field API means Distribution, Lp, PiLp, LineDeriv, and LocallyIntegrable identifiers.
- Plumbing means generic Filter, Fin, Set, Real, and Measure lemmas.
- PASS means the check holds on the artifact I read.
- FAIL means the check does not hold on the artifact I read.
- GAP means the predicate is not met.
- DONE means the predicate is met.
- Queued means work remains, with an owner and a next step.
- Closed means the gap is repaired on the artifact I read.

## Result

- Verdict: DONE.
- Checks 1 through 8 pass.
- First missing step: none.
- DONE closes only this narrow predicate.
- This slice does close weak derivatives on R^n.
- This slice does close W^{1,2} on R^n with its norm proved.
- This slice does close the Hilbert structure of W^{1,2} on R^n.
- This slice does not close the H^1 = W^{1,2} bridge proof.
- This slice does not close embeddings, trace, or Poincare.
- This slice does not close weighted spaces or bounded domains.
- This slice does not close Phase 3.
- Phase 3 full is 12 to 36 person-months, per the stage 1 package.

## Evidence

### Check 1: lake build exits 0, with the Slice included: PASS

- I ran the build in the work copy.
- Command: `cd track-sobolev/lean-phase1 && export PATH="$HOME/.elan/bin:$PATH" && flock /tmp/lean-phase1-build.lock lake build`.
- Result: exit 0.
- Result: `Build completed successfully (6528 jobs).`
- Result: the Slice ran at job 6525 of 6528.
- Result: my run printed 15 axiom lines for the Slice.
- Each axiom line reads `[propext, Classical.choice, Quot.sound]`.
- Linter warnings appear, and the build still exits 0.

### Check 2: no sorry, no admit, no extra axiom: PASS

- Command: `grep -rn "sorry\|admit" track-sobolev/lean-phase1/PseudoRiemannian/SobolevSlice.lean`.
- Result: no matches, exit 1.
- Print lines 438 to 452 hold 15 print commands.
- Line 45 is doc text.
- Each of the 15 theorems has one print line.
- Each print line shows only propext, Classical.choice, and Quot.sound.

### Check 3: GAP-10 parameters fixed and recorded: PASS

- I read docs/SobolevAcceptance-v01.md in full.
- Dimension R3 is fixed for the embedding test and the weighted test.
- Dimension 1 plus 3 Minkowski is fixed for the wave test.
- Target exponent q equal to 6 is fixed for the H1 embedding.
- Target exponent q equal to 2 is fixed for the wave energy variables.
- Target exponent q equal to infinity after weighting is fixed for decay.
- Weight delta equal to 0 is fixed for the first two tests.
- Weight delta equal to minus 1 is fixed for the weighted test.
- Order s equal to 1 is fixed for the embedding test.
- Order s equal to 2 is fixed for the weighted test.
- Local regularity, Poincare, and trace hypotheses are fixed in writing.
- The doc states the bridge is not proved.
- The doc states bounded-domain W^{1,2} is out of scope.
- Test 3 now uses the square-root form from gap G4.
- Check 3 as written asks only that parameters are fixed and recorded.
- They are fixed and recorded, so Check 3 passes as written.

### Check 4: v4.36.0 audit complete, with file, line, and source: PASS

- I read map/Sobolev-v436-audit.md in full.
- Command: grepped each of the 8 names in the audit and in the Slice.
- Each of the 8 is present with file, line, and source.
- The 8 names are:
  - Distribution.ofFun_apply, theorem: Distribution.lean, line 306. Audit line 44.
  - Distribution.ofFun_zero, theorem: Distribution.lean, line 322. Audit line 45.
  - Distribution.ofFun_congr_ae, theorem: Distribution.lean, line 326. Audit line 46.
  - Distribution.ofFun_add, theorem: Distribution.lean, line 340. Audit line 47.
  - Distribution.ofFun_smul, theorem: Distribution.lean, line 357. Audit line 48.
  - MeasureTheory.Lp.coeFn_zero, theorem: LpSpace/Basic.lean, line 194. Audit line 49.
  - MeasureTheory.Lp.coeFn_add, theorem: LpSpace/Basic.lean, line 202. Audit line 50.
  - MeasureTheory.Lp.coeFn_smul, theorem: LpSpace/Basic.lean, line 480. Audit line 51.
- I spot-checked all 8 audit line numbers against the cached Mathlib source.
- Each cited line names the claimed identifier.
- Command: grepped each of the 7 names in the audit and in the Slice.
- Each audit grep returned 0.
- Each Slice grep returned at least 1.
- The 7 names are:
  - Filter.Eventually.of_forall
  - Real.norm_eq_abs
  - Fin.sum_univ_succ
  - Set.mem_iInter
  - SetLike.mem_coe
  - LinearMap.mem_ker
  - Measure.restrict_univ
- The completeness sweep found 36 of 43 dotted identifiers present.
- The besselPotential entry carries file, line, and source.
- Its parenthetical grep note is stale, see the scope decision.
- Command: `grep -n besselPotential` on the Slice and on the audit.
- Result: Slice lines 248 and 271, audit line 13.

### Check 4 scope decision

- Decision: the applied standard applies, and Check 4 passes.
- Basis 1: section 2 defines the audit as file, line, and source for every v4.36.0 Sobolev item used.
- Basis 2: the 7 identifiers are generic plumbing, and none is a Sobolev item.
- Basis 3: the previous verdict failed Check 4 on the 8 field API identifiers only.
- Basis 4: the fix repaired all 8 and added 7 more field API items.
- Basis 5: a literal every-token reading would also demand single-segment generic lemmas.
- Basis 6: no version of this audit ever listed that class, and the previous verdict never demanded it.
- This decision follows section 2, and it changes no check.
- The stale besselPotential note is a minor inaccuracy, and it fails no check.
- The entry itself carries the correct file, line, and source.

### Check 5: weak derivatives defined on R^n, uniqueness proved: PASS

- HasWeakDeriv is a def at Slice line 71.
- It uses Distribution.ofFun and the distributional line derivative.
- Local integrability stands as a conjunct.
- HasWeakDeriv.unique is a theorem at Slice line 83.
- Its conclusion is `v =ᵐ[volume] w`.
- Its axiom line shows only the three allowed axioms.
- The domain is R^n.

### Check 6: W^{1,2} defined, its norm proved to be a norm: PASS

- sobolevSpace is a def at Slice line 166.
- It is a submodule of the (n+1)-fold L2 PiLp product.
- Component 0 is the function.
- Components 1 to n are weak derivatives in basis directions.
- sobolev_norm_eq is a theorem at Slice line 203.
- It gives the explicit norm formula.
- Four norm axioms are proved at lines 218, 222, 226, and 231.
- Each axiom line shows only the three allowed axioms.
- Closedness is proved at line 366.
- Completeness is proved at line 433.
- The Hilbert structure is proved, beyond what Check 6 asks.

### Check 7: H^1 = W^{1,2} bridge stated, exact norm comparison, steps listed: PASS

- I read the Bridge at Slice lines 244 to 278 myself.
- The Bridge quantifies over x in sobolevSpace n only.
- It asks for an h in Lp ℂ 2.
- Lines 271 to 272 tie h to the Bessel witness.
- The first conjunct says the order 1 Bessel potential of the complexified distribution equals h.
- The MemSobolev conjunct states the distribution is in H^1.
- The norm conjunct at lines 276 to 278 is stated on that same h.
- The formula gives ‖h‖ as the square root of the u term plus the scaled derivative sum.
- The H1 norm is therefore the norm of the Bessel witness h.
- The doc comment states the forward direction only.
- It lists no reverse direction, no iff, and no uniqueness of the derivative tuple.
- The acceptance doc matches with its own forward-only bridge section.
- The doc comment lists 6 remaining steps in order.
- The three v01 Check 7 failures are each repaired.
- Check 7 passes because the bridge is now actually stated.

### Check 8: a fresh judge rules DONE: PASS

- Check 8 asks a fresh judge to rule DONE.
- I am the fresh judge.
- I rule DONE.
- Check 8 therefore passes.

### Root diff, read by me

- I diffed the shared root and the work-copy root.
- The shared root has 6 lines.
- The work-copy root has 7 lines.
- The diff shows one added line only.
- The line is `import PseudoRiemannian.SobolevSlice`.
- The shared root has no SobolevSlice reference.
- The shared root is unchanged.

## Units

- U1, acceptance parameters: PASS.
- U2, audit: PASS, on the applied standard, see Check 4.
- U3, weak derivatives: PASS.
- U4, W^{1,2} norm: PASS.
- U5, bridge statement: PASS, see Check 7.
- U6, hostile reviews: PASS, carried from the previous verdict, and both review files exist.
- U7, judge: DONE, this file is the ruling.

## Kit

- Kit: Case B, Lean verification kit, draft.
- Kit path: ~/workspace/handover-mathlib-geometry-2026-11-26/.
- The kit design is compile exit 0 with no sorry.
- The kit design is property tests and audit with file, line, and source.
- The kit design is hostile review recorded verbatim.
- The kit is draft, and it is not proven across many tasks.
- No separate kit budget line exists.
- The run cap covers the kit.

## Gaps

- G1, Bridge Witness: Closed, h now equals the Bessel potential.
- G2, audit omissions: Closed, all 8 identifiers are now present.
- G4, weighted Test 3: Closed, Test 3 now uses the square-root form.
- G5, bridge reverse direction: Closed, forward-only statement matches the acceptance doc.
- G8, Check 8: Closed, this verdict rules DONE.
- G3, monolithic non-parameterized core definitions: Queued.
  - Owner: generator.
  - Next step: design a parameterized W^{k,p} carrier before weighted H^2 work starts.
  - Next step: carry order, exponent, domain, and weight as parameters.
  - Next step: record a written decision to rewrite sobolevSpace from scratch for that work.
- G6, bridge proof, embeddings, trace, Poincare, weighted spaces, bounded domains: Queued.
  - Owner: future run.
  - Next step: none in this run, these are out of scope by design.
- G7, BesselPotentialSpace API and Fourier lemmas are not audited: Queued.
  - Owner: generator.
  - Next step: inspect the BesselPotentialSpace bundled API as an alternative bridge target.
  - Next step: then list the Plancherel and multiplier lemmas needed for bridge steps 1 to 6.
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
- No dollar figure for this judge run is in the evidence I read.
- Timebox for this judge: 2 hours.
- I did not edit any artifact file.
- I did not push, post, send, deploy, or delete anything.

## Next step

- The integration gate may now add the root import.
- Push still needs a separate approval.
- Correct the stale besselPotential note before the next audit use.
- Then close this run, and queue the bridge proof for a future run.
