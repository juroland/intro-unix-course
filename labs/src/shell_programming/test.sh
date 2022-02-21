#!/bin/bash

grade=12

if [ $grade -lt 15 ] && [ $grade -gt 10 ]
then
    echo "grade..."
fi

if [ "one" = "one" -a "two" != "owt" ]
then
    echo "one..."
fi
