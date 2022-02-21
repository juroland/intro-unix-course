#!/bin/bash

if [ $# -eq 0 ]; then
    echo "Directory is required"
    exit 1
else
    directory=$1
    if [ ! -d "$directory" ]; then
        echo "The first argument has to be a directory!"
        exit 1 # non-zero exit value means an error
    else
        if [ "${directory:${#directory}-1}" != / ]; then
            directory=$directory/
        fi

        for dir in "$directory"*; do
            if [ -d "$dir" ]; then
                echo $dir
            fi
        done
    fi
fi
