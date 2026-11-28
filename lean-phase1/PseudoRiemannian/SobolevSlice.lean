/-
Sobolev first slice: weak derivatives, W^{1,2}, and the H^1 bridge statement.
Run: stage2-mathlib-geometry-phase3-sobolev-slice-01.
Baseline: Mathlib v4.36.0, commit fc4f59e577feb1a4956671bc04ac18aaaf8cd842.

Exact statements proved in this file:
- `HasWeakDeriv.unique`: two weak directional derivatives of the same locally
  integrable function on R^n are equal almost everywhere.
- `HasWeakDeriv.iff_integral`: the distribution definition of a weak derivative
  is equivalent to the textbook integration by parts identity against every
  smooth compactly supported test function.
- `HasWeakDeriv.zero`, `HasWeakDeriv.add`, `HasWeakDeriv.smul`: weak derivatives
  are linear, so the W^{1,2} graph is a linear subspace.
- `sobolev_norm_eq`: the norm on the W^{1,2} subspace is the square root of the
  squared L2 norm of the function plus the sum of the squared L2 norms of its
  weak derivatives.
- `sobolev_norm_nonneg`, `sobolev_norm_eq_zero`, `sobolev_norm_add_le`,
  `sobolev_norm_smul`: that norm satisfies the norm axioms.
- `sobolevSpace_isClosed`, `weakFunctional_apply`, `sobolevSpace_complete`:
  W^{1,2} is the intersection of the kernels of the continuous pairing
  functionals, hence closed in the ambient Hilbert sum, hence complete. The
  instances `sobolevInnerProductSpace` and `sobolevCompleteSpace` make it a
  Hilbert space.
- `sobolevBridge`: the H^1 = W^{1,2} bridge, stated as a Prop, not proved, with
  the exact norm comparison and the remaining steps listed in its doc comment.

Novelty tier: Tier 2. Weak derivatives and a first W^{1,2} slice are new
formalizations of known analysis in Lean. They are the first verified step of
Phase 3, not the phase. Nothing here claims a new mathematical result.

State of the art: the classical theory is in Evans, Partial Differential
Equations, 2010, Chapter 5, weak derivatives and Sobolev spaces on R^n and on
domains. The Bessel potential side in Lean is Mathlib v4.36.0,
Mathlib/Analysis/Distribution/Sobolev.lean, following the tempered distribution
layer of arXiv 2510.24060. Mathlib has no weak derivative API and no W^{k,p}
on domains; this file builds the weak route from the distribution API.

Bottleneck gap: the library has no function space tools, so no PDE statement,
energy estimate, or wave equation can even be written down. A researcher who
writes W^{1,2} for a bounded domain gets unknown identifier. This file gives
the first W^{1,2} that Lean accepts, on R^n, with its norm proved and its
Hilbert structure proved.

Lean integrity audit: zero placeholders, no axiom beyond propext,
Classical.choice, Quot.sound. Every new theorem below carries a #print axioms
line, and the outputs are recorded in generator-log-phase3-sobolev-slice.md.

It would be misleading to claim that this slice finishes Phase 3, or that the
H^1 = W^{1,2} bridge is proved, or that W^{1,2} on a bounded domain now
exists in Lean. The bridge is stated only. Embeddings, trace, Poincare,
weighted spaces, and bounded domains are all still open.
-/

import Mathlib.Analysis.Distribution.Distribution
import Mathlib.Analysis.Distribution.Sobolev
import Mathlib.Analysis.Normed.Lp.PiLp
import Mathlib.MeasureTheory.Function.L2Space

open MeasureTheory Distribution
open scoped LineDeriv

noncomputable section

variable {n : ℕ}

