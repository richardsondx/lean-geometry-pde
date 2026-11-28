# Sobolev acceptance parameters, v01

- Date: 28 Nov 2026.
- Run: stage2-mathlib-geometry-phase3-sobolev-slice-01.
- Baseline: Mathlib v4.36.0, commit fc4f59e577feb1a4956671bc04ac18aaaf8cd842.
- Status: parameters fixed in writing. No proof is claimed here.
- Scope: this run delivers the first verified slice only, not Phase 3.
- Math author: GPT-6.2 Astra, model openai/gpt-6.2-astra, via or_chat.py.
- Source for the choices: Astra reply recorded in generator-log-phase3-sobolev-slice.md.

## GAP-10 items, fixed

- Dimension: R3 for the embedding test and the weighted test.
- Dimension: 1 plus 3 Minkowski, 3 spatial dims, for the wave energy test.
- Dimension: the slice itself works on R^n for general n, with n equal to 3 as the acceptance case.
- Target exponent: q equal to 6, the critical exponent, for the H1 embedding in R3.
- Target exponent: q equal to 2 for the energy variables in the wave test.
- Target exponent: q equal to infinity after weighting for the decay test.
- Weight convention: unit weight, delta equal to 0, for the first two tests.
- Weight convention: delta equal to 0 in the first two tests means unit weight, not the weighted space index of the third test.
- Weight convention: weighted norm is the sum over multi-indices alpha with order at most 2 of the integral of bracket-x to the power minus 2 delta plus 2 order of alpha minus 3, times the squared alpha derivative, with bracket-x equal to the square root of 1 plus x squared.
- s: s equal to 1 for the H1 embedding test.
- s: spatial data orders s equal to 1 and s minus 1 equal to 0 for the wave test.
- s: s equal to 2 for the weighted test.
- Delta: delta equal to 0 for the first two tests.
- Delta: delta equal to minus 1 for the weighted test, which specifies r to the minus 1 decay in the convention above.
- Local regularity, embedding test: first weak derivatives locally in L2, and global H1 assumed.
- Local regularity, wave test: classical smooth solutions with spatial support uniformly compact on bounded time intervals.
- Local regularity, weighted test: u in H2 locally, with finite global weighted norm.
- Local regularity, slice itself: u and each weak derivative in L2 on R^n, hence locally integrable.
- Poincare hypothesis: none for the whole space tests, the norm is inhomogeneous and no zero mean is used.
- Poincare hypothesis: on a bounded domain it needs zero mean or zero boundary values, named here as a later run hypothesis, not assumed here.
- Trace hypothesis: none for the whole space tests, there is no boundary.
- Trace hypothesis: on a bounded domain it needs a Lipschitz domain, named here as a later run hypothesis, not assumed here.

## Acceptance tests, exact form

- Test 1, H1 embedding: for u in H1 of R3, the L6 norm of u is at most C times the H1 norm of u, for some constant C.
- Test 2, wave energy: for the homogeneous wave equation on Minkowski space, energy is conserved, E of t equals E of 0, with 2 E of t equal to the squared L2 norm of the time derivative plus the squared L2 norm of the spatial gradient.
- Test 3, weighted decay: for u with finite weighted norm at s equal to 2 and delta equal to minus 1, the sup norm of bracket-x times u is at most C times the square root of the weighted norm, which gives O of r to the minus 1 at infinity for the continuous representative.
- None of the three tests supplies W12 on a bounded domain. The downstream bounded domain example stays out of scope for this run.

## Bridge norm comparison, exact form to prove later

- Bridge (forward only): every W12 element of R^n has an H1 Bessel witness h, with the norm comparison below; the reverse direction, the equality of H1 and W12 as sets of L2 classes, and uniqueness of the derivative tuple are not stated here.
- H1 norm: the L2 norm of the witness h, where h is the L2 function representing the order 1 Bessel potential of the tempered distribution in MemSobolev.
- W12 norm: the square root of the squared L2 norm of u plus the sum over i of the squared L2 norm of the i-th weak derivative.
- Exact comparison to prove: squared H1 norm equals squared L2 norm of u plus (2 pi) to the minus 2 times the sum over i of squared L2 norms of the weak derivatives.
- The (2 pi) to the minus 2 factor comes from the Mathlib Bessel convention, where the order 1 symbol is (1 plus x squared) to the one half and the derivative symbol is 2 pi i xi.
- The multiplier check is remaining step 1 of the bridge. No isometry is claimed until the symbols are read off in the same Fourier coordinates.

## What this run delivers, and what it does not

- Delivers: weak derivatives on R^n with uniqueness proved, W12 defined with its norm proved, bridge stated with the exact comparison above and the remaining steps listed.
- Does not deliver: embeddings, trace, Poincare, weighted spaces, the bridge proof, or W12 on a bounded domain.
- It would be misleading to claim that this slice finishes Phase 3, or that the bridge is proved, or that W12 on a bounded domain exists in Lean after this run.
