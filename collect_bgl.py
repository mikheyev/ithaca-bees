from glob import glob
import pdb


sites = {}

for file in glob("data/beagle/*pval"):
	infile = open(file)
	infile.next() 
	for line in infile:
		line = line.rstrip().split()
		if line[0] not in sites:
			sites[line[0]] = line[3]
		elif sites[line[0]] < line[3]:
			sites[line[0]] = line[3]
	infile.close()

print "chrom,pos,pval"
for site in sites:
	print ",".join(site.split(":")+[sites[site]])
