from Bio.SeqRecord import SeqRecord
from Bio import SeqIO
import os,pdb

#ref=SeqIO.to_dict(SeqIO.parse("/genefs/MikheyevU/sasha\ genefs/hbee/ref/amel4.5.fa","fasta"))

#read mafs
old = {}
for line in open("data/angsd/old.mafs"):
    line = line.split()
    old[line[0]+":"+line[1]] = {'major':line[2],'freq': line[5],'minor':line[3]}

modern = {}
for line in open("data/angsd/modern.mafs"):
    line = line.split()
    modern[line[0]+":"+line[1]] = {'major':line[2],'freq': line[5]}

outfile = open("data/haplotypes.bed","w")
for line in open("data/beagle/all.all.bgl.pval"):
    line = line.split()
    if line[0] == 'Marker' or float(line[-1]) >= 0.05:
        continue
    #only do pseudomarkers
    if len(line[1].split(".")) > 1:
        parent,allele = line[1].split(".")
    else:
        continue
    chrom = line[0].split(":")[0]
    marker = line[0]
    if (marker not in old) or (marker not in modern):
        continue

    # find the longest haplotype associated with the trait  
    os.system("java -Xmx4G -jar ./cluster2haps.jar maxhaps=20000 out=data/beagle/c2h/"+line[0]+ " dag=data/beagle/"+\
        chrom+"."+chrom+".bgl.dag.gz phased=data/beagle/"+chrom+".bgl trait=population marker="+line[0]+" parent="+parent+\
               " allele="+allele)    
    # os.system("java -Xmx1G -jar /apps/MikheyevU/sasha/beagle_phase/cluster2haps.jar maxhaps=200 out=data/beagle/c2h/"+line[0]+ " dag=data/beagle/"+\
    #     chrom+"."+chrom+".bgl.dag.gz phased=data/beagle/"+chrom+".bgl trait=population marker="+line[0]+" parent="+parent+\
    #            " allele="+allele)
    #parse output and collect the longest haplotype
    infile= open("data/beagle/c2h/"+line[0])
    infile_name = line[0]
    topmarkers = []
    for line in infile:
        line=line.split()
        if line  and line[0]=="Markers:":
            topmarkers = line[1:]
            line = infile.next().split()
            while not line or line[0]!="allele":
                topmarkers = topmarkers+line
                line=infile.next().split()
            line=infile.next().split()
            pval = 1
            while line:
                if float(line[-1]) < pval:
                    pval=float(line[-1])
                    haplotype=line[0:-4]
#                    print line
                line=infile.next().split()
#            print topmarkers,haplotype,pval
    #sort markers, and output bed file with old and modern markers
    if topmarkers:
        topmarkers = map(lambda x: int(x.split(":")[1]),topmarkers)
    else: 
        continue
    topmarkers.sort()
    if old[marker]['major'] != modern[marker]['major']:
        modern_freq = str(1-float(modern[marker]['freq']))
    else:
        modern_freq = modern[marker]['freq']
    #write coordinates of haplotype, and information on major allele, minor allele, and frequency of minor allele
    outfile.write("\t".join([chrom,str(topmarkers[0]),str(topmarkers[-1]),\
         old[marker]['major'] + ","  + old[marker]['minor'] + ":" + old[marker]['freq'] + "," + modern_freq])+"\n")
    print "\t".join([chrom,str(topmarkers[0]),str(topmarkers[-1]),\
         old[marker]['major'] + ","  + old[marker]['minor'] + ":" + old[marker]['freq'] + "," + modern_freq])+"\n"
    #write haplotype into vcf and fasta
    infile.close()
outfile.close()
    # outfile = open("data/beagle/c2h/"+infile_name+".vcf","w")
    # outfile.write("##fileformat=VCFv4.1\n")
    # start = int(topmarkers[0].split(":")[1])
    # end = int(topmarkers[-1].split(":")[1])+1
    # for pos,base in zip(topmarkers,haplotype):
    #     chrom=pos.split(":")[0]
    #     locus=int(pos.split(":")[1])
    #     outfile.write("%s\t%s\t.\t%s\t%s\t.\t.\t\n" % (chrom,locus,ref[chrom].seq[locus],base))
    # outfile.close()
    # seqfile=open("data/beagle/c2h/"+infile_name+".fa","w")
    # newrec=SeqRecord(ref[chrom][start:end].seq)
    # newrec.id=infile_name
    # newrec.description=infile_name+"-"+str(end)
    # seqfile.write(newrec.format("fasta"))
    # seqfile.close()


    
