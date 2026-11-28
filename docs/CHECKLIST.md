# Checklist: build the geometry and PDE layer Mathlib lacks

Goal: a Lean library where a researcher can write down a Lorentzian metric, compute its curvature, state the Einstein vacuum equations, state Kerr stability, and state a mass gap, with every definition checked by Lean. Baseline: Mathlib v4.36.0. Acceptance for every item: Lean exit 0, no sorry, axioms only propext, Classical.choice, Quot.sound.

Last updated: 28 Nov 2026. Done: 17 of 47. Running: 8 tracks.

## Phase 0: audit and architecture

- ✅ Audit inventory done, 43 #check lines, re-verified live on v4.36.0
- ✅ Signature lock in writing: (p, q), Lorentzian (3, 1), (-, +, +, +)
- ✅ RFCs written and amended (planning docs DONE v03, pushed)
- ❌ RFCs approved by a Mathlib maintainer (not sought yet)

## Phase 1: Lorentzian metric, Levi-Civita, Ricci

- ✅ Metric interface, signature (p, q) parameterized
- ✅ Flat Levi-Civita connection on R^n
- ✅ Minkowski flat test, Riemann, Ricci, scalar all zero
- ✅ 2D Minkowski showcase, determinant -1, Lean and Python agree
- ✅ Sphere test, spherical form, discriminating (deleting the key term breaks the build)
- ❌ Compiled indefinite Levi-Civita example (running, close-out track)
- ❌ Step 0 import check (running, close-out track)
- ❌ Scoped-instances decision (running, close-out track)
- ❌ Migration build on v4.36.0 (running, close-out track)
- ❌ Hilbert6 portability audit (running, close-out track)
- ❌ Linter cleanup, 37 warnings (in close-out track)
- ❌ Levi-Civita uniqueness proof (in close-out track)
- ❌ General-manifold Levi-Civita existence (not in any track yet)
- ❌ Riemann, Ricci, scalar for general non-flat metrics (not in any track yet)
- ❌ Bianchi identities as theorems (running, divergence track)
- ❌ Merged in Mathlib, or staging repo with review blockers listed (phase exit)

## Phase 2: Einstein equations and Ricci flat

- ✅ Vacuum equations stated, both forms
- ✅ Minkowski G = 0
- ✅ Schwarzschild Ric = 0 on its regular chart, all 16 components
- ❌ API job: ginv as a field, chart domain, bundled API, inverse proof (running)
- ❌ Einstein tensor divergence-free from Bianchi (running)

## Phase 3: Sobolev, energy estimates, PDE tools

- ✅ W^{1,2} first slice: weak derivatives, norm, Hilbert structure
- ✅ Bridge stated forward-only, h tied to the Bessel witness
- ✅ Carrier design: parameterized W^{k,p}, rewrite decision
- ❌ Bridge proof, H^1 = W^{1,2} (running, wave 2)
- ❌ Sobolev embedding H^1(R^3) into L^6 (running, wave 2)
- ❌ Poincare inequality (running, wave 2)
- ❌ Trace theorem (running, wave 2)
- ❌ Weighted spaces and bounded domains (running, wave 2)
- ❌ Sobolev spaces of tensor fields on a manifold (not started)
- ❌ Energy currents and divergence theorem on Lorentzian domains (not started)
- ❌ Gronwall and energy estimates for the linear wave equation (not started)

## Phase 4: Kerr metric and horizons

- ✅ Horizons located: Delta = 0 at r+ and r-, Sigma positive at r+ (proved 25 Nov 2026)
- ❌ Kerr Ric = 0 on a regular chart (running, Track B)
- ❌ Coordinate poles and ring singularity handled explicitly (in Track B)
- ❌ Kerr files pushed to the repo (KerrMetric.lean lives in the run folder only)

## Phase 5: decay and stability scaffolding

- ❌ Stability statement in Lean, hypotheses named one by one (running, wave 1)
- ❌ Gap file listing every hypothesis with no Lean proof (running, wave 1)
- ❌ Energy and Morawetz quantities defined (not started)
- ❌ Decay scaffolding (not started)

Note: the full Kerr stability proof is out of scope for this plan. It is research, not a checklist item.

## Repo and proof of work

- ✅ CI green on every push so far
- ✅ README showcase with the 3D sphere, live
- ❌ Scoreboard updated to current state (stale, predates Einstein and Sobolev)
