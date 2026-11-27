/-
Mathlib inventory for Phase 0 of the Mathlib geometry and PDE plan.
Baseline: Lean 4.23.0, Mathlib v4.23.0.
Local tree checked: ~/workspace/kerr-stability-lean/kerr-mathlib/.lake/packages/mathlib
Run with: cd ~/workspace/kerr-stability-lean/kerr-mathlib && lake env lean <this file>
Method: every #check below was run live against that tree on 26 Nov 2026.
Lines that failed are commented out with the exact Lean error recorded,
and the verdict for each item is in Audit/inventory.md.
No names were invented: a failed #check is recorded as confirmed absent,
never repaired by guessing.
Verification runs: four probe files, one per topic, run 26 Nov 2026
against the same tree (probe1 manifold 186s, probe2 Riemannian 22s,
probe3 measure 13s, probe4 ODE 12s). Probe logs in /tmp/probes/.
Result: 33 of 43 #check lines compiled, 10 failed with
"Unknown identifier". The 33 live lines in this file compile clean.
-/

import Mathlib.Geometry.Manifold.ChartedSpace
import Mathlib.Geometry.Manifold.IsManifold.Basic
import Mathlib.Geometry.Manifold.ContMDiff.Defs
import Mathlib.Topology.VectorBundle.Basic
import Mathlib.Topology.VectorBundle.Riemannian
import Mathlib.Geometry.Manifold.VectorBundle.Riemannian
import Mathlib.Geometry.Manifold.VectorBundle.Tangent
import Mathlib.Geometry.Manifold.VectorField.LieBracket
import Mathlib.Geometry.Manifold.IntegralCurve.Basic
import Mathlib.Geometry.Manifold.Algebra.LieGroup
import Mathlib.Geometry.Manifold.Riemannian.Basic
import Mathlib.MeasureTheory.Integral.Bochner.Basic
import Mathlib.MeasureTheory.Function.LpSpace.Basic
import Mathlib.MeasureTheory.Function.LpSeminorm.TriangleInequality
import Mathlib.MeasureTheory.Function.LpSeminorm.CompareExp
import Mathlib.MeasureTheory.Integral.Prod
import Mathlib.MeasureTheory.Measure.Prod
import Mathlib.Analysis.Fourier.FourierTransform
import Mathlib.Analysis.Distribution.SchwartzSpace
import Mathlib.Analysis.FunctionalSpaces.SobolevInequality
import Mathlib.Analysis.Normed.Module.Basic
import Mathlib.Topology.UniformSpace.Cauchy
import Mathlib.Analysis.InnerProductSpace.Defs
import Mathlib.Analysis.ODE.PicardLindelof
import Mathlib.Analysis.ODE.Gronwall

/-! ### Smooth manifolds -/

#check @ChartedSpace
#check @IsManifold
#check @ModelWithCorners
#check @ContMDiff
#check @TangentBundle
#check @TangentSpace
#check @VectorBundle
#check @VectorField.mlieBracket
#check @IsMIntegralCurve
#check @LieGroup

/-! ### Names the plan uses that are not in v4.23.0 -/

-- #check @SmoothManifoldWithCorners
-- error(lean.unknownIdentifier): Unknown identifier `SmoothManifoldWithCorners`
-- The class is `IsManifold`. `SmoothManifoldWithCorners` does not exist in v4.23.0.
-- #check @AnalyticManifold
-- error(lean.unknownIdentifier): Unknown identifier `AnalyticManifold`
-- Mathlib/Geometry/Manifold/AnalyticManifold.lean is a deprecated shim:
-- "Analytic manifolds are deprecated, use `IsManifold I ω M`" (since 2025-04-13).

/-! ### Riemannian manifolds -/

#check @Bundle.RiemannianBundle
#check @Bundle.ContMDiffRiemannianMetric
#check @IsContMDiffRiemannianBundle
#check @IsRiemannianManifold
#check @Manifold.riemannianEDist

/-! ### Covariant derivative and Levi-Civita (PR 36128, open, not merged) -/

-- #check @CovariantDerivative
-- error(lean.unknownIdentifier): Unknown identifier `CovariantDerivative`
-- #check @IsLeviCivitaConnection
-- error(lean.unknownIdentifier): Unknown identifier `IsLeviCivitaConnection`
-- #check @LeviCivitaConnection
-- error(lean.unknownIdentifier): Unknown identifier `LeviCivitaConnection`
-- #check @ChristoffelSymbol
-- error(lean.unknownIdentifier): Unknown identifier `ChristoffelSymbol`
-- All four are added by PR 36128, which is open and unmerged as of 26 Nov 2026
-- (GitHub API: state open, merged false, merged_at null).

/-! ### Satellite: Hamilton three-manifold project, not in Mathlib -/

-- #check @SmoothRiemannianMetric
-- error(lean.unknownIdentifier): Unknown identifier `SmoothRiemannianMetric`
-- Confirmed in the Hamilton three-manifold formalization, arXiv 2608.21502,
-- repo https://github.com/qinz1yang/differential-geometry, release 0.1.0.

/-! ### Measure, Lp, Bochner -/

#check @MeasureTheory.integral
#check @MeasureTheory.MemLp
#check @MeasureTheory.Lp
#check @MeasureTheory.eLpNorm_add_le
#check @MeasureTheory.MemLp.mul
#check @MeasureTheory.integral_prod
#check @MeasureTheory.lintegral_prod

/-! ### Fourier, Schwartz, tempered distributions, Sobolev -/

#check @VectorFourier.fourierIntegral
#check @SchwartzMap
-- #check @TemperedDistribution
-- error(lean.unknownIdentifier): Unknown identifier `TemperedDistribution`
-- #check @TemperedDistribution.MemSobolev
-- error(lean.unknownIdentifier): Unknown identifier `TemperedDistribution.MemSobolev`
-- #check @BesselPotentialSpace
-- error(lean.unknownIdentifier): Unknown identifier `BesselPotentialSpace`
-- No Sobolev space file exists in v4.23.0. The plan's claim that
-- Mathlib/Analysis/Distribution/Sobolev exists is wrong for this version.
-- Only the Sobolev inequality below exists.
#check @MeasureTheory.eLpNorm_le_eLpNorm_fderiv_one

/-! ### Functional analysis -/

#check @NormedSpace
#check @CompleteSpace
#check @InnerProductSpace
#check @NormedAddCommGroup

/-! ### ODE -/

#check @IsPicardLindelof
#check @IsPicardLindelof.exists_eq_forall_mem_Icc_hasDerivWithinAt
#check @gronwallBound
#check @le_gronwallBound_of_liminf_deriv_right_le
