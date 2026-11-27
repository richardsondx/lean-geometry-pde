/-
Copyright (c) 2026 Richardson Dackam. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.

# Pseudo-Riemannian metric interface

What is proved here: a signature-parameterised metric interface on a finite-dimensional
real vector space, with signature (p, q) = (pluses, minuses), Lorentzian (3, 1) and
Riemannian (n, 0) as cases, plus the Minkowski metric on `Fin 4 → ℝ` as a concrete
example with its signature witness. No general manifold metric is constructed here.

Novelty tier: Tier 2, incremental API. This is new formalisation, not a research result.

What is NOT proved here: a general manifold Levi-Civita connection, curvature in general,
Sobolev theory, Einstein equations, Kerr stability. Those are later modules or not in scope.

Lean 4.36.0, Mathlib v4.36.0.

Diamond note: this module registers no instances at all. There is no `pos` field and no
`isVonNBounded` field, because a Lorentzian form cannot satisfy them: on Mathlib v4.36.0
the `pos` field of `Bundle.ContMDiffRiemannianMetric` is strict positive definiteness,
`pos (b) (v) (hv : v ≠ 0) : 0 < inner b v v`
(`Mathlib/Geometry/Manifold/VectorBundle/Riemannian.lean:249`), and a nonzero null vector
already violates it since `0 < 0` is false. A negative vector violates both `pos` and
`isVonNBounded`. The fiber inner product for the (n, 0) case is a plain definition
(`PseudoRiemannianMetric.fiberInner`), and its equality with the form is `rfl` on that
explicit definition, not a typeclass synthesis result. Zero instances here means these
modules cannot be the source of a typeclass diamond; that does not stop a downstream file
registering two competing instances on the same fibers.
-/

import Mathlib.Basic.Real.Basic
import Mathlib.LinearAlgebra.Basis.Fin
import Mathlib.LinearAlgebra.StdBasis
import Mathlib.LinearAlgebra.FiniteDimensional.Defs
import Mathlib.LinearAlgebra.Dimension.Finrank
import Mathlib.LinearAlgebra.Dimension.Constructions
import Mathlib.LinearAlgebra.Pi
import Mathlib.Logic.Equiv.Fin.Rotate
import Mathlib.Tactic.FinCases

open Module Finset

/-- A pseudo-Riemannian metric on a finite-dimensional real vector space, with
signature `(p, q) = (pluses, minuses)`. The form is symmetric and nondegenerate, the
space has dimension `p + q`, and the signature is witnessed by a basis on which the
form is diagonal with `p` plus-ones first and then `q` minus-ones. There is deliberately no
positive-definiteness field: a Lorentzian form cannot satisfy one. -/
structure PseudoRiemannianMetric (V : Type*) [AddCommGroup V] [Module ℝ V]
    [FiniteDimensional ℝ V] (p q : ℕ) where
  form : V →ₗ[ℝ] V →ₗ[ℝ] ℝ
  symm : ∀ v w, form v w = form w v
  nondeg : ∀ v, (∀ w, form v w = 0) → v = 0
  finrank_eq : Module.finrank ℝ V = p + q
  signature : ∃ b : Basis (Fin (p + q)) ℝ V, ∀ i j,
    form (b i) (b j) = if i = j then (if (i : ℕ) < p then 1 else -1) else 0

/-- A Lorentzian metric in dimension `n`: signature `(n - 1, 1)`. -/
abbrev LorentzianMetric (V : Type*) [AddCommGroup V] [Module ℝ V]
    [FiniteDimensional ℝ V] (n : ℕ) :=
  PseudoRiemannianMetric V (n - 1) 1

/-- A spacetime metric: signature `(3, 1)`, coordinate `0` timelike. -/
abbrev SpacetimeMetric (V : Type*) [AddCommGroup V] [Module ℝ V]
    [FiniteDimensional ℝ V] :=
  PseudoRiemannianMetric V 3 1

/-- A Riemannian metric in dimension `n`: signature `(n, 0)`, positive definite. -/
abbrev PositiveDefiniteMetric (V : Type*) [AddCommGroup V] [Module ℝ V]
    [FiniteDimensional ℝ V] (n : ℕ) :=
  PseudoRiemannianMetric V n 0

/-- The Minkowski bilinear form on `Fin 4 → ℝ`: `- v 0 * w 0 + v 1 * w 1 + v 2 * w 2
+ v 3 * w 3`, diagonal `(-1, 1, 1, 1)`, coordinate `0` timelike. This is the locked
signature `(-, +, +, +)`. -/
noncomputable def minkowskiForm : (Fin 4 → ℝ) →ₗ[ℝ] (Fin 4 → ℝ) →ₗ[ℝ] ℝ where
  toFun v :=
    { toFun := fun w => - v 0 * w 0 + v 1 * w 1 + v 2 * w 2 + v 3 * w 3
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
      LinearMap.smul_apply, smul_eq_mul]
    ring

