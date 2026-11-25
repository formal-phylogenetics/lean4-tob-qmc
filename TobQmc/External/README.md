# The results the paper cites

One directory per source, `TobQmc/External/<Source>/`, with modules `TobQmc.External.<Source>.…`,
declarations in the namespace `External.<Source>`, and a [`README.md`](README.md) giving the source, the statement,
how the paper uses it, whether the source was read, and the argument that proves it. Each result is
stated in its source's terms and proved; none is assumed. These modules import Mathlib,
[`TobQmc/Basic/`](../Basic) and the libraries this repository requires, never the paper's library.

A source that another repository of the collection already formalizes (lean4-phylogenetics, the hubs
lean4-phylo-network and lean4-phylo-tree-of-blobs, or the repository of a paper) is not formalized again
(lean4-phylogenetics, docs/CONVENTIONS.md, Sections 4 and 6).

| Source | Where | What the paper uses |
| --- | --- | --- |
| Ané, Fogg, Allman, Baños, Rhodes 2024 | [`AneEtAl2024/`](AneEtAl2024) | exchangeability of taxa across a cut edge, in the proof of Lemma 3 ([`External.AneEtAl2024.exchangeability`](AneEtAl2024/Exchangeability.lean#L29)); Proposition 12, no anomaly at `ρ = 1` ([`External.AneEtAl2024.proposition12`](AneEtAl2024/Proposition12.lean#L156)); rule 2 of its Section 3.3 ([`External.AneEtAl2024.rule2`](AneEtAl2024/Rules.lean#L134)) |
| Dinh, Baños 2025 | [`DinhBanos2025/`](DinhBanos2025) | Theorem 1 and Corollary 2: ASTRAL's tree need not be displayed by the network ([`External.DinhBanos2025.theorem1`](DinhBanos2025/Theorem1.lean#L600), [`External.DinhBanos2025.corollary2`](DinhBanos2025/Theorem1.lean#L630)) |
| Kane, Tao 2017 | [`KaneTao2017/`](KaneTao2017) | the bound of Theorem 1, behind the exponent `1.726` of ASTRAL-III's running time ([`External.KaneTao2017.theorem1`](KaneTao2017/PartitioningClusters.lean#L974)) |
| Allman, Baños, Mitchell, Rhodes 2023 | [`Allman2023/`](Allman2023), proved from lean4-allman2023 | `CF`-detectability for generic parameters ([`External.Allman2023.cfDetectable_generic`](Allman2023/CFDetectable.lean#L33)), the reduction of part (b) of the proof of its Theorem 1, in the proof of Lemma 1 ([`External.Allman2023.exists_reduction`](Allman2023/Reduction.lean#L70)), the quartet trees of the tree of blobs ([`External.Allman2023.inducedCutSplit_of_displays`](Allman2023/Rule.lean#L27)) |
| Allman, Baños, Mitchell, Rhodes 2024 (TINNiK) | [`Tinnik/`](Tinnik), proved from lean4-tinnik | the correctness of TINNiK's hypothesis tests on all sets of four taxa, a step of the proof of its Theorem 4 ([`External.Tinnik.tests_correct`](Tinnik/Theorem4.lean#L43), [`External.Tinnik.tests_correct_t3_of_t3Detectable`](Tinnik/T3.lean#L47)), and their limits on one set of four taxa |
| Huber, van Iersel, Jones, Moulton, Veenema-Nipius 2025 | lean4-phylo-network, `PhyloNetwork/External/HuberEtAl2025/`, in the namespace `External.HuberEtAl2025` | Theorem 5.1, whose forward direction is the paper's Lemma 2 ([`External.HuberEtAl2025.theorem5_1_forward`](https://github.com/vltanh/lean4-phylo-network/blob/4ed2bb0f7085acbf1326f43e2a5c582ba4566125/PhyloNetwork/External/HuberEtAl2025/Theorem51.lean#L25), [`External.HuberEtAl2025.theorem5_1`](https://github.com/vltanh/lean4-phylo-network/blob/4ed2bb0f7085acbf1326f43e2a5c582ba4566125/PhyloNetwork/External/HuberEtAl2025/Theorem51.lean#L168)) |
| Mitchell, Allman, Rhodes 2019 | lean4-phylo-network, `PhyloNetwork/External/MitchellAllmanRhodes2019/`, in the namespace `External.MitchellAllmanRhodes2019` | the T3 test and its limit laws, behind the T3 option ([`External.MitchellAllmanRhodes2019.proposition4_1`](https://github.com/vltanh/lean4-phylo-network/blob/4ed2bb0f7085acbf1326f43e2a5c582ba4566125/PhyloNetwork/External/MitchellAllmanRhodes2019/T3Limit.lean#L480), [`External.MitchellAllmanRhodes2019.proposition4_2`](https://github.com/vltanh/lean4-phylo-network/blob/4ed2bb0f7085acbf1326f43e2a5c582ba4566125/PhyloNetwork/External/MitchellAllmanRhodes2019/T3Density.lean#L839)) |
| Mirarab et al. 2014 | lean4-phylogenetics, `Phylogenetics/Tree/AstralDP.lean` | ASTRAL's dynamic program is exact on its search space ([`Phylogenetics.IsTraceback.isAstralOptimal`](https://github.com/vltanh/lean4-phylogenetics/blob/3fcabfd7d191990dda268b0b3968d945b65eb59a/Phylogenetics/Tree/AstralDP.lean#L1103)), behind the ASTRAL corollary |

Allman et al. 2023 and TINNiK are formalized in their own repositories, lean4-allman2023 and
lean4-tinnik: each of their results that the proofs here use is stated in [`Allman2023/`](Allman2023) or
[`Tinnik/`](Tinnik) and proved from that repository's theorem (lean4-phylogenetics, docs/CONVENTIONS.md,
Section 6). The counts of ASTRAL-III (Zhang et al. 2018, Lemma 1 and Theorem 1) and of TREE-QMC (Han,
Molloy 2023, Theorem 3), which the running times quote, are in [`TobQmc/Algorithms/RunningTime.lean`](../Algorithms/RunningTime.lean).

## What the sources share with the paper's library

The cited results are stated on the definitions of lean4-phylogenetics, of the hubs and of the
repositories this one requires (networks, quartet trees, the network multispecies coalescent with its
inheritance correlation, the tests on quartet counts, `CF`-detectability), so the sources need no
definition of the paper. No module here imports the paper's library, and the paper's library defines
nothing that a source uses.
