#!/bin/bash
#$ -q long
#$ -j y
#$ -cwd
#$ -N ahb
#$ -l h_vmem=30G
#$ -l virtual_free=30G

. $HOME/.bashrc

vcftools --vcf data/recalibrated.filtered.passed.vcf --weir-fst-pop data/vcftools/ahb.txt --weir-fst-pop data/vcftools/ehb.txt

#cat *.weir.fst |awk -v OFS="\t" '$3=="1"' > data/vcftools/african.txt

#vcftools --vcf data/recalibrated.filtered.passed.vcf  --positions data/vcftools/african.txt --weir-fst-pop data/vcftools/died.txt --weir-fst-pop data/vcftools/living.txt