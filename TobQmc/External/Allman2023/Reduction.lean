module

public import Allman2023.LargeNetworks.Reduction

/-!
# Allman, Baños, Mitchell, Rhodes 2023: the reduction of part (b) of Theorem 1

The proof of part (b) of Theorem 1 of Allman et al. 2023 (the PMC text, lines 145-149) reduces a set
of four taxa with a 4-blob on a binary network: below a lowest reticulation the network is a tree,
in which an arc separating two taxa from the other two is a `2|2` cut. TOB-QMC's Lemma 1, which it
takes from Ané et al. 2024, uses these steps for its direction from "displays one quartet tree" to
"no 4-blob" (`TobQmc.lemma1`), and the language of domination off a set of deleted arcs with them.

Each result is stated in the source's terms, those of lean4-allman2023 and of the libraries, and
proved from the theorem of lean4-allman2023 named in its docstring.
-/

@[expose] public noncomputable section

open Phylogenetics Phylogenetics.RootedNetwork
open Allman2023 (taxaBelowOff HasUniqueParentsBelow StarOff)
open scoped Classical

namespace External.Allman2023

variable {V E X : Type*} {N : RootedNetwork V E X} {D : Set E}

/-- The taxa of `q` below `w` off `D` are those that `w` reaches off `D`. lean4-allman2023 proves it
as `Allman2023.mem_taxaBelowOff`. -/
theorem mem_taxaBelowOff {q : Finset X} {w : V} {x : X} :
    x ∈ taxaBelowOff N D q w ↔ x ∈ q ∧ N.ReachesOff D w (N.leaf x) :=
  _root_.Allman2023.mem_taxaBelowOff

/-- Off `D`, an arc into the tree below `v` dominates the taxa of `q` below it: going up from such a
taxon, each vertex has only one parent. lean4-allman2023 proves it as
`Allman2023.dominatesOff_of_uniqueParents`. -/
theorem dominatesOff_of_uniqueParents (hN : N.IsPhylogenetic) {q : Finset X} {v : V}
    (hT : HasUniqueParentsBelow N D q v) {e : E} (he : e ∉ D)
    (hv : N.ReachesOff D v (N.graph.source e)) {x : X} (hx : x ∈ q)
    (hr : N.ReachesOff D (N.graph.target e) (N.leaf x)) : N.DominatesOff D e x :=
  _root_.Allman2023.dominatesOff_of_uniqueParents hN hT he hv hx hr

variable [Fintype X] [DecidableEq X]

/-- **A tree with two taxa has a `2|2` arc**, what the source's "since `𝒩−` has no 3-blobs, this
tree can only have one leaf" (the PMC text, line 148) uses: with one parent at each vertex
ancestral to `q` below `v`, and two taxa of `q` or more below `v`, either `q` is treelike off `D` or
some vertex is a multifurcation towards the four taxa. lean4-allman2023 proves it as
`Allman2023.isTreelikeOff_or_starOff`. -/
theorem isTreelikeOff_or_starOff (hN : N.IsPhylogenetic) (hD : N.IsDeletion D) {q : Finset X}
    (hq : q.card = 4) {v : V} (hT : HasUniqueParentsBelow N D q v)
    (h2 : 2 ≤ (taxaBelowOff N D q v).card)
    (hv : (taxaBelowOff N D q v).card = 2 →
      ∀ f g, N.graph.source f = v → N.graph.source g = v → f = g) :
    N.IsTreelikeOff D q ∨ ∃ w, StarOff N D q w :=
  _root_.Allman2023.isTreelikeOff_or_starOff hN hD hq hT h2 hv

/-- With no arc deleted, treelikeness off `D` is `IsTreelike`. lean4-allman2023 proves it as
`Allman2023.isTreelikeOff_empty_iff`. -/
theorem isTreelikeOff_empty_iff (hN : N.IsPhylogenetic) {q : Finset X} :
    N.IsTreelikeOff ∅ q ↔ IsTreelike N q :=
  _root_.Allman2023.isTreelikeOff_empty_iff hN

/-- **The graph side of part (b) of Theorem 1** (the PMC text, lines 145-149). For a binary network
and a set `q` of four taxa that is not treelike, there are a deletion `D` of hybrid arcs and a
reticulation with exactly two parents `k₁`, `k₂` off `D` and exactly one taxon `a` of `q` below it,
such that deleting `k₂` gives a cut arc `e₁` of a quartet tree `s₁` on `q`, deleting `k₁` gives a
cut arc `e₂` of a quartet tree `s₂` on `q`, and `s₁ ≠ s₂`. lean4-allman2023 proves it as
`Allman2023.exists_reduction`. -/
theorem exists_reduction (hN : N.IsPhylogenetic) (hBin : N.IsBinary) {q : Finset X} (hq : q.card = 4)
    (hnt : ¬ IsTreelike N q) :
    ∃ (D : Set E) (k₁ k₂ : E) (a : X) (s₁ s₂ : QuartetTree X) (e₁ e₂ : E),
      N.IsDeletion D ∧ k₁ ≠ k₂ ∧ N.graph.target k₁ = N.graph.target k₂ ∧ k₁ ∉ D ∧ k₂ ∉ D ∧
      (∀ f, N.graph.target f = N.graph.target k₁ → f ∉ D → f = k₁ ∨ f = k₂) ∧
      a ∈ q ∧ N.ReachesOff D (N.graph.target k₁) (N.leaf a) ∧
      (∀ x ∈ q, x ≠ a → ¬ N.ReachesOff D (N.graph.target k₁) (N.leaf x)) ∧
      s₁ ∈ treesOn q ∧ s₂ ∈ treesOn q ∧ s₁ ≠ s₂ ∧
      N.SplitOffAt (insert k₂ D) e₁ s₁ ∧ N.SplitOffAt (insert k₁ D) e₂ s₂ :=
  _root_.Allman2023.exists_reduction hN hBin hq hnt

end External.Allman2023
