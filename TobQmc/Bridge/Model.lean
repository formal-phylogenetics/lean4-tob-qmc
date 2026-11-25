module

public import TobQmc.Defs
public import TobQmc.FalsePositives.Consistency

/-!
# The Challenge's definitions are the library's

The Challenge states its theorems on the definitions of `TobQmc.Defs` (namespace `TobQmc.Model`),
written in Mathlib's vocabulary. The library states them on those of `Phylogenetics`,
`PhyloNetwork`, `TreeOfBlobs` and `Allman2023`. This module proves that the two agree: most are equal
by definition, once a network of the Challenge is read as one of the library (`Network.toRooted`) and
its parameters as the library's (`Params.toMetric`).

* `Network.isPhylogenetic_iff`, `Network.isBinary_iff`, `Network.isMetric_iff`,
  `Network.isLevelOne_iff`: the networks and their parameters.
* `Network.treeOfBlobs_eq`, `Network.isTreelike_iff`: the tree of blobs and treelikeness.
* `Network.geneTreeDist_eq`, `Network.nmscCF_eq`, `Network.isGeneTreeSample_iff`: the network
  multispecies coalescent and its samples.
* `isBinaryTree_iff`, `isUnrootedTree_iff`, `quartetSupport_eq`, `isWQCOptimal_iff`, `geneCount_eq`:
  trees and Weighted Quartet Consensus.
* `Network.standardAssumptions_iff`, `Network.isTQuartetNonanomalous_iff`, `isDisjointCover_iff`,
  `isNonCut_iff`, `isMLSelection_iff`, `iidProb_eq`, `quartetCount_eq`, `tobqmc_eq`: the
  assumptions and the method.
-/

@[expose] public noncomputable section

open Finset Phylogenetics Phylogenetics.RootedNetwork
open scoped Classical

namespace TobQmc.Model

variable {V E X : Type*}

/-- A graph of the Challenge as a graph of the library. -/
def Digraph.toDM (G : Digraph V E) : DirectedMultigraph V E := ⟨G.source, G.target⟩

/-- A network of the Challenge as a network of the library. -/
def Network.toRooted (N : Network V E X) : RootedNetwork V E X := ⟨N.graph.toDM, N.root, N.leaf⟩

/-- Parameters of the Challenge as parameters of the library. -/
def Params.toMetric (θ : Params E) : MetricData E := ⟨θ.length, θ.inheritance⟩

/-! ### Networks -/

namespace Network

variable (N : Network V E X)

/-- Rooted phylogenetic networks are the library's. -/
theorem isPhylogenetic_iff : N.IsPhylogenetic ↔ N.toRooted.IsPhylogenetic := by
  constructor
  · rintro ⟨h1, h2, h3, h4, h5, h6, h7, h8, h9, h10⟩
    exact ⟨h1, h2, h3, h4, h5, h6, h7, h8, h9, h10⟩
  · rintro ⟨h1, h2, h3, h4, h5, h6, h7, h8, h9, h10⟩
    exact ⟨h1, h2, h3, h4, h5, h6, h7, h8, h9, h10⟩

/-- Binary networks are the library's. -/
theorem isBinary_iff : N.IsBinary ↔ N.toRooted.IsBinary := Iff.rfl

/-- Valid parameters are the library's. -/
theorem isMetric_iff [Fintype E] (θ : Params E) : N.IsMetric θ ↔ N.toRooted.IsMetric θ.toMetric :=
  Iff.rfl

/-- Level-1 networks are the library's. -/
theorem isLevelOne_iff [Fintype V] [Fintype E] : N.IsLevelOne ↔ N.toRooted.IsLevelOne := Iff.rfl

variable [Fintype X] [DecidableEq X]

/-- The tree of blobs of the Challenge is the library's. -/
theorem treeOfBlobs_eq : N.treeOfBlobs = Phylogenetics.treeOfBlobs N.toRooted := rfl

/-- Treelike sets of four taxa are the library's. -/
theorem isTreelike_iff (q : Finset X) : N.IsTreelike q ↔ Phylogenetics.IsTreelike N.toRooted q :=
  Iff.rfl

/-! ### The coalescent -/

variable [Fintype V] [Fintype E] (θ : Params E) (ρ : ℝ)

/-- **The network multispecies coalescent** of the Challenge is the library's. -/
theorem geneTreeDist_eq (G : Finset (Finset X)) :
    N.geneTreeDist θ ρ G = Phylogenetics.geneTreeDist N.toRooted θ.toMetric ρ G := rfl

/-- The concordance factors of the Challenge are the library's. -/
theorem nmscCF_eq (s : QuartetTree X) :
    N.nmscCF θ ρ s = Phylogenetics.nmscCF N.toRooted θ.toMetric ρ s := rfl

/-- Samples of gene trees are the library's. -/
theorem isGeneTreeSample_iff {Ω : Type*} [MeasurableSpace Ω] (P : MeasureTheory.Measure Ω)
    (G : ℕ → Ω → Finset (Finset X)) :
    N.IsGeneTreeSample θ ρ P G ↔ Phylogenetics.IsGeneTreeSample N.toRooted θ.toMetric ρ P G := by
  constructor
  · rintro ⟨h1, h2, h3⟩
    exact ⟨h1, h2, h3⟩
  · rintro ⟨h1, h2, h3⟩
    exact ⟨h1, h2, h3⟩

