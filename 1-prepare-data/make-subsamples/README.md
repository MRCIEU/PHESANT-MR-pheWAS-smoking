


## Extract smoking status from phenotype file


We first find the column index of this smoking status field:

```bash
phenoFile="${PROJECT_DATA}/phenotypes/derived/data.21753-phesant_header.csv"
head -n 1 $phenoFile | sed 's/,/\n/g' | cat -n | grep '20116_'
```

We then extract this field from the phenotype file:

```bash
cut -d, -f1,6360-6362 $phenoFile > "${PROJECT_DATA}/phenotypes/derived/data.21753-phesant_header-20116.csv"
sed -i 's/"//g' ${PROJECT_DATA}/phenotypes/derived/data.21753-phesant_header-20116.csv
```


## Split sample by smoking status

The following script makes two separate files containing the SNP dosages, for never and ever smokers respectively.

```bash
matlab -r makeSubsamples
```
