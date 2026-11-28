# Verdict: Phase 3 Sobolev first slice

- Run: stage2-mathlib-geometry-phase3-sobolev-slice-01.
- Predicate: pred-mathlib-geometry-phase3-sobolev-slice-v01.
- Judge: fresh judge, unit U7.
- Date: 28 Nov 2026.
- Baseline: Mathlib v4.36.0, commit fc4f59e577feb1a4956671bc04ac18aaaf8cd842.

## Words used in this file

- Slice means SobolevSlice.lean, 444 lines.
- Bridge means sobolevBridge, a Prop at line 262.
- Witness means the L2 function h in the Bridge.
- Bessel witness means the L2 function inside MemSobolev.
- MemSobolev means TemperedDistribution.MemSobolev 1 2.
- PASS means the check holds on the artifact I read.
- FAIL means the check does not hold on the artifact I read.
- GAP means the predicate is not met.
- DONE means the predicate is met.
- Queued means work remains, with an owner and a next step.

## Result

- Verdict: GAP.
- Checks 1, 2, 3, 5, and 6 pass.
- Checks 4, 7, and 8 fail.
- First missing step: tie the Witness to the Bessel witness.
- This slice does close weak derivatives on R^n.
- This slice does close W^{1,2} on R^n with its norm proved.
- This slice does close the Hilbert structure of W^{1,2} on R^n.
- This slice does not close the H^1 = W^{1,2} bridge.
- This slice does not close embeddings, trace, or Poincare.
- This slice does not close weighted spaces or bounded domains.
- This slice does not close Phase 3.
- Phase 3 full is 12 to 36 person-months, per the stage 1 package.

## Evidence

### Check 1: lake build exits 0, with the Slice included: PASS

- I ran the build in the work copy.
- Command: `flock /tmp/lean-phase1-build.lock lake build`.
- Working directory: track-sobolev/lean-phase1.
- Result: exit 0.
- Result: `Build completed successfully (6528 jobs).`
- Result: SobolevSlice replayed at job 6518 of 6528.
- Result: the root built at job 6526 of 6528.
- Result: my run printed 15 axiom lines for the Slice.
- Each axiom line reads `[propext, Classical.choice, Quot.sound]`.

### Check 2: no sorry, no admit, no extra axiom: PASS

- Command: `grep -rn "sorry\|admit" PseudoRiemannian/SobolevSlice.lean`.
- Result: no matches, exit 1.
- Print lines 430 to 444 hold 15 print commands.
- Line 45 is doc text, not a print command.
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
- One recorded test is false as written, see gap G4.
- Check 3 as written asks only that parameters are fixed and recorded.
- They are fixed and recorded, so Check 3 passes as written.

### Check 4: v4.36.0 audit complete, with file, line, and source: FAIL

- I read map/Sobolev-v436-audit.md in full.
- The listed 31 entries carry file, line, and source.
- The audit omits identifiers the Slice uses directly.
- I grepped the Slice for six such names.
- Each name occurs in the Slice.
- I grepped the audit for the same six names.
- Each grep returned no match.
- The six names are:
  - Distribution.ofFun_apply
  - Distribution.ofFun_congr_ae
  - Distribution.ofFun_add
  - Distribution.ofFun_smul
  - Distribution.ofFun_zero
  - MeasureTheory.Lp.coeFn_add
- Lp.coeFn_zero and Lp.coeFn_smul are also used and also absent.
- Stage 1 asks for file, line, and source for every item used.
- Used items are missing, so the audit is not complete.
- The v04 checker verified the listed entries, not completeness.
- My grep governs here, and it shows the omission.

### Check 5: weak derivatives defined on R^n, uniqueness proved: PASS

- HasWeakDeriv is a def at Slice line 71.
- It uses Distribution.ofFun and the distributional line derivative.
- Local integrability is a conjunct, not a fallback.
- HasWeakDeriv.unique is a theorem at Slice line 83.
- Its conclusion is `v =ᵐ[volume] w`.
- Its axiom line shows only the three allowed axioms.
- The domain is R^n, not another space.

### Check 6: W^{1,2} defined, its norm proved to be a norm: PASS

- sobolevSpace is a def at Slice line 166.
- It is a submodule of the (n+1)-fold L2 PiLp product.
- Component 0 is the function.
- Components 1 to n are weak derivatives in basis directions.
- sobolev_norm_eq is a theorem at Slice line 203.
- It gives the explicit norm formula.
- Four norm axioms are proved at lines 218, 222, 226, and 231.
- Each axiom line shows only the three allowed axioms.
- Closedness is proved at line 358.
- Completeness is proved at line 425.
- The Hilbert structure is proved, beyond what Check 6 asks.

### Check 7: H^1 = W^{1,2} bridge stated, exact norm comparison, steps listed: FAIL

- I read the Bridge at Slice lines 244 to 271 myself.
- The Bridge quantifies over x in sobolevSpace n only.
- It asks for an h in Lp ℂ 2.
- The MemSobolev conjunct never mentions h.
- The norm conjunct is the only limit on h.
- Any scaled unit L2 vector meets the norm conjunct.
- The norm formula is present as text.
- Its subject h is not the Bessel witness.
- The H1 norm is the norm of the Bessel witness.
- The formula therefore does not state the H1 norm comparison.
- A proof of this Prop would not prove the norm identity.
- The Bridge states no reverse direction.
- It states no iff over L2 classes.
- It states no uniqueness of the derivative tuple.
- The acceptance doc asks for H1 equals W^{1,2} as sets of L2 classes.
- The Bridge does not state that equality.
- The doc comment lists 6 remaining steps in order.
- The steps are listed, but the statement itself is not the bridge.
- Astra found this flaw, and my own reading confirms it.
- Check 7 fails because the bridge is not actually stated.
- I do not convert this gap into a pass.

