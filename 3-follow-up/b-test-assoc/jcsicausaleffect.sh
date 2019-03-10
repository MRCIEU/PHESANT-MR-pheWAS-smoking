#!/bin/bash
#PBS -l walltime=4:00:00,nodes=1:ppn=1
#PBS -o output-csi-causalestimate-boots.file
#PBS -t 1-10
#---------------------------------------------

date

cd $PBS_O_WORKDIR

module add apps/stata15

ix=${PBS_ARRAYID}

ixStart=$((ix*100-99))
ixEnd=$((ixStart+100-1))

stata -b csiCausalEstimateBootstaps.do $ixStart $ixEnd

date



