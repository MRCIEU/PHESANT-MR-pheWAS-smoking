
# Restrict sample - QC and withdrawn consent


## 1. Generate files of exclusions from QC

We generate lists of excluded participants, where each list uses one of the following criteria:

1. Sex mismatch
2. Putative sex chromosom aneiploidy
3. Outliers in heterozygosity and and missing rates
4. non-Europeans
5. Related to another participant (up to third degree)

```bash
module add languages/R-3.3.1-ATLAS
Rscript processUKBQCFile.r
```

## 2. Create a new genetic score data file with only the participants included in our sample

This code removes all participants with genetic data not passing QC (i.e. they are in one of the subsets generated in step 1), or who have withdrawn their consent.

```bash
module add apps/matlab-r2015a
matlab -r "doGenerateIncludedSample"
```
