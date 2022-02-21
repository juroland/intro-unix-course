# Users and permissions

UNIX is a multi-user operating system. Each user is identified by a name and a unique ID (the uid),
belongs to one or more groups (for example : admin, student,...), and has a unique password.

Three files are used to manage this information:

* `/etc/passwd` : contains information about users
    * username
    * encrypted password (in traditional UNIX systems), or a single "x"
    * user id (uid)
    * group id (gid) (primary group)
    * full name of user
    * user's home directory (/home/username)
    * user's shell (/bin/bash, /bin/zsh/,...)
* `/etc/shadow` : contains usernames and encrypted passwords
* `/etc/group` : contains a list of groups
    * group name group
    * password (in traditional UNIX systems), or a single "x"
    * group id
    * member list

Several commands are commonly used to manage this aspect of UNIX:

* `who` : print everyone who is currently logged in
* `who am i` or `whoami` :  print the user name
* `groups` : print the groups to which you belong
* `passwd` :  update user's password
* `useradd` : create a new user
* `usermod` : modify a user account
* `groupadd` : create a new group

A super-user, named **root**, is the administrating account of the system and has all rights on the
system. For example, it can perform the following actions:

* change id : can become any defined user
* suspend/stop any process (see later)
* change rights on files (see later)
* change/set passwords

An **owner** (also known as user) and a **group** is associated to each file. They are specified in
the third and fourth columns of the output of the `ls -l` command, respectively.

1. Create a file named `file1` and execute `ls -l file1` to determine its owner and group.

2. Create a new user with `useradd`, for example named *alice* (execute this command as the
   superuser).

3. Use the `usermod` command to add this user into a new group `users` (created with `groupadd` if
it does not exist). Find the right option/syntax in the man pages.

4. The owner and group of a given set of files can be changed with the command `chown
user[:[group]] file(s)`. Change the owner and group of `file1` to `alice` and `users`, respectively.

5. What are the differences between commands `chown root:staff /u`, `chown root /u`,
`chown root: /u` and `chown :staff /u` ?

The first column of `ls -l` provides information about permissions (Read (r), Write (w), and Execute
(x)). Three levels of permissions are described in this column :

* Owner permissions (user)
* Group permissions
* Permissions for others

For instance, if the first column is equal to `-rwxrw-r--` :

* The file owner has permission to read its content, to write changes to the file, and to run the
  file as a program (see later);
* The group (members of the group) has permission to read its content and to write changes to the
  file;
* Other users have permission to read its content.

For instance, if the first column is equal to `drwxrwxr-x` :

* The directory owner has permission see the files in the directory, to create, move, or remove
  files, and to use the directory name in a path;
* The group has the same permissions;
* Other users have permission to see the files in this directory and to use the directory name in a
  path. In other words, the execution permission of a directory lets you pass through it when it is
  part of a path.

Permissions are changed with the command `chmod [rights] file(s)`. The rights can be specified
through two different syntax. The first one uses three octal digits, i.e., one for each user mode
(first bit=execute, second bit=write, third bit=read). For example , `chmod 744 myfile` :

* 7 is equal to 111 in binary and equivalent to `rwx`,
* 4 is equal to 100 in binary and equivalent to `r--`.

6. Create a file and change its permissions to `rw-------` with `chmod` using the octal mode.

The second syntax is the character mode. For example, `chmod 744 myfile` is equivalent to `chmod
u=rwx,g=r,o=r myfile` in character mode, where `u` stands for user, `g` stands for group, and `o`
stands for `other`.

More generally, this syntax allows to perform three actions (+ : adding rights, - : deleting rights,
= : setting rights) for the modes u(ser), g(roup), o(ther) or a(ll).

7. What is the purpose of the following commands : `chmod g+r myfile`, `chmod a+r myfile`, `chmod
g-r myfile`, `chmod g=rw,o=r myfile`, `chmod a=rwx myfile` ?

To add or remove a file in a directory, we need to have both execute and write permissions on this
directory. This behavior can be changed with the use of a particular mode (in addition to read,
write, and execute), called the **sticky bit** mode (denoted by a lower case `t` instead of `x` in
the last field if both the sticky bit and execute modes are enabled, an upper case `T` otherwise).
When applied to a directory, files in the directory can be renamed or removed only if the user has
write permissions on the directory *and* owns either the file or the directory.

8. Create a file `file0` owned by `alice:users` in `/tmp` and try to remove it with you own
account. What can you conclude ? Can you remove this file with the super-user ?

9. Create a directory, in your user home directory, with permissions such that all user is able to
   create files but not able to remove files from other users.

\newpage
## Supplementary Exercises

1. Create 9 files with the command `touch pp{1..4}`, then change the files to have the specified permissions:
    * pp1 : `rwxrwxrwx`
    * pp2 : `rwxrwxr-x`
    * pp3 : `rwxr-xr-x`
    * pp4 : `r-x------`
    * pp5 : `r--r-----`
    * pp6 : `rw-r--r--`
    * pp7 : `r--r--r--`
    * pp8 : `rw-rw-rw-`
    * pp9 : `rwx------`
