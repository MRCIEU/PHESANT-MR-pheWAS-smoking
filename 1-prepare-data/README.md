
# SNP pre-processing and creating a genetic score

The code in this directory extracts SNPs from the UK Biobank genetic data and then uses these to generate a genetic score (weighted by the effect size of each SNP on BMI)

After the following steps, the file `snp-score96-withPhenIds-subset.csv` contains the genetic risk score for the participants included in our sample (after QC).

## 1. Retrieve the correct SNP from Biobank main data

```bash
cd retrieve-snps/
qsub j-retrieve-snp.sh
```

## 2. Create dosage data from the gen format


The GEN format output from step 1 has 3 columns per person, the probability a participant has a particular genotype - GG, GA or AA.

We now convert this format into dosages, the number of A alleles a person has (strictly this is the expected value of the number of A alleles, because we are dealing with probabilities).

The following script does the following:
1) Calculate the dosages - each column is then the dosage for each participant
2) Adapts the format from column-wise to row-wise
3) Add user ID column

```bash
cd process-snps/
sh processGenFiles.sh
```

We now use the ID mapping file, that contains the mapping between the genetic participant IDs and the phenotype participant IDs, to add the phenotype IDs to this file:

```bash
matlab -r mapIds
```

## 3. Remove excluded participants (QC)

See `exclusions` directory.




## 4. Phenotype data formatting

Rename phenotypes to correct format in phenotype file column header.

These commands add a 'x' to the start of each phenotype and replaces '.' and '-' characters with '_' in the column headers of the phenotype file.

```bash
datadir="${PROJECT_DATA}/phenotypes/derived/"
origdir="${UKB_DATA_PHENO}/_latest/UKBIOBANK_Phenotypes_App_16729/data/"
head -n 1 ${origdir}data.21753.csv | sed 's/,"/,"x/g' | sed 's/-/_/g' | sed 's/\./_/g' > ${datadir}data.21753-phesant_header.csv
awk '(NR>1) {print $0}' ${origdir}data.21753.csv >> ${datadir}data.21753-phesant_header.csv
```


## 5. Make confounder file

See `make-confounder-file` directory.


## 6. Make subsamples

Make two versions of the SNP data file, one for ever and one for never smokers.

See `make-subsamples` directory.


## 7. Remove intermediate files

```bash
snpDir="${HOME}/2016-biobank-mr-phewas-bmi/data/sample500/snps/"
rm ${snpDir}snp-score96.txt
rm ${snpDir}snps-all-expected2.txt
rm ${snpDir}snps-all-expected.txt
rm ${snpDir}snp-data.txt
rm ${snpDir}snp-names.txt
rm ${snpDir}userIds.txt
rm ${snpDir}snps-all-expected2-transposed.txt
rm ${snpDir}snp-score96-withPhenIds.csv
```


## 8. Extract smoking quantity

```bash
phenoFile="${PROJECT_DATA}/phenotypes/derived/data.21753-phesant_header.csv"
head -n 1 $phenoFile | sed 's/,/\n/g' | cat -n | grep '6183_'
head -n 1 $phenoFile | sed 's/,/\n/g' | cat -n | grep '3456_'
```

```bash
cut -d, -f1,1168,4010 $phenoFile > ${PROJECT_DATA}/phenotypes/derived/data.21753-phesant_header-smokingquantity.csv
sed -i 's/"//g' ${PROJECT_DATA}/phenotypes/derived/data.21753-phesant_header-smokingquantity.csv
```



