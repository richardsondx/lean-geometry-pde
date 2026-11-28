# docs/InteropExample.md

Date: 26 Nov 2026. Run: stage2-mathlib-geometry-phase1-planning-01.
Author: GPT-6.2 Astra, model openai/gpt-6.2-astra, as mathematician.
Baseline: Lean 4.23.0, Mathlib v4.23.0, local tree commit 37df177aaa770670452312393d4e84aaad56e7b6.
Status: planning only. No Lean code in this file. No proof claimed.

Baseline note, 27 Nov 2026, fix cycle 2: the opening block below cites the v4.23.0 tree. The v4.36.0 amendment notes in this file supersede those cites where they differ.

How to read this file: the interop math is verbatim Astra output from astra-log.md
call 1. The generator verification block at the end is not Astra output.

## The (n, 0) case against Bundle.ContMDiffRiemannianMetric

Target structure, verified in the v4.23.0 tree:
Bundle.ContMDiffRiemannianMetric, Mathlib/Geometry/Manifold/VectorBundle/Riemannian.lean:238.
Fields: inner, symm, pos (0 < inner b v v for v != 0), isVonNBounded
(the set {v | inner b v v < 1} is von Neumann bounded), contMDiff.

Related names, verified in the v4.23.0 tree:
- Bundle.RiemannianBundle, class, Mathlib/Topology/VectorBundle/Riemannian.lean:420,
  single field g : RiemannianMetric E.
- IsContMDiffRiemannianBundle, class,
  Mathlib/Geometry/Manifold/VectorBundle/Riemannian.lean:62.
- IsRiemannianManifold, class, Mathlib/Geometry/Manifold/Riemannian/Basic.lean:77,
  single field out: edist x y = riemannianEDist I x y.
- Manifold.riemannianEDist, Mathlib/Geometry/Manifold/Riemannian/PathELength.lean:205.
- Instance `instance (g : ContMDiffRiemannianMetric IB n F E) : RiemannianBundle E`
  plus `IsContMDiffRiemannianBundle IB n F E`, declared in
  VectorBundle/Riemannian.lean right after the structure.
- Two scoped instances (priority 80, Bundle namespace) in
  Topology/VectorBundle/Riemannian.lean give NormedAddCommGroup and
  InnerProductSpace on each fiber from a RiemannianBundle instance.

## Section 2. Interop math (verbatim Astra)

- Convert the `(n,0)` metric to `Bundle.ContMDiffRiemannianMetric` by a plain definition, not an instance. Retain `inner`, `symm`, and `contMDiff`; positive definiteness gives `pos`, and in finite dimension the positive-definite unit ball is bounded, giving `isVonNBounded`.
- Use the existing registration from that converted metric as one registration path for `Bundle.RiemannianBundle`, not a guaranteed sole source, with the existing `IsContMDiffRiemannianBundle` instance. Keep the two priority-80 fiber instances in the `Bundle` scope. Amended 27 Nov 2026, run stage2-mathlib-geometry-planning-docs-01: the converted metric is one registration path, not a guaranteed sole source (verdict-phase1-planning-v02.md, GAP-C; check-log-phase1-planning-v03.md item 7). The diamond and priority-80 shadowing risk is an owned open design decision, owner Phase 1 lead, to be decided before any Phase 1 file registers instances.
- With `(n,0)` denoting positive signature, **p>0 alone is not an obstruction**. For mixed signature `p,q>0`, a negative vector violates both `pos` and `isVonNBounded`. A nonzero null vector `v` fails `pos` at the vector itself, because `pos` requires `0 < g(v,v)` for every nonzero `v`, and `0 < 0` is false when `g(v,v) = 0`. The `isVonNBounded` failure has a separate argument: the whole line `tv` lies in `{w | g(w,w) < 1}`, because `g(tv,tv) = t^2 g(v,v)`, which is at most 0 for a negative or null vector, so the set is unbounded. That line argument is what `isVonNBounded` needs, at Mathlib/Geometry/Manifold/VectorBundle/Riemannian.lean:250 in v4.36.0 (`isVonNBounded (b : B) : IsVonNBounded ℝ {v : E b | inner b v v < 1}`). The pure negative-definite `(0, n)` case with `n > 0` also fails `pos`, with no light cone at all. Amendment note, 27 Nov 2026, run stage2-mathlib-geometry-planning-docs-01: this bullet replaces the verbatim Astra bullet, which stated the opposite split (a negative vector violates `pos`; a nonzero null vector violates `isVonNBounded`) and labelled it the light-cone obstruction. That split is refuted by the live source: `pos` is strict positive-definiteness at Mathlib/Geometry/Manifold/VectorBundle/Riemannian.lean:249 in v4.36.0 (`pos (b : B) (v : E b) (hv : v ≠ 0) : 0 < inner b v v`). The light-cone obstruction label is dropped. Sources: verdict-phase1-planning-v02.md (GAP-B); check-log-phase1-planning-v03.md item 7 and Neon 2. Further amendment, 27 Nov 2026, fix cycle 2: the line argument for `isVonNBounded` was added, the `(0, n)` case was qualified with `n > 0`, and the wording was softened per Astra point 1.

