# generator-log.md, stage2-mathlib-geometry-phase1-planning-01

Date: 26 Nov 2026. Generator for units U1 to U6, serial order.
Predicate: pred-mathlib-geometry-phase1-planning-v01.
Work folder: ~/workspace/handover-mathlib-geometry-2026-11-26/ only.

## Role change, applied mid-run

- Original instruction: Neon authors everything.
- Role clarification from Richardson, received during this run: Astra is the
  MATHEMATICIAN, Neon is the ARCHITECT. No change to cost, scope, or predicate.
- Astra authors: U2 downstream failing examples, U4 Sobolev routes, U5 interop
  math, and the statements each architecture module must serve.
- Neon authors: U1 architecture, U3 baseline decision, U6 missing inventory
  structure.
- Neon call 3 (downstream examples and interop) was made before the role
  clarification. It is kept in neon-log.md but SUPERSEDED for math content.
  Astra's versions are authoritative for U2 and U5. Verified facts were kept
  and re-used in the Astra prompts; nothing verified was discarded.
- Hostile review is not the generator's job. The checker (U7) does
  cross-review later: Neon reviews Astra's math, Astra reviews Neon's
  architecture.

## Units done

- U1 docs/ARCHITECTURE.md: done. Neon calls 1 and 2. Modules, interfaces,
  dependency graph, imports, exports, forbids, build order, open decisions.
  Each module states the downstream theorem or computation it enables.
- U2 docs/DownstreamExamples.md: done. Astra call 1. Four minimal failing
  examples, each with the exact Lean statement in prose, the probe and error,
  and the unblocking API. All four probes re-run by the generator.
- U3 docs/BaselineDecision.md: done. Neon call 4, section 1. Move to v4.36.0.
  Vendoring cost for PR 36128 measured: 3,901 new lines plus +307 / -30 edited
  lines across 13 files, dependency depth listed. GAP-4b and GAP-4d answered.
  GAP-5b answered: the PR defines no curvature, so the Riemann sign trigger
  cannot fire on it.
- U4 docs/SobolevRoutes.md: done. Astra call 2. Weak-derivative W^{k,p} route
  versus Bessel potential route, each tied to specific Phase 3 statements.
  No false dichotomy. Bridge theorem named.
- U5 docs/InteropExample.md: done. Astra call 1. (n, 0) case against
  Bundle.ContMDiffRiemannianMetric, instance conflicts named, lost lemmas
  named, plain-def conversion rule, light-cone obstruction.
- U6 docs/MissingInventory.md: done. Neon call 4, section 2. All 15 items
  covered: present, absent, or satellite, with file path and line, verified
  by grep in the local v4.23.0 tree.

## Model calls

Neon, google/gemini-4-neon, via or_chat.py, prompt via stdin only:
- Call 1, max_tokens 16000: architecture core. Exit 0, reply returned but cut
  off mid-sentence (4237 bytes). Completed by call 2.
- Call 2, max_tokens 12000: architecture completion, narrower prompt. Exit 0,
  complete reply, 8675 bytes. This is the one allowed retry for the call 1
  cut-off, recorded here, not a fix attempt.
- Call 3, max_tokens 12000: downstream examples and interop (math). Exit 0,
  complete reply, 7695 bytes. Superseded for math content per the role split.
- Call 4, max_tokens 12000: baseline decision and missing inventory. Exit 0,
  complete reply, 7970 bytes.

Astra, openai/gpt-6.2-astra, via or_chat.py, prompt via stdin only:
- Call 1, max_tokens 12000: downstream examples (U2) and interop math (U5).
  Exit 0, complete reply, 3674 bytes.
- Call 2, max_tokens 12000: Sobolev routes (U4). Exit 0, complete reply,
  3981 bytes.

Total model calls: 6 (4 Neon, 2 Astra). Retries: 1 (Neon call 2, cut-off
completion). No call returned empty. No other model calls.

## Files written

- docs/ARCHITECTURE.md
- docs/DownstreamExamples.md
- docs/BaselineDecision.md
- docs/SobolevRoutes.md
- docs/InteropExample.md
- docs/MissingInventory.md
- neon-log.md
- astra-log.md
- generator-log.md (this file)

All inside ~/workspace/handover-mathlib-geometry-2026-11-26/ only.
No other folder written. No new .lean files created. The existing audit file
was not modified. Probe files for U2 live in /tmp/u2probes/ only and are not
deliverables.

## Cost

- Hard cap: $4. Run budget: $3.40. Held back: $0.60.
- The tool reports no dollar figure, so no dollar spend is claimed here.
  Six model calls were made, all first-attempt except the one cut-off retry.
  No figure is invented.

## Fix attempts used

- 0 of 5. No checker verdict has been received, so no fix cycle ran.
- The Neon call 1 cut-off retry is a model-call retry, not a fix attempt.

## Verification done by the generator (not by the models)

- Lean probes 1 to 4 re-run with `lake env lean` against the v4.23.0 tree,
  each failing with the exact Unknown identifier error quoted in
  docs/DownstreamExamples.md. An `import Mathlib` probe failed differently
  (Mathlib.olean not built in this tree); single-module imports were used.
- PR 36128 status, file list, line counts, and import chains re-checked via
  GitHub API and raw file reads at head 8968a1246.
- CovariantDerivative landing window re-checked via contents API: 404 at
  v4.24.0 through v4.28.0, 200 at v4.29.0 and v4.36.0. Sobolev.lean 404 at
  v4.29.0, 200 at v4.36.0 and on master. Latest release v4.36.0, 16 Nov 2026.
- All U6 grep results re-checked in the local v4.23.0 tree. Lax-Milgram is
  the only present item of the 15.
- All U5 file and line citations re-checked by grep and match Phase 0
  inventory-v02.md exactly.
- Neon errors corrected in the docs, not hidden: the invented
  Mathlib.Geometry.Manifold.Riemannian.Distance path (404 in v4.36.0),
  the missing VectorBundle segment in one header path, the unverified
  HasWeakDerivAt upstream claim in Neon's call 3, and Neon's "p > 0 cannot
  supply pos" framing, corrected by Astra to mixed signature as the
  obstruction.

## Claims not verified, gaps left open

- HasWeakDerivAt on v4.36.0: not verified either way. GitHub code search
  needs auth (401). No weak-derivative API name is asserted in any doc.
  Owner: Phase 1 lead, to check before relying on any weak-derivative name.
- Upgrade effort across 13 releases (build time, breaking changes in other
  dependencies): not measured. Owner: Phase 1 lead, before the baseline move
  is executed.
- Missing inventory on v4.36.0: only CovariantDerivative, IsLeviCivitaConnection,
  Sobolev.lean, and TemperedDistribution.lean were checked. The other absent
  items were not re-audited on v4.36.0. Owner: Phase 1 lead.
- Signature (p, q) ordering: Phase 0 docs/RFC_PseudoRiemannian.md is
  internally inconsistent (p minus ones, Lorentzian (1, 3), Riemannian (n, 0)
  cannot all hold). Neon and Astra both use (pluses, minuses), Lorentzian
  (3, 1). The ordering must be locked before any file is written, and locking
  (pluses, minuses) requires amending the Phase 0 RFC. Owner: Richardson
  (review) with the Phase 1 lead. This is the one open decision the checker
  and judge should rule on explicitly.
- Phase 3 acceptance test parameters (dimension, target exponent, weight
  convention, domain and regularity hypotheses for Poincare and trace) are
  not fixed by the plan. Astra names them as open choices. Owner: Phase 3 lead.
- No hostile review was done by the generator, by design. U7 does it.
