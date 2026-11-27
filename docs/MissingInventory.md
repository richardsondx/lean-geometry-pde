# docs/MissingInventory.md

Date: 26 Nov 2026. Run: stage2-mathlib-geometry-phase1-planning-01.
Author: Gemini 4 Neon, model google/gemini-4-neon, as architect, for structure.
All statuses verified by the generator by grep in the local Mathlib v4.23.0 tree.
Status: planning only. No Lean code in this file. No proof claimed.

How to read this file: the inventory is verbatim Neon output from neon-log.md
call 4, section 2. The generator verification block at the end is not Neon output.

## Section 2: Missing Inventory Structure (verbatim Neon)

* **Audit scope:** All statuses below come from the 26 Nov 2026 grep audit over the full Mathlib v4.23.0 tree. None of these 15 items are verified as satellite deliverables. Newer-Mathlib presence is noted only where explicitly verified above (`CovariantDerivative` / `IsLeviCivitaConnection` in v4.29.0 and v4.36.0; `Sobolev.lean` / `TemperedDistribution.lean` in v4.36.0).
* **Differential forms:** absent (0 hits for a `DifferentialForm` definition; 0 hits in `Geometry/Manifold` for `ContinuousAlternatingMap`). Nearest present neighbour: `ExteriorAlgebra`, `ExteriorPower`, and alternating maps in linear algebra.
* **Exterior derivative:** absent (0 hits). Nearest present neighbour: `ExteriorPower` and `ExteriorAlgebra` in linear algebra.
* **Volume forms:** absent on manifolds. Nearest present neighbour: flat-space `volumeForm` at `Mathlib/Analysis/InnerProductSpace/Orientation.lean:166`.
* **Manifold integration:** absent (no volume measure on manifolds). Nearest present neighbour: Bochner integral on measure spaces.
* **Stokes theorem:** absent as a manifold theorem. Nearest present neighbour: flat box divergence theorem `hasIntegral_GP_divergence_of_forall_hasDerivWithinAt` at `Mathlib/Analysis/BoxIntegral/DivergenceTheorem.lean:258`.
* **Geodesics:** absent (no `Geodesic` definition, no geometric exponential map: `expMap` returns 0 hits in `Mathlib/Geometry/Manifold`; tree-wide `expMap` returns 192 hits, 189 of them a number-field expMap in `Mathlib/NumberTheory/NumberField/CanonicalEmbedding/NormLeOne.lean`, unrelated to geodesics; matches for "geodesic" are combinatorics and group theory false positives). Nearest present neighbour: Picard-Lindelof and Gronwall (plus `CovariantDerivative` / `IsLeviCivitaConnection` on upgrade to v4.29.0 or v4.36.0).
* **Curvature:** absent (0 hits for Riemann curvature or `Ricci`; the string `Riemann` returns 336 hits tree-wide, all Riemann-integral or Riemannian-adjective uses, none of them Riemann curvature). Nearest present neighbour: manifold vector-field and bundle modules (`Tangent`, `SmoothSection`, `VectorField/LieBracket`), plus `CovariantDerivative` (`Basic.lean:366`) and `IsLeviCivitaConnection` on upgrade to v4.29.0 or v4.36.0.
* **Laplace-Beltrami operators:** absent as such. Nearest present neighbour: flat `laplacian` at `Mathlib/Analysis/InnerProductSpace/Laplacian.lean:135` and `laplacianWithin` at `Mathlib/Analysis/InnerProductSpace/Laplacian.lean:124`.
* **Weak derivatives:** absent (0 hits for `HasWeakDeriv`, `WeakDeriv`, or `HasDistribDeriv`). Nearest present neighbour: v4.23.0 `Distribution` directory (`AEEqOfIntegralContDiff.lean`, `FourierSchwartz.lean`, `SchwartzSpace.lean`), `SchwartzMap`, and Fourier transform (plus `TemperedDistribution.lean` on upgrade to v4.36.0).
* **W^{k,p} spaces on domains:** absent. Nearest present neighbour: Sobolev inequality `eLpNorm_le_eLpNorm_fderiv_one` at `Mathlib/Analysis/FunctionalSpaces/SobolevInequality.lean:437` and Lp spaces (v4.36.0 adds `Mathlib/Analysis/Distribution/Sobolev.lean` with `TemperedDistribution.MemSobolev` and `besselPotential`, not verified as domain W^{k,p} spaces).
* **Compact embeddings:** absent (0 hits for `Rellich` or `CompactEmbedding`). Nearest present neighbour: `Mathlib/Analysis/FunctionalSpaces/SobolevInequality.lean:437` (`eLpNorm_le_eLpNorm_fderiv_one`) and Lp spaces.
* **Lax-Milgram:** present, `continuousLinearEquivOfBilin` at `Mathlib/Analysis/InnerProductSpace/LaxMilgram.lean:102`.
* **Elliptic PDE infrastructure:** absent (no `Mathlib/Analysis/PDE` directory; "elliptic" hits are unrelated complex analysis and special functions). Nearest present neighbour: Lax-Milgram (`Mathlib/Analysis/InnerProductSpace/LaxMilgram.lean:102`) and flat `laplacian` / `laplacianWithin` (`Mathlib/Analysis/InnerProductSpace/Laplacian.lean:135`, `:124`).
* **Parabolic PDE infrastructure:** absent (no `Mathlib/Analysis/PDE` directory; "parabolic" hits are unrelated complex analysis and special functions). Nearest present neighbour: flat `laplacian` (`Mathlib/Analysis/InnerProductSpace/Laplacian.lean:135`), Picard-Lindelof, Gronwall, `SchwartzMap`, and Fourier transform.
* **Hyperbolic PDE infrastructure:** absent (no `Mathlib/Analysis/PDE` directory; "hyperbolic" hits are unrelated complex analysis and special functions). Nearest present neighbour: flat `laplacian` (`Mathlib/Analysis/InnerProductSpace/Laplacian.lean:135`), Picard-Lindelof, Gronwall, `SchwartzMap`, and Fourier transform.

