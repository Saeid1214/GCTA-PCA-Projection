#!/usr/bin/env bash
# Calculate PCs in unrelated individuals and project onto the full sample.
set -euo pipefail

if [[ $# -lt 2 || $# -gt 3 ]]; then
  echo "Usage: bash $0 REFERENCE_PREFIX TARGET_PREFIX [NUMBER_OF_PCS]" >&2
  exit 1
fi

REF=$1
TARGET=$2
NPC=${3:-20}
OUTDIR="results"

if ! [[ "$NPC" =~ ^[1-9][0-9]*$ ]]; then
  echo "Error: NUMBER_OF_PCS must be a positive integer." >&2
  exit 1
fi
command -v gcta64 >/dev/null 2>&1 || { echo "Error: gcta64 not found in PATH." >&2; exit 1; }
for prefix in "$REF" "$TARGET"; do
  for ext in bed bim fam; do
    [[ -f "${prefix}.${ext}" ]] || { echo "Error: Missing ${prefix}.${ext}" >&2; exit 1; }
  done
done
mkdir -p "$OUTDIR"

# 1. GRM for unrelated reference individuals.
gcta64 --bfile "$REF" --autosome --make-grm --out "$OUTDIR/unrelated_grm"

# 2. Estimate reference PCs.
gcta64 --grm "$OUTDIR/unrelated_grm" --pca "$NPC" --out "$OUTDIR/unrelated_pca"

# 3. Compute SNP weights for the reference PC axes.
gcta64 --bfile "$REF" --pc-loading "$OUTDIR/unrelated_pca" --out "$OUTDIR/unrelated_snp_loading"

# 4. Project all individuals (including relatives) onto the reference axes.
gcta64 --bfile "$TARGET" --project-loading "$OUTDIR/unrelated_snp_loading" "$NPC" --out "$OUTDIR/full_projected"

echo "Finished. Projected PCs: $OUTDIR/full_projected.proj.eigenvec"
