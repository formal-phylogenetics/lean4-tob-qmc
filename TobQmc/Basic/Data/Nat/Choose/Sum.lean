module

public import Mathlib.Algebra.BigOperators.Intervals
public import Mathlib.Data.Nat.Choose.Basic
public import Mathlib.Tactic.Ring

/-!
# A Vandermonde identity for `C(a, 2)`

`∑_{a ≤ n} C(a, 2) C(n - a, s) = C(n + 1, s + 3)`. The count of the subsets that the brute force
tests on a caterpillar (`TobQmc.Algorithms.RunningTime`) is its case `s = 2`.
-/

@[expose] public section

open Finset

namespace Nat

/-- `∑_{a ≤ n} C(a, 2) C(n - a, s) = C(n + 1, s + 3)`. -/
theorem sum_range_choose_two_mul_choose (n s : ℕ) :
    ∑ a ∈ range (n + 1), a.choose 2 * (n - a).choose s = (n + 1).choose (s + 3) := by
  induction n generalizing s with
  | zero =>
    rw [Nat.choose_eq_zero_of_lt (by omega)]
    simp
  | succ n ih =>
    cases s with
    | zero =>
      have h0 := ih 0
      simp only [Nat.choose_zero_right, mul_one] at h0 ⊢
      rw [sum_range_succ, h0, Nat.choose_succ_succ (n + 1) 2, add_comm]
    | succ s =>
      rw [sum_range_succ]
      have hlast : (n + 1 - (n + 1)).choose (s + 1) = 0 := by simp
      rw [hlast, mul_zero, add_zero]
      have hpascal : ∀ a ∈ range (n + 1), a.choose 2 * (n + 1 - a).choose (s + 1) =
          a.choose 2 * (n - a).choose (s + 1) + a.choose 2 * (n - a).choose s := by
        intro a ha
        have ha' : a ≤ n := by simpa [Nat.lt_succ_iff] using ha
        rw [show n + 1 - a = (n - a) + 1 by omega, Nat.choose_succ_succ]
        ring
      rw [sum_congr rfl hpascal, sum_add_distrib, ih, ih, show s + 1 + 3 = (s + 3) + 1 by ring, Nat.choose_succ_succ (n + 1) (s + 3)]
      ring

end Nat
