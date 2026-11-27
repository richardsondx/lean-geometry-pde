# First Principles Ladder: Signature Ordering Lock

- Version note: v02 changes only the C8 line numbers from lines 11 to 14 to lines 12 to 14, and the rest of the ladder is copied unchanged from v01.

- Predicate: pred-signature-ordering-lock-v01.
- Date: 26 Nov 2026.
- Outcome: Outcome 3 full ladder.
- Decision to test: lock (p, q) as (pluses, minuses), Lorentzian (3, 1), Riemannian (n, 0).
- Verdict: lock the proposed ordering.
- Reason: the proposed lock makes (n, 0) positive definite and matches the architecture exports, while the RFC rule makes (n, 0) negative definite.

## Step 1: Name the decision

- Decision: lock (p, q) as (pluses, minuses), with Lorentzian (3, 1) and Riemannian (n, 0).
- Action: amend the two RFC lines that state (1, 3) and keep the (n, 0) lines unchanged.
- Risk if wrong: Phase 1 files would use the wrong count and the Riemannian interop conversion would fail.

## Step 2: List what must be true

- C1 load bearing: the RFC defines (p, q) as (minuses, pluses).
- C2 load bearing: the RFC pairs that definition with Riemannian (n, 0) and Lorentzian (1, 3).
- C3 load bearing: under the RFC rule, (n, 0) means n minus ones and 0 plus ones.
- C4 load bearing: under the proposed rule, (n, 0) means n plus ones and 0 minus ones.
- C5 load bearing: the architecture uses the proposed rule, with Lorentzian (3, 1) and Riemannian (n, 0).
- C6 load bearing: under the proposed rule, (n, 0) supplies pos and isVonNBounded for the conversion to Bundle.ContMDiffRiemannianMetric.
- C7 not load bearing: algebra texts use Sylvester (pluses, minuses) as the standard count.
- C8 not load bearing: the signature (-, +, +, +) is locked and is not in dispute.

## Step 3: Test each claim

- C1 verified: docs/RFC_PseudoRiemannian.md lines 37 to 38 state diag(-1, ..., -1, 1, ..., 1) with p minus ones and q plus ones.
- C2 verified: docs/RFC_PseudoRiemannian.md lines 39 to 40 state Lorentzian is the signature (1, 3) case.
- C2 verified: docs/RFC_PseudoRiemannian.md lines 42 to 43 state Riemannian is the signature (n, 0) case.
- C2 verified: docs/RFC_Conventions.md lines 78 to 79 state LorentzianMetric for the signature (1, 3) case and Riemannian is the signature (n, 0) case.
- C3 verified by calculation: under the RFC rule, (n, 0) gives a diagonal matrix with n entries equal to -1 and 0 entries equal to 1.
- C3 verified by calculation: that matrix gives g(v, v) below 0 for every nonzero v, so it is negative definite.
- C4 verified by calculation: under the proposed rule, (n, 0) gives a diagonal matrix with n entries equal to 1 and 0 entries equal to -1.
- C4 verified by calculation: that matrix gives g(v, v) above 0 for every nonzero v, so it is positive definite.
- C5 verified: docs/ARCHITECTURE.md line 14 states signature (p, q) denotes p positive and q negative eigenvalues, so Riemannian is (n, 0) and 4D Lorentzian (-, +, +, +) is (3, 1).
- C5 verified: docs/ARCHITECTURE.md line 33 states LorentzianMetric is the (n - 1, 1) abbreviation and SpacetimeMetric is the (3, 1) abbreviation.
- C6 verified: docs/InteropExample.md lines 35 to 37 state the (n, 0) metric converts by a plain definition, positive definiteness gives pos, and finite dimension gives isVonNBounded.
- C6 verified: docs/InteropExample.md lines 35 to 37 state a mixed signature fails pos through a negative vector and fails isVonNBounded through a null vector.
- C6 verified: docs/ARCHITECTURE.md line 38 states the export PseudoRiemannianMetric.pos_of_q_eq_zero.
- C7 cited, not verified: docs/ARCHITECTURE.md lines 127 to 128 state Option A differs from Sylvester (pluses, minuses) in algebra texts.
- C7 cited, not verified: no live model reply confirmed the Sylvester standard, because both model calls failed twice with a network timeout.
- C8 verified: docs/RFC_Conventions.md lines 12 to 14 state the signature is (-, +, +, +), with one timelike direction and three spacelike directions.
- C8 verified: map/Physicslib4-assessment-v02.md lines 140 to 145 state Mathlib needs Lorentzian as the (1, 3) case and Riemannian as the (n, 0) case under the old count.
- C8 verified: map/Physicslib4-assessment-v02.md lines 209 to 210 state the generalisation decision makes the Riemannian metric the signature (n, 0) case.
- Third option failed: (minuses, pluses) with Riemannian (n, 0) gives negative definite by C3, so it cannot be Riemannian.
- Alternative consistent: (minuses, pluses) with Riemannian (0, n) is internally consistent, but it contradicts docs/RFC_PseudoRiemannian.md lines 42 to 43 and docs/ARCHITECTURE.md line 14.

