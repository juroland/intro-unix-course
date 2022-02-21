#!/bin/bash

total=0
for i in $(seq 1 2 $#)
do
    total=$(($total + ${!i}))
done

echo $total
