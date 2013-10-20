import sets,sys

file1 = open(sys.argv[1])
file2 = open(sys.argv[2])

file1.next()
file2.next()

f1 = set([])

for line  in file1:
    line = line.split()
    f1.add(line[0]+"\t"+line[1])

f2 = set([])

for line  in file2:
    line = line.split()
    f2.add(line[0]+"\t"+line[1])

both = f1 & f2
for i in open("data/angsd/snps.bim"):
    if i.split()[0]+"\t"+i.split()[3] in both:
        print i.split()[0]+"\t"+i.split()[3]

