# Prerequisites

This course requires to have a UNIX-like operating system, known as *GNU/Linux*, to be installed on your computer. Either directly installed, or through a virtual machine. Linux distributions such as *Ubuntu* or *Fedora* are recommended.

# Getting started

The **shell** is an application that provides an interface for running other applications.

1. Access the UNIX-shell through a terminal emulator such as `Terminal` or `Konsole`.

Opening such a terminal emulator leads to a *prompt* printed by the shell. This prompt is, for
example, the single character `%`, `$`, or a more complex string such as `julien@srv1:~$`, where
`julien` is my login name and `srv1` the *hostname* followed by the
current directory, in this case `~` that stands for the user's **home directory** (*i.e.*,
`/home/julien`).

In the shell, you can run a program by typing its name, followed by pressing the *Enter* key.

1. Run the program `date` within the UNIX-shell.

UNIX operating systems provide a documentation known as **the man pages**. The man pages of a
program can be accessed by typing, within a UNIX shell, the command `man` followed by its name. You
can move forward or backward in this documentation with the arrow keys and exit the man pages by
pressing on the `q` key.

2. Display the man pages of `date` and try the first example of the section entitled **examples**.

3. The `man` utility provides some help by pressing the `h` key. Use this help to find a way for
   searching the word `day` in the man pages of `date`. How do you move to the next (or previous)
   occurrence of this word ? How do you jump to the first line ?

There exists many implementation of the UNIX-shell such as the Bourne Shell (`sh`), the C shell
(`csh`), the Z shell (`zsh`), the *Bourne-again* shell (`bash`), etc. The one used in this course is
**BASH**. To determine if you are running `bash`, type the command `echo $0`.

4. The command `nano` executes a small text editor included by default in most Linux distribution.
   Read the first paragraph of the *editing* section from the nano man pages. Then, enter the
   command `nano` followed by a file name (for example, `nano f1`) and write some text.
   Save your changes and close this editor.

5. Check the presence of this file in your current working directory with the `ls` command. This
   command lists the content of the working directory.

6. The command `cat` can be used to print the content of all the files named by its arguments
   (*i.e*, con*cat*enate their contents and write the result in the standard output). For example,
   `cat junk temp` or `cat junk.txt`. Use this command to check the content of the file created in
   question 4.

In UNIX-like operating systems, a file is an uninterpreted byte array and a directory is a reference
to files and other directories.

The directories form a tree-like structure starting at a special directory called **root** (`/`).

\centerline{\includegraphics[scale=0.6]{image/file_sys.pdf}}

In this example, the *full file name* (i.e., the full path from the root directory) of the directory
`you` is `/home/you`. This directory contains two child directories and it's parent directory is
`/home`.

7. Display the *full file name* of the current directory with `pwd` (print working directory).

8. What is the *full file name* of the working directory's parent directory ?

Files and directories can be referred through their *full path* or *relative path*. The relative
path starts at the current working directory. In the above example, if the current working directory
is `/home`, then `you/Documents` is a relative path to `Documents`, and `/home/you/Documents` is the
full path.

Most of the UNIX-like operating systems contain the following standard directories :

* `/bin` : essential programs in executable form ("binaries")
* `/dev` : files that refer to devices
* `/etc` : configuration files
* `/usr` : programs (and their configuration files) that are not needed at system startup
* `/home` : user home directory space (one subdirectory per user)
* `/root` : the super-user's home directory
* `/tmp` : temporary storage
* `/var` : contains data that changes frequently

The content of a directory can be displayed with the command `ls` followed by its name. For example,
the content of `/usr/bin` is displayed with the command `ls /usr/bin`; or `ls bin` if `/usr` is your
working directory; or `ls` if `/usr/bin` is your working directory.

9. Use the `ls` command to list the content of `/etc`.

10. Use the `cd` command to change your working directory to `/etc`.

11. Print the content of your working directory. This directory should contain the text file named
    `hostname`.  Display its content with its full name and relative name (*i.e.*,
    `/etc/hostname` and `hostname`, respectively).

12. Change your working directory to the user's home directory.

13. Create a directory named `lab0` with the command `mkdir lab0`, and list its content with its
    relative path.

14. Move to this directory with the command `cd lab0`. What is your current working directory ?

15. In this directory, create a file with the command `touch file0` and a second directory named
    `abc`

16. A directory cannot be created if its parents do not exist. For example, the command `mkdir
    abc/test` succeed, but the command `mkdir abc/def/ghi` does not. Find an option of `mkdir` in
    its man pages to overcome this problem.

17. Change your working directory to `abc/def/ghi`. What is the result of executing the `cd -`
    command?

# File system

Each file is identified by an **i-node** number. This number can be displayed with the command `ls
-i` (`ls` **minus** `i`), where `i` is said to be an option to the command `ls`. The file names that
are displayed by running `ls` are only convenient names to refer to i-nodes that refer to the
underlying arrays of bytes. Moreover, several different names can refer to the same i-node number
(see later).

By default `ls` ignore entries starting with a dot. These entries can be displayed with the option
`-a`.

1. Create directories `lab2` and `lab2/abc` in your home directory.

2. Change your working directory to `lab2` and execute the command `ls -ai`. Perform the same
   action in the directory `lab2/abc`. Based on the i-node numbers, what can you conclude about the
   directories named `.` and `..` ? Can you use these directories in a path ?

3. A file is renamed (or moved) with the command `mv` followed by the source file and the
    destination file. What is the purpose of the following three commands?
    * `mv file1 /tmp`
    * `mv file1 file2`
    * `mv file1 /tmp/file2`

4. A file can be removed with the command `rm` followed by its file name. Create a file with
`touch` and remove this file with `rm`.

5. A directory and its content is removed with the command `rm -r` followed by its name. Create a
   directory that contains a directory that itself contains a file. Remove this directory an all its
   content with `rm -r`.

6. Reproduce the same steps and remove the directory with the command `rm -ri`. What is the purpose
   of option `-i`? Check your answer with the man pages.

As mentioned before, several names can refer to the same i-node number. This is known as a
**hardlink**. One can create a hardlink between a `source_file` and a `destination_file` with the
command `ln source_file destination_file`. Once this command is executed, both file names refer to
the same i-node. There are several limitations to the use of hardlinks. The `source_file` and
`destination_file` must be "normal" files and on the same file system (see later).

7. Create a file named `file1` and edit this file with your favorite text editor. Add some content
   to this file. Create an hardlink between `file1` and `file2`.  Check that both `file1` and
   `file2` have the same i-node number. Change the content of file2 and check that `file1` content
   has changed accordingly.

The disk space holding the file's content is freed when the file's link count is zero. The link
count is displayed as the second column of the output of `ls -l`.

8. Whats is the link count of `file1` and `file2`. Remove `file1`. What is the link count and the
content of `file2` ?

A symbolic link (softlink) is a special type of file that contains a reference to another file or
directory. Such a link is created  between a `source_file` and a `destination_file` with the
command `ln -s source_file destination_file`, where `source_file` can be of any kind, and
`source_file` and `destination_file` can be on different file systems. Repeat the two previous
points with `ln -s`. What can you conclude ?

The output of `ls -l` provides more information about the content of the working directory. The
first character of the first column gives the kinds of files :

* regular files (-)
* directories (d)
* symbolic links (l)
* special files (devices) (c or b)
* pipes (p)

The output of this command provides other information that are explained in the next section.
