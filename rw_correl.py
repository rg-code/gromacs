#!/usr/bin/python
import sys

# Number values per line
nval=21

# Read dimension from first line
line=sys.stdin.readline()
line1=line.split()
dimension=int(line1[0])

# Generate correlation matrix
correl=[]
for i in range(dimension):
    correl.append([])
    for j in range(dimension):
        correl[i].append(0.0)
        
# Read in all the correlation matrix 
i=0
j=0
count=0
linecount=0
finalline=(dimension*dimension)/nval+1

while 1:
    # Read in chunk of nval values
    line=sys.stdin.readline()
    values=line.split()
    linecount+=1

    # Adjust range if we just read in last row
    if linecount==finalline:
        nvalues=(dimension*dimension)%nval
    else:
        nvalues=nval
    # Put these values into the array
    # print linecount, finalline, nvalues, count
    for ival in range(nvalues):
        correl[i][j]=float(values[ival])
        j+=1
        if (j==dimension):
            i+=1
            j=0
        count+=1
    if count==(dimension*dimension):
        break

# Test diagonal values
for i in range(dimension):
    if abs(correl[i][i]-1.0)>0.0000001:
        print "Trouble correl[%d][%d]=%f"%(i,i,correl[i][i])

# Write out square matrix to file
fo=open("corr_matrix.dat","w")
for i in range(dimension):
    print>>fo,"%4i"%(i+1),
    for j in range(dimension):
        print>>fo,"%6.4f"%(correl[i][j]),
        # Check the values above threshold
        #print returned values above threshold and 5 elements away from diagonal
        if (correl[i][j] > 0.80) and (correl[i][j] != 1) and (j > i+3):
            print "%6.4f"%correl[i][j], i+1+13, j+1+13, j-i
            #print i+1+13, j+1+13
    print>>fo,""
fo.close()        
