# U4 independent check log, stage2-mathlib-geometry-phase0

Date: 26 Nov 2026, evening EST. Checker: independent, did not write the artifacts.
Work folder: ~/workspace/handover-mathlib-geometry-2026-11-26/
Spec: ~/workspace/mathlib-geometry-plan-2026-11-26/PLAN.md and stage2-manifest-v01.md, predicate pred-mathlib-geometry-phase0-v01.
Baseline: Lean 4.23.0, Mathlib v4.23.0, local tree ~/workspace/kerr-stability-lean/kerr-mathlib/ (Mathlib commit 37df177aaa770670452312393d4e84aaad56e7b6, tag v4.23.0, verified by `git rev-parse HEAD` and `git describe --tags`).

## Final verdict: FAIL

The Lean audit itself re-verified cleanly (check 1 PASS, check 2 mostly PASS), but three cited facts in the U2/U1 satellite material do not verify against the live sources re-opened, and the hostile reviews converge on method gaps that the artifacts do not answer. Gaps are listed by name at the end. They are narrow and fixable, but as written the deliverables contain incorrect citations, so U4 cannot PASS.

## Check 1: Re-run `lake env lean` on the audit file: PASS

Commands run:
- `cd ~/workspace/kerr-stability-lean/kerr-mathlib && lake env lean ~/workspace/handover-mathlib-geometry-2026-11-26/Audit/MathlibInventory.lean`
- First attempt: exit 127, `lake: command not found`. Cause: `lake` is not on the default PATH in this shell; it lives in ~/.elan/bin. This is an environment issue, not an artifact issue.
- Second attempt, with `export PATH="$HOME/.elan/bin:$PATH"`: exit 0, wall time 16.6s (real 0m16.587s), no errors, no warnings on stderr. Mathlib was NOT rebuilt; the run used the existing .lake build.
- Output: 33 `#check` results printed, one per live line, in file order from ChartedSpace through le_gronwallBound_of_liminf_deriv_right_le. Count confirmed: 33 live `#check` lines, 10 commented-out `#check` lines, 43 directives total. (A raw `grep -c '#check'` returns 46 because the file header mentions `#check` three times in prose.)
- The audit file header claim "33 of 43 #check lines compiled, 10 failed" matches the re-run exactly.
- Note: the file header says probe logs live in /tmp/probes/. That was NOT re-checked: /tmp is a 512M tmpfs at 100% full on 26 Nov 2026, and a write to /tmp failed with "No space left on device". Not part of the required checks; recorded as unverified, minor.

## Check 2a: Spot-check names directly in the Mathlib tree: PASS (33 of 33 line citations exact)

Method: `grep -n` for each defining declaration in ~/workspace/kerr-stability-lean/kerr-mathlib/.lake/packages/mathlib, compared against Audit/inventory.md. Every cited file and line number matched exactly. Full list:

