#!/bin/bash
#$ -q genomics
#$ -j y
#$ -cwd
#$ -l h_vmem=50G
#$ -l virtual_free=50G
#$ -N fst
. $HOME/.bashrc
export TEMPDIR=/genefs/MikheyevU/temp
export TMPDIR=/genefs/MikheyevU/temp
export TEMP=/genefs/MikheyevU/temp
export TMP=/genefs/MikheyevU/temp

ref=../ref/amel4.5.fa

alias angsd="/apps/MikheyevU/popgen/angsd0.549/angsd"

chroms=(8 10)
bees=(ehb ahb)

for i in `seq 0 1`
do
    base=${bees["$i"]}
    nchr=${chroms["$i"]}

    rm data/angsd/$base.ml* data/angsd/$base.norm* data/angsd/$base.sfs* data/angsd/$base.geno* data/angsd/$base.mafs*
    rm data/angsd/snps.*bin snps.*idx

    angsd  -anc $ref -ref $ref -out data/angsd/$base -doGeno 32 -doPost 1 -doMaf 2 -GL 4 -doCounts 1 -nThreads 6 -realSFS 1 -bam data/angsd/$base.txt -doMajorMinor 4 -filter data/angsd/snps.txt -rf data/angsd/chr

    /apps/MikheyevU/popgen/angsd0.549/misc/optimSFS  -binput data/angsd/$base.sfs -nChr $nchr -outnames data/angsd/$base -nThreads 6

    /apps/MikheyevU/popgen/angsd0.549/misc/sfstools -sfsFile  data/angsd/$base.sfs -nChr $nchr -priorFile data/angsd/$base.ml -dumpBinary 1 > data/angsd/$base.norm  

done

sites=`wc -l data/angsd/snps.bim |cut -d " " -f1`

#rm data/angsd/spectrum.txt 
#/apps/MikheyevU/popgen/ngsTools/bin/ngs2dSFS  -postfiles data/angsd/ahb.norm data/angsd/ehb.norm -nind 5 4  -outfile data/angsd/spectrum.txt -relative 1  -nsites $sites  -block_size 20000

rm data/angsd/ahb_ehb.fst

/apps/MikheyevU/popgen/ngsTools/bin/ngsFST -postfiles data/angsd/ahb.norm data/angsd/ehb.norm -nind 5 4 -block_size 20000 -nsites $sites -outfile data/angsd/ahb_ehb.fst -islog 1

##/apps/MikheyevU/popgen/ngsTools/bin/ngsCovar -probfile data/angsd/old.geno -outfile pop.covar -nind 40 -nsites 100000 -block_size 20000 -call 1 -minmaf 0.05    