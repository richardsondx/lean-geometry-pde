#!/usr/bin/env python3
"""Independent numerical check for the 2D Minkowski showcase proof.

Checks, with exact integer arithmetic, the same facts Lean proves in
PseudoRiemannian/Showcase.lean:
  - the form -v0*w0 + v1*w1 on the standard basis vectors gives the matrix
    [[-1, 0], [0, 1]]
  - that matrix has determinant -1
  - the form is symmetric and nondegenerate on basis vectors
"""

from fractions import Fraction


def form(v, w):
    return -v[0] * w[0] + v[1] * w[1]


e0 = (Fraction(1), Fraction(0))
e1 = (Fraction(0), Fraction(1))
basis = [e0, e1]

matrix = [[form(basis[i], basis[j]) for j in range(2)] for i in range(2)]
assert matrix == [[Fraction(-1), Fraction(0)], [Fraction(0), Fraction(1)]], matrix

det = matrix[0][0] * matrix[1][1] - matrix[0][1] * matrix[1][0]
assert det == Fraction(-1), det

for i in range(2):
    for j in range(2):
        assert form(basis[i], basis[j]) == form(basis[j], basis[i])

# Nondegenerate: no nonzero vector pairs to zero with both basis vectors.
for v in [(Fraction(1), Fraction(0)), (Fraction(0), Fraction(1)),
          (Fraction(1), Fraction(1)), (Fraction(2), Fraction(-3))]:
    assert form(v, e0) != 0 or form(v, e1) != 0

print("showcase check passed: matrix [[-1, 0], [0, 1]], det -1, symmetric, nondegenerate")
