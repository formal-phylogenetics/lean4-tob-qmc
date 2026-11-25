module

public import Mathlib.Analysis.Normed.Algebra.MatrixExponential
public import Mathlib.Analysis.SpecialFunctions.Log.Basic
public import Mathlib.Analysis.SpecialFunctions.Sqrt
public import Mathlib.Analysis.SpecialFunctions.Trigonometric.Arctan
public import Mathlib.Combinatorics.Graph.Connected.EdgeCut
public import Mathlib.Data.Fintype.Powerset
public import Mathlib.Data.Set.Card
public import Mathlib.MeasureTheory.Constructions.Pi
public import Mathlib.MeasureTheory.Measure.Lebesgue.Basic
public import Mathlib.MeasureTheory.Measure.Prod
public import Mathlib.Probability.Distributions.Gaussian.Real
public import Mathlib.Topology.Instances.Matrix

/-! # The definitions of the Challenge

The definitions that the Challenge states its theorems with, between the markers of
`scripts/sync_challenge_defs.py`, which copies them word for word into the Challenge,
`palomar/TobQmc/Challenge.lean` (formalize-math-paper, `references/palomar.md`, Section 2).

This module imports exactly what the Challenge imports: Lean, Mathlib, and nothing from this
repository or from any other repository of the collection. The definitions are those of the paper,
written in Mathlib's vocabulary. They follow the definitions of `Phylogenetics`, `PhyloNetwork`,
`TreeOfBlobs` and `Allman2023` that the library uses, so that `TobQmc.Bridge.Model` proves that the
two agree. -/

-- BEGIN SHARED DEFINITIONS

/-! ## Networks

A rooted network is a directed multigraph with named arcs (two arcs may join the same two vertices),
a root and a labelling of the taxa by vertices. Its numerical parameters are a length for every arc,
in coalescent units, and an inheritance probability for every arc. -/

@[expose] public noncomputable section

open Finset MeasureTheory ProbabilityTheory
open scoped Classical

namespace TobQmc.Model

/-- A directed multigraph: each arc `e` goes from `source e` to `target e`. -/
structure Digraph (V E : Type*) where
  source : E → V
  target : E → V

namespace Digraph

variable {V E : Type*} (G : Digraph V E)

/-- An arc leads from `u` to `v`. -/
def Adj (u v : V) : Prop := ∃ e, G.source e = u ∧ G.target e = v

/-- A directed path, possibly empty, leads from `u` to `v`. -/
def Reaches : V → V → Prop := Relation.ReflTransGen G.Adj

/-- No nonempty directed path from a vertex to itself. -/
def IsAcyclic : Prop := ∀ v, ¬ Relation.TransGen G.Adj v v

/-- The number of arcs entering `v`. -/
def indegree (v : V) : ℕ := {e | G.target e = v}.ncard

/-- The number of arcs leaving `v`. -/
def outdegree (v : V) : ℕ := {e | G.source e = v}.ncard

/-- The arc `e` crosses the bipartition `S | Sᶜ` of the vertices, in either direction. -/
def Crosses (e : E) (S : Set V) : Prop :=
  (G.source e ∈ S ∧ G.target e ∉ S) ∨ (G.target e ∈ S ∧ G.source e ∉ S)

/-- An arc of `F` joins `u` and `v`, in either direction. -/
def AdjOn (F : Set E) (u v : V) : Prop :=
  ∃ e ∈ F, (G.source e = u ∧ G.target e = v) ∨ (G.source e = v ∧ G.target e = u)

/-- An undirected walk, possibly empty, along arcs of `F` joins `u` and `v`. -/
def Walks (F : Set E) : V → V → Prop := Relation.ReflTransGen (G.AdjOn F)

