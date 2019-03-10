

## Alternate smoking heaviness SNP rs1051730 that is in strong LD with rs16969968



## Retrieve SNP

```bash
qsub j-retrieve-snp-rs1051730.sh
```


## Process SNP

```bash
sh processGenFilesSecondSNP.sh
matlab -r mapIds_rs1051730
```


## Correlate SNPs

```bash
Rscript correlateLDSnps.r
```
