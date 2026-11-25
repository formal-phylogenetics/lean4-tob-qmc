module

public import Allman2023.LargeNetworks.Rule

/-!
# Allman, Baños, Mitchell, Rhodes 2023: the quartet trees of the tree of blobs

A quartet tree displayed on the tree of blobs is a cut-edge split of the network induced on its four
taxa. TOB-QMC uses it to pass from T-quartet-nonanomaly, on the quartet trees of the tree of blobs,
to the inequality that the T3 option needs (`TobQmc.FalsePositives.ConsistencyT3`).

The result is stated in the source's terms, those of lean4-allman2023 and of the libraries, and proved
from the theorem of lean4-allman2023 named in its docstring.
-/

@[expose] public noncomputable section

open Phylogenetics Phylogenetics.RootedNetwork
open scoped Classical

namespace External.Allman2023

variable {V E X : Type*} [Fintype X] [DecidableEq X] {N : RootedNetwork V E X}

/-- A quartet tree displayed on the tree of blobs is a cut-edge split of its induced network.
lean4-allman2023 proves it as `Allman2023.inducedCutSplit_of_displays`. -/
theorem inducedCutSplit_of_displays (hN : N.IsPhylogenetic) {s : QuartetTree X}
    (h : Displays (treeOfBlobs N) s) : InducedCutSplit N s :=
  _root_.Allman2023.inducedCutSplit_of_displays hN h

end External.Allman2023
