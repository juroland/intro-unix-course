#!/bin/bash

if [ $# -lt 1 ]
then
    echo "This script takes an integer as an argument"
    exit 1
fi

if [ $1 -lt 5 ] || [ $1 -gt 10 ]
then
    echo "The input integer has to be between 5 and 10"
    exit 1
fi

for (( i=1; i <= $1; i++ ))
do
    for (( j=1; j <= $1-$i; j++ ))
    do
	printf " "
    done

    for (( j=1; j <= $i; j++ ))
    do
	printf ". "
    done

    printf "\n"
done
