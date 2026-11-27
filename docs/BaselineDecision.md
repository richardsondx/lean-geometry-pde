# docs/BaselineDecision.md

Date: 26 Nov 2026. Run: stage2-mathlib-geometry-phase1-planning-01.
Author: Gemini 4 Neon, model google/gemini-4-neon, as architect.
Status: planning only. No Lean code in this file. No proof claimed.
Answers GAP-4b and GAP-4d from Phase 0, and GAP-5b.

How to read this file: the decision is verbatim Neon output from neon-log.md
call 4, section 1. The generator verification block at the end is not Neon output.

## Section 1: Baseline Decision (verbatim Neon)

* **Target revision recommendation (answers GAP-4d):** Move from the local baseline (Lean 4.23.0, Mathlib v4.23.0, commit `37df177aaa770670452312393d4e84aaad56e7b6`) to Mathlib v4.36.0 (latest release, published 16 Nov 2026). Do not stay on v4.23.0 with a vendored PR 36128, and do not stop at v4.29.0.
* **Reason for target baseline (answers GAP-4d):** Mathlib v4.36.0 supplies both the upstream covariant derivative / Levi-Civita API and the upstream Sobolev Bessel distribution layer without carrying a large, unmerged backport. It also aligns closely with active satellite branches (Hilbert6 on Lean 4.35.0, Mathlib rev `56a005855ea1`; Hamilton three-manifold current main on Lean v4.35.0-rc3).
* **PR 36128 vendoring cost (answers GAP-4b):** PR 36128 (`Levicivita minimal`, created 4 Mar 2026, last updated 19 Sep 2026, head `8968a1246e09fbe77e70282027173874e5c3f437`, base `master`) remains open, `merged` false, and `mergeable` false. Vendoring it onto v4.23.0 requires porting 13 files (3,901 new Lean lines plus +307 / -30 edited lines across core Mathlib files):
  * 4 new `CovariantDerivative` files (3,535 lines): `Prelim` (1,009), `Basic` (1,030), `Torsion` (338), `LeviCivita` (1,158).
  * 2 new helper files required by the PR (366 lines): `Misc` (152), `Tensoriality` (214).
  * 6 modified Mathlib files whose diffs must be ported (+307 / -30 lines): `VectorField/LieBracket` (+123 / -23), `VectorBundle/LocalFrame` (+95 / -3), `MFDeriv/Atlas` (+41), `MFDeriv/NormedSpace` (+21), `VectorField/Pullback` (+21 / -4), `Mathlib.lean` (+6).
  * 1 non-code file: `plan.mde` (+12).
* **PR 36128 dependency depth:**
  * `LeviCivita` -> `Torsion` (plus `InnerProductSpace/Dual`, `VectorBundle/Riemannian`, `Util/PrintSorries`).
  * `Torsion` -> `Basic`.
  * `Basic` -> `Prelim` (plus the same 10 Mathlib modules imported by `Prelim`).
  * `Prelim` -> 10 modules: new helpers `Misc` and `Tensoriality`, modified `VectorField/LieBracket`, plus `SmoothSection`, `Tangent`, `MFDeriv/FDeriv`, `MFDeriv/SpecificFunctions`, `BumpFunction`, `Notation`, and `IsManifold/InteriorBoundary` (with remaining diffs in `MFDeriv/Atlas`, `MFDeriv/NormedSpace`, `VectorBundle/LocalFrame`, `VectorField/Pullback`, and `Mathlib.lean`).
* **Moving to v4.29.0 (answers GAP-4b):**
  * Fixes: includes the upstream covariant derivative API (absent in v4.24.0 through v4.28.0), eliminates PR 36128 vendoring, and matches the Hamilton three-manifold paper-time snapshot (Lean 4.29.0 / Mathlib v4.29.0).
  * Leaves open: `Mathlib/Analysis/Distribution/Sobolev.lean` is absent (404 at v4.29.0), leaving the Sobolev Bessel layer missing; trails Hilbert6 (Lean 4.35.0) and Hamilton current main (Lean v4.35.0-rc3); leaves the v4.23.0 missing-inventory items unverified or absent.
* **Moving to v4.36.0 (answers GAP-4b):**
  * Fixes: includes the upstream covariant derivative API (`CovariantDerivative` structure at `Basic.lean:366`; public `IsLeviCivitaConnection` structure with Koszul formula lemma and uniqueness theorem) and the upstream Sobolev Bessel layer (`Mathlib/Analysis/Distribution/Sobolev.lean` and `TemperedDistribution.lean`, including `TemperedDistribution.MemSobolev` and `besselPotential`), with zero PR 36128 vendoring cost.
  * Leaves open: requires upgrading across 13 releases from local v4.23.0, reconciling minor toolchain skew with satellites pinned at Lean 4.35.0 / v4.35.0-rc3, and re-auditing the absent geometry and PDE inventory items on v4.36.0.
* **Riemann sign trigger check (answers GAP-5b):** PR 36128 defines no Riemann curvature at all; its `LeviCivita` file is Riemannian-only and takes a `RiemannianBundle` instance. Because no curvature is defined, the PR carries no Riemann sign convention, and the Riemann sign trigger in `RFC_Conventions` cannot fire on this PR.

## Generator verification (not Neon output)

- PR status re-checked by the generator via GitHub API, 26 Nov 2026: state open,
  merged false, mergeable false, created 2026-03-04, updated 2026-09-19,
  head 8968a1246e09fbe77e70282027173874e5c3f437.
- File list and line counts re-checked via the PR files API: 13 files, counts
  match Neon's numbers exactly. New lines total 3,901 (3,535 CovariantDerivative
  plus 366 helpers). Edited lines total +307 / -30.
- Import chains re-checked by reading the PR head files: Prelim imports 10
  Mathlib modules including the two new helpers Misc and Tensoriality; Basic
  imports Prelim plus the same 10; Torsion imports Basic only; LeviCivita
  imports InnerProductSpace/Dual, Torsion, VectorBundle/Riemannian,
  Util/PrintSorries.
- Landing window re-checked via the contents API: CovariantDerivative/Basic.lean
  returns 404 at v4.24.0, v4.25.0, v4.26.0, v4.27.0, and v4.28.0, and 200 at
  v4.29.0 and v4.36.0. Sobolev.lean returns 404 at v4.29.0 and 200 at v4.36.0
  and on master.
- Latest release re-checked: v4.36.0, published 16 Nov 2026.
- Riemann sign: confirmed by grep over the four PR files. No line matches
  Riemann or curvature except doc mentions of Riemannian manifolds. GAP-5b is
  answered: the trigger cannot fire on this PR. It could still fire on a future
  curvature PR, so the RFC_Conventions trigger stays, with its scope narrowed
  to that case.
- Open cost not measured: the human effort to upgrade the local tree across 13
  releases (build time, breaking changes in the plan's other dependencies) is
  not estimated here. That is the next measurement before the move is executed.
