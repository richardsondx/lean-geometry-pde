# Mathlib geometry and PDE infrastructure plan

- Date: 26 Nov 2026
- Status: plan only, no Lean code, no proof claimed
- Novelty: Tier 0, a map and a plan, no new result
- Baseline: Lean 4.23.0, Mathlib v4.23.0
- Model used for drafting: Gemini 4 Neon, via OpenRouter as google/gemini-4-neon, through or_chat.py, max_tokens 8000
- Neon note: Neon replied, but the tool result cut off mid Phase 0. Phases 1 to 5 below are my synthesis, checked against the sources in the Sources section. They are not verbatim Neon output.
- Rule: map only, no toy proofs, no claim of a proof unless it touches the bottleneck

## Goal, in plain language

Mathlib can describe smooth shapes and positive definite geometry. It cannot yet describe spacetime, where one direction behaves like time and three behave like space. It cannot yet describe the Einstein equations in Lean, or the function spaces that PDE proofs use on curved space.

This plan builds that missing layer. The end state is a Lean library where a researcher can write down a Lorentzian metric, compute its curvature, state the Einstein vacuum equations, state Kerr stability, and state a mass gap, with every definition checked by Lean.

This plan does not prove Kerr stability. It does not prove the Yang-Mills mass gap. It builds the floor those proofs would stand on.

## What Mathlib already has

Checked 26 Nov 2026 against Mathlib docs, the Mathlib overview page, and the files named below. Items marked uncertain need a Phase 0 check against the exact v4.23.0 tree.

- Smooth manifolds: smooth or analytic manifolds with boundary and corners, smooth maps, tangent bundles, vector bundles, Lie brackets, integral curves, Lie groups. Source: Mathlib overview, Geometry section.
- Riemannian manifolds: Riemannian bundle metric, smooth bundle metric, inner product on each tangent space, extended distance from path length. Source: Mathlib/Geometry/Manifold/Riemannian/Basic, and the Mathlib overview.
- Covariant derivatives and Levi-Civita: a Mathlib pull request adds CovariantDerivative, IsLeviCivitaConnection, LeviCivitaConnection, and ChristoffelSymbol in Mathlib/Geometry/Manifold/VectorBundle/CovariantDerivative/LeviCivita. Source: Mathlib PR 36128, by grunweg. Uncertain: whether this PR is merged in v4.23.0. Phase 0 must check the exact tree, and must not assume it is in.
- Riemannian tensor calculus in a satellite project: the Hamilton three-manifold formalization, arXiv 2608.21502, Aug 2026, builds Riemannian tensor calculus, the Levi-Civita connection, Ricci flow evolution, and maximum principles, with the metric as SmoothRiemannianMetric. That work lives outside Mathlib core. It proves the pattern works in Lean. It does not put the API in Mathlib.
- Measure and Lp: Bochner integral, Lp spaces, Holder and Minkowski, Fubini and Tonelli, Fourier transform on R^n.
- Schwartz functions and tempered distributions: SchwartzMap, tempered distributions as the dual of Schwartz space, Fourier transform extended to L2. Source: arXiv 2510.24060, Formalizing Schwartz functions and tempered distributions.
- Sobolev spaces on flat space, one kind: Mathlib/Analysis/Distribution/Sobolev defines Sobolev spaces on normed vector spaces through the Fourier transform, as Bessel potential spaces. A tempered distribution u is in H^{s,p} when its Bessel potential is in Lp. The file proves Schwartz functions lie in every Sobolev space, derivatives lower the order by 1, and the Laplacian lowers it by 2. Source: Mathlib/Analysis/Distribution/Sobolev.
- Functional analysis: Banach and Hilbert spaces, bounded linear operators, Riesz representation, Hahn-Banach.
- ODE basics: Picard-Lindelof local existence and uniqueness, Gronwall.

## What Mathlib already has, stated carefully

- Sobolev spaces exist in Mathlib only in the Bessel potential form on flat vector spaces. W^{k,p} on a domain, W^{k,p} on a manifold, Sobolev embeddings, trace theorems, and weighted Sobolev spaces do not exist in Mathlib as far as the sources checked show. Phase 0 must confirm each one by name in the tree.
- A Lorentzian metric type does not exist in Mathlib. Physicslib4 says this directly in its Spacetime docs: Mathlib provides Riemannian metrics, but no Lorentzian or pseudo-Riemannian metric type.
- A general pseudo-Riemannian API does exist outside Mathlib, in Physicslib4. That changes Phase 1 from building from scratch to porting and generalising an existing layer. See the next section.

