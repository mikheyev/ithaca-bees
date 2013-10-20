#!/bin/bash
#$ -q long
#$ -j y
#$ -cwd
#$ -N bee_assoc
#$ -l h_vmem=15G
#$ -l virtual_free=15G

. $HOME/.bashrc

export TEMPDIR=/genefs/MikheyevU/temp
export TEMP=/genefs/MikheyevU/temp
export TMP=/genefs/MikheyevU/temp

find ./data/beagle/c2h/ -type f -delete
python c2h.py
