#!/bin/bash
#$ -q long
#$ -j y
#$ -cwd
#$ -N angsd
#$ -l h_vmem=30G
#$ -l virtual_free=30G

. $HOME/.bashrc

export TEMPDIR=/genefs/MikheyevU/temp
export TEMP=/genefs/MikheyevU/temp
export TMP=/genefs/MikheyevU/temp

ref=../ref/amel4.5.fa


# Calculate allele frequencies, genotype frequencies for modern and old bees, using reference allele as major

nchr=8
base=ehb
#/apps/MikheyevU/popgen/angsd/angsd -filter data/angsd/snps.bim -anc $ref -out data/angsd/$base -doGeno 32 -doPost 1 -doMaf 2 -GL 1 -doCounts 1 -nThreads 6 -realSFS 1  -bam data/angsd/$base.txt -doMajorMinor 1

#/apps/MikheyevU/popgen/angsd0.549/misc/optimSFS -binput data/angsd/$base.sfs -nThreads 6 -nChr $nchr -outnames data/angsd/$base

/apps/MikheyevU/popgen/angsd0.549/misc/sfstools -sfsFile  data/angsd/$base.sfs -nChr $nchr -priorFile data/angsd/$base.ml -dumpBinary 1 > data/angsd/$base.norm  
