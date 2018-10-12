#!/bin/bash
#PBS -l walltime=360:00:00,nodes=1:ppn=1
#PBS -o output2
#PBS -e errors2
#PBS -t 101-200
#---------------------------------------------



module add languages/R-3.3.1-ATLAS

date

dataDir="${HOME}/2017-PHESANT-smoking-interaction/data/"
resultsDir="${HOME}/2017-PHESANT-smoking-interaction/results/results-21753/results-main-never/"

codeDir="${PHESANT}/WAS/"
varListDir="${PHESANT}/variable-info/"

outcomeFile="${dataDir}phenotypes/derived/data.21753-phesant_header.csv"
expFile="${dataDir}snp/snp-never.csv"
varListFile="${varListDir}outcome-info.tsv"
dcFile="${varListDir}data-coding-ordinal-info.txt"
resDir="${resultsDir}"

# start and end index of phenotypes
pIdx=${PBS_ARRAYID}
np=200

# confounders
confFile="${dataDir}confounders/confounders-main.csv"

cd $codeDir
Rscript ${codeDir}phenomeScan.r --partIdx=$pIdx --numParts=$np --phenofile=${outcomeFile} --traitofinterestfile=${expFile} --variablelistfile=${varListFile} --datacodingfile=${dcFile} --traitofinterest="rs16969968" --resDir=${resDir} --userId="eid" --confounderfile=${confFile} --standardise=FALSE




date


