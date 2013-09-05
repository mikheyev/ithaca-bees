#!/bin/bash
#$ -q long
#$ -j y
#$ -cwd
#$ -N align
#$ -l mf=30G
. $HOME/.bashrc
a=(./*_1.fastq.gz)
b=(./*_2.fastq.gz)
base=$(basename ${a["SGE_TASK_ID"-1]} "_1.fastq.gz")
f=${a["SGE_TASK_ID"-1]}
r=${b["SGE_TASK_ID"-1]} 
bowbase=../ref/amel4.5
ref=../ref/amel4.5.fa
export TEMPDIR=/genefs/MikheyevU/temp
export TEMP=/genefs/MikheyevU/temp
export TMP=/genefs/MikheyevU/temp

alias GA="java -Xmx5g -jar /apps/MikheyevU/sasha/GATK/GenomeAnalysisTK.jar"

#bowtie2 -p 12 --sam-rg ID:$base --sam-rg LB:Truseq --sam-rg SM:$base --sam-rg PL:ILLUMINA \
#     -x $bowbase -1 $f -2 $r | samtools view -Su  - | novosort -t /genefs/MikheyevU/temp -i -o $base.bam -



#GA \
#    -nt 12 \
#   -I $base.bam \
#   -R $ref \
#   -T RealignerTargetCreator \
#   -o $base"_IndelRealigner.intervals" 

GA  \
   -I $base.bam \
   -R $ref \
   -T IndelRealigner \
   -targetIntervals $base"_IndelRealigner.intervals" \
   --maxReadsInMemory 1000000 \
   --maxReadsForRealignment 100000 \
   -o $base.realigned.bam




