/-
Copyright (c) 2026 Richardson Dackam. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.

# Einstein tensor and vacuum Einstein equations

What is proved here, using the project's own coordinate-component definitions
`ricciComponents` and `scalarCurvature` from `PseudoRiemannian.LeviCivita`:
- `einsteinComponents`: the Einstein tensor `G_jl = Ric_jl - (1/2) R g_jl`;
- `vacuumEinsteinRicci` and `vacuumEinsteinTensor`: the vacuum Einstein
  equations in `Ric = 0` form and in `G = 0` form;
- `ricci_zero_implies_einstein_zero`: `Ric = 0` implies `G = 0` in general
  (the scalar curvature is the trace of Ricci, so it vanishes too);
- `einstein_zero_implies_ricci_zero`: `G = 0` implies `Ric = 0` in 4D,
  given the trace identity `sum_j sum_l g^{jl} g_jl = 4`;
- `minkowski_trace_identity`: the trace identity for Minkowski, by fin_cases;
- `minkowski_vacuum_iff`: the two vacuum forms are equivalent for Minkowski;
- `minkowski_einstein_eq_zero`: the Minkowski Einstein tensor is zero;
- `schwarzschild_ricci_eq_zero` and `schwarzschild_einstein_eq_zero`:
  the Schwarzschild metric in coordinates `(t, r, theta, phi)` on the chart
  `M > 0`, `r > 2M`, `sin theta != 0` has `Ric = 0`, hence `G = 0`.
  The symbols are derived from the metric by the Koszul formula and proved
  equal to the standard Schwarzschild symbol table, following the pattern of
  `PseudoRiemannian.SphereTestSpherical`.

Novelty tier: Tier 2, incremental API. This is new formalisation, not a
research result.

What is NOT proved here: divergence-free of the Einstein tensor from the
Bianchi identities (Queued: it needs general Bianchi machinery that does not
exist yet), a general manifold Einstein tensor, and no Kerr content.

Lean 4.36.0, Mathlib v4.36.0. Signature lock: (p, q) = (3, 1), (-, +, +, +).
Coordinate order for Schwarzschild: (t, r, theta, phi) = indices 0, 1, 2, 3.
-/

import PseudoRiemannian.LeviCivita
import PseudoRiemannian.MinkowskiTest
import Mathlib.Analysis.SpecialFunctions.Trigonometric.Basic
import Mathlib.Analysis.SpecialFunctions.Trigonometric.Deriv
import Mathlib.Analysis.Calculus.Deriv.Comp
import Mathlib.Analysis.Calculus.FDeriv.Linear

open Module Finset
open scoped BigOperators

/-- The Einstein tensor components from Ricci and scalar curvature:
`G_jl = Ric_jl - (1/2) R g_jl`, where `g` is the component field and
`ginv` the inverse metric components. -/
noncomputable def einsteinComponents (n : ℕ)
    (Γ : (Fin n → ℝ) → ChristoffelSymbols n)
    (g : (Fin n → ℝ) → Fin n → Fin n → ℝ)
    (ginv : Fin n → Fin n → ℝ) (x : Fin n → ℝ)
    (j l : Fin n) : ℝ :=
  ricciComponents n Γ x j l
    - (1 / 2) * scalarCurvature n Γ ginv x * g x j l

/-- The vacuum Einstein equations in `Ric = 0` form: Ricci vanishes at
every point of the chart. -/
def vacuumEinsteinRicci (n : ℕ)
    (Γ : (Fin n → ℝ) → ChristoffelSymbols n) : Prop :=
  ∀ x j l, ricciComponents n Γ x j l = 0

/-- The vacuum Einstein equations in `G = 0` form: the Einstein tensor
vanishes at every point of the chart. -/
def vacuumEinsteinTensor (n : ℕ)
    (Γ : (Fin n → ℝ) → ChristoffelSymbols n)
    (g : (Fin n → ℝ) → Fin n → Fin n → ℝ)
    (ginv : Fin n → Fin n → ℝ) : Prop :=
  ∀ x j l, einsteinComponents n Γ g ginv x j l = 0

