#!/bin/bash

i=1
while [ $i -le $# ]; do
    if [ ! `expr ${!i} + 0 2> /dev/null` ]; then
        exit 1
    fi
    i=$((i+1))
done
exit 0