#!/bin/bash
#$ -q genomics
#$ -j y
#$ -cwd
#$ -l h_vmem=30G
#$ -l virtual_free=30G
#$ -N sfs
. $HOME/.bashrc
export TEMPDIR=/genefs/MikheyevU/temp
export TMPDIR=/genefs/MikheyevU/temp
export TEMP=/genefs/MikheyevU/temp
export TMP=/genefs/MikheyevU/temp
###call sfs samples

a=(old modern)
base=${a[$SGE_TASK_ID-1]}

/apps/MikheyevU/popgen/angsd/angsd -anc ../ref/amel4.5.fa -nThreads 12 -bam data/angsd/old.txt -GL 1 -doCounts 1 -out data/angsd/$base -realSFS 1 

