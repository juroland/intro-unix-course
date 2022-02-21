# The Shell

Each user has a default shell called a *login shell* defined in `/etc/passwd`. You can display the
content of this file with the command `cat /etc/passwd`. A user can change his/her default shell
with `chsh`, for example `chsh -s /usr/bin/zsh` to switch to the Z shell.

Some properties of the shell (your environment) are controlled by the so-called **shell variables**.
The most important variable is `PATH`. In this variable is stored a set of directories called the
*search path*. This variable is used by the shell when you type the name of a program to locate the
corresponding binary file. For example, if the `PATH` is equal to `.:/bin/usr/bin`, then when you
type the name of a program, the shell looks for it first in the current directory (`.`), then in
`/bin`, and then in `/usr/bin`. Based on this variable, you can locate the binary of a program with
the command `whereis` followed by its name.

22. What is the location of `date` ?

The value of a shell variable is obtained by prefixing its name with a `$`. You can display the
value of your own `PATH` with the command `echo $PATH`.

The UNIX-Shell is not only a program to run other programs. The UNIX-Shell is a command-line
interpreter. The simplest command is a single word such as `date` which executes the file
`/bin/date`. Multiple commands can be executed on the same line by terminating them with a semicolon
(`;`). For example, `cmd1; cmd2` or equivalently `cmd1; cmd2;`. In other words, each command is
terminated with a semicolon and executed one after another once the Enter key is pressed.

23. Execute the three commands `date`, `ls -l`, and `who`, on the same line.

The content of a file is displayed with the command `cat` followed by its name. For example, `cat
file1.txt`. If more than one file is provided as an argument to `cat`, then the files are
concatenated on the standard output (i.e., the display, by default).

24. Create a directory that contains 4 files named `file1.txt`, `file2.txt`, `file3.txt`, and
`junk.txt`. Add some contents to all these files (for example, `file1.txt` contains `content file1`,
`file2.txt` contains `content file2`, and so on).

25. Concatenate, on the standard output, the content of  `file1.txt`, `file2.txt`, and `file3.txt`.

A set of file names can be specified by a pattern (known as **Filename shorthand**). For example,
`file*` is a pattern that matches all filenames in the current directory that begin with `file`. In
other words, the `*` matches any string of characters.

Let us assume that the output of `ls` is `file1.txt file2.txt file3.txt junk.txt`. If you consider
the command `cat file*`, then `file*` is replaced by the shell with the strings `file1.txt`,
`file2.txt`, and `file3.txt` which are then passed to `cat`. In other words, `cat file*` is
transformed into `cat file1.txt file2.txt file3.txt` by the shell.

26. Create a directory that contains the following files : `file1.txt`, `file2.txt`, `file3.txt`,
`file4.txt`, `file5.txt`, `file25.txt`, `save.txt`, `junk.txt`, and `jack`. Add some content to each
file.

27. List all the files that ends with `.txt`

28. List all the files that starts with letter `j`.

The `*` is not the only parttern-matching feature provided by the shell. `[...]` is a pattern that
matches any of the characters inside the brackets and `?` is a pattern that matches any single
character.

29. What is the meaning of the following commands :

* `cat file[25]*`
* `cat file[25]*`
* `cat file[2-4]*`
* `cat [sj]*`
* `ls -l file*.txt`
* `ls -l file?.txt`

Most of the commands produce output to the terminal, and take their input from the terminal. The
terminal can be replaced by a **file** through **input-output redirection**. There exists three I/O
streams:

* Descriptor 0: stdin, keyboard by default
* Descriptor 1: stdout, display by default
* Descriptor 2: stderr, display by default

These streams can be redirected with the following operators:

* output stream redirection: `>` or `>>`
* input stream redirection: `<` or `<<`
* error stream redirection: `2>` or `2>>`

30. Create a directory that contains the following files : `file1.txt`, `file2.txt`, `file3.txt`,
   `file4.txt`, `file5.txt`, `save.txt`, and `junk.txt`. What is the result of `ls > filelist` in
   this directory ? Check your answer with `cat filelist`. What stream is redirected ?

31. What is the result of the command `ls >> filelist` ? What is the difference with `ls > filelist` ?

The command `echo`, followed by a string, displays it to the standard output.

32. Use the command `echo` to write a line of text in a file.

33. Use the command `echo` to *append* a line of text in a file (i.e., to add the line of text at the
   end of the file).

34. `bc` is an arbitrary precision calculator language (see, `man bc`). Install and execute the
   command `bc`.  Try any valid expression (such as `2^32`) followed by enter. Exit this tool with
   the command `quit`.

35. Write a valid `bc` expression in a file (for example, named `compute`). What is the result of
`bc < compute` ?  What stream is redirected ?

The last redirection is known as **Here-documents**. For example:

```
$ bc << .
> 4*6
> .
24
```

This redirection has the syntax `<< label`. The input of the command is read from the shell's
standard input until there is a line that contains only `label`. In this case, the label is a single
dot (`.`).

Output streams can be chained to input streams using **the pipe mechanism**:

```
command 1 | command 2 | command 3 | .... | command n
```

This means that the output stream of `command 1` is linked to the input stream of `command 2`, then
the output stream of `command 2` is linked to the input stream of `command 3`, and so on (the input
stream of `command 1` and the output stream of `command n` remain unchanged).

36. Create a file `words.txt` that contains a list of unsorted words (a single word on each line).
Chain the output stream of `cat words.txt` with the input stream of `sort`. What is the equivalent
command with the use of *input stream redirection* ?

The command `sort`, without any arguments, sorts its standard input until there is no more input.
The *control character* `C-d` (hold down the `CONTROL` key and type a `d`) tells the program that
there is no more input.

