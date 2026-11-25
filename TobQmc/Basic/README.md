# General mathematics

Lemmas that say nothing about phylogenetics, filed by field as Mathlib files them and named as
Mathlib would name them, in Mathlib's namespaces, so that they can be contributed to Mathlib. They
import only Mathlib.

| File | Contents | Where it could go |
| --- | --- | --- |
| [`Algebra/BigOperators/Basic.lean`](Algebra/BigOperators/Basic.lean) | the sum of `b_j c_k` over `j ≠ i` and `k ≠ i, j`, in terms of the sums of `b`, `c` and `b c` ([`Fintype.sum_sum_ite_ne_mul`](Algebra/BigOperators/Basic.lean#L25)), for Equation 6 of Zhang et al. 2018 in ASTRAL-III's count of operations | `Mathlib/Algebra/BigOperators/Basic.lean` |
| [`Data/Nat/Choose/Sum.lean`](Data/Nat/Choose/Sum.lean) | `∑_{a ≤ n} C(a, 2) C(n - a, s) = C(n + 1, s + 3)` ([`Nat.sum_range_choose_two_mul_choose`](Data/Nat/Choose/Sum.lean#L21)), for the number of subsets that the brute force tests on a caterpillar | `Mathlib/Data/Nat/Choose/Vandermonde.lean` |

Some general facts stay where they are used, because they state a claim of the paper in arithmetic:
the orders of growth of the running times ([`TobQmc.choose_five_mul`](../Algorithms/RunningTime.lean#L554), [`TobQmc.rpow_mul_lt_cube`](../Algorithms/RunningTime.lean#L507),
[`TobQmc.balanced_total_le`](../Algorithms/RunningTime.lean#L563)) and the number of samples of the remark on random subsets
([`TobQmc.one_sub_pow_le_mul`](../Algorithms/RunningTime.lean#L676), [`TobQmc.pow_le_exp`](../Algorithms/RunningTime.lean#L683)), in [`TobQmc/Algorithms/RunningTime.lean`](../Algorithms/RunningTime.lean). The
analysis of Kane and Tao's inequality (abc), Gibbs' inequality for two outcomes and the bounds on
`log 3`, is part of the source's argument, in [`TobQmc/External/KaneTao2017/`](../External/KaneTao2017).

Before adding a lemma, search Mathlib and lean4-phylogenetics (`Phylogenetics/ForMathlib/`): a
lemma that a second repository of the collection needs moves up the tree, to the lowest node above
both (lean4-phylogenetics, docs/CONVENTIONS.md, Section 4).