## Instance conflicts, named (verbatim Astra, from docs/DownstreamExamples.md example 4)

- A second `Bundle.RiemannianBundle` alongside the registration derived from the
  `(n, 0)` metric gives competing choices of metric and hence of fiber
  `NormedAddCommGroup` and `InnerProductSpace`. Typeclass search choosing one
  does not make both norms definitionally equal.
- The existing instance in VectorBundle/Riemannian.lean already declares
  `instance (g : ContMDiffRiemannianMetric IB n F E) : RiemannianBundle E`
  and `IsContMDiffRiemannianBundle IB n F E`. Any second RiemannianBundle
  instance on the same fibers creates a typeclass diamond on
  `g : RiemannianMetric E` and breaks synthesis for the two scoped priority 80
  Bundle-namespace instances (NormedAddCommGroup and InnerProductSpace on each
  fiber).

## Lost lemmas if the (n, 0) metric is never registered (verbatim Astra)

- With no registration, neither the fiber norm nor the `InnerProductSpace` is
  supplied by this metric. For a tangent metric, results about
  `Manifold.riemannianEDist` and the `IsRiemannianManifold` equality then
  cannot be used through this metric either.
- Lost: the scoped priority 80 fiber NormedAddCommGroup (fiber norm) and
  InnerProductSpace instances from Mathlib/Topology/VectorBundle/Riemannian.lean;
  IsContMDiffRiemannianBundle (VectorBundle/Riemannian.lean:62);
  IsRiemannianManifold (Riemannian/Basic.lean:77); Manifold.riemannianEDist
  (PathELength.lean:205).
- Registration alone does not prove the IsRiemannianManifold equality
  (edist x y = riemannianEDist I x y). That equality still needs its own proof
  for the converted metric.

## Open decision: scoped instances (fix cycle 1, owned by the Phase 1 lead)

