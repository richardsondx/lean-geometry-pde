# Fix log: signature ordering lock, cycle 1

- Predicate: pred-signature-ordering-lock-v01.
- Date: 26 Nov 2026.
- Fix attempt: 1 of 3 shared for the whole run.
- Status: complete.
- Source check log: check-log-signature-lock.md.
- Verdict in source check log: FAIL, on items 16 to 19 and C8 only.

## Files written

- docs/SignatureOrdering-Amendment-Draft-v03.md
- first-principles-ladder-signature-v02.md
- fix-log-signature-lock-cycle1.md

## Files not edited

- No checked file was edited in place.
- docs/SignatureOrdering-Amendment-Draft-v02.md was not edited.
- first-principles-ladder-signature.md was not edited.
- docs/RFC_Conventions.md was not edited.
- docs/RFC_PseudoRiemannian.md was not edited.
- The 6 lines needing change were not changed.
- The locked rule was not changed.
- The verdict was not changed.

## Verification done

- Re-read docs/RFC_Conventions.md with nl.
- Line 11 is blank.
- Line 12 is "Signature is (-, +, +, +). One timelike direction, three spacelike".
- Line 13 is "directions. A tangent vector v is timelike when g(v, v) < 0,".
- Line 14 is "null when g(v, v) = 0, spacelike when g(v, v) > 0.".
- Line 15 is blank.
- Line 16 is "Why: it is the convention of Wald's General Relativity, of the".
- Each corrected quote in v03 items 16 to 19 was checked as an exact substring of its corrected RFC line.
- Em dash count is 0 in v03 and ladder v02.
- No Lean code was added.

## Gaps fixed

- GAP-QUOTES-11-14: v03 corrects items 16, 17, 18, and 19 to lines 12, 13, 14, and 16, with the same quotes, and states the correct range is lines 12 to 14 for the signature text, plus line 16 for the Why sentence.
- GAP-LADDER-C8: ladder v02 corrects all 3 C8 citations from lines 11 to 14 to lines 12 to 14, copies the rest unchanged, and notes at the top that v02 changes only the C8 line numbers.
- GAP-GREP-COUNT-NOTE: v03 states the grep count of 46 excludes the v02 draft itself, and a raw whole-folder re-run returns 94 because v02 adds 48 self-quotation hits.
- GAP-ASTRA-CLAIM3: adjudication is recorded in one sentence in this log and in one sentence as a note in v03, and the lock was not changed.

## Astra claim 3 adjudication

- Adjudication on Astra claim 3: Astra marked architecture claim 3 false because the current pre-lock RFC (1, 3) already matches minuses first, but claim 3 is about flipping after the lock, when the RFC lines will read (3, 1), so flipping then would require editing those locked (3, 1) lines and the architecture exports while the (-, +, +, +) sign pattern needs no change, and Astra's verbatim reply is preserved in check-log-signature-lock.md.

## Verifier result expected on re-check

- Items 16 to 19 in v03 verify at lines 12, 13, 14, and 16.
- The v02 claim that lines 11 to 14 are correct is corrected in v03.
- All 3 C8 citations in ladder v02 verify at lines 12 to 14.
- The grep count note is present in v03.
- The Astra claim 3 note is present in v03.
- The 6 lines needing change, the locked rule, and the verdict are unchanged.

## Note on a quoted record

- Item 63 in v03 still quotes the verdict file line that says Lines 11-14, because that text is a verbatim quote of that file, not a v03 claim.

## Gaps carried

- GAP-APPROVAL: owner is Richardson with the Phase 1 lead, next step is to approve the lock and apply draft items 1 to 6.
