# Verdict planning docs v03

## Result

- Verdict: DONE
- Predicate: pred-mathlib-geometry-phase1-planning-v03
- Run: stage2-mathlib-geometry-planning-docs-01
- Date: 27 Nov 2026
- Judge: fresh judge

- DONE means the predicate passes.
- Fixed means the work is complete.
- Queued means the work waits for a later step.
- Carried means the docs record an owned open decision.
- Answered means the docs correct the point.

- DONE closes only this narrow planning predicate.
- DONE does not close build work.
- DONE does not close the carried gaps below.

- The compiled indefinite Levi-Civita example stays open.
- The migration build stays open.
- The portability audit stays open.
- The bridge components stay open.
- The Step 0 import check stays queued.
- The scoped instances decision stays queued.

## Evidence

### Check 1: all six amendment items pass

- Item 1 passes.
- The LeviCivita export now limits existence to the Riemannian case.
- The indefinite case is a Phase 1 build obligation.
- ARCHITECTURE line 53 cites existence 359 and uniqueness 255-258.
- ARCHITECTURE line 53 cites gating 126, 156, and 172.
- The removed phrase returns zero hits by grep.

- Item 2 passes.
- The pos split now states the correct mechanism.
- A null vector fails pos at the vector itself.
- A negative vector violates both pos and isVonNBounded.
- InteropExample line 39 cites pos at line 249.
- InteropExample line 39 cites isVonNBounded at line 250.
- InteropExample line 39 adds the whole line argument.
- The (0, n) case now carries n > 0.

- Item 3 passes.
- The sole source guarantee is withdrawn in both docs.
- Every sole source hit is a negation.
- The registration cite now reads 264 and 264-268.
- The priority cites now read 431 and 453.
- The diamond risk is an owned open decision.

- Item 4 passes.
- SobolevRoutes lines 37-38 read besselPotential at line 72.
- SobolevRoutes lines 37-38 read MemSobolev at line 152.
- The old numbers 73 and 153 return zero live hits.

- Item 5 passes.
- The stale signature item is gone from ARCHITECTURE.
- The lock record now reads (p, q) equals pluses and minuses.
- The lock record now reads Lorentzian (3, 1).
- The lock record now reads Riemannian (n, 0).

- Item 6 passes.
- ARCHITECTURE line 160 records the Step 0 gate honestly.
- The line states no Lean import check has run.
- The line states the inventory rests on source reads.
- The line names the partial olean cache failure.
- The line names the Phase 1 lead as owner.

### Check 2: fresh re-check confirms each amended claim

- Check log v03 passes all twelve points.
- Check log v02 passes the cite fix.
- Check log v01 first found the cite error.
- The v03 checker re-opened every live source.
- My spot checks below confirm the same lines.

### My spot checks

- I read the live sources myself by direct read.
- I did not copy the check logs for these reads.
- Baseline pin is fc4f59e577feb1a4956671bc04ac18aaaf8cd842.
- Baseline tag is v4.36.0.

```
cd ~/workspace/handover-mathlib-geometry-2026-11-26
M=lean-phase1/.lake/packages/mathlib
git -C $M rev-parse HEAD
git -C $M describe --tags
sed -n '249,250p;264,268p' $M/Mathlib/Geometry/Manifold/VectorBundle/Riemannian.lean
sed -n '126p;156p;172p;255,258p;359p' $M/Mathlib/Geometry/Manifold/VectorBundle/CovariantDerivative/LeviCivita.lean
sed -n '72p;152p' $M/Mathlib/Analysis/Distribution/Sobolev.lean
sed -n '431p;443p;453p;458p' $M/Mathlib/Topology/VectorBundle/Riemannian.lean
grep -rn "Christoffel" $M/Mathlib/Geometry/Manifold/VectorBundle/CovariantDerivative/
```

- Source 1: Riemannian file lines 249, 250, and 264-268.
- Line 249 reads pos with 0 < inner b v v.
- Line 250 reads isVonNBounded with inner b v v < 1.
- Lines 264-268 hold the registration instance.
- Result: the pos split and the registration cite match.

- Source 2: LeviCivita file lines 126, 156, 172, 255-258, and 359.
- Lines 126 and 156 read RiemannianBundle for tangent spaces.
- Line 172 reads IsContMDiffRiemannianBundle.
- Lines 255-258 read the uniqueness theorem.
- Line 359 reads def leviCivitaConnection.
- Result: the Riemannian gate and the narrowing match.

- Source 3: Sobolev file lines 72 and 152.
- Line 72 reads def besselPotential.
- Line 152 reads def MemSobolev.
- Result: the Sobolev numbers match.

- Source 4: Topology file lines 431, 443, 453, and 458.
- Lines 431 and 453 read scoped instance priority 80.
- Line 443 reads NormedAddCommGroup.
- Line 458 reads InnerProductSpace.
- Result: the priority cites match.

- Extra check: upstream Christoffel grep returns zero hits.
- Result: upstream supplies no Christoffel symbols.

### Check 3: Neon planning review record is complete

