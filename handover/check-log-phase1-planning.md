# U7 independent check log, stage2-mathlib-geometry-phase1-planning-01

Date: 26 Nov 2026, evening EST. Checker: independent, did not write the artifacts.
Work folder: ~/workspace/handover-mathlib-geometry-2026-11-26/
Spec: stage1-package-phase1-planning-v01.md, stage2-manifest-phase1-planning-v01.md,
predicate pred-mathlib-geometry-phase1-planning-v01.
Baseline checked: Lean 4.23.0, Mathlib v4.23.0, local tree
~/workspace/kerr-stability-lean/kerr-mathlib/.lake/packages/mathlib,
commit 37df177aaa770670452312393d4e84aaad56e7b6, tag v4.23.0
(verified by `git rev-parse HEAD` and `git describe --tags`).
Role split checked: Astra openai/gpt-6.2-astra authored U2, U4, U5;
Neon google/gemini-4-neon authored U1, U3, U6.

## Final verdict: FAIL

The Lean core re-verifies cleanly and most tree citations are exact, but three
things block a PASS, and all three are narrow and fixable in one fix cycle:
(1) neither hostile review could be obtained, because outbound network egress
failed on every attempt during this check, so the cross-review the task
requires is missing, not merely thin; (2) the live sources for the baseline
decision could not be re-opened for the same reason, so the v4.36.0 claims
rest on the generator's verification alone; (3) two Neon path errors the
generator says are corrected still sit in the operative text of
docs/ARCHITECTURE.md, one of them carrying a false "verified in Step 0"
claim. Gaps are listed by name at the end. Fixable in one fix cycle: yes,
explicitly. The fix cycle is: correct the two paths, the two grep wordings,
and the two missing imports in the docs; have Richardson lock the signature
ordering and amend the two RFCs; then re-run the two saved hostile-review
prompts and the live-source checks when egress recovers. No predicate, cost,
or scope change is needed.

## Check 1: Re-run the 4 Lean probes in DownstreamExamples.md: PASS

Commands run, with `export PATH="$HOME/.elan/bin:$PATH"`, from
~/workspace/kerr-stability-lean/kerr-mathlib, `lake env lean` on probe files
in /tmp/u7probes/ (single-module imports, as the Phase 0 audit file does):

- Probe 1: imports Mathlib.Geometry.Manifold.VectorBundle.Riemannian, line
  `#check @CovariantDerivative`, error:
  `/tmp/u7probes/p1.lean:2:8: error(lean.unknownIdentifier): Unknown identifier
  'CovariantDerivative'`. Exit 1. Matches the quoted error exactly.
- Probe 2: imports Mathlib.Analysis.Distribution.SchwartzSpace, line
  `#check @TemperedDistribution.MemSobolev`, error: Unknown identifier
  `TemperedDistribution.MemSobolev`. Exit 1. Matches exactly.
- Probe 3: same import, line `#check @HasWeakDerivAt`, error: Unknown
  identifier `HasWeakDerivAt`. Exit 1. Matches exactly.
- Probe 4: imports Mathlib.Geometry.Manifold.Riemannian.Basic, line
  `#check @MeasureTheory.integral_stokes`, error: Unknown identifier
  `MeasureTheory.integral_stokes`. Exit 1. Matches exactly.

All four probes fail as quoted. DownstreamExamples.md correctly records probe
3 as a probe name only, with no weak-derivative API asserted.

## Check 2: Grep the local Mathlib tree for every present/absent claim: MIXED

Method: `grep -rn --include="*.lean"` over the whole v4.23.0 tree, plus
targeted file and line reads. Present claims verified exact, line by line:

