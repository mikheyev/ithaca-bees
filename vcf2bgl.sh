#!/bin/bash
#$ -q short
#$ -j y
#$ -cwd
#$ -l h_vmem=4G
#$ -l virtual_free=4G
#$ -N to_gprob
. $HOME/.bashrc
export TEMPDIR=/genefs/MikheyevU/temp
export TMPDIR=/genefs/MikheyevU/temp
export TEMP=/genefs/MikheyevU/temp
export TMP=/genefs/MikheyevU/temp

old_IFS=$IFS
IFS=$'\n'
a=(`cat data/beagle/groups.txt`)  #2627
IFS=$old_IFS
f=${a[$SGE_TASK_ID-1]}

#zcat data/beagle/$f.vcf.gz | java  -Djava.io.tmpdir=/genefs/MikheyevU/temp  -Xmx3000m  -jar /apps/MikheyevU/sasha/beagle_phase/vcf2gprobs.jar |gzip > data/beagle/$f.gprobs.gz

zcat data/beagle/$f.vcf.gz | java  -Djava.io.tmpdir=/genefs/MikheyevU/temp  -Xmx3000m  -jar /apps/MikheyevU/sasha/beagle_phase/vcf2beagle.jar ? $f 

mv $f*.* data/beagle/