/-! ### The assumptions of TOB-QMC -/

omit [Fintype V] [Fintype X] [DecidableEq X] in
/-- The standard assumptions are the library's. -/
theorem standardAssumptions_iff :
    N.StandardAssumptions θ ρ ↔ TreeOfBlobs.StandardAssumptions N.toRooted θ.toMetric ρ := by
  constructor
  · rintro ⟨h1, h2, h3, h4⟩
    exact ⟨(N.isPhylogenetic_iff).mp h1, h2, h3, h4⟩
  · rintro ⟨h1, h2, h3, h4⟩
    exact ⟨(N.isPhylogenetic_iff).mpr h1, h2, h3, h4⟩

omit [Fintype V] [Fintype E] in
/-- T-quartet-nonanomaly is the library's. -/
theorem isTQuartetNonanomalous_iff (F : QuartetTree X → ℝ) :
    N.IsTQuartetNonanomalous F ↔ TreeOfBlobs.IsTQuartetNonanomalous N.toRooted F := Iff.rfl

end Network

/-! ### Trees, the method and its samples -/

section Trees

variable [Fintype X] [DecidableEq X]

/-- Unrooted trees are the library's. -/
theorem isUnrootedTree_iff (T : Finset (Finset X)) :
    IsUnrootedTree T ↔ Phylogenetics.IsUnrootedTree T := Iff.rfl

/-- Binary trees are the library's. -/
theorem isBinaryTree_iff (T : Finset (Finset X)) : IsBinaryTree T ↔ Phylogenetics.IsBinaryTree T :=
  Iff.rfl

/-- The sides of the internal edges are the library's. -/
theorem internalSides_eq (T : Finset (Finset X)) :
    internalSides T = Phylogenetics.internalSides T := rfl

/-- Contracting edges is the library's. -/
theorem contractSides_eq (T C : Finset (Finset X)) :
    contractSides T C = Phylogenetics.contractSides T C := rfl

/-- The quartet score is the library's. -/
theorem quartetSupport_eq (w : QuartetTree X → ℝ) (T : Finset (Finset X)) :
    quartetSupport w T = Phylogenetics.quartetSupport w T := rfl

/-- Optimal solutions of Weighted Quartet Consensus are the library's. -/
theorem isWQCOptimal_iff (c : QuartetTree X → ℝ) (B : Finset (Finset X)) :
    IsWQCOptimal c B ↔ Phylogenetics.IsWQCOptimal c B := Iff.rfl

/-- Counts of gene trees in a sequence are the library's. -/
theorem geneCount_eq {Ω : Type*} (G : ℕ → Ω → Finset (Finset X)) (k : ℕ) (ω : Ω) :
    geneCount G k ω = Phylogenetics.geneCount G k ω := rfl

/-- Disjoint covers are the library's. -/
theorem isDisjointCover_iff (T : Finset (Finset X)) (A : Finset X) (Q : Finset (Finset X)) :
    IsDisjointCover T A Q ↔ TreeOfBlobs.IsDisjointCover T A Q := by
  constructor
  · rintro ⟨h1, h2⟩
    exact ⟨h1, h2⟩
  · rintro ⟨h1, h2⟩
    exact ⟨h1, h2⟩

/-- Non-cut concordance factors are those of lean4-allman2023. -/
theorem isNonCut_iff (p : QuartetTree X → ℝ) (q : Finset X) :
    IsNonCut p q ↔ Allman2023.IsNonCut p q := Iff.rfl

/-- Selections of maximum likelihood topologies are the library's. -/
theorem isMLSelection_iff (ml : (QuartetTree X → ℝ) → Finset X → QuartetTree X) :
    IsMLSelection ml ↔ Phylogenetics.IsMLSelection ml := Iff.rfl

/-- Independent samples are the library's. -/
theorem iidProb_eq {Γ : Type*} [Fintype Γ] (dist : Γ → ℝ) (n : ℕ) (Ev : (Fin n → Γ) → Prop) :
    iidProb dist n Ev = Phylogenetics.iidProb dist n Ev := rfl

omit [Fintype X] in
/-- Counts of quartet trees are the library's. -/
theorem quartetCount_eq {Γ : Type*} [Fintype Γ] {n : ℕ} (sides : Γ → Finset (Finset X))
    (ω : Fin n → Γ) : quartetCount sides ω = Phylogenetics.quartetCount sides ω := rfl

/-- **TOB-QMC**, the contraction of the Challenge, is the library's. -/
theorem tobqmc_eq (ml : (QuartetTree X → ℝ) → Finset X → QuartetTree X) (α β : ℝ)
    (c : QuartetTree X → ℝ) (B : Finset (Finset X)) (Q : Finset X → Finset (Finset X)) :
    tobqmc ml α β c B Q = TreeOfBlobs.tobqmc ml α β c B Q := rfl

end Trees

end TobQmc.Model