- ChartedSpace: Mathlib/Geometry/Manifold/ChartedSpace.lean:537, `class ChartedSpace`.
- IsManifold: Mathlib/Geometry/Manifold/IsManifold/Basic.lean:773, `class IsManifold`.
- ModelWithCorners: Mathlib/Geometry/Manifold/IsManifold/Basic.lean:161, `structure ModelWithCorners`.
- ContMDiff: Mathlib/Geometry/Manifold/ContMDiff/Defs.lean:188, `def ContMDiff`.
- TangentBundle: Mathlib/Geometry/Manifold/IsManifold/Basic.lean:1023, `abbrev TangentBundle`.
- TangentSpace: Mathlib/Geometry/Manifold/IsManifold/Basic.lean:1001, `def TangentSpace`.
- VectorBundle: Mathlib/Topology/VectorBundle/Basic.lean:349, `class VectorBundle`.
- VectorField.mlieBracket: Mathlib/Geometry/Manifold/VectorField/LieBracket.lean:72, `def mlieBracket`.
- IsMIntegralCurve: Mathlib/Geometry/Manifold/IntegralCurve/Basic.lean:76, `def IsMIntegralCurve`.
- LieGroup: Mathlib/Geometry/Manifold/Algebra/LieGroup.lean:68, `class LieGroup`.
- Bundle.RiemannianBundle: Mathlib/Topology/VectorBundle/Riemannian.lean:420, `class RiemannianBundle`.
- Bundle.ContMDiffRiemannianMetric: Mathlib/Geometry/Manifold/VectorBundle/Riemannian.lean:238, `structure ContMDiffRiemannianMetric`.
- IsContMDiffRiemannianBundle: Mathlib/Geometry/Manifold/VectorBundle/Riemannian.lean:62, `class IsContMDiffRiemannianBundle`.
- IsRiemannianManifold: Mathlib/Geometry/Manifold/Riemannian/Basic.lean:77, `class IsRiemannianManifold`.
- Manifold.riemannianEDist: Mathlib/Geometry/Manifold/Riemannian/PathELength.lean:205, `noncomputable irreducible_def riemannianEDist`.
- MeasureTheory.integral: Mathlib/MeasureTheory/Integral/Bochner/Basic.lean:157, `irreducible_def integral`.
- MeasureTheory.MemLp: Mathlib/MeasureTheory/Function/LpSeminorm/Defs.lean:112, `def MemLp`.
- MeasureTheory.Lp: Mathlib/MeasureTheory/Function/LpSpace/Basic.lean:84, `def Lp`.
- MeasureTheory.eLpNorm_add_le: Mathlib/MeasureTheory/Function/LpSeminorm/TriangleInequality.lean:48, `theorem eLpNorm_add_le`.
- MeasureTheory.MemLp.mul: Mathlib/MeasureTheory/Function/LpSeminorm/CompareExp.lean:319, `theorem MemLp.mul`.
- MeasureTheory.integral_prod: Mathlib/MeasureTheory/Integral/Prod.lean:460, `theorem integral_prod`.
- MeasureTheory.lintegral_prod: Mathlib/MeasureTheory/Measure/Prod.lean:880, `theorem lintegral_prod`.
- VectorFourier.fourierIntegral: Mathlib/Analysis/Fourier/FourierTransform.lean:77, `def fourierIntegral`.
- SchwartzMap: Mathlib/Analysis/Distribution/SchwartzSpace.lean:76, `structure SchwartzMap`.
- MeasureTheory.eLpNorm_le_eLpNorm_fderiv_one: Mathlib/Analysis/FunctionalSpaces/SobolevInequality.lean:437, `theorem eLpNorm_le_eLpNorm_fderiv_one`.
- NormedSpace: Mathlib/Analysis/Normed/Module/Basic.lean:40, `class NormedSpace`.
- CompleteSpace: Mathlib/Topology/UniformSpace/Cauchy.lean:361, `class CompleteSpace`.
- InnerProductSpace: Mathlib/Analysis/InnerProductSpace/Defs.lean:102, `class InnerProductSpace`.
- NormedAddCommGroup: Mathlib/Analysis/Normed/Group/Basic.lean:209, `class NormedAddCommGroup`.
- IsPicardLindelof: Mathlib/Analysis/ODE/PicardLindelof.lean:79, `structure IsPicardLindelof`.
- IsPicardLindelof.exists_eq_forall_mem_Icc_hasDerivWithinAt: Mathlib/Analysis/ODE/PicardLindelof.lean:579, `theorem exists_eq_forall_mem_Icc_hasDerivWithinAt`.
- gronwallBound: Mathlib/Analysis/ODE/Gronwall.lean:39, `noncomputable def gronwallBound`.
- le_gronwallBound_of_liminf_deriv_right_le: Mathlib/Analysis/ODE/Gronwall.lean:97, `theorem le_gronwallBound_of_liminf_deriv_right_le`.

Absent names, zero hits anywhere in the v4.23.0 Mathlib tree (grep over all .lean files, whole tree):
- SmoothManifoldWithCorners: 0 files. Confirmed absent.
- CovariantDerivative: 0 files. Confirmed absent.
- IsLeviCivitaConnection: 0 files. Confirmed absent.
- LeviCivitaConnection: 0 files. Confirmed absent.
- ChristoffelSymbol: 0 files. Confirmed absent.
- SmoothRiemannianMetric: 0 files. Confirmed absent from Mathlib core.
- TemperedDistribution: 0 files. Confirmed absent.
- BesselPotentialSpace: 0 files. Confirmed absent.
- BesselPotential (any form): 0 files. Confirmed absent.
- MemSobolev: 0 files. Confirmed absent.
- No file Mathlib/Analysis/Distribution/Sobolev in the tree (directory listing shows no Sobolev entry). Confirmed absent.
- No directory Mathlib/Geometry/Manifold/VectorBundle/CovariantDerivative in the tree. Confirmed absent.
- AnalyticManifold: the file Mathlib/Geometry/Manifold/AnalyticManifold.lean is 11 lines and contains `deprecated_module "Analytic manifolds are deprecated, use IsManifold I ω M" (since := "2025-04-13")`, importing Mathlib.Deprecated.AnalyticManifold. The inventory quote is verbatim. Confirmed as a deprecated shim, not a live class.
- BanachSpace: 0 class/structure definitions in the tree, supporting the inventory note that Mathlib has no BanachSpace class (completeness is CompleteSpace plus NormedSpace).

## Check 2b: Re-open cited source URLs: MIXED (6 of 7 reached and supportive, 1 failed to open, 2 citation errors found in Hilbert6/Hamilton material)

URLs re-opened, all on 26 Nov 2026 evening EST:

