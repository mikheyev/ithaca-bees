#!/bin/bash
#$ -q short
#$ -j y
#$ -cwd
#$ -N pca
#$ -l h_vmem=4G
#$ -l virtual_free=4G

. $HOME/.bashrc

export TEMPDIR=/genefs/MikheyevU/temp
export TEMP=/genefs/MikheyevU/temp
export TMP=/genefs/MikheyevU/temp

# using genotype probabilites computed by angsd.sh, compute covariance matrix of genotypes

find data/angsd/both.covar -delete

/apps/MikheyevU/popgen/ngsTools/bin/ngsCovar -probfile data/angsd/both.geno -outfile data/angsd/both.covar -nind 64 -nsites 1000 -call 0 -minmaf 0.05 