37. Use the command `sort` to sort some text entered on the standard input (i.e., the keyboard).

The command `wc -l` counts the lines on its standard input until there is no more input.

38. Use commands `wc -l` and `ls` to count the number of files and directories in `/usr/bin`.

39. As explained previously, semicolons can be used to terminate commands. What is the difference
between `date; who | wc -l` and `(date; who) | wc -l` ?

Several keyboard shortcuts are available in *BASH* for improving your productivity. These shortcuts
are a great help for editing commands (move the cursor, remove words,...) and for searching your
*history* for commands. Try all the following commands.

**Moving the cursor:**

* `C-a` or `<Home>` : move the cursor to the beginning of the line;
* `C-e` or `<End>` : move the cursor to the end of the line;
* `M-f` (`Alt-f`) : move the cursor forward a word;
* `M-b` : move the cursor backward a word.

**Editing:**

* `Tab` : auto-complete the command, file, or folder names;
* `C-k` : clears (kill) the rest of the line;
* `C-u` : clears the line before the cursor position;
* `C-w` : clears the word before the cursor position;
* `M-d` : clears the word after the cursor position;
* `C-y` : paste (yank) the previously killed text at the cursor position;
* `C-_` : undo.

**History:**

* `<Up>` or `C-p` : move back through the history list (previous command);
* `<Down>` or `C-n` : move forward through the history list;
* `C-r` : reverse search;
* `C-s` : forward search;
* `C-g` : escape from history searching mode.

## Synthesis Exercises

All the following steps have to be performed in the Shell :

40. Apply the `ls` command on different files (and directories) to display the basic file attributes
   (name, size, date(s), rights). Be sure to use the options : `-l`, `-d`, `--time=atime`,
   `--time=ctime`, `-t` and `-h`. More details about the time of last file modification (mtime),
   file access (atime), and status change (ctime) are detailed in the second section of `stat` man
   pages (`man 2 stat`). (Let us note that depending on how your system is configured (mount
   option), the access time (atime) might not be updated when a file is accessed. For example, you
   can find mounting options such as `relatime` and `noatime` in the output of the `mount` command.)

41. Create a file named `file1.txt`.

42. Check the default rights on `file1.txt` and write down all the information you can figure out
   (with `ls -l` check the value of atime, ctime, and mtime).

43. Write something to `file1.txt` with `echo`.

44. Display `file1.txt` content using the cat command.

45. Append something to `file1.txt` with `echo`.

46. Run: `chmod a-r file1.txt`. Check the `file1.txt` rights and write down its date attributes (with
   `ls -l` check the value of atime, ctime, and mtime).

47. Same question after running : `touch file1.txt`.

48. Create a link between `file1.txt` and `file2.txt`.

49. Check the link attribute on both files. Use `ls` to get i-node information on both files.

50. Modify the rights on one of the file (for example, `a+r`). What does it imply on the other one ?
    What do you conclude from that ?

51. Check that the link works as an alias by modifying one of the files.

52. Create the user `alice` with `useradd`.

53. Use the `usermod` command to add this user into a new group `users` (created with `groupadd` if
   it does not exist).

54. Change the owner (and group owner) of `file1.txt`. What is the result on the second file ?

55. Change back the file owner to its default value. As your normal user login delete `file1.txt` and
   try to access to `file2.txt`.

56. Create a new file `file1.txt`. Compare the contents of `file1.txt` and `file2.txt`.

57. Delete `file2.txt`.

58. Create a symbolic link between `file1.txt` and `file2.txt`. Answer to the previous questions
   using symbolic linked files.

59. As a standard user, create a directory `exos/` and in this directory, create a file `file1.txt`.

60. Modify the access rights of `file1.txt` (try to modify read rights and/or
   write rights).  What is the impact for the normal user and superuser ? Reset `file1.txt` rights
   to their original values.

61. As root change the ownership values of `file1.txt` (change them to user `alice` of group users
   for instance) and modify its access rights so that only the new owner can read and modify it. Try
   to modify `file1.txt` as a normal user. Try again as root.

62. As a normal user try to delete `file1.txt`. Explain the results.

63. Create a file `file2.txt` in `exos/` and change its ownership attributes to user `alice` of
    group `users`, change its access rights to `rw-r--r--`. Change the access rights of `exos/` to
    `rwxrwxrwx` and change its ownership attributes to root of group root.

64. Modify permissions of directory `exos/`, so that, as a normal user, you are not able to delete
    file `file2.txt`.

66. As a normal user, delete `exos/`. Correct the access rights to make it possible.

67. Use commands `head` and `tail` to print the 3 first and 4 last lines of `/etc/passwd` (use the
   man pages to find how to use these tools).

68. The `umask` utility can be used to change the default permissions for a newly created file. You
   have to install the package `manpages-posix` to get man pages for `umask` and other standard
   POSIX utilities such as `cd` and `mkdir`.  For example, if the value of `umask` is `002` (i.e.,
   000000010), then the write permission bit is not set for others. By default, if this mask is
   `000`, the creation permission is `666` for a file (i.e., 110110110, or rw-rw-rw). Which `umask`
   command would you use to give rights `rw-r-----` to all your new files created with touch ?

<!-- 1. Using the find command, display the list of `suid` or `sgid` programs in `/usr/sbin`. The
list must be a detailed list. -->

<!-- 1. Open a console window. As a normal user, run `touch file1.txt`. Then, execute `umask 007`
and then `touch file2.txt`. Compare `file1.txt` and `file2.txt `.

69.

70. Create a file `-file.txt` in your current directory and delete it.

71. Create a file `one two three.txt` in your current directory and delete it. -->
