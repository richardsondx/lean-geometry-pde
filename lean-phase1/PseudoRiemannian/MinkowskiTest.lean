/-
Copyright (c) 2026 Richardson Dackam. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.

# Minkowski property test

What is proved here, for the Minkowski metric on `R^4` with signature `(3, 1)`:
the Levi-Civita Christoffel symbols vanish, the connection is torsion-free and
metric-compatible, and the Riemann, Ricci and scalar curvature coordinate
components are all zero.

What this does NOT prove: zero Riemann / Ricci / scalar curvature in general, a
general-manifold Levi-Civita connection, or anything about Sobolev theory, Einstein
equations, or Kerr stability. Riemann, Ricci and scalar here are the coordinate
component definitions in `PseudoRiemannian.LeviCivita`, on `R^4` only.

Novelty tier: Tier 2, incremental API.

Lean 4.36.0, Mathlib v4.36.0.
-/

import PseudoRiemannian.Metric
import PseudoRiemannian.LeviCivita

open Module Finset

/-- The Minkowski metric has signature `(3, 1)`: its type already says so, and its
form is the explicit four-term sum, diagonal `(-1, 1, 1, 1)`, coordinate `0`
timelike. -/
theorem minkowski_signature_check (v w : Fin 4 → ℝ) :
    minkowskiMetric.form v w = - v 0 * w 0 + v 1 * w 1 + v 2 * w 2 + v 3 * w 3 :=
  minkowskiMetric_apply v w

/-- Christoffel symbols vanish for Minkowski. -/
theorem minkowski_christoffel_eq_zero (x : Fin 4 → ℝ) (i k j : Fin 4) :
    flatChristoffel 4 x i k j = 0 :=
  rfl

/-- The Minkowski Levi-Civita connection is torsion-free. -/
theorem minkowski_torsionFree (x : Fin 4 → ℝ) :
    IsTorsionFree (flatChristoffel 4 x) :=
  flatChristoffel_torsionFree 4 x

/-- The Minkowski Levi-Civita connection is metric-compatible. -/
theorem minkowski_metricCompatible (x : Fin 4 → ℝ) :
    IsMetricCompatible 4 minkowskiMetric.constantComponents (flatChristoffel 4 x) :=
  flatChristoffel_metricCompatible minkowskiMetric x

/-- Riemann components vanish for Minkowski: every `Γ` term and every partial
derivative of `Γ` is zero. -/
theorem minkowski_riemann_eq_zero (x : Fin 4 → ℝ) (i j k l : Fin 4) :
    riemannComponents 4 (flatChristoffel 4) x i j k l = 0 := by
  unfold riemannComponents
  have h1 : (fun y : Fin 4 → ℝ => flatChristoffel 4 y i l j)
      = Function.const (Fin 4 → ℝ) 0 := rfl
  have h2 : (fun y : Fin 4 → ℝ => flatChristoffel 4 y i k j)
      = Function.const (Fin 4 → ℝ) 0 := rfl
  rw [h1, h2, fderiv_const]
  simp [flatChristoffel]

/-- Ricci components vanish for Minkowski: they are sums of zero Riemann
components. -/
theorem minkowski_ricci_eq_zero (x : Fin 4 → ℝ) (j l : Fin 4) :
    ricciComponents 4 (flatChristoffel 4) x j l = 0 := by
  simp [ricciComponents, minkowski_riemann_eq_zero]

/-- Scalar curvature vanishes for Minkowski: it is a sum of inverse-metric
components times zero Ricci components. -/
theorem minkowski_scalar_eq_zero (x : Fin 4 → ℝ) :
    scalarCurvature 4 (flatChristoffel 4) minkowskiInverseComponents x = 0 := by
  simp [scalarCurvature, minkowski_ricci_eq_zero]

#print axioms minkowski_christoffel_eq_zero
#print axioms minkowski_torsionFree
#print axioms minkowski_metricCompatible
#print axioms minkowski_riemann_eq_zero
#print axioms minkowski_ricci_eq_zero
#print axioms minkowski_scalar_eq_zero
#print axioms minkowski_leviCivita
