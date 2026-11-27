/-
Copyright (c) 2026 Richardson Dackam. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.

# Levi-Civita connection for a constant metric on R^n

What is proved here: for a constant metric field on `R^n`, the flat Christoffel
symbols `Γ = 0` are torsion-free and metric-compatible, and they are constructed from
the metric interface `PseudoRiemannianMetric` alone, with no `RiemannianBundle`
assumption anywhere in this file. The Minkowski case is the compiled example
`minkowski_leviCivita`. Riemann, Ricci and scalar curvature are defined here as
coordinate components from `Γ` and its partial derivatives, using the formula
confirmed by Astra (call 1, astra-log-phase1-build.md):
`R^i_jkl = ∂_k Γ^i_lj - ∂_l Γ^i_kj + Σ_m (Γ^i_km Γ^m_lj - Γ^i_lm Γ^m_kj)`,
`Ric_jl = Σ_i R^i_jil`, scalar `= Σ_{j,l} g^{jl} Ric_jl` with the inverse metric.

Novelty tier: Tier 2, incremental API. This is new formalisation, not a research result.

What is NOT proved here: a Levi-Civita connection on a general manifold, for a
non-constant metric, or for a general (p, q) metric field. Upstream Mathlib v4.36.0
`CovariantDerivative.IsLeviCivitaConnection` is Riemannian-only: it requires
`[RiemannianBundle (fun x => TangentSpace I x)]` and
`[IsContMDiffRiemannianBundle I 1 E ...]`
(`Mathlib/Geometry/Manifold/VectorBundle/CovariantDerivative/LeviCivita.lean:126,156,172,201`),
so it cannot supply an indefinite connection, and this file does not claim to replace
it in general. Uniqueness of the connection in general is also not proved here.
No Sobolev theory, no Einstein equations, no Kerr content.

Lean 4.36.0, Mathlib v4.36.0.

Convention: `Γ i k j` means `Γ^i_{kj}`, so `∇_{∂_k} ∂_j = Σ_i Γ^i_{kj} ∂_i`.
Torsion-free is symmetry of `Γ` in its two lower indices. Metric-compatible is the
coordinate identity `∂_k g_ij = Σ_l (Γ^l_{ki} g_{lj} + Γ^l_{kj} g_{il})`.
-/

import PseudoRiemannian.Metric
import Mathlib.Analysis.Calculus.FDeriv.Basic
import Mathlib.Analysis.Calculus.FDeriv.Const

open Module Finset
open scoped BigOperators

/-- Christoffel symbols on `R^n`: `Γ i k j = Γ^i_{kj}`. -/
abbrev ChristoffelSymbols (n : ℕ) := Fin n → Fin n → Fin n → ℝ

/-- A Christoffel symbol family is torsion-free when it is symmetric in its two
lower indices. -/
def IsTorsionFree {n : ℕ} (Γ : ChristoffelSymbols n) : Prop :=
  ∀ i k j, Γ i k j = Γ i j k

/-- A Christoffel symbol family is metric-compatible with a component field `g`
when the coordinate identity `∂_k g_ij = Σ_l (Γ^l_{ki} g_{lj} + Γ^l_{kj} g_{il})`
holds at every point. -/
def IsMetricCompatible (n : ℕ) (g : (Fin n → ℝ) → Fin n → Fin n → ℝ)
    (Γ : ChristoffelSymbols n) : Prop :=
  ∀ x i j k, fderiv ℝ (fun y => g y i j) x (Pi.single k 1) =
    ∑ l, (Γ l k i * g x l j + Γ l k j * g x i l)

/-- The flat Christoffel symbols: `Γ = 0` at every point. -/
def flatChristoffel (n : ℕ) : (Fin n → ℝ) → ChristoffelSymbols n :=
  fun _ _ _ _ => 0