### Check 8: a fresh judge rules DONE: FAIL

- Check 8 asks a fresh judge to rule DONE.
- I am the fresh judge.
- I rule GAP.
- Check 8 therefore fails.

### Root diff, read by me

- I diffed the shared root and the work-copy root.
- The shared root has 6 lines.
- The work-copy root has 7 lines.
- The diff shows one added line only.
- The line is `import PseudoRiemannian.SobolevSlice`.
- The shared root has no SobolevSlice reference.
- The shared root is unchanged.

### Neon's strongest flaw, decided by me

- Neon calls the core definitions monolithic and non-parameterized.
- I read sobolevSpace at Slice line 166 myself.
- It is a submodule over real scalars, PiLp 2, whole space, unit weight.
- HasWeakDeriv hardcodes the whole space with ⊤.
- The carrier fuses order 1, exponent 2, real scalars, whole space, unit weight.
- The weighted H^2 decay test needs a new carrier.
- Bounded domains and W^{k,p} need a rewrite of this carrier.
- This flaw fails no check as written.
- Checks 5 and 6 ask only for R^n W^{1,2} with its norm proved.
- Those checks are met, so this flaw is a queued design gap.
- It is gap G3 below.

### Astra's other points, noted by me

- Astra says the coefficient is correct for the stated symbols.
- The file does not identify the Mathlib multipliers in common coordinates.
- A wrong positive factor would keep norm equivalence but falsify the exact identity.
- That point belongs to bridge step 1, inside gap G1.
- Astra says the four norm axioms add no Sobolev argument.
- They are thin wrappers around inherited norm laws.
- They still prove the norm axioms, so Check 6 passes.
- Astra confirms completeness is genuinely proved, for this graph only.
- That matches my reading of lines 358 and 425.

## Units

- U1, acceptance parameters: PASS.
- U2, audit: FAIL, used items are missing, see Check 4.
- U3, weak derivatives: PASS.
- U4, W^{1,2} norm: PASS.
- U5, bridge statement: FAIL, see Check 7.
- U6, hostile reviews: PASS, both reviews are recorded verbatim.
- U7, judge: GAP, this file is the ruling.

## Kit

- Kit: Case B, Lean verification kit, draft.
- Kit path: the run folder, per the stage 1 package.
- The kit design is compile exit 0 with no sorry.
- The kit design is property tests and audit with file, line, and source.
- The kit design is hostile review recorded verbatim.
- The kit is draft, not proven across many tasks.
- No separate kit budget line exists.
- The run cap covers the kit.

## Gaps

- G1, Bridge Witness is disconnected from the Bessel witness: Queued.
  - Owner: generator.
  - Next step: restate sobolevBridge so h equals besselPotential applied to the complexified distribution, with the norm formula on that h.
  - Next step: then add the reverse direction, or label the statement forward only.
  - Next step: then run bridge step 1, read both symbols in the same Fourier coordinates.
- G2, audit omits directly used identifiers: Queued.
  - Owner: generator.
  - Next step: add file, line, and source for ofFun_apply, ofFun_congr_ae, ofFun_add, ofFun_smul, ofFun_zero, and Lp.coeFn_add, coeFn_zero, coeFn_smul.
  - Next step: then grep every identifier in the Slice against the audit and close the list.
- G3, monolithic non-parameterized core definitions: Queued.
  - Owner: generator.
  - Next step: design a parameterized W^{k,p} carrier with order, exponent, domain, and weight as parameters, before weighted H^2 work starts.
  - Next step: or record a written decision to rewrite sobolevSpace from scratch for that work.
- G4, weighted acceptance Test 3 is false as written: Queued.
  - Owner: generator.
  - Next step: fix Test 3 in docs/SobolevAcceptance-v01.md to use the square root of the weighted sum, or square the left side.
  - Next step: then re-check the scaling argument with a nonzero bump scaled by t.
- G5, bridge has no reverse direction and no uniqueness: Queued.
  - Owner: generator.
  - Next step: state the bridge as an iff over L2 classes, with the derivative tuple unique in L2 to the power n.
  - Next step: or state it as forward only and change the acceptance doc to match.
- G6, bridge proof, embeddings, trace, Poincare, weighted spaces, bounded domains: Queued.
  - Owner: future run.
  - Next step: none in this run, these are out of scope by design.
- G7, BesselPotentialSpace API and Fourier lemmas are not audited: Queued.
  - Owner: generator.
  - Next step: inspect the BesselPotentialSpace bundled API as an alternative bridge target.
  - Next step: then list the Plancherel and multiplier lemmas needed for bridge steps 1 to 6.
- G8, Check 8 fails because this verdict is GAP: Queued.
  - Owner: coordinator.
  - Next step: fix G1 and G2 first, then run a fresh checker on Checks 4 and 7.
  - Next step: then a fresh judge re-rules on the predicate.

## Cost and envelope

- Hard cap: $4.
- Run budget: $3.40.
- Held back sum: $0.60.
- Fix attempts used: 3 of 5.
- Fix attempts remaining: 2.
- No dollar figure for this judge run is in the evidence I read.
- Timebox for this judge: 2 hours.
- I did not edit any artifact file.
- I did not push, post, send, deploy, or delete anything.

## Next step

- Fix G1 first.
- Restate the Bridge with h tied to the Bessel witness.
- Then fix G2, the audit omissions.
- Then run a fresh checker on Checks 4 and 7.
- Then a fresh judge re-rules on the predicate.
- Do not push or integrate until a fresh judge rules DONE.
