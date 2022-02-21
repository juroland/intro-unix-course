#!/bin/bash

if test $# -eq 0
then
	echo "File name is required"
else
	for i in $*
	do
		newname=`echo $i | tr "[a-z]" "[A-Z]"`
		mv $i $newname
	done
fi	
