# Stage 1 package v01, signature ordering lock, first principles

Date: 26 Nov 2026
Work folder: ~/workspace/handover-mathlib-geometry-2026-11-26/
Predicate: pred-signature-ordering-lock-v01
Models: GPT-6.2 Astra openai/gpt-6.2-astra as mathematician, Gemini 4 Neon google/gemini-4-neon as architect, cross-review
Kit: Research brief kit, reused
Cost: hard cap $2, run $1.70, held back $0.30
Fix attempts: at most 3 shared

## Question

Lock the meaning of (p, q) in PseudoRiemannianMetric, and the Lorentzian and Riemannian values under that lock.

## Why no Lean

Lean cannot decide this. It is a convention, not a theorem. Lean can check consistency after the lock, it cannot choose the lock. First principles decides it.

## First principles, to test

- A Lorentzian metric in 4 dimensions has signature (-, +, +, +), one minus, three plus, per Hilbert6 LorentzianAt diag(-1, 1, 1, 1) and Phase 0 RFC_Conventions.
- A Riemannian metric is positive definite, all plus, (n, 0) under plus-first ordering.
- Mathlib Riemannian API assumes positive definite. The (n, 0) case must interoperate with Bundle.ContMDiffRiemannianMetric without duplicate instances.
- PR 36128, Hilbert6, and the architecture must use the same ordering, or every downstream statement flips sign.

## Proposed lock, to test, not assumed

- (p, q) = (pluses, minuses)
- Lorentzian (3, 1)
- Riemannian (n, 0)

## Units, serial order

- U1, first principles ladder: decision, load bearing claims, tests, counter cases, rebuild from true facts only.
- U2, amendment draft: exact lines to change in RFC_PseudoRiemannian.md lines 37-38 and 39-40, and RFC_Conventions.md line 78, plus every downstream line that cites (1, 3).
- U3, independent check: fresh checker re-reads RFCs, Hilbert6, PR 36128, architecture, Astra and Neon cross-review recorded with model id, prompt, result.
- U4, final report and judge verdict: judge in fresh context, verdict DONE or GAP only on predicate.

## Allowed

- Read RFCs, Hilbert6 source, PR 36128, ARCHITECTURE.md.
- Write in ~/workspace/handover-mathlib-geometry-2026-11-26/ only.
- Call Astra and Neon via or_chat.py only.
- No Lean code in this run. Lean consistency check waits for Phase 1.

## Still blocked

- No push, no post, no repo edit, no deploy, no email.
- No RFC amendment applied in this run, draft only. Richardson applies the lock, or approves the amendment as a separate step.
- No Kerr stability claim, no Yang-Mills claim.
- No change to predicate, cost, or scope without reapproval.
