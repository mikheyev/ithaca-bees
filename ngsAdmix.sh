#!/bin/bash
#$ -q genomics
#$ -j y
#$ -cwd
#$ -l h_vmem=10G
#$ -l virtual_free=10G
#$ -N cluster
. $HOME/.bashrc
export TEMPDIR=/genefs/MikheyevU/temp
export TMPDIR=/genefs/MikheyevU/temp
export TEMP=/genefs/MikheyevU/temp
export TMP=/genefs/MikheyevU/temp



ref=../ref/amel4.5.fa 
#convert to beagle format
# /apps/MikheyevU/popgen/angsd/angsd -ref $ref -GL 1 -out data/angsd/genolike2 -filter data/angsd/snps.bim -nThreads 10 -doGlf 2 -doMajorMinor 3  -doMaf 2 -bam data/angsd/both.txt

/apps/MikheyevU/popgen/NGSadmix -printInfo 1 -likes data/angsd/genolike2.beagle.gz -K 2 -P 12 -minInd 64 -outfiles data/angsd/genolike_1_k2