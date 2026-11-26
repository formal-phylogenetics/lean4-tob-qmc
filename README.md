# TOB-QMC: quartet-based tree of blobs reconstruction, in Lean

[![CI](https://github.com/formal-phylogenetics/lean4-tob-qmc/actions/workflows/lean_action_ci.yml/badge.svg)](https://github.com/formal-phylogenetics/lean4-tob-qmc/actions/workflows/lean_action_ci.yml)

A Lean 4 formalization of Junyan Dai, Yunheng Han and Erin K. Molloy (2026), "Quartet-based species tree methods enable fast and consistent tree of blobs reconstruction under the network multispecies coalescent", [bioRxiv 10.1101/2025.11.05.686850 v5](https://www.biorxiv.org/content/10.1101/2025.11.05.686850v5), with its supplement. The tree of blobs of a phylogenetic network is what remains of it when its reticulate parts, the blobs, are contracted. The paper shows that quartet-based species tree methods give a refinement of the tree of blobs under the network multispecies coalescent: almost surely, once there are enough gene trees, every optimal solution of Weighted Quartet Consensus refines it (Theorem 1). An oracle for treelikeness, applied to a disjoint cover of four-taxon subsets around each edge of the refinement, a linear number of them, then finds the edges to contract on a binary level-1 network (Theorem 2). With TINNiK's hypothesis tests as the oracle, the method, TOB-QMC, returns the tree of blobs with probability tending to one (§4.3).

Every numbered result of the paper is proved, as printed or in a corrected form, by the paper's arguments except the departures that [Section 7 of the report](docs/TobQmc/REPORT.md#7-departures-from-the-papers-proofs) lists. The formalization is unconditional: no result of the literature is assumed, and there is no `sorry` or `axiom` outside the Challenge's statements. Three claims of the supplement are false, and their failure is proved; main v5 does not make them. No person has reviewed the proofs.

This paper belongs to the hub [lean4-phylo-network](https://github.com/formal-phylogenetics/lean4-phylo-network), with the papers on the tree of blobs of a phylogenetic network, which share the library of [lean4-phylo-tree-of-blobs](https://github.com/formal-phylogenetics/lean4-phylo-tree-of-blobs), in the collection rooted at [lean4-phylogenetics](https://github.com/formal-phylogenetics/lean4-phylogenetics). It builds on Allman et al. 2023 and TINNiK, formalized in [lean4-allman2023](https://github.com/formal-phylogenetics/lean4-allman2023) and [lean4-tinnik](https://github.com/formal-phylogenetics/lean4-tinnik).

## Status

| Part of the paper | Status |
| --- | --- |
| §4.1: Lemma 1, Definition 1, a refinement of the tree of blobs need not be a display tree | proved; Lemma 1, which the paper cites from Ané et al. 2024, through the steps of Allman et al. 2023 that its source's proof uses |
| §4.2: equations (1)–(3), Lemma 3, Theorem 1, the ASTRAL corollary, supplement Lemma 4 | proved; supplement Lemma 4 with a repaired margin (E22) |
| §4.3: Lemma 2, Lemma 4, Corollary 1, Definition 2, Theorem 2, 3-fix-1-alter, the consistency claim | proved; the consistency claim needs a fact the paper does not give, proved here (E21) |
| What the paper says in passing: the T3 option, the bipartition search with 3-fix-1-alter, the implementation that applies the star test to the minimizer only, ASTRAL's dynamic program, the running times | proved; the running times as counts of operations |
| The supplement: Lemmas 2, 4, 7, 8 and Theorem 1 | Lemma 4 and Lemma 8 proved, Lemma 8 for nontrivial blobs (E26); the converse of Lemma 2 (E23), and Lemma 7 and Theorem 1 at level 2 (E25), shown false |
| Cited results: Huber et al. 2025, Ané et al. 2024, Dinh and Baños 2025, Kane and Tao 2017, Mitchell et al. 2019; Allman et al. 2023 and TINNiK | proved, in [`TobQmc/External/`](TobQmc/External), lean4-phylo-network and lean4-phylogenetics; those of Allman et al. 2023 and TINNiK stated in [`TobQmc/External/`](TobQmc/External) and proved from lean4-allman2023 and lean4-tinnik |
| The simulations, the data analyses and measured running times | not formalized |

[Section 9 of the report](docs/TobQmc/REPORT.md#9-not-formalized) lists what is not formalized.

## Main results

The statements of record are the theorems of the Challenge, [`palomar/TobQmc/Challenge.lean`](palomar/TobQmc/Challenge.lean), in the namespace `TobQmcChallenge`. The Challenge imports only Mathlib, and its definitions are those of [`TobQmc/Defs.lean`](TobQmc/Defs.lean), copied by [`scripts/sync_challenge_defs.py`](scripts/sync_challenge_defs.py): rooted phylogenetic, binary and level-1 networks, valid parameters, the network multispecies coalescent with an inheritance correlation `ρ` and its samples, the tree of blobs by its splits, treelikeness of the network induced on four taxa, binary trees, the quartet score and Weighted Quartet Consensus, the standard assumptions, T-quartet-nonanomaly, disjoint covers, TINNiK's star and cut tests, and TOB-QMC's contraction. [`palomar/TobQmc/Solution.lean`](palomar/TobQmc/Solution.lean) proves them, under the same names, from the library, through the bridges of [`TobQmc/Bridge/`](TobQmc/Bridge). They keep the paper's hypotheses.

| Paper | Lean | Statement |
| --- | --- | --- |
| Theorem 1 | [`TobQmcChallenge.theorem1`](palomar/TobQmc/Challenge.lean#L639) | under the standard assumptions, for a T-quartet-nonanomalous network on at least four taxa and independent gene trees, for every binary tree `T` that does not refine the tree of blobs and every `ε > 0`, there are a binary refinement `B` of the tree of blobs and `K` such that, with probability at least `1 - ε`, the quartet score of `B` on the first `k` gene trees exceeds that of `T` for all `k ≥ K` |
| Theorem 1, "put simply" | [`TobQmcChallenge.theorem1_optimal`](palomar/TobQmc/Challenge.lean#L654) | almost surely, for all large `k`, every optimal solution of Weighted Quartet Consensus on the first `k` gene trees refines the tree of blobs |
| Theorem 2 | [`TobQmcChallenge.theorem2`](palomar/TobQmc/Challenge.lean#L670) | on a binary level-1 network, for any refinement `B` of the tree of blobs and disjoint covers around its internal edges, contracting the edges where the oracle for treelikeness answers non-treelike on a set of the cover returns the tree of blobs |
| §4.3, consistency | [`TobQmcChallenge.consistency`](palomar/TobQmc/Challenge.lean#L686) | for a binary level-1 network under the standard assumptions, T-quartet-nonanomalous, whose non-treelike sets of four taxa have non-cut concordance factors (assumption 6a), there are levels `α_k → 0` such that for any `β > 0`, any selection of maximum likelihood topologies, any solver of Weighted Quartet Consensus and any disjoint covers, the method on `k` gene trees returns the tree of blobs with probability tending to one |

### Also proved in the library

| Paper | Lean | Statement |
| --- | --- | --- |
| Lemma 1 | [`TobQmc.lemma1`](TobQmc/Background/Lemma1.lean#L545) | a binary network on four taxa displays exactly one binary quartet tree if and only if it has no 4-blob |
| Lemma 3 | [`TobQmc.lemma3`](TobQmc/Refinement/WQC.lean#L679) | with the exact expected concordance factors, a binary refinement of the tree of blobs has a higher quartet score than every binary tree that does not refine it |
| The ASTRAL corollary | [`TobQmc.astral_corollary`](TobQmc/Refinement/WQC.lean#L1065), [`TobQmc.astral_refines_treeOfBlobs`](TobQmc/Refinement/Astral.lean#L160) | ASTRAL's optima in its search space, and the tree its dynamic program returns, refine the tree of blobs almost surely |
| Lemma 4, Corollary 1 | [`TobQmc.lemma4`](TobQmc/FalsePositives/Level1.lean#L383), [`TobQmc.corollary1`](TobQmc/FalsePositives/Level1.lean#L414) | at level 1, a set of four taxa around an edge of a refinement that is not in the tree of blobs is non-treelike exactly when its taxa lie in distinct blocks at the blob and one of them descends from the reticulation; an edge is in the tree of blobs exactly when the oracle answers treelike on all four-taxon subsets around it |
| 3-fix-1-alter | [`TobQmc.threeFixOneAlter_correct`](TobQmc/FalsePositives/Level1.lean#L785) | the 3-fix-1-alter search tests a disjoint cover around each edge, so contracting the edges where the oracle answers non-treelike returns the tree of blobs |
| The T3 option | [`TobQmc.consistencyT3_of_noAnomalous`](TobQmc/FalsePositives/ConsistencyT3.lean#L161) | the consistency claim with TINNiK's T3 test, under conditions 5, 6a and 6b |
| The bipartition search | [`TobQmc.consistency_search`](TobQmc/FalsePositives/BipartitionSearch.lean#L797) | combining the bipartition search (Algorithm 2 of the supplement) with a disjoint cover gives a consistent method at level 1 |
| The implementation | [`TobQmc.consistency_implementation`](TobQmc/Algorithms/Implementation.lean#L197) | the same holds for the implementation, which tests a selection of four-taxon subsets around each edge and applies the star test to the minimizer only |
| A refinement need not be displayed | [`TobQmc.DisplayedRefinement.refinement_not_displayed`](TobQmc/Background/DisplayedRefinement.lean#L41) | a binary tree refining the tree of blobs of a binary level-1 network, that no parent choice displays |
| The running times | [`TobQmc.tobqmcOperations_le`](TobQmc/Algorithms/RunningTime.lean#L497), [`TobQmc.astralOperations_le`](TobQmc/Algorithms/RunningTime.lean#L364), [`TobQmc.treeQMCWork_le`](TobQmc/Algorithms/RunningTime.lean#L131) | the counts behind `O(n³ k)` for TOB-QMC, and the bounds of ASTRAL-III and TREE-QMC that the paper quotes |
| Supplement Lemma 4 | [`TobQmc.supplementLemma4`](TobQmc/Refinement/WQC.lean#L708) | the perturbation lemma, with the margin between the displayed quartet and its alternatives (E22) |
| Supplement Lemma 8 | [`TobQmc.supplement_lemma8`](TobQmc/Supplement/Lemma8.lean#L91) | a nontrivial blob of a binary network has a reticulation incident to a cut edge of the blob (E26) |

### The supplement's claims that fail

| Claim | Lean | Statement |
| --- | --- | --- |
| The margin of supplement Lemma 4 (E22) | [`TobQmc.not_printedPiMin_pos`](TobQmc/Supplement/Lemma4Margin.lean#L65), [`TobQmc.not_exists_printedError_lt`](TobQmc/Supplement/Lemma4Margin.lean#L73) | on a network whose tree of blobs is not a star, the margin `π_min` is not positive, and no weights meet the printed hypothesis |
| The converse of supplement Lemma 2 (E23) | [`TobQmc.SupplementLemma2.not_lemma2Converse`](TobQmc/Supplement/Lemma2.lean#L165) | with `N\|Y` the induced subnetwork, as the supplement defines it: a binary level-1 network whose tree of blobs is a star, with a treelike induced network on four taxa |
| Supplement Lemma 7 and Theorem 1 at level 2 (E25) | [`TobQmc.LevelTwo.not_supplementLemma7`](TobQmc/Supplement/LevelTwo.lean#L588), [`TobQmc.LevelTwo.not_supplementTheorem1`](TobQmc/Supplement/LevelTwo.lean#L721), [`TobQmc.LevelTwo.not_theorem2_without_level_one`](TobQmc/Supplement/LevelTwo.lean#L612) | on a binary level-2 network, a set of four taxa around a false edge meets both conditions of Lemma 7 and is treelike; Theorem 1 fails at `ρ = 1` |
| The method at level 2 (E25) | [`TobQmc.LevelTwo.tendsto_tobqmcT3_eq_treeOfBlobs_rho_one`](TobQmc/Supplement/LevelTwo.lean#L679), [`TobQmc.LevelTwo.forGenericParams_tendsto_tobqmc_eq_treeOfBlobs`](TobQmc/Supplement/LevelTwo.lean#L664) | on that network the method returns the tree of blobs with probability tending to zero, at `ρ = 1` with the T3 option and for generic parameters at `ρ = 0` |

### The sources

| Source | Lean | Statement |
| --- | --- | --- |
| Huber et al. 2025, Theorem 5.1 (the paper's Lemma 2 is its forward direction) | [`External.HuberEtAl2025.theorem5_1`](https://github.com/formal-phylogenetics/lean4-phylo-network/blob/4ed2bb0f7085acbf1326f43e2a5c582ba4566125/PhyloNetwork/External/HuberEtAl2025/Theorem51.lean#L168) | a split is the split of a cut edge exactly when it is trivial or every `a₁a₂\|b₁b₂` across it is a cut-edge split of the induced network; proved in lean4-phylo-network |
| Ané et al. 2024, exchangeability and Proposition 12 | [`External.AneEtAl2024.exchangeability`](TobQmc/External/AneEtAl2024/Exchangeability.lean#L29), [`External.AneEtAl2024.proposition12`](TobQmc/External/AneEtAl2024/Proposition12.lean#L156) | taxa on one side of a cut edge are exchangeable for quartets; at `ρ = 1` a network with weak parameters is not anomalous |
| Allman et al. 2023 | [`External.Allman2023.exists_reduction`](TobQmc/External/Allman2023/Reduction.lean#L70), [`External.Allman2023.cfDetectable_generic`](TobQmc/External/Allman2023/CFDetectable.lean#L33), [`External.Allman2023.inducedCutSplit_of_displays`](TobQmc/External/Allman2023/Rule.lean#L27) | the reduction of part (b) of the proof of their Theorem 1, `CF`-detectability for generic parameters, and the quartet trees of the tree of blobs; proved from lean4-allman2023 |
| TINNiK, the proof of Theorem 4 | [`External.Tinnik.tests_correct`](TobQmc/External/Tinnik/Theorem4.lean#L43), [`External.Tinnik.tests_correct_t3_of_t3Detectable`](TobQmc/External/Tinnik/T3.lean#L47) | at parameters with `CF`-detectability, the star and cut tests, or the T3 test, are correct on all sets of four taxa with probability tending to one; proved from lean4-tinnik |
| Dinh, Baños 2025, Theorem 1 | [`External.DinhBanos2025.theorem1`](TobQmc/External/DinhBanos2025/Theorem1.lean#L600) | under their conditions (6) and (7), a tree that the network does not display has a higher expected ASTRAL score than both displayed trees |
| Kane, Tao 2017, Theorem 1 | [`External.KaneTao2017.theorem1`](TobQmc/External/KaneTao2017/PartitioningClusters.lean#L974) | the number of triples `(A₁, A₂, A)` of a finite collection of finite sets with `A = A₁ ⊎ A₂` is at most `\|X\|^(3/p)`, `p = log₃(27/4)`: the exponent `1.726` of ASTRAL-III |
| Mitchell et al. 2019, Propositions 4.1, 4.2, 5.1, 5.2 | [`External.MitchellAllmanRhodes2019.proposition4_1`](https://github.com/formal-phylogenetics/lean4-phylo-network/blob/4ed2bb0f7085acbf1326f43e2a5c582ba4566125/PhyloNetwork/External/MitchellAllmanRhodes2019/T3Limit.lean#L480), [`External.MitchellAllmanRhodes2019.proposition4_2`](https://github.com/formal-phylogenetics/lean4-phylo-network/blob/4ed2bb0f7085acbf1326f43e2a5c582ba4566125/PhyloNetwork/External/MitchellAllmanRhodes2019/T3Density.lean#L839) | the limit laws and densities of the T3 and T1 tests, behind the T3 option; proved in lean4-phylo-network |

## What the audit found

| Finding | Where |
| --- | --- |
| The supplement's Lemma 7 and Theorem 1 are false at level 2, by an explicit network | E25 |
| The converse of the supplement's Lemma 2 is false with `N\|Y` the induced subnetwork, as it defines it; it holds under the gloss in its proof | E23 |
| Positive edge lengths do not exclude the centroid, as the supplement claims | E28 |
| The margin of the supplement's Lemma 4 is vacuous as printed | E22 |
| The consistency claim cites the statement of TINNiK's Theorem 4 for what is a step of its proof, and needs the tests to be correct on treelike subsets that the tree of blobs does not resolve | E21 |
| Gaps in Lemma 4, Corollary 1 and supplement Lemma 4, all repaired | E18–E20, E24, E39 |
| Supplement Lemma 8 needs a nontrivial blob | E26 |
| Binary lifting isn't `O(1)` per query, though the total stands; other loose sentences on running times; a formula for `α` in §1.2; ASTRAL-III drops a constant; typos | E69–E74, E27, E83, E34 |

None of these affects a result of main v5, which states Theorem 2 at level 1, keeps only the forward direction of Lemma 2 and excludes the centroid on T-quartets. [Section 3 of the report](docs/TobQmc/REPORT.md#3-errors-and-gaps-in-the-paper) gives each finding with its location, the paper's sentence, a Lean counterexample where there is one, and the repair, and [Section 5](docs/TobQmc/REPORT.md#5-redundant-hypotheses) the redundant hypotheses: all the refinement hypotheses of Lemma 4 except [`TobQmc.RefinesBlob`](TobQmc/FalsePositives/Level1.lean#L41); `B` binary in Corollary 1; for the T3 option, 6a in full and 6b given condition 4. The proofs follow the paper's arguments, except the departures in [Section 7 of the report](docs/TobQmc/REPORT.md#7-departures-from-the-papers-proofs), each with what the paper does, what Lean does and why. Some repair a gap or an error: Lemma 4 (E19), Corollary 1 (E20), the consistency claim (E21) and supplement Lemma 4 (E22, E24). A few aren't forced, and say so: Lemma 1, the suppression skipped in Lemma 4, supplement Lemma 8, and three proofs of cited results.

## Trust

- `lake build` passes; the only warnings are the `sorry`s of the Challenge's statements. There is no `sorry`, `axiom`, `native_decide` or `implemented_by` in [`TobQmc/`](TobQmc) or in the Solution.
- [`scripts/Audit.lean`](scripts/Audit.lean) checks every declaration of this repository and of the libraries it requires, `Phylogenetics`, `PhyloNetwork`, `TreeOfBlobs`, `Allman2023` and `Tinnik`, including private and generated ones, against [`propext`](https://leanprover-community.github.io/mathlib4_docs/Init/Core.html#propext), [`Classical.choice`](https://leanprover-community.github.io/mathlib4_docs/Init/Prelude.html#Classical.choice) and [`Quot.sound`](https://leanprover-community.github.io/mathlib4_docs/Init/Prelude.html#Quot.sound), and writes the routes of the proofs.
- [`scripts/route_check.py`](scripts/route_check.py) compares those routes with the paper's, in [`docs/TobQmc/paper_routes.tsv`](docs/TobQmc/paper_routes.tsv); [`docs/TobQmc/route_differences.tsv`](docs/TobQmc/route_differences.tsv) records every difference, with its reason.
- Comparator checks that the Solution proves exactly the Challenge's statements, under Lean's kernel and NanoDa; [`scripts/check_kernels.sh`](scripts/check_kernels.sh) runs it, and con-ron on an export of the same theorems.
- No person has reviewed the proofs. Independent agents reviewed the statements against the paper, compared the proofs with the paper's, and checked the findings.

## Dependencies

- [Mathlib](https://github.com/leanprover-community/mathlib4), at `v4.37.0-rc1`.
- [lean4-phylogenetics](https://github.com/formal-phylogenetics/lean4-phylogenetics), the library of the collection, pinned by commit in [`lakefile.toml`](lakefile.toml): networks, trees and quartets, blobs and the tree of blobs, induced networks, the network multispecies coalescent with inheritance correlation and its exchangeability, ASTRAL's dynamic program.
- [lean4-phylo-network](https://github.com/formal-phylogenetics/lean4-phylo-network), the library of the hub of network estimation, pinned by commit: the hypothesis tests on quartet counts and their limit laws, the blobs, blocks and wedge paths of level-1 networks, cut splits of induced networks, and the sources Huber et al. 2025 and Mitchell et al. 2019.
- [lean4-phylo-tree-of-blobs](https://github.com/formal-phylogenetics/lean4-phylo-tree-of-blobs), the library of this paper's hub, pinned by commit: TOB-QMC's algorithm and standing assumptions, the local objective at a multifurcation, no anomalous quartets at `ρ = 1`, lowest common ancestors, counts of tree edges, and networks given by tables.
- [lean4-allman2023](https://github.com/formal-phylogenetics/lean4-allman2023) and [lean4-tinnik](https://github.com/formal-phylogenetics/lean4-tinnik), Allman et al. 2023 and TINNiK, pinned by commit: the results the proofs here use, which [`TobQmc/External/Allman2023/`](TobQmc/External/Allman2023) and [`TobQmc/External/Tinnik/`](TobQmc/External/Tinnik) state and prove from their theorems.

## Palomar

No submission to Palomar is planned. [`palomar/TobQmc/`](palomar/TobQmc) has the files of an entry: the Challenge, which imports only Mathlib, the Solution, [`comparator.json`](palomar/TobQmc/comparator.json), which names them and the theorems, and [`formalization.yaml`](palomar/TobQmc/formalization.yaml), the entry's metadata, with the statements aligned to the Challenge's theorems and every divergence from the paper. From the repository root, after `lake build`, run [`scripts/check_kernels.sh`](scripts/check_kernels.sh). CI checks that the Challenge's copy of the definitions is the block of [`TobQmc/Defs.lean`](TobQmc/Defs.lean) (`python3 scripts/sync_challenge_defs.py --check`).

## Building

From the root of the repository:

```sh
lake exe cache get
lake build
lake build Phylogenetics PhyloNetwork TreeOfBlobs Allman2023 Tinnik   # the libraries that the audit reads
lake env lean -Dlinter.deprecated.module=false scripts/Audit.lean     # axioms and dependencies
python3 scripts/route_check.py check docs/TobQmc/paper_routes.tsv --accept docs/TobQmc/route_differences.tsv
scripts/check_kernels.sh                                              # Comparator: Lean's kernel, NanoDa; con-ron
python3 scripts/linkify_docs.py                                       # the documents' links to the code
```

- Toolchain: Lean and Mathlib `v4.37.0-rc1` ([`lean-toolchain`](lean-toolchain), [`lake-manifest.json`](lake-manifest.json)).
- `lake comparator`, `leanexport` and `con-ron` come from the toolchain, under `lake env`. The kernels' replays need much memory.
- [lean4-phylo-tree-of-blobs's `docs/CONFIGURATION.md`](https://github.com/formal-phylogenetics/lean4-phylo-tree-of-blobs/blob/05a024a837076455c700e5d0f88637aa22432b45/docs/CONFIGURATION.md) records the versions, the decisions, and what "line N" means.

## Layout

| Folder | Content |
| --- | --- |
| [`TobQmc/Basic/`](TobQmc/Basic) | General mathematics, in Mathlib's namespaces; [its README](TobQmc/Basic/README.md) says where each part could go |
| [`TobQmc/External/`](TobQmc/External) | The cited results, one directory per source, in the namespaces `External.<Source>`: Ané et al. 2024, Dinh and Baños 2025, Kane and Tao 2017, and Allman et al. 2023 and TINNiK, proved from lean4-allman2023 and lean4-tinnik; [its README](TobQmc/External/README.md) lists them, with those proved in the libraries |
| [`TobQmc/Defs.lean`](TobQmc/Defs.lean), [`TobQmc/Bridge/`](TobQmc/Bridge) | The definitions of the Challenge, and the proof that they are the library's |
| [`TobQmc/Background/`](TobQmc/Background) | §4.1: Lemma 1 (`Lemma1`), a refinement of the tree of blobs need not be a display tree (`DisplayedRefinement`), the two definitions of a level-1 network agree on binary networks (`LevelOneDigraph`) |
| [`TobQmc/Refinement/`](TobQmc/Refinement) | §4.2: Definition 1, equations (1)–(4), Lemma 3, supplement Lemma 4, Theorem 1 and the ASTRAL corollary (`WQC`); the tree that ASTRAL's dynamic program returns (`Astral`) |
| [`TobQmc/FalsePositives/`](TobQmc/FalsePositives) | §4.3: Lemma 2, Lemma 4, Corollary 1, Theorem 2 and 3-fix-1-alter (`Level1`); the concordance factors of induced cut-edge splits at level 1 (`Level1CF`); the consistency claim (`Consistency`) and its T3 option (`ConsistencyT3`); the bipartition search (`BipartitionSearch`, `BipartitionSearchT3`) |
| [`TobQmc/Algorithms/`](TobQmc/Algorithms) | §2.1 and the running times: the implementation of the tests (`Implementation`), the counts of the subsets tested (`Counts`), the running times and what they rest on (`RunningTime`) |
| [`TobQmc/Supplement/`](TobQmc/Supplement) | The supplement's Lemma 2 (`Lemma2`), the margin of its Lemma 4 (`Lemma4Margin`), its Lemma 8 (`Lemma8`), and its Lemma 7 and Theorem 1 at level 2 (`LevelTwo`) |
| [`palomar/TobQmc/`](palomar/TobQmc) | The Challenge, the Solution, the Comparator configuration and the metadata |
| [`docs/TobQmc/`](docs/TobQmc) | [The report](docs/TobQmc/REPORT.md), [the credits](docs/TobQmc/CREDITS.md) and the routes of the proofs |
| [`scripts/`](scripts) | The audit, the route check, the copy of the definitions into the Challenge, the kernels, the links and the tables |

The paper's library is in the namespace [`TobQmc`](TobQmc). No repository of the collection requires this one.

## Related work

From [Section 10 of the report](docs/TobQmc/REPORT.md#10-the-paper-in-the-literature).

- No other formalization of the paper was found.
- Before: Gusfield et al. 2007's decomposition theory is the source of the tree of blobs. Allman et al. 2023 showed that the tree of blobs is identifiable from gene quartet distributions with no assumption on the level, and TINNiK made that an algorithm with a consistency theorem; TOB-QMC uses its tests. Huber et al. 2025 characterize cut-edge splits by quarnets, and TOB-QMC's Lemma 2 is the forward direction.
- Concurrent: ECToBlob (first version 2026-05-31; TOB-QMC's was 2025-11-06) proves the same result, that an optimum of the quartet criterion refines the tree of blobs, and contracts edges by another test. Its authors say that the two groups pursued the outline independently.
- Since: the paper appeared in Genome Research in 2026, whose text we could not read. Dai and Molloy (WABI 2026) reconstruct level-1 blobs from a tree of blobs, using TOB-QMC's Theorem 2 and its Lemma 4. We found no erratum, and no work that settles treelikeness beyond level 1.

## What's next

An open question is whether, beyond level 1, every false edge of a refinement of the tree of blobs has a non-treelike four-taxon set around it: the formal justification of TOB-QMC stops at level 1, and the supplement's claim for disjoint covers fails at level 2 (E25). That failure is proved at `ρ = 1` and for generic parameters at `ρ = 0`, and other values of `ρ` remain. [Section 11 of the report](docs/TobQmc/REPORT.md#11-whats-next) has these and the simpler arguments that the formalization found.

## Credits

- Maintainer: The-Anh Vu-Le, who requested and supervised the formalization, chose the paper and its version, agreed to the corrections of its statements, and decided the library's boundary and the project's layout.
- Formalization: Codex made the source audit and first foundations of the collection on 2026-10-27, and Claude (Opus 5.5) in Claude Code, with sub-agents, wrote the statements, proofs, audit and documents from 2026-10-31 to 2026-11-01, following the [formalize-math-paper](https://github.com/vltanh/formalize-math-paper) procedure, both in lean4-phylo-tree-of-blobs with the other papers of the collection. [`docs/TobQmc/CREDITS.md`](docs/TobQmc/CREDITS.md) and lean4-phylo-tree-of-blobs's [`docs/CREDITS.md`](https://github.com/formal-phylogenetics/lean4-phylo-tree-of-blobs/blob/05a024a837076455c700e5d0f88637aa22432b45/docs/CREDITS.md) have the details.
- Review: no person has reviewed the proofs; Lean's kernel checks them. Independent agents reviewed the statements and compared the proofs with the paper.

## License

Apache-2.0: [LICENSE](LICENSE). Code adapted from [lean4-phylogenetics](https://github.com/formal-phylogenetics/lean4-phylogenetics) (Apache-2.0) keeps its notice in each file's header.
