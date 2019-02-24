#!/bin/bash
#PBS -l walltime=360:00:00,nodes=1:ppn=4
#PBS -o output-all166
#PBS -e errors-all166
#---------------------------------------------

cd $PBS_O_WORKDIR

module add languages/R-3.3.1-ATLAS

date

dataDir="${HOME}/2017-PHESANT-smoking-interaction/data/"
resultsDir="${HOME}/2017-PHESANT-smoking-interaction/results/results-21753/results-main-all-PHESANTv0_17-fromsaved/"
confFile="${dataDir}confounders/confounders-main.csv"
expFile="${dataDir}snp/snp-withPhenIds-subset.csv"
phenodir="${dataDir}phenotypes/derived/PHESANTv0_17-derived/"

part=166
np=200

cd ..
Rscript testFromSaved.r --userId="eid" --traitofinterest="rs16969968" --resDir=${resultsDir} --partIdx=${part} --numParts=${np} --confounderfile=${confFile} --phenoDir=${phenodir} --traitofinterestfile=${expFile}

date
