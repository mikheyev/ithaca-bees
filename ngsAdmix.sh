#!/bin/bash
#$ -q genomics
#$ -j y
#$ -cwd
#$ -l h_vmem=100G
#$ -l virtual_free=100G
#$ -N cluster
. $HOME/.bashrc
export TEMPDIR=/genefs/MikheyevU/temp
export TMPDIR=/genefs/MikheyevU/temp
export TEMP=/genefs/MikheyevU/temp
export TMP=/genefs/MikheyevU/temp



ref=../ref/amel4.5.fa 
#convert to beagle format

/apps/MikheyevU/popgen/NGSadmix -printInfo 1 -likes data/ithaca.bgl.gz -K 2 -P 12 -minInd 52 -outfiles data/angsd/genolike_k2_2