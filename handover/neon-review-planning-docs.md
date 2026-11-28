# Gemini 4 Neon hostile review, amended architecture

- Date: 27 Nov 2026.
- Run: stage2-mathlib-geometry-planning-docs-01.
- Model: google/gemini-4-neon.
- Max tokens: 16000.
- Role: architect reviewing architecture consistency.
- Prompt file: prompt-neon-review-planning-docs.md.
- Call: ~/workspace/custom-connectors/custom.openrouter-chat/bin/or_chat.py, first attempt, exit 0.
- Outcome: reply received, 4,530 bytes, recorded verbatim below.

## Verbatim reply

**1. Strongest flaw: The `LeviCivita` narrowing breaks structural consistency across the architecture and smuggles in unverified claims.**

Downgrading indefinite `(p, q)` Levi-Civita from an upstream export to a "Phase 1 obligation" turns a thin re-export into an unspecified foundational build, while leaving the rest of the architecture un-amended:
- **Downstream and dependency-graph mismatch:** The amendment never reconciles downstream consumers (`Curvature`, `RicciEinstein`, or any module importing `LeviCivita`) or the dependency graph. Either downstream modules still assume an indefinite `(p, q)` connection exists—contradicting the narrowed export in practice—or they are silently blocked on an unscheduled construction. Updating the `Forbids` line to ban only *claiming upstream* indefinite existence leaves downstream assumptions untouched.
- **Broken Build Order:** Step 4 asks `#check` to confirm both the upstream Riemannian `(n, 0)` connection and "the Phase 1-built connection with its named route." A `#check` step cannot conjure a construction that has no preceding build step, module dependency slot, or proof-obligation spec.
- **Unrecorded Open Decision disguised as a spec:** Naming two mutually exclusive routes ("generalised Koszul construction, or Hilbert6 port, `ddbe9da :371`") is an unresolved design branch, not a specification. Moreover, `ddbe9da :371` is an unverified external commit cite absent from the pinned v4.36.0 audit.
- **Unverifiable/overstated upstream claim:** Both the module list and Build Order step 4 assert "local Christoffel symbols supplied upstream" and "agreement with upstream" for the Christoffel formula. The independent checker verified only `def leviCivitaConnection` (`:359`), uniqueness (`:255-258`), and the `RiemannianBundle` gates (`:126`, `:156`, `:172`)—not upstream Christoffel symbols. Until verified, that claim is unsupported.

**2. Direct doc-set contradiction: The signature lock is still a hard blocker elsewhere.**

Deleting the `(p, q)` item from `ARCHITECTURE.md`'s Open Decisions did not make the doc set consistent. `ARCHITECTURE.md` claims the signature locked on 26 Nov 2026, yet after the 27 Nov amendment pass, `docs/InteropExample.md`'s Generator verification block still declares an unresolved signature-ordering inconsistency that "must be resolved before any file is written." The docs simultaneously declare the decision closed and impose a total write freeze on it.

**3. The "Step 0 gate" is unenforceable prose with an internal contradiction.**

Recording a gate inside *generator notes* gates nothing. There is no Step 0 in the Build Order, no prerequisite blocking Step 1, no CI/merge check, and no required verification artifact. Naming "Phase 1 lead" as owner stops zero Phase 1 files from compiling against unverified imports before a full olean cache exists.

Worse, the note contradicts itself: it concedes that "no Lean import check of the documented imports against pinned v4.36.0 has run" and that the inventory rests on grep/API/source reads, then immediately claims "The `LocalFrame` import is recorded as verified to exist on v4.36.0." Without a Lean import check—and with `LocalFrame` absent from the independent checker's verified list—calling the *import* verified is overstated and contradicts the preceding sentence.

**4. The scoped-instances "open decision" is self-contradictory, gives the builder no rule, and relies on unverified citations.**

- **Spec vs. Open Decision conflict:** Keeping the scoped-instance design inside `docs/InteropExample.md` (and any architecture exports referencing it) while labeling it an "open design decision" puts the docs at war with themselves: the architecture still presents an interface whose existence is undecided.
- **No decision rule:** Saying "drop the scoped instances, or record exactly why each is needed, before any Phase 1 file registers instances" is not a rule. It defines no acceptance threshold for when "needed" outweighs a typeclass diamond or priority-80 shadowing hazard, no reviewer sign-off, and no replacement API if dropped. A builder can rationalize keeping every instance simply by writing a sentence.
- **Unverified mechanism cite:** The note cites `Topology/VectorBundle/Riemannian.lean:431` and `:453`. Neither that path nor those line numbers appear in the independent checker's verified v4.36.0 list (which verified only `Mathlib/Geometry/Manifold/VectorBundle/Riemannian.lean:249` and `:264-268`). That citation is unverified and suspect.
