#!/bin/bash
#$ -q long
#$ -j y
#$ -cwd
#$ -N quality
#$ -l h_vmem=30G
#$ -l virtual_free=30G

. $HOME/.bashrc
ref=../ref/amel4.5.fa
alias GA="java -Xmx"$MAXMEM"g -Djava.io.tmpdir=/genefs/MikheyevU/temp -jar /apps/MikheyevU/sasha/GATK/GenomeAnalysisTK.jar"
alias picard="java -Xmx"$MAXMEM"g -Djava.io.tmpdir=/genefs/MikheyevU/temp -jar /apps/MikheyevU/picard-tools-1.66/"

export TEMPDIR=/genefs/MikheyevU/temp
export TEMP=/genefs/MikheyevU/temp
export TMP=/genefs/MikheyevU/temp

alias GA="java -Xmx9g -jar /apps/MikheyevU/sasha/GATK/GenomeAnalysisTK.jar"

GA \
   -T VariantRecalibrator \
   -R $ref \
   -input data/raw.vcf \
   -resource:hunt,known=false,training=true,truth=true,prior=12.0 ../ref/snps/hunt.vcf \
   -resource:conserved,known=false,training=true,truth=true,prior=10.0 ../ref/snps/dbSNP.vcf \
   -an QD -an FS -an DP -an MQRankSum -an ReadPosRankSum  -an ClippingRankSum -an BaseQRankSum -an MQ\
   -mode both \
   -recalFile data/output.recal \
   -tranchesFile data/output.tranches \
   -rscriptFile data/plots.R


GA \
  -T ApplyRecalibration \
   -R $ref \
   -input data/raw.vcf \
   --ts_filter_level 99.0 \
   -tranchesFile data/output.tranches \
   -recalFile data/output.recal \
   -mode BOTH \
   -o data/recalibrated.filtered.vcf
 
