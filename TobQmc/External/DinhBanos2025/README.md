# Dinh, Baños 2025, Theorem 1 and Corollary 2

Source: V. Dinh, H. Baños, *Misspecification strikes: ASTRAL can mislead in the presence of hybridization, even for nonanomalous scenarios*, Mol. Biol. Evol. 42 (2025), msaf049,
<https://doi.org/10.1093/molbev/msaf049>, read in its PMC text with its MathML (PMC11934270).

TOB-QMC cites it in passing: under the NMSC, including non-anomalous scenarios, ASTRAL's tree need not be displayed by the network.

The statements are in [`Theorem1.lean`](Theorem1.lean), on the 5-cycle of Figure 1(d), with `y_i = exp(-e_i)`:

* [`theorem1`](Theorem1.lean#L600): if `1 - y₂ > γ/(1-γ) (1 - y₃y₄)` and `1 - y₃ < min(γ/(2-γ) (1-y₄), (1-γ)/(1+γ) (1-y₂))`, then `S = (((A,E),B),C,D)` has a higher expected ASTRAL score than `T₁` and `T₂`, and is not displayed. [`theorem1_displayed`](Theorem1.lean#L1121) states it of every parent choice.
* [`corollary2`](Theorem1.lean#L630): the same for `S′ = (((A,E),D),C,B)`.
* [`displayed_trees`](Theorem1.lean#L1106): the displayed trees are exactly `T₁ = ((B,C),A,(D,E))` and `T₂ = ((A,B),E,(C,D))`.
* [`not_quartetAnomalous`](Theorem1.lean#L706): the network has no quartet anomaly, at all parameters. The source cites this from Baños 2019.
* [`exists_params`](Theorem1.lean#L722): the conditions are satisfiable.

The proof follows the source's: the concordance factors of the five quartet sets, and a comparison of the three scores. They are read from [`Phylogenetics.cycleCF`](https://github.com/vltanh/lean4-phylogenetics/blob/3fcabfd7d191990dda268b0b3968d945b65eb59a/Phylogenetics/NMSC/Level1/Defs.lean#L169) through [`Phylogenetics.nmsc_quartetCF`](https://github.com/vltanh/lean4-phylogenetics/blob/3fcabfd7d191990dda268b0b3968d945b65eb59a/Phylogenetics/NMSC/Level1/Cycle.lean#L743) and [`Net.nmscCF_toRootedNetwork`](https://github.com/vltanh/lean4-phylogenetics/blob/3fcabfd7d191990dda268b0b3968d945b65eb59a/Phylogenetics/NMSC/Level1/General.lean#L1273).

**Departures from the paper.** The network is rooted on the hybrid edge of `D`, not semi-directed. The pendant and hybrid edges have length `1`, since, as the source notes, their lengths have no effect. The inheritance correlation is `0`. The generalization to `n`-cycles in the Supplementary material, the simulations and the numerical example are not formalized; [`exists_params`](Theorem1.lean#L722) uses other values for the example.
