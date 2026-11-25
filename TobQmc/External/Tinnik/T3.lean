module

public import Tinnik.Consistency.T3

/-!
# TINNiK: the T3 option

TINNiK's T3 option replaces the cut test by the T3 test of Mitchell et al. 2019, and TOB-QMC makes it
its default ("the T3 option is the default in TINNiK due to its strong empirical performance"). Its
consistency claim with the T3 option uses the T3 form of the step of the proof of TINNiK's Theorem 4:
levels at which the T3 test rejects on the sets with no cut-edge split, and the correctness of the tests
on all sets of four taxa.

Each result is stated in the source's terms, those of lean4-tinnik and of the libraries, and proved
from the theorem of lean4-tinnik named in its docstring.
-/

@[expose] public noncomputable section

open Phylogenetics Phylogenetics.RootedNetwork Filter Topology
open Tinnik (T3Detectable T3Rejects IsT3MLSelection testedBT3 testedTT3)
open scoped Classical

namespace External.Tinnik

variable {V E X : Type*} [Fintype X] [DecidableEq X]

/-- A non-cut concordance factor (Definition 15 of Allman et al. 2023) is off model T3.
lean4-tinnik proves it as `Tinnik.not_isT3Null_of_isNonCut`. -/
theorem not_isT3Null_of_isNonCut {p : QuartetTree X → ℝ} {q : Finset X}
    (h : Allman2023.IsNonCut p q) : ¬ IsT3Null p q :=
  _root_.Tinnik.not_isT3Null_of_isNonCut h

/-- **The levels of the proof of Theorem 4, for the T3 test**: at parameters where the T3 test can
detect the sets with no cut-edge split, there are levels `α_m → 0` at which it rejects on them with
probability tending to one. lean4-tinnik proves it as `Tinnik.exists_levels_t3`. -/
theorem exists_levels_t3 [Fintype V] [Fintype E] [Nonempty X] {N : RootedNetwork V E X} (hN : N.IsPhylogenetic)
    {θ : MetricData E} (hθ : N.IsMetric θ) {ρ : ℝ} (hρ : 0 ≤ ρ ∧ ρ ≤ 1)
    (hdet : T3Detectable N (nmscCF N θ ρ)) :
    ∃ α : ℕ → ℝ, Tendsto α atTop (𝓝 0) ∧ (∀ m, 0 < α m) ∧ T3Rejects N θ ρ α :=
  _root_.Tinnik.exists_levels_t3 hN hθ hρ hdet

/-- **The tests are correct on all sets of four taxa, with the T3 option**, for any inheritance
correlation `ρ`: for levels `α_m → 0` at which the T3 test rejects on the sets with no cut-edge split,
and any `β > 0`, TINNiK's tests with the T3 option return the correct answer on all sets of four taxa
with probability tending to one. lean4-tinnik proves it as `Tinnik.tests_correct_t3_of_t3Detectable`. -/
theorem tests_correct_t3_of_t3Detectable [Fintype V] [Fintype E] {N : RootedNetwork V E X}
    (hN : N.IsPhylogenetic) (hX : 4 ≤ Fintype.card X) {θ : MetricData E} (hθ : N.IsMetric θ)
    {ρ : ℝ} (hρ : 0 ≤ ρ ∧ ρ ≤ 1) (hdet : T3Detectable N (nmscCF N θ ρ))
    {α : ℕ → ℝ} (hα₀ : Tendsto α atTop (𝓝 0)) (hrej : T3Rejects N θ ρ α)
    {β : ℝ} (hβ : 0 < β) {ml : (QuartetTree X → ℝ) → Finset X → QuartetTree X}
    (hml : IsT3MLSelection ml) :
    Tendsto (fun m => iidProb (geneTreeDist N θ ρ) m fun ω =>
      testedBT3 ml (α m) β (quartetCount unroot ω) = {q | q.card = 4 ∧ ¬ IsTreelike N q} ∧
        testedTT3 ml (α m) β (quartetCount unroot ω) = {s | InducedCutSplit N s}) atTop (𝓝 1) :=
  _root_.Tinnik.tests_correct_t3_of_t3Detectable hN hX hθ hρ hdet hα₀ hrej hβ hml

end External.Tinnik