## What exists outside Mathlib, and why it matters

- Physicslib4, Spacetime: a real, four dimensional, connected, smooth, Hausdorff manifold M with a globally defined smooth, non-degenerate, symmetric, Lorentzian (0,2) tensor field g. The Lorentzian condition is LorentzianAt, a basis with Gram matrix diag(-1, 1, 1, 1). Signature is (-, +, +, +). The structure carries no time orientation. Time orientation is separate data. Source: Physicslib4 Spacetime Basic docs, crawled 23 Nov 2026.
- Physicslib4, pseudo-Riemannian layer: Spacetime.toPseudoRiemannianMetric gives access to the general pseudo-Riemannian API, with musical isomorphisms and the Levi-Civita connection. Source: same docs page.
- PhysLean: Lorentz vectors, Minkowski spacetime as Lorentz.Vector, Minkowski product, Lorentz group, causal structure for the twin paradox. This covers flat spacetime, not curved spacetime.
- MathPhysics project: builds Lorentz groups and curvature in pure Lean, with no Mathlib dependency. Useful only for isolated algebraic ideas, not as a Mathlib layer.

## What is missing, hardest first

- Hardest: nonlinear hyperbolic PDE and dispersive estimates on Kerr. Quasilinear wave well-posedness, Morawetz and integrated local energy decay, r^p weighted energy estimates, the vector field method, trapping and superradiance. This is the analytic bottleneck for Kerr stability. Formalising definitions does not touch it.
- Next: constructive QFT and spectral theory for Yang-Mills. Wightman or Osterwalder-Schrader axioms, operator valued distributions, principal G-bundle connections, a spectral gap on an infinite dimensional Hilbert space. This diverges from Kerr after Phase 1 and Phase 3. It is a separate track, not a Kerr corollary.
- Next: global Lorentzian causality and the initial value formulation. Time orientation, causal curves, global hyperbolicity, Cauchy hypersurfaces, constraint equations, maximal globally hyperbolic development. Without this, the Einstein equations cannot be stated as an evolution problem in Lean.
- Next: Sobolev spaces on manifolds and weighted spaces. Weak derivatives on tensor bundles, H^s and weighted H^s_delta for asymptotic flatness, embeddings, trace theorems, divergence theorem on Lorentzian domains.
- Next: coordinate free pseudo-Riemannian geometry. Constant signature non-degenerate symmetric bilinear forms on tangent bundles, musical isomorphisms, torsion free metric compatible Levi-Civita connection without positive definiteness, Riemann curvature, trace and contraction API, Ricci tensor, scalar curvature, Bianchi identities.
- Easiest of the missing pieces, and still undone: a Lean Kerr metric on a regular chart, with a checked proof that Ric equals 0. This is definitions plus a computation. It does not move the analytic bottleneck.

## Phased roadmap

Repository policy: general mathematics in Phases 1 to 3 targets Mathlib directly, developed in a staging repo if needed, upstreamed continuously. Concrete Kerr geometry and stability statements in Phases 4 to 5 live in a satellite repo, for example KerrLean, depending on Mathlib. Yang-Mills gauge theory lives in a second satellite repo, sharing Phases 1 and 3.

Acceptance test for every phase: Lean exit 0, no sorry, no admit, and #print axioms reports only propext, Classical.choice, and Quot.sound for each new theorem. A definition with no theorem still needs Lean exit 0 and a compiled example that uses it.

### Phase 0: audit and architecture

