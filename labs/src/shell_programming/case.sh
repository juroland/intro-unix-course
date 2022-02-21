#!/bin/bash

remainder=$(($1 % 2))

case $remainder in
0) echo "even number";;
1) echo "odd number";;
*) echo "??";;
esac