- Model is google/gemini-4-neon.
- Max tokens is 16000.
- Outcome is recorded as reply received.
- Outcome size is 4,530 bytes.
- Outcome attempt is first attempt with exit 0.
- Prompt file is prompt-neon-review-planning-docs.md.
- Prompt file is saved in the run folder.
- Reply file is neon-review-planning-docs.md.
- Record file is handover/neon-review-phase1-planning-record.md.
- Review 1 stays marked unavailable, not invented.

### Check 4: this ruling itself

- I am a fresh judge.
- I did not write the planning docs.
- I did not check the planning docs before.
- I did not fix the planning docs.
- I read the predicate, the artifacts, and the evidence only.
- I did not read the generator log.
- I did not read the execution record.
- I rule DONE on this predicate only.

### Hostile review: Astra

- Astra point 1: Answered in docs.
- Docs add the whole line argument for isVonNBounded.
- Docs cite isVonNBounded at line 250.
- Docs qualify the (0, n) case with n > 0.
- Docs drop the phrase violates pos first.

- Astra point 2: Carried, not done.
- Docs record the diamond as an owned open decision.
- Owner is the Phase 1 lead.
- The decision point is named in both docs.
- The fix log adds threshold and sign-off as next step.

- Astra point 3: Answered in docs.
- The trap cite 257 is gone from both docs.
- The correct cite 264 and 264-268 stands.
- InteropExample line 8 is a dated baseline note.
- The note states v4.36.0 notes supersede v4.23.0 cites.

- Astra point 4: Answered in docs.
- Docs state indefinite uniqueness is a separate obligation.
- Docs state Hilbert6 existence alone does not supply uniqueness.
- Docs name Koszul generalisation or the Hilbert6 port as route.

### Hostile review: Neon

- Neon point 1: Answered in docs, with route carried.
- ARCHITECTURE line 54 names Curvature and RicciEinstein as blocked.
- ARCHITECTURE line 119 limits check to the Riemannian case.
- ARCHITECTURE line 119 states the prior build step for indefinite case.
- Docs soften Christoffel to defined in this module.
- Upstream grep returns zero Christoffel hits.
- The route choice itself stays a carried build obligation.

- Neon point 2: Answered in docs.
- InteropExample line 130 replaces the freeze note.
- The line states the lock and the RFC cites.
- The line states the old note is withdrawn.

- Neon point 3: Carried, with one limb answered.
- The Step 0 gate stays a carried gap.
- The gate has no enforcement in the docs.
- Owner is the Phase 1 lead.
- The LocalFrame limb is answered by evidence.
- LocalFrame wording is a file existence claim.
- The file exists in the local tree.

- Neon point 4: Answered in part, carried in part.
- The cites 431 and 453 are answered by evidence.
- My spot check confirms both priority instances.
- The decision rule stays a carried gap.
- Owner is the Phase 1 lead.
- The decision point is named in both docs.

- No hostile point stays open without owner and next step.

### Readability breaks in evidence

- These breaks do not change the substance verdict.
- check-log-planning-docs.md line 53 has 87 words.
- That line breaks the 20 word sentence limit.
- check-log-planning-docs-v03.md line 52 has 129 words.
- That line breaks the 20 word sentence limit.
- astra-review-planning-docs.md line 14 has 139 words.
- That line breaks the 20 word sentence limit.
- neon-review-planning-docs.md line 24 has 66 words.
- That line breaks the 20 word sentence limit.

## Units

- Generator amended the docs.
- Checker re-checked the live sources.
- Astra reviewed the math claims.
- Neon reviewed the architecture.
- Judge ruled fresh on this predicate.

## Kit

- Kit is Case B Lean verification kit, draft.
- Kit path is the run folder above.
- Kit design passed three real task proofs already.
- Kit remains draft, not a proven field tool.
- No separate kit budget line exists.

## Gaps

- LeviCivita narrowing: owner generator, next step none, Fixed.
- Pos split correction: owner generator, next step none, Fixed.
- Sole source withdrawal: owner generator, next step none, Fixed.
- Sobolev line numbers: owner generator, next step none, Fixed.
- Stale signature item removal: owner generator, next step none, Fixed.
- Step 0 gate recording: owner generator, next step none, Fixed.
- Step 0 import check run: owner Phase 1 lead, next step run the check with a full cache, Queued.
- Scoped instances decision rule: owner Phase 1 lead, next step decide before any file registers instances, Queued.
- Indefinite Levi-Civita compiled example: owner Phase 1 build, next step build the connection from the metric, Queued.
- Route choice Koszul or Hilbert6 port: owner Phase 1 lead, next step choose the route and record it, Queued.
- Migration build: owner Phase 1 lead, next step run a time-boxed migration build, Queued.
- Hilbert6 portability audit: owner Phase 1 lead, next step audit the file body against v4.36.0, Queued.
- Sobolev bridge components: owner Phase 3 lead, next step name norm comparison, map, and extension operator, Queued.

## Cost and envelope

- Cap is $2 hard cap.
- Run budget is $1.70.
- Held back is $0.30.
- Judge made 0 model calls.
- Judge invents no dollar figure for this ruling.
- Fix attempts used are 2 of 3.
- Fix attempts left are 1.
- No predicate change was made in this run.
- No cost change was made in this run.
- No scope change was made in this run.

## Next step

- Next step: Phase 1 lead runs the Step 0 import check.
- That check uses a full olean cache.
- That check runs before any Phase 1 file uses the imports.