- Goal: remove every uncertain item in this plan, and lock conventions before heavy code.
- Work: machine checked #check inventory of v4.23.0 manifold, Riemannian, bundle, distribution, Sobolev, and ODE APIs. Read the Levi-Civita PR 36128 status in the exact tree. Read the Physicslib4 pseudo-Riemannian files line by line. Read the Hamilton Ricci flow repo for its tensor calculus interface.
- Decisions to lock in writing: generalise the Riemannian metric to a PseudoRiemannianMetric, or build a parallel class. Signature convention (-, +, +, +) for general relativity, with the general API parameterised by p and q. Tensor contraction representation. Sobolev design: Bessel potential on flat space first, then W^{k,p} on domains, then on manifolds.
- Lean files: Audit/MathlibInventory.lean, with #check lines for every API named in this plan. Docs: docs/RFC_PseudoRiemannian.md, docs/RFC_Sobolev.md, docs/RFC_Conventions.md.
- Acceptance: every uncertain item in this plan is marked confirmed present, confirmed absent, or confirmed in a named satellite repo, with a file path and a line number.
- Effort: 2 to 4 weeks for one experienced Lean contributor, full time. Add 2 weeks if the contributor is new to Mathlib review standards.
- Exit: the RFCs are approved by at least one Mathlib maintainer, or the plan records that approval was not sought and why.

### Phase 1: Lorentzian metric, Levi-Civita, Ricci

- Goal: a general pseudo-Riemannian metric in Mathlib, with curvature and Ricci, built by porting and generalising the Physicslib4 layer.
- Definitions to add: PseudoRiemannianMetric with signature (p, q) as a smooth section of symmetric bilinear forms, non-degenerate at every point. LorentzianMetric as the signature (3, 1) case, with the (-, +, +, +) convention locked. Musical isomorphisms, sharp and flat. Levi-Civita connection, torsion free and metric compatible, proved unique through the Koszul formula. Riemann curvature with one fixed sign convention, recorded in the file header. Ricci tensor as the trace, Ricci operator as the raised endomorphism, scalar curvature as the further trace. Bianchi identities.
- Lean files, proposed: Mathlib/Geometry/Manifold/PseudoRiemannian/Basic.lean, Mathlib/Geometry/Manifold/PseudoRiemannian/LeviCivita.lean, Mathlib/Geometry/Manifold/PseudoRiemannian/Curvature.lean, Mathlib/Geometry/Manifold/PseudoRiemannian/Ricci.lean.
- Acceptance: Minkowski spacetime is an instance, with signature checked by Lean. A round trip test: flat metric gives zero Riemann, zero Ricci, zero scalar curvature, proved in Lean. A non-flat test: the round sphere, or Schwarzschild in a chart, gives the expected Ricci values, proved in Lean.
- Effort: 6 to 18 person-months if the Physicslib4 layer ports cleanly. 12 to 36 person-months if the port needs a redesign of the bundle section API. The range is wide because Mathlib review is the long pole, and review time is not coding time.
- Exit: the files are merged in Mathlib, or they live in a staging repo with a written list of review blockers.

### Phase 2: Einstein equations and Ricci flat

- Goal: state the Einstein equations in Lean, and prove the first Ricci flat examples.
- Definitions to add: Einstein tensor G equals Ric minus one half R g. Vacuum Einstein equation Ric equals 0. Einstein equation with matter, G plus Lambda g equals 8 pi T, with T as a symmetric (0,2) tensor field. Energy conditions as predicates, not as theorems.
- Lean files, proposed: Mathlib/Geometry/Manifold/PseudoRiemannian/Einstein.lean, and in the satellite repo KerrLean/EinsteinVacuum.lean.
- Acceptance: Minkowski space satisfies Ric equals 0, proved in Lean. Schwarzschild satisfies Ric equals 0 on its regular chart, proved in Lean. The Einstein tensor is divergence free, proved in Lean from the Bianchi identities.
- Effort: 3 to 9 person-months, after Phase 1. The computation is heavy in Lean, and the risk is performance, not mathematics.
- Exit: at least one non-trivial Ricci flat example is checked by Lean, with no sorry.

### Phase 3: Sobolev, energy estimates, PDE tools

