# Stage 1 package v01, Mathlib geometry Phase 1 planning, Neon as architect

Date: 26 Nov 2026
Work folder: ~/workspace/handover-mathlib-geometry-2026-11-26/
Repo: https://github.com/richardsondx/lean-geometry-pde, public, empty, push still blocked by GitHub App 403
Predicate: pred-mathlib-geometry-phase1-planning-v01
Models: Gemini 4 Neon google/gemini-4-neon as lead architect, GPT-6.2 Astra openai/gpt-6.2-astra as hostile reviewer, max_tokens 8000 or higher
Kit: Research brief kit, reused
Cost: hard cap $4, run $3.40, held back $0.60
Fix attempts: at most 5 shared

## Why this run exists

Phase 0 audit passed the judge, but Neon called it a trivial grep session. Its points that stand, from check-log.md:
- #check proves a name exists, not that it can be used. No downstream example shows a blocker failing.
- Absence was stated from commented out lines, not rerunnable negative probes.
- Baseline v4.23.0 is stale, satellites run 4.29.0 and 4.35.0, no reason given for staying.
- Sobolev conclusion was a false dichotomy. Weak derivative W^{k,p} may not need tempered distributions first.
- Hilbert6 port was dismissed at the first missing import, no dependency depth or porting cost.
- One PseudoRiemannianMetric (p, q) with no parallel class does not show how the (n, 0) case interoperates with Mathlib Riemannian API.
- Inventory missed load bearing pieces: differential forms, exterior derivative, volume forms, manifold integration, Stokes, geodesics, curvature, Laplace-Beltrami, weak derivatives, W^{k,p} on domains, compact embeddings, Lax-Milgram, elliptic, parabolic, hyperbolic PDE infrastructure.

This run answers those points with architecture, not with a longer list.

## Units, serial order

- U1, architecture: docs/ARCHITECTURE.md, modules, interfaces, dependency graph, what each module imports, what it exports, what it forbids.
- U2, downstream examples: one minimal failing example per alleged blocker, in prose with exact Lean statement, file and line where it fails, and what API would unblock it.
- U3, baseline decision: record why v4.23.0 stays or name the target revision, with vendoring cost and PR 36128 dependency depth.
- U4, Sobolev route: weak derivative W^{k,p} route versus Bessel potential route, with a specific Phase 3 statement each route must serve.
- U5, interop example: (n, 0) case against Bundle.ContMDiffRiemannianMetric, instance conflicts named, lost lemmas named.
- U6, missing inventory: cover the load bearing pieces Neon listed, present or absent, with file and line.
- U7, independent check: fresh checker re-opens every claim, Astra hostile review recorded with model id, prompt, result.
- U8, final report and judge verdict: judge in fresh context, verdict DONE or GAP only on predicate.

## Allowed

- Read Mathlib, Hilbert6, PR 36128, arXiv sources.
- Write in ~/workspace/handover-mathlib-geometry-2026-11-26/ only.
- Call Neon and Astra via or_chat.py only.
- Neon writes the architecture. Richardson reviews it, he does not write it unless he chooses to.

## Still blocked

- No push, no post, no repo edit, no deploy, no email.
- No Phase 1 code. Planning only.
- No Kerr stability claim, no Yang-Mills claim.
- No change to predicate, cost, or scope without reapproval.