1. PR 36128, https://github.com/leanprover-community/mathlib4/pull/36128 : REACHABLE. Page text (crawled 29 min before the read) shows the PR title "Levicivita minimal" by grunweg and a declarations diff adding CovariantDerivative, IsLeviCivitaConnection, LeviCivitaConnection, ChristoffelSymbol, plus new files Mathlib/Geometry/Manifold/VectorBundle/CovariantDerivative/Prelim, Basic, Torsion, LeviCivita. Supports the claim that the PR adds exactly the four missing names. Status via GitHub API (curl, same evening): state open, merged false, merged_at null, created_at 2026-03-04T12:28:17Z, title "Levicivita minimal". Re-verdict: PR 36128 is NOT merged in v4.23.0. This matches the artifacts. Note: the PR page text itself does not show the open/merged state in the excerpt read; the state comes from the API call, which is the authoritative source.

2. arXiv 2608.21502, https://arxiv.org/abs/2608.21502 : REACHABLE. Title "A Lean Formalization of Hamilton's Three-Manifold Theorem", authors Bennett Chow, Yuan Liao, Ziyang Qin, submitted 21 Aug 2026. Abstract confirms Riemannian tensor calculus, the Levi-Civita connection, Ricci-flow evolution equations, scalar and tensor maximum principles. Supports the paper citation. The identifier SmoothRiemannianMetric was confirmed separately in the full HTML text (https://arxiv.org/html/2608.21502, fetched by curl): 22 occurrences. Supports the satellite claim for the identifier.

3. Physicslib4 Spacetime docs, https://physicslib.github.io/physicslib4/docs/Physicslib4/Spacetime/Basic.html : REACHABLE (crawled 23 Nov 2026). Supports: LorentzianAt as a basis with Gram matrix diag(-1, 1, 1, 1); Spacetime as a real, four-dimensional, connected, smooth, Hausdorff manifold with a globally defined smooth, non-degenerate, symmetric, Lorentzian (0,2) tensor field; signature (-, +, +, +) with timelike when g(v,v) < 0; "Mathlib provides Riemannian metrics but no Lorentzian or pseudo-Riemannian metric type"; Spacetime.toPseudoRiemannianMetric giving access to the general pseudo-Riemannian API (musical isomorphisms, Levi-Civita connection); no time orientation carried by the structure; the ContMDiffRiemannianMetric pos/isVonNBounded reason (the set {v | g(v,v) < 1} contains the whole light cone). Supports the assessment's content claims.

4. Mathlib Sobolev docs, https://leanprover-community.github.io/mathlib4_docs/Mathlib/Analysis/Distribution/Sobolev.html : REACHABLE (crawled under 1 min before the read). The page DOES describe TemperedDistribution.MemSobolev and BesselPotentialSpace as Bessel potential spaces. This is the current docs site, i.e. a newer Mathlib than v4.23.0. It therefore supports the inventory's own note that "that docs URL describes a newer Mathlib, not v4.23.0", and it does not rescue the plan's claim for v4.23.0. The plan's claim stays wrong for v4.23.0, as the tree check shows.

5. arXiv 2510.24060, https://arxiv.org/html/2510.24060 : REACHABLE. Title "Formalizing Schwartz functions and tempered distributions", Moritz Doll. Abstract confirms tempered distributions formalized in Lean, Fourier transform extended to L2, Sobolev spaces defined via the Fourier transform on tempered distributions, and that the code lives on a fork branch (github.com/mcdoll/mathlib4/tree/formal_schwartz_v2), not merged Mathlib. Supports the RFC_Sobolev correction that the paper describes work that has not landed in v4.23.0.

6. Hilbert6 source files via raw.githubusercontent.com, fetched by curl 26 Nov 2026 evening : REACHABLE. Hilbert6/Spacetime/Basic.lean (177 lines), Hilbert6/Geometry/PseudoRiemannian/Basic.lean (167 lines), Hilbert6/Geometry/PseudoRiemannian/LeviCivita.lean (404 lines). Line counts match the assessment exactly. Content verified: namespace Hilbert6 (not Physicslib4); lorentzSignature def; LorentzianAt def; Spacetime structure with fields val, symm, nondegenerate, lorentzian, contMDiff, IsManifold model infinity Carrier, model.Boundaryless, tangent_findim; PseudoRiemannianMetric structure with fields val, symm, nondegenerate, contMDiff; bijective_val (line 81), flatEquiv (line 97), contMDiff_flatEquiv_symm (line 112); LeviCivita.lean first import is `Mathlib.Geometry.Manifold.VectorBundle.CovariantDerivative.Torsion` (line 6); IsMetricCompatibleWith (line 62), IsLeviCivitaFor structure (line 83), koszul (line 100), uniqueness (line 133), koszulConnection (line 307), exists_isLeviCivitaFor (line 371), leviCivita (line 391), isLeviCivitaFor_leviCivita (line 396); Christoffel symbols appear only in a doc comment, no ChristoffelSymbol definition of its own. Lean toolchain file says leanprover/lean4:v4.35.0, and lake-manifest.json pins a Mathlib revision (56a005855ea1). Supports the assessment's content and port-split claims, BUT the cited line numbers are wrong (see GAP-1 and GAP-2 below). The GitHub API confirms the repo hilbert6/hilbert6 exists, default branch main.