/-- Applying the Minkowski form is the explicit four-term sum. -/
theorem minkowskiForm_apply (v w : Fin 4 → ℝ) :
    minkowskiForm v w = - v 0 * w 0 + v 1 * w 1 + v 2 * w 2 + v 3 * w 3 :=
  rfl

theorem minkowskiForm_symm (v w : Fin 4 → ℝ) :
    minkowskiForm v w = minkowskiForm w v := by
  simp only [minkowskiForm_apply]
  ring

theorem minkowskiForm_nondeg (v : Fin 4 → ℝ) :
    (∀ w, minkowskiForm v w = 0) → v = 0 := by
  intro hv
  have h0 := hv (Pi.single 0 1)
  have h1 := hv (Pi.single 1 1)
  have h2 := hv (Pi.single 2 1)
  have h3 := hv (Pi.single 3 1)
  simp only [minkowskiForm_apply, Pi.single_apply] at h0 h1 h2 h3
  -- Each hypothesis now says a single component of `v` is zero (up to sign).
  have e0 : v 0 = 0 := by
    simpa using h0
  have e1 : v 1 = 0 := by
    simpa using h1
  have e2 : v 2 = 0 := by
    simpa using h2
  have e3 : v 3 = 0 := by
    simpa using h3
  funext i
  fin_cases i <;> assumption

/-- The Minkowski metric on `Fin 4 → ℝ`, signature `(3, 1)`. -/
noncomputable def minkowskiMetric : PseudoRiemannianMetric (Fin 4 → ℝ) 3 1 where
  form := minkowskiForm
  symm := minkowskiForm_symm
  nondeg := minkowskiForm_nondeg
  finrank_eq := by
    simp [Module.finrank_pi]
  signature := by
    -- The locked diagonal is `(-1, 1, 1, 1)`, coordinate 0 timelike, but the
    -- structure's signature witness lists plus-ones first, then minus-ones.
    -- The witness basis therefore lists the three spacelike directions first,
    -- then the timelike one: it is the standard basis reindexed by the
    -- one-step rotation, so basis vector 0 is `e 1`, vector 1 is `e 2`,
    -- vector 2 is `e 3`, and vector 3 is `e 0`.
    refine ⟨(Pi.basisFun ℝ (Fin 4)).reindex (finRotate 4).symm, ?_⟩
    intro i j
    fin_cases i <;> fin_cases j <;>
      simp [minkowskiForm_apply, Pi.basisFun_apply, Basis.reindex_apply]

/-- The Minkowski metric has the expected form on vectors. -/
theorem minkowskiMetric_apply (v w : Fin 4 → ℝ) :
    minkowskiMetric.form v w = - v 0 * w 0 + v 1 * w 1 + v 2 * w 2 + v 3 * w 3 :=
  rfl

/-- The constant component field of a metric on `Fin n → ℝ`: the components of the
fiber form in the standard basis, the same at every point. -/
noncomputable def PseudoRiemannianMetric.constantComponents {n p q : ℕ}
    (g : PseudoRiemannianMetric (Fin n → ℝ) p q) :
    (Fin n → ℝ) → Fin n → Fin n → ℝ :=
  fun _ i j => g.form (Pi.single i 1) (Pi.single j 1)

/-- The fiber inner product of a positive-definite `(n, 0)` metric, as a plain
definition. This is not an instance: nothing is registered with typeclass inference,
so this definition cannot create a diamond. -/
noncomputable def PseudoRiemannianMetric.fiberInner {V : Type*} [AddCommGroup V]
    [Module ℝ V] [FiniteDimensional ℝ V] {n : ℕ}
    (g : PseudoRiemannianMetric V n 0) : V → V → ℝ :=
  fun v w => g.form v w

/-- The fiber inner product is the metric form, by definition. -/
theorem PseudoRiemannianMetric.fiberInner_apply {V : Type*} [AddCommGroup V]
    [Module ℝ V] [FiniteDimensional ℝ V] {n : ℕ}
    (g : PseudoRiemannianMetric V n 0) (v w : V) :
    g.fiberInner v w = g.form v w :=
  rfl

/-- The fiber inner product of a positive-definite metric is symmetric. -/
theorem PseudoRiemannianMetric.fiberInner_symm {V : Type*} [AddCommGroup V]
    [Module ℝ V] [FiniteDimensional ℝ V] {n : ℕ}
    (g : PseudoRiemannianMetric V n 0) (v w : V) :
    g.fiberInner v w = g.fiberInner w v :=
  g.symm v w