### Fetch list

- C1: read docs/RFC_PseudoRiemannian.md lines 37 to 38 to settle the RFC definition.
- C2: read docs/RFC_PseudoRiemannian.md lines 39 to 43 and docs/RFC_Conventions.md lines 78 to 79 to settle the RFC pairings.
- C3: count the diagonal entries of diag(-1, ..., -1, 1, ..., 1) at (n, 0) under the RFC rule to settle the sign.
- C4: count the diagonal entries at (n, 0) under the proposed rule to settle the sign.
- C5: read docs/ARCHITECTURE.md lines 14 and 33 to settle the architecture ordering.
- C6: read docs/InteropExample.md lines 35 to 37 and docs/ARCHITECTURE.md line 38 to settle the interop conversion.

## Step 4: Counter cases

- Counter case 1: if diag(-1, 1, 1, 1) counted 1 plus and 3 minus under the standard count, then the proposed lock would fail.
- Counter case 1 check: diag(-1, 1, 1, 1) has 3 entries equal to 1 and 1 entry equal to -1, so the counter case fails.
- Counter case 2: if (n, 0) under the proposed rule failed to supply pos for Bundle.ContMDiffRiemannianMetric, then the proposed lock would fail.
- Counter case 2 check: docs/InteropExample.md lines 35 to 37 state positive definiteness gives pos, so the counter case fails.

## Step 5: Rebuild from true facts

- True fact: the RFC defines (p, q) as (minuses, pluses) at docs/RFC_PseudoRiemannian.md lines 37 to 38.
- True fact: the RFC calls Riemannian (n, 0) at docs/RFC_PseudoRiemannian.md lines 42 to 43.
- True fact: under the RFC rule, (n, 0) is negative definite by direct counting.
- True fact: under the proposed rule, (n, 0) is positive definite by direct counting.
- True fact: the architecture uses (pluses, minuses) at docs/ARCHITECTURE.md line 14.
- True fact: the (n, 0) case under the proposed rule supplies pos and isVonNBounded at docs/InteropExample.md lines 35 to 37.
- True fact: the signature (-, +, +, +) is locked at docs/RFC_Conventions.md lines 12 to 14.
- Dropped: the Sylvester external standard claim stays cited, not verified, because both live model calls failed.
- Dropped: the third option (minuses, pluses) with Riemannian (n, 0) fails by direct counting.
- Rebuilt answer: lock (p, q) as (pluses, minuses), Lorentzian (3, 1), Riemannian (n, 0).

## Step 6: Decide and record

- Decision: lock (p, q) as (pluses, minuses), Lorentzian (3, 1), Riemannian (n, 0).
- Claim C1: verified, source docs/RFC_PseudoRiemannian.md lines 37 to 38, evidence is the quoted minus first definition.
- Claim C2: verified, source docs/RFC_PseudoRiemannian.md lines 39 to 43 and docs/RFC_Conventions.md lines 78 to 79, evidence is the quoted (1, 3) and (n, 0) pairings.
- Claim C3: verified, source is direct counting at (n, 0), evidence is n entries equal to -1 under the RFC rule.
- Claim C4: verified, source is direct counting at (n, 0), evidence is n entries equal to 1 under the proposed rule.
- Claim C5: verified, source docs/ARCHITECTURE.md lines 14 and 33, evidence is the quoted (3, 1) and (n, 0) exports.
- Claim C6: verified, source docs/InteropExample.md lines 35 to 37 and docs/ARCHITECTURE.md line 38, evidence is pos from positive definiteness and isVonNBounded from finite dimension.
- Claim C7: cited, not verified, source docs/ARCHITECTURE.md lines 127 to 128, evidence is the internal statement about Sylvester, with no live model confirmation.
- Claim C8: verified, source docs/RFC_Conventions.md lines 12 to 14, evidence is the locked (-, +, +, +) signature.
- True facts used: the RFC rule makes (n, 0) negative definite.
- True facts used: the proposed rule makes (n, 0) positive definite.
- True facts used: the architecture already uses the proposed rule.
- True facts used: the proposed (n, 0) case supplies the interop fields.
- Biggest open risk: no live model confirmed the Sylvester standard, so the external standard claim stays unverified.
- What would change my mind: a counted basis of diag(-1, 1, 1, 1) with 1 plus and 3 minus under the standard count would change my mind.
- Open question: does a Mathlib reviewer require Riemannian (0, n) under the alternative count instead of the proposed lock.
- Open question: does the Phase 1 lead accept the amendment lines listed in docs/SignatureOrdering-Amendment-Draft.md.

