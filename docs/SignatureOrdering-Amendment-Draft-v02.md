# Signature ordering amendment, draft v02

Date: 26 Nov 2026.
Predicate: pred-signature-ordering-lock-v01.
Source verdict: first-principles-ladder-signature.md, verdict is lock.
Status: draft only.
This file proposes an amendment.
It changes nothing.
No RFC or other file was edited to write this draft.

## Locked rule

- Locked rule: (p, q) means (pluses, minuses).
- Lorentzian is (3, 1).
- Riemannian is (n, 0).

## Grep record

- Grep command: grep -rn -E '\(1, 3\)|\(1,3\)|p minus ones|q plus ones' .
- Grep working directory: the work folder root.
- Grep output count: 46 lines.
- Every one of those 46 lines is quoted below as items 1 to 6 in part and items in the later sections.
- Total lines quoted in this draft: 76.
- Lines needing change: 6.
- Lines needing no change: 70.

## 1. Lines needing change

### 1. docs/RFC_PseudoRiemannian.md line 37

Quote: "matrix is diag(-1, ..., -1, 1, ..., 1) with p minus ones and q"

- Replacement: "matrix is diag(-1, ..., -1, 1, ..., 1) with p plus ones and q"

### 2. docs/RFC_PseudoRiemannian.md line 38

Quote: "plus ones."

- Replacement: "minus ones."

### 3. docs/RFC_PseudoRiemannian.md line 39

Quote: "- A Lorentzian metric is the signature (1, 3) case on a"

- Replacement: "- A Lorentzian metric is the signature (3, 1) case on a"

### 4. docs/RFC_Conventions.md line 78

Quote: "- `LorentzianMetric` for the signature (1, 3) case."

- Replacement: "- `LorentzianMetric` for the signature (3, 1) case."

### 5. map/Physicslib4-assessment.md line 113

Quote: "with signature (p, q) as data, so that Lorentzian is the (1, 3)"

- Replacement: "with signature (p, q) as data, so that Lorentzian is the (3, 1)"

### 6. map/Physicslib4-assessment-v02.md line 143

Quote: "with signature (p, q) as data, so that Lorentzian is the (1, 3)"

- Replacement: "with signature (p, q) as data, so that Lorentzian is the (3, 1)"

## 2. Lines needing no change

### 7. docs/RFC_PseudoRiemannian.md line 40

Quote: "four-dimensional manifold, with the (-, +, +, +) convention"

- No change: this line states only the sign convention and the dimension.

### 8. docs/RFC_PseudoRiemannian.md line 42

Quote: "- A Riemannian metric is the signature (n, 0) case. Positivity"

- No change: this line states the Riemannian case that is correct under the lock.

### 9. docs/RFC_PseudoRiemannian.md line 43

Quote: "is a consequence of the signature, not separate data."

- No change: this line states positivity follows from the signature.

### 10. docs/RFC_PseudoRiemannian.md line 9

Quote: "signature (p, q) as data, and make the Riemannian metric the"

- No change: this line states the generalisation direction without an ordering count.

### 11. docs/RFC_PseudoRiemannian.md line 10

Quote: "signature (n, 0) case. Do not build a parallel class."

- No change: this line states the Riemannian case that is correct under the lock.

### 12. docs/RFC_PseudoRiemannian.md line 24

Quote: "- The Riemannian case is recovered exactly: signature (n, 0) plus"

- No change: this line states the Riemannian case that is correct under the lock.

### 13. docs/RFC_PseudoRiemannian.md line 25

Quote: "the positivity that follows from the signature."

- No change: this line states positivity follows from the signature.

### 14. docs/RFC_Conventions.md line 77

Quote: "signature (p, q)."

- No change: this line names the pair without an ordering count.

### 15. docs/RFC_Conventions.md line 79

Quote: "- Riemannian is the signature (n, 0) case of the same structure."

- No change: this line states the Riemannian case that is correct under the lock.

### 16. docs/RFC_Conventions.md line 11

Quote: "Signature is (-, +, +, +). One timelike direction, three spacelike"

- No change: this line locks the sign choice that is not in dispute.

### 17. docs/RFC_Conventions.md line 12

Quote: "directions. A tangent vector v is timelike when g(v, v) < 0,"

- No change: this line defines timelike vectors under the locked sign choice.

