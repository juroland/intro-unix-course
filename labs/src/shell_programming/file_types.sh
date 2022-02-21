#!/bin/bash

DIRNAME=$1
FILETYPE=$2
LOGFILE=logfile

file "$DIRNAME"/* | grep "$FILETYPE" | tee $LOGFILE | wc -l

exit 0