- Goal: the function spaces and energy tools that PDE proofs use, on flat space first, then on manifolds.
- Definitions to add: W^{k,p} on open subsets of R^n through weak derivatives, H^s through the Bessel potential already in Mathlib, Sobolev embeddings, Poincare inequality, trace theorem, weighted Sobolev spaces H^s_delta for asymptotic flatness, Sobolev spaces of tensor fields on a manifold, energy currents and divergence theorem on Lorentzian domains, Gronwall and basic energy estimates for the linear wave equation.
- Lean files, proposed: Mathlib/Analysis/Distribution/SobolevDomain.lean, Mathlib/Analysis/Distribution/SobolevEmbedding.lean, Mathlib/Analysis/PDE/WaveEnergy.lean, Mathlib/Geometry/Manifold/Sobolev.lean.
- Acceptance: H^1 functions on R^n satisfy the Sobolev embedding proved in Lean for the cases the plan claims. The linear wave equation on Minkowski space has an energy estimate, proved in Lean. A weighted space test: a function decaying like r^{-1} at infinity lies in the claimed weighted space, proved in Lean.
- Effort: 12 to 36 person-months. This is the largest infrastructure phase. Embeddings and trace theorems are long formalizations, and the weighted case is harder than the flat case.
- Exit: the wave energy estimate is merged, or the staging repo lists the exact lemmas still missing.

### Phase 4: Kerr metric and horizons in Lean

- Goal: the Kerr metric as a Lorentzian metric in Lean, with its horizons located and its Ricci flatness checked.
- Definitions to add: Boyer-Lindquist coordinates (t, r, theta, phi), parameters M greater than 0 and |a| less than M, Delta equals r^2 - 2Mr + a^2, Sigma equals r^2 + a^2 cos^2(theta), the Kerr line element in the (-, +, +, +) convention, the exterior region r greater than r+, the event horizon r equals r+ and the inner horizon r equals r-, the ring singularity Sigma equals 0.
- Lean files, proposed, satellite repo: KerrLean/KerrMetric.lean, KerrLean/KerrHorizons.lean, KerrLean/KerrRicciFlat.lean.
- Acceptance: Delta equals 0 at r+ and r-, proved in Lean, reusing the 8 elementary theorems already proved 25 Nov 2026. Sigma is positive at r+, proved in Lean. Ric equals 0 for Kerr on a regular chart, proved in Lean, no sorry. The coordinate pole at Delta equals 0 is handled explicitly, with a note that it is a coordinate pole, and the ring singularity is handled explicitly.
- Effort: 6 to 18 person-months, after Phases 1 and 2. The Ricci flat computation is the long part, and Lean performance on the tensor algebra is the main risk.
- Exit: KerrRicciFlat.lean compiles with no sorry, and the file header states exactly which chart it covers and which points it excludes.

### Phase 5: decay and stability scaffolding

- Goal: state Kerr stability in Lean, with the scaffolding for decay, and state clearly what is still missing.
- Definitions to add: asymptotically flat initial data as a predicate, a nearby Kerr solution as a predicate, convergence to a nearby Kerr at a stated rate, energy and Morawetz quantities as definitions, trapped null geodesics as a predicate, superradiance as a statement about energy.
- Lean files, proposed, satellite repo: KerrLean/StabilityStatement.lean, KerrLean/DecayScaffolding.lean, KerrLean/EnergyMorawetz.lean.
- Acceptance: the stability statement compiles, and its hypotheses are named one by one. No theorem claims the stability result. A gap file lists every hypothesis that has no Lean proof, with the paper and theorem that proves it in mathematics, or with the word open if no paper proves it.
- Effort: 24 to 60 person-months for the scaffolding alone. The full stability proof is out of scope for this plan. It is research, and it depends on the 2026 preprints by Hintz and Szeftel being verified by peer review or by a second group. A realistic range for the proof itself, if it were attempted, is 5 to 10 person-years, and that range is a guess.
- Exit: StabilityStatement.lean compiles, and the gap file is complete. No DONE verdict is claimed for Kerr stability.

## Total effort, honest ranges

- Phases 0 to 2: 11 to 31 person-months, about 1 to 3 person-years.
- Phase 3: 12 to 36 person-months, about 1 to 3 person-years.
- Phase 4: 6 to 18 person-months, about 0.5 to 1.5 person-years.
- Phases 0 to 4 total: 29 to 85 person-months, about 2.5 to 7 person-years.
- Phase 5 scaffolding: 24 to 60 person-months, about 2 to 5 person-years, with no proof at the end.
- These ranges assume experienced Lean contributors and active Mathlib review. A single person working part time multiplies the calendar time. A team of 3 to 5 shortens it, and adds coordination cost.

