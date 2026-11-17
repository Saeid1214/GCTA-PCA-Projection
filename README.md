# GCTA PCA Projection

Estimate principal components (PCs) in an unrelated reference sample, then project the full sample—including related individuals—onto the same genetic axes. This reduces family-driven distortion of ancestry PCs while retaining samples for downstream analyses. **Projection does not account for relatedness in subsequent statistical models.**

## Requirements

- [GCTA](https://yanglab.westlake.edu.cn/software/gcta/) (`gcta64` available on `PATH`)
- QC-filtered, LD-pruned PLINK binary files (`.bed`, `.bim`, `.fam`) for unrelated reference and full target samples
- Consistent genome build, SNP IDs, and allele coding across datasets

## Run

```bash
bash pca_projection.sh full_merged_pruned_unrel full_merged_pruned 20
```

Arguments: `REFERENCE_PREFIX TARGET_PREFIX [NUMBER_OF_PCS]` (default: 20).

## Workflow

1. Calculate the genetic relationship matrix (GRM) for unrelated individuals.
2. Estimate reference PCs from the GRM.
3. Calculate per-SNP PC loadings from the reference sample.
4. Project the full sample onto the reference PC axes.

Outputs are written to `results/`. The projected PC scores are in `results/full_projected.proj.eigenvec` (FID, IID, then projected PCs). The reference PCs are in `results/unrelated_pca.eigenvec`.

**Note:** Only SNPs shared by reference and target contribute to projection. Check the GCTA log for SNP overlap, allele handling, and quality-control warnings. The unrelated reference sample must already have been selected before running this script.

## Reference

[GCTA documentation — PC loading and projection](https://yanglab.westlake.edu.cn/software/gcta/#PCloadingandprojection)
