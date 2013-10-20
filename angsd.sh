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


# #covert vcf file to bim file
cat data/recalibrated.filtered.passed.repeatmasked.vcf | awk -v OFS="\t" '$1!~/^#/ && length($5)==1 {print $1,".",".",$2,$4,$5}' | uniq > data/angsd/snps.bim 

# #Conduct likelihood ratio test and call SNPs
/apps/MikheyevU/popgen/angsd/angsd -filter data/angsd/snps.bim -ref $ref -doAsso 1 -yBin data/angsd/cases.txt -bam data/angsd/both.txt -out data/angsd/association.txt -doMaf 2 -GL 4 -doCounts 1 -doMajorMinor 4 -minLRT 24 -doSNP 1 -nThreads 12

# # Calculate allele frequencies, genotype frequencies for modern and old bees, using reference allele as major

/apps/MikheyevU/popgen/angsd/angsd -filter data/angsd/snps.bim -ref $ref -bam data/angsd/old.txt -out data/angsd/old -doGeno 32 -doPost 1 -doMaf 2 -doMajorMinor 4 -GL 4 -doCounts 1 -nThreads 12

/apps/MikheyevU/popgen/angsd/angsd -filter data/angsd/snps.bim -ref $ref -bam data/angsd/modern.txt -out data/angsd/modern -doGeno 32 -doPost 1 -doMaf 2 -doMajorMinor 4 -GL 4 -doCounts 1 -nThreads 12


