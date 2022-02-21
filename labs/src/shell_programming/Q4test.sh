#!/bin/bash

echo "What number ? "
read x
if [ $x -ge 5 -a $x -le 10 ]; then
    for (( i=1 ; i <= $x ; ++i )); do
        for (( k=1 ; k <= $x-$i ; ++k )); do
            printf ' '
        done
        for (( k=1 ; k <= $i ; ++k )); do
            printf '. '
        done
            printf '\n'
    done
fi
