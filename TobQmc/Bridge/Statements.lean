module

public import TobQmc.Bridge.Model
public import TobQmc.FalsePositives.Consistency

/-!
# The main results on the Challenge's definitions

Theorems 1 and 2 and the consistency claim of §4.3, as the Challenge states them on the definitions
of `TobQmc.Defs`, proved from the paper's library (`TobQmc.theorem1`, `TobQmc.theorem1_optimal`,
`TobQmc.theorem2`, `TobQmc.consistency`) through the bridges of `TobQmc.Bridge.Model`.
-/

@[expose] public noncomputable section

open Filter Topology MeasureTheory Phylogenetics Phylogenetics.RootedNetwork
open scoped Classical

namespace TobQmc.Model

variable {V E X : Type*} [Fintype V] [Fintype E] [Fintype X] [DecidableEq X]

/-- **Theorem 1**, on the Challenge's definitions. -/
theorem theorem1 {N : Network V E X} {θ : Params E} {ρ : ℝ}
    (hStd : N.StandardAssumptions θ ρ) (hNon : N.IsTQuartetNonanomalous (N.nmscCF θ ρ))
    (hX : 4 ≤ Fintype.card X)
    {Ω : Type*} [MeasurableSpace Ω] (P : Measure Ω) [IsProbabilityMeasure P]
    (G : ℕ → Ω → Finset (Finset X)) (hG : N.IsGeneTreeSample θ ρ P G)
    (T : Finset (Finset X)) (hT : IsBinaryTree T) (hTN : ¬ N.treeOfBlobs ⊆ T) {ε : ℝ} (hε : 0 < ε) :
    ∃ (B : Finset (Finset X)) (K : ℕ), IsBinaryTree B ∧ N.treeOfBlobs ⊆ B ∧
      1 - ε ≤ P.real {ω | ∀ k, K ≤ k →
        quartetSupport (geneCount G k ω) T < quartetSupport (geneCount G k ω) B} :=
  TobQmc.theorem1 ((N.standardAssumptions_iff θ ρ).mp hStd) hNon hX P G
    ((N.isGeneTreeSample_iff θ ρ P G).mp hG) T hT hTN hε

/-- **Theorem 1**, "put simply", on the Challenge's definitions. -/
theorem theorem1_optimal {N : Network V E X} {θ : Params E} {ρ : ℝ}
    (hStd : N.StandardAssumptions θ ρ) (hNon : N.IsTQuartetNonanomalous (N.nmscCF θ ρ))
    (hX : 4 ≤ Fintype.card X)
    {Ω : Type*} [MeasurableSpace Ω] (P : Measure Ω) [IsProbabilityMeasure P]
    (G : ℕ → Ω → Finset (Finset X)) (hG : N.IsGeneTreeSample θ ρ P G) :
    ∀ᵐ ω ∂P, ∃ K, ∀ k, K ≤ k → ∀ B, IsBinaryTree B →
      (∀ T, IsBinaryTree T → quartetSupport (geneCount G k ω) T ≤ quartetSupport (geneCount G k ω) B) →
      N.treeOfBlobs ⊆ B :=
  TobQmc.theorem1_optimal ((N.standardAssumptions_iff θ ρ).mp hStd) hNon hX P G
    ((N.isGeneTreeSample_iff θ ρ P G).mp hG)

/-- **Theorem 2**, on the Challenge's definitions. -/
theorem theorem2 {N : Network V E X} (hN : N.IsPhylogenetic) (hBin : N.IsBinary)
    (hLevel : N.IsLevelOne) {B : Finset (Finset X)} (hB : IsUnrootedTree B)
    (hTB : N.treeOfBlobs ⊆ B) (Q : Finset X → Finset (Finset X))
    (hQ : ∀ A ∈ internalSides B, IsDisjointCover B A (Q A)) :
    contractSides B ((internalSides B).filter fun A => ∃ Y ∈ Q A, ¬ N.IsTreelike Y) =
      N.treeOfBlobs :=
  TobQmc.theorem2 ((N.isPhylogenetic_iff).mp hN) hBin hLevel hB hTB Q
    fun A hA => (isDisjointCover_iff B A (Q A)).mp (hQ A hA)

/-- **The consistency claim of §4.3**, on the Challenge's definitions. -/
theorem consistency {N : Network V E X} {θ : Params E} {ρ : ℝ}
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
  obtain ⟨α, hα, hαpos, h⟩ :=
    TobQmc.consistency ((N.standardAssumptions_iff θ ρ).mp hStd) hLevel hNon hBlob hX
  refine ⟨α, hα, hαpos, fun β hβ ml hml solve hsolve cover hcover => ?_⟩
  exact h β hβ ml hml solve hsolve cover
    fun B hB A hA => (isDisjointCover_iff B A (cover B A)).mp (hcover B hB A hA)

end TobQmc.Model