### 18. docs/RFC_Conventions.md line 13

Quote: "null when g(v, v) = 0, spacelike when g(v, v) > 0."

- No change: this line defines null and spacelike vectors under the locked sign choice.

### 19. docs/RFC_Conventions.md line 14

Quote: "Why: it is the convention of Wald's General Relativity, of the"

- No change: this line gives a reason for the sign choice that is not in dispute.

### 20. map/Physicslib4-assessment.md line 114

Quote: "case and Riemannian is the (n, 0) case."

- No change: this line states the Riemannian case that is correct under the lock.

### 21. map/Physicslib4-assessment.md line 168

Quote: "with signature (p, q) as data, and make the Riemannian metric the"

- No change: this line states the generalisation direction without an ordering count.

### 22. map/Physicslib4-assessment.md line 169

Quote: "signature (n, 0) case. Do not build a parallel class."

- No change: this line states the Riemannian case that is correct under the lock.

### 23. map/Physicslib4-assessment-v02.md line 144

Quote: "case and Riemannian is the (n, 0) case."

- No change: this line states the Riemannian case that is correct under the lock.

### 24. map/Physicslib4-assessment-v02.md line 209

Quote: "with signature (p, q) as data, and make the Riemannian metric the"

- No change: this line states the generalisation direction without an ordering count.

### 25. map/Physicslib4-assessment-v02.md line 210

Quote: "signature (n, 0) case. Do not build a parallel class."

- No change: this line states the Riemannian case that is correct under the lock.

### 26. docs/InteropExample.md line 102

Quote: "(p, q) has p minus ones and q plus ones, which would make (n, 0) negative"

- No change: this line describes the old Phase 0 rule as the source of the inconsistency.

### 27. docs/InteropExample.md line 35

Quote: "- Convert the `(n,0)` metric to `Bundle.ContMDiffRiemannianMetric` by a plain definition, not an instance. Retain `inner`, `symm`, and `contMDiff`; positive definiteness gives `pos`, and in finite dimension the positive-definite unit ball is bounded, giving `isVonNBounded`."

- No change: this line uses the (n, 0) case that is correct under the lock.

### 28. docs/InteropExample.md line 36

Quote: "- Use the existing registration from that converted metric as the sole source of `Bundle.RiemannianBundle`, with the existing `IsContMDiffRiemannianBundle` instance. Keep the two priority-80 fiber instances in the `Bundle` scope."

- No change: this line states the registration source without an ordering count.

### 29. docs/InteropExample.md line 37

Quote: "- With `(n,0)` denoting positive signature, **p>0 alone is not an obstruction**. For mixed signature `p,q>0`, a negative vector violates `pos`. A nonzero null vector `v` violates `isVonNBounded`: the entire line `tv` lies in `{w | g(w,w)<1}`, since `g(tv,tv)=0` for every real `t`. This is the light-cone obstruction, not a failure of smoothness or symmetry."

- No change: this line uses the (n, 0) case that is correct under the lock.

### 30. docs/ARCHITECTURE.md line 14

Quote: "Target baseline: upgrade the local Mathlib pin from v4.23.0 to v4.36.0 in Step 0. This consumes upstream `Mathlib.Geometry.Manifold.VectorBundle.CovariantDerivative.Basic`, `Mathlib.Analysis.Distribution.Sobolev`, and `Mathlib.Analysis.Distribution.TemperedDistribution` instead of duplicating them or importing unmerged PR 36128. Signature `(p, q)` denotes `p` positive and `q` negative eigenvalues, so Riemannian is `(n, 0)` and 4D Lorentzian `(-, +, +, +)` is `(3, 1)` with coordinate 0 timelike."

- No change: this line already uses the locked ordering.

### 31. docs/ARCHITECTURE.md line 23

Quote: "- `PseudoRiemannian.Curvature`: enables computing the Riemann tensor, a (1, 3)-type tensor, `R(X, Y)Z = nabla_X nabla_Y Z - nabla_Y nabla_X Z - nabla_[X,Y] Z` and proving the first and second Bianchi identities."

- No change: this line uses (1, 3) as tensor valence, not as signature.

### 32. docs/ARCHITECTURE.md line 27

Quote: "- `Analysis.PDE.GeometricBase`: enables weak elliptic solvability for `(n, 0)` Laplace-Beltrami via `LaxMilgram` and energy bounds for `(n - 1, 1)` wave operators via `Gronwall`."

