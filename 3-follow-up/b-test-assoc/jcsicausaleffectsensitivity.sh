#!/bin/bash
#PBS -l walltime=4:00:00,nodes=1:ppn=1
#PBS -o output-csi-causalestimate-boots-sensitivity.file
#PBS -t 1-10
#---------------------------------------------

date

cd $PBS_O_WORKDIR

module add apps/stata14


ix=${PBS_ARRAYID}

ixStart=$((ix*100-99))
ixEnd=$((ixStart+100-1))

stata csiCausalEstimateBootstapsSensitivity.do $ixStart $ixEnd

date



