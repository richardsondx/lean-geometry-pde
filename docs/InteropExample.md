# docs/InteropExample.md

Date: 26 Nov 2026. Run: stage2-mathlib-geometry-phase1-planning-01.
Author: GPT-6.2 Astra, model openai/gpt-6.2-astra, as mathematician.
Baseline: Lean 4.23.0, Mathlib v4.23.0, local tree commit 37df177aaa770670452312393d4e84aaad56e7b6.
Status: planning only. No Lean code in this file. No proof claimed.

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
- Use the existing registration from that converted metric as the sole source of `Bundle.RiemannianBundle`, with the existing `IsContMDiffRiemannianBundle` instance. Keep the two priority-80 fiber instances in the `Bundle` scope.
- With `(n,0)` denoting positive signature, **p>0 alone is not an obstruction**. For mixed signature `p,q>0`, a negative vector violates `pos`. A nonzero null vector `v` violates `isVonNBounded`: the entire line `tv` lies in `{w | g(w,w)<1}`, since `g(tv,tv)=0` for every real `t`. This is the light-cone obstruction, not a failure of smoothness or symmetry.

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
Mathlib instance at VectorBundle/Riemannian.lean:257 already registers
`RiemannianBundle` (plus `IsContMDiffRiemannianBundle`) from any
`ContMDiffRiemannianMetric`, and this file states the existing registration
from the converted metric is the sole source of `Bundle.RiemannianBundle`.
The fix cycle could not resolve from the evidence whether the scoped
instances create a second live registration path or are needed despite the
existing instance, so no resolution is asserted. The instances involved,
identified by file and line because they are anonymous (no Lean names):
the Mathlib instance at
Mathlib/Geometry/Manifold/VectorBundle/Riemannian.lean:257, and the two
scoped priority-80 Bundle-namespace fiber instances at
Mathlib/Topology/VectorBundle/Riemannian.lean:431 (NormedAddCommGroup) and
:442 (InnerProductSpace). The Phase 1 lead must decide: drop the scoped
instances and rely on the existing registration as the sole source, or
record exactly why they are needed despite it, naming each instance.
See docs/ARCHITECTURE.md, Open Decisions, for the same open decision.

## Generator verification (not Astra output)

- All file and line citations above were re-checked by grep in the v4.23.0 tree
  on 26 Nov 2026 and match Phase 0 inventory-v02.md exactly.
- Correction to the earlier Neon draft: Neon wrote that a (p, q) metric with
  p > 0 cannot supply pos and isVonNBounded. Astra corrects this: with (n, 0)
  denoting positive signature, p > 0 alone is not an obstruction. The
  obstruction is mixed signature: a negative vector violates pos, and a null
  vector violates isVonNBounded because the whole line tv lies in
  {w | g(w,w) < 1}. Astra's version is authoritative for the math.
- Signature ordering note: Astra and Neon both use (p, q) as (pluses, minuses),
  so (n, 0) is positive definite. Phase 0 docs/RFC_PseudoRiemannian.md says
  (p, q) has p minus ones and q plus ones, which would make (n, 0) negative
  definite. That Phase 0 inconsistency must be resolved before any file is
  written; see docs/ARCHITECTURE.md.
- The light cone argument is also recorded in the Hilbert6 source: the
  boundedness condition is false for a Lorentzian form, since the set
  {v | g(v, v) < 1} contains the whole light cone.