- No change: this line uses (n, 0) and (n - 1, 1) in the locked ordering.

### 33. docs/ARCHITECTURE.md line 33

Quote: "- Exports: `PseudoRiemannianMetric` (parameters `p q : Nat`, smoothness `n : WithTop ENat`, fields `val`, `symm`, `nondegenerate`, `hasSignature`, `contMDiff`), `LorentzianMetric` (`(n - 1, 1)` abbreviation), `SpacetimeMetric` (`(3, 1)` abbreviation), `PseudoRiemannianMetric.finrank_eq`, `PseudoRiemannianMetric.isLocallyConstant_signature`."

- No change: this line already uses the locked ordering.

### 34. docs/ARCHITECTURE.md line 38

Quote: "- Exports: `PseudoRiemannianMetric.pos_of_q_eq_zero`, `PseudoRiemannianMetric.isVonNBounded_of_q_eq_zero`, `PseudoRiemannianMetric.toContMDiffRiemannianMetric`, `Bundle.ContMDiffRiemannianMetric.toPseudoRiemannianMetric` (plain `def`, not an instance), scoped instances in namespace `PseudoRiemannian.Riemannian` for `Bundle.RiemannianBundle`, `IsContMDiffRiemannianBundle`, and `IsRiemannianManifold` (open decision, see below: these scoped instances are in tension with the existing Mathlib instance at VectorBundle/Riemannian.lean:257 and are not yet justified)."

- No change: this line names the interop lemma that holds when q equals zero under the lock.

### 35. docs/ARCHITECTURE.md line 127

Quote: "- Option A (Phase 0 lock): `(p, q) = (minuses, pluses)`, Lorentzian is `(1, 3)`. Cost: differs from Sylvester `(pluses, minuses)` in algebra texts and makes Riemannian metrics `(0, n)`."

- No change: this line describes Option A, so it must keep the old ordering to describe that option.

### 36. docs/ARCHITECTURE.md line 128

Quote: "- Option B (architecture draft): `(p, q) = (pluses, minuses)`, Lorentzian is `(3, 1)`. Cost: breaks Phase 0 artifacts and departs from `(1, n-1)` physics conventions, requiring Phase 0 edits."

- No change: this line describes Option B, so it must keep both options and the physics convention note to describe that option.

### 37. docs/ARCHITECTURE.md line 165

Quote: "ones and q plus ones, Lorentzian is (1, 3), and Riemannian is (n, 0). Under its"

- No change: this line describes the Phase 0 inconsistency as a historical record.

### 38. Audit/inventory-v02.md line 206

Quote: "signature (p, q), Riemannian as the (n, 0) case) is unproven"

- No change: this line states the Riemannian case that is correct under the lock.

### 39. docs/DownstreamExamples.md line 18

Quote: "- **Metric interop.** Given a smooth finite-dimensional metric `g` of signature `(n,0)`, state that the squared fiber norm obtained through its Riemannian registration equals `g_b(v,v)`. This is a conversion and instance-coherence obligation, not a recorded failed probe. The target is `Bundle.ContMDiffRiemannianMetric` at `Mathlib/Geometry/Manifold/VectorBundle/Riemannian.lean:238`; its registration follows the structure. A second `Bundle.RiemannianBundle` alongside that registration gives competing choices of metric and hence of fiber `NormedAddCommGroup` and `InnerProductSpace`. Typeclass search choosing one does not make both norms definitionally equal. With no registration, neither the fiber norm nor the `InnerProductSpace` is supplied by this metric. For a tangent metric, results about `Manifold.riemannianEDist` and the `IsRiemannianManifold` equality then cannot be used through this metric either. Registration alone does not prove that equality."

- No change: this line uses the (n, 0) case that is correct under the lock.

## 3. Remaining grep hits, all needing no change

Each line below is a historical record, a draft quotation, a log entry, or a description of the old ordering.
No change is made to a historical record by this amendment.

### 40. docs/SignatureOrdering-Amendment-Draft.md line 21

Quote: "- Lines 37-38: \"matrix is diag(-1, ..., -1, 1, ..., 1) with p minus ones and q"

- No change: this line quotes the RFC in the existing draft.

### 41. docs/SignatureOrdering-Amendment-Draft.md line 23

