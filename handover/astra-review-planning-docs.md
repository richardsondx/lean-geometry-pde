# GPT-6.2 Astra hostile review, amended planning docs

- Date: 27 Nov 2026.
- Run: stage2-mathlib-geometry-planning-docs-01.
- Model: openai/gpt-6.2-astra.
- Max tokens: 8000.
- Role: mathematician reviewing the amended math claims.
- Prompt file: prompt-astra-review-planning-docs.md.
- Call: ~/workspace/custom-connectors/custom.openrouter-chat/bin/or_chat.py, first attempt, exit 0.
- Outcome: reply received, 2,671 bytes, recorded verbatim below.

## Verbatim reply

1. **“A negative vector violates both” conflates a pointwise counterexample with a set-boundedness argument.** If \(g(v,v)<0\), then \(v\ne0\) and `pos` fails at \(v\). If \(v\ne0\) and \(g(v,v)=0\), `pos` likewise fails at \(v\). Neither calculation alone refutes `isVonNBounded`: a bounded set can contain \(v\). For a sublevel set such as \(\{w:g(w,w)<1\}\) in an ordinary finite-dimensional real fiber, the missing argument is that it contains the **entire line** \(\mathbb Rv\), since \(g(tv,tv)=t^2g(v,v)\le0\). That line is unbounded. On that definition, **both negative and nonzero null directions witness failure of both fields**, by different arguments; “first” has no mathematical significance. The checker excerpt quotes `pos`, not the defining set for `isVonNBounded`, so the exact Lean boundedness claim needs its own citation. For \((0,n)\) with \(n>0\), every nonzero vector violates `pos` and none is null. If \(n=0\) is allowed, `pos` is vacuous, not false.

2. **The diamond is disclosed, not resolved.** “One registration path” makes no exclusivity claim. There *is* a procedural rule—decide before registering instances—but “record exactly why each is needed” is not a coherence criterion. Necessity does not show that overlapping paths yield definitionally equal fiber structures. Conversely, priority 80 and scoped availability alone do not prove an actual conflict. No builder can infer coherence from the cited registrations.

3. **The citation baseline is still ambiguous.** Lines 72 and 152 are supported for Sobolev **at the pinned v4.36.0 commit**. A v4.23.0 header does not falsify those citations, but it cannot authenticate v4.36.0 line references in `InteropExample.md`; references there need local version labels or a corrected baseline. There is also a specific non-Sobolev trap: in v4.36.0, lines 257–260 identify the conversion, not the registration at 264–268. Any surviving citation to 257–260 *for the instance* is wrong. The supplied excerpts do not establish whether one survives or support a document-wide clean bill of health.

4. **The narrowed Levi-Civita claim does not promise an indefinite export.** The cited upstream construction and uniqueness result concern the Riemannian setting under their typeclass and regularity hypotheses. Naming Koszul generalisation or a Hilbert6 port as a route does not imply proximity to completion. In particular, the cited Hilbert6 *existence* declaration alone establishes neither compatibility with the intended interfaces nor an indefinite *uniqueness* result. If Phase 1 owes both, uniqueness remains an explicit proof obligation unless separately sourced.
