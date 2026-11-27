/-
Copyright (c) 2026 Richardson Dackam. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.

# Ricci and scalar curvature of the unit 2-sphere in spherical coordinates

What is proved here: for the unit 2-sphere in spherical coordinates
`y = (θ, φ) : Fin 2 → ℝ`, with metric components
`g = diag(1, sin² θ)`, using the project's own coordinate-component
definitions `riemannComponents`, `ricciComponents`, and `scalarCurvature`
from `PseudoRiemannian.LeviCivita`:
- `sphKoszul_eq_explicit`: the Christoffel symbols obtained from the
  metric by the Koszul formula (inverse metric times metric derivatives)
  equal the standard spherical symbols
  `Γ^θ_{φφ} = -sin θ cos θ`,
  `Γ^φ_{θφ} = Γ^φ_{φθ} = cos θ / sin θ`, all others `0`;
- `sphKoszul_torsionFree` and `sphKoszul_metricCompatible_pointwise`:
  the Koszul-derived symbols are torsion-free and satisfy the
  metric-compatibility identity at each point with `sin θ ≠ 0`;
- `sphKoszul_ricci`: `Ric_jl = g_jl` at every point with `sin θ ≠ 0`;
- `sphKoszul_scalar_at_point`: at `θ = π / 4` the scalar curvature is `2`.

This is the discriminating test the stereographic test could not be: at
`θ = π / 4` one has `Γ^θ_{φφ} = -1 / 2` and `Γ^φ_{θφ} = 1`, so the
`ΓΓ` products in `riemannComponents` are genuinely nonzero — for example
`R^θ_{φθφ}` has derivative part `0` and `ΓΓ` part `+1 / 2` — and deleting
the `ΓΓ` sum from `riemannComponents` makes the Riemann and Ricci statements
fail (see the deletion check in the generator log). The scalar value `2`
itself does not detect the deletion: it is ΓΓ-blind identically in θ, so
discrimination lives in the Riemann and Ricci statements, not in the scalar.

Novelty tier: Tier 2, incremental API. This is new formalisation, not a
research result.

What is NOT proved here: curvature of a general manifold, the Einstein
equations, and no Kerr content. Only the unit 2-sphere, in this one
spherical chart, at points with `sin θ ≠ 0` (Ricci) and at the single
point `θ = π / 4` (scalar curvature, via the inverse metric at that
point) is covered.

Remark on `IsMetricCompatible`, for this metric only: the project's definition fixes one
`Γ : ChristoffelSymbols n` and demands the compatibility identity at
*every* point `x`. For this sphere metric no single fixed `Γ` can
satisfy it at every point (at `θ = π / 6` the identity would force
`Γ^φ_{θφ} = cot (π / 6)` while at `θ = π / 4` it would force
`Γ^φ_{θφ} = cot (π / 4)`). The statement proved here is therefore the
diagonal instance for this metric: for each point `y`, the identity holds
at `x = y` with `Γ = Γ(y)`, the symbols derived from the metric at `y`. That is
`sphKoszul_metricCompatible_pointwise`. Nothing here claims the same form
works for a general non-constant connection.

Lean 4.36.0, Mathlib v4.36.0.
-/

import PseudoRiemannian.LeviCivita
import Mathlib.Analysis.SpecialFunctions.Trigonometric.Basic
import Mathlib.Analysis.SpecialFunctions.Trigonometric.Deriv
import Mathlib.Analysis.Calculus.Deriv.Comp
import Mathlib.Analysis.Calculus.FDeriv.Linear

open Module Finset
open scoped BigOperators

