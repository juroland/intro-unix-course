#!/bin/bash

len=${#1}
reverse=""
for (( i=$len-1; i >= 0; i-- ))
do
    reverse="$reverse${1:$i:1}"
done

echo $reverse

reverse=""
i=$(($len - 1))

while [ $i -ge 0 ]
do
    reverse="$reverse${1:$i:1}"
    i=$(($i - 1))
done

echo $reverse
