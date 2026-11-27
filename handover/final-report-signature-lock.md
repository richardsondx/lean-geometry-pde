# Final report: signature ordering lock

Predicate: pred-signature-ordering-lock-v01.
Date: 26 Nov 2026.

## Result

- Verdict is DONE on pred-signature-ordering-lock-v01.
- The proposed lock is (p, q) as (pluses, minuses), Lorentzian as (3, 1), and Riemannian as (n, 0).
- The re-check verdict is PASS and no check was converted.

## Evidence

- Direct read confirmed RFC_Conventions.md lines 12 to 14 lock the signature as (-, +, +, +) with one timelike direction and three spacelike directions.
- Direct read confirmed RFC_Conventions.md line 16 gives the Wald reason for that sign choice.
- Direct read confirmed RFC_PseudoRiemannian.md lines 37 to 38 define (p, q) as p minus ones and q plus ones.
- Direct read confirmed RFC_PseudoRiemannian.md lines 39 to 43 pair Lorentzian with (1, 3) and Riemannian with (n, 0).
- Direct read confirmed ARCHITECTURE.md line 14 defines (p, q) as p positive and q negative eigenvalues with Lorentzian (3, 1) and Riemannian (n, 0).
- Counting diag(-1, 1, 1, 1) gives three plus entries and one minus entry.
- Counting under the RFC rule makes (n, 0) negative definite.
- Counting under the proposed rule makes (n, 0) positive definite.
- The ladder, the amendment draft v03, both check logs, and the fix log were read in full.
- The Astra claim 3 disagreement is adjudicated in the fix log and in the draft v03 note, with the verbatim reply preserved in the first check log.
- The Neon cross-review reply confirms the Sylvester standard and the counting claims.
- Both RFCs still contain the pre-lock (1, 3) lines, so no RFC was amended in this run.

## Units

- U1 is complete because the first principles ladder v02 records the decision, the load bearing claims, the tests, the counter cases, and the rebuild.
- U2 is complete because amendment draft v03 lists the exact lines to change.
- U3 is complete because the independent check found the citation errors, the fix cycle corrected them in new files, and the re-check passed.
- U4 is complete because this final report and the verdict file are the judge output in fresh context.

## Kit

- Research brief kit, reused, workspace/handover-v1/kits/research-brief/.

## Gaps

- No predicate gap remains.
- Approval is a carried next step and not a predicate gap, with owner Richardson with the Phase 1 lead.
- The scoped instances question is unchanged by this amendment, with owner the Phase 1 lead.

## Cost and envelope

- Hard cap is $2, run is $1.70, and held back amount is $0.30.
- Fix attempts allowed are at most 3 shared, and 1 was used.
- The model tool reported no cost, so no additional dollar figure is stated.

## Next step

- Richardson with the Phase 1 lead approves the lock and applies draft v03 items 1 to 6.
- The Phase 1 lead decides the scoped instances question separately.
