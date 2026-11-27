# Fix log, fix cycle 1 of 5, stage2-mathlib-geometry-phase1-planning-01

Date: 26 Nov 2026, evening EST. Fixer: fix cycle 1.
Checker verdict was FAIL, fixable in one cycle. This log records what
changed in the docs only. No predicate, cost, or scope change. No push,
post, repo edit, deploy, or email. No Phase 1 Lean code written.

## GAP-3, fixed

File: docs/ARCHITECTURE.md, RiemannianInterop imports line.
Removed `Mathlib.Geometry.Manifold.Riemannian.Distance` and the false
"exact v4.36.0 leaf paths verified in Step 0" claim. The line now
imports `Mathlib.Geometry.Manifold.Riemannian.PathELength` and states
the v4.36.0 Riemannian directory holds only Basic.lean and
PathELength.lean, with the path to be re-confirmed at Step 0.
Verified: local v4.23.0 tree holds only Basic.lean and PathELength.lean
in Mathlib/Geometry/Manifold/Riemannian. The generator verification
note at the end now says "fixed in fix cycle 1". The only remaining
mention of the Distance path in the file is inside that note, quoting
what Neon wrote.

## GAP-4, fixed, with one flagged path

File: docs/ARCHITECTURE.md, header line 14.
Corrected `Mathlib.Geometry.Manifold.CovariantDerivative.Basic` to
`Mathlib.Geometry.Manifold.VectorBundle.CovariantDerivative.Basic`.
Every other import path in the file was checked against the local
v4.23.0 tree and the generator verified v4.36.0 notes:
- Exist in v4.23.0: Tangent, SmoothSection, MFDeriv.Atlas,
  BilinearForm.Properties, QuadraticForm.Real, Riemannian.Basic,
  Riemannian.PathELength.
- v4.36.0 target paths, absent in v4.23.0 by design, verified by the
  generator on the v4.36.0 tag per docs/BaselineDecision.md:
  VectorBundle.CovariantDerivative.Basic,
  VectorBundle.CovariantDerivative.LeviCivita, Distribution.Sobolev,
  Distribution.TemperedDistribution.
- One path could not be verified either way and was not invented:
  `Mathlib.Geometry.Manifold.VectorBundle.LocalFrame` has 0 hits in
  the v4.23.0 tree (no file of that name exists there) and is not
  among the paths the generator verified on the v4.36.0 tag. It is
  flagged in the generator verification notes at the end of
  ARCHITECTURE.md, with an instruction to confirm it at Step 0
  before any file uses it.
Also fixed a Check 5 nit in the same file: the Curvature module line
said "(1, 3) Riemann tensor", which collides visually with the
disputed signature notation. It now says "Riemann tensor, a
(1, 3)-type tensor".

## GAP-5, fixed

File: docs/MissingInventory.md, Curvature line and verification block.
"0 hits for `Riemann` or `Ricci`" is now "0 hits for Riemann
curvature or `Ricci`; the string `Riemann` returns 336 hits
tree-wide, all Riemann-integral or Riemannian-adjective uses, none
of them Riemann curvature".
Verified by grep in the local v4.23.0 tree: `Riemann` 336 hits,
case-insensitive `riemann.*curvat|ricci` 0 hits, `Ricci` 0 hits.

## GAP-6, fixed

File: docs/MissingInventory.md, Geodesics line and verification block.
"no `expMap`" is now qualified: `expMap` returns 0 hits in
`Mathlib/Geometry/Manifold`, so no geometric exponential map exists
there; tree-wide it returns 192 hits, 189 of them a number-field
expMap in
`Mathlib/NumberTheory/NumberField/CanonicalEmbedding/NormLeOne.lean`,
unrelated to geodesics.
Verified by grep in the local v4.23.0 tree: 192 total, 189 in
NormLeOne.lean, 3 in
Mathlib/Analysis/SpecialFunctions/Complex/Circle.lean, 0 in
Mathlib/Geometry/Manifold.

## GAP-7, draft written, RFCs untouched

File: docs/SignatureOrdering-Amendment-Draft.md (new).
Quotes the inconsistent lines from docs/RFC_PseudoRiemannian.md
(lines 37-38, 39-40, 42) and docs/RFC_Conventions.md (lines 78-79),
states the proposed lock ((p, q) = (pluses, minuses), Lorentzian
(3, 1), Riemannian (n, 0)), and lists exactly which lines would
change: RFC_PseudoRiemannian.md lines 37-38 and 39-40;
RFC_Conventions.md line 78. Lines 42, 9-10, 24-25 in
RFC_PseudoRiemannian.md and line 79 in RFC_Conventions.md need no
change under the proposed lock.
Verified: both RFC files still contain the original (1, 3) lines,
unchanged. The lock decision belongs to Richardson with the Phase 1
lead. Still open until he locks it.

