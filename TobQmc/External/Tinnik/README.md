# TINNiK (Allman, Baños, Mitchell, Rhodes 2024)

Source: E. S. Allman, H. Baños, J. D. Mitchell, J. A. Rhodes, *TINNiK: inference of the tree of blobs
of a species network under the coalescent model*, Algorithms Mol. Biol. 19 (2024), 23,
<https://doi.org/10.1186/s13015-024-00266-2>. Read in the publisher's XML (PMC11539473). It is a paper of
the hub lean4-phylo-tree-of-blobs, formalized in its own repository, [lean4-tinnik](https://github.com/formal-phylogenetics/lean4-tinnik),
which this repository requires; its [report](https://github.com/formal-phylogenetics/lean4-tinnik/blob/main/docs/Tinnik/REPORT.md)
is the audit of the source.

TOB-QMC's oracle for treelikeness is "TINNiK's hypothesis tests": the star test, and the cut test or,
with the T3 option, the T3 test, on each set of four taxa. The consistency claim of its §4.3 cites
TINNiK's Theorem 4 for their correctness on all sets of four taxa, which is a step of that theorem's
proof, not its statement (E21 of the report). The counterexamples at level 2 of the supplement use the
limits of the tests on one set of four taxa.

Each result that the proofs here use is stated in this directory, in the namespace
`External.Tinnik`, in the source's terms (the definitions of lean4-tinnik and of the libraries), and
proved from the theorem of lean4-tinnik named below; the paper's library uses these statements. None of
them has a row of its own in lean4-tinnik's routes file: they are steps of the proof of Theorem 4,
whose row `tinnik:theorem4` [`docs/TobQmc/paper_routes.tsv`](../../../docs/TobQmc/paper_routes.tsv) has, with
`proved = 0`. The labels of lean4-tinnik's routes file already carry the prefix `tinnik:`.

| Statement | Where the paper uses it | Proved from |
| --- | --- | --- |
| [`External.Tinnik.exists_levels`](Theorem4.lean#L32), [`External.Tinnik.tests_correct`](Theorem4.lean#L43): at parameters with `CF`-detectability there are levels `α_m → 0` at which the star and cut tests are correct on all sets of four taxa with probability tending to one | The consistency claim of §4.3 ([`TobQmc.consistency`](../../FalsePositives/Consistency.lean#L132)), the bipartition search ([`TobQmc.consistency_search`](../../FalsePositives/BipartitionSearch.lean#L797)), the implementation ([`TobQmc.consistency_implementation`](../../Algorithms/Implementation.lean#L197)) | [`Tinnik.exists_levels`](https://github.com/formal-phylogenetics/lean4-tinnik/blob/de514e1f14522531f16dcdfa12244fe72fe05944/Tinnik/Consistency/Theorem4.lean#L570), [`Tinnik.tests_correct`](https://github.com/formal-phylogenetics/lean4-tinnik/blob/de514e1f14522531f16dcdfa12244fe72fe05944/Tinnik/Consistency/Theorem4.lean#L494) |
| [`External.Tinnik.exists_levels_t3`](T3.lean#L37), [`External.Tinnik.tests_correct_t3_of_t3Detectable`](T3.lean#L47), [`External.Tinnik.not_isT3Null_of_isNonCut`](T3.lean#L30): the same with the T3 option, where the T3 test detects the sets with no cut-edge split, which a non-cut concordance factor gives | The consistency claim with the T3 option ([`TobQmc.consistencyT3_of_noAnomalous`](../../FalsePositives/ConsistencyT3.lean#L161)), and the bipartition search and the implementation with it | [`Tinnik.exists_levels_t3`](https://github.com/formal-phylogenetics/lean4-tinnik/blob/de514e1f14522531f16dcdfa12244fe72fe05944/Tinnik/Consistency/T3.lean#L414), [`Tinnik.tests_correct_t3_of_t3Detectable`](https://github.com/formal-phylogenetics/lean4-tinnik/blob/de514e1f14522531f16dcdfa12244fe72fe05944/Tinnik/Consistency/T3.lean#L343), [`Tinnik.not_isT3Null_of_isNonCut`](https://github.com/formal-phylogenetics/lean4-tinnik/blob/de514e1f14522531f16dcdfa12244fe72fe05944/Tinnik/Consistency/T3.lean#L48) |
| [`External.Tinnik.displaysOne_nmsc`](Theorem4.lean#L56), [`External.Tinnik.tendsto_star`](Theorem4.lean#L63), [`External.Tinnik.tendsto_good_cut`](Theorem4.lean#L73): gene trees display one quartet tree on four taxa; off the centroid the star test rejects, and at a strictly cut concordance factor the cut test does not, with probability tending to one | The method at level 2 (`TobQmc.LevelTwo`, E25) | [`Tinnik.displaysOne_nmsc`](https://github.com/formal-phylogenetics/lean4-tinnik/blob/de514e1f14522531f16dcdfa12244fe72fe05944/Tinnik/Consistency/Theorem4.lean#L244), [`Tinnik.tendsto_star`](https://github.com/formal-phylogenetics/lean4-tinnik/blob/de514e1f14522531f16dcdfa12244fe72fe05944/Tinnik/Consistency/Theorem4.lean#L273), [`Tinnik.tendsto_good_cut`](https://github.com/formal-phylogenetics/lean4-tinnik/blob/de514e1f14522531f16dcdfa12244fe72fe05944/Tinnik/Consistency/Theorem4.lean#L287) |

The statements use the definitions of lean4-tinnik ([`Tinnik.Rejects`](https://github.com/formal-phylogenetics/lean4-tinnik/blob/de514e1f14522531f16dcdfa12244fe72fe05944/Tinnik/Consistency/Theorem4.lean#L315), [`Tinnik.T3Rejects`](https://github.com/formal-phylogenetics/lean4-tinnik/blob/de514e1f14522531f16dcdfa12244fe72fe05944/Tinnik/Consistency/T3.lean#L298),
[`Tinnik.T3Detectable`](https://github.com/formal-phylogenetics/lean4-tinnik/blob/de514e1f14522531f16dcdfa12244fe72fe05944/Tinnik/Consistency/T3.lean#L101), [`Tinnik.IsT3MLSelection`](https://github.com/formal-phylogenetics/lean4-tinnik/blob/de514e1f14522531f16dcdfa12244fe72fe05944/Tinnik/Consistency/T3.lean#L62), [`Tinnik.testedBT3`](https://github.com/formal-phylogenetics/lean4-tinnik/blob/de514e1f14522531f16dcdfa12244fe72fe05944/Tinnik/Consistency/T3.lean#L71), [`Tinnik.testedTT3`](https://github.com/formal-phylogenetics/lean4-tinnik/blob/de514e1f14522531f16dcdfa12244fe72fe05944/Tinnik/Consistency/T3.lean#L75)) and those of
the libraries (the tests on quartet counts and the algorithm's Step 2, [`testedB`](https://github.com/formal-phylogenetics/lean4-phylo-tree-of-blobs/blob/265ba443cb147a33ff2478cbc311a5597db1c1c7/TreeOfBlobs/Defs.lean#L158) and [`testedT`](https://github.com/formal-phylogenetics/lean4-phylo-tree-of-blobs/blob/265ba443cb147a33ff2478cbc311a5597db1c1c7/TreeOfBlobs/Defs.lean#L162), in
lean4-phylo-tree-of-blobs and lean4-phylo-network).