7. Physicslib4 PseudoRiemannian Basic docs page, https://physicslib.github.io/physicslib4/docs/Physicslib4/Geometry/PseudoRiemannian/Basic.html : NOT REACHED. browser.open failed with "browser-service exited with code 1". Per instruction this request was not retried, including through another endpoint. The claims that page would support were instead verified against the raw source files in item 6 above. Recorded as not re-opened.

Additional URL checks by curl/GitHub API:
- Hamilton repo https://github.com/qinz1yang/differential-geometry : exists, default branch main. Commit 8bd406e35 exists, message "Set package version to 0.1.0". BUT the releases list is v0.1.5, v0.1.4, v0.1.3, v0.1.2, v0.1.1, arxiv-v1-preview; there is NO release tagged 0.1.0 (a tag lookup for 0.1.0 returns 404). Current lean-toolchain is leanprover/lean4:v4.35.0-rc3, not Lean 4.29.0. See GAP-3.
- GitHub code search for toPseudoRiemannianMetric in hilbert6/hilbert6: API returns 401 "Requires authentication", so code search could not be used. The definition was instead searched by fetching candidate files directly.

## Check 2c: Hilbert6 line-number discrepancies (the FAILING detail)

The assessment cites line numbers that do not match current hilbert6/main as fetched 26 Nov 2026 evening. The items exist, but the citations are wrong:

- Spacetime structure: cited "lines 125 to 177". Actual: `structure Spacetime where` at line 119. File is 177 lines, so the end matches but the start is off by 6.
- lorentzSignature: cited "lines 82 to 84". Actual: `def lorentzSignature` at line 76.
- LorentzianAt: cited "lines 90 to 95". Actual: `def LorentzianAt` at line 88, body through about line 91.
- Spacetime.toPseudoRiemannianMetric: cited "lines 156 to 167". Actual: lines 156 to 167 in the current file are the `lorentzian` field and its doc comment. No definition of toPseudoRiemannianMetric exists anywhere in Spacetime/Basic.lean; the name appears only in doc comments (lines 48 and 115). It is also absent as a definition from PseudoRiemannian/Basic.lean (doc mentions only), PseudoRiemannian/Flat.lean (0 mentions), Spacetime/LorentzianSpacetime.lean (0 mentions), and Spacetime/Minkowski.lean (0 mentions). The old docs page (item 3 above) asserts the function exists, so existence is supported by the docs text, but its current definition location is unconfirmed and the cited location is wrong.
- PseudoRiemannianMetric structure: cited "structure at lines 83 to 99". Actual: `structure PseudoRiemannianMetric where` at line 59; its fields run to about line 72.
- Possibility not excluded: the repo main moved between the generator's fetch earlier on 26 Nov 2026 and this evening re-fetch. The assessment pins no commit hash, so the citations cannot be checked against a pinned revision. Either way, as re-opened, they do not verify.

## Check 3: Hostile reviews: DONE, both models returned full text on first attempt

Tool: ~/workspace/custom-connectors/custom.openrouter-chat/bin/or_chat.py, prompt via stdin only, never argv. Both calls used --max-tokens 8000. Neither call failed, so no 4000-token retry was needed. Cost: or_chat.py prints the assistant text only and reports no cost figure, so dollar spend for these two calls is not verifiable from the tool output. Two calls were made total, no retries, no other model calls. (Note: an earlier standing note said a Gemini 4 Neon call at a 12000-token cap returned no text; that failure did NOT reproduce here, the 8000-token Neon call returned full text.)

Prompt sent to both models, verbatim (identical for both):

