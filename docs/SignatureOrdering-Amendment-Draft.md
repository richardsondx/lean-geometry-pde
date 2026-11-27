# Signature ordering amendment, draft for Richardson

Date: 26 Nov 2026. Run: stage2-mathlib-geometry-phase1-planning-01, fix cycle 1.
Status: draft only. This file proposes an amendment. It changes nothing.
The two RFCs below are untouched. No file is written on the basis of this
draft until Richardson locks the ordering.

## The inconsistency

Phase 0 defines (p, q) one way and uses it the other way. The Phase 1
planning docs (ARCHITECTURE.md, InteropExample.md, DownstreamExamples.md)
all use (p, q) as (pluses, minuses). The Phase 0 RFCs define it as
(minuses, pluses) and then call Riemannian (n, 0), which under their own
rule is negative definite. The three statements cannot all hold. The
(-, +, +, +) signature itself is not in dispute anywhere.

## Inconsistent lines, quoted verbatim

From docs/RFC_PseudoRiemannian.md, Definitions section:

- Lines 37-38: "matrix is diag(-1, ..., -1, 1, ..., 1) with p minus ones and q
  plus ones."
- Lines 39-40: "A Lorentzian metric is the signature (1, 3) case on a
  four-dimensional manifold, with the (-, +, +, +) convention
  locked in docs/RFC_Conventions.md."
- Line 42: "A Riemannian metric is the signature (n, 0) case. Positivity
  is a consequence of the signature, not separate data."

Under the lines 37-38 rule, (n, 0) at line 42 means n minus ones and
0 plus ones, which is negative definite, not Riemannian. Lines 39-40
and line 42 contradict lines 37-38.

From docs/RFC_Conventions.md, Naming section:

- Line 78: "`LorentzianMetric` for the signature (1, 3) case."
- Line 79: "Riemannian is the signature (n, 0) case of the same structure."

Same inconsistency, same consequence. Note the Signature section of the
same file (lines 11-14) locks (-, +, +, +) with one timelike and three
spacelike directions, which is not in dispute and needs no change.

## Proposed lock

(p, q) = (pluses, minuses). Riemannian is (n, 0). 4D Lorentzian is
(3, 1). This is the ordering Neon and Astra both use, it matches
Sylvester (pluses, minuses) in algebra texts, and it makes the
architecture module exports (LorentzianMetric (n - 1, 1),
SpacetimeMetric (3, 1), wave operators (n - 1, 1)) consistent with
the docs that use them.

## Lines that would change if the lock is approved

docs/RFC_PseudoRiemannian.md:

- Lines 37-38: change "with p minus ones and q plus ones" to
  "with p plus ones and q minus ones".
- Lines 39-40: change "the signature (1, 3) case" to
  "the signature (3, 1) case". The rest of the sentence, including
  the (-, +, +, +) reference, stays.
- Line 42: no change. "A Riemannian metric is the signature (n, 0)
  case" is correct under the proposed lock.
- Lines 9-10 and 24-25: no change. Both state the Riemannian case
  is signature (n, 0), which is correct under the proposed lock.

docs/RFC_Conventions.md:

- Line 78: change "for the signature (1, 3) case" to
  "for the signature (3, 1) case".
- Line 79: no change. "Riemannian is the signature (n, 0) case"
  is correct under the proposed lock.
- Signature section (lines 11-14): no change. (-, +, +, +) stands.

## Decision needed

Richardson locks the ordering, with the Phase 1 lead. Until then, no
Phase 1 file is written, because the module exports assume the
(pluses, minuses) ordering while the Phase 0 lock says the opposite.
