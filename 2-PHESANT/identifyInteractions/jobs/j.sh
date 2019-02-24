#!/bin/bash
#PBS -l walltime=6:00:00,nodes=1:ppn=1
#PBS -o output
#PBS -e errors
#PBS -t 1-19
#---------------------------------------------


module add apps/stata15

date


cd $PBS_O_WORKDIR

jidx=${PBS_ARRAYID}
endidx=$((jidx*1000))
startidx=$((endidx-999))

stata -b do interactionPvalueParallel.do $startidx $endidx


date


