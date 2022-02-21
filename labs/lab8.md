% Shell Script Assignment

# Questions

1. Create a shell program to list all the directories found in a given directory. You will
   assume that the base directory will be given as a shell script argument. You will limit the
   search to the directory itself not to sub-directories. You can used the command `basename`
   in order to keep only the last component of the path. Specific tests should be done to handle
   errors. Save this script as `Q1.sh`. For example (where the `$` symbol stands for the prompt) :
```
   $ ./Q1.sh /var/log
   apt
   cups
   dist-upgrade
   upstart
   $ echo $?
   0
   $ ./Q1.sh
   Usage : ./Q1.sh directory
   $ echo $?
   1
   $ ./Q1.sh ../abc
   Expected a directory, got : ../abc
   $ echo $?
   1
```
1. Create a bash function that computes the Stirling numbers of the second kind
   (see, [here](https://en.wikipedia.org/wiki/Stirling_numbers_of_the_second_kind)). This function can be easily implimented by considering the recurrence relation. Save this script as `Q2.sh`.
```
    $ source Q2.sh
    $ for n in {0..6}; do
        for k in {0..6}; do
            echo -n `stirling $n $k`
            echo -n ' '
        done
        echo
    done
    1 0 0 0 0 0 0
    0 1 0 0 0 0 0
    0 1 1 0 0 0 0
    0 1 3 1 0 0 0
    0 1 7 6 1 0 0
    0 1 15 25 10 1 0
    0 1 31 90 65 15 1
```
1. Write a shell script inverting a number given as an argument to the script. Save this script
   as `Q3.sh`. For example, if you type `./Q3.sh 34157815` the result displayed is `51875143`.
