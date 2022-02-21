#!/bin/bash

if [ $# -ne 2 ]
then
    echo "Provide two arguments"
    exit 1
else
    echo "$1+$2" | bc
fi
