# Allman, Baños, Mitchell, Rhodes 2023

Source: E. S. Allman, H. Baños, J. D. Mitchell, J. A. Rhodes, *The tree of blobs of a species network:
identifiability under the coalescent*, J. Math. Biol. 86 (2023), 10,
<https://doi.org/10.1007/s00285-022-01838-9>. Read: the PMC author manuscript NIHMS1884071 and the arXiv
TeX (2205.03466). It is a paper of the hub lean4-phylo-tree-of-blobs, formalized in its own repository,
[lean4-allman2023](https://github.com/formal-phylogenetics/lean4-allman2023), which this repository requires; its
[report](https://github.com/formal-phylogenetics/lean4-allman2023/blob/main/docs/Allman2023/REPORT.md) is the audit
of the source.

TOB-QMC uses it through TINNiK's hypothesis tests, whose correctness rests on its `CF`-detectability,
and in three places of its own: the reduction of a set of four taxa with a 4-blob, in the proof of
Lemma 1 that the paper takes from Ané et al. 2024; the quartet trees of the tree of blobs, for the T3
option; and the `CF`-detectability for generic parameters, for the level-2 network of the supplement
at `ρ = 0`.

Each result that the proofs here use is stated in this directory, in the namespace
`External.Allman2023`, in the source's terms (the definitions of lean4-allman2023 and of the
libraries), and proved from the theorem of lean4-allman2023 named below; the paper's library uses
these statements. The results with a row in lean4-allman2023's routes file carry its label, prefixed
by `allman2023:`, and have the same row, with `proved = 0`, in [`docs/TobQmc/paper_routes.tsv`](../../../docs/TobQmc/paper_routes.tsv).

| Statement | Label | Where the paper uses it | Proved from |
| --- | --- | --- | --- |
| [`External.Allman2023.cfDetectable_generic`](CFDetectable.lean#L33): for generic parameters on a binary network, every induced 4-taxon network is `CF`-detectable | `allman2023:a:cor:largeCFdetect` (Corollary 1) | The level-2 network of the supplement at `ρ = 0` ([`TobQmc.LevelTwo.forGenericParams_tendsto_tobqmc_eq_treeOfBlobs`](../../Supplement/LevelTwo.lean#L664), E25) | [`Allman2023.cfDetectable_generic`](https://github.com/formal-phylogenetics/lean4-allman2023/blob/46efa61d0988df12649089689ae77bc100be034f/Allman2023/FourTaxa/CFDetectable.lean#L24) |
| [`External.Allman2023.exists_reduction`](Reduction.lean#L70): on a binary network, a set of four taxa that is not treelike has a reticulation with one of its taxa below, whose two parents give incompatible cut splits | none: the graph side of part (b) of the proof of Theorem 1 | Lemma 1, from "displays one quartet tree" to "no 4-blob" ([`TobQmc.lemma1`](../../Background/Lemma1.lean#L545)) | [`Allman2023.exists_reduction`](https://github.com/formal-phylogenetics/lean4-allman2023/blob/46efa61d0988df12649089689ae77bc100be034f/Allman2023/LargeNetworks/Reduction.lean#L801) |
| [`External.Allman2023.isTreelikeOff_or_starOff`](Reduction.lean#L50), [`External.Allman2023.dominatesOff_of_uniqueParents`](Reduction.lean#L37), [`External.Allman2023.mem_taxaBelowOff`](Reduction.lean#L30): below a lowest reticulation the network is a tree, in which two taxa give a `2\|2` arc | none: steps of part (b) of the proof of Theorem 1 | Lemma 1, the displayed trees of a network on four taxa | [`Allman2023.isTreelikeOff_or_starOff`](https://github.com/formal-phylogenetics/lean4-allman2023/blob/46efa61d0988df12649089689ae77bc100be034f/Allman2023/LargeNetworks/Reduction.lean#L553), [`Allman2023.dominatesOff_of_uniqueParents`](https://github.com/formal-phylogenetics/lean4-allman2023/blob/46efa61d0988df12649089689ae77bc100be034f/Allman2023/LargeNetworks/Reduction.lean#L503), [`Allman2023.mem_taxaBelowOff`](https://github.com/formal-phylogenetics/lean4-allman2023/blob/46efa61d0988df12649089689ae77bc100be034f/Allman2023/LargeNetworks/Reduction.lean#L492) |
| [`External.Allman2023.isTreelikeOff_empty_iff`](Reduction.lean#L60): with no arc deleted, treelikeness off a deletion is [`IsTreelike`](https://github.com/formal-phylogenetics/lean4-phylogenetics/blob/3fcabfd7d191990dda268b0b3968d945b65eb59a/Phylogenetics/Network/Quartets.lean#L49) | none | Lemma 1 | [`Allman2023.isTreelikeOff_empty_iff`](https://github.com/formal-phylogenetics/lean4-allman2023/blob/46efa61d0988df12649089689ae77bc100be034f/Allman2023/LargeNetworks/Reduction.lean#L631) |
| [`External.Allman2023.inducedCutSplit_of_displays`](Rule.lean#L27): a quartet tree displayed on the tree of blobs is a cut-edge split of its induced network | none | The T3 option: T-quartet-nonanomaly on the cut-edge splits that the tree of blobs displays ([`TobQmc.FalsePositives.ConsistencyT3`](../../FalsePositives/ConsistencyT3.lean)) | [`Allman2023.inducedCutSplit_of_displays`](https://github.com/formal-phylogenetics/lean4-allman2023/blob/46efa61d0988df12649089689ae77bc100be034f/Allman2023/LargeNetworks/Rule.lean#L68) |

The statements use the definitions of lean4-allman2023 ([`Allman2023.CFDetectable`](https://github.com/formal-phylogenetics/lean4-allman2023/blob/46efa61d0988df12649089689ae77bc100be034f/Allman2023/LargeNetworks/Rule.lean#L56),
[`Allman2023.taxaBelowOff`](https://github.com/formal-phylogenetics/lean4-allman2023/blob/46efa61d0988df12649089689ae77bc100be034f/Allman2023/LargeNetworks/Reduction.lean#L489), [`Allman2023.HasUniqueParentsBelow`](https://github.com/formal-phylogenetics/lean4-allman2023/blob/46efa61d0988df12649089689ae77bc100be034f/Allman2023/LargeNetworks/Reduction.lean#L497), [`Allman2023.StarOff`](https://github.com/formal-phylogenetics/lean4-allman2023/blob/46efa61d0988df12649089689ae77bc100be034f/Allman2023/LargeNetworks/Reduction.lean#L543)) and those of the
libraries (networks, deletions of arcs, induced cut-edge splits, the tree of blobs). The paper's
library also states its assumptions with [`Allman2023.IsNonCut`](https://github.com/formal-phylogenetics/lean4-allman2023/blob/46efa61d0988df12649089689ae77bc100be034f/Allman2023/LargeNetworks/Rule.lean#L45) and [`Allman2023.CFDetectable`](https://github.com/formal-phylogenetics/lean4-allman2023/blob/46efa61d0988df12649089689ae77bc100be034f/Allman2023/LargeNetworks/Rule.lean#L56)
(assumption 6a, and the correctness of the tests).
