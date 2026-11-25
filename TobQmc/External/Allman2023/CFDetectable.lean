module

public import Allman2023.FourTaxa.CFDetectable

/-!
# Allman, Baños, Mitchell, Rhodes 2023: `CF`-detectability

Corollary 1 of Allman et al. 2023, in the form of `CF`-detectability: for generic parameters on a
binary network, every induced 4-taxon network with a 4-blob has a non-cut concordance factor, and
every one with a cut-edge split has a concordance factor strictly cut at that split. TOB-QMC uses it
for the level-2 network of its supplement (`TobQmc.LevelTwo`), where at `ρ = 0` the generic
parameters meet assumption 6a.

The result is stated in the source's terms, those of lean4-allman2023 and of the libraries, and proved
from the theorem of lean4-allman2023 named in its docstring.
-/

@[expose] public noncomputable section

open Phylogenetics Phylogenetics.RootedNetwork
open Allman2023 (CFDetectable)
open scoped Classical

namespace External.Allman2023

variable {V E X : Type*} [Fintype V] [Fintype E] [Fintype X] [DecidableEq X] {N : RootedNetwork V E X}

/-- **Corollary 1, as `CF`-detectability** (`allman2023:a:cor:largeCFdetect`): for a rooted binary
phylogenetic network, the numerical parameters at which the network multispecies coalescent with
independent inheritance fails `CF`-detectability on some induced 4-taxon network form a null set.
lean4-allman2023 proves it as `Allman2023.cfDetectable_generic`, from the step of the proof of
Corollary 1 on one 4-taxon network. -/
theorem cfDetectable_generic (hN : N.IsPhylogenetic) (hBin : N.IsBinary) :
    N.IsGenericNull {θ | N.IsMetric θ ∧ ¬ CFDetectable N (nmscCF N θ 0)} :=
  _root_.Allman2023.cfDetectable_generic hN hBin

end External.Allman2023
