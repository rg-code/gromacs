#!/bin/python
import csv
mat = open("correl.dat", "rb")
lines = csv.reader(mat, delimiter=" ")
table = [row for row in lines]
x=len(table)
print x
k=1
l=10
nlist = []
glist = []
for i in range(x):
	#print i
	y=len(table[i])
	print y
	for j in range(y):
		if table[i][j]== "1":
			#print j
			#print table[i].index(table[i][j])
			while k <= 5:	
				nlist.append(table[i][j+k])
				k=k+1
				print nlist
				#break
				#while l >= 5:
				#nlist.append(table[i][j-l])
				#l=l-1
				#print nlist
				#glist.extend(table[i][j])
			#print nlist 
			#print table[i][j-1]

			#print k
			#if j==1:
			#k=k+5
			#print j
			#for l in range(k)
			#for k in table[i]:
			#if k == "1":
			#	print 'bingo'
				#for l in table[j]:
				#print 'x'
			#print table[i]


