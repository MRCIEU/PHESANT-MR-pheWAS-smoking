#!/bin/bash
#PBS -l walltime=360:00:00,nodes=1:ppn=16
#PBS -o output
#PBS -e errors
#---------------------------------------------



module add languages/R-3.3.1-ATLAS

date

dataDir="${HOME}/2017-PHESANT-smoking-interaction/data/"
codeDir="${PHESANTv0_17}/WAS/"
varListDir="${PHESANTv0_17}/variable-info/"


outcomeFile="${dataDir}phenotypes/derived/data.21753-phesant_header.csv"
varListFile="${varListDir}outcome-info.tsv"
dcFile="${varListDir}data-coding-ordinal-info.txt"
resDir="${dataDir}phenotypes/derived/PHESANTv0_17-derived/"

# start and end index of phenotypes
pIdx=153
np=200

cd $codeDir
Rscript ${codeDir}phenomeScan.r --partIdx=$pIdx --numParts=$np --phenofile=${outcomeFile} --variablelistfile=${varListFile} --datacodingfile=${dcFile} --resDir=${resDir} --userId="eid" --save



date


