import pdb
"""intersect old and modern allele frequencies, switching major allele as necessary"""
#read mafs
old = {}
for line in open("data/angsd/old.mafs"):
    line = line.split()
    old[line[0]+":"+line[1]] = {'major':line[2],'freq': line[5],'minor':line[3],'n' : line[6]}

infile = open("data/angsd/modern.mafs")
infile.next()
print "chrom,pos,major,minor,old_freq,modern_freq,old_ind,modern_ind"
for line in infile:
    line = line.split()
    marker = line[0]+":"+line[1]
    major = line[2]
    minor = line[3]
    if marker in old:
        #switch major allele frequencies if major alleles don't match
        if major != old[marker]['major']:
            if  minor == old[marker]['major']:
                modern_freq = str(1-float(line[5]))
                pdb.set_trace()
            else:
                continue
        elif major == old[marker]['major']:
            modern_freq = line[5]
        print ",".join(marker.split(":") + [old[marker]['major'], old[marker]['minor'], old[marker]['freq'],modern_freq,old[marker]['n'],line[6]])
        del old[marker]
infile.close()