Tension, not resolved here. docs/ARCHITECTURE.md exports scoped instances in
namespace `PseudoRiemannian.Riemannian` for `Bundle.RiemannianBundle`,
`IsContMDiffRiemannianBundle`, and `IsRiemannianManifold`. But the existing
Mathlib instance at VectorBundle/Riemannian.lean:264 already registers
`RiemannianBundle` (plus `IsContMDiffRiemannianBundle`) from any
`ContMDiffRiemannianMetric`. The converted metric is one registration path
for `Bundle.RiemannianBundle`, not a guaranteed sole source (amended
27 Nov 2026, run stage2-mathlib-geometry-planning-docs-01;
verdict-phase1-planning-v02.md, GAP-C).
The fix cycle could not resolve from the evidence whether the scoped
instances create a second live registration path or are needed despite the
existing instance, so no resolution is asserted. The instances involved,
identified by file and line because they are anonymous (no Lean names):
the Mathlib instance at
Mathlib/Geometry/Manifold/VectorBundle/Riemannian.lean:264, and the two
scoped priority-80 Bundle-namespace fiber instances at
Mathlib/Topology/VectorBundle/Riemannian.lean:431 (NormedAddCommGroup) and
:453 (InnerProductSpace) in v4.36.0. The Phase 1 lead must decide, before
any Phase 1 file registers instances: drop the scoped instances, or
record exactly why each is needed, naming each instance. The diamond risk
stands: the registration instance at
Mathlib/Geometry/Manifold/VectorBundle/Riemannian.lean:264-268 registers
`RiemannianBundle E` from any `ContMDiffRiemannianMetric`, and
`RiemannianBundle` is indexed by `E`, not by the metric, so a second
`(n, 0)` metric or an ambient `RiemannianBundle` can collide with the
converted metric. The priority-80 shadowing risk stands too: a
default-priority fiber `NormedAddCommGroup` can win synthesis over the
priority-80 scoped instance. Both risks are an owned open design decision,
owner Phase 1 lead. Sources: verdict-phase1-planning-v02.md (GAP-C);
check-log-phase1-planning-v03.md item 7.
See docs/ARCHITECTURE.md, Open Decisions, for the same open decision.

## Generator verification (not Astra output)

- All file and line citations above were re-checked by grep in the v4.23.0 tree
  on 26 Nov 2026 and match Phase 0 inventory-v02.md exactly.
- Correction to the earlier Neon draft: Neon wrote that a (p, q) metric with
  p > 0 cannot supply pos and isVonNBounded. Astra corrects this: with (n, 0)
  denoting positive signature, p > 0 alone is not an obstruction. The
  obstruction is mixed signature. Amendment, 27 Nov 2026, run
  stage2-mathlib-geometry-planning-docs-01: the split stated here before (a
  negative vector violates pos, and a null vector violates isVonNBounded
  because the whole line tv lies in {w | g(w,w) < 1}) was wrong, and the
  light-cone obstruction label attached to it is dropped. The corrected
  split, verified at Mathlib/Geometry/Manifold/VectorBundle/Riemannian.lean:249
  in v4.36.0 (`pos (b : B) (v : E b) (hv : v ≠ 0) : 0 < inner b v v`, strict):
  a nonzero null vector fails pos at the vector itself, because 0 < 0 is
  false; a negative vector violates both pos and isVonNBounded, where the
  isVonNBounded failure is the line argument: the whole line tv lies in
  {w | g(w,w) < 1} because g(tv,tv) = t^2 g(v,v) is at most 0 for a negative
  or null vector, so the set is unbounded, cited at
  Mathlib/Geometry/Manifold/VectorBundle/Riemannian.lean:250 in v4.36.0; the
  pure negative-definite (0, n) case with n > 0 fails pos with no light cone
  at all.
  Sources: verdict-phase1-planning-v02.md (GAP-B);
  check-log-phase1-planning-v03.md item 7 and Neon 2. The same correction
  was applied to the Section 2 bullet above, with the line argument added in
  fix cycle 2, 27 Nov 2026.
- Signature ordering note, locked 26 Nov 2026, record amended 27 Nov 2026, fix cycle 2: the lock is (p, q) = (pluses, minuses), Lorentzian (3, 1), Riemannian (n, 0). The RFCs were amended at docs/RFC_PseudoRiemannian.md lines 37-40 and docs/RFC_Conventions.md line 78. The earlier note in this block, which said the Phase 0 inconsistency "must be resolved before any file is written", is withdrawn; the lock above replaces it. See docs/ARCHITECTURE.md.
- The light cone argument is also recorded in the Hilbert6 source: the
  boundedness condition is false for a Lorentzian form, since the set
  {v | g(v, v) < 1} contains the whole light cone.
