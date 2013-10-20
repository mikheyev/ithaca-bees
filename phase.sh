#!/bin/bash
#$ -q long
#$ -j y
#$ -cwd
#$ -N bee_phase
#$ -l h_vmem=22G
#$ -l virtual_free=22G
. $HOME/.bashrc

export TEMPDIR=/genefs/MikheyevU/temp
export TEMP=/genefs/MikheyevU/temp
export TMP=/genefs/MikheyevU/temp

old_IFS=$IFS
IFS=$'\n'
a=(`cat data/beagle/groups.txt`)
IFS=$old_IFS
f=${a[$SGE_TASK_ID-1]}

java  -Djava.io.tmpdir=/genefs/MikheyevU/temp  -Xmx20000m  -jar /apps/MikheyevU/sasha/beagle_phase/b4.r1128.jar gtgl=data/ithaca_uniq.vcf chrom=$f out=data/beagle/$f
