#!/bin/bash

if [ $# -eq 0 ]
then
    echo "Directory is required"
else
    list=1
    if [ $# -eq 2 ]; then
        if [ "$1" = -l ];  then
            list=0
            directory=$2
        elif [ "$2" = -l ]; then
            list=0
            directory=$1
        else
            echo "Arguments error!"
            exit 1
        fi
    elif [ $# -eq 1 ]; then
        directory=$1
    else
        echo "Arguments error!"
        exit 1
    fi

    if [ ! -d "$directory" ]; then
        echo "An argument has to be a directory!"
        exit 1
    else
        if [ "${directory:${#directory}-1}" != / ]; then
            directory=$directory/
        fi
        for file in "$directory"*; do
            if [ -d "$file" ]; then
                if [ $list -eq 0 ]; then
                    ls -ld "$file"
                else
                    echo $file
                fi
            fi
        done
    fi
fi
