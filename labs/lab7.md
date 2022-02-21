# Shell programming (BASH)

The shell is not only an interactive command interpreter, but also a programming language, where
each statement runs a command. Therefore, it's worth noting that spaces are often mandatory, because
they are needed to separate arguments. In other words, this language is said *whitespace sensitive*.

## Shell variables
Several variables are set by the shell. For example, the variable `PATH` is a colon-separated list
of directories in which the shell searches for commands. You can obtain the value of this variable
by prefixing its name with the symbol `$`{.bash}. The value of this variable is displayed with the
command `echo $PATH`{.bash}. What is the value of the variables `PWD`, `HOME`, and `HISTFILE`?

New variables can be created by assigning them values. For instance, a variable `myvar` can be
declared like this: `myvar="Some string"`{.bash} (*without spaces around the* `=`).

Try and explain the following commands:

* `echo "Value: $myvar"`{.bash}
* `echo 'Value: $myvar'`{.bash}
* `echo "Value: $myvars"`{.bash}
* `echo "Value: ${myvar}s"`{.bash}
* `echo 'one  two'  '3  4'`{.bash}
* `echo  one  two    3  4`{.bash}
* `echo ${myvar/Some/A}`{.bash}
* `str="ABC ABC"; echo ${str//ABC/123}`{.bash}
* `echo ${myvar:4}`{.bash}
* `echo ${myvar:0:7}`{.bash}
* `echo ${myvar:4:2}`{.bash}
* `echo ${#myvar}`{.bash}

What is the difference between single (`'`) and double quotes (`"`) ?

## Shell program

Copy the following shell program in a file called `name.sh`.

```bash
#!/bin/bash
# UNIX scripts start with a shebang (also called a hashbang) line
# which tells the system how to execute it

echo "What's your name?"
read name
echo "Hello $name !"
```

Add the execution permission to this file and execute this script with the command `./name.sh`.
Explain this program.

\newpage

Like any other programs, a shell program can be executed with arguments. The following variables
give access to the program arguments:

* `$#`{.bash} : the number of arguments
* `$0`{.bash}, `$1`{.bash}, `$2`{.bash},..., `$9`{.bash}, `${10}`{.bash},... : arguments
* `$*`{.bash} : all the arguments

Write a shell program `arguments.sh` that leads to the following output:

```
$ ./arguments.sh Hello World !
3
World
Hello World !
$ ./arguments.sh 13 178 21 89
4
178
13 178 21 89
$ ./arguments.sh 42
1

42
```

## Command substitution
When a command is surrounded by back quotes, it is executed by the shell. In other words, ``
`command` ``{.bash} is replaced by the standard output of the command. Its main purpose is to store
its output in a variable. For example, ``dir_listing=`ls -l` ``{.bash} assign the output of `ls -l`
to `dir_listing`. This is equivalent to `dir_listing=$(ls -l)`{.bash}.

## The `for` statement

The syntax of the `for` command is:

```
for var in list of words
do
    commands
done
```

You can also write this command all on one line :
```
for var in list; do commands; done
```

Try and explain the following program :

```bash
#!/bin/bash

count=1
for i in *.txt
do
    echo $count : $i
    count=`expr $count + 1`
done
```

where `*.txt` is all the files with the extension `.txt` in the current directory (you can try `echo
*.txt`) and the `expr` command evaluates the expression `$count + 1` (see, `man expr` for more
details) -- pay attention to the back quotes around `expr $count + 1`.

The line ```count=`expr $count + 1` ```{.bash} is equivalent to:

* `count=$(expr $count + 1)`
* `count=$(($count + 1))`

Write a shell program `sum.sh` that computes the sum of all arguments with odd index (if `myvar` is
initialized with `myvar=7`, then `echo ${!myvar}` is equivalent to `echo $7`). For this purpose, use
the command `seq` to print a sequence of numbers (for example, `seq 2 3 17` prints all the numbers
from 2 to 17, in steps of 3).

## The `case` statement

The syntax of the case statement is:
```
case word in
pattern)  commands ;;
pattern)  commands ;;
...
esac
```

This statement compares `word` to the `patterns` and performs the commands associated with the first
pattern that matches.

Try and explain the following program:

```bash
case $1 in
jan*|Jan*) m=1;;
feb*|Feb*) m=2;;
mar*|Mar*) m=3;;
apr*|Apr*) m=4;;
may*|May*) m=5;;
jun*|Jun*) m=6;;
jul*|Jul*) m=7;;
aug*|Aug*) m=8;;
sep*|Sep*) m=9;;
oct*|Oct*) m=10;;
nov*|Nov*) m=11;;
dec*|Dec*) m=12;;
*) m=0;;
esac

echo $m
```

Write a shell program `case.sh` (with a case statement) that leads to the following output:

```
$ ./case.sh 4
even number
$ ./case.sh 5
odd number
```

## The `test` command

The command `test EXPRESSION` returns an *exit status* equals to 0 if the `EXPRESSION` is evaluated
to "true"; non-zero otherwise. Like other commands, the exit status is stored in the variable `$?`.
Try and explain the following commands:

* `test "one" = "one"; echo $?`{.bash}
* `test "one" = "one" -o "two" = "owt"; echo $?`{.bash}
* `test ! \( "one" = "one" -a "two" != "owt" \); echo $?`{.bash}
* `test 3 -lt 4; echo $?`{.bash}
* `test 3 -eq 4; echo $?`{.bash}
* `test 3 -gt 4; echo $?`{.bash}

