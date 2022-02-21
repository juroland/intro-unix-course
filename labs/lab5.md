# Filters
Standard UNIX tools such as `grep`, `tail`, `sort`, `wc`, `sed`, and `awk` are part of a family of
programs called filters. These tools perform the following three actions:

1. Read some input;
1. Perform a "simple" transformation;
1. Write some output.

In particular, `sed` and `awk` are are programmable filters with the help of an *ad-hoc* programming
language.

## ed : the "standard" UNIX editor

The program `ed` is a text editor designed in the early 1970's. This editors allows to introduce
fundamental concepts (*e.g.*, pattern matching, substitution,...) used in other tools such as `sed`,
`grep`, `awk` or `vi`.

The user starts starts editing a new file named `file1.txt` with the command `ed file1.txt`. Once
this command is executed the program is used interactively with a set of commands. The following
commands (followed by pressing `ENTER`) are used to write a text :

* `a` : adds (appends) lines (to start the appending mode)
* `.` : to stop the appending mode
* `w` : write into a file
* `q` : quit

For example :

```
julien@zbook:~$ ed test
test: No such file or directory
a
Lorem ipsum dolor sit amet, consectetur adipiscing elit. Vivamus ullamcorper
mauris a ipsum interdum gravida. Donec augue elit, imperdiet dapibus orci nec,
maximus dignissim nibh. Fusce metus felis, hendrerit a.         
.
w
213
q
julien@zbook:~$ cat test
Lorem ipsum dolor sit amet, consectetur adipiscing elit. Vivamus ullamcorper
mauris a ipsum interdum gravida. Donec augue elit, imperdiet dapibus orci nec,
maximus dignissim nibh. Fusce metus felis, hendrerit a.
```

\newpage

