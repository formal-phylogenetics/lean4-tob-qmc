# TINNiK (Allman, Baños, Mitchell, Rhodes 2024)

Source: E. S. Allman, H. Baños, J. D. Mitchell, J. A. Rhodes, *TINNiK: inference of the tree of blobs
of a species network under the coalescent model*, Algorithms Mol. Biol. 19 (2024), 23,
<https://doi.org/10.1186/s13015-024-00266-2>. Read in the publisher's XML (PMC11539473). It is a paper of
the hub lean4-tob, formalized in its own repository, [lean4-tinnik](https://github.com/vltanh/lean4-tinnik),
which this repository requires; its [report](https://github.com/vltanh/lean4-tinnik/blob/main/docs/Tinnik/REPORT.md)
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
| `External.Tinnik.exists_levels`, `External.Tinnik.tests_correct`: at parameters with `CF`-detectability there are levels `α_m → 0` at which the star and cut tests are correct on all sets of four taxa with probability tending to one | The consistency claim of §4.3 (`TobQmc.consistency`), the bipartition search (`TobQmc.consistency_search`), the implementation (`TobQmc.consistency_implementation`) | `Tinnik.exists_levels`, `Tinnik.tests_correct` |
| `External.Tinnik.exists_levels_t3`, `External.Tinnik.tests_correct_t3_of_t3Detectable`, `External.Tinnik.not_isT3Null_of_isNonCut`: the same with the T3 option, where the T3 test detects the sets with no cut-edge split, which a non-cut concordance factor gives | The consistency claim with the T3 option (`TobQmc.consistencyT3_of_noAnomalous`), and the bipartition search and the implementation with it | `Tinnik.exists_levels_t3`, `Tinnik.tests_correct_t3_of_t3Detectable`, `Tinnik.not_isT3Null_of_isNonCut` |
| `External.Tinnik.displaysOne_nmsc`, `External.Tinnik.tendsto_star`, `External.Tinnik.tendsto_good_cut`: gene trees display one quartet tree on four taxa; off the centroid the star test rejects, and at a strictly cut concordance factor the cut test does not, with probability tending to one | The method at level 2 (`TobQmc.LevelTwo`, E25) | `Tinnik.displaysOne_nmsc`, `Tinnik.tendsto_star`, `Tinnik.tendsto_good_cut` |

The statements use the definitions of lean4-tinnik (`Tinnik.Rejects`, `Tinnik.T3Rejects`,
`Tinnik.T3Detectable`, `Tinnik.IsT3MLSelection`, `Tinnik.testedBT3`, `Tinnik.testedTT3`) and those of
the libraries (the tests on quartet counts and the algorithm's Step 2, `testedB` and `testedT`, in
lean4-tob and lean4-phylo-network).
