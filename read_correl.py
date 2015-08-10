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
        if (correl[i][j] > 0.85) and (correl[i][j] != 1):
            print correl[i][j], i,j
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
        
        #for z in range(dimension):
         #   if correl[i+z][j+z] >0.85:
          #      print "k"
           #     z+=1   
# Print a couple values
#print correl[2071][2071], correl[dimension-20][dimension-24]
#print  %((correl[dimension -2][dimension-20]), (correl[dimension-4][dimension-12]))
#print "All done"
    