Quote: "- Lines 39-40: \"A Lorentzian metric is the signature (1, 3) case on a"

- No change: this line quotes the RFC in the existing draft.

### 42. docs/SignatureOrdering-Amendment-Draft.md line 35

Quote: "- Line 78: \"`LorentzianMetric` for the signature (1, 3) case.\""

- No change: this line quotes the RFC in the existing draft.

### 43. docs/SignatureOrdering-Amendment-Draft.md line 55

Quote: "- Lines 37-38: change \"with p minus ones and q plus ones\" to"

- No change: this line states a proposed change in the existing draft.

### 44. docs/SignatureOrdering-Amendment-Draft.md line 57

Quote: "- Lines 39-40: change \"the signature (1, 3) case\" to"

- No change: this line states a proposed change in the existing draft.

### 45. docs/SignatureOrdering-Amendment-Draft.md line 67

Quote: "- Line 78: change \"for the signature (1, 3) case\" to"

- No change: this line states a proposed change in the existing draft.

### 46. neon-log.md line 56

Quote: "- `PseudoRiemannian.Curvature`: enables computing the `(1, 3)` Riemann tensor `R(X, Y)Z = nabla_X nabla_Y Z - nabla_Y nabla_X Z - nabla_[X,Y] Z` and proving the first and second Bianchi identities."

- No change: this line is a log copy of a tensor valence use.

### 47. neon-log.md line 110

Quote: "9. Open decisions for the Mathlib reviewer, each with the cost of each option. Include one item: the (p, q) ordering is disputed, Phase 0 locked (p, q) as (minuses, pluses) with Lorentzian (1, 3), your draft used (pluses, minuses) with Lorentzian (3, 1). State both and say the choice must be locked before any file is written."

- No change: this line is a log record of an instruction.

### 48. neon-log.md line 198

Quote: "- Option A (Phase 0 lock): `(p, q) = (minuses, pluses)`, Lorentzian is `(1, 3)`. Cost: differs from Sylvester `(pluses, minuses)` in algebra texts and makes Riemannian metrics `(0, n)`."

- No change: this line is a log copy of the Option A description.

### 49. generator-log.md line 132

Quote: "internally inconsistent (p minus ones, Lorentzian (1, 3), Riemannian (n, 0)"

- No change: this line is a log summary of the inconsistency.

### 50. check-log-phase1-planning.md line 248

Quote: "- Signature dispute, real and unresolved: Phase 0 docs/RFC_PseudoRiemannian.md defines (p,q) as p minus ones and q plus ones, calls Lorentzian (1,3), and calls Riemannian (n,0); under its own rule (n,0) is n minuses, i.e. negative definite, not Riemannian. The same inconsistency is in docs/RFC_Conventions.md (LorentzianMetric is the (1,3) case, Riemannian is (n,0)). Neon and Astra both use (p,q) as (pluses, minuses), Lorentzian (3,1), Riemannian (n,0). The (-,+,+,+) signature itself is undisputed."

- No change: this line is a check record of the dispute.

### 51. check-log-phase1-planning.md line 254

Quote: "- Open decisions: signature (p,q) ordering disputed, must be locked before any file is written (Option A Phase 0 lock (minuses,pluses) Lorentzian (1,3); Option B (pluses,minuses) Lorentzian (3,1)); connection interface (extend upstream CovariantDerivative.Basic directly vs local typeclass plus bridge); LocalSobolevSpace foundation (restrict upstream TemperedDistribution Sobolev spaces vs define distributional derivatives directly on open U)."

- No change: this line is a check record of the open decision.

### 52. check-log-phase1-planning.md line 290

Quote: "ones and q plus ones.\" Same file: \"A Lorentzian metric is the signature"

- No change: this line is a check record quoting the RFC.

### 53. check-log-phase1-planning.md line 291

Quote: "(1, 3) case\" and \"A Riemannian metric is the signature (n, 0) case.\""

- No change: this line is a check record quoting the RFC.

### 54. check-log-phase1-planning.md line 295

Quote: "(1, 3) case. Riemannian is the signature (n, 0) case of the same"

- No change: this line is a check record quoting the RFC.

### 55. check-log-phase1-planning.md line 312

Quote: "docs/RFC_PseudoRiemannian.md (the p-minus-ones definition, the (1, 3)"