/-- A weak directional derivative on R^n, by distributions. `u` has weak
derivative `v` in direction `m` when both are locally integrable on the whole
space and the distributional line derivative of the distribution of `u` equals
the distribution of `v`. Local integrability is a conjunct, not left to the
zero map fallback of `Distribution.ofFun`. -/
def HasWeakDeriv (u v : EuclideanSpace ℝ (Fin n) → ℝ)
    (m : EuclideanSpace ℝ (Fin n)) : Prop :=
  LocallyIntegrableOn u ⊤ volume ∧ LocallyIntegrableOn v ⊤ volume ∧
    ∂_{m} (Distribution.ofFun ⊤ u volume ⊤) = Distribution.ofFun ⊤ v volume ⊤

/-- Local integrability of an L2 representative on the whole space. -/
theorem memLp_locallyIntegrableOn (f : Lp ℝ 2 (volume : Measure (EuclideanSpace ℝ (Fin n)))) :
    LocallyIntegrableOn (f : EuclideanSpace ℝ (Fin n) → ℝ) ⊤ volume :=
  ((Lp.memLp f).locallyIntegrable (by norm_num)).locallyIntegrableOn ⊤

/-- Uniqueness of weak derivatives: two weak derivatives of the same function
in the same direction agree almost everywhere. -/
theorem HasWeakDeriv.unique {u v w : EuclideanSpace ℝ (Fin n) → ℝ}
    {m : EuclideanSpace ℝ (Fin n)} (hv : HasWeakDeriv u v m) (hw : HasWeakDeriv u w m) :
    v =ᵐ[volume] w := by
  have h : Distribution.ofFun ⊤ v volume ⊤ = Distribution.ofFun ⊤ w volume ⊤ := by
    rw [← hv.2.2, ← hw.2.2]
  have h' := Distribution.ofFun_injective hv.2.1 hw.2.1 h
  simpa using h'

/-- Weak derivatives only depend on almost everywhere classes: changing `u`
and `v` on a null set keeps the weak derivative relation. -/
theorem HasWeakDeriv.congr_ae {u u' v v' : EuclideanSpace ℝ (Fin n) → ℝ}
    {m : EuclideanSpace ℝ (Fin n)} (hu : u =ᵐ[volume] u') (hv : v =ᵐ[volume] v')
    (h : HasWeakDeriv u v m) : HasWeakDeriv u' v' m := by
  have hu'' : u =ᵐ[volume.restrict (Set.univ : Set (EuclideanSpace ℝ (Fin n)))] u' := by
    rw [Measure.restrict_univ]; exact hu
  have hv'' : v =ᵐ[volume.restrict (Set.univ : Set (EuclideanSpace ℝ (Fin n)))] v' := by
    rw [Measure.restrict_univ]; exact hv
  refine ⟨LocallyIntegrableOn.congr hu'' h.1, LocallyIntegrableOn.congr hv'' h.2.1, ?_⟩
  have e1 : Distribution.ofFun ⊤ u volume ⊤ = Distribution.ofFun ⊤ u' volume ⊤ :=
    Distribution.ofFun_congr_ae hu''
  have e2 : Distribution.ofFun ⊤ v volume ⊤ = Distribution.ofFun ⊤ v' volume ⊤ :=
    Distribution.ofFun_congr_ae hv''
  rw [← e1, ← e2, h.2.2]