## Model calls

- Model 1 id: openai/gpt-6.2-astra, role mathematician, tool ~/workspace/custom-connectors/custom.openrouter-chat/bin/or_chat.py, max_tokens 8000.
- Model 1 outcome: failed twice, exit code 1, error urllib.error.URLError timed out.
- Model 1 cost: or_chat.py reports no cost, so no dollar figure is stated.
- Model 2 id: google/gemini-4-neon, role architect, tool ~/workspace/custom-connectors/custom.openrouter-chat/bin/or_chat.py, max_tokens 8000.
- Model 2 outcome: failed twice, exit code 1, error urllib.error.URLError timed out.
- Model 2 cost: or_chat.py reports no cost, so no dollar figure is stated.
- Model calls stopped after two failures for each model, per the timebox.
- No model reply was invented, and no verbatim model reply exists to record.

### Prompt sent to Astra

```
You are a mathematician testing signature ordering claims. Answer in short plain bullets, one sentence per bullet, no em dashes.

Context: Signature is (-, +, +, +), diag(-1, 1, 1, 1) in 4D. Proposed lock: (p, q) = (pluses, minuses), so Lorentzian is (3, 1) and Riemannian is (n, 0). Alternative: (p, q) = (minuses, pluses), so Lorentzian is (1, 3) and Riemannian is (0, n). A third option, (minuses, pluses) with Riemannian (n, 0), is claimed internally inconsistent.

Test these three claims and give a verdict on each, true or false, with one concrete reason each:
1. Sylvester law of inertia makes (pluses, minuses) the standard count for a real symmetric bilinear form, so diag(-1,1,1,1) has (p,q) = (3,1) under that count.
2. Under (pluses, minuses), (n,0) means n plus ones and 0 minus ones, so the form is positive definite, and positivity follows from the signature alone in finite dimension.
3. Under (minuses, pluses), (n,0) means n minus ones and 0 plus ones, so the form is negative definite, not Riemannian, and the third option above is inconsistent.

Also state in one sentence whether Hilbert6 diag(-1,1,1,1) is consistent with Lorentzian (3,1) under (pluses, minuses). Do not write Lean code. Do not claim any Kerr or Yang-Mills proof.
```

### Prompt sent to Neon

```
You are a software architect testing signature ordering claims for a Mathlib pseudo-Riemannian layer. Answer in short plain bullets, one sentence per bullet, no em dashes.

Context: Signature is (-, +, +, +), diag(-1, 1, 1, 1) in 4D. Proposed lock: (p, q) = (pluses, minuses), so Lorentzian is (3, 1) and Riemannian is (n, 0). Alternative: (p, q) = (minuses, pluses), so Lorentzian is (1, 3) and Riemannian is (0, n). Architecture file uses (pluses, minuses) with exports LorentzianMetric (n-1, 1), SpacetimeMetric (3, 1), and Riemannian interop lemma pos_of_q_eq_zero. The (n, 0) metric must convert by a plain definition to Bundle.ContMDiffRiemannianMetric, which needs fields pos and isVonNBounded.

Test these three claims and give a verdict on each, true or false, with one concrete reason each:
1. Under (pluses, minuses), q = 0 is exactly the condition that makes pos_of_q_eq_zero true, because no negative direction exists.
2. Under (minuses, pluses) with Riemannian (n, 0), the same conversion would fail, because (n, 0) would mean n negative directions and pos would be false.
3. Flipping the ordering after the lock would cost edits to the RFC lines that state (1, 3) and to the architecture exports that state (3, 1) and (n-1, 1), while the (-, +, +, +) sign choice itself would need no change.

Also state in one sentence the cost of flipping the ordering in Phase 1 files. Do not write Lean code. Do not claim any Kerr or Yang-Mills proof.
```

## Scope and gaps

- Scope: this file only records the ladder, and no RFC was edited.
- Gap: live model verification is missing, owner is the parent agent, next step is to retry the two model calls when the network allows.
- Gap: Sylvester external confirmation is missing, owner is the parent agent, next step is to confirm it from an algebra source or a live model reply.
- Gap: the amendment itself is not applied, owner is Richardson with the Phase 1 lead, next step is to approve the lock and apply the draft lines.