1. Write the following lines (*De Morgan's poem*) in `file1.txt` with the only use of `ed`:
```
      And the great fleas themselves, in turn,
      have greater fleas to go on;
      While these again have greater still,
      and greater still, and so on.
```
 Check the content of `file1.txt` with `cat`.

1. Let us consider ed's commands for printing lines. Open `file1.txt` with
`ed`. You can print the n-th line with the command `np` or just the number
`n`. What is the result (meaning) of the following commands : `1`, `ENTER`,
`n`, `.`, `3p`, `$`, and `$p` ?

1. You can print line `m` through `n` with `m,np`. Print lines 1, 2, and 3. Print lines 1 through
   last without the use of the digit `4`. What is the result of `,p` ?

1. Line numbers can be combined with the plus and minus signs. For example, `$-1` or `2+3`. Use this
   technique to print the last three lines of `file1.txt`.

1. This editor provides a way to search for lines that match a particular *pattern* (`/pattern/` or
   `?pattern?` to search backwards). Apply the following commands in `file1.txt`:
    * `/flea/` : search for next line containing *flea*
    * `//` : search for the next one using the same pattern
    * `??` : search backwards for the same pattern

1. A pattern search like `/flea/` is also used as a line number. Print the lines of `file1.txt` from
   line 1 to next `flea`. Why do you get a different result if you apply this command after the use
   of commands `1p` and `2p`.

1. The command `na` (append) adds a line after a specified line `n` (append). For example, the
   command `2a` adds text after line `2`. Append the text "And little fleas have lesser fleas, and
   so ad infinitum." at the beginning of `file1.txt`.

1. The command `m,nd` deletes lines `m` through `n`. Delete the first line of `file1.txt`.

1. A string of letters is replaced by another with the command `s` (substitute). The command
   `s/old/new/` changes the first *old* into *new* on *current line*. The command `s/old/new/g`
   changes each *old* into *new* on *current line*. You can append `p` at the end of these commands
   in order to print the changed line. Use `ed` to create `file2.txt` with the following content :
```
      One two three one one two.
      Two one two one two three.
```
    * Change the first "two" by "one" in the second line.
    * Change each "one" by "two" in the first line (with a single command).

1. Certain characters called *metacharacters* have special meaning when they appear in a search
   pattern. The patterns that use these characters are called *regular expressions*. Let us consider
   the following regular expressions:
    * `c` : any non-special character `c` matches itself
    * `\c` : turn off special meaning of character `c`
    * `^` : beginning of line
    * `$` : end of line
    * `.` : any single character
    * `[...]` : any one of characters in `...`; ranges like `a-z` or `2-7` are legal (*e.g.*,
        `[2-7]`)
    * `[^...]` : any single character not in `...`; ranges are legal (*e.g.* `[^2-7]`)
    * `r*` : zero or more occurrences of `r`, where `r` is a character, `.` or `[...]`

	What is the meaning of the following patterns :
    1. `/thing.$/`
    2. `/thing\.$/`
    3. `/\/thing\//`
    4. `/[tT]hing/`
    5. `/thing1.*thing2/`
    6. `/^thing1.*thing2$/`
    7. `/thing[^0-9]/`
    8. `/thing[0-9][^0-9]/`

	Create a file containing strings accepted/rejected by these regular expressions. Apply these patterns with `ed` on the content of this file.

## Sed : the stream editor

*Sed* is a stream editor used to perform text transformations (on an input stream) similar to the
ones performed with *ed*. However, there are several operations from `ed` that are not valid in
*sed* (for example, `+` and `-` in line number expressions). The following command **applies** a
list of *ed* commands **to each line** from the input files and write the result on the standard
output:

```
  sed 'list of ed commands' filenames ...
```

1. What is the meaning of the following commands:
    1. `sed '1,3d' file`
    1. `sed '/on/p' file`
    1. `sed -n '/on/p' file`
    1. `sed -n '/on/!p' file`
    1. `sed 's/ipsum/ABC/' file`
    1. `sed 's/ipsum/ABC/g' file`
    1. `sed 's/^/\t/' file` (Some versions of `sed` do not recognize `\t`, in this case replace it
       with the shortcut `Control+v` followed by the `<TAB>` key)
    1. `sed 's/^[ \t]*//' file`
    1. `sed 's/^[ \t]*//;s/[ \t]*$//' file`

Use `sed` in order to perform the following actions:

1. Replace each occurrence of `fleas` with another word in `file1.txt` and write the resulting text
   to the file `corr_text`. **Add the corresponding command in `lastname_firstname_sed1.txt`. (2pt)**

1. Display all the lines of `corr_text` not containing the word `fleas`. **Add the corresponding
   command in `lastname_firstname_sed2.txt`. (2pt)**

## Sed : scripts

*Sed* **scripts** are text files that contain *sed* commands separated by semicolons (`;`) or
newlines. These scripts are executed with the command `sed -f` followed by the script's file name.

1. Retrieve the `xmas.poem.source.txt` from the campus site (the expected result is available in
   `xmas.poem.source.expected.txt`).
1. Based *only* on the regular expressions presented in *this* lab, create a *sed script* to
   display nicely the Christmas poem on the screen only using `sed`. In order to achieve this task,
   you'll need to do the following actions in order:
    * Replace lines starting with two `+` symbols, followed by at least one `-` symbol and ending
      with a `+` symbol by an empty line.
    * A line matching a pattern is deleted with `/pattern/d`. Delete all lines starting with a `+`
      symbol followed by any number of blanks (spaces and tabs) followed by at least one `-` symbol
      and ending with a `+` symbol preceded or not by some blanks.
    * Delete any remaining `+` symbols.
    * Delete blanks or tabs at the beginning of each line.
    * Replace multiple sequences of blanks and tabs by a single blank character.
    * Replace Xmas by Christmas.

**Save this `sed` script to `lastname_firstname_sedscript.txt`. (8pt)**

## grep

The following command searches the named input files (or the standard input if no files are named)
and print each line that contains a match to the given `pattern`:

```
	grep pattern filenames ...
```
The pattern is the same regular expression as in `ed`.

1. Using only `ls -l` and `grep`, list all the directories in your home directory. Remind that you can
   link the standard input and standard output of two commands by using a pipe (`|`). For example, you
   can try the following pipeline : `ls -l | grep rw`.
1. Using only `ls -l` and `grep`, list all the directories and symbolic links in your home directory.
1. Using only `ls -l` and `grep`, list all the files (in your current directory) that others can
   read and write.
1. List all the lines from `/etc/passwd` containing the string `bash`.
1. List all the lines from `/etc/passwd` not containing the string `bash` (you have to invert the
   sense of matching with an option of `grep`, see the *manpages*).

**Save these five commands to `lastname_firstname_grep.txt` (a single command per line). (5pt)**
<!-- 1. Using only `grep`, get the line from `/etc/passwd` whose the `uid` is 6. -->

## cut

The `/etc/passwd` file contains information about all the users. Each line details a particular user
with seven fields separated by colons:

* username
* encrypted password (in traditional UNIX systems), or a single "x"
* user id (uid)
* group id (gid) (primary group)
* full name of user
* user's home directory (/home/username)
* user's shell (/bin/bash, /bin/zsh/,...)

1. What is the meaning of `cut -d : -f 1 /etc/passwd` ?
1. Using only `cut`, list all the `uid` fields contained in `/etc/passwd`.
1. Using only `cut`, list all the username and uid fields in `/etc/passwd`.
1. Using only `grep` and `cut`, give a single command line to display the username associated to a
   given user id.

**Save the three last commands to `lastname_firstname_cut.txt` (a single command per line). (3pt)**

\newpage

## Supplementary exercises

1. With the command `wget` followed by the `URL`, retrieve `linux-0.01.tar.gz` from the web site
   `www.kernel.org/pub/linux/kernel/Historic/`. Extract all the files with the command `tar -zxvf
   linux-0.01.tar.gz`. Using only `grep -nHr`, list all the lines (with line number and file name)
   from all the source file that contains `file_write`. What is the meaning of options `n`, `H`, and
   `r` ?
1. `grep` allows to use extended regular expressions with option `E`. These expressions allows
   alternations with the symbol `|`.  Try the regular expression `file_write|file_read` for the
   previous question. You can learn more details about these regular expression from the following
   document : `http://pubs.opengroup.org/onlinepubs/9699919799/`.
1. Repeat the same exercise as for `sed` with the `vim` text editor.