/-- Partial derivative, in direction `k`, of a scalar function of the
first coordinate `y 0` only, from its one-variable derivative. -/
theorem fderiv_scalar_proj (F : ℝ → ℝ) (F' : ℝ) (y : Fin 2 → ℝ) (k : Fin 2)
    (hF : HasDerivAt F F' (y 0)) :
    fderiv ℝ (fun z => F (z 0)) y (Pi.single k 1) = if k = 0 then F' else 0 := by
  have hP : HasFDerivAt (⇑(ContinuousLinearMap.proj 0 : (Fin 2 → ℝ) →L[ℝ] ℝ))
      (ContinuousLinearMap.proj 0) y :=
    ContinuousLinearMap.hasFDerivAt _
  have h := hF.comp_hasFDerivAt y hP
  have hf : fderiv ℝ (fun z => F (z 0)) y = F' • ContinuousLinearMap.proj 0 := h.fderiv
  rw [hf]
  by_cases hk : k = 0
  · subst hk
    simp
  · simp [hk]

/-- Derivative of `sin² θ` in direction `k`. -/
theorem fderiv_sin_sq (y : Fin 2 → ℝ) (k : Fin 2) :
    fderiv ℝ (fun z => Real.sin (z 0) ^ 2) y (Pi.single k 1) =
      if k = 0 then 2 * Real.sin (y 0) * Real.cos (y 0) else 0 := by
  apply fderiv_scalar_proj (fun t => Real.sin t ^ 2)
    (2 * Real.sin (y 0) * Real.cos (y 0)) y k
  have h := (Real.hasDerivAt_sin (y 0)).fun_pow 2
  simpa [pow_one] using h

/-- Derivative of `sin θ cos θ` in direction `k`. This is stated for the
plain product because `simp` pulls a negation out of an `fderiv` and
rewrites a division as multiplication by an inverse, so the lemmas used
as `simp` rewrites must be in that normal form. -/
theorem fderiv_sin_cos (y : Fin 2 → ℝ) (k : Fin 2) :
    fderiv ℝ (fun z => Real.sin (z 0) * Real.cos (z 0)) y (Pi.single k 1) =
      if k = 0 then Real.cos (y 0) ^ 2 - Real.sin (y 0) ^ 2 else 0 := by
  apply fderiv_scalar_proj (fun t => Real.sin t * Real.cos t)
    (Real.cos (y 0) ^ 2 - Real.sin (y 0) ^ 2) y k
  have h := (Real.hasDerivAt_sin (y 0)).mul (Real.hasDerivAt_cos (y 0))
  have hval : Real.cos (y 0) * Real.cos (y 0) + Real.sin (y 0) * (-Real.sin (y 0)) =
      Real.cos (y 0) ^ 2 - Real.sin (y 0) ^ 2 := by ring
  rw [hval] at h
  exact h

/-- Derivative of `cos θ / sin θ` in direction `k`, where `sin θ ≠ 0`. -/
theorem fderiv_cot (y : Fin 2 → ℝ) (hs : Real.sin (y 0) ≠ 0) (k : Fin 2) :
    fderiv ℝ (fun z => Real.cos (z 0) / Real.sin (z 0)) y (Pi.single k 1) =
      if k = 0 then -1 / Real.sin (y 0) ^ 2 else 0 := by
  apply fderiv_scalar_proj (fun t => Real.cos t / Real.sin t)
    (-1 / Real.sin (y 0) ^ 2) y k
  have h := (Real.hasDerivAt_cos (y 0)).div (Real.hasDerivAt_sin (y 0)) hs
  have hnum : -Real.sin (y 0) * Real.sin (y 0) -
      Real.cos (y 0) * Real.cos (y 0) = -1 := by
    have hsc := Real.sin_sq_add_cos_sq (y 0)
    nlinarith [hsc]
  have hval : (-Real.sin (y 0) * Real.sin (y 0) -
      Real.cos (y 0) * Real.cos (y 0)) / Real.sin (y 0) ^ 2 =
      -1 / Real.sin (y 0) ^ 2 := by rw [hnum]
  rw [hval] at h
  exact h

/-- Derivative of `cos θ / sin θ` in the `simp` normal form
`cos θ * (sin θ)⁻¹`, where `sin θ ≠ 0`. -/
theorem fderiv_cot_inv (y : Fin 2 → ℝ) (hs : Real.sin (y 0) ≠ 0) (k : Fin 2) :
    fderiv ℝ (fun z => Real.cos (z 0) * (Real.sin (z 0))⁻¹) y (Pi.single k 1) =
      if k = 0 then -1 / Real.sin (y 0) ^ 2 else 0 := by
  have heq : (fun z : Fin 2 → ℝ => Real.cos (z 0) * (Real.sin (z 0))⁻¹) =
      (fun z => Real.cos (z 0) / Real.sin (z 0)) := by
    funext z
    rw [div_eq_mul_inv]
  rw [heq]
  exact fderiv_cot y hs k

/-- Metric components of the unit 2-sphere in spherical coordinates:
`g = diag(1, sin² θ)`. Here `0` is `θ` and `1` is `φ`. -/
noncomputable def sphMetric : (Fin 2 → ℝ) → Fin 2 → Fin 2 → ℝ :=
  fun y i j => if i = j then (if i = 0 then 1 else Real.sin (y 0) ^ 2) else 0

/-- Inverse metric components: `diag(1, 1 / sin² θ)`. -/
noncomputable def sphInvMetric : (Fin 2 → ℝ) → Fin 2 → Fin 2 → ℝ :=
  fun y i j => if i = j then (if i = 0 then 1 else 1 / Real.sin (y 0) ^ 2) else 0

/-- The point `θ = π / 4`, `φ = 0` at which the scalar curvature is computed. -/
noncomputable def sphPoint : Fin 2 → ℝ :=
  fun i => if i = 0 then Real.pi / 4 else 0

/-- `sin θ ≠ 0` at the chosen point. -/
theorem sphPoint_sin_ne_zero : Real.sin (sphPoint 0) ≠ 0 := by
  have h0 : sphPoint 0 = Real.pi / 4 := by simp [sphPoint]
  rw [h0, Real.sin_pi_div_four]
  positivity

/-- Partial derivatives of the metric components: only `∂_θ g_φφ` is nonzero. -/
theorem sphMetric_fderiv (y : Fin 2 → ℝ) (l j k : Fin 2) :
    fderiv ℝ (fun z => sphMetric z l j) y (Pi.single k 1) =
      if l = 1 ∧ j = 1 ∧ k = 0 then 2 * Real.sin (y 0) * Real.cos (y 0) else 0 := by
  fin_cases l <;> fin_cases j <;> fin_cases k <;>
    simp [sphMetric, fderiv_sin_sq]

/-- The standard spherical Christoffel symbols, as an explicit table:
`Γ^θ_{φφ} = -sin θ cos θ`, `Γ^φ_{θφ} = Γ^φ_{φθ} = cos θ / sin θ`,
all others `0`. -/
noncomputable def sphGammaExplicit : (Fin 2 → ℝ) → ChristoffelSymbols 2 :=
  fun y i k j =>
    if i = 0 then (if k = 1 ∧ j = 1 then -Real.sin (y 0) * Real.cos (y 0) else 0)
    else if (k = 0 ∧ j = 1) ∨ (k = 1 ∧ j = 0) then
      Real.cos (y 0) / Real.sin (y 0) else 0

/-- The Christoffel symbols derived from the metric by the Koszul formula
`Γ^i_{kj} = (1/2) Σ_l g^{il} (∂_k g_{lj} + ∂_j g_{lk} - ∂_l g_{kj})`. -/
noncomputable def sphKoszulGamma : (Fin 2 → ℝ) → ChristoffelSymbols 2 :=
  fun y i k j => (1 / 2) * ∑ l, sphInvMetric y i l *
    (fderiv ℝ (fun z => sphMetric z l j) y (Pi.single k 1) +
      fderiv ℝ (fun z => sphMetric z l k) y (Pi.single j 1) -
      fderiv ℝ (fun z => sphMetric z k j) y (Pi.single l 1))

/-- The Koszul-derived symbols equal the standard spherical symbols
wherever `sin θ ≠ 0`: the connection is derived from the metric, not
merely asserted. -/
theorem sphKoszul_eq_explicit (y : Fin 2 → ℝ) (hs : Real.sin (y 0) ≠ 0)
    (i k j : Fin 2) :
    sphKoszulGamma y i k j = sphGammaExplicit y i k j := by
  fin_cases i <;> fin_cases k <;> fin_cases j <;>
    simp [sphKoszulGamma, Fin.sum_univ_two, sphMetric_fderiv, sphInvMetric,
      sphGammaExplicit] <;>
    try field_simp [hs] <;> ring

/-- Partial derivatives of the explicit spherical symbols. -/
theorem sphGammaExplicit_fderiv (y : Fin 2 → ℝ) (hs : Real.sin (y 0) ≠ 0)
    (i k j m : Fin 2) :
    fderiv ℝ (fun z => sphGammaExplicit z i k j) y (Pi.single m 1) =
      if i = 0 then
        (if k = 1 ∧ j = 1 then
          (if m = 0 then Real.sin (y 0) ^ 2 - Real.cos (y 0) ^ 2 else 0) else 0)
      else if (k = 0 ∧ j = 1) ∨ (k = 1 ∧ j = 0) then
        (if m = 0 then -1 / Real.sin (y 0) ^ 2 else 0) else 0 := by
  -- Specialise the conditional scalar lemmas to this point first: `simp`
  -- does not discharge the `sin θ ≠ 0` side condition, so they must enter
  -- the simp set as unconditional rewrite rules.
  have hct : ∀ k : Fin 2,
      fderiv ℝ (fun z => Real.cos (z 0) / Real.sin (z 0)) y (Pi.single k 1) =
        if k = 0 then -1 / Real.sin (y 0) ^ 2 else 0 := fderiv_cot y hs
  have hcti : ∀ k : Fin 2,
      fderiv ℝ (fun z => Real.cos (z 0) * (Real.sin (z 0))⁻¹) y (Pi.single k 1) =
        if k = 0 then -1 / Real.sin (y 0) ^ 2 else 0 := fderiv_cot_inv y hs
  have hsc : ∀ k : Fin 2,
      fderiv ℝ (fun z => Real.sin (z 0) * Real.cos (z 0)) y (Pi.single k 1) =
        if k = 0 then Real.cos (y 0) ^ 2 - Real.sin (y 0) ^ 2 else 0 :=
    fderiv_sin_cos y
  fin_cases i <;> fin_cases k <;> fin_cases j <;> fin_cases m <;>
    simp [sphGammaExplicit, hct, hcti, hsc]

/-- The Koszul-derived symbols have the same partial derivatives as the
explicit symbols at any point with `sin θ ≠ 0`: the two symbol fields
agree on a neighbourhood of such a point. -/
theorem sphKoszul_fderiv_eq (y : Fin 2 → ℝ) (hs : Real.sin (y 0) ≠ 0)
    (i k j m : Fin 2) :
    fderiv ℝ (fun z => sphKoszulGamma z i k j) y (Pi.single m 1) =
      fderiv ℝ (fun z => sphGammaExplicit z i k j) y (Pi.single m 1) := by
  have hcont : Continuous (fun z : Fin 2 → ℝ => Real.sin (z 0)) :=
    Real.continuous_sin.comp (continuous_apply 0)
  have hmem : (fun z : Fin 2 → ℝ => Real.sin (z 0)) ⁻¹' ({0} : Set ℝ)ᶜ ∈ nhds y :=
    (isOpen_compl_singleton.preimage hcont).mem_nhds hs
  have heq : (fun z => sphKoszulGamma z i k j) =ᶠ[nhds y]
      (fun z => sphGammaExplicit z i k j) := by
    filter_upwards [hmem] with z hz
    exact sphKoszul_eq_explicit z hz i k j
  rw [heq.fderiv_eq]

/-- `(√2 / 2)² = 1 / 2`, `(√2 / 2) * (√2 / 2) = 1 / 2`, and
`(√2 / 2) / (√2 / 2) = 1`: the arithmetic of the values at `θ = π / 4`,
stated for `√2 / 2` directly because `simp` rewrites `sin (π / 4)` and
`cos (π / 4)` to `√2 / 2` before a lemma about `sin` and `cos` can apply. -/
theorem sqrt_two_div_two_sq : (Real.sqrt 2 / 2) ^ 2 = 1 / 2 := by
  rw [div_pow, Real.sq_sqrt (by norm_num : (0 : ℝ) ≤ 2)]
  norm_num

theorem sqrt_two_div_two_mul :
    Real.sqrt 2 / 2 * (Real.sqrt 2 / 2) = 1 / 2 := by
  rw [div_mul_div_comm, Real.mul_self_sqrt (by norm_num : (0 : ℝ) ≤ 2)]
  norm_num

theorem sqrt_two_div_two_div :
    Real.sqrt 2 / 2 / (Real.sqrt 2 / 2) = 1 :=
  div_self (by positivity : Real.sqrt 2 / 2 ≠ 0)

/-- The explicit spherical symbols are torsion-free. -/
theorem sphGammaExplicit_torsionFree (y : Fin 2 → ℝ) :
    IsTorsionFree (sphGammaExplicit y) := by
  intro i k j
  fin_cases i <;> fin_cases k <;> fin_cases j <;> simp [sphGammaExplicit]

/-- The Koszul-derived symbols are torsion-free where `sin θ ≠ 0`. -/
theorem sphKoszul_torsionFree (y : Fin 2 → ℝ) (hs : Real.sin (y 0) ≠ 0) :
    IsTorsionFree (sphKoszulGamma y) := by
  intro i k j
  rw [sphKoszul_eq_explicit y hs i k j, sphKoszul_eq_explicit y hs i j k]
  exact sphGammaExplicit_torsionFree y i k j

/-- The explicit spherical symbols satisfy the metric-compatibility
identity at each point with `sin θ ≠ 0` (the diagonal instance of
`IsMetricCompatible`, see the file header). -/
theorem sphGammaExplicit_metricCompatible_pointwise (y : Fin 2 → ℝ)
    (hs : Real.sin (y 0) ≠ 0) (i j k : Fin 2) :
    fderiv ℝ (fun z => sphMetric z i j) y (Pi.single k 1) =
      ∑ l, (sphGammaExplicit y l k i * sphMetric y l j +
        sphGammaExplicit y l k j * sphMetric y i l) := by
  fin_cases i <;> fin_cases j <;> fin_cases k <;>
    simp [sphMetric_fderiv, fderiv_sin_sq, Fin.sum_univ_two, sphGammaExplicit,
      sphMetric] <;>
    try field_simp [hs] <;> ring

/-- The Koszul-derived symbols satisfy the metric-compatibility identity
at each point with `sin θ ≠ 0`. -/
theorem sphKoszul_metricCompatible_pointwise (y : Fin 2 → ℝ)
    (hs : Real.sin (y 0) ≠ 0) (i j k : Fin 2) :
    fderiv ℝ (fun z => sphMetric z i j) y (Pi.single k 1) =
      ∑ l, (sphKoszulGamma y l k i * sphMetric y l j +
        sphKoszulGamma y l k j * sphMetric y i l) := by
  simp only [sphKoszul_eq_explicit y hs]
  exact sphGammaExplicit_metricCompatible_pointwise y hs i j k

/-- Metric components at the chosen point: `g = diag(1, 1/2)`. -/
theorem sphMetric_at_point (i j : Fin 2) :
    sphMetric sphPoint i j =
      if i = j then (if i = 0 then (1 : ℝ) else 1 / 2) else 0 := by
  fin_cases i <;> fin_cases j <;>
    simp [sphMetric, sphPoint, Real.sin_pi_div_four, sqrt_two_div_two_sq] <;>
    norm_num [Real.sq_sqrt]

/-- The stated inverse metric is the inverse of the metric at the
chosen point. -/
theorem sphInvMetric_at_point (i j : Fin 2) :
    ∑ l, sphMetric sphPoint i l * sphInvMetric sphPoint l j =
      if i = j then (1 : ℝ) else 0 := by
  fin_cases i <;> fin_cases j <;>
    simp [Fin.sum_univ_two, sphMetric, sphInvMetric, sphPoint,
      Real.sin_pi_div_four] <;>
    norm_num [Real.sq_sqrt]

/-- `sin θ cos θ = 1 / 2` at `θ = π / 4`. -/
theorem sin_cos_pi_div_four :
    Real.sin (Real.pi / 4) * Real.cos (Real.pi / 4) = 1 / 2 := by
  rw [Real.sin_pi_div_four, Real.cos_pi_div_four, div_mul_div_comm,
    Real.mul_self_sqrt (by norm_num : (0 : ℝ) ≤ 2)]
  norm_num

/-- `cos θ / sin θ = 1` at `θ = π / 4`. -/
theorem cos_div_sin_pi_div_four :
    Real.cos (Real.pi / 4) / Real.sin (Real.pi / 4) = 1 := by
  rw [Real.cos_pi_div_four, Real.sin_pi_div_four]
  exact div_self (by positivity : Real.sqrt 2 / 2 ≠ 0)

/-- The explicit spherical symbols at the chosen point:
`Γ^θ_{φφ} = -1 / 2`, `Γ^φ_{θφ} = Γ^φ_{φθ} = 1`, all others `0`. -/
theorem sphGammaExplicit_at_point (i k j : Fin 2) :
    sphGammaExplicit sphPoint i k j =
      if i = 0 ∧ k = 1 ∧ j = 1 then (-1 / 2 : ℝ)
      else if i = 1 ∧ ((k = 0 ∧ j = 1) ∨ (k = 1 ∧ j = 0)) then 1 else 0 := by
  have h0 : sphPoint 0 = Real.pi / 4 := by simp [sphPoint]
  fin_cases i <;> fin_cases k <;> fin_cases j <;>
    simp [sphGammaExplicit, h0, sqrt_two_div_two_mul, sqrt_two_div_two_div] <;>
    norm_num

/-- The Koszul-derived symbols at the chosen point. -/
theorem sphKoszulGamma_at_point (i k j : Fin 2) :
    sphKoszulGamma sphPoint i k j =
      if i = 0 ∧ k = 1 ∧ j = 1 then (-1 / 2 : ℝ)
      else if i = 1 ∧ ((k = 0 ∧ j = 1) ∨ (k = 1 ∧ j = 0)) then 1 else 0 := by
  rw [sphKoszul_eq_explicit sphPoint sphPoint_sin_ne_zero]
  exact sphGammaExplicit_at_point i k j

/-- Riemann components of the unit 2-sphere in spherical coordinates,
for the explicit symbols: `R^i_{jkl} = δ^i_k g_{jl} - δ^i_l g_{jk}`
(sectional curvature `1`). The `ΓΓ` terms contribute here: for
example at `θ = π / 4`, `R^θ_{φθφ}` has derivative part `0` and
`ΓΓ` part `+1 / 2`. -/
theorem sphGammaExplicit_riemann (y : Fin 2 → ℝ) (hs : Real.sin (y 0) ≠ 0)
    (i j k l : Fin 2) :
    riemannComponents 2 sphGammaExplicit y i j k l =
      (if i = k then sphMetric y j l else 0) -
        (if i = l then sphMetric y j k else 0) := by
  have hfd : ∀ (i k j m : Fin 2),
      fderiv ℝ (fun z => sphGammaExplicit z i k j) y (Pi.single m 1) =
        if i = 0 then
          (if k = 1 ∧ j = 1 then
            (if m = 0 then Real.sin (y 0) ^ 2 - Real.cos (y 0) ^ 2 else 0) else 0)
        else if (k = 0 ∧ j = 1) ∨ (k = 1 ∧ j = 0) then
          (if m = 0 then -1 / Real.sin (y 0) ^ 2 else 0) else 0 :=
    sphGammaExplicit_fderiv y hs
  have hct : ∀ k : Fin 2,
      fderiv ℝ (fun z => Real.cos (z 0) / Real.sin (z 0)) y (Pi.single k 1) =
        if k = 0 then -1 / Real.sin (y 0) ^ 2 else 0 := fderiv_cot y hs
  have hcti : ∀ k : Fin 2,
      fderiv ℝ (fun z => Real.cos (z 0) * (Real.sin (z 0))⁻¹) y (Pi.single k 1) =
        if k = 0 then -1 / Real.sin (y 0) ^ 2 else 0 := fderiv_cot_inv y hs
  have hsc : ∀ k : Fin 2,
      fderiv ℝ (fun z => Real.sin (z 0) * Real.cos (z 0)) y (Pi.single k 1) =
        if k = 0 then Real.cos (y 0) ^ 2 - Real.sin (y 0) ^ 2 else 0 :=
    fderiv_sin_cos y
  unfold riemannComponents
  fin_cases i <;> fin_cases j <;> fin_cases k <;> fin_cases l <;>
    simp [hfd, hct, hcti, hsc, sphGammaExplicit, sphMetric, Fin.sum_univ_two,
      Real.sin_sq_add_cos_sq] <;>
    try field_simp [hs] <;> simp only [Real.sin_sq] <;> ring

/-- Riemann components for the Koszul-derived symbols. -/
theorem sphKoszul_riemann (y : Fin 2 → ℝ) (hs : Real.sin (y 0) ≠ 0)
    (i j k l : Fin 2) :
    riemannComponents 2 sphKoszulGamma y i j k l =
      (if i = k then sphMetric y j l else 0) -
        (if i = l then sphMetric y j k else 0) := by
  unfold riemannComponents
  rw [sphKoszul_fderiv_eq y hs i l j k, sphKoszul_fderiv_eq y hs i k j l]
  simp only [sphKoszul_eq_explicit y hs]
  show riemannComponents 2 sphGammaExplicit y i j k l = _
  exact sphGammaExplicit_riemann y hs i j k l

/-- Ricci components for the Koszul-derived symbols: `Ric = g` at every
point with `sin θ ≠ 0`. -/
theorem sphKoszul_ricci (y : Fin 2 → ℝ) (hs : Real.sin (y 0) ≠ 0)
    (j l : Fin 2) :
    ricciComponents 2 sphKoszulGamma y j l = sphMetric y j l := by
  unfold ricciComponents
  rw [Fin.sum_univ_two, sphKoszul_riemann y hs 0 j 0 l, sphKoszul_riemann y hs 1 j 1 l]
  fin_cases j <;> fin_cases l <;> simp [sphMetric]

/-- Ricci components at the chosen point: `Ric = g = diag(1, 1/2)`. -/
theorem sphKoszul_ricci_at_point (j l : Fin 2) :
    ricciComponents 2 sphKoszulGamma sphPoint j l = sphMetric sphPoint j l :=
  sphKoszul_ricci sphPoint sphPoint_sin_ne_zero j l

/-- Scalar curvature at the chosen point: `2`. -/
theorem sphKoszul_scalar_at_point :
    scalarCurvature 2 sphKoszulGamma (sphInvMetric sphPoint) sphPoint = 2 := by
  simp [scalarCurvature, Fin.sum_univ_two, sphKoszul_ricci_at_point,
    sphInvMetric, sphMetric_at_point, sphPoint, Real.sin_pi_div_four,
    sqrt_two_div_two_sq, div_pow, Real.sq_sqrt]
  norm_num

#print axioms sphKoszul_eq_explicit
#print axioms sphKoszul_torsionFree
#print axioms sphKoszul_metricCompatible_pointwise
#print axioms sphInvMetric_at_point
#print axioms sphKoszul_riemann
#print axioms sphKoszul_ricci_at_point
#print axioms sphKoszul_scalar_at_point
