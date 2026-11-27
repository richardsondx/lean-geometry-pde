# Verdict: signature ordering lock v01

Predicate: pred-signature-ordering-lock-v01.
Date: 26 Nov 2026.

## Verdict

- Verdict is DONE on pred-signature-ordering-lock-v01.

## Evidence relied on

- Direct read confirmed RFC_Conventions.md lines 12 to 14 lock the signature as (-, +, +, +) with one timelike direction and three spacelike directions.
- Direct read confirmed RFC_Conventions.md line 16 gives the Wald reason for that sign choice.
- Direct read confirmed RFC_PseudoRiemannian.md lines 37 to 43 define (p, q) as minuses first and pair Lorentzian with (1, 3) and Riemannian with (n, 0).
- Direct read confirmed ARCHITECTURE.md line 14 defines (p, q) as pluses first with Lorentzian (3, 1) and Riemannian (n, 0).
- Counting diag(-1, 1, 1, 1) gives three plus entries and one minus entry.
- Counting under the RFC rule makes (n, 0) negative definite.
- Counting under the proposed rule makes (n, 0) positive definite.
- Amendment draft v03 lists 6 exact lines to change and 70 lines needing no change.
- The first check log verdict was FAIL on the C8 citation and draft items 16 to 19 only.
- The fix cycle corrected those citations in new files v03 and ladder v02 without editing any checked file in place.
- The re-check verdict is PASS on direct re-read with exact substring checks.
- The Astra claim 3 disagreement is adjudicated in the fix log and in the draft v03 note.
- Both RFCs still contain the pre-lock (1, 3) lines, so no RFC was amended in this run.
- Fix attempts allowed are at most 3 shared, and 1 was used.
- Hard cap is $2, run is $1.70, and held back amount is $0.30.
- The model tool reported no cost, so no additional dollar figure is stated.

## Gaps

- No predicate gap remains.
- Approval is a carried next step and not a predicate gap, with owner Richardson with the Phase 1 lead.
- The scoped instances question is unchanged by this amendment, with owner the Phase 1 lead.

## Next step

- Richardson with the Phase 1 lead approves the lock and applies draft v03 items 1 to 6.
- The Phase 1 lead decides the scoped instances question separately.
