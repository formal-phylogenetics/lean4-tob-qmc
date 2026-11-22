# Credits

TOB-QMC (Dai, Han, Molloy 2026), in Lean.

- **Maintainer:** The-Anh Vu-Le, who chose the paper, agreed to the corrections of its statements that
  [the report](REPORT.md) records, and decided the layout. **No person has reviewed the proofs.**
- **Formalization:** Claude (Opus 5.5) in Claude Code, with sub-agents, following the
  [formalize-math-paper](https://github.com/vltanh/formalize-math-paper) procedure; the first foundations and
  the source audit by Codex. The work was done in [lean4-tob](https://github.com/vltanh/lean4-tob), with the other
  papers on the tree of blobs, from 2026-10-27 to 2026-11-04. The rounds, the agents and models, and the time and
  effort of each are in lean4-tob's
  [`docs/CREDITS.md`](https://github.com/vltanh/lean4-tob/blob/6e7bc494d26f3d7096a17adffbfde1cf559f0ae9/docs/CREDITS.md),
  at the last commit before the split.
- **Moved to this repository** on 2026-11-21, by Claude (Opus 5.5) in Claude Code, when lean4-tob became the hub
  of its papers. No statement and no proof changed: only module paths did. Every declaration keeps its name and its
  type, checked against lean4-tob at commit `6e7bc49`, and the audit and the route check pass here.