- No change: this line is a check record naming the RFC lines.

### 56. check-log-phase1-planning.md line 313

Quote: "Lorentzian case) and docs/RFC_Conventions.md (the (1, 3) LorentzianMetric"

- No change: this line is a check record naming the RFC lines.

### 57. check-log-phase1-planning.md line 319

Quote: "the Riemann tensor \"(1, 3)\", which is standard (1,3)-tensor-type notation"

- No change: this line is a check record about tensor valence notation.

### 58. fix-log-cycle1.md line 45

Quote: "said \"(1, 3) Riemann tensor\", which collides visually with the"

- No change: this line is a fix log record about tensor valence wording.

### 59. fix-log-cycle1.md line 47

Quote: "(1, 3)-type tensor\"."

- No change: this line is a fix log record about tensor valence wording.

### 60. fix-log-cycle1.md line 84

Quote: "Verified: both RFC files still contain the original (1, 3) lines,"

- No change: this line is a fix log verification record.

### 61. check-log-phase1-planning-v02.md line 42

Quote: "Verified line by line: RFC_PseudoRiemannian.md line 37 starts with the diag matrix text and line 38 ends with plus ones, lines 39 to 40 give Lorentzian as the signature (1, 3) case, line 42 gives Riemannian as the signature (n, 0) case. RFC_Conventions.md line 78 gives LorentzianMetric for the signature (1, 3) case, line 79 gives Riemannian as the signature (n, 0) case."

- No change: this line is a check record verifying the RFC lines.

### 62. check-log-phase1-planning-v02.md line 44

Quote: "Both RFCs are untouched: they still contain the original (1, 3) lines at the quoted line numbers."

- No change: this line is a check record that the RFCs are untouched.

### 63. verdict-phase1-planning-v01.md line 15

Quote: "- Signature inconsistency, confirmed by direct read of the RFCs: docs/RFC_PseudoRiemannian.md lines 37-38 define (p, q) as p minus ones and q plus ones, lines 39-40 call Lorentzian the (1, 3) case, line 42 calls Riemannian the (n, 0) case. Under the lines 37-38 rule, (n, 0) means n minus ones, which is negative definite, not Riemannian. docs/RFC_Conventions.md line 78 calls LorentzianMetric the (1, 3) case and line 79 calls Riemannian the (n, 0) case, same inconsistency. Lines 11-14 of the same file lock (-, +, +, +), which is not in dispute. The amendment draft quotes all of these lines accurately and both RFCs are still untouched."

- No change: this line is a verdict record of the inconsistency.

### 64. final-report-phase1-planning.md line 20

Quote: "- The RFCs still contain the original (1, 3) lines, and the amendment draft quotes them accurately."

- No change: this line is a final report record.

### 65. stage1-package-signature-lock-v01.md line 35

Quote: "- U2, amendment draft: exact lines to change in RFC_PseudoRiemannian.md lines 37-38 and 39-40, and RFC_Conventions.md line 78, plus every downstream line that cites (1, 3)."

- No change: this line is a stage package task description.

### 66. stage2-manifest-signature-lock-v01.md line 14

Quote: "- U2, amendment draft: exact lines to change in RFC_PseudoRiemannian.md lines 37-38 and 39-40, and RFC_Conventions.md line 78, plus every downstream line that cites (1, 3)."

- No change: this line is a stage manifest task description.

### 67. first-principles-ladder-signature.md line 13

Quote: "- Action: amend the two RFC lines that state (1, 3) and keep the (n, 0) lines unchanged."

- No change: this line is a ladder record of the action.

### 68. first-principles-ladder-signature.md line 19

Quote: "- C2 load bearing: the RFC pairs that definition with Riemannian (n, 0) and Lorentzian (1, 3)."

- No change: this line is a ladder record of the claim.

### 69. first-principles-ladder-signature.md line 29

Quote: "- C1 verified: docs/RFC_PseudoRiemannian.md lines 37 to 38 state diag(-1, ..., -1, 1, ..., 1) with p minus ones and q plus ones."

- No change: this line is a ladder record of the verification.

### 70. first-principles-ladder-signature.md line 30

Quote: "- C2 verified: docs/RFC_PseudoRiemannian.md lines 39 to 40 state Lorentzian is the signature (1, 3) case."

- No change: this line is a ladder record of the verification.