2. Set up the foundation for a web page:
    * Change to your home directory 
    * Make a directory named `public_html` 
    * Allow group and others to be able to read and execute on your home directory 
    * Allow group and others to be able to read and execute on the `public_html` directory 
    * Verify the permissions on your home directory and on `public_html` 
    * Use touch to create an empty file named index.html in the `public_html` directory 
    * Allow group and others to be able to read all files in the `public_html` directory 
    * Verify the permissions on the file(s) in `public_html` (your home page files)
3. How many user groups exist on your system ? How did you get your answer ?
4. The user *sarwar* sets access permissions to his home directory by using the command `chmod 700 $HOME`. If the file `cp.new` in his home directory has read permissions of 777, can anyone read this file ? Why or why not ?

### References

These supplementary exercises are based on :

* **UNIX, Third Edition: The Textbook** By Syed Mansoor Sarwar, Robert M. Koretsky
* http://www.nbcs.rutgers.edu/~edseries/

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

1. What is the location of `date` ?

The value of a shell variable is obtained by prefixing its name with a `$`. You can display the
value of your own `PATH` with the command `echo $PATH`.

The UNIX-Shell is not only a program to run other programs. The UNIX-Shell is a command-line
interpreter. The simplest command is a single word such as `date` which executes the file
`/bin/date`. Multiple commands can be executed on the same line by terminating them with a semicolon
(`;`). For example, `cmd1; cmd2` or equivalently `cmd1; cmd2;`. In other words, each command is
terminated with a semicolon and executed one after another once the Enter key is pressed.

2. Execute the three commands `date`, `ls -l`, and `who`, on the same line.

The content of a file is displayed with the command `cat` followed by its name. For example, `cat
file1.txt`. If more than one file is provided as an argument to `cat`, then the files are
concatenated on the standard output (i.e., the display, by default).

3. Create a directory that contains 4 files named `file1.txt`, `file2.txt`, `file3.txt`, and
`junk.txt`. Add some contents to all these files (for example, `file1.txt` contains `content file1`,
`file2.txt` contains `content file2`, and so on).

4. Concatenate, on the standard output, the content of  `file1.txt`, `file2.txt`, and `file3.txt`.

A set of file names can be specified by a pattern (known as **Filename shorthand**). For example,
`file*` is a pattern that matches all filenames in the current directory that begin with `file`. In
other words, the `*` matches any string of characters.

Let us assume that the output of `ls` is `file1.txt file2.txt file3.txt junk.txt`. If you consider
the command `cat file*`, then `file*` is replaced by the shell with the strings `file1.txt`,
`file2.txt`, and `file3.txt` which are then passed to `cat`. In other words, `cat file*` is
transformed into `cat file1.txt file2.txt file3.txt` by the shell.

5. Create a directory that contains the following files : `file1.txt`, `file2.txt`, `file3.txt`,
`file4.txt`, `file5.txt`, `file25.txt`, `save.txt`, `junk.txt`, and `jack`. Add some content to each
file.

6. List all the files that ends with `.txt`

7. List all the files that starts with letter `j`.

The `*` is not the only parttern-matching feature provided by the shell. `[...]` is a pattern that
matches any of the characters inside the brackets and `?` is a pattern that matches any single
character.

8. What is the meaning of the following commands :

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

9. Create a directory that contains the following files : `file1.txt`, `file2.txt`, `file3.txt`,
   `file4.txt`, `file5.txt`, `save.txt`, and `junk.txt`. What is the result of `ls > filelist` in
   this directory ? Check your answer with `cat filelist`. What stream is redirected ?

10. What is the result of the command `ls >> filelist` ? What is the difference with `ls > filelist` ?

The command `echo`, followed by a string, displays it to the standard output.

11. Use the command `echo` to write a line of text in a file.

12. Use the command `echo` to *append* a line of text in a file (i.e., to add the line of text at the
   end of the file).

13. `bc` is an arbitrary precision calculator language (see, `man bc`). Install and execute the
   command `bc`.  Try any valid expression (such as `2^32`) followed by enter. Exit this tool with
   the command `quit`.

14. Write a valid `bc` expression in a file (for example, named `compute`). What is the result of
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

15. Create a file `words.txt` that contains a list of unsorted words (a single word on each line).
Chain the output stream of `cat words.txt` with the input stream of `sort`. What is the equivalent
command with the use of *input stream redirection* ?

The command `sort`, without any arguments, sorts its standard input until there is no more input.
The *control character* `C-d` (hold down the `CONTROL` key and type a `d`) tells the program that
there is no more input.

16. Use the command `sort` to sort some text entered on the standard input (i.e., the keyboard).

The command `wc -l` counts the lines on its standard input until there is no more input.

17. Use commands `wc -l` and `ls` to count the number of files and directories in `/usr/bin`.

18. As explained previously, semicolons can be used to terminate commands. What is the difference
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