## Biggest risks

- Sign conventions: Riemann, Ricci, and the Einstein tensor each have two sign choices in the literature. A wrong choice early forces a rewrite of every later file. Phase 0 locks one convention in writing, and every file header repeats it.
- Coordinate singularities: Boyer-Lindquist coordinates break at Delta equals 0 and at the poles. A Lean proof that ignores the chart breaks at exactly those points. Phase 4 must name its chart and its excluded points.
- Lean performance: tensor calculus with explicit indices is slow in Lean. The Hamilton Ricci flow project and the Physicslib4 layer both hit this. The plan must budget time for performance work, and must test compile times at the end of each phase.
- Mathlib review standards: Mathlib merges slowly, and review asks for general statements, not physics specific ones. A Lorentzian layer written only for 4d general relativity will be asked to generalise to signature (p, q). Phase 1 builds the general case first, then the 4d case.
- The analytic bottleneck stays: Phases 0 to 4 build definitions. They do not prove energy decay, Morawetz estimates, or nonlinear stability. A reader who confuses definitions with the proof will overclaim. The gap file in Phase 5 exists to stop that.
- Yang-Mills diverges: after Phase 1 and Phase 3, Yang-Mills needs gauge theory, principal bundles, and constructive QFT. Those are a second project, with their own risks. This plan does not fold them into Kerr.
- People: this is a multi-year project. It needs maintainers who stay, and a staging repo that survives Mathlib version changes. Lean 4.23.0 will not be the current version in a year.

## What this would unlock, for mathematicians and for physics

- For mathematicians: a general pseudo-Riemannian layer in Mathlib, usable for any signature, not only Lorentzian. That layer serves differential geometry, geometric analysis, and PDE, and it removes the need for every project to rebuild Levi-Civita and Ricci from scratch.
- For PDE researchers: Sobolev spaces on manifolds and weighted spaces in Lean, with energy estimates for the wave equation. That is the shared base for wave, Einstein, and Yang-Mills work.
- For physics: a checked statement of the Einstein equations, a checked Kerr metric with Ric equals 0, and a checked statement of Kerr stability with named gaps. A physicist can read the gap file and see exactly which estimates are missing, instead of guessing.
- For the Yang-Mills mass gap: the same Sobolev and gauge theory base, plus a checked statement of the Wightman or Osterwalder-Schrader axioms. The mass gap itself stays open. The plan only makes it statable.
- For the community: every later project starts from Phase 1, instead of from zero. That is the real return. It is infrastructure, and its value is measured in projects it enables, not in theorems it proves.

## Workbench track, UI and UX

- The Lean work needs a workbench site. One concrete example per result, interactive where possible, with scope stated on the page.
- Design this site with Claude Opus 5.5, after Phase 0 locks conventions. Designing it before Phase 0 risks showing definitions that change.
- The site carries: the plan, the audit, per phase status, per file status, the gap file, and a search page. It does not carry proof claims. A phase is marked done only when Lean exits 0 with no sorry.
- Effort for the site: 1 to 3 person-months for a first version, separate from the Lean effort. It is not a substitute for the Lean work.

## What not to do

- Do not present a toy theorem as progress. A definition with no theorem is a definition. A theorem about Delta and Sigma is algebra, and it stays labelled algebra.
- Do not claim Kerr stability or the Yang-Mills mass gap from any phase in this plan. Phases 0 to 4 build the floor. Phase 5 states the problem and lists gaps.
- Do not build a Lorentzian layer only for 4d. Mathlib review will ask for the general signature case. Build general first, then specialise.
- Do not copy the Physicslib4 layer without reading it. Port it, generalise it, and record what changed and why.
- Do not start Phase 4 before Phase 1 compiles. A Kerr metric with no Levi-Civita connection behind it is a formula, and it cannot support a Ricci flat proof.
- Do not hide the analytic bottleneck. Every report names it: nonlinear dispersive PDE estimates at fixed |a| less than M, without small spin.
- Do not run a build without stating where it runs and what it costs. That rule stands for this project too.

## Relationship to the 10 small targets