/-- The integration by parts characterization: the distribution definition is
equivalent to the textbook identity against every smooth compactly supported
test function. -/
theorem HasWeakDeriv.iff_integral {u v : EuclideanSpace ℝ (Fin n) → ℝ}
    {m : EuclideanSpace ℝ (Fin n)}
    (hu : LocallyIntegrableOn u ⊤ volume) (hv : LocallyIntegrableOn v ⊤ volume) :
    HasWeakDeriv u v m ↔
      ∀ φ : TestFunction ⊤ ℝ ⊤,
        ∫ x, φ x * v x = -∫ x, lineDeriv ℝ (φ : EuclideanSpace ℝ (Fin n) → ℝ) x m * u x := by
  have hpt : ∀ φ : TestFunction ⊤ ℝ ⊤, ∀ x,
      (-∂_{m} φ) x * u x =
        -(lineDeriv ℝ (φ : EuclideanSpace ℝ (Fin n) → ℝ) x m * u x) := by
    intro φ x
    have h1 : (-∂_{m} φ) x = -lineDeriv ℝ (φ : EuclideanSpace ℝ (Fin n) → ℝ) x m := by
      rw [TestFunction.lineDerivOp_eq_lineDerivCLM (𝕜 := ℝ)]
      simp [TestFunction.lineDerivCLM_apply]
    rw [h1, neg_mul]
  constructor
  · intro h φ
    have e1 : (∂_{m} (Distribution.ofFun ⊤ u volume ⊤)) φ =
        (Distribution.ofFun ⊤ v volume ⊤) φ := by rw [h.2.2]
    rw [Distribution.lineDerivOp_apply_apply, Distribution.ofFun_apply hu,
      Distribution.ofFun_apply hv] at e1
    simp only [smul_eq_mul] at e1
    rw [← e1, integral_congr_ae (Filter.Eventually.of_forall (hpt φ)), integral_neg]
  · intro h
    refine ⟨hu, hv, ?_⟩
    ext φ
    rw [Distribution.lineDerivOp_apply_apply, Distribution.ofFun_apply hu,
      Distribution.ofFun_apply hv]
    simp only [smul_eq_mul]
    rw [integral_congr_ae (Filter.Eventually.of_forall (hpt φ)), integral_neg, h φ]

/-- The zero function has weak derivative zero. -/
theorem HasWeakDeriv.zero {m : EuclideanSpace ℝ (Fin n)} :
    HasWeakDeriv (0 : EuclideanSpace ℝ (Fin n) → ℝ) 0 m := by
  refine ⟨locallyIntegrableOn_zero, locallyIntegrableOn_zero, ?_⟩
  rw [Distribution.ofFun_zero]
  exact LineDeriv.lineDerivOp_zero m