```
You are a hostile reviewer. Read this Phase 0 audit summary and say why it is trivial, already known, or flawed. Name any claim you cannot verify from the evidence given.

PHASE 0 AUDIT SUMMARY (Mathlib geometry and PDE plan, baseline Lean 4.23.0, Mathlib v4.23.0, local tree commit 37df177aaa770670452312393d4e84aaad56e7b6):

Audit file Audit/MathlibInventory.lean has 43 #check lines. Claimed result: 33 confirmed present, 9 confirmed absent, 1 confirmed in a named satellite repo. Failing lines are commented out in the file with the exact Lean error. Each item in Audit/inventory.md carries a file path and line number.

Present (33): ChartedSpace, IsManifold, ModelWithCorners, ContMDiff, TangentBundle, TangentSpace, VectorBundle, VectorField.mlieBracket, IsMIntegralCurve, LieGroup; Bundle.RiemannianBundle, Bundle.ContMDiffRiemannianMetric, IsContMDiffRiemannianBundle, IsRiemannianManifold, Manifold.riemannianEDist; MeasureTheory.integral, MeasureTheory.MemLp, MeasureTheory.Lp, MeasureTheory.eLpNorm_add_le, MeasureTheory.MemLp.mul, MeasureTheory.integral_prod, MeasureTheory.lintegral_prod; VectorFourier.fourierIntegral, SchwartzMap, MeasureTheory.eLpNorm_le_eLpNorm_fderiv_one (a Sobolev inequality, not a space); NormedSpace, CompleteSpace, InnerProductSpace, NormedAddCommGroup; IsPicardLindelof, IsPicardLindelof.exists_eq_forall_mem_Icc_hasDerivWithinAt, gronwallBound, le_gronwallBound_of_liminf_deriv_right_le.

Absent (9): SmoothManifoldWithCorners (class is IsManifold instead); AnalyticManifold (deprecated shim); CovariantDerivative, IsLeviCivitaConnection, LeviCivitaConnection, ChristoffelSymbol; TemperedDistribution, TemperedDistribution.MemSobolev, BesselPotentialSpace.

Satellite (1): SmoothRiemannianMetric, in the Hamilton three-manifold project, arXiv 2608.21502, repo https://github.com/qinz1yang/differential-geometry, release 0.1.0, commit 8bd406e35, Lean 4.29.0, Mathlib v4.29.0.

TWO PLAN CORRECTIONS:
1. PR 36128 Levi-Civita NOT merged in v4.23.0. Evidence claimed: none of its four names exist anywhere in the v4.23.0 tree (ripgrep returns zero hits); GitHub API 26 Nov 2026: state open, merged false, merged_at null, created 4 Mar 2026. PR: https://github.com/leanprover-community/mathlib4/pull/36128. Consequence claimed: Phase 1 Levi-Civita work is blocked on the PR merging, being vendored, or targeting a newer Mathlib.
2. Sobolev Bessel potential spaces absent in v4.23.0; the plan was wrong. Evidence claimed: Mathlib/Analysis/Distribution/Sobolev does not exist in the v4.23.0 tree; zero hits for BesselPotential or TemperedDistribution anywhere in the tree. The arXiv paper cited (2510.24060) describes work that has not landed in v4.23.0. Consequence claimed: Phase 3 must first land the tempered distribution layer or target a newer Mathlib.

Also claimed: Physicslib4 (repo renamed to hilbert6/hilbert6, namespace Hilbert6) has a Spacetime structure with LorentzianAt diag(-1,1,1,1), signature (-,+,+,+), a general PseudoRiemannianMetric with musical isomorphisms, and a Levi-Civita layer that does NOT port to v4.23.0 because its first import is Mathlib.Geometry.Manifold.VectorBundle.CovariantDerivative.Torsion, which does not exist in v4.23.0. Generalisation decision: generalise to one PseudoRiemannianMetric with signature (p,q), Riemannian as the (n,0) case, no parallel class.

Be specific. Attack the method, the completeness, and any overclaim. Keep your reply under 600 words.
```

Note on verbatim reviews below: the review texts are reproduced exactly as returned, including any punctuation the model produced. That punctuation is part of the verbatim record, not part of the audited artifacts.

### Hostile review (a): Gemini 4 Neon, model id google/gemini-4-neon, --max-tokens 8000, first attempt, exit 0

```
This "Phase 0 audit" is a glorified grep session dressed up as due diligence. It is trivial, methodologically weak, strategically incoherent, and makes major architectural decisions unsupported by its own evidence.

**Trivial and Self-Inflicted**
Padding a 43-item checklist with Mathlib 101 basics (`NormedSpace`, `CompleteSpace`, `InnerProductSpace`, `MeasureTheory.integral`, `ChartedSpace`) inflates "33 confirmed present" with facts every Lean user already knows. Worse, both headline "plan corrections" expose a self-inflicted baseline error: you pin the project to Mathlib v4.23.0 while citing a satellite repo on v4.29.0 and a November 2026 GitHub query. Discovering that a March 2026 PR (`#36128`) and an October 2025 paper (`2510.24060`) aren't in an obsolete v4.23.0 snapshot is trivial—why are you targeting a stale release at all?

**Flawed Methodology**
- **`#check` proves existence, not usability.** Confirming a name typechecks tells you nothing about definitions, universe polymorphism, lemma coverage, or typeclass diamonds. Knowing `IsRiemannianManifold` or `VectorField.mlieBracket` exists does not mean you can compute curvature or integrate on manifolds.
- **Unchecked negatives.** Commenting out failing lines reduces negative claims to unverified prose; use `fail_if_success` / `#guard_msgs` so absence is actually machine-checked.
- **Brittle string search.** Zero ripgrep hits for guessed names (`CovariantDerivative`, `BesselPotential`) disproves only those exact strings, not equivalent APIs under different names (as `SmoothManifoldWithCorners` vs. `IsManifold` already illustrates).

**Glaring Omissions**
For a geometry and PDE plan, the inventory ignores almost every load-bearing component: differential forms, exterior derivatives, volume forms, manifold integration, Stokes' theorem, geodesics, curvature, Laplace–Beltrami operators, weak derivatives, $W^{k,p}$ spaces on domains, compact embeddings, Lax–Milgram, and elliptic/parabolic/hyperbolic PDE infrastructure.

