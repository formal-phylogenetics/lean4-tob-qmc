module

public import Mathlib.Algebra.BigOperators.Ring.Finset
public import Mathlib.Basic.Real.Basic
public import Mathlib.Tactic.Linarith
public import Mathlib.Tactic.Ring

/-!
# A double sum over distinct indices

`∑_{j≠i} ∑_{k≠i,j} b_j c_k`, in terms of the sums of `b` and `c` and of `b c`. The equation 6 of
Zhang et al. 2018, which ASTRAL-III's count of operations (`TobQmc.Algorithms.RunningTime`) uses,
is three such sums.
-/

@[expose] public section

open Finset

namespace Fintype

variable {ι : Type*} [Fintype ι] [DecidableEq ι]

/-- The sum of `b_j c_k` over the pairs `j ≠ i`, `k ≠ i, j`: `∑_{j≠i} ∑_{k≠i,j} b_j c_k`. -/
theorem sum_sum_ite_ne_mul (b c : ι → ℝ) (i : ι) :
    (∑ j, ∑ k, if j ≠ i ∧ k ≠ i ∧ k ≠ j then b j * c k else 0) =
      (∑ j, b j - b i) * (∑ j, c j - c i) - ∑ j, b j * c j + b i * c i := by
  have h₁ : ∀ j, (∑ k, if j ≠ i ∧ k ≠ i ∧ k ≠ j then b j * c k else 0) =
      if j ≠ i then b j * (∑ k, c k - c i - c j) else 0 := by
    intro j
    by_cases hj : j = i
    · simp [hj]
    · have hsplit : ∑ k, c k = c i + (c j + ∑ k ∈ (univ.erase i).erase j, c k) := by
        rw [← add_sum_erase _ _ (mem_univ i), ← add_sum_erase _ _ (mem_erase.2 ⟨hj, mem_univ j⟩)]
      have hsum : (∑ k, if k ≠ i ∧ k ≠ j then c k else 0) = ∑ k ∈ (univ.erase i).erase j, c k := by
        rw [← sum_filter]
        refine sum_congr ?_ fun _ _ => rfl
        ext k
        simp only [mem_filter, mem_univ, true_and, mem_erase, ne_eq]
        tauto
      simp only [hj, ne_eq, not_false_eq_true, true_and, ↓reduceIte]
      have hpull : (∑ k, if ¬ k = i ∧ ¬ k = j then b j * c k else 0) = b j * ∑ k, if ¬ k = i ∧ ¬ k = j then c k else 0 := by
        rw [mul_sum]
        refine sum_congr rfl fun k _ => ?_
        split_ifs <;> simp
      rw [hpull]
      congr 1
      simp only [ne_eq] at hsum
      rw [hsum]
      linarith
  simp only [h₁]
  have h₂ : (∑ j, if j ≠ i then b j * (∑ k, c k - c i - c j) else 0) =
      ∑ j, (b j * (∑ k, c k - c i) - b j * c j) - (b i * (∑ k, c k - c i) - b i * c i) := by
    rw [← add_sum_erase _ (fun j => b j * (∑ k, c k - c i) - b j * c j) (mem_univ i), add_sub_cancel_left,
      ← sum_filter]
    refine sum_congr ?_ fun j _ => by ring
    ext j
    simp [mem_erase]
  rw [h₂, sum_sub_distrib, ← sum_mul]
  ring

end Fintype
