# Stage 1 package v01, Mathlib geometry and PDE, Phase 0 audit

Date: 26 Nov 2026
Run: stage1-mathlib-geometry-2026-11-26-01
Plan file: ~/workspace/mathlib-geometry-plan-2026-11-26/PLAN.md
Target repo, to be created: richardsondx/lean-geometry-pde, public, MIT
Repo status: creation failed 26 Nov 2026, GitHub token returns 401 Bad credentials. No Muse authorization on his GitHub account, per memory 26 Nov 2026 16:40 EST. The repo must be created by Richardson, or by the Mac gh login, before any push. This run writes files locally only.
Models: GPT-6.2 Astra, openai/gpt-6.2-astra, for design. Gemini 4 Neon, google/gemini-4-neon, for hostile verification. Both via OpenRouter, max_tokens 4000 or higher for Neon.
Kit: Research brief kit, reused, proven, workspace/handover-kerr-full-stability-2026-11-25/kit/
Rule: map only, no toy proofs. Phase 0 is an audit and a plan, no Lean proof claimed.

## Goal

Audit what Mathlib v4.23.0 already has, lock conventions, and produce three RFCs, so Phase 1 can port Physicslib4 into Mathlib without guessing.

## Proof of done

- Audit file Audit/MathlibInventory.lean, with #check lines for every API named in the plan, and each item marked confirmed present, confirmed absent, or confirmed in a named satellite repo, with file path and line number.
- Three RFCs: docs/RFC_PseudoRiemannian.md, docs/RFC_Sobolev.md, docs/RFC_Conventions.md.
- Every uncertain item in the plan is resolved, including PR 36128 Levi-Civita merge status, and the Physicslib4 pseudo-Riemannian files read line by line.
- A fresh checker re-opens every cited file and source.
- A fresh judge gives a verdict.
- Gemini 4 Neon and GPT-6.2 Astra both review the audit, and their disagreements are recorded, not smoothed over.

## Cost

- Hard cap: $4.
- Run budget: $3.40.
- Held back: $0.60, for checking and the final report.
- Fix attempts: at most 5, shared across units.

## Will not touch

- Phase 1 code. No Lean definitions for Phase 1 until Phase 0 is done.
- Kerr stability proof. No proof claimed.
- Yang-Mills mass gap. No proof claimed.
- No push, no post, no repo creation, no deploy, without a separate approval.

## Needs from you

- Approval of this Stage 1 package.
- Approval of Stage 2 before the run starts.
- The $4 hard cap above.
- A decision on the repo: create lean-geometry-pde yourself, or let the Mac gh login create it, before Phase 0 files are pushed.

## Pass looks like

Audit compiles, every uncertain item is marked with a path and line, RFCs are written, checker and judge agree.

## Fail looks like

An API cannot be confirmed in the tree, or Physicslib4 cannot be ported cleanly, and the run reports a dead end with the blocker named.

## Units

- U1: Audit, machine checked #check inventory of v4.23.0.
- U2: Physicslib4 read, port assessment, generalisation decision.
- U3: RFCs, conventions locked, signature (-, +, +, +), tensor contraction, Sobolev design.
- U4: Independent check, fresh checker, Neon and Astra hostile review.
- U5: Final report and judge verdict.

## Verification like Lean, for this run and for the tool

Lean is the checker for math definitions. For the tool itself, the check is the same shape, in three layers.

- Layer 1, compile check: every Lean file in the repo must compile, exit 0, no sorry, no admit. A file that does not compile is not a tool.
- Layer 2, property check: every definition must pass a property test. Minkowski gives zero Riemann, zero Ricci, zero scalar. A round sphere gives the expected Ricci values. A definition with no test is a claim, and it fails.
- Layer 3, audit check: every claim in a report must name a file, a line, and a source. A checker re-opens each one. A claim with no source fails, even if the reasoning sounds right.
- Layer 4, hostile review: Gemini 4 Neon and GPT-6.2 Astra review the same artifact, in fresh contexts, with a prompt to say why it is trivial, already known, or flawed. Their verdicts are recorded in the run folder, with model id, prompt, and result.
- No layer passes on reasoning alone. A tool passes only when Lean, the property tests, the audit, and both hostile reviewers agree it does what it claims.