- The 10 small target hunt runs in parallel, in the main repo, under the map only rule for the big physics targets.
- The small targets give fast Lean wins, in combinatorics and number theory, where Mathlib already has the tools.
- This infrastructure plan gives slow, large wins, where Mathlib does not yet have the tools.
- The two tracks share one rule: Lean decides, and a claim needs a Lean check with no sorry.

## Sources

- Kerr map, 25 Nov 2026: ~/workspace/handover-kerr-lorentzian-metric-2026-11-25/map-v02.md. Gap: Mathlib holds no Lorentzian metric definition, no Levi-Civita connection on Lorentzian manifolds, no curvature trace, no Kerr metric. Bottleneck: nonlinear dispersive PDE estimates.
- Mathlib overview, Geometry section: smooth manifolds, vector bundles, covariant derivatives, Riemannian manifolds. https://leanprover-community.github.io/mathlib-overview.html
- Mathlib Riemannian Basic docs: IsRiemannianManifold, RiemannianBundle, ContMDiffRiemannianMetric. https://leanprover-community.github.io/mathlib4_docs/Mathlib/Geometry/Manifold/Riemannian/Basic.html
- Mathlib PR 36128, Levicivita minimal, by grunweg: CovariantDerivative, IsLeviCivitaConnection, LeviCivitaConnection, ChristoffelSymbol. https://github.com/leanprover-community/mathlib4/pull/36128
- Hamilton three-manifold formalization, arXiv 2608.21502, Aug 2026: Riemannian tensor calculus, Levi-Civita connection, Ricci flow, SmoothRiemannianMetric. https://arxiv.org/pdf/2608.21502
- Mathlib Sobolev docs: Bessel potential spaces, TemperedDistribution.MemSobolev, BesselPotentialSpace. https://leanprover-community.github.io/mathlib4_docs/Mathlib/Analysis/Distribution/Sobolev.html
- Schwartz and tempered distributions, arXiv 2510.24060: first formalization in any proof assistant, Fourier transform on L2, Sobolev spaces defined. https://arxiv.org/html/2510.24060
- Physicslib4 Spacetime Basic docs, crawled 23 Nov 2026: LorentzianAt, Spacetime, toPseudoRiemannianMetric, musical isomorphisms, Levi-Civita connection. https://physicslib.github.io/physicslib4/docs/Physicslib4/Spacetime/Basic.html
- PhysLean: Lorentz.Vector, Minkowski product, Lorentz group, SpaceTime. https://deepwiki.com/leanprover-community/physlib/2.1-space-and-spacetime-types
- Kerr stability papers, from the Kerr map: Klainerman and Szeftel 2021, arXiv 2104.11857, Giorgi, Klainerman, and Szeftel 2022, arXiv 2205.14808, Hintz 2026 preprint arXiv 2606.28253, Szeftel 2026 preprint arXiv 2609.40068. The 2026 preprints are not peer reviewed as of 25 Nov 2026.
- Neon draft, 26 Nov 2026: used for structure, for the uncertain items list, and for the phased shape. Its output was cut off mid Phase 0 in the tool result. All claims in this plan were rechecked against the sources above, and corrections are recorded in the next section.

## Corrections to the Neon draft

- Neon flagged the Riemannian Levi-Civita API as uncertain. The check found PR 36128, which adds it, and the Hamilton project, which uses it. Phase 0 still must check whether PR 36128 is merged in v4.23.0.
- Neon flagged Sobolev spaces as uncertain. The check found they exist in Mathlib, but only as Bessel potential spaces on flat vector spaces. W^{k,p} on domains and manifolds, embeddings, and weighted spaces are still missing.
- Neon listed PhysLean and MathPhysics as external references. The check found a stronger starting point: Physicslib4 already has a Spacetime definition and a pseudo-Riemannian API with Levi-Civita. Phase 1 is a port and a generalisation, and the plan says that plainly.
- Neon gave no effort numbers in the portion received. The effort ranges in this plan are mine, and they are rough. They are labelled as ranges, and they assume experienced contributors and active review.

## Next decision

- Approve Phase 0 only, with a 2 to 4 week audit and RFCs, before any Phase 1 code.
- The Phase 0 deliverables are the audit file and three RFCs, each with a named maintainer reviewer or a recorded note that review was not sought.
- No Lean code for Phases 1 to 5 is written until Phase 0 is done and the conventions are locked.
