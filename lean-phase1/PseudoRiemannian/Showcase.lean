/-
Copyright (c) 2026 Richardson Dackam. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.

# Small showcase proof: 2D Minkowski form, signature (1, 1), determinant -1

What is proved here, on `Fin 2 → ℝ`: the bilinear form
`-v 0 * w 0 + v 1 * w 1` is symmetric and nondegenerate, it is a
`PseudoRiemannianMetric` with signature `(1, 1)`, and its matrix in the
standard basis is `!![-1, 0; 0, 1]` with determinant `-1`. This is the
smallest example that exercises the whole interface: form, signature
witness, and matrix.

What is NOT proved here: anything in dimension 4, any curvature, any
general-manifold statement, Sobolev theory, Einstein equations, or Kerr
stability. This is a showcase of the interface, not a research result.

Novelty tier: Tier 2, incremental API.

Lean 4.36.0, Mathlib v4.36.0.
-/

import PseudoRiemannian.Metric
import Mathlib.LinearAlgebra.Matrix.Notation
import Mathlib.LinearAlgebra.Matrix.Determinant.Basic

open Module Finset
open scoped BigOperators

/-- The 2D Minkowski bilinear form: `-v 0 * w 0 + v 1 * w 1`. -/
noncomputable def minkowski2Form : (Fin 2 → ℝ) →ₗ[ℝ] (Fin 2 → ℝ) →ₗ[ℝ] ℝ where
  toFun v :=
    { toFun := fun w => -v 0 * w 0 + v 1 * w 1
      map_add' := by
        intro w w'
        simp only [Pi.add_apply]
        ring
      map_smul' := by
        intro r w
        simp only [Pi.smul_apply, RingHom.id_apply, smul_eq_mul]
        ring }
  map_add' := by
    intro v v'
    apply LinearMap.ext
    intro w
    simp only [Pi.add_apply, LinearMap.coe_mk, AddHom.coe_mk, LinearMap.add_apply]
    ring
  map_smul' := by
    intro r v
    apply LinearMap.ext
    intro w
    simp only [Pi.smul_apply, RingHom.id_apply, LinearMap.coe_mk, AddHom.coe_mk,
      LinearMap.smul_apply, RingHom.id_apply, smul_eq_mul]
    ring

/-- Applying the 2D Minkowski form is the explicit two-term sum. -/
theorem minkowski2Form_apply (v w : Fin 2 → ℝ) :
    minkowski2Form v w = -v 0 * w 0 + v 1 * w 1 :=
  rfl

theorem minkowski2Form_symm (v w : Fin 2 → ℝ) :
    minkowski2Form v w = minkowski2Form w v := by
  simp only [minkowski2Form_apply]
  ring

theorem minkowski2Form_nondeg (v : Fin 2 → ℝ) :
    (∀ w, minkowski2Form v w = 0) → v = 0 := by
  intro hv
  have h0 := hv (Pi.single 0 1)
  have h1 := hv (Pi.single 1 1)
  simp only [minkowski2Form_apply, Pi.single_apply] at h0 h1
  -- Each hypothesis now says a single component of `v` is zero (up to sign).
  have e0 : v 0 = 0 := by
    simpa using h0
  have e1 : v 1 = 0 := by
    simpa using h1
  funext i
  fin_cases i <;> assumption

/-- The 2D Minkowski metric, signature `(1, 1)`. -/
noncomputable def minkowski2Metric : PseudoRiemannianMetric (Fin 2 → ℝ) 1 1 where
  form := minkowski2Form
  symm := minkowski2Form_symm
  nondeg := minkowski2Form_nondeg
  finrank_eq := by
    simp [Module.finrank_pi]
  signature := by
    -- The locked diagonal is `(-1, 1)`, coordinate 0 timelike, but the
    -- structure's signature witness lists plus-ones first, then minus-ones.
    -- The witness basis therefore lists the spacelike direction first,
    -- then the timelike one: the standard basis reindexed by the
    -- one-step rotation, so basis vector 0 is `e 1` and vector 1 is `e 0`.
    refine ⟨(Pi.basisFun ℝ (Fin 2)).reindex (finRotate 2).symm, ?_⟩
    intro i j
    fin_cases i <;> fin_cases j <;>
      simp [minkowski2Form_apply, Pi.basisFun_apply, Basis.reindex_apply]

/-- The 2D Minkowski metric has the expected form on vectors. -/
theorem minkowski2Metric_apply (v w : Fin 2 → ℝ) :
    minkowski2Metric.form v w = -v 0 * w 0 + v 1 * w 1 :=
  rfl

/-- The matrix of the 2D Minkowski form in the standard basis. -/
noncomputable def minkowski2Matrix : Matrix (Fin 2) (Fin 2) ℝ :=
  !![-1, 0; 0, 1]

/-- The matrix entries are the form evaluated on standard basis vectors. -/
theorem minkowski2Matrix_apply (i j : Fin 2) :
    minkowski2Matrix i j = minkowski2Form (Pi.single i 1) (Pi.single j 1) := by
  fin_cases i <;> fin_cases j <;>
    simp [minkowski2Matrix, minkowski2Form_apply, Pi.single_apply]

/-- The determinant of the 2D Minkowski matrix is `-1`. -/
theorem minkowski2Matrix_det : minkowski2Matrix.det = -1 := by
  rw [minkowski2Matrix, Matrix.det_fin_two_of]
  norm_num

#print axioms minkowski2Metric
#print axioms minkowski2Matrix_det
