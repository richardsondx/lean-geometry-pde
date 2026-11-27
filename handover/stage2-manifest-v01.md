# Stage 2 manifest v01, Mathlib geometry Phase 0 audit

Date: 26 Nov 2026
Stage 1: ~/workspace/handover-mathlib-geometry-2026-11-26/stage1-package-v01.md, approved by Richardson 26 Nov 2026, "approve all phases"
Predicate: pred-mathlib-geometry-phase0-v01
Repo: https://github.com/richardsondx/lean-geometry-pde, public, empty at start, push blocked 26 Nov 2026 by GitHub App 403, files stay local in ~/workspace/handover-mathlib-geometry-2026-11-26/ and ~/workspace/lean-geometry-pde/
Models: GPT-6.2 Astra openai/gpt-6.2-astra, Gemini 4 Neon google/gemini-4-neon, max_tokens 4000 or higher for Neon
Kit: Research brief kit, reused, pilot, workspace/handover-v1/kits/research-brief/
Cost: hard cap $4, run $3.40, held back $0.60
Fix attempts: at most 5, shared. Dead end after 3 distinct approaches for same failure class.

## Units, serial order

- U1, audit: output Audit/MathlibInventory.lean, check #check lines for every API in PLAN.md, each item marked confirmed present, confirmed absent, or confirmed in a named satellite repo, with file path and line number.
- U2, Physicslib4 read: output map, port assessment, generalisation decision, PseudoRiemannianMetric vs parallel class.
- U3, RFCs: output docs/RFC_PseudoRiemannian.md, docs/RFC_Sobolev.md, docs/RFC_Conventions.md, conventions locked, signature (-, +, +, +).
- U4, independent check: fresh checker re-opens every cited file and source, Neon and Astra hostile review recorded with model id, prompt, result.
- U5, final report and judge verdict: judge in fresh context, verdict DONE or GAP only on predicate.

## Allowed

- Read Mathlib docs, Physicslib4 docs, arXiv, GitHub.
- Write in ~/workspace/handover-mathlib-geometry-2026-11-26/ only.
- Call GPT-6.2 Astra and Gemini 4 Neon via or_chat.py only.
- Run Lean #check via lake env lean where a local Mathlib copy exists, read only.

## Still blocked

- No push, no post, no repo edit, no deploy, no email.
- No Phase 1 code.
- No Kerr stability claim, no Yang-Mills claim.
- No change to predicate, cost, or scope without reapproval.

## What changed since Stage 1

- Repo now exists, https://github.com/richardsondx/lean-geometry-pde, public, empty, verified live 26 Nov 2026.
- Push of README, PLAN.md, Stage 1 failed 26 Nov 2026, GitHub App 403 Resource not accessible by integration, on push_files initial file. Files stay local until installation covers the new repo.
- No change to proof of done or cost.
