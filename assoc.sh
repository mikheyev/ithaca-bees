#!/bin/bash
#$ -q genomics
#$ -j y
#$ -cwd
#$ -N bee_assoc
#$ -l h_vmem=55G
#$ -l virtual_free=55G

. $HOME/.bashrc

export TEMPDIR=/genefs/MikheyevU/temp
export TEMP=/genefs/MikheyevU/temp
export TMP=/genefs/MikheyevU/temp


#a=(data/beagle/*.bgl.gz)  # 2624
#f=${a[$SGE_TASK_ID-1]}
#o="data/beagle/"$(basename $f .bgl.gz)

#gunzip -c $f | head -1  > $o.bgl
#echo A population `for i in $(seq 1 32); do echo -ne "2 "; done` `for i in $(seq 1 64); do echo -ne "1 "; done` `for i in $(seq 1 32); do echo -ne "2 "; done` >> $o.bgl
#gunzip -c $f | awk 'NR>1 ' >> $o.bgl  


zcat  data/beagle/Group1.bgl.gz | head -1 > data/beagle/all.bgl
echo A population `for i in $(seq 1 32); do echo -ne "2 "; done` `for i in $(seq 1 64); do echo -ne "1 "; done` `for i in $(seq 1 32); do echo -ne "2 "; done` >> data/beagle/all.bgl
for i in data/beagle/Group*.bgl.gz ; do zcat $i | sed '1d' >> data/beagle/all.bgl; done  

java  -Djava.io.tmpdir=/genefs/MikheyevU/temp  -Xmx50000m  -jar /apps/MikheyevU/sasha/beagle_phase/beagle.jar data=data/beagle/all.bgl trait=population out=data/beagle/all
