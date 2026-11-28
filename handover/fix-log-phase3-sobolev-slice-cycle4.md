# Fix log: phase3 Sobolev slice, fix cycle 4 of 5 (attempt 4 of 5)

- Run: stage2-mathlib-geometry-phase3-sobolev-slice-01.
- Predicate: pred-mathlib-geometry-phase3-sobolev-slice-v01.
- Date: 28 Nov 2026.
- Judge verdict before fix: GAP (verdict-phase3-sobolev-slice-v01.md). Checks 1, 2, 3, 5, 6 PASS. Checks 4, 7, 8 FAIL.
- Failure class: disconnected statement (G1), incomplete audit (G2), false acceptance test as written (G4).
- Approach ladder rung used: rung 1, retry with corrected input (restate the bridge from the definitions it must match; add verified audit entries; one-line doc fix). No theorem weakened, no predicate changed.
- Scope: exactly three files edited (track-sobolev/lean-phase1/PseudoRiemannian/SobolevSlice.lean, map/Sobolev-v436-audit.md, docs/SobolevAcceptance-v01.md) and exactly this one new file written. No push, no post, no send, no deploy, no delete. No edit to the shared root, no edit to any other track, no edit to the repo staging copy at ~/workspace/lean-geometry-pde/.

## First Principles ladder, run before editing the bridge

Step 1, name the decision: restate `sobolevBridge` so the existentially quantified `h` is the Lp function given by `TemperedDistribution.MemSobolev` itself, by adding the conjunct `TemperedDistribution.besselPotential (EuclideanSpace ℝ (Fin n)) ℂ 1 (Lp.toTemperedDistributionCLM ℂ volume 2 (sobolevComplex n x)) = h`, keeping the `MemSobolev` conjunct and the norm formula on that same `h`, and labelling the bridge forward only in its doc comment (no reverse direction, no iff, no derivative-tuple uniqueness), with the acceptance doc changed to match.

Step 4, counter cases (each checked against the restated form before editing):

