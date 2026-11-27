# lean-geometry-pde

Lean infrastructure for Lorentzian geometry and PDE.

## Goal

Mathlib can describe smooth shapes and positive definite geometry. It cannot yet describe spacetime, where one direction behaves like time and three behave like space. It cannot yet describe the Einstein equations in Lean, or the function spaces that PDE proofs use on curved space.

This repo builds that missing layer. The end state is a Lean library where a researcher can write down a Lorentzian metric, compute its curvature, state the Einstein vacuum equations, state Kerr stability, and state a mass gap, with every definition checked by Lean.

This repo does not prove Kerr stability. It does not prove the Yang-Mills mass gap. It builds the floor those proofs would stand on.

## Plan

Read [PLAN.md](PLAN.md). Phases:

- Phase 0: audit and architecture, 2 to 4 weeks
- Phase 1: Lorentzian metric, Levi-Civita, Ricci, 6 to 18 person-months
- Phase 2: Einstein equations and Ricci flat, 3 to 9 person-months
- Phase 3: Sobolev, energy estimates, PDE tools, 12 to 36 person-months
- Phase 4: Kerr metric and horizons in Lean, 6 to 18 person-months
- Phase 5: decay and stability scaffolding only, 24 to 60 person-months, no proof claimed

Total Phases 0 to 4: about 2.5 to 7 person-years.

## Rule

Lean decides. Every Lean file must compile, exit 0, no sorry, no admit. Every claim names a file, a line, and a source. A checker re-opens each one.

## Status

- Phase 0 audit: DONE, 26 Nov 2026. Audit file compiles, exit 0, 33 present, 9 absent, 1 satellite.
- Phase 1 planning: judge verdict GAP, 26 Nov 2026. Architecture delivered by Neon, math by Astra, Astra hostile review landed 26 Nov 2026, Gemini review still missing.
- Signature lock: DONE, 26 Nov 2026. (p, q) = (pluses, minuses), Lorentzian (3, 1), Riemannian (n, 0). RFCs amended.
- Phases 1 to 5 code: planned, not started

## Author

Richardson Dackam, independent researcher, Toronto, Canada.
LinkedIn: https://linkedin.com/in/richardsondx
X: https://x.com/RichardsonDx

## License

MIT
