#!/bin/bash
#$ -q batch
#$ -j y
#$ -cwd
#$ -N align
#$ -l mf=40G
. $HOME/.bashrc
#SGE_TASK_ID=1
a=(./*.fq)
ref=../ref/amel4.5.fa
bowbase=../ref/amel4.5
base=$(basename ${a["SGE_TASK_ID"-1]} ".fq")
u=${a["SGE_TASK_ID"-1]} 

export TEMPDIR=/genefs/MikheyevU/temp
export TEMP=/genefs/MikheyevU/temp
export TMP=/genefs/MikheyevU/temp

alias GA="java -Xmx5g -jar /apps/MikheyevU/sasha/GATK/GenomeAnalysisTK.jar"

#bowtie2 -p 12 --sam-rg ID:$base --sam-rg LB:PCRfree --sam-rg SM:$base --sam-rg PL:ILLUMINA \
#    --very-sensitive-local -x $bowbase -U $u | samtools view -Su  - | novosort -t /genefs/MikheyevU/temp -i -o $base.bam -

#java -Xmx30g -Djava.io.tmpdir=/genefs/MikheyevU/temp -jar /apps/MikheyevU/picard-tools-1.66/MarkDuplicates.jar METRICS_FILE=$base"_duplicates.txt" ASSUME_SORTED=1 INPUT=$base".bam" OUTPUT=$base"_nodup.bam" TMP_DIR=/genefs/MikheyevU/temp VALIDATION_STRINGENCY=LENIENT REMOVE_DUPLICATES=1 COMPRESSION_LEVEL=0

#samtools index $base"_nodup.bam"

GA \
    -nt 12 \
   -I $base.bam \
   -R $ref \
   -T RealignerTargetCreator \
   -o $base"_IndelRealigner.intervals" 

GA  \
   -I $base.bam \
   -R $ref \
   -T IndelRealigner \
   -targetIntervals $base"_IndelRealigner.intervals" \
   --maxReadsInMemory 1000000 \
   --maxReadsForRealignment 100000 \
   -o $base.realigned.bam

#clean up temporary files