/-- Weak derivatives add. -/
theorem HasWeakDeriv.add {u u' v v' : EuclideanSpace ℝ (Fin n) → ℝ}
    {m : EuclideanSpace ℝ (Fin n)} (h : HasWeakDeriv u v m) (h' : HasWeakDeriv u' v' m) :
    HasWeakDeriv (u + u') (v + v') m := by
  refine ⟨h.1.add h'.1, h.2.1.add h'.2.1, ?_⟩
  rw [Distribution.ofFun_add h.1 h'.1, Distribution.ofFun_add h.2.1 h'.2.1,
    LineDeriv.lineDerivOp_add, h.2.2, h'.2.2]

/-- Weak derivatives scale. -/
theorem HasWeakDeriv.smul {u v : EuclideanSpace ℝ (Fin n) → ℝ}
    {m : EuclideanSpace ℝ (Fin n)} (c : ℝ) (h : HasWeakDeriv u v m) :
    HasWeakDeriv (c • u) (c • v) m := by
  refine ⟨h.1.smul c, h.2.1.smul c, ?_⟩
  rw [Distribution.ofFun_smul c, Distribution.ofFun_smul c, LineDeriv.lineDerivOp_smul, h.2.2]

/-- W^{1,2} on R^n, as a submodule of the (n+1)-fold L2 product. Component 0
is the function, components 1 to n are its weak derivatives in the basis
directions. The PiLp 2 norm on the ambient space is the Hilbert sum norm, so
the inherited norm is the standard W^{1,2} norm. -/
def sobolevSpace (n : ℕ) :
    Submodule ℝ (PiLp 2 (fun _ : Fin (n + 1) =>
      Lp ℝ 2 (volume : Measure (EuclideanSpace ℝ (Fin n))))) where
  carrier := {x | ∀ i : Fin n, HasWeakDeriv
    ((x 0 : Lp ℝ 2 (volume : Measure (EuclideanSpace ℝ (Fin n)))) :
      EuclideanSpace ℝ (Fin n) → ℝ)
    ((x i.succ : Lp ℝ 2 (volume : Measure (EuclideanSpace ℝ (Fin n)))) :
      EuclideanSpace ℝ (Fin n) → ℝ)
    (EuclideanSpace.single i 1)}
  add_mem' := by
    intro x y hx hy i
    have hadd := (hx i).add (hy i)
    apply hadd.congr_ae
    · rw [PiLp.add_apply]
      exact (MeasureTheory.Lp.coeFn_add _ _).symm
    · rw [PiLp.add_apply]
      exact (MeasureTheory.Lp.coeFn_add _ _).symm
  zero_mem' := by
    intro i
    have h0 := HasWeakDeriv.zero (m := EuclideanSpace.single i (1 : ℝ))
    apply h0.congr_ae
    · rw [PiLp.zero_apply]
      exact (MeasureTheory.Lp.coeFn_zero _ _ _).symm
    · rw [PiLp.zero_apply]
      exact (MeasureTheory.Lp.coeFn_zero _ _ _).symm
  smul_mem' := by
    intro c x hx i
    have hs := (hx i).smul c
    apply hs.congr_ae
    · rw [PiLp.smul_apply]
      exact (MeasureTheory.Lp.coeFn_smul _ _).symm
    · rw [PiLp.smul_apply]
      exact (MeasureTheory.Lp.coeFn_smul _ _).symm

/-- The norm formula: the W^{1,2} norm is the square root of the squared L2
norm of the function plus the sum of the squared L2 norms of the weak
derivatives. -/
theorem sobolev_norm_eq {n : ℕ} (x : sobolevSpace n) :
    ‖x‖ = Real.sqrt (‖(x : PiLp 2 (fun _ : Fin (n + 1) =>
      Lp ℝ 2 (volume : Measure (EuclideanSpace ℝ (Fin n))))).ofLp 0‖ ^ 2 +
        ∑ i : Fin n, ‖(x : PiLp 2 (fun _ : Fin (n + 1) =>
          Lp ℝ 2 (volume : Measure (EuclideanSpace ℝ (Fin n))))).ofLp i.succ‖ ^ 2) := by
  have h1 : ‖(x : PiLp 2 (fun _ : Fin (n + 1) =>
      Lp ℝ 2 (volume : Measure (EuclideanSpace ℝ (Fin n)))) )‖ =
        Real.sqrt (∑ j : Fin (n + 1), ‖(x : PiLp 2 (fun _ : Fin (n + 1) =>
          Lp ℝ 2 (volume : Measure (EuclideanSpace ℝ (Fin n))))).ofLp j‖ ^ 2) :=
    PiLp.norm_eq_of_L2 _
  rw [show ‖x‖ = ‖(x : PiLp 2 (fun _ : Fin (n + 1) =>
    Lp ℝ 2 (volume : Measure (EuclideanSpace ℝ (Fin n)))) )‖ from rfl, h1,
    Fin.sum_univ_succ]

/-- The W^{1,2} norm is nonnegative. -/
theorem sobolev_norm_nonneg {n : ℕ} (x : sobolevSpace n) : 0 ≤ ‖x‖ :=
  norm_nonneg x

/-- The W^{1,2} norm vanishes only at zero. -/
theorem sobolev_norm_eq_zero {n : ℕ} (x : sobolevSpace n) : ‖x‖ = 0 ↔ x = 0 :=
  norm_eq_zero

/-- The W^{1,2} norm satisfies the triangle inequality. -/
theorem sobolev_norm_add_le {n : ℕ} (x y : sobolevSpace n) :
    ‖x + y‖ ≤ ‖x‖ + ‖y‖ :=
  norm_add_le x y

/-- The W^{1,2} norm is homogeneous. -/
theorem sobolev_norm_smul {n : ℕ} (c : ℝ) (x : sobolevSpace n) :
    ‖c • x‖ = |c| * ‖x‖ := by
  rw [norm_smul, Real.norm_eq_abs]

set_option maxHeartbeats 400000 in
/-- The complexified L2 function of a W^{1,2} element, as a complex L2
element. Used to form the tempered distribution in the bridge statement. -/
noncomputable def sobolevComplex (n : ℕ) (x : sobolevSpace n) :
    Lp ℂ 2 (volume : Measure (EuclideanSpace ℝ (Fin n))) :=
  ((Lp.memLp ((x : PiLp 2 (fun _ : Fin (n + 1) =>
    Lp ℝ 2 (volume : Measure (EuclideanSpace ℝ (Fin n))))).ofLp 0)).ofReal (K := ℂ)).toLp

/-- The H^1 = W^{1,2} bridge on R^n, stated, not proved. Forward only: for
each W^{1,2} element `x`, with function `u` and weak derivatives `D`, the
tempered distribution of the complexified `u` is a Sobolev function of order
1, and the witness `h` is the Bessel witness itself, the Lp function
representing the order 1 Bessel potential of that distribution, that is
`besselPotential` applied to the complexified distribution equals `h` as a
tempered distribution. The H^1 witness norm equals the W^{1,2} norm with the
exact comparison
`‖h‖ = sqrt (‖u‖^2 + (2 pi)^(-2) * sum_i ‖D_i‖^2)`. The (2 pi) factor comes
from the Mathlib Bessel convention, where the order 1 symbol is
(1 + ‖xi‖^2)^(1/2) and the derivative symbol is 2 pi i xi. This states the
forward direction only. It does not state the reverse direction, no iff over
L2 classes, and no uniqueness of the derivative tuple.
Remaining steps, in order:
1. Read off both symbols in the same Fourier coordinates and fix the norm
   statement. The comparison above is the formula to prove, not a proved fact.
2. Identify the L2 to tempered distribution representation, prove it
   injective, and relate its compact test evaluations to `Distribution.ofFun`.
3. Identify a graph derivative with a tempered derivative, passing from
   equality on compact tests to equality of tempered distributions.
4. Forward from the graph: use the derivative multiplier identity and
   Plancherel to obtain the Bessel witness in L2.
5. Reverse from a witness: recover `u` and `D` by the multipliers 1/b_1 and
   q_i/b_1, proving boundedness from the checked symbols.
6. Apply Plancherel with those same symbols to conclude the norm formula. -/
def sobolevBridge (n : ℕ) : Prop :=
  ∀ x : sobolevSpace n,
    ∃ h : Lp ℂ 2 (volume : Measure (EuclideanSpace ℝ (Fin n))),
      TemperedDistribution.besselPotential (EuclideanSpace ℝ (Fin n)) ℂ 1
          (Lp.toTemperedDistributionCLM ℂ volume 2 (sobolevComplex n x)) = h ∧
      TemperedDistribution.MemSobolev 1 2
        (Lp.toTemperedDistributionCLM ℂ volume 2 (sobolevComplex n x)) ∧
      ‖h‖ = Real.sqrt (‖((x : PiLp 2 (fun _ : Fin (n + 1) =>
          Lp ℝ 2 (volume : Measure (EuclideanSpace ℝ (Fin n)))))) 0‖ ^ 2 +
        ((2 * Real.pi) ^ 2)⁻¹ * ∑ i : Fin n, ‖((x : PiLp 2 (fun _ : Fin (n + 1) =>
          Lp ℝ 2 (volume : Measure (EuclideanSpace ℝ (Fin n)))))) i.succ‖ ^ 2)


/-- A smooth compactly supported test function, viewed as an L2 element. -/
noncomputable def testFunLp {n : ℕ} (φ : TestFunction (E := EuclideanSpace ℝ (Fin n)) ⊤ ℝ ⊤) :
    Lp ℝ 2 (volume : Measure (EuclideanSpace ℝ (Fin n))) :=
  ((TestFunction.hasCompactSupport φ).toSchwartzMap (TestFunction.contDiff φ)).toLp 2 volume

/-- The pairing functional that tests the weak derivative identity in direction `i`
against the test function `φ`. Its kernel is the set of pairs satisfying the
integration-by-parts identity for this `i` and `φ`. -/
noncomputable def weakFunctional {n : ℕ} (i : Fin n)
    (φ : TestFunction (E := EuclideanSpace ℝ (Fin n)) ⊤ ℝ ⊤) :
    (PiLp 2 (fun _ : Fin (n + 1) =>
      Lp ℝ 2 (volume : Measure (EuclideanSpace ℝ (Fin n))))) →L[ℝ] ℝ where
  toFun x := inner ℝ (x.ofLp i.succ) (testFunLp φ) +
    inner ℝ (x.ofLp 0)
      (testFunLp (TestFunction.lineDerivCLM ℝ (EuclideanSpace.single i 1) φ :
        TestFunction (E := EuclideanSpace ℝ (Fin n)) ⊤ ℝ ⊤))
  map_add' x y := by
    simp only [PiLp.add_apply, inner_add_left]
    ring
  map_smul' c x := by
    simp [PiLp.smul_apply, inner_smul_left, mul_add]
  cont := by
    have hcoord : ∀ j : Fin (n + 1),
        Continuous (fun x : PiLp 2 (fun _ : Fin (n + 1) =>
          Lp ℝ 2 (volume : Measure (EuclideanSpace ℝ (Fin n)))) => x.ofLp j) :=
      fun j => (continuous_apply j).comp (PiLp.continuous_ofLp 2 _)
    exact ((hcoord i.succ).inner continuous_const).add ((hcoord 0).inner continuous_const)

/-- The functional, written out as the two integrals of the integration-by-parts
identity. -/
theorem weakFunctional_apply {n : ℕ} (i : Fin n)
    (φ : TestFunction (E := EuclideanSpace ℝ (Fin n)) ⊤ ℝ ⊤)
    (x : PiLp 2 (fun _ : Fin (n + 1) =>
      Lp ℝ 2 (volume : Measure (EuclideanSpace ℝ (Fin n))))) :
    weakFunctional i φ x =
      (∫ a, (x.ofLp i.succ : EuclideanSpace ℝ (Fin n) → ℝ) a * φ a) +
        ∫ a, (x.ofLp 0 : EuclideanSpace ℝ (Fin n) → ℝ) a *
          lineDeriv ℝ (φ : EuclideanSpace ℝ (Fin n) → ℝ) a (EuclideanSpace.single i 1) := by
  have hφ : ((testFunLp φ : Lp ℝ 2 (volume : Measure (EuclideanSpace ℝ (Fin n)))) :
      EuclideanSpace ℝ (Fin n) → ℝ) =ᵐ[volume] (φ : EuclideanSpace ℝ (Fin n) → ℝ) :=
    SchwartzMap.coeFn_toLp _ 2 volume
  have hdφ : ((testFunLp (TestFunction.lineDerivCLM ℝ (EuclideanSpace.single i 1) φ :
        TestFunction (E := EuclideanSpace ℝ (Fin n)) ⊤ ℝ ⊤) :
      Lp ℝ 2 (volume : Measure (EuclideanSpace ℝ (Fin n)))) :
      EuclideanSpace ℝ (Fin n) → ℝ) =ᵐ[volume]
      ((TestFunction.lineDerivCLM ℝ (EuclideanSpace.single i 1) φ :
        TestFunction (E := EuclideanSpace ℝ (Fin n)) ⊤ ℝ ⊤) :
        EuclideanSpace ℝ (Fin n) → ℝ) :=
    SchwartzMap.coeFn_toLp _ 2 volume
  have hderiv : ∀ a : EuclideanSpace ℝ (Fin n),
      ((TestFunction.lineDerivCLM ℝ (EuclideanSpace.single i 1) φ :
        TestFunction (E := EuclideanSpace ℝ (Fin n)) ⊤ ℝ ⊤) :
        EuclideanSpace ℝ (Fin n) → ℝ) a =
      lineDeriv ℝ (φ : EuclideanSpace ℝ (Fin n) → ℝ) a (EuclideanSpace.single i 1) := by
    intro a
    simp [TestFunction.lineDerivCLM_apply]
  have hinner : ∀ p q : ℝ, inner ℝ p q = q * p := fun p q => by
    rw [RCLike.inner_apply]
    simp
  have e1 : (∫ a, (testFunLp φ : EuclideanSpace ℝ (Fin n) → ℝ) a *
        (x.ofLp i.succ : EuclideanSpace ℝ (Fin n) → ℝ) a) =
      ∫ a, (x.ofLp i.succ : EuclideanSpace ℝ (Fin n) → ℝ) a * φ a := by
    apply integral_congr_ae
    filter_upwards [hφ] with a ha
    rw [ha]
    exact mul_comm _ _
  have e2 : (∫ a, (testFunLp (TestFunction.lineDerivCLM ℝ (EuclideanSpace.single i 1) φ :
        TestFunction (E := EuclideanSpace ℝ (Fin n)) ⊤ ℝ ⊤) :
        EuclideanSpace ℝ (Fin n) → ℝ) a * (x.ofLp 0 : EuclideanSpace ℝ (Fin n) → ℝ) a) =
      ∫ a, (x.ofLp 0 : EuclideanSpace ℝ (Fin n) → ℝ) a *
        lineDeriv ℝ (φ : EuclideanSpace ℝ (Fin n) → ℝ) a (EuclideanSpace.single i 1) := by
    apply integral_congr_ae
    filter_upwards [hdφ] with a ha
    rw [ha, hderiv a]
    exact mul_comm _ _
  show inner ℝ (x.ofLp i.succ) (testFunLp φ) +
      inner ℝ (x.ofLp 0)
        (testFunLp (TestFunction.lineDerivCLM ℝ (EuclideanSpace.single i 1) φ :
          TestFunction (E := EuclideanSpace ℝ (Fin n)) ⊤ ℝ ⊤)) = _
  rw [L2.inner_def, L2.inner_def]
  simp only [hinner]
  rw [e1, e2]

/-- W^{1,2} is closed in the ambient Hilbert sum: it is the intersection of the
kernels of the pairing functionals, and each kernel is closed. -/
theorem sobolevSpace_isClosed {n : ℕ} :
    IsClosed (↑(sobolevSpace n) : Set (PiLp 2 (fun _ : Fin (n + 1) =>
      Lp ℝ 2 (volume : Measure (EuclideanSpace ℝ (Fin n)))))) := by
  have hset : ((sobolevSpace n : Submodule ℝ (PiLp 2 (fun _ : Fin (n + 1) =>
      Lp ℝ 2 (volume : Measure (EuclideanSpace ℝ (Fin n)))))) : Set _) =
      ⋂ (i : Fin n) (φ : TestFunction (E := EuclideanSpace ℝ (Fin n)) ⊤ ℝ ⊤),
        ((weakFunctional i φ).ker : Set (PiLp 2 (fun _ : Fin (n + 1) =>
          Lp ℝ 2 (volume : Measure (EuclideanSpace ℝ (Fin n)))))) := by
    ext x
    simp only [Set.mem_iInter, SetLike.mem_coe, LinearMap.mem_ker]
    constructor
    · intro hx i φ
      show weakFunctional i φ x = 0
      have hx' : ∀ j : Fin n, HasWeakDeriv
          ((x.ofLp 0 : Lp ℝ 2 (volume : Measure (EuclideanSpace ℝ (Fin n)))) :
            EuclideanSpace ℝ (Fin n) → ℝ)
          ((x.ofLp j.succ : Lp ℝ 2 (volume : Measure (EuclideanSpace ℝ (Fin n)))) :
            EuclideanSpace ℝ (Fin n) → ℝ)
          (EuclideanSpace.single j 1) := hx
      have hiff := (HasWeakDeriv.iff_integral (memLp_locallyIntegrableOn (x.ofLp 0))
        (memLp_locallyIntegrableOn (x.ofLp i.succ))).mp (hx' i) φ
      rw [weakFunctional_apply]
      have e1 : (∫ a, (x.ofLp i.succ : EuclideanSpace ℝ (Fin n) → ℝ) a * φ a) =
          ∫ a, φ a * (x.ofLp i.succ : EuclideanSpace ℝ (Fin n) → ℝ) a :=
        integral_congr_ae (Filter.Eventually.of_forall fun a => mul_comm _ _)
      have e2 : (∫ a, (x.ofLp 0 : EuclideanSpace ℝ (Fin n) → ℝ) a *
            lineDeriv ℝ (φ : EuclideanSpace ℝ (Fin n) → ℝ) a (EuclideanSpace.single i 1)) =
          ∫ a, lineDeriv ℝ (φ : EuclideanSpace ℝ (Fin n) → ℝ) a (EuclideanSpace.single i 1) *
            (x.ofLp 0 : EuclideanSpace ℝ (Fin n) → ℝ) a :=
        integral_congr_ae (Filter.Eventually.of_forall fun a => mul_comm _ _)
      rw [e1, e2, hiff]
      exact neg_add_cancel _
    · intro h i
      apply (HasWeakDeriv.iff_integral (memLp_locallyIntegrableOn (x.ofLp 0))
        (memLp_locallyIntegrableOn (x.ofLp i.succ))).mpr
      intro φ
      have h0 : weakFunctional i φ x = 0 := h i φ
      rw [weakFunctional_apply] at h0
      have e1 : (∫ a, (x.ofLp i.succ : EuclideanSpace ℝ (Fin n) → ℝ) a * φ a) =
          ∫ a, φ a * (x.ofLp i.succ : EuclideanSpace ℝ (Fin n) → ℝ) a :=
        integral_congr_ae (Filter.Eventually.of_forall fun a => mul_comm _ _)
      have e2 : (∫ a, (x.ofLp 0 : EuclideanSpace ℝ (Fin n) → ℝ) a *
            lineDeriv ℝ (φ : EuclideanSpace ℝ (Fin n) → ℝ) a (EuclideanSpace.single i 1)) =
          ∫ a, lineDeriv ℝ (φ : EuclideanSpace ℝ (Fin n) → ℝ) a (EuclideanSpace.single i 1) *
            (x.ofLp 0 : EuclideanSpace ℝ (Fin n) → ℝ) a :=
        integral_congr_ae (Filter.Eventually.of_forall fun a => mul_comm _ _)
      rw [e1, e2] at h0
      exact eq_neg_of_add_eq_zero_left h0
  rw [hset]
  apply isClosed_iInter
  intro i
  apply isClosed_iInter
  intro φ
  exact (weakFunctional i φ).isClosed_ker

/-- The inner product on W^{1,2}, inherited from the ambient Hilbert sum. -/
noncomputable instance sobolevInnerProductSpace {n : ℕ} :
    InnerProductSpace ℝ (sobolevSpace n) :=
  inferInstance

/-- W^{1,2} is complete, because it is a closed subspace of a Hilbert space. -/
noncomputable instance sobolevCompleteSpace {n : ℕ} : CompleteSpace (sobolevSpace n) :=
  @IsClosed.completeSpace_coe _ _ _ _ sobolevSpace_isClosed

/-- W^{1,2} is complete. The inner product is the instance `sobolevInnerProductSpace`
above, inherited from the ambient Hilbert sum, so together the two make W^{1,2} a
Hilbert space. -/
theorem sobolevSpace_complete {n : ℕ} : CompleteSpace (sobolevSpace n) :=
  inferInstance

end

#print axioms HasWeakDeriv.unique
#print axioms memLp_locallyIntegrableOn
#print axioms HasWeakDeriv.congr_ae
#print axioms HasWeakDeriv.iff_integral
#print axioms HasWeakDeriv.zero
#print axioms HasWeakDeriv.add
#print axioms HasWeakDeriv.smul
#print axioms sobolev_norm_eq
#print axioms sobolev_norm_nonneg
#print axioms sobolev_norm_eq_zero
#print axioms sobolev_norm_add_le
#print axioms sobolev_norm_smul
#print axioms sobolevSpace_complete
#print axioms weakFunctional_apply
#print axioms sobolevSpace_isClosed
