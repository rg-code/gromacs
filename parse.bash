#!/bin/bash
if [ -f /home/rg/Documents/new.dat ]; then
    rm new.dat
fi

cat $1 | colrm 1 7 | colrm 9 15 >> new.dat
line=`cat new.dat`
num=$(wc -l < "new.dat")
for i in $line
do
	if [ $i -le 518 ]; then
		echo "dist mydist"", A/"$i"/CA"
	fi
	if [ $i -gt 518 ] && [ $i -le 1036 ]; then
		let b=$i-518
		echo "dist mydist"", B/"$b"/CA"
	fi
	if [ $i -gt 1036 ] && [ $i -le 1554 ]; then
		let c=$i-1036
		echo "dist mydist"", C/"$c"/CA"
	fi
	if [ $i -gt 1554 ]; then
		let d=$i-1554
		echo "dist mydist"", D/"$d"/CA"
	fi
done