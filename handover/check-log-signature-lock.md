# Check log: signature ordering lock

- Predicate is pred-signature-ordering-lock-v01.
- Status is check complete.
- Verdict is FAIL.
- Check log path is ~/workspace/handover-mathlib-geometry-2026-11-26/check-log-signature-lock.md.
- Scope is this file only, with no other file edited.

## Check 1: ladder

- Ladder contains Steps 1 to 6 and a fetch list with entries for C1 to C6.
- Ladder lists 8 distinct claims C1 to C8, which is within the limit of 8.
- Both counter cases were run, and both counter cases fail.
- Claim C1 verifies at docs/RFC_PseudoRiemannian.md lines 37 to 38.
- Claim C2 verifies at docs/RFC_PseudoRiemannian.md lines 39 to 43 and docs/RFC_Conventions.md lines 78 to 79.
- Claim C3 verifies by direct counting, with (n, 0) giving n minus ones under the RFC rule.
- Claim C4 verifies by direct counting, with (n, 0) giving n plus ones under the proposed rule.
- Claim C5 verifies at docs/ARCHITECTURE.md lines 14 and 33.
- Claim C6 verifies at docs/InteropExample.md lines 35 to 37 and docs/ARCHITECTURE.md line 38.
- Claim C7 is cited, not verified in the ladder, and its source lines docs/ARCHITECTURE.md lines 127 to 128 verify as quoted.
- Claim C8 fails on line numbers because docs/RFC_Conventions.md line 11 is blank and the signature text starts at line 12.
- Check 1 result is FAIL on the C8 line citation only.

## Check 2: draft v02

- Raw grep over the whole work folder returns 94 lines.
- Grep excluding the v02 draft itself returns 46 lines, which matches the draft count of 46.
- The v02 draft itself adds 48 grep hits through its own quotations.
- All 46 pre-v02 grep hits are quoted in the draft, with zero uncovered hits.
- Draft quotes 76 items, with 6 lines needing change and 70 lines needing no change.
- All 6 lines needing change verify verbatim as exact substrings.
- I verified all 70 no-change lines, not only a spot check.
- A total of 72 of 76 quotes verify verbatim as exact substrings.
- Item 16 fails because its quote is at docs/RFC_Conventions.md line 12, not line 11.
- Item 17 fails because its quote is at docs/RFC_Conventions.md line 13, not line 12.
- Item 18 fails because its quote is at docs/RFC_Conventions.md line 14, not line 13.
- Item 19 fails because its quote is at docs/RFC_Conventions.md line 16, not line 14.
- The draft correction claim that lines 11 to 14 are correct is wrong.
- The five claimed no-grep-hit files each return zero grep hits.
- Check 2 result is FAIL on items 16 to 19 only.

## Check 3: consistency

- Direct counting gives diag(-1, 1, 1, 1) with 3 plus entries and 1 minus entry.
- The locked rule makes (n, 0) positive definite by direct counting.
- The RFC rule makes (n, 0) negative definite by direct counting.
- Check 3 result is PASS.

## Check 4: cross-review

- Cross-review used Neon to review the Astra math prompt and Astra to review the Neon architecture prompt.
- Neon call succeeded on the first attempt with model google/gemini-4-neon.
- Astra call succeeded on the first attempt with model openai/gpt-6.2-astra.
- No retry was used for either call.
- The tool reports no cost, so no dollar figure is stated.
- Neon reply marks all three math claims true.
- Astra reply marks architecture claims 1 and 2 true and claim 3 false.
- Check 4 result is PASS on reply existence, with the Astra claim 3 disagreement recorded as a gap below.

### Prompt sent to Neon (Astra math prompt, verbatim)

```
You are a mathematician testing signature ordering claims. Answer in short plain bullets, one sentence per bullet, no em dashes.

Context: Signature is (-, +, +, +), diag(-1, 1, 1, 1) in 4D. Proposed lock: (p, q) = (pluses, minuses), so Lorentzian is (3, 1) and Riemannian is (n, 0). Alternative: (p, q) = (minuses, pluses), so Lorentzian is (1, 3) and Riemannian is (0, n). A third option, (minuses, pluses) with Riemannian (n, 0), is claimed internally inconsistent.

Test these three claims and give a verdict on each, true or false, with one concrete reason each:
1. Sylvester law of inertia makes (pluses, minuses) the standard count for a real symmetric bilinear form, so diag(-1,1,1,1) has (p,q) = (3,1) under that count.
2. Under (pluses, minuses), (n,0) means n plus ones and 0 minus ones, so the form is positive definite, and positivity follows from the signature alone in finite dimension.
3. Under (minuses, pluses), (n,0) means n minus ones and 0 plus ones, so the form is negative definite, not Riemannian, and the third option above is inconsistent.

Also state in one sentence whether Hilbert6 diag(-1,1,1,1) is consistent with Lorentzian (3,1) under (pluses, minuses). Do not write Lean code. Do not claim any Kerr or Yang-Mills proof.
```

