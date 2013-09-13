from Bio import SeqIO

groups = ['Group1','Group2','Group3','Group4','Group5','Group6','Group7','Group8','Group9','Group10','Group11','Group12','Group13','Group14','Group15','Group16']

increment = 10000
for rec in SeqIO.parse("../ref/amel4.5.fa","fasta"):
	if rec.id not in groups:
		continue
	start = 1
	while 1:
		if start + increment > len(rec):
			print "-L %s:%i-%i" % (rec.id, start,len(rec))
			break
		else:
			print "-L %s:%i-%i" % (rec.id, start,start+increment)
			start += increment
