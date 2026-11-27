/-
Copyright (c) 2026 Richardson Dackam. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.

# Ricci and scalar curvature of the unit 2-sphere at one point

What is proved here: for the linearised stereographic Christoffel symbols of
the unit 2-sphere,
`Γ^i_kj(y) = -2 * (δ^i_k y_j + δ^i_j y_k - δ_kj y_i)`,
at the origin `y = 0` of the stereographic chart, using the project's own
coordinate-component definitions `riemannComponents`, `ricciComponents`, and
`scalarCurvature` from `PseudoRiemannian.LeviCivita`:
- `sphere_riemann_at_zero`: `R^i_jkl = 4 * (δ^i_k δ_jl - δ^i_l δ_jk)`,
- `sphere_ricci_at_zero`: `Ric_jl = 4 * δ_jl`,
- `sphere_scalar_at_zero`: scalar curvature `= 2`,
with the inverse metric `(1/4) * δ` at the origin. This is the discriminating
test for the curvature pipeline: it proves the pipeline computes something
nonzero (sectional curvature 1, scalar curvature 2), not just `0 = 0` on flat
space. The symbols vanish at the origin, so the Riemann components come
entirely from the symbol derivatives.

Novelty tier: Tier 2, incremental API. This is new formalisation, not a
research result.

What is NOT proved here: curvature of a general manifold, curvature away from
the origin of this chart, the Einstein equations, and no Kerr content. Only
one point of one chart of one surface is covered, for the linearised symbols
above.

Lean 4.36.0, Mathlib v4.36.0.
-/

import PseudoRiemannian.LeviCivita
import Mathlib.Analysis.Calculus.FDeriv.Linear

open Module Finset
open scoped BigOperators

/-- Linearised stereographic Christoffel symbols of the unit 2-sphere:
`Γ^i_kj(y) = -2 * (δ^i_k y_j + δ^i_j y_k - δ_kj y_i)`. -/
noncomputable def sphereChristoffel : (Fin 2 → ℝ) → ChristoffelSymbols 2 :=
  fun y i k j =>
    -2 * ((if i = k then y j else 0) + (if i = j then y k else 0) -
      (if k = j then y i else 0))

/-- Inverse metric components at the origin: `(1/4) * δ`, the inverse of
`g = 4 * δ` at the origin of the stereographic chart. -/
noncomputable def sphereInverseMetric : Fin 2 → Fin 2 → ℝ :=
  fun j l => if j = l then (1 / 4 : ℝ) else 0

/-- Partial derivative of the sphere symbols in direction `m`, as a
continuous linear map: the symbols are linear in `y`, with derivative the
constant coefficient of `y_m`. -/
theorem sphereChristoffel_fderiv (i k j m : Fin 2) (x : Fin 2 → ℝ) :
    fderiv ℝ (fun y => sphereChristoffel y i k j) x (Pi.single m 1) =
      -2 * ((if i = k then (if j = m then (1 : ℝ) else 0) else 0) +
        (if i = j then (if k = m then (1 : ℝ) else 0) else 0) -
        (if k = j then (if i = m then (1 : ℝ) else 0) else 0)) := by
  classical
  set L : (Fin 2 → ℝ) →L[ℝ] ℝ :=
    (if i = k then (ContinuousLinearMap.proj j : (Fin 2 → ℝ) →L[ℝ] ℝ) else 0) +
    (if i = j then (ContinuousLinearMap.proj k : (Fin 2 → ℝ) →L[ℝ] ℝ) else 0) -
    (if k = j then (ContinuousLinearMap.proj i : (Fin 2 → ℝ) →L[ℝ] ℝ) else 0) with hLdef
  have hfun : (fun y => sphereChristoffel y i k j) = ⇑((-2 : ℝ) • L) := by
    funext y
    simp only [sphereChristoffel, hLdef]
    split_ifs <;>
      simp only [smul_apply, add_apply, sub_apply, ContinuousLinearMap.proj_apply,
        smul_eq_mul, ContinuousLinearMap.zero_apply, add_zero, sub_zero]
  have hfd : fderiv ℝ (fun y => sphereChristoffel y i k j) x = (-2 : ℝ) • L := by
    rw [hfun]
    exact (ContinuousLinearMap.hasFDerivAt ((-2 : ℝ) • L)).fderiv
  rw [hfd]
  simp only [hLdef]
  split_ifs <;>
    simp only [smul_apply, add_apply, sub_apply, ContinuousLinearMap.proj_apply,
      Pi.single_apply, smul_eq_mul, ContinuousLinearMap.zero_apply, add_zero, sub_zero] <;>
    split_ifs <;>
    simp_all

/-- The sphere symbols vanish at the origin. -/
theorem sphereChristoffel_at_zero (a b c : Fin 2) :
    sphereChristoffel 0 a b c = 0 := by
  simp [sphereChristoffel]

/-- Riemann components of the unit 2-sphere at the origin:
`R^i_jkl = 4 * (δ^i_k δ_jl - δ^i_l δ_jk)`, constant sectional curvature 1. -/
theorem sphere_riemann_at_zero (i j k l : Fin 2) :
    riemannComponents 2 sphereChristoffel 0 i j k l =
      4 * ((if i = k then (if j = l then (1 : ℝ) else 0) else 0) -
        (if i = l then (if j = k then (1 : ℝ) else 0) else 0)) := by
  unfold riemannComponents
  simp only [sphereChristoffel_fderiv]
  simp [sphereChristoffel_at_zero]
  fin_cases i <;> fin_cases j <;> fin_cases k <;> fin_cases l <;> simp <;> norm_num

/-- Ricci components of the unit 2-sphere at the origin: `Ric_jl = 4 * δ_jl`. -/
theorem sphere_ricci_at_zero (j l : Fin 2) :
    ricciComponents 2 sphereChristoffel 0 j l =
      4 * (if j = l then (1 : ℝ) else 0) := by
  fin_cases j <;> fin_cases l <;>
    simp [ricciComponents, Fin.sum_univ_two, sphere_riemann_at_zero]

/-- Scalar curvature of the unit 2-sphere at the origin: `2`. -/
theorem sphere_scalar_at_zero :
    scalarCurvature 2 sphereChristoffel sphereInverseMetric 0 = 2 := by
  simp [scalarCurvature, sphere_ricci_at_zero, sphereInverseMetric]

#print axioms sphere_ricci_at_zero
#print axioms sphere_scalar_at_zero
#print axioms sphere_riemann_at_zero
