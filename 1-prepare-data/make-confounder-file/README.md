


# Generating confounder files

This code generates two confounders files:

- confounders-all.csv: age,sex and first 40 genetic PCs, used for follow-up sensitivity analysis.
- confounders-main.csv: age, sex and first 10 genetic PCs, used for MR-pheWAS and main follow-up analysis.

## 1. Make file containing phenotypic confounders.

Find the column numbers of each confounder variable in the phenotype file:

```bash
head -n 1 ${PROJECT_DATA}/phenotypes/derived/data.21753-phesant_header.csv | sed 's/,/\n/g' | cat -n | grep 'eid'
head -n 1 ${PROJECT_DATA}/phenotypes/derived/data.21753-phesant_header.csv | sed 's/,/\n/g' | cat -n | grep 'x31_'
head -n 1 ${PROJECT_DATA}/phenotypes/derived/data.21753-phesant_header.csv | sed 's/,/\n/g' | cat -n | grep 'x21022_'
```

Extract the confounders from the phenotypes file, using the column numbers found in step 1:

```bash
cut -d',' -f 1,9,7075 ${PROJECT_DATA}/phenotypes/derived/data.21753-phesant_header.csv > ${PROJECT_DATA}/phenotypes/derived/data.21753-phesant_header-confounders.csv
```


## 2. Combine the genetic and phenotypic confounders into a single file.

```bash
Rscript makeConfounderFile.r
```

## 3. Make confounder file for main analysis

```bash
cut -d, -f1-13 ${PROJECT_DATA}/confounders/confounders-all.csv > ${PROJECT_DATA}/confounders/confounders-main.csv
```

