# Whole-genome re-sequencing to examine genetic changes in a population of Ithaca, NY honeybees using samples collected in 1977 and 2011

This repo contains the part of the analysis that was performed on the cluster. Downstream analysis done in R and plotting in python have not yet been added.

Genomes were sequenced on an Illumina HiSeq, using genomic libraries prepared without PCR. In addition to the Ithaca samples, there were some bees included from populations in Arizona, Chiapas (Africanized) and from Hawaii, Korea and Japan (non-Africanized).

Some of the steps are parallelized on an SGE cluster.

## Workflow
The first step was to align the reads to the reference using [bowtie2](http://bowtie-bio.sourceforge.net/bowtie2/index.shtml), and then to re-calibrate alignments around indels using [GATK](http://www.broadinstitute.org/gatk/gatkdocs/org_broadinstitute_sting_gatk_walkers_variantrecalibration_ApplyRecalibration.html).
### SNP calling
#### major_split.py
- create a file of limits for GATK, corresponding to the 16 major chromosomes
#### bqsr.sh
- perform base quality recalibration using known SNP sites from NCBI and validated sites kindly provided by Greg Hunt
#### call.sh
- starting with mapped fragments, call genotypes for all samples
#### vqsr.sh
- perform variant quality score recalibration to filter low-quality SNPs

### SNP frequency measurement using [ANGSD](http://popgen.dk/wiki/index.php/ANGSD)
#### angsd.sh
- compute minor allele frequencies for old and modern populations, and conduct likelihood ratio tests for significant changes
#### intersect_mafs.py
- intersect minor allele frequency files for old and modern populations


### Imputation and association testing using [BEAGLE](http://faculty.washington.edu/browning/beagle/beagle.html)
#### vcf2bgl.sh
- convert GATK vcf to BEAGLE format
#### phase.sh
- phase genotypes and impute missing values
#### assoc.sh
- association testing on imputed haplotypes, looking for evidence of selection between old and modern populations
   - This is a parallel analysis to likelihoood ratio testing with ANGDS
##### c2h.py and c2h.sh
- extract haplotypes from BEAGLE results
### Differentiation between European and Africanized bees 
#### ahb.sh
- calculate Fst between populations with European and African ancestry using [vcftools](http://vcftools.sourceforge.net/options.html)
   - note: output files manually moved into the data directory
#### angsd_ahb.sh
- trying to compute Fst using [ngsutils](https://github.com/ngsutils/ngsutils).
   - this approach has not worked, given the different number of snp calls between samples.
   - I have given up on this for now, focusing instead on the vcftools analysis

### plotting differentiation between populations
#### angsd2bgl.sh
- generate BEAGLE-formatted data from ngs count data
#### ngsAdmix.sh
- use [NgsAdmix](http://www.popgen.dk/software/index.php/NgsAdmix) to infer ancestral population clusters
#### pca.sh
- compute covariance matrix using posterior probabilities of genotypes computed by angsd.sh




