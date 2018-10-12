


## A. Extract SNPs

Make list of snps for qctool.

```bash
grep -v SNP CSI_genome-wideSNPs_MRBase.txt | cut -d' ' -f1 > a-retrieve-snps/snps.txt
```

Run qctool to extract snps.

In `a-retrieve-snps` directory.

```bash
qsub j-retrieve-snps.sh
```

## B. Process SNP data

In `b-process-snps` directory.

```bash
sh processGenFiles.sh
```

## C. Generate score

In `c-generate-score` directory.

```bash
qsub jscore.sh
```

## D. Exclusions

```bash
matlab -r d_doGenerateIncludedSample
```




## E. Extract and pre-process phenotype data

Extract phenotypes from UKB csv.

```bash
head -n 1 ${PROJECT_DATA}/phenotypes/derived/data.21753-phesant_header.csv | sed 's/,/\n/g' | cat -n | grep 'eid'
head -n 1 ${PROJECT_DATA}/phenotypes/derived/data.21753-phesant_header.csv | sed 's/,/\n/g' | cat -n | grep '20116'
head -n 1 ${PROJECT_DATA}/phenotypes/derived/data.21753-phesant_header.csv | sed 's/,/\n/g' | cat -n | grep '3436'
head -n 1 ${PROJECT_DATA}/phenotypes/derived/data.21753-phesant_header.csv | sed 's/,/\n/g' | cat -n | grep '2867'
head -n 1 ${PROJECT_DATA}/phenotypes/derived/data.21753-phesant_header.csv | sed 's/,/\n/g' | cat -n | grep '2897'
head -n 1 ${PROJECT_DATA}/phenotypes/derived/data.21753-phesant_header.csv | sed 's/,/\n/g' | cat -n | grep '3456'
head -n 1 ${PROJECT_DATA}/phenotypes/derived/data.21753-phesant_header.csv | sed 's/,/\n/g' | cat -n | grep '2887'
head -n 1 ${PROJECT_DATA}/phenotypes/derived/data.21753-phesant_header.csv | sed 's/,/\n/g' | cat -n | grep '40001'
head -n 1 ${PROJECT_DATA}/phenotypes/derived/data.21753-phesant_header.csv | sed 's/,/\n/g' | cat -n | grep '31_0_0'
head -n 1 ${PROJECT_DATA}/phenotypes/derived/data.21753-phesant_header.csv | sed 's/,/\n/g' | cat -n | grep '189_0_0'
head -n 1 ${PROJECT_DATA}/phenotypes/derived/data.21753-phesant_header.csv | sed 's/,/\n/g' | cat -n | grep '21000_0_0'
head -n 1 ${PROJECT_DATA}/phenotypes/derived/data.21753-phesant_header.csv | sed 's/,/\n/g' | cat -n | grep '6138_0_0'
head -n 1 ${PROJECT_DATA}/phenotypes/derived/data.21753-phesant_header.csv | sed 's/,/\n/g' | cat -n | grep '21022_0_0'
```

```bash
cut -d',' -f 1,6360,1162,1030,1039,1168,1036,9714,9,304,7059,3611,7075  ${PROJECT_DATA}/phenotypes/derived/data.21753-phesant_header.csv > ${PROJECT_DATA}/phenotypes/derived/data.21753-phesant_header-smokingscore-followup.csv
```


Extract our outcome phenotype.

```
head -n 1 ${PROJECT_DATA}/phenotypes/derived/data.21753-phesant_header.csv | sed 's/,/\n/g' | cat -n | grep '1757_0_0'
```

```bash
cut -d',' -f 1,778 ${PROJECT_DATA}/phenotypes/derived/data.21753-phesant_header.csv > ${PROJECT_DATA}/phenotypes/derived/data.21753-phesant_header-facialaging.csv
```

Pre-process phenotype data.

```bash
Rscript e-pheno-preprocess.R
```


## F. Combine data into single dataset

```bash
Rscript f-followupDataset.R
```



