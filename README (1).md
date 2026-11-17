# PCA Projection from Unrelated to Full Samples Using GCTA

Estimate principal components (PCs) in unrelated individuals and project them onto the full sample, including relatives. This reduces family-driven distortion of population structure estimates while retaining all individuals for downstream analyses.

## Requirements

- [GCTA](https://yanglab.westlake.edu.cn/software/gcta/) (`gcta64`)
- QC-filtered, LD-pruned autosomal genotypes in PLINK binary format (`.bed`, `.bim`, `.fam`):
  - `full_merged_pruned_unrel`: unrelated reference sample
  - `full_merged_pruned`: full sample, including relatives
- Consistent SNP IDs, genome build, and allele coding across datasets.

## Workflow

```bash
# 1. Build the GRM using unrelated individuals
gcta64 --bfile full_merged_pruned_unrel \
       --autosome --make-grm \
       --out unrelated_grm

# 2. Estimate 20 PCs from the unrelated sample
gcta64 --grm unrelated_grm \
       --pca 20 \
       --out unrelated_pca

# 3. Calculate SNP loadings for the reference PCs
gcta64 --bfile full_merged_pruned_unrel \
       --pc-loading unrelated_pca \
       --out unrelated_snp_loading

# 4. Project all individuals onto the same PC axes
gcta64 --bfile full_merged_pruned \
       --project-loading unrelated_snp_loading 20 \
       --out full_projected
```

**Output:** `full_projected.proj.eigenvec` contains the projected PC scores (with family and individual IDs). The reference PCs are in `unrelated_pca.eigenvec`.

**Note:** Only SNPs shared between the reference and target datasets contribute to projection. Projected PCs account for population structure, but do not themselves model residual relatedness in downstream analyses.

**Reference:** [GCTA documentation — PC loading and projection](https://yanglab.westlake.edu.cn/software/gcta/).
