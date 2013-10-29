#!/bin/bash
#$ -q long
#$ -j y
#$ -cwd
#$ -l h_vmem=4G
#$ -l virtual_free=4G
#$ -N cluster
. $HOME/.bashrc
export TEMPDIR=/genefs/MikheyevU/temp
export TMPDIR=/genefs/MikheyevU/temp
export TEMP=/genefs/MikheyevU/temp
export TMP=/genefs/MikheyevU/temp



ref=../ref/amel4.5.fa 
#convert VCF to beagle format
# /apps/MikheyevU/popgen/angsd/angsd -ref $ref -GL 1 -out data/angsd/genolike2 -filter data/angsd/snps.bim -nThreads 10 -doGlf 2 -doMajorMinor 3  -doMaf 2 -bam data/angsd/both.txt

MAXMEM=3
alias GA="java -Xmx"$MAXMEM"g -Djava.io.tmpdir=/genefs/MikheyevU/temp -jar /apps/MikheyevU/sasha/GATK/GenomeAnalysisTK.jar"

GA \
   -T ProduceBeagleInput \
   -R $ref \
   -V data/ithaca.vcf \
   -o data/ithaca.bgl

   pigz data/ithaca.bgl
