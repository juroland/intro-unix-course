#!/bin/bash

function fibonacci ()
{
    if [ $1 -le 2 ]
    then
	echo 1
    else
	echo $(( $( fibonacci $(($1-2)) ) + $( fibonacci $(($1-1)) ) ))
    fi
}

for i in {1..12}
do
    echo $(fibonacci $i)
done
