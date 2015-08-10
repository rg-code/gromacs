#!/bin/bash
if [ $# -ne 2 ]; then
    echo "This script requires 2 args, the file prefix and the ending ns "
    exit 
fi
for i in gro cpt xtc log edr; do
    if [ ! -f $1.$i ]; then
	echo "Could not find file $1.i"
	exit 1
    fi
done
if [ -f $1.ext.tpr ]; then
    cp $1.ext.tpr $1.tpr
fi
for i in gro tpr cpt; do
    cp $1.$i archive/$1.$2.$i 
done
for i in xtc log edr;  do
    mv $1.$i archive/$1.$2.$i 
done
cd archive
tar cf $1.$2.tar $1.$2.???
cd ..
tpbconv -s $1.tpr -o $1.ext.tpr -extend 10000
