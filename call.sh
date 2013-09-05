#!/bin/bash
#$ -q long
#$ -j y
#$ -cwd
#$ -N bee_hct
#$ -l h_vmem=4G
#$ -l virtual_free=4G

. $HOME/.bashrc

export TEMPDIR=/genefs/MikheyevU/temp
export TEMP=/genefs/MikheyevU/temp
export TMP=/genefs/MikheyevU/temp
MAXMEM=3

ref=../ref/amel4.5.fa
alias GA="java -Xmx"$MAXMEM"g -Djava.io.tmpdir=/genefs/MikheyevU/temp -jar /apps/MikheyevU/sasha/GATK/GenomeAnalysisTK.jar"
alias picard="java -Xmx"$MAXMEM"g -Djava.io.tmpdir=/genefs/MikheyevU/temp -jar /apps/MikheyevU/picard-tools-1.66/"

old_IFS=$IFS
IFS=$'\n'
#a=($(cat data/scaffolds.txt))
a=($(cat data/scaffolds_long.txt))
IFS=$old_IFS
limit=${a[$SGE_TASK_ID-1]}

GA -nct 1 \
    -T HaplotypeCaller\
    -R $ref \
    -I data/merged.recal.bam \
    $limit \
    -A QualByDepth -A RMSMappingQuality -A FisherStrand -A HaplotypeScore -A InbreedingCoeff -A MappingQualityRankSumTest -A Coverage -A ReadPosRankSumTest -A BaseQualityRankSumTest -A ClippingRankSumTest \
    --genotyping_mode DISCOVERY \
    --heterozygosity 0.005 \
    -o data/16/$SGE_TASK_ID.vcf
#    -o data/variants/$SGE_TASK_ID.vcf


