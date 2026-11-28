# Hostile math review, Sobolev first slice

- Run: stage2-mathlib-geometry-phase3-sobolev-slice-01, unit U6.
- Reviewer: GPT-6.2 Astra (mathematician).
- Model id: openai/gpt-6.2-astra.
- Max-tokens: 12000.
- Timestamp: 2026-11-28 00:54 EST (2026-11-28T05:54Z).
- Prompt: prompt-astra-review-phase3-sobolev-slice.md.
- The reply below is verbatim, unedited.

---

1. **`sobolevBridge` does not state the advertised bridge.** It quantifies only over `x : sobolevSpace n`, so there is no \(H^1\Rightarrow W^{1,2}\) implication. Worse, `h` does not occur in the `MemSobolev` conjunct. Its only constraint is its norm: scale any fixed unit \(L^2\) vector to the displayed radius and it qualifies. Thus even a proof of this `Prop` would establish only forward membership, not the claimed witness norm. State an iff for each real \(L^2\) class \(u\): its complex embedding is in \(H^1\) iff it is the first coordinate of a unique graph element. Tie the norm identity to an \(h\) whose tempered distribution **equals** the order-one Bessel operator applied to \(u\). `sobolevComplex` embeds real functions; it does not cover arbitrary complex \(H^1\).

2. **The coefficient is correct for the stated symbols, not verified by the statement.** With \(b_1(\xi)=\sqrt{1+|\xi|^2}\) and \(q_i(\xi)=2\pi i\xi_i\), one has \(b_1^2=1+(2\pi)^{-2}\sum_i|q_i|^2\). Plancherel then gives exactly the proposed squared norm for the *actual* witness. The file does not identify those Mathlib multipliers in common coordinates. A wrong positive factor would preserve norm equivalence but falsify the exact witness identity for nonzero gradient; the disconnected `h` would not detect it.

3. **The weighted acceptance test is false as written.** Appendix A calls the *sum of integrals of squares* the norm. For a nonzero compactly supported smooth bump scaled by \(t>0\), the weighted supremum scales as \(t\), that sum as \(t^2\). No uniform \(C\) works as \(t\downarrow0\). Take the square root or square the left side. Even corrected, the slice supplies neither weighted second derivatives nor a continuous representative estimate. It also proves no \(L^6\) embedding, wave energy conservation, trace, Poincaré inequality, or bounded-domain construction.

4. **The graph norm is standard, but the four norm axioms add no Sobolev argument.** `sobolev_norm_eq` splits the ambient `PiLp.norm_eq_of_L2` sum at coordinate zero; the four corollaries invoke generic norm laws. The identification works because the remaining coordinates are weak derivatives in an orthonormal frame. Other orthonormal frames preserve the sum mathematically; an uncorrected oblique frame or a different product exponent generally gives only an equivalent norm, not the displayed Euclidean norm.

5. **`HasWeakDeriv` is narrower in scope, not in its integrability requirement.** `iff_integral` tests \(\int v\phi=-\int u\,\partial_m\phi\) against every real \(C_c^\infty\) test, precisely Evans’s first derivative identity in a coordinate direction. Both \(L^1_{\rm loc}\) conjuncts are appropriate and exclude `ofFun`’s fallback; neither imposes global \(L^2\). The restriction is to real scalars, constant directions and the whole space, not arbitrary open domains. `unique` uses injectivity of regular distributions **modulo a.e. equality**, with both local integrability hypotheses supplied. `congr_ae` handles changes of representative. No pointwise uniqueness is asserted or needed.

6. **Completeness is genuinely proved, but only for this graph.** For each fixed test, both \(\phi\) and \(\partial_i\phi\) are smooth compactly supported \(L^2\) functions, so the two pairings are continuous. `iff_integral` identifies the graph with the intersection of their summed functionals’ kernels; no test-density assumption is needed. Closedness gives completeness, and the inherited inner product is the usual function pairing plus the derivative pairings. This argument identifies neither the graph with the Fourier-defined space nor any downstream PDE estimate.
