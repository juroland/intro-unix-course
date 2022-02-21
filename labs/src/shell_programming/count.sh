#!/bin/bash

count=1
for i in *.txt
do
	echo $count : $i
	count=`expr $count + 1`
done
