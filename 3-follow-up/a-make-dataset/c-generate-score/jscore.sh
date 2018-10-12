#!/bin/bash
#PBS -l walltime=4:00:00,nodes=1:ppn=1
#PBS -o output-score.file
#---------------------------------------------

date

cd $PBS_O_WORKDIR


# make score
Rscript generateScore.R


# Add phenotype IDs to SNP score file - the user IDs in the genetic data files will be different to the user IDs in the phenotype file, so we use a bridging file supplied by UK Biobank to map between them.
matlab -r 'mapIds'


date



