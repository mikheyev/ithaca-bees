#!/bin/bash
#$ -q long
#$ -j y
#$ -cwd
#$ -N bee_bqsr
#$ -l h_vmem=20G
#$ -l virtual_free=20G
##$ -m ea
##$ -M alexander.mikheyev@oist.jp

. $HOME/.bashrc

export TEMPDIR=/genefs/MikheyevU/temp
export TEMP=/genefs/MikheyevU/temp
export TMP=/genefs/MikheyevU/temp
MAXMEM=9

allfiles=$(for i in ../ahb_panel/*/*realigned.bam ; do echo -ne "-I" $i" "; done; \
for i in ../modern/*realigned.bam ; do echo -ne "-I" $i" "; done; \
for i in ../old2/*realigned.bam ; do echo -ne "-I" $i" "; done)

ref=../ref/amel4.5.fa
alias GA="java -Xmx"$MAXMEM"g -Djava.io.tmpdir=/genefs/MikheyevU/temp -jar /apps/MikheyevU/sasha/GATK/GenomeAnalysisTK.jar"
alias picard="java -Xmx"$MAXMEM"g -Djava.io.tmpdir=/genefs/MikheyevU/temp -jar /apps/MikheyevU/picard-tools-1.66/"

 GA \
    -nct 6 \
    -T BaseRecalibrator \
    -I $allfiles  \
    -R $ref \
    -knownSites ../ref/snps/hunt.vcf \
    -knownSites ../ref/snps/dbSNP.vcf \
    -o data/recal_data.table

 GA \
    -nct 6 \
    -T PrintReads \
    -R $ref  \
    -I $allfiles  \
    -BQSR data/recal_data.table \
    -o data/merged.recal.bam


GA \
   -nct 6 \
   -T BaseRecalibrator \
   -I data/merged.recal.bam  \
   -R $ref \
    -knownSites ../ref/snps/hunt.vcf \
    -knownSites ../ref/snps/dbSNP.vcf \
   -BQSR data/recal_data.table \
   -o data/post_recal_data.table

GA \
    -T AnalyzeCovariates \
    -R $ref \
    -before data/recal_data.table \
    -after data/post_recal_data.table \
    -plots recalibration_plots.pdf