## GAP-8, fixed

File: docs/ARCHITECTURE.md, GeometricBase imports and dependency graph.
Added `Mathlib.Analysis.InnerProductSpace.LaxMilgram` and
`Mathlib.Analysis.ODE.Gronwall` to the GeometricBase imports, and
added both edges to the dependency graph.
Verified by grep in the local v4.23.0 tree: both files exist;
`continuousLinearEquivOfBilin` is defined at LaxMilgram.lean:102;
Gronwall.lean defines `gronwallBound` and the `le_gronwallBound`
theorems.

## GAP-9, recorded as open decision in both files, not resolved

Files: docs/ARCHITECTURE.md (exports line annotation plus a new Open
Decisions entry) and docs/InteropExample.md (new section "Open
decision: scoped instances", before the generator verification block).
The tension: the architecture exports scoped instances in namespace
`PseudoRiemannian.Riemannian` for `Bundle.RiemannianBundle`,
`IsContMDiffRiemannianBundle`, and `IsRiemannianManifold`, but the
existing Mathlib instance at VectorBundle/Riemannian.lean:257 already
registers `RiemannianBundle` (plus `IsContMDiffRiemannianBundle`)
from any `ContMDiffRiemannianMetric`. The fix cycle could not resolve
from the evidence whether the scoped instances create a second live
registration path or are needed despite that instance, so no
resolution is asserted and no new mechanism was invented. Both files
name the instances involved by file and line (they are anonymous, so
there are no Lean names): VectorBundle/Riemannian.lean:257, and the
two scoped priority-80 fiber instances at
Topology/VectorBundle/Riemannian.lean:431 (NormedAddCommGroup) and
:442 (InnerProductSpace). Line numbers verified by grep.
Still open, owned by the Phase 1 lead: drop the scoped instances or
record exactly why they are needed despite the existing instance.

## GAP-1, hostile reviews, still open, egress still down

Attempted once per model, via
~/workspace/custom-connectors/custom.openrouter-chat/bin/or_chat.py,
prompt via stdin only, --max-tokens 8000, no retries:
- Neon, model google/gemini-4-neon, prompt
  /tmp/u7probes/prompt-neon-review.md: exit 1, 0 bytes reply.
  Error: `urllib.error.URLError: <urlopen error timed out>`, raised
  in the HTTPS CONNECT tunnel after 120 seconds.
- Astra, model openai/gpt-6.2-astra, prompt
  /tmp/u7probes/prompt-astra-review.md: exit 1, 0 bytes reply.
  Error: `urllib.error.URLError: <urlopen error Remote end closed
  connection without response>`, raised in the HTTPS CONNECT tunnel.
No reply was obtained from either model, so nothing was appended to
check-log-phase1-planning.md. The saved prompts are unchanged at
/tmp/u7probes/prompt-neon-review.md and
/tmp/u7probes/prompt-astra-review.md for a later run when egress
recovers.

## GAP-2, live sources, still open, egress still down

One attempt, curl to the GitHub API for PR 36128 and the v4.36.0
release, plus connectivity probes to openrouter.ai and api.github.com.
All four calls returned HTTP 000; the batch exited 28 (timeout).
No live source was re-opened, so no v4.36.0 or PR 36128 claim was
re-verified in this cycle. Those claims still rest on the generator
verification alone.

## GAP-10, carried

Phase 3 acceptance-test parameters remain unfixed (dimension, target
exponent, weight convention, s, delta, local regularity, Poincare
and trace hypotheses). Carried to the Phase 3 lead, as the docs
already record. Not changed in this cycle.

## What remains open

- GAP-1: both hostile reviews, waiting on egress recovery.
- GAP-2: live-source re-open of PR 36128 and v4.36.0, waiting on
  egress recovery.
- GAP-7: signature ordering lock, waiting on Richardson.
- GAP-9: scoped instances decision, waiting on the Phase 1 lead.
- GAP-10: Phase 3 parameters, carried to the Phase 3 lead.
- LocalFrame import path in ARCHITECTURE.md Metric imports,
  flagged for confirmation at Step 0.
