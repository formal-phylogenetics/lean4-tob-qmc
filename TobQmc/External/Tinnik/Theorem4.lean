module

public import Tinnik.Consistency.Theorem4

/-!
# TINNiK: the hypothesis tests of the proof of Theorem 4

TOB-QMC's oracle for treelikeness is "TINNiK's hypothesis tests" (Allman, Baños, Mitchell, Rhodes
2024), and the consistency claim of its §4.3 cites TINNiK's Theorem 4 for them. What it uses is a step
of that theorem's proof: at parameters with `CF`-detectability, there are levels `α_m → 0` at which
the star and cut tests return the correct answer on every set of four taxa with probability tending
to one. The level-2 counterexamples of its supplement use the limits of the tests on one set of four
taxa.

Each result is stated in the source's terms, those of lean4-tinnik and of the libraries, and proved
from the theorem of lean4-tinnik named in its docstring.
-/

@[expose] public noncomputable section

open Phylogenetics Phylogenetics.RootedNetwork Filter Topology
open Tinnik (Rejects)
open scoped Classical

namespace External.Tinnik

variable {V E X : Type*} [Fintype X] [DecidableEq X]

/-- **The levels of the proof of Theorem 4.** At parameters with `CF`-detectability there are levels
`α_m → 0` at which the cut test rejects on every set of four taxa with no cut-edge split, with
probability tending to one. lean4-tinnik proves it as `Tinnik.exists_levels`. -/
theorem exists_levels [Fintype V] [Fintype E] [Nonempty X] {N : RootedNetwork V E X} (hN : N.IsPhylogenetic)
    {θ : MetricData E} (hθ : N.IsMetric θ) {ρ : ℝ} (hρ : 0 ≤ ρ ∧ ρ ≤ 1)
    (hdet : Allman2023.CFDetectable N (nmscCF N θ ρ)) :
    ∃ α : ℕ → ℝ, Tendsto α atTop (𝓝 0) ∧ (∀ m, 0 < α m) ∧ Rejects N θ ρ α :=
  _root_.Tinnik.exists_levels hN hθ hρ hdet

/-- **The tests are correct on all sets of four taxa**, the step of the proof of Theorem 4 that
TOB-QMC §4.3 cites: at parameters with `CF`-detectability, for levels `α_m → 0` at which the cut test
rejects on the sets with no cut-edge split, and any `β > 0`, Step 2 of TINNiK judges exactly the sets
with no cut-edge split to be B-quartets and infers the cut-edge splits of the others, with probability
tending to one. lean4-tinnik proves it as `Tinnik.tests_correct`. -/
theorem tests_correct [Fintype V] [Fintype E] {N : RootedNetwork V E X}
    (hN : N.IsPhylogenetic) (hX : 4 ≤ Fintype.card X) {θ : MetricData E} (hθ : N.IsMetric θ)
    {ρ : ℝ} (hρ : 0 ≤ ρ ∧ ρ ≤ 1) (hdet : Allman2023.CFDetectable N (nmscCF N θ ρ))
    {α : ℕ → ℝ} (hα₀ : Tendsto α atTop (𝓝 0)) (hrej : Rejects N θ ρ α)
    {β : ℝ} (hβ : 0 < β) {ml : (QuartetTree X → ℝ) → Finset X → QuartetTree X}
    (hml : IsMLSelection ml) :
    Tendsto (fun m => iidProb (geneTreeDist N θ ρ) m fun ω =>
      testedB ml (α m) β (quartetCount unroot ω) = {q | q.card = 4 ∧ ¬ IsTreelike N q} ∧
        testedT ml (α m) β (quartetCount unroot ω) = {s | InducedCutSplit N s}) atTop (𝓝 1) :=
  _root_.Tinnik.tests_correct hN hX hθ hρ hdet hα₀ hrej hβ hml

/-- Gene trees under the network multispecies coalescent are binary, so they display one quartet tree
on each set of four taxa. lean4-tinnik proves it as `Tinnik.displaysOne_nmsc`. -/
theorem displaysOne_nmsc [Fintype V] [Fintype E] [Nonempty X]
    {N : RootedNetwork V E X} (hN : N.IsPhylogenetic) {θ : MetricData E} {ρ : ℝ} :
    QuartetTests.DisplaysOne (geneTreeDist N θ ρ) (unroot (L := X)) :=
  _root_.Tinnik.displaysOne_nmsc hN

/-- Step 2a of the algorithm: for any `β > 0` the star test rejects a concordance factor off the
centroid, with probability tending to one. lean4-tinnik proves it as `Tinnik.tendsto_star`. -/
theorem tendsto_star {Γ : Type*} [Fintype Γ] {dist : Γ → ℝ} {sides : Γ → Finset (Finset X)}
    (hd : IsDist dist) (hs : QuartetTests.DisplaysOne dist sides) {q : Finset X} (hq : q.card = 4)
    (h : ¬ ∀ r ∈ treesOn q, displayCF dist sides r = 1 / 3) {β : ℝ} (hβ : 0 < β) :
    Tendsto (fun n => iidProb dist n fun ω => starPValue .lrt (quartetCount sides ω) q < β)
      atTop (𝓝 1) :=
  _root_.Tinnik.tendsto_star hd hs hq h hβ

/-- At a strictly cut concordance factor the maximum likelihood topology is the cut split, and the cut
test does not reject, with probability tending to one. lean4-tinnik proves it as
`Tinnik.tendsto_good_cut`. -/
theorem tendsto_good_cut [Fintype V] [Fintype E] [Nonempty X]
    {N : RootedNetwork V E X} (hN : N.IsPhylogenetic) {θ : MetricData E} (hθ : N.IsMetric θ)
    {ρ : ℝ} (hρ : 0 ≤ ρ ∧ ρ ≤ 1) {α : ℕ → ℝ} (hα₀ : Tendsto α atTop (𝓝 0))
    {ml : (QuartetTree X → ℝ) → Finset X → QuartetTree X}
    (hml : IsMLSelection ml) {s₀ : QuartetTree X}
    (hc : Allman2023.IsStrictlyCutAt (nmscCF N θ ρ) s₀) :
    Tendsto (fun m => iidProb (geneTreeDist N θ ρ) m fun ω =>
      ml (quartetCount unroot ω) s₀.taxa = s₀ ∧
        α m ≤ cutPValue (quartetCount unroot ω) s₀) atTop (𝓝 1) :=
  _root_.Tinnik.tendsto_good_cut hN hθ hρ hα₀ hml hc

end External.Tinnik