- volumeForm: Mathlib/Analysis/InnerProductSpace/Orientation.lean:166,
  `irreducible_def volumeForm`. Confirmed (the doc says "flat-space
  volumeForm", which is what this is).
- Box divergence theorem:
  hasIntegral_GP_divergence_of_forall_hasDerivWithinAt at
  Mathlib/Analysis/BoxIntegral/DivergenceTheorem.lean:258. Confirmed.
- laplacian at Mathlib/Analysis/InnerProductSpace/Laplacian.lean:135,
  laplacianWithin at :124. Confirmed.
- continuousLinearEquivOfBilin: `def` at
  Mathlib/Analysis/InnerProductSpace/LaxMilgram.lean:102. Confirmed. Lax-Milgram
  is the one present item of the 15, as the inventory says.
- eLpNorm_le_eLpNorm_fderiv_one at
  Mathlib/Analysis/FunctionalSpaces/SobolevInequality.lean:437. Confirmed.
- Interop citations, all exact: Bundle.ContMDiffRiemannianMetric structure at
  Mathlib/Geometry/Manifold/VectorBundle/Riemannian.lean:238, fields inner,
  symm, pos, isVonNBounded, contMDiff, in that order; Bundle.RiemannianBundle
  class at Mathlib/Topology/VectorBundle/Riemannian.lean:420;
  IsContMDiffRiemannianBundle class at VectorBundle/Riemannian.lean:62;
  IsRiemannianManifold class at Riemannian/Basic.lean:77;
  Manifold.riemannianEDist, `noncomputable irreducible_def`, at
  PathELength.lean:205; the instance
  `instance (g : ContMDiffRiemannianMetric IB n F E) : RiemannianBundle E`
  plus IsContMDiffRiemannianBundle at VectorBundle/Riemannian.lean:257
  (the doc says "right after the structure"; strictly there are two
  conversion defs between, lines 248-255, so "right after" is loose but the
  instance is the next declaration after them); two scoped priority-80
  Bundle-namespace instances giving NormedAddCommGroup and InnerProductSpace
  on each fiber at Topology/VectorBundle/Riemannian.lean:431 and :442.
  Confirmed.

Absent claims, confirmed as substantive absences, with two literal wordings
wrong (GAP-5, GAP-6):

- DifferentialForm: 0 hits in the whole tree. Confirmed absent.
- Exterior derivative: 0 hits for the identifier `exteriorDerivative`;
  the only text hit is a doc comment in
  Mathlib/LinearAlgebra/Alternating/Uncurry/Fin.lean:39 mentioning that a
  result "will be used to prove that the second exterior derivative of a
  differential form is zero". No definition exists. Substantively absent.
- Stokes: 1 hit in the whole tree, a doc comment in
  Mathlib/Analysis/BoxIntegral/DivergenceTheorem.lean:38 listing "Stokes
  theorem" among the topics of that file. No manifold Stokes theorem exists.
  Substantively absent.
- Geodesics: "geodesic" hits only in
  Mathlib/Combinatorics/Quiver/Arborescence.lean (geodesicSubtree,
  geodesicArborescence) and
  Mathlib/GroupTheory/FreeGroup/NielsenSchreier.lean:282 (geodesicSubtree).
  Both are false positives. No Geodesic definition, no geometric expMap:
  `expMap` returns 0 hits in Mathlib/Geometry/Manifold. See GAP-6 for the
  unqualified wording.
- Curvature: `Ricci` returns 0 hits in the whole tree, case-insensitive
  `riemann.*curvat|ricci` returns 0 hits. No Riemann curvature, no Ricci.
  Confirmed absent. See GAP-5 for the literal "Riemann" wording.
- Weak derivatives: HasWeakDeriv, WeakDeriv, HasDistribDeriv all return
  0 hits. Confirmed absent.
- Compact embeddings: Rellich and CompactEmbedding both return 0 hits.
  Confirmed absent.
- ContinuousAlternatingMap: 76 hits tree-wide, 0 in Geometry/Manifold.
  Confirmed as the inventory states it.
- No Mathlib/Analysis/PDE directory. No Sobolev file in
  Mathlib/Analysis/Distribution (directory holds only
  AEEqOfIntegralContDiff.lean, FourierSchwartz.lean, SchwartzSpace.lean).
  No CovariantDerivative directory under
  Mathlib/Geometry/Manifold/VectorBundle. All confirmed absent.
- Count check: the inventory's "15 items" is correct, 12 named topics plus
  elliptic, parabolic, and hyperbolic PDE infrastructure counted separately.

## Check 3: Re-open the cited live sources for the baseline decision: NOT VERIFIED

This check could not be completed. Outbound network egress failed on every
attempt during this check, from the exec sandbox and from the browser tool:

- GitHub API batch (curl): PR 36128 status, PR files list, latest release,
  v4.36.0 release tag. All four curl calls returned empty bodies; the
  python JSON parse failed on empty input ("Expecting value: line 1 column
  1"). The command ran 361 seconds and exited 1.
- Connectivity probe after that failure: `curl --max-time 25` to
  openrouter.ai/api/v1/models and to api.github.com both returned HTTP 000
  with exit 28 (timeout). Egress was down at that moment, not just slow.
- browser.open on the PR 36128 page and on the v4.36.0 release page both
  failed with "browser_open failed: query network grant". Per the standing
  instruction those requests were not repeated, including with changed
  arguments or through another endpoint.

What this leaves unverified in this run (not falsified, unverified):
PR 36128 status and files (state open, merged false, mergeable false,
head 8968a1246, 13 files, 3,901 new lines, +307/-30 edited lines);
Mathlib v4.36.0 release date (claimed 16 Nov 2026); the CovariantDerivative
landing window (404 at v4.24.0-v4.28.0, 200 at v4.29.0 and v4.36.0);
Sobolev.lean presence at v4.36.0 and absence at v4.29.0;
CovariantDerivative structure at Basic.lean:366 in v4.36.0;
TemperedDistribution.MemSobolev and besselPotential in v4.36.0;
the master Sobolev.lean line numbers cited in SobolevRoutes.md
(besselPotential line 73, MemSobolev line 153);
the Hilbert6 LeviCivita first import at pinned commit ddbe9da;
the v4.36.0 Riemannian directory contents (only Basic.lean and
PathELength.lean).

These claims rest on the generator's verification alone for this run. Note
for the record: the Phase 0 checker independently verified the PR 36128
status (state open, merged false, merged_at null, created 2026-03-04) and
the Hilbert6 pinned-commit line citations in an earlier run, but this U7
check did not re-verify them, so they are carried, not re-confirmed.

## Check 4: Hostile reviews (cross-review): FAIL, not obtained

Required: Neon hostile reviews Astra's math (U2, U4, U5); Astra hostile
reviews Neon's architecture (U1, U3, U6). Neither review was obtained.
Tool: ~/workspace/custom-connectors/custom.openrouter-chat/bin/or_chat.py,
prompt via stdin only, never argv, --max-tokens 8000, as specified.

Call log, all four attempts:

- Call A1, Neon, model google/gemini-4-neon, --max-tokens 8000, prompt from
  /tmp/u7probes/prompt-neon-review.md via stdin: exit 1.
  `urllib.error.URLError: <urlopen error Remote end closed connection
  without response>`, raised in the HTTPS CONNECT tunnel
  (`http.client.RemoteDisconnected` in `_tunnel`). No reply text.
- Call A2, Neon, same model and prompt, the one allowed retry: exit 1,
  identical error, identical failure point. No reply text.
- Call B1, Astra, model openai/gpt-6.2-astra, --max-tokens 8000, prompt
  from /tmp/u7probes/prompt-astra-review.md via stdin: exit 1, identical
  proxy error. No reply text.
- Call B2, Astra, same model and prompt, the one allowed retry: exit 1,
  identical proxy error. No reply text.

Total model calls: 4 attempts, 0 successes, 0 replies. The tool reports no
dollar figure; call count only is reported, no cost is invented. Both
retries are now used; no further retry is within the task's allowance.
The prompts are recorded verbatim below so the fix cycle can re-run them
unchanged when egress recovers. The checker did not substitute its own
opinions for the missing reviews; its own findings are recorded separately
in Check 8, and the points the reviews were meant to adjudicate (notably
whether DownstreamExamples example 4 counts as a failing example, and
whether RiemannianInterop's scoped instances create a second registration
path) stay open.

### Prompt sent to Neon (reviewing Astra's math), verbatim

```
You are a hostile reviewer, Gemini 4 Neon. You are the architect; the mathematician (GPT-6.2 Astra) authored the math content below for Phase 1 planning of a Lean pseudo-Riemannian geometry layer. Review Astra's math only, not the architecture. Attack it. Be specific, name any claim that is wrong, overstated, or unverifiable from the evidence given.

CONTEXT, verified by an independent checker 26 Nov 2026 against the local Mathlib v4.23.0 tree (commit 37df177aaa770670452312393d4e84aaad56e7b6):
- All four Lean probes below were re-run with `lake env lean` and fail exactly as quoted (Unknown identifier each time).
- Interop citations verified: Bundle.ContMDiffRiemannianMetric structure at Mathlib/Geometry/Manifold/VectorBundle/Riemannian.lean:238 with fields inner, symm, pos, isVonNBounded, contMDiff; Bundle.RiemannianBundle class at Topology/VectorBundle/Riemannian.lean:420; IsContMDiffRiemannianBundle class at VectorBundle/Riemannian.lean:62; IsRiemannianManifold class at Riemannian/Basic.lean:77; Manifold.riemannianEDist defined at PathELength.lean:205; an instance (g : ContMDiffRiemannianMetric ...) : RiemannianBundle E plus IsContMDiffRiemannianBundle at VectorBundle/Riemannian.lean:257; two scoped priority-80 Bundle-namespace instances giving NormedAddCommGroup and InnerProductSpace on fibers at Topology/VectorBundle/Riemannian.lean:431,442.

ASTRA'S MATH, verbatim substance:

U2 DownstreamExamples.md, four examples:
1. Levi-Civita: state there exists a unique torsion-free metric-compatible covariant derivative on the tangent bundle. Probe: `#check @CovariantDerivative` after importing Mathlib.Geometry.Manifold.VectorBundle.Riemannian fails with Unknown identifier. Unblocker: CovariantDerivative, IsLeviCivitaConnection, LeviCivitaConnection; v4.36.0 also has the uniqueness theorem. Does not require curvature.
2. Sobolev Bessel route: for a tempered distribution u on R^d, state u is in H^0 iff its Fourier transform is represented by an L^2 function. Probe: `#check @TemperedDistribution.MemSobolev` after importing Mathlib.Analysis.Distribution.SchwartzSpace fails. Requested API: TemperedDistribution.MemSobolev with Bessel characterization, at order s the distribution (1+|xi|^2)^{s/2} u-hat is represented by an L^2 function. Order zero is the minimal test; needs no weak-derivative API.
3. Hilbert6 portability: state Hilbert6's chosen leviCivita satisfies IsLeviCivitaFor for the input metric. First import of the Hilbert6 LeviCivita file at commit ddbe9da is Mathlib.Geometry.Manifold.VectorBundle.CovariantDerivative.Torsion, absent in v4.23.0. Immediate unblocker: the compatible covariant-derivative and torsion API. The file supplies koszulConnection, exists_isLeviCivitaFor, leviCivita.
4. Metric interop: given a smooth metric g of signature (n,0), state the squared fiber norm obtained through its Riemannian registration equals g_b(v,v). Astra admits this is a conversion and instance-coherence obligation, NOT a recorded failed probe. A second Bundle.RiemannianBundle alongside the registration gives competing choices of metric and hence of fiber NormedAddCommGroup and InnerProductSpace. Typeclass search choosing one does not make both norms definitionally equal. With no registration, neither fiber norm nor InnerProductSpace is supplied by this metric, and Manifold.riemannianEDist and the IsRiemannianManifold equality cannot be used through this metric. Registration alone does not prove that equality.

U5 InteropExample.md, interop math:
- Convert the (n,0) metric to Bundle.ContMDiffRiemannianMetric by a plain definition, not an instance. Retain inner, symm, contMDiff; positive definiteness gives pos, and in finite dimension the positive-definite unit ball is bounded, giving isVonNBounded.
- Use the existing registration from that converted metric as the sole source of Bundle.RiemannianBundle, with the existing IsContMDiffRiemannianBundle instance. Keep the two priority-80 fiber instances in the Bundle scope.
- With (n,0) denoting positive signature, p>0 alone is not an obstruction. For mixed signature p,q>0, a negative vector violates pos. A nonzero null vector v violates isVonNBounded: the entire line tv lies in {w | g(w,w)<1}, since g(tv,tv)=0 for every real t. This is the light-cone obstruction.

U4 SobolevRoutes.md, two routes:
- Weak-derivative route W^{k,p}(Omega): u and weak derivatives through order k in L^p(Omega); weak derivative defined by integration-by-parts against smooth compactly supported test functions. Needs no tempered distributions. v4.23.0 has MemLp, Lp, Holder, Minkowski; eLpNorm_le_eLpNorm_fderiv_one is an inequality, not a space. On either baseline, build the weak-derivative formulation and the domain space. Serves Poincare inequality and trace theorem on domains, and the linear wave energy estimate on Minkowski space (acceptance test 2). Astra notes Phase 3 names both theorems but does not fix the domain and normalization hypotheses.
- Bessel potential route H^{s,p}(R^n): tempered distribution whose Bessel potential of order s is represented by an L^p function; p=2 for H^s. Whole-space definition, not weak derivatives on open subsets. On v4.36.0, use TemperedDistribution.besselPotential and TemperedDistribution.MemSobolev; SchwartzMap.memSobolev supplies Schwartz examples; MemSobolev.lineDerivOp and MemSobolev.laplacian lower order by one and two. These do not supply the Phase 3 embedding. Serves Sobolev embedding (acceptance test 1): state for u in H^1(R^n) in the Bessel sense, fix dimension and target exponent per claimed case. Weighted membership (acceptance test 3): membership in H^s_delta for r^{-1} decay; build the weighted definition, specify weight convention, s, delta, local regularity and derivative decay. Unweighted Bessel membership is not this test; decay alone does not specify Sobolev regularity.
- Bridge: on R^n, prove agreement of weak W^{1,2} with Bessel H^1, including the norm comparison needed to transfer an estimate. v4.36.0: Bessel route first for whole-space H^1, then weak route, then bridge. v4.23.0: start with weak W^{k,p}; Bessel definition and bridge remain obligations.

ATTACK THESE POINTS, at least:
1. Example 4 has no failing probe. Is it a downstream example at all, or a design obligation dressed as one? Does the equality it states actually follow from registration, or is it unproven either way?
2. Is the light-cone argument correct as stated? Check the null-vector claim for isVonNBounded, and whether pos fails for a null vector (g(v,v)=0 is not <0, so is pos really violated by a null vector, or only by a negative vector?). Astra says a negative vector violates pos and a null vector violates isVonNBounded; is that split right?
3. Does the plain-def conversion actually prevent the diamond, given the existing instance at VectorBundle/Riemannian.lean:257 fires for ANY ContMDiffRiemannianMetric, including one built from a different metric? What stops two different (n,0) metrics on the same fibers from both registering?
4. Sobolev: the routes name the Phase 3 statements but Astra admits the plan fixes neither the dimension, target exponent, weight convention, nor the Poincare/trace hypotheses. Does this actually answer the Phase 0 false-dichotomy charge, or does it defer every hard choice to Phase 3? Is the W^{1,2} = H^1 bridge stated precisely enough to be a checkable obligation (which norm comparison, on which domain)?
5. Example 2: is H^0 membership via Fourier transform really the minimal test, or does it smuggle in the full tempered-distribution Fourier machinery? Does order zero genuinely need no weak-derivative API?
6. Example 3: does the first-import failure actually show the Hilbert6 construction is not portable, or only that one file does not build unchanged? The file's own koszulConnection and exists_isLeviCivitaFor might port with the upstream API; does Astra overstate or understate the porting cost?

Keep your reply under 700 words. Do not praise the work in general terms; name the strongest flaw first.
```

Neon review reply: NONE OBTAINED. Two attempts, both failed at the egress
proxy before any reply (see call log above). Recorded as GAP-1.

### Prompt sent to Astra (reviewing Neon's architecture), verbatim

```
You are a hostile reviewer, GPT-6.2 Astra. You are the mathematician; the architect (Gemini 4 Neon) authored the architecture below for Phase 1 planning of a Lean pseudo-Riemannian geometry layer. Review Neon's architecture only, not the math content. Attack it. Be specific, name any claim that is wrong, overstated, or unverifiable from the evidence given.

CONTEXT, verified by an independent checker 26 Nov 2026:
- Local baseline: Lean 4.23.0, Mathlib v4.23.0, commit 37df177aaa770670452312393d4e84aaad56e7b6.
- The checker re-ran the four Lean probes in DownstreamExamples.md; all fail with Unknown identifier as quoted.
- The checker re-grepped the whole v4.23.0 tree. Confirmed: volumeForm at Orientation.lean:166; box divergence theorem at DivergenceTheorem.lean:258; laplacian at Laplacian.lean:135, laplacianWithin at :124; continuousLinearEquivOfBilin defined at LaxMilgram.lean:102; eLpNorm_le_eLpNorm_fderiv_one at SobolevInequality.lean:437; DifferentialForm 0 hits; HasWeakDeriv/WeakDeriv/HasDistribDeriv 0 hits; Rellich/CompactEmbedding 0 hits; Ricci 0 hits; no Mathlib/Analysis/PDE directory; no Sobolev file in Analysis/Distribution; no CovariantDerivative directory; no ContinuousAlternatingMap in Geometry/Manifold; geodesic hits only in combinatorics and group theory false positives; no expMap and no Stokes in Geometry/Manifold.
- Two grep claims in Neon's inventory do NOT hold as literally stated: the string "Riemann" returns 336 hits tree-wide (all Riemann-integral / Riemannian-adjective uses, none of them Riemann curvature), so "0 hits for Riemann or Ricci" is false as a literal grep claim, though 0 hits for Riemann curvature is true; and "expMap" returns 192 hits tree-wide (189 in one number-theory file, none in Geometry/Manifold), so "no expMap" unqualified is false, though no geometric exponential map exists.
- Two Neon errors were flagged by the generator as corrected, but the wrong strings still appear in the operative verbatim text of docs/ARCHITECTURE.md: the RiemannianInterop imports line still lists `Mathlib.Geometry.Manifold.Riemannian.Distance` and claims its "exact v4.36.0 leaf paths verified in Step 0", although that file does not exist in v4.36.0 (the directory holds only Basic.lean and PathELength.lean); and the file header still lists `Mathlib.Geometry.Manifold.CovariantDerivative.Basic`, missing the VectorBundle segment, although the correct path appears in the LeviCivita module imports and in the generator note at the end. The dependency graph uses the correct PathELength.lean path.
- Signature dispute, real and unresolved: Phase 0 docs/RFC_PseudoRiemannian.md defines (p,q) as p minus ones and q plus ones, calls Lorentzian (1,3), and calls Riemannian (n,0); under its own rule (n,0) is n minuses, i.e. negative definite, not Riemannian. The same inconsistency is in docs/RFC_Conventions.md (LorentzianMetric is the (1,3) case, Riemannian is (n,0)). Neon and Astra both use (p,q) as (pluses, minuses), Lorentzian (3,1), Riemannian (n,0). The (-,+,+,+) signature itself is undisputed.

NEON'S ARCHITECTURE, verbatim substance (docs/ARCHITECTURE.md):
- Target baseline: move from v4.23.0 to v4.36.0 in Step 0, consuming upstream Mathlib.Geometry.Manifold.CovariantDerivative.Basic (sic), Mathlib.Analysis.Distribution.Sobolev, Mathlib.Analysis.Distribution.TemperedDistribution. Signature (p,q) denotes p positive and q negative eigenvalues; Riemannian (n,0); 4D Lorentzian (-,+,+,+) is (3,1).
- 10 modules: PseudoRiemannian.Metric, RiemannianInterop, Musical, TensorContraction, LeviCivita, Curvature, RicciEinstein, Analysis.Sobolev.LocalDomain, Geometry.Manifold.SobolevSection, Analysis.PDE.GeometricBase. Each lists imports, exports, forbids, and a one-line downstream theorem or computation it enables. Metric forbids importing Bundle.RiemannianBundle or Bundle.ContMDiffRiemannianMetric and forbids registering NormedAddCommGroup or InnerProductSpace instances. RiemannianInterop exports toContMDiffRiemannianMetric (plain def), a reverse toPseudoRiemannianMetric (plain def), and scoped instances in namespace PseudoRiemannian.Riemannian for Bundle.RiemannianBundle, IsContMDiffRiemannianBundle, and IsRiemannianManifold. LeviCivita imports upstream CovariantDerivative.Basic and CovariantDerivative.LeviCivita and exports existence and uniqueness of the torsion-free metric-compatible connection for any nondegenerate signature (p,q), plus Christoffel symbols. Curvature exports riemannEnd with R(X,Y)Z = nabla_X nabla_Y Z - nabla_Y nabla_X Z - nabla_[X,Y] Z, both Bianchi identities. RicciEinstein exports ricciTensor, scalarCurvature, einsteinTensor G = Ric - (1/2) R g, contractedSecondBianchi div G = 0. GeometricBase exports weakEllipticSolvability via Lax-Milgram and waveEnergyBound via Gronwall.
- Dependency graph and 9-step build order, each step ending with `lake build` succeeds plus #check / #print axioms confirmations.
- Open decisions: signature (p,q) ordering disputed, must be locked before any file is written (Option A Phase 0 lock (minuses,pluses) Lorentzian (1,3); Option B (pluses,minuses) Lorentzian (3,1)); connection interface (extend upstream CovariantDerivative.Basic directly vs local typeclass plus bridge); LocalSobolevSpace foundation (restrict upstream TemperedDistribution Sobolev spaces vs define distributional derivatives directly on open U).

NEON'S BASELINE DECISION (docs/BaselineDecision.md):
- Move to Mathlib v4.36.0 (latest release, published 16 Nov 2026). Do not stay on v4.23.0 with vendored PR 36128, do not stop at v4.29.0.
- PR 36128 (Levicivita minimal, created 4 Mar 2026, last updated 19 Sep 2026, head 8968a1246, base master) remains open, merged false, mergeable false. Vendoring onto v4.23.0 requires porting 13 files: 3,901 new Lean lines plus +307/-30 edited lines (4 CovariantDerivative files 3,535 lines; 2 helper files Misc 152, Tensoriality 214; 6 modified files; plan.mde +12). Dependency depth: LeviCivita -> Torsion -> Basic -> Prelim -> 10 modules.
- v4.29.0 fixes: includes upstream covariant derivative API (absent v4.24.0-v4.28.0), eliminates vendoring, matches Hamilton paper-time snapshot. Leaves open: Sobolev.lean absent (404 at v4.29.0); trails Hilbert6 (Lean 4.35.0) and Hamilton current main (Lean v4.35.0-rc3).
- v4.36.0 fixes: includes upstream covariant derivative API (CovariantDerivative structure at Basic.lean:366; public IsLeviCivitaConnection structure with Koszul formula lemma and uniqueness theorem) and Sobolev Bessel layer (Sobolev.lean and TemperedDistribution.lean, including TemperedDistribution.MemSobolev and besselPotential), zero PR 36128 vendoring cost. Leaves open: upgrading across 13 releases, toolchain skew with satellites at Lean 4.35.0, re-auditing absent inventory on v4.36.0.
- Riemann sign trigger (GAP-5b): PR 36128 defines no Riemann curvature at all; its LeviCivita file is Riemannian-only and takes a RiemannianBundle instance. The trigger in RFC_Conventions cannot fire on this PR.
- Open cost not measured: the human effort to upgrade the local tree across 13 releases (build time, breaking changes) is not estimated.

NEON'S MISSING INVENTORY (docs/MissingInventory.md), 15 items, all statuses from the 26 Nov 2026 grep audit over v4.23.0: differential forms absent; exterior derivative absent; volume forms absent on manifolds (flat volumeForm neighbour); manifold integration absent; Stokes absent as a manifold theorem (flat box divergence theorem neighbour); geodesics absent; curvature absent; Laplace-Beltrami absent as such (flat laplacian neighbour); weak derivatives absent; W^{k,p} on domains absent; compact embeddings absent; Lax-Milgram PRESENT (continuousLinearEquivOfBilin); elliptic/parabolic/hyperbolic PDE infrastructure absent (no PDE directory). Newer-Mathlib presence noted only for CovariantDerivative/IsLeviCivitaConnection (v4.29.0, v4.36.0) and Sobolev.lean/TemperedDistribution.lean (v4.36.0). The other absent items were not re-audited on v4.36.0; that re-audit is open work owned by the Phase 1 lead.

ATTACK THESE POINTS, at least:
1. The two wrong paths still sit in the operative text of ARCHITECTURE.md with a false "verified in Step 0" claim attached to one. Is the generator's note at the end a correction, or does the file as delivered still tell a reader to import a nonexistent module? What does that say about the architecture's checkability?
2. Is the (p,q) dispute actually resolved by listing two options, or does the whole module list (Metric exports, LorentzianMetric (n-1,1), SpacetimeMetric (3,1), wave operators (n-1,1)) silently assume Option B while Phase 0 locks Option A? Can any file be written before this is locked, and who locks it?
3. Baseline: is "move to v4.36.0" justified, or does it trade a measured vendoring cost (3,901 lines) for an unmeasured upgrade cost across 13 releases that Neon admits is not estimated? Does the decision actually answer GAP-4b, or does it swap one unmeasured cost for another? Also: v4.36.0 is "latest release" as of 16 Nov 2026; what happens to the plan if a newer release lands before Phase 1 starts?
4. Dependency graph: check for missing edges and contradictions. Does RiemannianInterop's scoped-instance export conflict with Metric's forbidding of RiemannianBundle imports? Does GeometricBase import what it needs for Lax-Milgram (it imports Metric, LeviCivita, TensorContraction, SobolevSection, but no Lax-Milgram module)? Does LocalDomain's forbidding of manifold atlases survive SobolevSection importing it alongside Metric and LeviCivita? Is the build order's step 2 (RiemannianInterop and Musical in parallel) actually parallel, given both import Metric only?
5. Inventory: the "0 hits for Riemann" and "no expMap" wordings are literally false as grep claims. How much does that weaken the inventory's credibility, and are there other items where "absent" really means "absent under one guessed name" (the exact failure mode Neon itself attacked in Phase 0)?
6. Does the architecture answer Neon's own Phase 0 hostile points (presence is not usability; every module must state its downstream theorem)? Or do the build-order steps mostly restate "lake build succeeds" and "#check confirms" without naming the theorem each step proves?

Keep your reply under 700 words. Do not praise the work in general terms; name the strongest flaw first.
```

Astra review reply: NONE OBTAINED. Two attempts, both failed at the egress
proxy before any reply (see call log above). Recorded as GAP-1.

## Check 5: Signature (p, q) ordering inconsistency: REAL, must be locked

Ruling: this is a real inconsistency, not a wording nit, and it spans both
Phase 0 RFCs.

Evidence, read in full:

- docs/RFC_PseudoRiemannian.md, Definitions: "a signature (p, q): a pair of
  naturals with p + q equal to the fibre dimension, witnessed by a basis at
  each point whose Gram matrix is diag(-1, ..., -1, 1, ..., 1) with p minus
  ones and q plus ones." Same file: "A Lorentzian metric is the signature
  (1, 3) case" and "A Riemannian metric is the signature (n, 0) case."
  Under its own ordering rule, (n, 0) means n minus ones and 0 plus ones:
  negative definite, not Riemannian. The three statements cannot all hold.
- docs/RFC_Conventions.md, Naming: "`LorentzianMetric` for the signature
  (1, 3) case. Riemannian is the signature (n, 0) case of the same
  structure." Same inconsistency, same consequence.
- docs/ARCHITECTURE.md line 14 and throughout: (p, q) denotes p positive
  and q negative eigenvalues, Riemannian (n, 0), Lorentzian (3, 1).
  docs/InteropExample.md and docs/DownstreamExamples.md use the same
  (pluses, minuses) ordering. Neon and Astra agree with each other and
  disagree with Phase 0.
- The (-, +, +, +) signature itself is not in dispute anywhere: it matches
  Hilbert6 LorentzianAt diag(-1, 1, 1, 1) and RFC_Conventions.md. Only how
  (p, q) counts it is disputed.

What must be locked before any file is written: (p, q) = (pluses, minuses),
so Riemannian is (n, 0) and 4D Lorentzian is (3, 1). That is the ordering
Neon and Astra both use, it matches Sylvester (pluses, minuses) in algebra
texts, and it makes the architecture's module exports (LorentzianMetric
(n - 1, 1), SpacetimeMetric (3, 1), wave operators (n - 1, 1)) consistent
with the docs that use them. Locking it requires amending
docs/RFC_PseudoRiemannian.md (the p-minus-ones definition, the (1, 3)
Lorentzian case) and docs/RFC_Conventions.md (the (1, 3) LorentzianMetric
line). The lock decision belongs to Richardson with the Phase 1 lead; the
generator cannot lock it alone because it overturns a Phase 0 lock.
Recorded as GAP-7.

Two nits in the same area, for the fix cycle: ARCHITECTURE.md line 23 calls
the Riemann tensor "(1, 3)", which is standard (1,3)-tensor-type notation
but collides visually with the disputed signature notation in the same file;
disambiguate it. And ARCHITECTURE.md Open Decisions Option A correctly notes
that the Phase 0 lock makes Riemannian metrics (0, n), which is the
consequence that proves the inconsistency.

## Check 6: Forbidden content: PASS

Scanned the six generator docs (ARCHITECTURE.md, BaselineDecision.md,
DownstreamExamples.md, InteropExample.md, MissingInventory.md,
SobolevRoutes.md) by grep:

- Em dash character: 0 hits.
- The forbidden domain string: 0 hits.
- `sorry` / `admit`: 0 hits in all six docs, including in prose.
- No Lean code blocks (no ``` fences at all) in any of the six docs; the
  quoted probe lines are `#check` one-liners in prose, not Phase 1 code.
  No new .lean file was created by the generator.
- No Kerr stability claim and no Yang-Mills mass gap claim: 0 hits for
  "Kerr stability" or "mass gap" in all six docs. The plan's own "state
  Kerr stability / state a mass gap" framing is not repeated as a claim.
- No Phase 1 Lean code: the docs state definitions in prose and name
  future Lean files only as a build order.

## Check 7: Generator's corrected Neon errors, actually corrected in the final docs: MIXED

Four errors were flagged in the generator log and the docs' verification
notes. Two are corrected in the operative text; two are only noted at the
end while the wrong strings remain where a reader would use them.

- HasWeakDerivAt as an upstream API (Neon call 3): CORRECTED. Astra's
  version does not repeat it. DownstreamExamples.md states explicitly that
  HasWeakDerivAt was a probe name only and that no weak-derivative API was
  found by grep. SobolevRoutes.md asserts no weak-derivative API name.
- Neon's "a (p, q) metric with p > 0 cannot supply pos and isVonNBounded"
  (Neon call 3): CORRECTED in substance. Astra's version is authoritative:
  with (n, 0) denoting positive signature, p > 0 alone is not an
  obstruction; mixed signature is the obstruction. InteropExample.md
  records the correction, and ARCHITECTURE.md's notes record it. The old
  framing survives only inside the correction note itself, which is the
  right place for it.
- Invented path Mathlib.Geometry.Manifold.Riemannian.Distance: NOT
  CORRECTED in the operative text. ARCHITECTURE.md line 37, in the
  RiemannianInterop imports (verbatim Neon), still lists
  `Mathlib.Geometry.Manifold.Riemannian.Distance` and claims its "exact
  v4.36.0 leaf paths verified in Step 0". That file does not exist in
  v4.36.0 (per the generator's own contents-API check: the directory holds
  only Basic.lean and PathELength.lean), so the "verified in Step 0" claim
  attached to it is false. The dependency graph (line 87) uses the correct
  PathELength.lean path, and the generator note at the end says it is
  corrected, but a reader following the imports line would import a
  nonexistent module. Recorded as GAP-3.
- Missing VectorBundle segment, Mathlib.Geometry.Manifold.CovariantDerivative.Basic:
  NOT CORRECTED in the operative text. ARCHITECTURE.md line 14, the file
  header (verbatim Neon), still lists the wrong path. The correct path
  appears in the LeviCivita module imports (line 52) and the dependency
  graph (lines 93-94) and the generator note. Recorded as GAP-4.

## Check 8: Checker's own findings (not a substitute for the missing reviews)

These are my independent findings, recorded so the fix cycle has them even
though the hostile reviews could not run. They are not presented as either
model's review.

- (a) GeometricBase imports do not cover its exports. The module claims
  weak elliptic solvability "via Lax-Milgram" and a wave energy bound "via
  Gronwall", but its imports list is Metric, LeviCivita, TensorContraction,
  SobolevSection. No Lax-Milgram module (Mathlib/Analysis/InnerProductSpace/
  LaxMilgram) and no Gronwall module (Mathlib/Analysis/ODE/Gronwall) is
  imported anywhere in ARCHITECTURE.md. A build-order step that typechecks
  weakEllipticSolvability cannot run on the listed imports. Recorded as
  GAP-8.
- (b) RiemannianInterop's scoped-instance exports sit in tension with
  Astra's single-source rule. The architecture exports scoped instances in
  namespace PseudoRiemannian.Riemannian for Bundle.RiemannianBundle,
  IsContMDiffRiemannianBundle, and IsRiemannianManifold. But the existing
  Mathlib instance at VectorBundle/Riemannian.lean:257 already registers
  RiemannianBundle from ANY ContMDiffRiemannianMetric. The architecture
  does not state why the scoped instances do not create a second live
  registration path, or when the PseudoRiemannian.Riemannian namespace is
  meant to be opened. This is exactly the point the Astra hostile review
  was meant to adjudicate; it stays open. Recorded as GAP-9.
- (c) DownstreamExamples example 4 has no failing Lean probe, and the doc
  is honest about that. Whether it satisfies the Stage 1 wording ("one
  minimal failing example per alleged blocker, in prose with exact Lean
  statement, file and line where it fails") is a judgement call: its
  failure is at the level of the structure fields, since
  PseudoRiemannianMetric does not exist in Mathlib at all. The Neon
  hostile review was meant to rule on this; it could not run. It stays
  open inside GAP-1, not ruled on here.
- (d) The build order is mostly checkable as stated, with two weak steps.
  Step 2 (RiemannianInterop and Musical in parallel) is genuinely parallel:
  both import Metric only. Steps 1 and 3-9 each name a concrete check
  (#check of a named export, #print axioms). But step 6's
  contractedSecondBianchi and step 9's waveEnergyBound are named as
  `#check` confirmations, which would confirm the names exist, not that
  the theorems are proved; the architecture's own standard (every module
  states the downstream theorem it enables) is met in the module list but
  softens in the build order. Not a gap on its own; noted for the judge.
- (e) The baseline decision trades a measured cost for an unmeasured one.
  Vendoring PR 36128 is measured (3,901 new lines, +307/-30 edited, 13
  files; the numbers could not be re-verified this run, see Check 3), while
  the upgrade across 13 releases is explicitly "not estimated". The decision
  answers GAP-4d (a reason to move is given) and GAP-4b in the vendoring
  half, but the upgrade half of GAP-4b is still unmeasured. The Astra
  hostile review was meant to press this; it stays open inside GAP-1.
- (f) Phase 3 acceptance-test parameters remain unfixed, as Astra records:
  dimension and target exponent for the Sobolev embedding, weight
  convention, s, delta, and local regularity for the weighted test, domain
  and normalization hypotheses for Poincare and trace. This is recorded as
  open by the docs themselves, owner Phase 3 lead. Recorded as GAP-10
  (minor, carried, not a U7 fail item on its own).

## Per-check summary

- Check 1, Lean probes re-run: PASS. 4 of 4 fail exactly as quoted.
- Check 2, Mathlib tree greps: MIXED. All present-item line citations
  exact; all substantive absences confirmed; two literal grep wordings
  wrong (GAP-5, GAP-6).
- Check 3, live sources re-opened: NOT VERIFIED. Egress proxy down for
  every attempt; browser.open failed and was not repeated. All v4.36.0
  and PR 36128 claims rest on the generator's verification alone.
- Check 4, hostile reviews: FAIL. 0 of 2 reviews obtained; 4 attempts,
  all failed at the proxy; both retries used; prompts saved verbatim for
  the fix cycle.
- Check 5, signature (p, q): REAL INCONSISTENCY, ruled. Lock
  (pluses, minuses), Lorentzian (3, 1), Riemannian (n, 0); amend both
  RFCs before any file is written (GAP-7).
- Check 6, forbidden content: PASS. No em dashes, no forbidden domain,
  no sorry, no Phase 1 code, no Kerr or mass-gap claim.
- Check 7, corrected Neon errors: MIXED. 2 of 4 corrected in operative
  text; 2 survive in the imports/header lines (GAP-3, GAP-4).
- Check 8, checker's own findings: two further gaps (GAP-8, GAP-9) and
  three open notes for the judge.

## Gaps, listed by name

- GAP-1, hostile reviews not obtained: neither cross-review exists.
  Neon (google/gemini-4-neon) reviewing Astra's math and Astra
  (openai/gpt-6.2-astra) reviewing Neon's architecture both failed at the
  egress proxy, 2 attempts each, 0 replies. The exact prompts are recorded
  verbatim in Check 4. Owner: checker (U7). Fix: re-run the two saved
  prompts (/tmp/u7probes/prompt-neon-review.md,
  /tmp/u7probes/prompt-astra-review.md) unchanged when egress recovers,
  record both replies verbatim with model id, max_tokens, and outcome, and
  answer each point raised. This is a fix-cycle action, not a new retry
  inside this check; both retries allowed here are used.
- GAP-2, live sources not re-opened: PR 36128 status and files, Mathlib
  v4.36.0 release date, CovariantDerivative landing window, Sobolev.lean
  presence at v4.36.0, master Sobolev.lean line numbers, Hilbert6
  LeviCivita first import at ddbe9da, v4.36.0 Riemannian directory
  contents. Owner: checker (U7). Fix: re-run the GitHub API and contents
  checks when egress recovers and record what verifies and what does not.
- GAP-3, ARCHITECTURE.md line 37 still lists the nonexistent
  Mathlib.Geometry.Manifold.Riemannian.Distance path in the
  RiemannianInterop imports, with a false "exact v4.36.0 leaf paths
  verified in Step 0" claim. Owner: generator (Neon). Fix: replace the
  path with Mathlib.Geometry.Manifold.Riemannian.PathELength in the
  imports line and drop the false verification claim.
- GAP-4, ARCHITECTURE.md line 14 header still lists
  Mathlib.Geometry.Manifold.CovariantDerivative.Basic, missing the
  VectorBundle segment. Owner: generator (Neon). Fix: correct the header
  path to Mathlib.Geometry.Manifold.VectorBundle.CovariantDerivative.Basic.
- GAP-5, MissingInventory.md "absent (0 hits for `Riemann` or `Ricci`)"
  is literally false: the string "Riemann" returns 336 hits tree-wide
  (Riemann-integral and Riemannian-adjective uses); only "Riemann
  curvature" returns 0 hits, and Ricci returns 0 hits. Owner: generator
  (Neon). Fix: reword to "0 hits for Riemann curvature or Ricci".
- GAP-6, MissingInventory.md "no expMap" is literally false unqualified:
  `expMap` returns 192 hits tree-wide, 189 of them a number-field expMap
  (inverse of logMap on realSpace) in
  Mathlib/NumberTheory/NumberField/CanonicalEmbedding/NormLeOne.lean,
  unrelated to geodesics. Owner: generator (Neon). Fix: qualify as "no
  geometric exponential map in Mathlib/Geometry/Manifold (0 hits there)".
- GAP-7, signature (p, q) ordering is a real inconsistency across
  docs/RFC_PseudoRiemannian.md and docs/RFC_Conventions.md versus Neon
  and Astra. Owner: Richardson (review) with the Phase 1 lead. Fix: lock
  (p, q) = (pluses, minuses), Lorentzian (3, 1), Riemannian (n, 0), and
  amend both RFCs before any file is written. Fixable in the fix cycle
  only if Richardson locks the ordering there; otherwise it stays open
  as a judge decision.
- GAP-8, ARCHITECTURE.md GeometricBase claims Lax-Milgram and Gronwall
  use but imports neither the LaxMilgram nor the Gronwall module.
  Owner: generator (Neon). Fix: add
  Mathlib/Analysis/InnerProductSpace/LaxMilgram and
  Mathlib/Analysis/ODE/Gronwall to the GeometricBase imports (and to the
  dependency graph), or state which listed import supplies them.
- GAP-9, RiemannianInterop scoped instances for Bundle.RiemannianBundle,
  IsContMDiffRiemannianBundle, and IsRiemannianManifold are in tension
  with Astra's single-source rule, since the Mathlib instance at
  VectorBundle/Riemannian.lean:257 already fires from any
  ContMDiffRiemannianMetric. Owner: generator (Neon with Astra). Fix:
  state explicitly why the scoped instances do not create a second live
  registration path, or drop them.
- GAP-10, minor, carried: Phase 3 acceptance-test parameters unfixed
  (dimension, target exponent, weight convention, s, delta, local
  regularity, Poincare and trace hypotheses). Owner: Phase 3 lead.
  Fix: leave open and owned, as the docs already record; not a U7 fail
  item on its own.

## Cost

- Model calls: 4 attempts total via or_chat.py, 0 successes:
  google/gemini-4-neon twice (first attempt and the one allowed retry),
  openai/gpt-6.2-astra twice (first attempt and the one allowed retry),
  --max-tokens 8000 each. The tool reports no dollar figure, so no dollar
  spend is claimed here and no figure is invented. Call count only.
- No other model calls. No fix attempts used (0 of 5). No push, post, repo
  edit, deploy, or email. No Phase 1 code written.

## Verdict restated

U7: FAIL. The Lean probes and the tree greps mostly verify, the forbidden
content scan is clean, and the signature inconsistency is ruled with a
concrete lock, but the two hostile reviews the task requires do not exist
because egress failed on all four attempts, the live baseline sources
could not be re-opened for the same reason, and two corrected Neon path
errors still sit in the operative text of docs/ARCHITECTURE.md. Every gap
above is fixable in one fix cycle: correct the paths, wordings, and imports
in the docs, lock the signature ordering with Richardson, and re-run the
two saved review prompts and the live-source checks when egress recovers.
