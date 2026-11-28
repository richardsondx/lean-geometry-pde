# docs/SobolevRoutes.md

Date: 26 Nov 2026. Run: stage2-mathlib-geometry-phase1-planning-01.
Author: GPT-6.2 Astra, model openai/gpt-6.2-astra, as mathematician.
Status: planning only. No Lean code in this file. No proof claimed.
Corrects the Phase 0 false dichotomy: missing TemperedDistribution does not
force Phase 3 to build tempered distributions first.

How to read this file: the routes are verbatim Astra output from astra-log.md
call 2. The generator verification block at the end is not Astra output.

# U4. Sobolev routes (verbatim Astra)

## Weak-derivative route: W^{k,p}(Omega)

- For an open set Omega in R^n and a nonnegative integer k, require u and its weak derivatives through order k to belong to L^p(Omega). A weak derivative is specified by an integration-by-parts identity against smooth test functions compactly supported in Omega. This definition does not require tempered distributions.
- **Available and missing:** v4.23.0 has `MeasureTheory.MemLp`, `Lp`, Holder and Minkowski. `MeasureTheory.eLpNorm_le_eLpNorm_fderiv_one` is an inequality for functions with a derivative, not a definition of W^{k,p}. On either baseline, build the weak-derivative formulation and the domain space.
- **Phase 3 use:** Use this route for the **Poincare inequality** and **trace theorem** on domains. For Poincare, state the domain and normalization hypotheses under which a derivative bound controls the function. For trace, state the domain and regularity hypotheses under which a boundary value is defined and controlled. Phase 3 names both theorems but does not fix these hypotheses.
- **Energy estimate (acceptance test 2):** Use weak first derivatives for the finite-energy formulation. The theorem is an energy estimate for a solution of the **linear wave equation on Minkowski space**. Specify the data and solution regularity in the claimed case. The space expresses integrability of derivatives; the estimate itself still needs the energy-current and divergence argument on the Lorentzian domain, with Gronwall as needed.

## Bessel potential route: H^{s,p}(R^n)

- Measure real-order regularity of a tempered distribution by requiring its Bessel potential of order s to be represented by an L^p function. Use p=2 for H^s. This is a whole-space definition, not a definition of weak derivatives on open subsets.
- **Available and missing:** On v4.36.0, use `TemperedDistribution.besselPotential` and `TemperedDistribution.MemSobolev`. `SchwartzMap.memSobolev` supplies Schwartz examples; `MemSobolev.lineDerivOp` and `MemSobolev.laplacian` lower the order by one and two, respectively. These results do not supply the Phase 3 embedding. On v4.23.0, `SchwartzMap` and `VectorFourier.fourierIntegral` are available, but the tempered-distribution and Bessel Sobolev ingredients must be supplied to take this route.
- **Sobolev embedding (acceptance test 1):** State the theorem for u in H^1(R^n) in the Bessel sense. Fix the dimension and target integrability exponent for each claimed case, then prove the corresponding integrability bound. Fact C does not specify the cases.
- **Weighted membership (acceptance test 3):** The target is membership in H^s_delta for a function with r^{-1} decay at infinity, for use in asymptotic flatness. Build the weighted definition and specify the weight convention, s, delta, local regularity and any derivative decay needed in the claimed case. Unweighted Bessel membership is not this test, and a decay rate at infinity alone does not specify Sobolev regularity.

## Agreement and order

- **Required bridge:** On R^n, prove agreement of weak W^{1,2} with Bessel H^1, including the norm comparison needed to transfer an estimate. Use it when a weak-derivative embedding is invoked for the Bessel acceptance test, or a weak energy bound is stated in H^1 terms. This does not identify a space on an arbitrary open domain with a whole-space Bessel space.
- **v4.36.0:** Take the Bessel route first for the whole-space H^1 statement because its membership predicate and order-lowering results are usable. Build the weak route for domain and energy statements, then prove the bridge.
- **v4.23.0:** Start with weak W^{k,p} using the existing L^p tools. Domain and integer-order work need not wait for tempered distributions. The Bessel definition and the bridge remain obligations for the planned H^s formulation.

## Generator verification (not Astra output)

- Bessel route consumable on v4.36.0: confirmed by reading
  Mathlib/Analysis/Distribution/Sobolev.lean. It defines besselPotential at
  line 72, MemSobolev at line 152, and proves SchwartzMap.memSobolev,
  MemSobolev.lineDerivOp, MemSobolev.laplacian. Sobolev.lean returns 404 at
  v4.29.0 and 200 at v4.36.0. Amended 27 Nov 2026, run
  stage2-mathlib-geometry-planning-docs-01: the line numbers were 73 and 153
  before this amendment; both were off by one in the v4.36.0 tree
  (check-log-phase1-planning-v03.md item 3; verdict-phase1-planning-v02.md,
  GAP-D).
- Weak route is a build on either baseline: confirmed by grep. In v4.23.0,
  HasWeakDeriv, WeakDeriv, and HasDistribDeriv return 0 hits in the whole
  tree. In master Sobolev.lean, DerivNotation.lean, and
  TemperedDistribution.lean, no text matching "weak" appears, and no
  SobolevSpace file exists. No weak-derivative API name is asserted here.
- Phase 3 acceptance tests are quoted from the plan, Phase 3: H^1 Sobolev
  embedding, linear wave energy estimate on Minkowski space, r^{-1} decay in
  the weighted space. Astra notes the plan does not fix the dimension, target
  exponent, or weight convention for these cases. Those are open choices for
  Phase 3, not settled here.
