#!/bin/bash
#$ -q genomics
#$ -j y
#$ -cwd
#$ -l h_vmem=50G
#$ -l virtual_free=50G
#$ -N pca
. $HOME/.bashrc
export TEMPDIR=/genefs/MikheyevU/temp
export TMPDIR=/genefs/MikheyevU/temp
export TEMP=/genefs/MikheyevU/temp
export TMP=/genefs/MikheyevU/temp


ref=../ref/amel4.5.fa 
# /apps/MikheyevU/popgen/angsd/angsd -filter data/angsd/snps.bim -anc $ref -out data/angsd/both -doGeno 32 -doPost 1 -doMaf 2 -GL 1 -doCounts 1 -nThreads 6 -realSFS 1 -bam data/angsd/both.txt -doMajorMinor 1

sites=`wc -l data/angsd/snps.bim |cut -d " " -f1`
rm data/angsd/both.covar
/apps/MikheyevU/popgen/ngsTools/bin/ngsCovar -probfile data/angsd/both.geno -outfile data/angsd/both.covar -nind 64 -nsites $sites -block_size 20000 -call 1 -minmaf 0.05    