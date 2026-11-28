# Hostile review: Einstein.lean architecture

- Model: google/gemini-4-neon, through ~/workspace/custom-connectors/custom.openrouter-chat/bin/or_chat.py, --max-tokens 16000.
- Date: 28 Nov 2026, 00:43 EST.
- Prompt: ~/workspace/handover-mathlib-geometry-2026-11-26/prompt-neon-review-phase2-einstein.md, plus the full source of track-einstein/lean-phase1/PseudoRiemannian/Einstein.lean and the LeviCivita definitions appendix.
- Role: Neon reviews the architecture. The prompt is neutral. It does not ask the model to say why the work is trivial.
- Result, verbatim:

### 1. Strongest Architectural Flaw: Unbundled, Global API with a Constant Inverse Metric
The decision that will force the most rework is defining `einsteinComponents` and `vacuumEinsteinTensor` over three disconnected functions—`Γ`, `g`, and a **constant** `ginv : Fin n → Fin n → ℝ`—while quantifying `vacuumEinsteinRicci` and `vacuumEinsteinTensor` globally over `∀ x : Fin n → ℝ` with no chart domain `U`.

This fails inside the file itself. Because `ginv` cannot vary with `x` and no chart predicate exists, **Schwarzschild cannot instantiate `vacuumEinsteinRicci`, `vacuumEinsteinTensor`, `ricci_zero_implies_einstein_zero`, or `einstein_zero_implies_ricci_zero`**. `schwarzschild_einstein_eq_zero` must evaluate `schInvMetric M y` pointwise and duplicate the proof of `ricci_zero_implies_einstein_zero`; no `schwarzschild_vacuum_iff` exists. Every curved metric (Schwarzschild, Kerr) has coordinate-dependent `g⁻¹` and proper chart domains, and `∇^j G_{jl} = 0` requires differentiating `g^{jk}(x)` alongside `G_{jl}(x)`. Downstream work built on these signatures will require a full rewrite once `ginv` becomes a field, charts are explicit, and `(g, ginv, Γ)` are bundled.

### 2. Missing Abstractions Required by Downstream Work
The file omits every reusable abstraction needed for Kerr and divergence-free:
- **No metric/inverse pair**: `g` and `ginv` carry no proof of `g⁻¹ g = I` or symmetry. Worse, `schInvMetric` is *never proved to invert `schMetric`* anywhere in the file; `schKoszulGamma` is wired to an unverified matrix.
- **No reusable Koszul construction**: `schKoszulGamma` hardcodes `schMetric`, `schInvMetric`, and `Fin 4`. There is no general `koszulChristoffel` operator, nor general proofs of torsion-freeness or metric compatibility (`∇ g = 0`), both required for Bianchi identities.
- **No field-valued connection or covariant derivative**: There is no `∇` on tensor fields and no way to even state `div G = 0`.

### 3. Definition and Proof Choices That Collapse on Kerr
- **Factored-metric and hand-tabulated calculus**: Schwarzschild is rewritten into factored form (`(2M - r)/r`), differentiated via 14 bespoke `hasDerivAt_*` lemmas, matched against a hand-typed 64-entry `schGammaExplicit` and 256-entry `schGammaExplicit_fderiv`, and closed by `fin_cases` + `field_simp` with fragile normal-form hacks (`h2Ma`, `h2Mb`, `h2Mc`, `hasDerivAt_sincos`). This relies on Schwarzschild's diagonality and separability (`fderiv_prod_coord`). Kerr in Boyer–Lindquist coordinates is non-diagonal (`g_{tφ} ≠ 0`), non-separable (`Σ = r² + a² cos²θ` couples `r` and `θ`), and has far more nonzero Christoffel symbols; repeating this manual table-and-`fin_cases` pattern will blow up in boilerplate and tactic timeouts.
- **Ad-hoc trace hypothesis and hardcoded dimension**: `einstein_zero_implies_ricci_zero` hardcodes `n = 4` (while `ricci_zero_implies_einstein_zero` is polymorphic in `n` and `G = 0 ↔ Ric = 0` holds for any `n ≠ 2`) and requires `htrace : ∀ x, ∑ j, ∑ l, ginv j l * g x j l = 4` as a raw hypothesis instead of deriving `tr(g⁻¹ g) = n` once from a metric/inverse pair.

### 4. Component-Level Module Structure and Index-Bookkeeping Tax
Exposing bare `Fin n → Fin n → ℝ` components forces every downstream user to repeat `Fin.sum_univ_four` contractions, `fin_cases` explosions, `fderiv ... (Pi.single k 1)` projections, and manual `=ᶠ[nhds y]` chart-neighborhood gluing (`schKoszul_fderiv_eq`). Structurally, one file conflates four layers—Einstein API, Minkowski tests, `Fin 4`-hardcoded calculus helpers (`fderiv_of_coord`, `hasDerivAt_cot`), and the Schwarzschild computation—plus 25 stray `#print axioms` commands.

### 5. Misleading Header Scope
Although the header disclaims Bianchi, manifolds, and Kerr, it still misleads readers:
- It advertises `einstein_zero_implies_ricci_zero` as proving `G = 0 → Ric = 0` in 4D without revealing that its constant-`ginv`, global-`∀ x` signature excludes every curved chart metric, including Schwarzschild.
- It pairs `schwarzschild_ricci_eq_zero` / `schwarzschild_einstein_eq_zero` with `vacuumEinsteinRicci` / `vacuumEinsteinTensor`, implying Schwarzschild satisfies those definitions when it bypasses them entirely.
- It claims Schwarzschild's symbols are "derived from the metric by the Koszul formula" while omitting that `schInvMetric` is never proved to invert `schMetric`.
- Internal planning notes ("U4", "Astra's strategy", "forms in the brief") leak into library comments.
