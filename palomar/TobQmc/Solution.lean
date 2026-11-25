module

public import TobQmc.Bridge.Statements
public import TobQmc.Algorithms.RunningTime
public import TobQmc.Background.DisplayedRefinement
public import TobQmc.Background.Lemma1
public import TobQmc.Background.LevelOneDigraph
public import TobQmc.External.AneEtAl2024.Rules
public import TobQmc.External.DinhBanos2025.Theorem1
public import TobQmc.FalsePositives.BipartitionSearchT3
public import TobQmc.Supplement.Lemma2
public import TobQmc.Supplement.Lemma4Margin
public import TobQmc.Supplement.Lemma8
public import TobQmc.Supplement.LevelTwo

/-! # TOB-QMC (Dai, Han, Molloy 2026): the proof of the statements of record

Restates the theorems of `TobQmc.Challenge` word for word, in the namespace `TobQmcChallenge`, and
proves them from the library, through the bridges of `TobQmc.Bridge` between the Challenge's
definitions and the library's. It is the entry point of the library. -/


public section

namespace TobQmcChallenge

open TobQmc.Model Filter Topology MeasureTheory
open scoped Classical

/-- **Theorem 1.** Under the standard assumptions, for a T-quartet-nonanomalous network on at least
four taxa and independent gene trees from the network multispecies coalescent, for every binary tree
`T` that does not refine the tree of blobs and every `ε > 0`, there are a binary refinement `B` of the
tree of blobs and `K` such that, with probability at least `1 - ε`, the quartet score of `B` on the
first `k` gene trees exceeds that of `T` for all `k ≥ K`. -/
theorem theorem1 {V E X : Type*} [Fintype V] [Fintype E] [Fintype X] [DecidableEq X]
    {N : Network V E X} {θ : Params E} {ρ : ℝ}
    (hStd : N.StandardAssumptions θ ρ) (hNon : N.IsTQuartetNonanomalous (N.nmscCF θ ρ))
    (hX : 4 ≤ Fintype.card X)
    {Ω : Type*} [MeasurableSpace Ω] (P : Measure Ω) [IsProbabilityMeasure P]
    (G : ℕ → Ω → Finset (Finset X)) (hG : N.IsGeneTreeSample θ ρ P G)
    (T : Finset (Finset X)) (hT : IsBinaryTree T) (hTN : ¬ N.treeOfBlobs ⊆ T) {ε : ℝ} (hε : 0 < ε) :
    ∃ (B : Finset (Finset X)) (K : ℕ), IsBinaryTree B ∧ N.treeOfBlobs ⊆ B ∧
      1 - ε ≤ P.real {ω | ∀ k, K ≤ k →
        quartetSupport (geneCount G k ω) T < quartetSupport (geneCount G k ω) B} := by
  exact TobQmc.Model.theorem1 hStd hNon hX P G hG T hT hTN hε

/-- **Theorem 1**, "put simply". Under the same assumptions, almost surely, for all large `k`, every
optimal solution of Weighted Quartet Consensus on the first `k` gene trees refines the tree of
blobs. -/
theorem theorem1_optimal {V E X : Type*} [Fintype V] [Fintype E] [Fintype X] [DecidableEq X]
    {N : Network V E X} {θ : Params E} {ρ : ℝ}
    (hStd : N.StandardAssumptions θ ρ) (hNon : N.IsTQuartetNonanomalous (N.nmscCF θ ρ))
    (hX : 4 ≤ Fintype.card X)
    {Ω : Type*} [MeasurableSpace Ω] (P : Measure Ω) [IsProbabilityMeasure P]
    (G : ℕ → Ω → Finset (Finset X)) (hG : N.IsGeneTreeSample θ ρ P G) :
    ∀ᵐ ω ∂P, ∃ K, ∀ k, K ≤ k → ∀ B, IsBinaryTree B →
      (∀ T, IsBinaryTree T → quartetSupport (geneCount G k ω) T ≤ quartetSupport (geneCount G k ω) B) →
      N.treeOfBlobs ⊆ B := by
  exact TobQmc.Model.theorem1_optimal hStd hNon hX P G hG

/-- **Theorem 2.** On a binary level-1 phylogenetic network, let `B` be an unrooted tree that refines
the tree of blobs, and `Q A` a disjoint cover around each internal edge of `B`, with side `A`. Applying
the oracle for treelikeness to the sets of each cover, labelling an edge a false positive when the
oracle answers non-treelike on one of them, and contracting the false positives returns the tree of
blobs. -/
theorem theorem2 {V E X : Type*} [Fintype V] [Fintype E] [Fintype X] [DecidableEq X]
    {N : Network V E X} (hN : N.IsPhylogenetic) (hBin : N.IsBinary)
    (hLevel : N.IsLevelOne) {B : Finset (Finset X)} (hB : IsUnrootedTree B)
    (hTB : N.treeOfBlobs ⊆ B) (Q : Finset X → Finset (Finset X))
    (hQ : ∀ A ∈ internalSides B, IsDisjointCover B A (Q A)) :
    contractSides B ((internalSides B).filter fun A => ∃ Y ∈ Q A, ¬ N.IsTreelike Y) =
      N.treeOfBlobs := by
  exact TobQmc.Model.theorem2 hN hBin hLevel hB hTB Q hQ

/-- **The consistency claim of §4.3.** Under the standard assumptions, for a level-1,
T-quartet-nonanomalous network on at least four taxa whose sets of four taxa with a 4-blob have non-cut
concordance factors (assumption 6a), there are levels `α_k → 0` such that, for every level `β > 0`,
every selection `ml` of maximum likelihood topologies, every solver `solve` of Weighted Quartet
Consensus and every choice `cover` of disjoint covers, TOB-QMC on `k` independent gene trees from the
network multispecies coalescent, with TINNiK's star and cut tests as the oracle, returns the tree of
blobs with probability tending to one as `k` grows. -/
theorem consistency {V E X : Type*} [Fintype V] [Fintype E] [Fintype X] [DecidableEq X]
    {N : Network V E X} {θ : Params E} {ρ : ℝ}
    (hStd : N.StandardAssumptions θ ρ) (hLevel : N.IsLevelOne)
    (hNon : N.IsTQuartetNonanomalous (N.nmscCF θ ρ))
    (hBlob : ∀ q : Finset X, q.card = 4 → ¬ N.IsTreelike q → IsNonCut (N.nmscCF θ ρ) q)
    (hX : 4 ≤ Fintype.card X) :
    ∃ α : ℕ → ℝ, Tendsto α atTop (𝓝 0) ∧ (∀ k, 0 < α k) ∧
      ∀ (β : ℝ), 0 < β →
      ∀ (ml : (QuartetTree X → ℝ) → Finset X → QuartetTree X), IsMLSelection ml →
      ∀ (solve : (QuartetTree X → ℝ) → Finset (Finset X)), (∀ c, IsWQCOptimal c (solve c)) →
      ∀ (cover : Finset (Finset X) → Finset X → Finset (Finset X)),
        (∀ B, IsBinaryTree B → ∀ A ∈ internalSides B, IsDisjointCover B A (cover B A)) →
        Tendsto (fun k => iidProb (N.geneTreeDist θ ρ) k fun ω =>
          tobqmc ml (α k) β (quartetCount unroot ω) (solve (quartetCount unroot ω))
            (cover (solve (quartetCount unroot ω))) = N.treeOfBlobs) atTop (𝓝 1) := by
  exact TobQmc.Model.consistency hStd hLevel hNon hBlob hX

end TobQmcChallenge

end