This command can also be used to check file types, file permissions, and to compare files
(modification date, i-node number,...). Create a file `file1` and a directory `dir1` in your home
directory. Try and explain the following commands:

* `test -f $HOME/file1`{.bash}
* `test -d $HOME/dir1`{.bash}
* `test -d dir1`{.bash}
* `test -d file1`{.bash}
* `test -r file1`{.bash}
* `test -w $HOME`{.bash}

Please refer to the man pages for more information about this command (`man test`).

# The `if` statement

The `if` statement runs commands based on the *exit status* of a command. 

```bash
if command
then
    # commands if condition true
else
    # commands if condition false
fi
```

Try and explain the following program (the `tr` command translate or delete characters -- `man tr`):

```bash
if test $# -eq 0
then
    echo "File name is required"
else
    for i in $*
    do
        newname=`echo $i | tr "[a-z]" "[A-Z]"`
        mv $i $newname
    done
fi
```

Instead of using the `test` command, you can call this command implicitly with the use of the double
square brackets. For example:

```bash
if [ $grade -lt 15 ] && [ $grade -gt 10 ]
then
    echo "..."
fi

if [ "one" = "one" -a "two" != "owt" ]
then
    echo "..."
fi
```

You can also write these commands all on one line :

```bash
if [ $grade -lt 15 ] && [ $grade -gt 10 ]; then echo "..."; fi

if [ "one" = "one" -a "two" != "owt" ]; then echo "..."; fi
```

## The `while` and `until` loops

The syntax of the `while` and `until` loops are the following:

```bash
while command
do
    # loop body executed as long as command
    # returns true
done

until command
do
    # loop body executed as long as command
    # returns false
done
```
## Exercises 

1. Create a simple shell program to list all the directories found in a given directory. You will
   assume that the base directory will be given as a shell script argument. You will limit the
   search to the directory itself not to sub-directories. Specific tests should be done to handle
   errors.

1. Modify the previous program to display a long list if the option `-l` is given to your script.
   This option can be given in the first or in the second place.

## Functions

A bash function can be defined as follows:

```bash
function foo ()
{
        echo $*
        echo $0
        echo $1
        echo $2
        echo $#
        x="some value"
        local y="42"
        return 12
}
```

where this function can be called as follows (try and explain this program):

```bash
    name=67
    foo "one two" $name
    echo $?
    result=$(foo "one two" $name)
    echo $result
    echo "x :" $x
    echo "y :" $y
```

1. Create a bash function that computes the *n-th* Fibonacci number. The
   recurrence relation is $F_n = F_{n-1} + F_{n-2}$, with $F_1 = 1$ and $F_2 =
   1$.

1. Write a shell script (without the use of command `rev`) inverting a number given as an argument
   to the script. For example, assuming the script is called `reverse.sh`, if you type `./reverse.sh
   123` the result displayed is `321`.

1. The shell language doesn't allow you to perform floating point arithmetic evaluations. Using
   basic shell features and the `bc` command find a way to add two floating point numbers given as a
   shell script arguments.

1. Another possible syntax for the `for` loop is the one used in the C language. For example:
```bash
    n=10
    for (( i=$n-1; i >= 0; i-- ))
    do
        echo $i
    done
```
Check it out in the man page (`man bash`, section *Compound Commands*) and write a script taking an
integer between 5 and 10 as an argument and displaying a full triangle on the display. For example,
if the script is called `triangle.sh`, then the result of `./triangle.sh 6` should display :

    ```
               .
    
              . .
    
             . . .
    
            . . . .
    
           . . . . .
    
          . . . . . .
    ```

1. Modify the previous script so that the integer is interactively asked to the user. The `read` command should be used to read information from the keyboard.
1. Explain what the following script does. What is the purpose of the tee command ?
    ```BASH
    #!/bin/bash
    
    DIRNAME=$1
    FILETYPE=$2
    LOGFILE=logfile
    
    file "$DIRNAME"/* | grep "$FILETYPE" | tee $LOGFILE | wc -l
    
    exit 0
    ```
1. Explain what the following pipeline does.
```BASH
while read LINE; do echo $LINE; done | tr '[:lower:]' '[:upper:]'
```
1. Based on the use of `tail -f` write a script that given a file as only argument print the message "a new line is written in this file" followed by the value of a counter incremented each time this line is printed.
1. Based on `who`, `grep`, and `sleep` commands, write a script named `watchfor.sh` that takes a user as single argument and waits until this user is logged in.
1. Based on commands such as `who`, `diff`, `sleep`, and `sed`, write a script named `watchwho.sh` used to
   watch all peaple logging in and out. For example,
```
   $./watchwho.sh
   in  :  julien   tty7         2018-03-14 12:52 (:0)
   in  :  alan     pts/19       2018-03-14 17:03
   out :  alan     pts/19       2018-03-14 17:03
   in  :  alan     pts/19       2018-03-14 17:04
   in  :  alice    pts/20       2018-03-14 17:05
   out :  alan     pts/19       2018-03-14 17:04
```
1. Write a script that copies itself to a file `FILENAME_backup.sh` each time it is executed.
1. Based on the use of the `expr` command, write a script that determines if all arguments passed to it are integers. This script has to return the exit status 0 in case of success and 1 otherwise.