**Overclaims and Bad Architecture**
1. **False Sobolev dichotomy:** Missing `TemperedDistribution` does *not* force Phase 3 to build tempered distributions first; standard $W^{k,p}$ spaces can be defined via weak derivatives or completion without Bessel potential spaces.
2. **Lazy portability dismissal:** Claiming Hilbert6's Levi-Civita layer "does NOT port to v4.23.0" because its *first import* is missing means you stopped reading at line 1 without assessing dependency depth or porting cost.
3. **Self-sabotaging generalisation:** Unifying everything under one `PseudoRiemannianMetric` of signature $(p,q)$ with "no parallel class" contradicts your own audit. Mathlib's `Bundle.RiemannianBundle`, `IsRiemannianManifold`, and `Manifold.riemannianEDist` rely on positive-definiteness that $(p,q)$ lacks. Rejecting a parallel class forfeits Mathlib interoperability with zero evidence that $(p,q)$ avoids instance conflicts.

**Unverifiable Claims**
Because no code, build logs, ripgrep outputs, or API payloads are provided, none of the following can be verified from this summary:
- Existence, contents, line numbers, and commented Lean errors in `Audit/MathlibInventory.lean`, `Audit/inventory.md`, and local commit `37df177...`.
- Presence or absence of all 43 declarations in Mathlib v4.23.0 (notably `IsRiemannianManifold`, `Manifold.riemannianEDist`, `eLpNorm_le_eLpNorm_fderiv_one`, and `AnalyticManifold`'s deprecation).
- GitHub PR `#36128` status, creation date, and the `26 Nov 2026` API timestamp.
- Satellite repo `qinz1yang/differential-geometry` (arXiv `2608.21502`, release `0.1.0`, commit `8bd406e35`, Lean/Mathlib `v4.29.0`, `SmoothRiemannianMetric`).
- Contents and landing status of arXiv `2510.24060`.
- `Physicslib4`'s rename to `hilbert6/hilbert6`, its `Spacetime`/`PseudoRiemannianMetric` structures and musical isomorphisms, and its exact first import (`Mathlib.Geometry.Manifold.VectorBundle.CovariantDerivative.Torsion`).
```

Checker response to review (a), recorded not smoothed over: the "unverifiable from this summary" list is answered by this check log itself for most items, since I re-ran Lean and re-grepped the tree and re-opened the URLs. The review is wrong to imply the audit is only prose: the live Lean re-run (exit 0, 33 outputs) and the tree greps are the evidence. But three of its substantive points stand and are NOT answered by the artifacts: (1) the stale baseline point is real, the plan pins v4.23.0 while the satellites it cites are on 4.29.0 and 4.35.0, and no reason for staying on v4.23.0 is given in the artifacts; (2) the Sobolev dichotomy point is real, the RFC does not show that a weak-derivative W^{k,p} route is unavailable, it only asserts the Bessel route needs tempered distributions first; (3) the generalisation interoperability point is real, the RFC does not exhibit how the (n,0) case interoperates with Bundle.ContMDiffRiemannianMetric without duplicate instances or lost lemmas. The "lazy portability" charge is partly unfair: the assessment does identify the dependency (CovariantDerivative/Torsion) and names the three options (merge, vendor, newer Mathlib), but it does not assess dependency depth or porting cost beyond the first import, so the charge stands in part. The "omissions" list is accurate as a description of what the inventory does not cover, though the inventory never claimed to cover PDE infrastructure beyond the named items; whether that coverage gap matters for Phase 0 is a judge question, not a factual fail.

### Hostile review (b): GPT-6.2 Astra, model id openai/gpt-6.2-astra, --max-tokens 8000, first attempt, exit 0

```
**Verdict: useful as a version-pinned name inventory; inadequate as a dependency audit.** The arithmetic checks out: the lists contain 33, 9 and 1 entries. Checking that `NormedSpace` and `MeasureTheory.integral` resolve is routine. The potentially valuable result is identifying which step of the geometry or PDE plan fails on v4.23.0. No such step is exhibited.

- **Presence is a weak test.** A successful `#check` establishes name resolution under particular imports. It does not establish that a theorem has the hypotheses, regularity, domain or conclusion the plan needs. Elaborating one intended application of the Sobolev inequality would say more about PDE readiness than counting it alongside `MemLp`. The 43 probes have no stated coverage criterion.
- **Absence is overclaimed.** Commented-out failures are records, not rerunnable tests. An unresolved identifier may reflect imports or namespace; zero literal hits in a tree rule out those spellings, not equivalent constructions. The taxonomy conflates replacement (`SmoothManifoldWithCorners` versus `IsManifold`), deprecation and missing mathematics. “`AnalyticManifold` absent (deprecated shim)” needs a versioned explanation: is the shim present, removed, or merely not imported?
- **Levi-Civita:** A verified open/unmerged API record would establish that PR 36128 had not merged as of the observation date. It would not establish that equivalent code was never introduced independently. Conversely, four missing names do not establish PR history. Neither observation proves Phase 1 is blocked. State the first required connection theorem or construction and show why the baseline API cannot supply it. A “newer Mathlib” is not a remedy without an identified compatible revision.
- **Sobolev:** The missing directory and two search strings, even if confirmed, discredit the proposed import and names. They do not show that Phase 3 must first formalize tempered distributions. That conclusion needs a specific Phase 3 statement that requires the Bessel-potential formulation rather than, for example, an integer-order weak-derivative formulation. The latter is not an automatic substitute either.
- **External libraries and design:** A declaration on 4.29 is a reference, not a 4.23 dependency. A missing `Torsion` import shows that the Hilbert6 file cannot build *unchanged*, not that its mathematics cannot be ported. A spacetime signature does not justify a single signature-indexed metric API. Exhibit how the positive-definite case interoperates with `Bundle.ContMDiffRiemannianMetric` without duplicate instances or lost lemmas.

**Unverified from the supplied evidence:** the checkout/tag/toolchain correspondence; audit files, imports, line references, diagnostics and all declaration outcomes; search scope, zero hits and missing paths; PR dates and API fields; both papers’ identities, contents and relationship to the code; satellite release, commit, versions and declaration; and the Physicslib4 rename, namespace, metric definitions, musical maps, Levi-Civita layer and import chain. The summary reports these facts but does not exhibit the artifacts. Provide a pinned replay with executable negative probes, search commands and outputs, and one minimal downstream example per alleged blocker.
```

Checker response to review (b), recorded not smoothed over: this review is the more accurate of the two. Its "unverified from the supplied evidence" list is again largely answered by this log (I re-ran Lean, re-grepped, re-opened URLs, and confirmed the checkout/tag correspondence: commit 37df177aaa770670452312393d4e84aaad56e7b6, tag v4.23.0). But its core criticisms stand: (1) no alleged blocker is exhibited as a minimal downstream example, so "Phase 1 is blocked" is an inference, not a demonstrated failure; (2) the Sobolev conclusion needs a specific Phase 3 statement that requires Bessel potential, which the RFC does not give; (3) "a newer Mathlib" is named as a remedy without an identified compatible revision, and the satellites cited run 4.29.0 and 4.35.0, which are not the same revision; (4) the AnalyticManifold point is fair in form but the inventory does answer it in substance (11-line shim, deprecated_module text quoted verbatim, import of Deprecated/AnalyticManifold). Both reviewers converge on: presence is a weak test, absence is overclaimed as stated, the Sobolev inference is unsupported, and the generalisation interoperability is unproven. I record that convergence as a real disagreement with the artifacts, not a minor wording issue.

## Check 4: Forbidden content: PASS, with one wording nit

Scanned the whole work folder (Audit, docs, map, stage1-package, stage2-manifest) by grep:
- Forbidden domain string (the site named in the task): 0 hits in any file.
- Em dash character: 0 hits in any artifact file (Audit, docs, map).
- `sorry` / `admit`: 0 hits in Audit, docs, map, outside the phrase "no sorry" (which appears in the plan context, not as a Lean sorry). The audit file contains no sorry.
- Lean code in docs/map: 0. The only .lean file in the work folder is Audit/MathlibInventory.lean. A grep for Lean keywords at line starts in docs and map returned 3 hits, all prose fragments, not code: "theorem for the boundary" (RFC_Sobolev.md:44), "instance fields" (Physicslib4-assessment.md:34), "structure as a pointwise basis condition" (Physicslib4-assessment.md:112). The RFCs state in prose that definitions are stated in prose only and Phase 1/3 code waits on approval.
- Proof claims: no Kerr stability claim, no Yang-Mills mass gap claim, no "proved in Lean" claim for any new result. The word "proof" appears only in future-work wording ("Prove: ..." as Phase 3 work items in RFC_Sobolev.md), in descriptions of the Hilbert6 proofs (whose uniqueness and existence theorems I verified exist in their repo), and in the phrase "a second, independent proof that the pattern works" for the Hamilton project in the assessment (line 159), which describes the satellite project, not a result of this run. That last phrase is loose wording, recorded as a nit, not a proof claim.
- Signature (-, +, +, +) and Riemann/Ricci conventions are locked in docs/RFC_Conventions.md, consistent with the Hilbert6 LorentzianAt diag(-1, 1, 1, 1) confirmed above. One open point, not a fail: the RFC says the round sphere has positive Ricci curvature under the locked sign, and that if PR 36128 defines the opposite Riemann sign when it lands, Phase 1 must follow Mathlib. The PR's Riemann sign is not stated anywhere in the artifacts or in the PR page text I read, so the trigger condition is untestable from the evidence given. The RFC records the trigger, which is the right handling, but no one has checked the PR's sign.

## Per-check summary

- Check 1, Lean re-run: PASS. Exit 0, 16.6s, 33 of 33 live #check lines printed, no errors. First attempt exit 127 was a PATH issue in this shell (lake in ~/.elan/bin), not an artifact defect.
- Check 2a, Mathlib tree spot-checks: PASS. All 33 present-item file and line citations exact; all 9 absent names plus BesselPotential, MemSobolev, and the Sobolev file and CovariantDerivative directory confirmed absent by zero-hit greps.
- Check 2b, cited URLs re-opened: MIXED. PR 36128 re-verdict: NOT merged (API state open, merged false, merged_at null, created 2026-03-04). Sobolev absence re-verified. Spacetime docs, both arXiv papers, and Hilbert6 source files support the content claims. Two citation errors found (GAP-1, GAP-2, GAP-3 below). One URL (PseudoRiemannian Basic docs page) failed to open in the browser and was not retried; equivalent claims were verified from raw source instead.
- Check 3, hostile reviews: DONE. Gemini 4 Neon and GPT-6.2 Astra both returned full text on first attempt at 8000 max tokens. Both recorded verbatim above with model id and prompt. Both converge on method gaps; neither falsifies a specific inventory fact, but both challenge inferences the artifacts treat as settled.
- Check 4, forbidden content: PASS. No forbidden domain mention, no em dashes in artifacts, no Phase 1 code, no proof claim.

## Gaps, listed by name

- GAP-1, Hilbert6 line citations wrong in map/Physicslib4-assessment.md: Spacetime structure cited lines 125 to 177, actual line 119; lorentzSignature cited lines 82 to 84, actual line 76; LorentzianAt cited lines 90 to 95, actual line 88; PseudoRiemannianMetric structure cited lines 83 to 99, actual line 59. Fix: re-fetch current main (or pin a commit hash) and correct the line numbers.
- GAP-2, Spacetime.toPseudoRiemannianMetric location unconfirmed: cited as lines 156 to 167 of Spacetime/Basic.lean, but those lines are the lorentzian field in current main, and the definition was not found in Spacetime/Basic.lean, PseudoRiemannian/Basic.lean, PseudoRiemannian/Flat.lean, Spacetime/LorentzianSpacetime.lean, or Spacetime/Minkowski.lean. The old docs page asserts the function exists, but its current definition location is unknown. Fix: locate the definition in the current tree and cite the correct file and lines, or drop the line citation.
- GAP-3, Hamilton "release 0.1.0" does not exist: the GitHub releases list for qinz1yang/differential-geometry is v0.1.5, v0.1.4, v0.1.3, v0.1.2, v0.1.1, arxiv-v1-preview; a 0.1.0 release lookup returns 404. Commit 8bd406e35 exists with message "Set package version to 0.1.0", so the version string is real but "release 0.1.0" is not. Also the pinned Lean 4.29.0 / Mathlib v4.29.0 describes the paper-time snapshot, while current main uses Lean v4.35.0-rc3. Fix: cite the commit and the paper-time pins as a snapshot, not as a current release.
- GAP-4, hostile-review convergence, open challenge for the judge (not a failed factual check): both reviewers say #check presence is a weak test, absence is stated more strongly than the evidence supports (commented-out lines are not rerunnable negative probes), the "Phase 1 is blocked" and "Phase 3 must build tempered distributions first" conclusions are inferences without a demonstrated failing downstream example, "a newer Mathlib" is named without an identified compatible revision, and the PseudoRiemannianMetric generalisation does not exhibit interoperability with the existing Riemannian API. Also the baseline staleness point: v4.23.0 is pinned while the cited satellites run 4.29.0 and 4.35.0, with no reason given for staying on v4.23.0. These need either an answer in the artifacts or an explicit acceptance by the judge; they are not fixed by correcting line numbers.
- GAP-5, minor, unverified: the /tmp/probes/ probe logs cited in the audit file header were not re-checked because /tmp was 100% full at check time. Also the PR 36128 Riemann sign (the RFC_Conventions trigger) is untested: no source in the evidence states the PR's sign convention.

## Cost

Two model calls total, both first-attempt successes, max-tokens 8000 each: google/gemini-4-neon and openai/gpt-6.2-astra via or_chat.py. The tool prints assistant text only and reports no cost figure, so dollar spend is not verifiable from the tool output and no figure is claimed here. No retries, no other model calls. Run cap was $4 with $0.60 held back and $0 generator spend; nothing in the evidence suggests the cap was approached, but that is an inference from call count, not a measured total.

## Verdict restated

U4: FAIL. The Lean audit core is sound and every Mathlib-tree citation verified exactly, but the Hilbert6 line citations and the Hamilton release citation in the U2/U1 material do not verify as written, the toPseudoRiemannianMetric definition location is unconfirmed, and the hostile reviews converge on inference gaps the artifacts do not answer. Fix GAP-1, GAP-2, and GAP-3 by correcting the citations against a pinned source revision, and have the judge rule on GAP-4, then re-check.
