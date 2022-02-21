#!/bin/bash

backup_filename=${0%.*}_backup.sh

cat $0 > $backup_filename

echo "hello world"