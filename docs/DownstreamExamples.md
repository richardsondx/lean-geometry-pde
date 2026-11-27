# docs/DownstreamExamples.md

Date: 26 Nov 2026. Run: stage2-mathlib-geometry-phase1-planning-01.
Author: GPT-6.2 Astra, model openai/gpt-6.2-astra, as mathematician.
Baseline: Lean 4.23.0, Mathlib v4.23.0, local tree commit 37df177aaa770670452312393d4e84aaad56e7b6.
Status: planning only. No Lean code in this file beyond the quoted probe lines that were run.
No proof claimed.

How to read this file: the four examples are verbatim Astra output from astra-log.md
call 1. The generator verification block at the end is not Astra output. It records
the exact probe commands and errors, run by the generator.

## Section 1. Downstream examples

- **Levi-Civita.** Given a smooth finite-dimensional Riemannian metric, state that there exists a unique torsion-free, metric-compatible covariant derivative on the tangent bundle. In v4.23.0, probe A1 stops at the type of the witness: `#check @CovariantDerivative` reports `Unknown identifier` after importing `Mathlib.Geometry.Manifold.VectorBundle.Riemannian`. The later API supplies `CovariantDerivative`, the predicate `IsLeviCivitaConnection`, and the chosen `LeviCivitaConnection`; v4.36.0 also has the uniqueness theorem. This example does not require curvature.
- **Sobolev, Bessel route.** For a tempered distribution `u` on `R^d`, state that `u` belongs to `H^0` if and only if its Fourier transform is represented by an `L^2` function. Probe A2 fails on `#check @TemperedDistribution.MemSobolev` after importing `Mathlib.Analysis.Distribution.SchwartzSpace`. The requested API is `TemperedDistribution.MemSobolev` with the Bessel characterization: at order `s`, the distribution `(1+|xi|^2)^{s/2} u-hat` is represented by an `L^2` function. Order zero is the minimal test; it needs no weak-derivative API.
- **Hilbert6 portability.** Under the hypotheses of the pinned Hilbert6 construction, state that its chosen `leviCivita` satisfies `IsLeviCivitaFor` for the input metric. Checking that statement against v4.23.0 stops before either name is defined: the first import of the Hilbert6 LeviCivita file at `ddbe9da` is `Mathlib.Geometry.Manifold.VectorBundle.CovariantDerivative.Torsion`, absent in that tree. The immediate unblocker is the compatible covariant-derivative and torsion API expected by that import. The file itself supplies `koszulConnection`, `exists_isLeviCivitaFor`, and `leviCivita`.
- **Metric interop.** Given a smooth finite-dimensional metric `g` of signature `(n,0)`, state that the squared fiber norm obtained through its Riemannian registration equals `g_b(v,v)`. This is a conversion and instance-coherence obligation, not a recorded failed probe. The target is `Bundle.ContMDiffRiemannianMetric` at `Mathlib/Geometry/Manifold/VectorBundle/Riemannian.lean:238`; its registration follows the structure. A second `Bundle.RiemannianBundle` alongside that registration gives competing choices of metric and hence of fiber `NormedAddCommGroup` and `InnerProductSpace`. Typeclass search choosing one does not make both norms definitionally equal. With no registration, neither the fiber norm nor the `InnerProductSpace` is supplied by this metric. For a tangent metric, results about `Manifold.riemannianEDist` and the `IsRiemannianManifold` equality then cannot be used through this metric either. Registration alone does not prove that equality.

## Generator verification (not Astra output)

Probes run by the generator, 26 Nov 2026, with `lake env lean` from
~/workspace/kerr-stability-lean/kerr-mathlib, PATH including ~/.elan/bin.
Astra's "probe A1" is probe 1 here, "probe A2" is probe 2.

- Probe 1: file imports Mathlib.Geometry.Manifold.VectorBundle.Riemannian, line
  `#check @CovariantDerivative`, error: `Unknown identifier CovariantDerivative`.
- Probe 2: file imports Mathlib.Analysis.Distribution.SchwartzSpace, line
  `#check @TemperedDistribution.MemSobolev`, error:
  `Unknown identifier TemperedDistribution.MemSobolev`.
- Probe 3: same import, line `#check @HasWeakDerivAt`, error:
  `Unknown identifier HasWeakDerivAt`. HasWeakDerivAt was a probe name only.
  No weak-derivative API was found by grep under any name checked in v4.23.0.
- Probe 4: file imports Mathlib.Geometry.Manifold.Riemannian.Basic, line
  `#check @MeasureTheory.integral_stokes`, error:
  `Unknown identifier MeasureTheory.integral_stokes`.
- An earlier probe attempt using `import Mathlib` failed for a different reason:
  the full Mathlib olean is not built in this tree
  (`Mathlib.olean does not exist`). The four probes above use single-module
  imports, as the Phase 0 audit file does.
- Hilbert6 first import confirmed by reading the pinned file:
  Hilbert6/Geometry/PseudoRiemannian/LeviCivita.lean, commit ddbe9da,
  first import `Mathlib.Geometry.Manifold.VectorBundle.CovariantDerivative.Torsion`,
  which has no directory in v4.23.0.
- PR 36128 unblocking API confirmed from the PR head (8968a1246):
  CovariantDerivative structure at Basic.lean:276, IsLeviCivitaConnection as a
  Prop at LeviCivita.lean:199, LeviCivitaConnection at LeviCivita.lean:859,
  ChristoffelSymbol at LeviCivita.lean:881. The PR defines no Riemann curvature.
- Example 4 has no failing Lean probe, because PseudoRiemannianMetric does not
  exist in Mathlib at all. Its failure is at the level of the structure fields,
  shown in docs/InteropExample.md.
- Superseded draft: Neon also drafted these four examples in its call 3
  (neon-log.md). Astra's versions above are authoritative for the math content,
  per the role split. Neon's draft is kept in the log only.
