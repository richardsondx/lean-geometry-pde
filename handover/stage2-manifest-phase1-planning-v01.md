# Stage 2 manifest v01, Mathlib geometry Phase 1 planning, Neon as architect

Date: 26 Nov 2026
Stage 1: ~/workspace/handover-mathlib-geometry-2026-11-26/stage1-package-phase1-planning-v01.md, approved by Richardson 26 Nov 2026, "Approve Neon architecture run"
Predicate: pred-mathlib-geometry-phase1-planning-v01
Repo: https://github.com/richardsondx/lean-geometry-pde, public, empty, push blocked by GitHub App 403
Models: Gemini 4 Neon google/gemini-4-neon as lead architect, GPT-6.2 Astra openai/gpt-6.2-astra as mathematician, max_tokens 8000 or higher
Roles, clarified by Richardson 26 Nov 2026: Astra is the mathematician, Neon is the architect. Astra authors the math content. Neon authors the architecture. Hostile review is cross-review, Neon reviews Astra math, Astra reviews Neon architecture, so no one reviews their own work.
Kit: Research brief kit, reused
Cost: hard cap $4, run $3.40, held back $0.60
Fix attempts: at most 5, shared. Dead end after 3 distinct approaches for same failure class.

## Intent, in Richardson words

Neon called Phase 0 trivial. Neon now does the architecture itself, to show how it would have done it if it is not trivial. Richardson does not write the architecture. He reviews Neon's version.

## Units, serial order

- U1, architecture: docs/ARCHITECTURE.md, modules, interfaces, dependency graph, what each module imports, what it exports, what it forbids.
- U2, downstream examples: one minimal failing example per alleged blocker, in prose with exact Lean statement, file and line where it fails, and what API would unblock it.
- U3, baseline decision: record why v4.23.0 stays or name the target revision, with vendoring cost and PR 36128 dependency depth.
- U4, Sobolev route: weak derivative W^{k,p} route versus Bessel potential route, with a specific Phase 3 statement each route must serve.
- U5, interop example: (n, 0) case against Bundle.ContMDiffRiemannianMetric, instance conflicts named, lost lemmas named.
- U6, missing inventory: cover the load bearing pieces Neon listed, differential forms, exterior derivative, volume forms, manifold integration, Stokes, geodesics, curvature, Laplace-Beltrami, weak derivatives, W^{k,p} on domains, compact embeddings, Lax-Milgram, elliptic, parabolic, hyperbolic PDE infrastructure, present or absent, with file and line.
- U7, independent check: fresh checker re-opens every claim, Astra hostile review recorded with model id, prompt, result.
- U8, final report and judge verdict: judge in fresh context, verdict DONE or GAP only on predicate.

## Allowed

- Read Mathlib, Hilbert6, PR 36128, arXiv sources.
- Write in ~/workspace/handover-mathlib-geometry-2026-11-26/ only.
- Call Neon and Astra via or_chat.py only.
- Neon writes the architecture.

## Still blocked

- No push, no post, no repo edit, no deploy, no email.
- No Phase 1 code. Planning only.
- No Kerr stability claim, no Yang-Mills claim.
- No change to predicate, cost, or scope without reapproval.

## What changed since Stage 1

- No change to proof of done or cost.
- Intent clarified: Neon is architect, not just reviewer.
