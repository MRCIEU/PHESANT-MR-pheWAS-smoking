#!/bin/bash
#PBS -l walltime=4:00:00,nodes=1:ppn=4
#PBS -o output-snp.file
#---------------------------------------------

date

module load languages/gcc-5.0
module load libraries/gnu_builds/gsl-1.16
module load apps/qctool-2.0

chr="15"

cd $PBS_O_WORKDIR
dir="${HOME}/2017-PHESANT-smoking-interaction/data/snp/"


ddir="${UKB_DATA}/_latest/UKBIOBANK_Array_Genotypes_500k_HRC_Imputation/data/"
datadir="${ddir}dosage_bgen/"

sampleFile="${ddir}sample-stats/data.chr${chr}.sample"

# qctool -g ${datadir}ukb_imp_chr${chr}_v2.bgen -incl-rsids snp.txt -s $sampleFile -og ${dir}snp-outx${chr}.gen
qctool -g ${datadir}data.chr${chr}.bgen -incl-rsids snp.txt -s $sampleFile -og ${dir}snp-outx${chr}.gen

date


