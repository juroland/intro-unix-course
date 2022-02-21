#!/bin/bash

remainder=abcde
case $remainder in
ac*) echo "even number";;
ab*) echo "odd number";;
*) echo "??";;
esac