/-- The undirected multigraph, Mathlib's `Graph`, with the same vertices and the same named arcs. -/
def underlying : Graph V E where
  vertexSet := Set.univ
  edgeSet := Set.univ
  IsLink e u v := (G.source e = u ∧ G.target e = v) ∨ (G.source e = v ∧ G.target e = u)
  isLink_symm := by
    intro e _
    constructor
    intro u v h
    exact h.symm
  eq_or_eq_of_isLink_of_isLink := by
    intro e u v x y h h'
    rcases h with h | h <;> rcases h' with h' | h'
    · exact Or.inl (h.1.symm.trans h'.1)
    · exact Or.inr (h.1.symm.trans h'.1)
    · exact Or.inr (h.2.symm.trans h'.2)
    · exact Or.inl (h.2.symm.trans h'.2)
  edge_mem_iff_exists_isLink := by
    intro e
    exact ⟨fun _ => ⟨G.source e, G.target e, Or.inl ⟨rfl, rfl⟩⟩, fun _ => Set.mem_univ e⟩
  left_mem_of_isLink := by intro e u v _; exact Set.mem_univ u

/-- Two vertices are in the same *blob*: an undirected walk that uses no cut edge (no bridge of
the undirected multigraph) joins them. The blobs are the connected components that remain when
the cut edges are deleted. -/
def blobSetoid : Setoid V where
  r := G.Walks {e | ¬ G.underlying.IsBridge e}
  iseqv := ⟨fun _ => .refl, fun h => by
    induction h with
    | refl => exact .refl
    | tail _ hab ih =>
      obtain ⟨e, he, h⟩ := hab
      exact Relation.ReflTransGen.head ⟨e, he, h.symm⟩ ih, fun h h' => h.trans h'⟩

end Digraph

/-- A rooted network on the taxa `X`: a directed multigraph, its root, and the vertex of each
taxon. -/
structure Network (V E X : Type*) where
  graph : Digraph V E
  root : V
  leaf : X → V

/-- The numerical parameters of a network: arc lengths, in coalescent units, and inheritance
probabilities. -/
structure Params (E : Type*) where
  length : E → ℝ
  inheritance : E → ℝ

namespace Network

variable {V E X : Type*} (N : Network V E X)

/-- A *rooted phylogenetic network*: a finite directed acyclic graph in which the root, of
in-degree zero, reaches every vertex; the vertices of out-degree zero are exactly the vertices of
the taxa, bijectively, each of in-degree one. -/
structure IsPhylogenetic : Prop where
  finite_vertices : Finite V
  finite_arcs : Finite E
  finite_taxa : Finite X
  acyclic : N.graph.IsAcyclic
  root_reaches : ∀ v, N.graph.Reaches N.root v
  root_indegree : N.graph.indegree N.root = 0
  nonroot_indegree : ∀ v, v ≠ N.root → 1 ≤ N.graph.indegree v
  leaf_injective : Function.Injective N.leaf
  leaf_indegree : ∀ x, N.graph.indegree (N.leaf x) = 1
  leaves : ∀ v, N.graph.outdegree v = 0 ↔ ∃ x, N.leaf x = v

/-- A *tree arc* enters a vertex with one entering arc. -/
def IsTreeArc (e : E) : Prop := N.graph.indegree (N.graph.target e) = 1

/-- A *hybrid arc* enters a vertex with at least two entering arcs. -/
def IsHybridArc (e : E) : Prop := 2 ≤ N.graph.indegree (N.graph.target e)

/-- The network is *binary*: the root has out-degree two, and every other vertex that is not a leaf
has in-degree and out-degree summing to three. -/
def IsBinary : Prop :=
  N.graph.outdegree N.root = 2 ∧
    ∀ v, v ≠ N.root → N.graph.outdegree v ≠ 0 →
      N.graph.indegree v + N.graph.outdegree v = 3

/-- *Valid numerical parameters*: tree arcs have positive length and inheritance probability one,
hybrid arcs non-negative length and positive inheritance probability, and the inheritance
probabilities of the arcs entering a vertex with several entering arcs sum to one. -/
def IsMetric [Fintype E] (m : Params E) : Prop :=
  (∀ e, N.IsTreeArc e → 0 < m.length e) ∧
  (∀ e, N.IsHybridArc e → 0 ≤ m.length e) ∧
  (∀ e, N.IsTreeArc e → m.inheritance e = 1) ∧
  (∀ e, N.IsHybridArc e → 0 < m.inheritance e) ∧
  ∀ v, 2 ≤ N.graph.indegree v →
    ∑ e, (if N.graph.target e = v then m.inheritance e else 0) = 1

/-- `A` is the set of taxa on one side of a cut edge: some arc is the only arc crossing a bipartition
`S | Sᶜ` of the vertices, and the taxa in `S` are `A`. -/
def HasCutSplit (A : Set X) : Prop :=
  ∃ (e : E) (S : Set V), (∀ f, N.graph.Crosses f S ↔ f = e) ∧ N.leaf ⁻¹' S = A

/-- The vertices ancestral to a taxon of `Y`. -/
def ancestralVertices (Y : Set X) : Set V :=
  {v | ∃ x ∈ Y, N.graph.Reaches v (N.leaf x)}

/-- The arcs ancestral to a taxon of `Y`: with the vertices above them, the subgraph induced on
`Y`. -/
def ancestralArcs (Y : Set X) : Set E :=
  {e | N.graph.target e ∈ N.ancestralVertices Y}

/-- `A ∩ Y | Y \ A` is a cut-edge split of the network induced on the taxa `Y`: some arc of the
induced subgraph is the only arc of that subgraph crossing a set of vertices that meets `Y` exactly
in `A`. -/
def HasCutSplitOn (Y A : Set X) : Prop :=
  ∃ e ∈ N.ancestralArcs Y, ∃ S : Set V,
    (∀ f ∈ N.ancestralArcs Y, N.graph.Crosses f S ↔ f = e) ∧ ∀ x ∈ Y, N.leaf x ∈ S ↔ x ∈ A

/-- The network is *level-1*: every blob has at most one more hybrid arc than vertices with
several entering arcs; on a binary network, the blobs are cycles that share no arc. -/
def IsLevelOne [Fintype V] [Fintype E] : Prop :=
  ∀ v : V,
    ((univ.filter fun e => N.IsHybridArc e ∧ N.graph.blobSetoid v (N.graph.source e) ∧
        N.graph.blobSetoid v (N.graph.target e)).card : ℤ) -
      ((univ.filter fun u => 2 ≤ N.graph.indegree u ∧ N.graph.blobSetoid v u).card : ℤ) ≤ 1

end Network

/-! ## Trees and quartet trees

A rooted tree on a set is given by its clusters, and an unrooted tree on the taxa by the sides of its
splits. A resolved quartet tree `ab|cd` is the pair of its cherries. -/

section Trees

variable {X : Type*} [Fintype X] [DecidableEq X]

/-- A *hierarchy* on `X`, a rooted tree given by its clusters: it contains `X` and every singleton,
its clusters are nonempty, and any two of them are nested or disjoint. -/
def IsHierarchy (H : Finset (Finset X)) : Prop :=
  univ ∈ H ∧ (∀ x : X, {x} ∈ H) ∧ (∀ A ∈ H, A.Nonempty) ∧
    ∀ A ∈ H, ∀ B ∈ H, A ⊆ B ∨ B ⊆ A ∨ Disjoint A B

/-- The children of the cluster `A` in the family `H`: the maximal members of `H` strictly
contained in `A`. -/
def childClusters (H : Finset (Finset X)) (A : Finset X) : Finset (Finset X) :=
  H.filter fun B => B ⊂ A ∧ ∀ C ∈ H, B ⊂ C → ¬ C ⊂ A

/-- The unrooted tree of a rooted tree `G`, given by its clusters: the sides of the splits of its
non-root clusters. -/
def unroot {L : Type*} [Fintype L] [DecidableEq L] (G : Finset (Finset L)) : Finset (Finset L) :=
  G.erase univ ∪ (G.erase univ).image compl

/-- An *unrooted tree* on `X`, given by the sides of its splits: those of a hierarchy. -/
def IsUnrootedTree (T : Finset (Finset X)) : Prop :=
  ∃ H : Finset (Finset X), IsHierarchy H ∧ unroot H = T

/-- A *binary* unrooted tree: it has a rooting in which every cluster with at least two taxa has
exactly two children. -/
def IsBinaryTree (T : Finset (Finset X)) : Prop :=
  ∃ H : Finset (Finset X), IsHierarchy H ∧ unroot H = T ∧
    ∀ A ∈ H, 2 ≤ A.card → (childClusters H A).card = 2

/-- A resolved quartet tree `ab|cd`: the pair of its two disjoint cherries `{a, b}`, `{c, d}`. -/
def IsQuartetTree (s : Finset (Finset X)) : Prop :=
  s.card = 2 ∧ (∀ B ∈ s, B.card = 2) ∧ ∀ B ∈ s, ∀ C ∈ s, B ≠ C → Disjoint B C

/-- The resolved quartet trees on `X`. -/
abbrev QuartetTree (X : Type*) [DecidableEq X] := {s : Finset (Finset X) // IsQuartetTree s}

instance : Fintype (QuartetTree X) := Fintype.ofFinite _

omit [Fintype X] in
/-- The four taxa of a quartet tree. -/
def QuartetTree.taxa (s : QuartetTree X) : Finset X := s.val.sup id

/-- The two quartet trees on the taxa of `s` other than `s`. -/
def QuartetTree.alternatives (s : QuartetTree X) : Finset (QuartetTree X) :=
  univ.filter fun r => r.taxa = s.taxa ∧ r ≠ s

/-- The three quartet trees on the four taxa `q`. -/
def treesOn (q : Finset X) : Finset (QuartetTree X) := univ.filter fun r => r.taxa = q

/-- The tree `T`, given by the sides of its splits, *displays* the quartet tree `s`: some split
restricts to `s` on its four taxa. -/
def Displays (T : Finset (Finset X)) (s : QuartetTree X) : Prop := ∃ A ∈ T, A ∩ s.taxa ∈ s.val

/-- The *quartet score* of `T` for the weights `w`: the sum of the weights of the quartet trees
that `T` displays. -/
def quartetSupport (w : QuartetTree X → ℝ) (T : Finset (Finset X)) : ℝ :=
  ∑ s, if Displays T s then w s else 0

/-- The tree obtained from `T` by contracting the edges with a side in `C`. -/
def contractSides (T C : Finset (Finset X)) : Finset (Finset X) := T.filter fun A => A ∉ C ∧ Aᶜ ∉ C

/-- The sides of the internal edges of `T`: both sides have at least two taxa. -/
def internalSides (T : Finset (Finset X)) : Finset (Finset X) :=
  T.filter fun A => 2 ≤ A.card ∧ 2 ≤ Aᶜ.card

/-- The quartet trees around the edge with side `A`: the sets of four taxa with two on each side,
each with the quartet tree that the edge induces on them. -/
def bipartitionQuartets (A : Finset X) : Finset (QuartetTree X) :=
  univ.filter fun s => A ∩ s.taxa ∈ s.val

/-- The quartet trees around the edge with side `A` of `T` that draw their taxa from distinct blocks
of the multipartition of `T` at that edge: two taxa on one side are in one block exactly when a split
of `T` properly inside that side contains both. On a binary `T` these are the four-taxon subsets
around the edge that draw one taxon from each block of its quadripartition. -/
def multipartitionQuartets (T : Finset (Finset X)) (A : Finset X) : Finset (QuartetTree X) :=
  (bipartitionQuartets A).filter fun s =>
    (¬ ∃ C ∈ T, C ⊂ A ∧ A ∩ s.taxa ⊆ C) ∧ (¬ ∃ C ∈ T, C ⊂ Aᶜ ∧ Aᶜ ∩ s.taxa ⊆ C)

/-- An optimal solution of *Weighted Quartet Consensus* for the weights `c`: a binary tree of largest
quartet score. -/
def IsWQCOptimal (c : QuartetTree X → ℝ) (B : Finset (Finset X)) : Prop :=
  IsBinaryTree B ∧ ∀ T, IsBinaryTree T → quartetSupport c T ≤ quartetSupport c B

end Trees

namespace Network

variable {V E X : Type*} [Fintype X] [DecidableEq X] (N : Network V E X)

/-- The *tree of blobs* of the network, given by the sides of its splits: the nonempty proper sets of
taxa on one side of a cut edge. -/
def treeOfBlobs : Finset (Finset X) :=
  univ.filter fun A => A.Nonempty ∧ Aᶜ.Nonempty ∧ N.HasCutSplit (A : Set X)

/-- The quartet tree `s` is a cut-edge split of the network induced on its four taxa. -/
def InducedCutSplit (s : QuartetTree X) : Prop :=
  ∃ B ∈ s.val, N.HasCutSplitOn (s.taxa : Set X) (B : Set X)

/-- The network induced on the taxa `q` is *treelike*: it has a cut edge with two taxa of `q` on each
side, so no 4-blob. -/
def IsTreelike (q : Finset X) : Prop :=
  ∃ s ∈ treesOn q, N.InducedCutSplit s

end Network

/-! ## The network multispecies coalescent

A forest of gene lineages on the leaves `L` is the set of its clusters, and its roots are its maximal
clusters. Along an arc of length `t` the lineages coalesce by Kingman's coalescent, each pair of
roots merging at rate `1`; above the root, for an infinite time. At a vertex with several entering
arcs, the lineages choose their parents by a Pólya urn with inheritance correlation `ρ`: `ρ = 0` is
independent inheritance, `ρ = 1` common inheritance. -/

section Coalescent

variable {L : Type*} [Fintype L] [DecidableEq L]

/-- The roots of a forest: its maximal clusters. -/
def roots (F : Finset (Finset L)) : Finset (Finset L) := F.filter fun A => ∀ B ∈ F, A ⊆ B → B = A

/-- The generator of Kingman's coalescent on forests: each pair of distinct roots `A, B` merges at
rate `1`, adding the cluster `A ∪ B`. -/
def kingmanGenerator : Matrix (Finset (Finset L)) (Finset (Finset L)) ℝ :=
  fun F G =>
    if G = F then -((#(roots F)).choose 2 : ℝ)
    else if ∃ A ∈ roots F, ∃ B ∈ roots F, A ≠ B ∧ G = insert (A ∪ B) F then 1 else 0

/-- Kingman's coalescent over a time `t`: `exp (t • Q)`. -/
def kingmanTransition (t : ℝ) : Matrix (Finset (Finset L)) (Finset (Finset L)) ℝ :=
  NormedSpace.exp (t • kingmanGenerator)

/-- Kingman's coalescent over an infinite time: the limits as `t → ∞`. -/
def kingmanAbsorption : Matrix (Finset (Finset L)) (Finset (Finset L)) ℝ :=
  fun F G => Filter.limUnder Filter.atTop fun t : ℝ => kingmanTransition t F G

/-- The part of the forest `F` below its roots in `A`. -/
def forestBelow (F A : Finset (Finset L)) : Finset (Finset L) := F.filter fun B => ∃ C ∈ A, B ⊆ C

end Coalescent

/-- The probability that the lineages `R` choose the parents `a` at a vertex with inheritance
probabilities `γ` and inheritance correlation `ρ`: the Pólya urn in which the first lineage draws from
`γ` and the lineage after `i` others takes a given parent with weight
`((1 - ρ) γ_e + ρ n_e) / ((1 - ρ) + ρ i)`, `n_e` being the number of earlier lineages that took it.
It is `∏ γ_{a r}` at `ρ = 0`; at `ρ = 1` it vanishes unless all lineages take one parent `e`, when it
is `γ_e`. -/
def allocationWeight {R P : Type*} [Fintype R] [Fintype P] [DecidableEq P] (ρ : ℝ) (γ : P → ℝ)
    (a : R → P) : ℝ :=
  (1 - ρ) ^ ((univ.image a).card - 1) *
    (∏ e ∈ univ.image a,
      (γ e * ∏ j ∈ Ico 1 (univ.filter fun r => a r = e).card, ((1 - ρ) * γ e + ρ * j))) /
    ∏ i ∈ Ico 1 (Fintype.card R), ((1 - ρ) + ρ * i)

namespace Network

variable {V E X : Type*} [Fintype V] [Fintype E] [Fintype X] [DecidableEq X]
variable (N : Network V E X) (θ : Params E) (ρ : ℝ)

/-- The forest arriving at `v` from below: its taxon's lineage, if any, and the forests at the top of
the arcs leaving `v`. -/
def arrivingForest (top : E → Finset (Finset X)) (v : V) : Finset (Finset X) :=
  ((univ.filter fun x => N.leaf x = v).image fun x => ({x} : Finset X)) ∪
    (univ.filter fun e => N.graph.source e = v).biUnion top

/-- The probability that the roots of the forest `F` arriving at `v` choose the arcs entering `v`
that put the forests `bot e` at their bottoms. -/
def allocationFactor (F : Finset (Finset X)) (v : V) (bot : E → Finset (Finset X)) : ℝ :=
  ∑ a : {A // A ∈ roots F} → {e // N.graph.target e = v},
    if ∀ e : {e // N.graph.target e = v},
        bot e.val = forestBelow F ((univ.filter fun r => a r = e).image Subtype.val) then
      allocationWeight ρ (fun e : {e // N.graph.target e = v} => θ.inheritance e.val) a
    else 0

/-- The probability of a history: the forests `bot e` at the bottom and `top e` at the top of each
arc. -/
def historyWeight (bot top : E → Finset (Finset X)) : ℝ :=
  (∏ v ∈ univ.erase N.root, N.allocationFactor θ ρ (N.arrivingForest top v) v bot) *
    ∏ e, kingmanTransition (θ.length e) (bot e) (top e)

/-- **The network multispecies coalescent** with inheritance correlation `ρ`: the probability of the
rooted gene tree `G` (its clusters), with one lineage per taxon. -/
def geneTreeDist (G : Finset (Finset X)) : ℝ :=
  ∑ bot : E → Finset (Finset X), ∑ top : E → Finset (Finset X),
    N.historyWeight θ ρ bot top * kingmanAbsorption (N.arrivingForest top N.root) G

/-- The *quartet concordance factor* of the quartet tree `s`: the probability that a gene tree
displays `s`. -/
def nmscCF (s : QuartetTree X) : ℝ :=
  ∑ G : Finset (Finset X), if Displays (unroot G) s then N.geneTreeDist θ ρ G else 0

/-- A sequence `G` of *independent gene trees*, each from the network multispecies coalescent, on a
probability space. -/
structure IsGeneTreeSample {Ω : Type*} [MeasurableSpace Ω] (P : Measure Ω)
    (G : ℕ → Ω → Finset (Finset X)) : Prop where
  measurable : ∀ i g, MeasurableSet (G i ⁻¹' {g})
  indep : ∀ (s : Finset ℕ) (g : ℕ → Finset (Finset X)),
    P (⋂ i ∈ s, G i ⁻¹' {g i}) = ∏ i ∈ s, P (G i ⁻¹' {g i})
  law : ∀ i g, P.real (G i ⁻¹' {g}) = N.geneTreeDist θ ρ g

end Network

/-- The number of the first `k` gene trees of the sequence `G` that display the quartet tree `s`. -/
def geneCount {X : Type*} [Fintype X] [DecidableEq X] {Ω : Type*} (G : ℕ → Ω → Finset (Finset X))
    (k : ℕ) (ω : Ω) (s : QuartetTree X) : ℝ :=
  ((Finset.range k).filter fun i => Displays (unroot (G i ω)) s).card

/-! ## Samples of gene trees -/

section Sampling

variable {Γ : Type*} [Fintype Γ]

/-- The probability that `n` independent draws from the distribution `dist` on the finite set `Γ` lie
in the event `Ev`. -/
def iidProb (dist : Γ → ℝ) (n : ℕ) (Ev : (Fin n → Γ) → Prop) : ℝ :=
  ∑ ω : Fin n → Γ, if Ev ω then ∏ i, dist (ω i) else 0

variable {X : Type*} [Fintype X] [DecidableEq X]

/-- The number of the gene trees `ω`, each given by the sides of its splits through `sides`, that
display the quartet tree `s`. -/
def quartetCount {n : ℕ} (sides : Γ → Finset (Finset X)) (ω : Fin n → Γ) (s : QuartetTree X) : ℝ :=
  ((univ.filter fun i => Displays (sides (ω i)) s).card : ℝ)

end Sampling

/-! ## TINNiK's hypothesis tests

The tests on the counts `c` of the three quartet trees on a set of four taxa (Allman, Baños,
Mitchell, Rhodes 2024, "Statistical testing and estimation for cut CFs", and its Appendix C). -/

section Tests

variable {X : Type*} [Fintype X] [DecidableEq X]

/-- The likelihood ratio statistic for the cut-model line of the quartet tree `s`: twice the
difference of the maximal trinomial log-likelihoods, unconstrained and on the line `p_{s'} = p_{s''}`,
where `s'`, `s''` are the alternatives of `s`. `x log x` vanishes at `x = 0`. -/
def lineStat (c : QuartetTree X → ℝ) (s : QuartetTree X) : ℝ :=
  2 * (∑ r ∈ s.alternatives, c r * Real.log (c r) -
    (∑ r ∈ s.alternatives, c r) * Real.log (∑ r ∈ s.alternatives, c r) +
    (∑ r ∈ s.alternatives, c r) * Real.log 2)

/-- The likelihood ratio statistic of the star test on the taxa `q`: twice the difference of the
maximal trinomial log-likelihoods, unconstrained and at `(1/3, 1/3, 1/3)`. -/
def starStat (c : QuartetTree X → ℝ) (q : Finset X) : ℝ :=
  2 * (∑ r ∈ treesOn q, c r * Real.log (c r) -
    (∑ r ∈ treesOn q, c r) * Real.log ((∑ r ∈ treesOn q, c r) / 3))

/-- The upper tail at `t` of the `χ²` distribution with 2 degrees of freedom. -/
def chiSqTwoTail (t : ℝ) : ℝ := Real.exp (-t / 2)

/-- The p-value of the star test on the taxa `q`, by the likelihood ratio, against the `χ²₂`
distribution. -/
def starPValue (c : QuartetTree X → ℝ) (q : Finset X) : ℝ := chiSqTwoTail (starStat c q)

/-- The cut-model likelihood ratio statistic on the taxa `q`: the least of the statistics of its three
lines. -/
def cutStat (c : QuartetTree X → ℝ) (q : Finset X) : ℝ := ⨅ s : {s // s ∈ treesOn q}, lineStat c s.val

/-- The parameter `μ₀` of the test distribution, `√(2n) (1 - φ) / √(φ (3 - 2φ))`, for the point
`(1 - 2φ/3, φ/3, φ/3)` and the sample size `n`. -/
def muZero (φ n : ℝ) : ℝ := Real.sqrt (2 * n) * (1 - φ) / Real.sqrt (φ * (3 - 2 * φ))

/-- The angle `α₀` of TINNiK's Appendix C.2. -/
def alphaZero (φ : ℝ) : ℝ := Real.arctan (1 / Real.sqrt (3 * (3 - 2 * φ)))

/-- The upper tail at `t` of the test distribution of the cut test, for `φ` and the sample size `n`:
that of `min(Z², (sin α₀ Z + cos α₀ Z̄)², (sin α₀ Z - cos α₀ Z̄)²)` for independent `Z ~ N(0, 1)` and
`Z̄ ~ N(μ₀, 1)`. -/
def cutTail (φ n t : ℝ) : ℝ :=
  ((gaussianReal 0 1).prod (gaussianReal (muZero φ n) 1)).real
    {z | t < min (z.1 ^ 2) (min ((Real.sin (alphaZero φ) * z.1 + Real.cos (alphaZero φ) * z.2) ^ 2)
      ((Real.sin (alphaZero φ) * z.1 - Real.cos (alphaZero φ) * z.2) ^ 2))}

/-- The p-value of the cut test, with `φ` estimated on the cut-model line of the quartet tree `s`. -/
def cutPValue (c : QuartetTree X → ℝ) (s : QuartetTree X) : ℝ :=
  cutTail (3 * (∑ r ∈ s.alternatives, c r) / (2 * (c s + ∑ r ∈ s.alternatives, c r)))
    (c s + ∑ r ∈ s.alternatives, c r) (cutStat c s.taxa)

/-- A selection of maximum likelihood topologies: on each set of four taxa, a quartet tree whose cut
line has the least statistic. -/
def IsMLSelection (ml : (QuartetTree X → ℝ) → Finset X → QuartetTree X) : Prop :=
  ∀ c q, q.card = 4 → ml c q ∈ treesOn q ∧ ∀ r ∈ treesOn q, lineStat c (ml c q) ≤ lineStat c r

/-- The sets of four taxa that TINNiK's hypothesis tests judge non-treelike (Step 2 of its B-quartet
Inference Algorithm): those on which the star test does not reject at level `β`, or the cut test
rejects at level `α`, with the maximum likelihood topologies `ml`. -/
def testedB (ml : (QuartetTree X → ℝ) → Finset X → QuartetTree X) (α β : ℝ)
    (c : QuartetTree X → ℝ) : Set (Finset X) :=
  {q | q.card = 4 ∧ (β ≤ starPValue c q ∨ cutPValue c (ml c q) < α)}

/-- The concordance factors on the taxa `q` are *non-cut* (Allman et al. 2023, Definition 15): the
three quartet trees on `q` have distinct concordance factors. -/
def IsNonCut (p : QuartetTree X → ℝ) (q : Finset X) : Prop :=
  ∀ r ∈ treesOn q, ∀ r' ∈ treesOn q, r ≠ r' → p r ≠ p r'

end Tests

/-! ## TOB-QMC -/

section TobQmc

variable {X : Type*} [Fintype X] [DecidableEq X]

namespace Network

variable {V E : Type*} (N : Network V E X)

/-- The *standard assumptions* of TOB-QMC (conditions 1–3): a rooted binary phylogenetic network,
valid numerical parameters, and the inheritance correlation in `[0, 1]`. -/
structure StandardAssumptions [Fintype E] (θ : Params E) (ρ : ℝ) : Prop where
  phylogenetic : N.IsPhylogenetic
  binary : N.IsBinary
  metric : N.IsMetric θ
  rho : 0 ≤ ρ ∧ ρ ≤ 1

/-- *T-quartet-nonanomalous* (Definition 1): on every set of four taxa that the tree of blobs
resolves, the quartet tree it displays has a larger concordance factor than the other two. -/
def IsTQuartetNonanomalous (F : QuartetTree X → ℝ) : Prop :=
  ∀ s, Displays N.treeOfBlobs s → ∀ r ∈ s.alternatives, F r < F s

end Network

/-- **Definition 2.** A *disjoint cover* around the edge with side `A` of the tree `T`: four-taxon
subsets, each drawing one taxon from each block of the quadripartition induced by the edge (of the
multipartition, when `T` is not binary), whose union is all the taxa. -/
structure IsDisjointCover (T : Finset (Finset X)) (A : Finset X) (Q : Finset (Finset X)) : Prop where
  around : ∀ Y ∈ Q, ∃ s ∈ multipartitionQuartets T A, s.taxa = Y
  cover : ∀ x : X, ∃ Y ∈ Q, x ∈ Y

/-- **TOB-QMC**, the method's second step: from the tree `B`, contract the internal edges around
which TINNiK's hypothesis tests, on the quartet counts `c` and with levels `α`, `β`, judge a set of
four taxa of the disjoint cover `Q` non-treelike. -/
def tobqmc (ml : (QuartetTree X → ℝ) → Finset X → QuartetTree X) (α β : ℝ) (c : QuartetTree X → ℝ)
    (B : Finset (Finset X)) (Q : Finset X → Finset (Finset X)) : Finset (Finset X) :=
  contractSides B ((internalSides B).filter fun A => ∃ Y ∈ Q A, Y ∈ testedB ml α β c)

end TobQmc

end TobQmc.Model

end

-- END SHARED DEFINITIONS