- Counter case, scaled unit L2 vector (the judge's counterexample): any `h` with the right norm but unrelated to `x` passed the old statement. It fails the restated statement, because the new equality conjunct forces `h` to equal the Bessel potential of this `x`'s complexified distribution, coerced to a tempered distribution; a generic unit vector is not that function.
- Counter case, `h = 0` with `u` nonzero: the norm formula alone would fail it only if the norm is nonzero, but the equality conjunct fails it directly, since the Bessel potential of a nonzero distribution is not the zero Lp function (the Lp-to-distribution coercion is injective; `Lp.ker_toTemperedDistributionCLM_eq_bot` is the Mathlib statement, TemperedDistribution.lean line 215, read during this cycle).
- Counter case, Bessel witness of a different element `x'`: fails, because the equality names this `x`'s `sobolevComplex n x`, not `x'`'s.
- Counter case, `h` with the right norm but wrong phase or wrong Fourier support: fails the equality conjunct, which is a full equality of tempered distributions, not a norm equality.
- Counter case, `h` satisfying MemSobolev but the norm formula on a different function: impossible in the restated form, because the norm conjunct now applies to the same bound variable `h` that the equality conjunct pins down.
- Counter case, the equality does not elaborate: the pattern is copied verbatim from the two places Mathlib itself states it, so elaboration is not guessed. `MemSobolev` is defined at Mathlib/Analysis/Distribution/Sobolev.lean lines 152-154 as `∃ (f' : Lp F p (volume : Measure E)), besselPotential E F s f = f'`, and the bundled `BesselPotentialSpace` field `bessel_toDistr_eq_toLp` is `besselPotential E F s toDistr = toLp` at Mathlib/Analysis/FunctionalSpaces/BesselPotentialSpace.lean line 53. The coercion on the right-hand side is the `CoeHead (Lp F p μ) 𝓢'(E, F)` instance at Mathlib/Analysis/Distribution/TemperedDistribution.lean line 180, `coe := toTemperedDistribution`. The restated bridge uses the same shape, with `E = EuclideanSpace ℝ (Fin n)`, `F = ℂ`, `s = 1`.
- Counter case, reverse direction smuggled in: no reverse direction is added. The bridge is labelled forward only, and the acceptance doc line 45 is changed to match, so a reader cannot mistake the forward statement for the set equality H1 = W12.
- What would falsify the restatement: if `lake build` fails to elaborate the equality conjunct, or if the build proves a different set of theorems. Both are checked below by the build and the axiom print lines, not assumed.

## Coefficient check, both symbols read in the same Fourier coordinates

- Bessel symbol: Mathlib/Analysis/Distribution/Sobolev.lean line 72-73. `def besselPotential (s : ℝ) : 𝓢'(E, F) →L[ℂ] 𝓢'(E, F) := fourierMultiplierCLM F (fun x ↦ ((1 + ‖x‖ ^ 2) ^ (s / 2) : ℝ))`. At `s = 1` the symbol is `(1 + ‖ξ‖ ^ 2) ^ (1 / 2)`.
- Derivative symbol: Mathlib/Analysis/Distribution/FourierMultiplier.lean lines 200-201, `TemperedDistribution.lineDeriv_eq_fourierMultiplierCLM`: `∂_{m} f = (2 * π * Complex.I) • fourierMultiplierCLM F (inner ℝ · m) f`. For a basis direction `m = e_i` the multiplier is `2 * π * Complex.I * ξ_i`, modulus `(2 * π) * |ξ_i|`.
- Cross-check in one lemma: Mathlib/Analysis/Distribution/Sobolev.lean lines 107-110, `besselPotential_neg_one_lineDerivOp_eq`: `(besselPotential E F (-1)) (∂_{m} f) = (2 * π * Complex.I) • fourierMultiplierCLM F (fun x ↦ Complex.ofReal <| inner ℝ x m * (1 + ‖x‖ ^ 2) ^ (-1 / 2 : ℝ)) f`. This one statement combines both symbols, so they are in the same Fourier coordinates by construction, not by my say-so.
- Check result: the bridge norm formula coefficient `((2 * Real.pi) ^ 2)⁻¹` is correct for the stated symbols. Fourier side: `‖h‖^2 = ∫ (1 + ‖ξ‖^2) |û|^2`, and `(2π)^-2 * Σ_i ‖D_i‖^2 = (2π)^-2 * Σ_i ∫ (2π)^2 ξ_i^2 |û|^2 = ∫ ‖ξ‖^2 |û|^2`. Sum with `‖u‖^2 = ∫ |û|^2` gives `∫ (1 + ‖ξ‖^2) |û|^2`. A wrong positive factor would keep norm equivalence but falsify the exact identity, which is why this check is recorded here rather than left to the doc comment. The bridge statement itself is still stated, not proved; the check is about the formula as stated.

## What changed

### G1, bridge restated (SobolevSlice.lean)

- Added one conjunct to `sobolevBridge`, first in the existential body: `TemperedDistribution.besselPotential (EuclideanSpace ℝ (Fin n)) ℂ 1 (Lp.toTemperedDistributionCLM ℂ volume 2 (sobolevComplex n x)) = h`. The `MemSobolev` conjunct and the norm formula on `h` are unchanged, and no theorem statement or proof was touched.
- Updated the bridge doc comment: it now says `h` is the Bessel witness, the Lp function representing the order 1 Bessel potential of the complexified distribution, and labels the bridge forward only: it states that every W^{1,2} element has such a witness with the exact norm comparison, and does not state the reverse direction, no iff over L2 classes, and no uniqueness of the derivative tuple.
- The file header comment was left unchanged.

### G2, audit completed (Sobolev-v436-audit.md)

- Added 15 entries under "Items used", each with file, line, and source, each location read in the cached Mathlib source at baseline commit fc4f59e577feb1a4956671bc04ac18aaaf8cd842, each with its use lines in SobolevSlice.lean. The 8 judge-named identifiers first, then 7 further dotted API identifiers the completeness grep found missing (see the completeness grep below).
- The 8 judge-named identifiers:
  - Distribution.ofFun_apply, theorem: Mathlib/Analysis/Distribution/Distribution.lean, line 306. Slice lines 128, 129, 135, 136.
  - Distribution.ofFun_zero, theorem: same file, line 322. Slice line 144.
  - Distribution.ofFun_congr_ae, theorem: same file, line 326. Slice lines 102, 104.
  - Distribution.ofFun_add, theorem: same file, line 340. Slice line 152 (twice).
  - Distribution.ofFun_smul, theorem: same file, line 357. Slice line 160 (twice).
  - MeasureTheory.Lp.coeFn_zero, theorem: Mathlib/MeasureTheory/Function/LpSpace/Basic.lean, line 194. Slice lines 188, 190.
  - MeasureTheory.Lp.coeFn_add, theorem: same file, line 202. Slice lines 180, 182.
  - MeasureTheory.Lp.coeFn_smul, theorem: same file, line 480. Slice lines 196, 198.
- The 7 further identifiers found by the completeness grep:
  - PiLp.add_apply, theorem: Mathlib/Analysis/Normed/Lp/PiLp.lean, line 118. Slice lines 179, 181, 290.
  - PiLp.zero_apply, theorem: same file, line 114. Slice lines 187, 189.
  - PiLp.smul_apply, theorem: same file, line 126. Slice lines 195, 197, 293.
  - LineDeriv.lineDerivOp_zero, theorem: Mathlib/Analysis/Distribution/DerivNotation.lean, line 143, in namespace LineDeriv. Slice line 145.
  - LineDeriv.lineDerivOp_add, class field of LineDerivAdd: same file, line 102, exported into namespace LineDeriv at line 132. Slice line 153.
  - LineDeriv.lineDerivOp_smul, class field of LineDerivSMul: same file, line 111, exported into namespace LineDeriv at line 134. Slice line 160.
  - LocallyIntegrableOn.congr, lemma: Mathlib/MeasureTheory/Function/LocallyIntegrable.lean, line 104. Slice line 100 (twice).
- Namespaces verified by reading the files: `namespace Distribution` at Distribution.lean line 179, section ofFun ending line 388; `namespace MeasureTheory` / `namespace Lp` at LpSpace/Basic.lean lines 69 and 144; `namespace PiLp` at PiLp.lean line 102; `namespace LineDeriv` at DerivNotation.lean line 130.
- No entry was added on a guess. The cycle 3 error (six "Items used" entries for identifiers the slice never uses) was not repeated: every added entry cites a grep count above zero in SobolevSlice.lean, and the fix log records the slice line for each.

### G4, Test 3 fixed in one line (SobolevAcceptance-v01.md, line 40)

- Old: "the sup norm of bracket-x times u is at most C times the weighted norm".
- New: "the sup norm of bracket-x times u is at most C times the square root of the weighted norm".
- One line changed, nothing else in the file touched except the line 45 forward-only change below.
- Scaling re-check, nonzero bump scaled by t: take any nonzero `u` with finite weighted norm and put `u_t = t * u` with `t > 0`. Left side: `sup |⟨x⟩ u_t| = t * sup |⟨x⟩ u|`, linear in `t`. Right side: the weighted norm is defined in the doc (line 21) as a sum over multi-indices of integrals of squared derivatives, so the weighted norm of `u_t` is `t^2` times the weighted norm of `u`, and its square root is `t` times the square root of the weighted norm of `u`. Both sides scale by `t`, so the inequality is scale-consistent. Under the old wording the right side scaled by `t^2` while the left scaled by `t`, which is the judge's falsification. This re-check is algebra on the scaling law from the doc's own definition of the weighted norm, not a numeric integral.

### G5 doc match, forward only (SobolevAcceptance-v01.md, line 45)

- Old: "Bridge: H1 of R^n equals W12 of R^n, as sets of L2 classes, with the derivative tuple unique in L2 to the power n."
- New: "Bridge (forward only): every W12 element of R^n has an H1 Bessel witness h, with the norm comparison below; the reverse direction, the equality of H1 and W12 as sets of L2 classes, and uniqueness of the derivative tuple are not stated here."
- One line changed. This is the forward-only option the verdict offers for G5, matching the bridge doc comment label. No reverse direction, iff, or uniqueness claim was added to the Lean file.

## Completeness grep (G2)

- Method: `grep -oE "[A-Za-z][A-Za-z0-9_]*(\.[A-Za-z][A-Za-z0-9_]*)+" track-sobolev/lean-phase1/PseudoRiemannian/SobolevSlice.lean | sort | uniq -c | sort -rn`, run before editing. Result: 64 distinct dotted strings.
- After the 15 additions, every dotted identifier in the Slice that names a distribution, Lp, PiLp, LineDeriv, TestFunction, SchwartzMap, or tempered-distribution API item appears in the audit. The 8 judge-named identifiers are each present; verified by grep per name below.
- What the grep count covers and what it does not: the remaining dotted strings not in the audit are, by inspection, (a) local definitions and theorems of the Slice itself (`HasWeakDeriv.*`, `sobolevSpace`, `sobolevComplex`, `testFunLp`, `weakFunctional`), (b) field projections and local variables (`x.ofLp`, `i.succ`, `j.succ`, `hs.congr_ae`, `hadd.congr_ae`, `h0.congr_ae`, `volume.restrict`), (c) import paths and prose (`Mathlib.Analysis.*`, `slice.md`, `Sobolev.lean`), (d) the axioms named in the file header (`Quot.sound`, `Classical.choice`), and (e) generic core/Mathlib lemmas the audit has never listed and the judge did not flag (`Set.mem_iInter`, `SetLike.mem_coe`, `LinearMap.mem_ker`, `Measure.restrict_univ`, `Fin.sum_univ_succ`, `Real.norm_eq_abs`, `Filter.Eventually.of_forall`, `Real.sqrt`, `Real.pi`, `Set.univ`, `L2.inner_def` is listed, `RCLike.inner_apply` is listed). Unqualified root-namespace lemmas used in proofs (`norm_nonneg`, `integral_congr_ae`, `locallyIntegrableOn_zero`, and similar) are likewise outside the audit's scope as written in all prior cycles, and were not added; the audit's scope is the named distribution/Lp API items, and this fix closes that scope. A fresh checker that wants a wider scope should say so explicitly; this log does not claim the wider scope was closed.

## Verification, run after the edits

All commands run 28 Nov 2026, ~06:19 UTC, from the paths stated.

- Build: `cd track-sobolev/lean-phase1 && flock /tmp/lean-phase1-build.lock lake build`. Exit 0. Output: "Build completed successfully (6528 jobs)." SobolevSlice replayed, root built at job 6526 of 6528. The restated bridge elaborated with no error; the equality conjunct uses the same coercion as `MemSobolev`, as the ladder predicted.
- Sorry/admit: `grep -rn "sorry\|admit" PseudoRiemannian/SobolevSlice.lean`. No matches, exit 1.
- Axiom check: `flock /tmp/lean-phase1-build.lock lake env lean PseudoRiemannian/SobolevSlice.lean`. Exit 0. All 15 `#print axioms` lines print `[propext, Classical.choice, Quot.sound]`; `grep -c "depends on axioms: \[propext, Classical.choice, Quot.sound\]"` on the output returns 15, `grep -c "^#print axioms"` on the file returns 15, and a grep for any other axiom line returns no matches (exit 1). The 15 theorems are the same 15 as before the fix (HasWeakDeriv.unique, memLp_locallyIntegrableOn, HasWeakDeriv.congr_ae, HasWeakDeriv.iff_integral, HasWeakDeriv.zero, HasWeakDeriv.add, HasWeakDeriv.smul, sobolev_norm_eq, sobolev_norm_nonneg, sobolev_norm_eq_zero, sobolev_norm_add_le, sobolev_norm_smul, sobolevSpace_complete, weakFunctional_apply, sobolevSpace_isClosed). No theorem statement was weakened; `sobolevBridge` is a stated Prop, not a theorem, and its restatement adds a conjunct rather than removing one.
- Audit grep per name, each `grep -c` on map/Sobolev-v436-audit.md returns 1: ofFun_apply, ofFun_congr_ae, ofFun_add, ofFun_smul, ofFun_zero, coeFn_add, coeFn_zero, coeFn_smul. "Items used" now has 46 entries (31 before plus the 15 added here), counted by awk over that section.
- Completeness grep re-run after the edits: the same 64 distinct dotted strings; every distribution/Lp/PiLp/LineDeriv/TestFunction/SchwartzMap/tempered-distribution API identifier among them is now in the audit. The remaining uncovered strings are the local/projection/import/prose/generic items enumerated in the completeness section above, which are outside the audit's scope as written in all prior cycles.
- Shared root guard: `lean-phase1/PseudoRiemannian.lean` still has 6 lines and 0 matches for SobolevSlice (grep exit 1). Unchanged.
- Files changed by this cycle: only the three edited files listed in Scope plus this fix log. No other track file, no check log, no predicate, no repo staging copy touched. No push, post, send, deploy, or delete.

## Why the last failure should not repeat

- G1: the judge's counterexample (a scaled unit L2 vector satisfying the norm formula) is now impossible by construction, because `h` is pinned by an equality to the Bessel potential of this `x`'s distribution, not merely by a norm. The equality is copied from the two places Mathlib states it (MemSobolev def, BesselPotentialSpace field), so the statement is the library's own witness, not a paraphrase.
- G2: every added audit entry was verified by reading the Mathlib source at the stated file and line and by a grep count above zero in the Slice, with slice line numbers recorded. The cycle 3 failure mode (entries for identifiers never used) cannot recur for these entries, because each one cites its use lines.
- G4: the one-line fix changes the scaling law on the right side from `t^2` to `t`, matching the left side, and the re-check with a nonzero bump scaled by `t` is recorded above.
- G5: the forward-only label is in both places that could mislead (the bridge doc comment and the acceptance doc line 45), so a fresh checker cannot read either as the set equality.

## Status per gap

- G1, bridge witness disconnected from the Bessel witness: Fixed.
- G2, audit omits directly used identifiers: Fixed (8 judge-named identifiers plus 7 further API identifiers found by the completeness grep).
- G4, weighted acceptance Test 3 false as written: Fixed in one line, with the scaling re-check recorded.
- G5, no reverse direction and no uniqueness: handled by the forward-only option, bridge labelled forward only and acceptance doc line 45 changed to match. No reverse direction, iff, or uniqueness was added.
- G3, G6, G7: not touched, still queued, per the task scope.