## Generator verification (not Neon output)

- Every status above was re-checked by the generator with grep over the local
  v4.23.0 tree on 26 Nov 2026. Line numbers confirmed: volumeForm at
  Orientation.lean:166; divergence theorem at DivergenceTheorem.lean:258;
  laplacian at Laplacian.lean:135, laplacianWithin at :124; Lax-Milgram
  continuousLinearEquivOfBilin at LaxMilgram.lean:102; Sobolev inequality
  eLpNorm_le_eLpNorm_fderiv_one at SobolevInequality.lean:437.
- Geodesic grep returned only Mathlib/Combinatorics/Quiver/Arborescence.lean
  and Mathlib/GroupTheory/FreeGroup/NielsenSchreier.lean, both false positives.
  `expMap` returns 192 hits tree-wide (189 in
  Mathlib/NumberTheory/NumberField/CanonicalEmbedding/NormLeOne.lean, 3 in
  Mathlib/Analysis/SpecialFunctions/Complex/Circle.lean) and 0 hits in
  Mathlib/Geometry/Manifold, so no geometric exponential map exists there.
  Counts re-verified by grep in fix cycle 1.
- Curvature grep returned 0 hits for Riemann curvature or Ricci in the whole
  tree. The string `Riemann` returns 336 hits tree-wide, all Riemann-integral
  or Riemannian-adjective uses. Counts re-verified by grep in fix cycle 1.
- Compact embedding grep returned 0 hits for Rellich or CompactEmbedding.
- No Mathlib/Analysis/PDE directory exists in v4.23.0.
- Count check: Neon's "15 items" is correct. The list has 15 entries:
  12 named topics plus elliptic, parabolic, and hyperbolic PDE infrastructure
  counted separately.
- The v4.36.0 notes in this inventory cover only CovariantDerivative,
  IsLeviCivitaConnection, Sobolev.lean, and TemperedDistribution.lean, which
  were verified by the generator. No other item above was checked against
  v4.36.0. The re-audit of the absent items on v4.36.0 is open work, owned by
  the Phase 1 lead, before the baseline move is executed.