/-- The flat symbols are torsion-free. -/
theorem flatChristoffel_torsionFree (n : ℕ) (x : Fin n → ℝ) :
    IsTorsionFree (flatChristoffel n x) := by
  intro i k j
  rfl

/-- The flat symbols are metric-compatible with any constant component field, in
particular with the constant field of any `PseudoRiemannianMetric` on `Fin n → ℝ`.
Both sides of the compatibility identity are zero: the metric does not vary, and
every `Γ` term is zero. -/
theorem flatChristoffel_metricCompatible {n p q : ℕ}
    (g : PseudoRiemannianMetric (Fin n → ℝ) p q) :
    ∀ x, IsMetricCompatible n g.constantComponents (flatChristoffel n x) := by
  intro x
  intro y i j k
  have h1 : (fun z : Fin n → ℝ => g.constantComponents z i j)
      = Function.const (Fin n → ℝ) (g.form (Pi.single i 1) (Pi.single j 1)) := rfl
  rw [h1, fderiv_const]
  simp [flatChristoffel]

/-- The Levi-Civita connection of the Minkowski metric, constructed from the metric
interface alone: the flat symbols, which are torsion-free and metric-compatible.
No `RiemannianBundle` assumption is used. This is the compiled example Astra's
hostile review demanded. Scope: constant metric on `R^4` only; general-manifold
Levi-Civita existence is not claimed. -/
theorem minkowski_leviCivita :
    ∃ Γ : (Fin 4 → ℝ) → ChristoffelSymbols 4,
      (∀ x, IsTorsionFree (Γ x)) ∧
      (∀ x, IsMetricCompatible 4 minkowskiMetric.constantComponents (Γ x)) ∧
      (∀ x i k j, Γ x i k j = 0) :=
  ⟨flatChristoffel 4, flatChristoffel_torsionFree 4,
    flatChristoffel_metricCompatible minkowskiMetric, fun _ _ _ _ => rfl⟩

/-- Riemann curvature components from a symbol field `Γ` and its partial
derivatives, with the index convention of the header:
`R^i_jkl = ∂_k Γ^i_lj - ∂_l Γ^i_kj + Σ_m (Γ^i_km Γ^m_lj - Γ^i_lm Γ^m_kj)`.
This is a coordinate-component definition on `R^n`, not the general manifold
Riemann tensor. -/
noncomputable def riemannComponents (n : ℕ)
    (Γ : (Fin n → ℝ) → ChristoffelSymbols n) (x : Fin n → ℝ)
    (i j k l : Fin n) : ℝ :=
  fderiv ℝ (fun y => Γ y i l j) x (Pi.single k 1)
    - fderiv ℝ (fun y => Γ y i k j) x (Pi.single l 1)
    + ∑ m, (Γ x i k m * Γ x m l j - Γ x i l m * Γ x m k j)

/-- Ricci components: the trace `Ric_jl = Σ_i R^i_jil`. -/
noncomputable def ricciComponents (n : ℕ)
    (Γ : (Fin n → ℝ) → ChristoffelSymbols n) (x : Fin n → ℝ)
    (j l : Fin n) : ℝ :=
  ∑ i, riemannComponents n Γ x i j i l

/-- Scalar curvature: the metric trace of Ricci with inverse metric components
`ginv`, `R = Σ_{j,l} g^{jl} Ric_jl`. -/
noncomputable def scalarCurvature (n : ℕ)
    (Γ : (Fin n → ℝ) → ChristoffelSymbols n)
    (ginv : Fin n → Fin n → ℝ) (x : Fin n → ℝ) : ℝ :=
  ∑ j, ∑ l, ginv j l * ricciComponents n Γ x j l

/-- Inverse Minkowski components: diagonal `(-1, 1, 1, 1)`. -/
noncomputable def minkowskiInverseComponents : Fin 4 → Fin 4 → ℝ :=
  fun i j => if i = j then (if (i : ℕ) = 0 then -1 else 1) else 0
