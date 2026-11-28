# Hostile architecture review, Sobolev first slice

- Run: stage2-mathlib-geometry-phase3-sobolev-slice-01, unit U6.
- Reviewer: Gemini 4 Neon (architect).
- Model id: google/gemini-4-neon.
- Max-tokens: 16000.
- Timestamp: 2026-11-28 00:56 EST (2026-11-28T05:56Z).
- Prompt: prompt-neon-review-phase3-sobolev-slice.md.
- The reply below is verbatim, unedited.

---

### 1. Strongest Architectural Flaw: Monolithic, Non-Parameterized Core Definitions

The most costly design decision is defining `sobolevSpace n` as `Submodule ℝ (PiLp 2 (fun _ : Fin (n + 1) => Lp ℝ 2 volume))` over a pointwise, whole-space `HasWeakDeriv`. This fuses five choices—order `s = 1`, exponent `p = 2`, real scalars `ℝ`, domain `Ω = ⊤`, and unit weight `volume`—into one rigid carrier:

- **Blocks higher order and weights:** Packing the function at index `0` and first derivatives at `i.succ` via `Fin (n + 1)` cannot represent `s = 2`, multi-indices `|α| ≤ 2`, or order-dependent weights `⟨x⟩^{-2δ + 2|α| - 3}`. Acceptance Test 3 (weighted `H^2` decay) requires throwing `sobolevSpace` away.
- **Blocks bounded domains and `p ≠ 2`:** `Distribution.ofFun` already accepts an open set `Ω`, yet `HasWeakDeriv` hardcodes `⊤`. Meanwhile `weakFunctional` builds a separate Hilbert pairing functional per direction and test function using `L2.inner_def`, `Continuous.inner`, and `HasCompactSupport.toSchwartzMap`, which breaks on bounded `Ω` or `p ≠ 2`. Bounded domains, trace, Poincaré, and `W^{k,p}` require rewriting `HasWeakDeriv`, `sobolevSpace`, and completeness from scratch.
- **One-off, leaky API:** Pointwise `HasWeakDeriv` forces repetitive `congr_ae`/`coeFn_*` boilerplate. `sobolevSpace` provides no value/gradient projections, coercions to `L^2`, general-direction weak derivatives, or a classical-to-weak lemma (`ContDiff` → `HasWeakDeriv`), exposing raw `(x : PiLp 2 (...)).ofLp 0` terms everywhere.

### 2. Defective Bridge Specification and Missing Downstream Interfaces

`sobolevBridge` does not unblock the next run; its Lean statement is mathematically broken:

1. **Vacuous norm claim:** `∃ h : Lp ℂ 2 ..., MemSobolev 1 2 (...) ∧ ‖h‖ = Real.sqrt (...)` never links `h` to `besselPotential` (whose witness is hidden inside `MemSobolev`). Any `h ∈ Lp ℂ 2` of that norm trivially satisfies the norm conjunct.
2. **One-directional:** The acceptance document requires `H^1 = W^{1,2}` as sets of `L^2` classes (and step 5 of the doc comment describes recovering `u` and `D`), yet `sobolevBridge` only states `W^{1,2} → H^1`.
3. **No interfaces:** The six listed bridge steps (Fourier symbols, `Lp.toTemperedDistributionCLM` vs. `Distribution.ofFun`, tempered derivatives, Plancherel, bounded multipliers) are prose with no Lean types or lemmas. Absent `C^1_c`-density and classical-derivative lemmas likewise leave Test 1 (applying Mathlib's Gagliardo-Nirenberg-Sobolev inequality), Test 2 (smooth wave solutions), and trace completely unblocked only on paper.

### 3. Corner-Locking Parameter Choices vs. Honest Restrictions

- **Must be undone:** Hardcoding `s = 1` and unit weight directly conflicts with Test 3. Hardcoding `ℝ` clashes with `ℂ`-valued `TemperedDistribution.MemSobolev`, forcing `sobolevComplex` (already needing `maxHeartbeats 400000`) and preventing a clean reverse bridge from complex `H^1`. Hardcoding `p = 2` via `PiLp 2` and Hilbert inner products blocks `W^{k,p}`.
- **Honest first-slice restrictions:** General `n` (with `n = 3` as the acceptance case) and deferring trace/Poincaré/bounded-domain theorems are defensible first-slice limits—except that hardcoding `⊤` in `HasWeakDeriv` gratuitously sabotages later bounded-domain work.

### 4. Incomplete Mathlib v4.36.0 Audit

The audit fails both as a dependency inventory and as a capability map:

- **Inconsistent usage accounting:** While flagging `besselPotential` transitively and listing trivial lemmas (`inner_add_left`, `isClosed_iInter`), it omits direct calls in `SobolevSlice.lean`: `Distribution.ofFun_apply`, `ofFun_congr_ae`, `ofFun_add`, `ofFun_smul`, `ofFun_zero`, `LineDeriv.lineDerivOp_*`, `Lp.coeFn_*`, and `MemLp.toLp`.
- **Missing capability audit:** After belatedly correcting its false claim that `BesselPotentialSpace` had no file, the audit never inspects `BesselPotentialSpace`'s bundled API (norm, completeness, inner product) as an alternative bridge target to raw `MemSobolev`. It omits Fourier/Plancherel/multiplier lemmas needed for bridge steps 1–6 and dismisses `MemSobolev.lineDerivOp` as unused without checking whether it already proves part of the bridge.

### 5. Misleading Surface Signals

- `sobolev_norm_nonneg`, `sobolev_norm_eq_zero`, `sobolev_norm_add_le`, `sobolev_norm_smul`, and `sobolevInnerProductSpace` are one-line wrappers around inherited `Submodule`/`PiLp` instances (`norm_nonneg`, `inferInstance`), yet appear in the file header and `#print axioms` list as substantive proved results.
- Exposing `sobolevBridge` as a top-level `Prop` while framing the bottleneck around bounded domains invites readers to assume the bridge contract is valid (or nearly proved) and that bounded domains, embeddings, or trace follow incrementally—when the bridge statement is defective and none of those targets fit the architecture.