### Neon reply (verbatim)

```
- Claim 1 is true because Sylvester's law of inertia proves that the counts of positive and negative entries are basis-independent invariants, conventionally ordered as (pluses, minuses), which assigns diag(-1, 1, 1, 1) the signature (3, 1).
- Claim 2 is true because on an n-dimensional real space, signature (n, 0) under (pluses, minuses) leaves no room for negative or zero eigenvalues, so the form is strictly positive definite from the signature alone.
- Claim 3 is true because under (minuses, pluses) the signature (n, 0) specifies n negative entries and 0 positive entries, which gives a negative definite form that contradicts the positive definiteness of a Riemannian metric and makes the third option inconsistent.
- Hilbert6 diag(-1, 1, 1, 1) is consistent with Lorentzian (3, 1) under (pluses, minuses) because the matrix has exactly three positive diagonal entries and one negative diagonal entry.
```

### Prompt sent to Astra (Neon architecture prompt, verbatim)

```
You are a software architect testing signature ordering claims for a Mathlib pseudo-Riemannian layer. Answer in short plain bullets, one sentence per bullet, no em dashes.

Context: Signature is (-, +, +, +), diag(-1, 1, 1, 1) in 4D. Proposed lock: (p, q) = (pluses, minuses), so Lorentzian is (3, 1) and Riemannian is (n, 0). Alternative: (p, q) = (minuses, pluses), so Lorentzian is (1, 3) and Riemannian is (0, n). Architecture file uses (pluses, minuses) with exports LorentzianMetric (n-1, 1), SpacetimeMetric (3, 1), and Riemannian interop lemma pos_of_q_eq_zero. The (n, 0) metric must convert by a plain definition to Bundle.ContMDiffRiemannianMetric, which needs fields pos and isVonNBounded.

Test these three claims and give a verdict on each, true or false, with one concrete reason each:
1. Under (pluses, minuses), q = 0 is exactly the condition that makes pos_of_q_eq_zero true, because no negative direction exists.
2. Under (minuses, pluses) with Riemannian (n, 0), the same conversion would fail, because (n, 0) would mean n negative directions and pos would be false.
3. Flipping the ordering after the lock would cost edits to the RFC lines that state (1, 3) and to the architecture exports that state (3, 1) and (n-1, 1), while the (-, +, +, +) sign choice itself would need no change.

Also state in one sentence the cost of flipping the ordering in Phase 1 files. Do not write Lean code. Do not claim any Kerr or Yang-Mills proof.
```

### Astra reply (verbatim)

```
- 1. True: For a nondegenerate metric, zero negative directions means every nonzero vector has positive squared norm.
- 2. True for n > 0: With minuses first, keeping (n, 0) gives a negative definite metric, so the required `pos` field cannot be supplied.
- 3. False: The RFC’s (1, 3) already matches minuses first, so the architecture exports must swap indices, but neither that RFC pair nor the sign pattern needs to change.
- In Phase 1, flipping the order means updating convention declarations and affected exports, changing Riemannian interop from q = 0 to p = 0, and adjusting dependent proofs.
```

## Check 5: forbidden content

- Em dash count is 0 in both new files.
- Sorry count is 0 in both new files.
- Itsdavis count is 0 in both new files.
- Kerr and Yang-Mills each appear twice in the ladder only in the sentence that forbids claiming a Kerr or Yang-Mills proof.
- No Kerr or Yang-Mills proof claim appears in either new file.
- No Lean code block appears in either new file.
- Check 5 result is PASS.

## Gaps

- GAP-QUOTES-11-14: owner is the draft author and next step is to correct draft v02 items 16 to 19 to lines 12, 13, 14, and 16.
- GAP-LADDER-C8: owner is the ladder author and next step is to correct the C8 citation from lines 11 to 14 to lines 12 to 14.
- GAP-GREP-COUNT-NOTE: owner is the draft author and next step is to state in the draft that the count of 46 excludes the v02 draft itself.
- GAP-ASTRA-CLAIM3: owner is the parent agent with the Phase 1 lead and next step is to resolve the Astra false verdict on the cost of flipping the ordering after the lock.
- GAP-APPROVAL: owner is Richardson with the Phase 1 lead and next step is to approve the lock and apply draft v02 items 1 to 6.
- GAP-1 is not recorded because both model calls succeeded, so no model gap was converted into a pass.
- Sylvester confirmation is now supplied by the Neon reply, so that ladder gap is closed.
