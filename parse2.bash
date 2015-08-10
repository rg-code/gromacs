#!/bin/bash

while read line; do
	array=($line)
	chain1=$(((${array[1]}-1)/518))
	chain2=$(((${array[2]}-1)/518))
	names=(A B C D)
	#echo ${names[$chain1]} ${names[$chain2]}
	res1=$(((${array[1]})%518))
	res2=$(((${array[2]})%518))
	#echo $res1 $res2
	echo "dist mydist, "${names[$chain1]}"/"$res1"/CA, "${names[$chain2]}"/"$res2"/CA"
done < $1