/-- `Ric = 0` implies `G = 0` in any dimension: the scalar curvature is
the trace of Ricci, so it vanishes too, and `G = Ric - (1/2) R g`. -/
theorem ricci_zero_implies_einstein_zero {n : ℕ}
    {Γ : (Fin n → ℝ) → ChristoffelSymbols n}
    {g : (Fin n → ℝ) → Fin n → Fin n → ℝ}
    {ginv : Fin n → Fin n → ℝ}
    (h : vacuumEinsteinRicci n Γ) : vacuumEinsteinTensor n Γ g ginv := by
  intro x j l
  have h' : ∀ (x : Fin n → ℝ) (j l : Fin n),
      ricciComponents n Γ x j l = 0 := h
  have hsc : scalarCurvature n Γ ginv x = 0 := by
    show ∑ j, ∑ l, ginv j l * ricciComponents n Γ x j l = 0
    simp only [h', mul_zero, Finset.sum_const_zero]
  simp only [einsteinComponents, h' x j l, hsc, mul_zero, zero_mul, sub_zero]

/-- Tracing the Einstein tensor: `sum_j sum_l g^{jl} G_jl`
is `R - (1/2) R * sum_j sum_l g^{jl} g_jl`. -/
theorem einstein_trace_sum
    {Γ : (Fin 4 → ℝ) → ChristoffelSymbols 4}
    {g : (Fin 4 → ℝ) → Fin 4 → Fin 4 → ℝ}
    {ginv : Fin 4 → Fin 4 → ℝ} (x : Fin 4 → ℝ) :
    (∑ j, ∑ l, ginv j l * einsteinComponents 4 Γ g ginv x j l)
      = scalarCurvature 4 Γ ginv x
        - (1 / 2) * scalarCurvature 4 Γ ginv x
          * (∑ j, ∑ l, ginv j l * g x j l) := by
  have hpoint : ∀ j l, ginv j l * einsteinComponents 4 Γ g ginv x j l
      = ginv j l * ricciComponents 4 Γ x j l
        - (1 / 2) * scalarCurvature 4 Γ ginv x * (ginv j l * g x j l) := by
    intro j l
    simp only [einsteinComponents]
    ring
  rw [Finset.sum_congr rfl
    (fun j _ => Finset.sum_congr rfl (fun l _ => hpoint j l))]
  simp only [Finset.sum_sub_distrib, ← Finset.mul_sum]
  rfl

/-- `G = 0` implies `Ric = 0` in 4D, given the trace identity
`sum_j sum_l g^{jl} g_jl = 4`: tracing `G` gives `0 = R - (1/2) R * 4`,
so `R = 0`, and then `Ric = G + (1/2) R g = 0`. -/
theorem einstein_zero_implies_ricci_zero
    {Γ : (Fin 4 → ℝ) → ChristoffelSymbols 4}
    {g : (Fin 4 → ℝ) → Fin 4 → Fin 4 → ℝ}
    {ginv : Fin 4 → Fin 4 → ℝ}
    (htrace : ∀ x, ∑ j, ∑ l, ginv j l * g x j l = 4)
    (h : vacuumEinsteinTensor 4 Γ g ginv) : vacuumEinsteinRicci 4 Γ := by
  intro x j l
  have h' : ∀ (x : Fin 4 → ℝ) (j l : Fin 4),
      einsteinComponents 4 Γ g ginv x j l = 0 := h
  have hR : scalarCurvature 4 Γ ginv x = 0 := by
    have htr : ∑ j, ∑ l, ginv j l * einsteinComponents 4 Γ g ginv x j l = 0 := by
      simp only [h', mul_zero, Finset.sum_const_zero]
    rw [einstein_trace_sum x, htrace x] at htr
    linear_combination -htr
  have hRic : ricciComponents 4 Γ x j l
      = einsteinComponents 4 Γ g ginv x j l
        + (1 / 2) * scalarCurvature 4 Γ ginv x * g x j l := by
    simp only [einsteinComponents]
    ring
  rw [hRic, h' x j l, hR, mul_zero, zero_mul, add_zero]

/-- The constant components of the Minkowski metric: diagonal
`(-1, 1, 1, 1)`, coordinate `0` timelike. -/
theorem minkowski_constantComponents_apply (x : Fin 4 → ℝ) (i j : Fin 4) :
    minkowskiMetric.constantComponents x i j =
      if i = j then (if (i : ℕ) = 0 then -1 else 1) else 0 := by
  fin_cases i <;> fin_cases j <;>
    simp [PseudoRiemannianMetric.constantComponents, minkowskiMetric_apply]

/-- The trace identity for Minkowski: the inverse components times the
metric components sum to `4`. -/
theorem minkowski_trace_identity (x : Fin 4 → ℝ) :
    ∑ j, ∑ l, minkowskiInverseComponents j l
      * minkowskiMetric.constantComponents x j l = 4 := by
  simp [Fin.sum_univ_four, minkowskiInverseComponents,
    minkowski_constantComponents_apply]
  norm_num

/-- For Minkowski the two vacuum forms are equivalent. -/
theorem minkowski_vacuum_iff :
    vacuumEinsteinRicci 4 (flatChristoffel 4) ↔
      vacuumEinsteinTensor 4 (flatChristoffel 4)
        minkowskiMetric.constantComponents minkowskiInverseComponents :=
  ⟨fun h => ricci_zero_implies_einstein_zero h,
   fun h => einstein_zero_implies_ricci_zero
     (fun x => minkowski_trace_identity x) h⟩

/-- The Minkowski Einstein tensor is zero: Ricci and scalar curvature
both vanish. -/
theorem minkowski_einstein_eq_zero (x : Fin 4 → ℝ) (j l : Fin 4) :
    einsteinComponents 4 (flatChristoffel 4) minkowskiMetric.constantComponents
      minkowskiInverseComponents x j l = 0 := by
  simp [einsteinComponents, minkowski_ricci_eq_zero, minkowski_scalar_eq_zero]

#print axioms ricci_zero_implies_einstein_zero
#print axioms einstein_trace_sum
#print axioms einstein_zero_implies_ricci_zero
#print axioms minkowski_constantComponents_apply
#print axioms minkowski_trace_identity
#print axioms minkowski_vacuum_iff
#print axioms minkowski_einstein_eq_zero

/- ## Schwarzschild (U4)

Coordinates `(t, r, theta, phi)` are indices `0, 1, 2, 3` on `Fin 4 → ℝ`.
The metric is written in factored form, with `r - 2M` in place of `r * f`
where `f = 1 - 2M / r`: `g_tt = (2M - r) / r = -(1 - 2M / r)`,
`g_rr = r / (r - 2M) = 1 / f`, `g_theta theta = r^2`,
`g_phi phi = r^2 sin^2 theta`. The factored form keeps every denominator
a plain `r`, `r - 2M`, or `sin theta`, which is what the `field_simp`
steps need. `schMetric_brief_form` records the equality with the forms
in the brief. Chart: `M > 0`, `r > 2M`, `sin theta ≠ 0`.
-/

/-- Partial derivative, in direction `k`, of a scalar function of one
coordinate `y c` only, from its one-variable derivative. -/
theorem fderiv_of_coord (F : ℝ → ℝ) (F' : ℝ) (y : Fin 4 → ℝ) (c k : Fin 4)
    (hF : HasDerivAt F F' (y c)) :
    fderiv ℝ (fun z => F (z c)) y (Pi.single k 1) = if k = c then F' else 0 := by
  have hP : HasFDerivAt (⇑(ContinuousLinearMap.proj c : (Fin 4 → ℝ) →L[ℝ] ℝ))
      (ContinuousLinearMap.proj c) y :=
    ContinuousLinearMap.hasFDerivAt _
  have h := hF.comp_hasFDerivAt y hP
  have hf : fderiv ℝ (fun z => F (z c)) y = F' • ContinuousLinearMap.proj c :=
    h.fderiv
  rw [hf]
  by_cases hk : k = c
  · subst hk
    simp
  · simp [hk, Ne.symm hk]

/-- Partial derivative, in direction `k`, of a product of a function of
coordinate `y a` and a function of a different coordinate `y b`. -/
theorem fderiv_prod_coord (U V : ℝ → ℝ) (U' V' : ℝ) (y : Fin 4 → ℝ)
    (a b k : Fin 4) (hab : a ≠ b)
    (hU : HasDerivAt U U' (y a)) (hV : HasDerivAt V V' (y b)) :
    fderiv ℝ (fun z => U (z a) * V (z b)) y (Pi.single k 1) =
      (if k = a then U' * V (y b) else 0)
        + (if k = b then U (y a) * V' else 0) := by
  have hPa : HasFDerivAt (⇑(ContinuousLinearMap.proj a : (Fin 4 → ℝ) →L[ℝ] ℝ))
      (ContinuousLinearMap.proj a) y :=
    ContinuousLinearMap.hasFDerivAt _
  have hPb : HasFDerivAt (⇑(ContinuousLinearMap.proj b : (Fin 4 → ℝ) →L[ℝ] ℝ))
      (ContinuousLinearMap.proj b) y :=
    ContinuousLinearMap.hasFDerivAt _
  have hUa : HasFDerivAt (fun z => U (z a)) (U' • ContinuousLinearMap.proj a) y :=
    hU.comp_hasFDerivAt y hPa
  have hVb : HasFDerivAt (fun z => V (z b)) (V' • ContinuousLinearMap.proj b) y :=
    hV.comp_hasFDerivAt y hPb
  have h := hUa.mul hVb
  have hf : fderiv ℝ (fun z => U (z a) * V (z b)) y
      = U (y a) • (V' • ContinuousLinearMap.proj b)
        + V (y b) • (U' • ContinuousLinearMap.proj a) :=
    h.fderiv
  rw [hf]
  by_cases hka : k = a <;> by_cases hkb : k = b
  · exfalso
    exact hab (hka.symm.trans hkb)
  · subst hka
    simp [hab, Ne.symm hab]
    ring
  · subst hkb
    simp [hab, Ne.symm hab]
  · simp [hka, hkb, Ne.symm hka, Ne.symm hkb]

/-- On the chart `r > 2M` with `M > 0`, `r ≠ 0`. -/
theorem sch_chart_r_ne_zero {M : ℝ} (hM : 0 < M) {r : ℝ} (hr : 2 * M < r) :
    r ≠ 0 :=
  ne_of_gt (by linarith)

/-- On the chart, `r - 2M ≠ 0`. -/
theorem sch_chart_r_sub_ne_zero {M : ℝ} (_hM : 0 < M) {r : ℝ} (hr : 2 * M < r) :
    r - 2 * M ≠ 0 :=
  ne_of_gt (by linarith)

/-- Derivative of `t^2`. -/
theorem hasDerivAt_sq (r : ℝ) :
    HasDerivAt (fun t => t ^ 2) (2 * r) r := by
  have h := (hasDerivAt_id r).fun_pow 2
  simpa [pow_one] using h

/-- Derivative of `2M - t`. -/
theorem hasDerivAt_2M_sub (M r : ℝ) :
    HasDerivAt (fun t => 2 * M - t) (-1) r := by
  simpa using (hasDerivAt_id r).const_sub (2 * M)

/-- Derivative of `sin^2 t`. -/
theorem hasDerivAt_sin_sq (r : ℝ) :
    HasDerivAt (fun t => Real.sin t ^ 2) (2 * Real.sin r * Real.cos r) r := by
  have h := (Real.hasDerivAt_sin r).fun_pow 2
  simpa [pow_one] using h

/-- Derivative of `sin t * cos t`: `cos^2 - sin^2`. Stated for the plain
product because `simp` pulls a negation out of an `fderiv`, so the
`fderiv` lemmas used as `simp` rewrites must be in that normal form. -/
theorem hasDerivAt_sincos (r : ℝ) :
    HasDerivAt (fun t => Real.sin t * Real.cos t)
      (Real.cos r ^ 2 - Real.sin r ^ 2) r := by
  have h := (Real.hasDerivAt_sin r).fun_mul (Real.hasDerivAt_cos r)
  exact h.congr_deriv (by
    show Real.cos r * Real.cos r + Real.sin r * (-Real.sin r)
      = Real.cos r ^ 2 - Real.sin r ^ 2
    ring)

/-- Derivative of `-(sin t * cos t)`: `sin^2 - cos^2`. -/
theorem hasDerivAt_neg_sincos (r : ℝ) :
    HasDerivAt (fun t => -(Real.sin t * Real.cos t))
      (Real.sin r ^ 2 - Real.cos r ^ 2) r := by
  have h := ((Real.hasDerivAt_sin r).mul (Real.hasDerivAt_cos r)).neg
  convert h using 1
  ring

/-- Derivative of `cos t / sin t`: `-1 / sin^2`, where `sin ≠ 0`. -/
theorem hasDerivAt_cot (r : ℝ) (hs : Real.sin r ≠ 0) :
    HasDerivAt (fun t => Real.cos t / Real.sin t) (-1 / Real.sin r ^ 2) r := by
  have h := (Real.hasDerivAt_cos r).div (Real.hasDerivAt_sin r) hs
  have hnum : -Real.sin r * Real.sin r - Real.cos r * Real.cos r = -1 := by
    have hsc := Real.sin_sq_add_cos_sq r
    nlinarith [hsc]
  have hval : (-Real.sin r * Real.sin r - Real.cos r * Real.cos r)
      / Real.sin r ^ 2 = -1 / Real.sin r ^ 2 := by rw [hnum]
  rw [hval] at h
  exact h

/-- Derivative of `1 / t`: `-1 / r^2`. -/
theorem hasDerivAt_one_div (r : ℝ) (hr0 : r ≠ 0) :
    HasDerivAt (fun t => 1 / t) (-1 / r ^ 2) r := by
  have h := (hasDerivAt_const r (1 : ℝ)).fun_div (hasDerivAt_id' r) hr0
  exact h.congr_deriv (by
    show (0 * r - 1 * 1) / r ^ 2 = -1 / r ^ 2
    ring)

/-- Derivative of `g_tt = (2M - t) / t`: `-2M / r^2`. -/
theorem hasDerivAt_sch_gtt (M r : ℝ) (hr0 : r ≠ 0) :
    HasDerivAt (fun t => (2 * M - t) / t) (-2 * M / r ^ 2) r := by
  have h := (hasDerivAt_2M_sub M r).fun_div (hasDerivAt_id' r) hr0
  exact h.congr_deriv (by
    show (-1 * r - (2 * M - r) * 1) / r ^ 2 = -2 * M / r ^ 2
    ring)

/-- Derivative of `g_rr = t / (t - 2M)`: `-2M / (r - 2M)^2`. -/
theorem hasDerivAt_sch_grr (M r : ℝ) (h2M : r - 2 * M ≠ 0) :
    HasDerivAt (fun t => t / (t - 2 * M)) (-2 * M / (r - 2 * M) ^ 2) r := by
  have hden : HasDerivAt (fun t => t - 2 * M) (1 : ℝ) r :=
    ((hasDerivAt_id' r).fun_sub (hasDerivAt_const r (2 * M))).congr_deriv
      (by norm_num)
  have h := (hasDerivAt_id' r).fun_div hden h2M
  exact h.congr_deriv (by
    show (1 * (r - 2 * M) - r * 1) / (r - 2 * M) ^ 2
      = -2 * M / (r - 2 * M) ^ 2
    ring)

/-- Derivative of `A = M / (t * (t - 2M))`, the `Gamma^t_{tr}` value:
`-2M (r - M) / (r^2 (r - 2M)^2)`. -/
theorem hasDerivAt_schA (M r : ℝ) (hr0 : r ≠ 0) (h2M : r - 2 * M ≠ 0) :
    HasDerivAt (fun t => M / (t * (t - 2 * M)))
      (-2 * M * (r - M) / (r ^ 2 * (r - 2 * M) ^ 2)) r := by
  have hden : HasDerivAt (fun t => t * (t - 2 * M))
      (1 * (r - 2 * M) + r * 1) r := by
    have hsub : HasDerivAt (fun t => t - 2 * M) (1 : ℝ) r :=
      ((hasDerivAt_id' r).fun_sub (hasDerivAt_const r (2 * M))).congr_deriv
        (by norm_num)
    exact (hasDerivAt_id' r).fun_mul hsub
  have hprod : r * (r - 2 * M) ≠ 0 := mul_ne_zero hr0 h2M
  have h := (hasDerivAt_const r M).fun_div hden hprod
  exact h.congr_deriv (by
    show (0 * (r * (r - 2 * M)) - M * (1 * (r - 2 * M) + r * 1))
        / (r * (r - 2 * M)) ^ 2
      = -2 * M * (r - M) / (r ^ 2 * (r - 2 * M) ^ 2)
    field_simp [hr0, h2M, hprod]
    ring)

/-- Derivative of `-A`, the `Gamma^r_{rr}` value. -/
theorem hasDerivAt_neg_schA (M r : ℝ) (hr0 : r ≠ 0) (h2M : r - 2 * M ≠ 0) :
    HasDerivAt (fun t => -(M / (t * (t - 2 * M))))
      (2 * M * (r - M) / (r ^ 2 * (r - 2 * M) ^ 2)) r := by
  have h := (hasDerivAt_schA M r hr0 h2M).neg
  exact h.congr_deriv (by
    show -(-2 * M * (r - M) / (r ^ 2 * (r - 2 * M) ^ 2))
      = 2 * M * (r - M) / (r ^ 2 * (r - 2 * M) ^ 2)
    ring)

/-- Derivative of `B = M (t - 2M) / t^3`, the `Gamma^r_{tt}` value:
`M (-2r + 6M) / r^4`. -/
theorem hasDerivAt_schB (M r : ℝ) (hr0 : r ≠ 0) :
    HasDerivAt (fun t => M * (t - 2 * M) / t ^ 3)
      (M * (-2 * r + 6 * M) / r ^ 4) r := by
  have hnum : HasDerivAt (fun t => M * (t - 2 * M)) M r := by
    have hsub : HasDerivAt (fun t => t - 2 * M) (1 : ℝ) r :=
      ((hasDerivAt_id' r).fun_sub (hasDerivAt_const r (2 * M))).congr_deriv
        (by norm_num)
    exact ((hasDerivAt_const r M).fun_mul hsub).congr_deriv (by
      show 0 * (r - 2 * M) + M * 1 = M
      ring)
  have hden : HasDerivAt (fun t => t ^ 3) (3 * r ^ 2) r := by
    have h := (hasDerivAt_id' r).fun_pow 3
    simpa using h
  have h3 : (r ^ 3) ≠ 0 := pow_ne_zero 3 hr0
  have h := hnum.fun_div hden h3
  exact h.congr_deriv (by
    show (M * r ^ 3 - M * (r - 2 * M) * (3 * r ^ 2)) / (r ^ 3) ^ 2
      = M * (-2 * r + 6 * M) / r ^ 4
    field_simp [hr0, h3]
    ring)

/-- Schwarzschild metric components, factored form:
`g = diag((2M - r) / r, r / (r - 2M), r^2, r^2 sin^2 theta)`. -/
noncomputable def schMetric (M : ℝ) : (Fin 4 → ℝ) → Fin 4 → Fin 4 → ℝ :=
  fun y i j =>
    if i = j then
      (if i = 0 then (2 * M - y 1) / (y 1)
      else if i = 1 then (y 1) / (y 1 - 2 * M)
      else if i = 2 then (y 1) ^ 2
      else (y 1) ^ 2 * Real.sin (y 2) ^ 2)
    else 0

/-- Schwarzschild inverse metric components:
`g^{-1} = diag(-r / (r - 2M), (r - 2M) / r, 1 / r^2, 1 / (r^2 sin^2 theta))`. -/
noncomputable def schInvMetric (M : ℝ) : (Fin 4 → ℝ) → Fin 4 → Fin 4 → ℝ :=
  fun y i j =>
    if i = j then
      (if i = 0 then -(y 1) / (y 1 - 2 * M)
      else if i = 1 then (y 1 - 2 * M) / (y 1)
      else if i = 2 then 1 / (y 1) ^ 2
      else 1 / ((y 1) ^ 2 * Real.sin (y 2) ^ 2))
    else 0

/-- The factored metric components equal the brief's forms
`diag(-(1 - 2M / r), 1 / (1 - 2M / r), r^2, r^2 sin^2 theta)` on the chart. -/
theorem schMetric_brief_form (M : ℝ) (y : Fin 4 → ℝ) (hr0 : y 1 ≠ 0)
    (h2M : y 1 - 2 * M ≠ 0) (i j : Fin 4) :
    schMetric M y i j =
      if i = j then
        (if i = 0 then -(1 - 2 * M / (y 1))
        else if i = 1 then 1 / (1 - 2 * M / (y 1))
        else if i = 2 then (y 1) ^ 2
        else (y 1) ^ 2 * Real.sin (y 2) ^ 2)
      else 0 := by
  fin_cases i <;> fin_cases j <;>
    simp [schMetric] <;>
    field_simp [hr0, h2M]

/-- Partial derivatives of the Schwarzschild metric components: only
`∂_r g_tt`, `∂_r g_rr`, `∂_r g_θθ`, `∂_r g_φφ`, and `∂_θ g_φφ` are nonzero. -/
theorem schMetric_fderiv (M : ℝ) (y : Fin 4 → ℝ)
    (hr0 : y 1 ≠ 0) (h2M : y 1 - 2 * M ≠ 0) (l j k : Fin 4) :
    fderiv ℝ (fun z => schMetric M z l j) y (Pi.single k 1) =
      if l = 0 ∧ j = 0 ∧ k = 1 then -2 * M / (y 1) ^ 2
      else if l = 1 ∧ j = 1 ∧ k = 1 then -2 * M / (y 1 - 2 * M) ^ 2
      else if l = 2 ∧ j = 2 ∧ k = 1 then 2 * (y 1)
      else if l = 3 ∧ j = 3 ∧ k = 1 then 2 * (y 1) * Real.sin (y 2) ^ 2
      else if l = 3 ∧ j = 3 ∧ k = 2 then
        (y 1) ^ 2 * (2 * Real.sin (y 2) * Real.cos (y 2))
      else 0 := by
  have hgtt : ∀ k : Fin 4,
      fderiv ℝ (fun z => (2 * M - z 1) / (z 1)) y (Pi.single k 1) =
        if k = 1 then -2 * M / (y 1) ^ 2 else 0 :=
    fun k => fderiv_of_coord _ _ y 1 k (hasDerivAt_sch_gtt M (y 1) hr0)
  have hgrr : ∀ k : Fin 4,
      fderiv ℝ (fun z => (z 1) / (z 1 - 2 * M)) y (Pi.single k 1) =
        if k = 1 then -2 * M / (y 1 - 2 * M) ^ 2 else 0 :=
    fun k => fderiv_of_coord _ _ y 1 k (hasDerivAt_sch_grr M (y 1) h2M)
  have hgth : ∀ k : Fin 4,
      fderiv ℝ (fun z => (z 1) ^ 2) y (Pi.single k 1) =
        if k = 1 then 2 * (y 1) else 0 :=
    fun k => fderiv_of_coord _ _ y 1 k (hasDerivAt_sq (y 1))
  have hgpp : ∀ k : Fin 4,
      fderiv ℝ (fun z => (z 1) ^ 2 * Real.sin (z 2) ^ 2) y (Pi.single k 1) =
        (if k = 1 then 2 * (y 1) * Real.sin (y 2) ^ 2 else 0)
          + (if k = 2 then
              (y 1) ^ 2 * (2 * Real.sin (y 2) * Real.cos (y 2)) else 0) :=
    fun k => fderiv_prod_coord (fun t => t ^ 2) (fun t => Real.sin t ^ 2)
      (2 * (y 1)) (2 * Real.sin (y 2) * Real.cos (y 2)) y 1 2 k (by decide)
      (hasDerivAt_sq (y 1)) (hasDerivAt_sin_sq (y 2))
  fin_cases l <;> fin_cases j <;> fin_cases k <;>
    simp [schMetric, hgtt, hgrr, hgth, hgpp]

/-- The standard Schwarzschild Christoffel symbols, as an explicit table
(Astra's strategy, section 2), in factored form:
`Γ^t_{tr} = Γ^t_{rt} = M / (r (r - 2M))`,
`Γ^r_{tt} = M (r - 2M) / r^3`,
`Γ^r_{rr} = -M / (r (r - 2M))`,
`Γ^r_{θθ} = 2M - r`,
`Γ^r_{φφ} = (2M - r) sin^2 θ`,
`Γ^θ_{rθ} = Γ^θ_{θr} = 1 / r`,
`Γ^θ_{φφ} = -(sin θ cos θ)`,
`Γ^φ_{rφ} = Γ^φ_{φr} = 1 / r`,
`Γ^φ_{θφ} = Γ^φ_{φθ} = cos θ / sin θ`, all others `0`. -/
noncomputable def schGammaExplicit (M : ℝ) : (Fin 4 → ℝ) → ChristoffelSymbols 4 :=
  fun y i k j =>
    if i = 0 then
      (if (k = 1 ∧ j = 0) ∨ (k = 0 ∧ j = 1) then
        M / ((y 1) * (y 1 - 2 * M)) else 0)
    else if i = 1 then
      (if k = 0 ∧ j = 0 then M * (y 1 - 2 * M) / (y 1) ^ 3
      else if k = 1 ∧ j = 1 then -(M / ((y 1) * (y 1 - 2 * M)))
      else if k = 2 ∧ j = 2 then 2 * M - y 1
      else if k = 3 ∧ j = 3 then (2 * M - y 1) * Real.sin (y 2) ^ 2
      else 0)
    else if i = 2 then
      (if (k = 1 ∧ j = 2) ∨ (k = 2 ∧ j = 1) then 1 / (y 1)
      else if k = 3 ∧ j = 3 then -(Real.sin (y 2) * Real.cos (y 2))
      else 0)
    else
      (if (k = 1 ∧ j = 3) ∨ (k = 3 ∧ j = 1) then 1 / (y 1)
      else if (k = 2 ∧ j = 3) ∨ (k = 3 ∧ j = 2) then
        Real.cos (y 2) / Real.sin (y 2)
      else 0)

/-- The Christoffel symbols derived from the metric by the Koszul formula
`Γ^i_{kj} = (1/2) Σ_l g^{il} (∂_k g_{lj} + ∂_j g_{lk} - ∂_l g_{kj})`. -/
noncomputable def schKoszulGamma (M : ℝ) : (Fin 4 → ℝ) → ChristoffelSymbols 4 :=
  fun y i k j => (1 / 2) * ∑ l, schInvMetric M y i l *
    (fderiv ℝ (fun z => schMetric M z l j) y (Pi.single k 1) +
      fderiv ℝ (fun z => schMetric M z l k) y (Pi.single j 1) -
      fderiv ℝ (fun z => schMetric M z k j) y (Pi.single l 1))

/-- The Koszul-derived symbols equal the standard Schwarzschild symbols
wherever `M > 0`, `r > 2M`, and `sin θ ≠ 0`: the connection is derived
from the metric, not merely asserted. -/
theorem schKoszul_eq_explicit (M : ℝ) (hM : 0 < M) (y : Fin 4 → ℝ)
    (hr : 2 * M < y 1) (hs : Real.sin (y 2) ≠ 0) (i k j : Fin 4) :
    schKoszulGamma M y i k j = schGammaExplicit M y i k j := by
  have hr0 : y 1 ≠ 0 := sch_chart_r_ne_zero hM hr
  have h2M : y 1 - 2 * M ≠ 0 := sch_chart_r_sub_ne_zero hM hr
  have h1sq : (y 1) ^ 2 ≠ 0 := pow_ne_zero 2 hr0
  have hsin2 : Real.sin (y 2) ^ 2 ≠ 0 := pow_ne_zero 2 hs
  have hprod : (y 1) ^ 2 * Real.sin (y 2) ^ 2 ≠ 0 := mul_ne_zero h1sq hsin2
  have hrr : (y 1) * (y 1 - 2 * M) ≠ 0 := mul_ne_zero hr0 h2M
  have hfd := schMetric_fderiv M y hr0 h2M
  fin_cases i <;> fin_cases k <;> fin_cases j <;>
    simp [schKoszulGamma, Fin.sum_univ_four, hfd, schInvMetric,
      schGammaExplicit] <;>
    field_simp [hr0, h2M, hs, h1sq, hsin2, hprod, hrr] <;> ring

#print axioms fderiv_of_coord
#print axioms fderiv_prod_coord
#print axioms hasDerivAt_schA
#print axioms hasDerivAt_schB
#print axioms schMetric_brief_form
#print axioms schMetric_fderiv
#print axioms schKoszul_eq_explicit

/-- Partial derivatives of the explicit Schwarzschild symbols (Astra's
strategy, section 3). Only the `r` and `theta` directions are nonzero;
`t` and `phi` derivatives all vanish. -/
theorem schGammaExplicit_fderiv (M : ℝ) (y : Fin 4 → ℝ)
    (hr0 : y 1 ≠ 0) (h2M : y 1 - 2 * M ≠ 0) (hs : Real.sin (y 2) ≠ 0)
    (i k j m : Fin 4) :
    fderiv ℝ (fun z => schGammaExplicit M z i k j) y (Pi.single m 1) =
      if i = 0 then
        (if (k = 1 ∧ j = 0) ∨ (k = 0 ∧ j = 1) then
          (if m = 1 then
            -2 * M * ((y 1) - M) / ((y 1) ^ 2 * (y 1 - 2 * M) ^ 2) else 0)
        else 0)
      else if i = 1 then
        (if k = 0 ∧ j = 0 then
          (if m = 1 then M * (-2 * (y 1) + 6 * M) / (y 1) ^ 4 else 0)
        else if k = 1 ∧ j = 1 then
          (if m = 1 then
            2 * M * ((y 1) - M) / ((y 1) ^ 2 * (y 1 - 2 * M) ^ 2) else 0)
        else if k = 2 ∧ j = 2 then (if m = 1 then -1 else 0)
        else if k = 3 ∧ j = 3 then
          ((if m = 1 then (-1) * Real.sin (y 2) ^ 2 else 0)
            + (if m = 2 then (2 * M - y 1)
              * (2 * Real.sin (y 2) * Real.cos (y 2)) else 0))
        else 0)
      else if i = 2 then
        (if (k = 1 ∧ j = 2) ∨ (k = 2 ∧ j = 1) then
          (if m = 1 then -((y 1) ^ 2)⁻¹ else 0)
        else if k = 3 ∧ j = 3 then
          (if m = 2 then Real.sin (y 2) ^ 2 - Real.cos (y 2) ^ 2 else 0)
        else 0)
      else
        (if (k = 1 ∧ j = 3) ∨ (k = 3 ∧ j = 1) then
          (if m = 1 then -((y 1) ^ 2)⁻¹ else 0)
        else if (k = 2 ∧ j = 3) ∨ (k = 3 ∧ j = 2) then
          (if m = 2 then -1 / Real.sin (y 2) ^ 2 else 0)
        else 0) := by
  have hA : ∀ m : Fin 4,
      fderiv ℝ (fun z => M / ((z 1) * (z 1 - 2 * M))) y (Pi.single m 1) =
        if m = 1 then
          -2 * M * ((y 1) - M) / ((y 1) ^ 2 * (y 1 - 2 * M) ^ 2) else 0 :=
    fun m => fderiv_of_coord _ _ y 1 m (hasDerivAt_schA M (y 1) hr0 h2M)
  have hB : ∀ m : Fin 4,
      fderiv ℝ (fun z => M * (z 1 - 2 * M) / (z 1) ^ 3) y (Pi.single m 1) =
        if m = 1 then M * (-2 * (y 1) + 6 * M) / (y 1) ^ 4 else 0 :=
    fun m => fderiv_of_coord _ _ y 1 m (hasDerivAt_schB M (y 1) hr0)
  have h2Mr : ∀ m : Fin 4,
      fderiv ℝ (fun z => 2 * M - z 1) y (Pi.single m 1) =
        if m = 1 then -1 else 0 :=
    fun m => fderiv_of_coord _ _ y 1 m (hasDerivAt_2M_sub M (y 1))
  have hinvr : ∀ m : Fin 4,
      fderiv ℝ (fun z => (z 1)⁻¹) y (Pi.single m 1) =
        if m = 1 then -((y 1) ^ 2)⁻¹ else 0 :=
    fun m => fderiv_of_coord _ _ y 1 m (hasDerivAt_inv hr0)
  have hsc : ∀ m : Fin 4,
      fderiv ℝ (fun z => Real.sin (z 2) * Real.cos (z 2)) y (Pi.single m 1) =
        if m = 2 then Real.cos (y 2) ^ 2 - Real.sin (y 2) ^ 2 else 0 :=
    fun m => fderiv_of_coord _ _ y 2 m (hasDerivAt_sincos (y 2))
  have hcot : ∀ m : Fin 4,
      fderiv ℝ (fun z => Real.cos (z 2) / Real.sin (z 2)) y (Pi.single m 1) =
        if m = 2 then -1 / Real.sin (y 2) ^ 2 else 0 :=
    fun m => fderiv_of_coord _ _ y 2 m (hasDerivAt_cot (y 2) hs)
  have hGpp : ∀ m : Fin 4,
      fderiv ℝ (fun z => (2 * M - z 1) * Real.sin (z 2) ^ 2) y (Pi.single m 1) =
        (if m = 1 then (-1) * Real.sin (y 2) ^ 2 else 0)
          + (if m = 2 then (2 * M - y 1)
            * (2 * Real.sin (y 2) * Real.cos (y 2)) else 0) :=
    fun m => fderiv_prod_coord (fun t => 2 * M - t) (fun t => Real.sin t ^ 2) (-1)
      (2 * Real.sin (y 2) * Real.cos (y 2)) y 1 2 m (by decide)
      (hasDerivAt_2M_sub M (y 1)) (hasDerivAt_sin_sq (y 2))
  fin_cases i <;> fin_cases k <;> fin_cases j <;>
    simp [schGammaExplicit, hA, hB, h2Mr, hinvr, hsc, hcot, hGpp] <;>
    by_cases hm1 : m = 1 <;> by_cases hm2 : m = 2 <;> simp [hm1, hm2] <;> ring

/-- The Koszul-derived symbols have the same partial derivatives as the
explicit symbols at any point of the chart: the two symbol fields agree
on a neighbourhood of such a point. -/
theorem schKoszul_fderiv_eq (M : ℝ) (hM : 0 < M) (y : Fin 4 → ℝ)
    (hr : 2 * M < y 1) (hs : Real.sin (y 2) ≠ 0) (i k j m : Fin 4) :
    fderiv ℝ (fun z => schKoszulGamma M z i k j) y (Pi.single m 1) =
      fderiv ℝ (fun z => schGammaExplicit M z i k j) y (Pi.single m 1) := by
  have hmem1 : {z : Fin 4 → ℝ | 2 * M < z 1} ∈ nhds y :=
    (isOpen_Ioi.preimage (continuous_apply 1)).mem_nhds hr
  have hmem2 : {z : Fin 4 → ℝ | Real.sin (z 2) ≠ 0} ∈ nhds y :=
    (isOpen_compl_singleton.preimage
      (Real.continuous_sin.comp (continuous_apply 2))).mem_nhds hs
  have heq : (fun z => schKoszulGamma M z i k j) =ᶠ[nhds y]
      (fun z => schGammaExplicit M z i k j) := by
    filter_upwards [hmem1, hmem2] with z hz1 hz2
    exact schKoszul_eq_explicit M hM z hz1 hz2 i k j
  rw [heq.fderiv_eq]

#print axioms schGammaExplicit_fderiv
#print axioms schKoszul_fderiv_eq

/-- Schwarzschild Ricci vanishes on the chart `M > 0`, `r > 2M`,
`sin θ ≠ 0`: `Ric = 0`. Proved per `(j, l)` pair by `fin_cases`,
expanding each Ricci component into its four Riemann summands and using
the symbol `fderiv` table (Astra's strategy, section 4). -/
theorem schwarzschild_ricci_eq_zero (M : ℝ) (hM : 0 < M) (y : Fin 4 → ℝ)
    (hr : 2 * M < y 1) (hs : Real.sin (y 2) ≠ 0) (j l : Fin 4) :
    ricciComponents 4 (schKoszulGamma M) y j l = 0 := by
  have hr0 : y 1 ≠ 0 := sch_chart_r_ne_zero hM hr
  have h2M : y 1 - 2 * M ≠ 0 := sch_chart_r_sub_ne_zero hM hr
  have h1sq : (y 1) ^ 2 ≠ 0 := pow_ne_zero 2 hr0
  have hsin2 : Real.sin (y 2) ^ 2 ≠ 0 := pow_ne_zero 2 hs
  have hprod : (y 1) ^ 2 * Real.sin (y 2) ^ 2 ≠ 0 := mul_ne_zero h1sq hsin2
  have hrr : (y 1) * (y 1 - 2 * M) ≠ 0 := mul_ne_zero hr0 h2M
  -- `simp` normalises `2 * M` to `M * 2` and can flip the subtraction,
  -- so `field_simp` needs the nonvanishing facts in those exact forms.
  have h2Ma : y 1 - M * 2 ≠ 0 := by
    rw [show y 1 - M * 2 = y 1 - 2 * M by ring]; exact h2M
  have h2Mb : (-(M * 2) + y 1) ≠ 0 := by
    rw [show (-(M * 2) + y 1) = y 1 - 2 * M by ring]; exact h2M
  have h2Mc : (y 1 + -(M * 2)) ≠ 0 := by
    rw [show y 1 + -(M * 2) = y 1 - 2 * M by ring]; exact h2M
  unfold ricciComponents
  rw [Fin.sum_univ_four]
  unfold riemannComponents
  simp only [Fin.sum_univ_four]
  fin_cases j <;> fin_cases l <;>
    simp [schKoszul_fderiv_eq M hM y hr hs,
      schGammaExplicit_fderiv M y hr0 h2M hs] <;>
    simp [schKoszul_eq_explicit M hM y hr hs, schGammaExplicit] <;>
    field_simp [hr0, h2M, h2Ma, h2Mb, h2Mc, hs, h1sq, hsin2, hprod, hrr] <;>
    (try simp only [Real.sin_sq]) <;>
    ring

/-- Schwarzschild Einstein tensor vanishes on the chart: `G = 0`,
from `Ric = 0` (hence scalar curvature `0`). -/
theorem schwarzschild_einstein_eq_zero (M : ℝ) (hM : 0 < M) (y : Fin 4 → ℝ)
    (hr : 2 * M < y 1) (hs : Real.sin (y 2) ≠ 0) (j l : Fin 4) :
    einsteinComponents 4 (schKoszulGamma M) (schMetric M) (schInvMetric M y)
      y j l = 0 := by
  have hsc : scalarCurvature 4 (schKoszulGamma M) (schInvMetric M y) y = 0 := by
    show ∑ j, ∑ l, schInvMetric M y j l
      * ricciComponents 4 (schKoszulGamma M) y j l = 0
    simp only [schwarzschild_ricci_eq_zero M hM y hr hs, mul_zero,
      Finset.sum_const_zero]
  simp only [einsteinComponents, schwarzschild_ricci_eq_zero M hM y hr hs, hsc,
    mul_zero, zero_mul, sub_zero]

#print axioms schwarzschild_ricci_eq_zero
#print axioms schwarzschild_einstein_eq_zero
#print axioms sch_chart_r_ne_zero
#print axioms sch_chart_r_sub_ne_zero
#print axioms hasDerivAt_sq
#print axioms hasDerivAt_2M_sub
#print axioms hasDerivAt_sin_sq
#print axioms hasDerivAt_sincos
#print axioms hasDerivAt_neg_sincos
#print axioms hasDerivAt_cot
#print axioms hasDerivAt_one_div
#print axioms hasDerivAt_sch_gtt
#print axioms hasDerivAt_sch_grr
#print axioms hasDerivAt_neg_schA