### 71. first-principles-ladder-signature.md line 32

Quote: "- C2 verified: docs/RFC_Conventions.md lines 78 to 79 state LorentzianMetric for the signature (1, 3) case and Riemannian is the signature (n, 0) case."

- No change: this line is a ladder record of the verification.

### 72. first-principles-ladder-signature.md line 45

Quote: "- C8 verified: map/Physicslib4-assessment-v02.md lines 140 to 145 state Mathlib needs Lorentzian as the (1, 3) case and Riemannian as the (n, 0) case under the old count."

- No change: this line is a ladder record of the verification.

### 73. first-principles-ladder-signature.md line 83

Quote: "- Claim C2: verified, source docs/RFC_PseudoRiemannian.md lines 39 to 43 and docs/RFC_Conventions.md lines 78 to 79, evidence is the quoted (1, 3) and (n, 0) pairings."

- No change: this line is a ladder record of the claim.

### 74. first-principles-ladder-signature.md line 115

Quote: "Context: Signature is (-, +, +, +), diag(-1, 1, 1, 1) in 4D. Proposed lock: (p, q) = (pluses, minuses), so Lorentzian is (3, 1) and Riemannian is (n, 0). Alternative: (p, q) = (minuses, pluses), so Lorentzian is (1, 3) and Riemannian is (0, n). A third option, (minuses, pluses) with Riemannian (n, 0), is claimed internally inconsistent."

- No change: this line is a ladder record of the model prompt context.

### 75. first-principles-ladder-signature.md line 130

Quote: "Context: Signature is (-, +, +, +), diag(-1, 1, 1, 1) in 4D. Proposed lock: (p, q) = (pluses, minuses), so Lorentzian is (3, 1) and Riemannian is (n, 0). Alternative: (p, q) = (minuses, pluses), so Lorentzian is (1, 3) and Riemannian is (0, n). Architecture file uses (pluses, minuses) with exports LorentzianMetric (n-1, 1), SpacetimeMetric (3, 1), and Riemannian interop lemma pos_of_q_eq_zero. The (n, 0) metric must convert by a plain definition to Bundle.ContMDiffRiemannianMetric, which needs fields pos and isVonNBounded."

- No change: this line is a ladder record of the model prompt context.

### 76. first-principles-ladder-signature.md line 135

Quote: "3. Flipping the ordering after the lock would cost edits to the RFC lines that state (1, 3) and to the architecture exports that state (3, 1) and (n-1, 1), while the (-, +, +, +) sign choice itself would need no change."

- No change: this line is a ladder record of the model prompt.

## Files with no grep hit

- docs/SobolevRoutes.md has no line matching the grep pattern.
- docs/BaselineDecision.md has no line matching the grep pattern.
- docs/MissingInventory.md has no line matching the grep pattern.
- docs/DownstreamExamples.md has no line matching the grep pattern for the old ordering.
- Audit/inventory-v02.md has no line matching the grep pattern for the old ordering.

## Corrections to the existing draft

- The existing draft cites the Riemannian sentence as line 42 alone.
- The sentence spans lines 42 to 43, so the correct citation is lines 42 to 43.
- The existing draft states the Sylvester match as a fact.
- That Sylvester claim is cited, not verified, because both model calls in the ladder failed twice with a network timeout.
- The existing draft does not cover the Physicslib4 lines, the InteropExample note, or the Architecture option lines.
- This draft adds those lines as items 5, 6, 26, 35, 36, and 37.
- The existing draft line numbers for RFC_PseudoRiemannian.md lines 37 to 38, lines 39 to 40, lines 9 to 10, and lines 24 to 25 are correct.
- The existing draft line numbers for RFC_Conventions.md line 78, line 79, and lines 11 to 14 are correct.

## Gaps

- Approval is open, owner is Richardson with the Phase 1 lead, next step is to approve the lock and apply items 1 to 6.
- Live model confirmation of the Sylvester standard is missing, owner is the parent agent, next step is to retry the two model calls when the network allows.
- The amendment itself is not applied, owner is Richardson with the Phase 1 lead, next step is to edit the RFC and Physicslib4 lines listed in section 1 after approval.
- The scoped instances question in docs/ARCHITECTURE.md line 38 and docs/InteropExample.md line 36 is unchanged by this amendment, owner is the Phase 1 lead, next step is to decide that question separately.
