# UNIX Processes

A **process** is an instance of an executing program. The UNIX operating system is a
**multi-tasking** operating system. Multiple processes can simultaneously reside in memory and
receive use of the CPU(s). UNIX is also said to be a *preemptive* operating system. This means that
a scheduler determines which process receives use of the CPU and for how long. The kernel records
various information about each process in several data structures. Among others, they contain the
following information:

* Process identity (`pid`, `ppid`, process real owner, process effective owner, creation date)
* Scheduling priority (niceness)
* Process state (sleeping, stopped, runnable,...)
* The resources used (memory, CPU,...)
* Files and network ports opened
* Which signals are blocked
<!-- * process identity (pid, ppid, process real owner, process effective owner, creation date) -->
<!-- * time values (CPU time, user mode time, system mode time) -->
<!-- * memory used -->
<!-- * file descriptors -->
<!-- * CPU registers -->

A process can create new processes using the **fork()** system call. In other words, a process is
*created* with the *fork()* system call. The process that calls *fork()* is the **parent process**,
and the new process is the **child process**. Each process is identified by a **pid** (process ID)
and identifies its parent process with a **ppid** (parent process ID). This induces a tree-like
structure starting from the **init** process with a `pid` equal to 1.

1. Use the `pstree` command to display the tree of all running processes.

2. The status of every process on the system is displayed with the command `ps -e`. What is
   displayed with `ps -e -o pid,comm,%mem,%cpu` ?

3. The output of `ps` can be sorted with the option `--sort`. Find the description of this option in
   the *manpages*. Use this option to sort the output of `ps` with respect to the *cpu* and *memory*
   utilization of processes.

The command `pgrep`, followed by a `pattern`,  displays processes ids whose names match the
`pattern`. For example, `pgrep sh` displays all the processes ids whose names contain `sh`.

4. Open two ssh connections to the virtual connections, and keep these two terminals open for the
   remaining of this lab. In the first one, execute a text editor (vim, emacs,...). In the second
   one, use `pgrep` to find easily its `pid`.

5. Search the *manpages* for an option of `pgrep` to list the process names in addition to the
   process IDs.

Each process has two user IDs associated to it. The **real user ID** (UID) and the **effective user
ID** (UEID). The UID identifies the user who created it (i.e., equal to the UID of the parent
process). The UEID determines the *permissions* of the process (i.e., what resources and files the
process is allowed to access). In the same way, the process has two group IDs associated to it. The
**real group ID** (GID) and the **effective group ID** (EGID). For this purpose, you can change the
effective user and group ids of programs with the command `chmod u+s` and `chmod g+s`, respectively.
If the **set uid** mode is enabled (`s` on the execution field of the owner's user mode), then the
file will run under the id of the owner of the file. If the **set gid** mode is enabled (s on the
execution field of the group's user mode), then the file will run under the id of the group owning
the file.

6. With help of the *manpages* of `ps`, display the `EUID` and `UID` of all running processes (see,
   `STANDARD FORMAT SPECIFIERS`). **Warning** : for `ps`, `uid` is an alias to `euid`.

7. List the permissions associated to `passwd` (locate the binary file with `whereis passwd`). What
   do you conclude from that? Check your result with the use of `ps`.

A **signal** is a notification to a process that an event has occurred. They are sent by the
*kernel* or other processes. In this course, only two types of signals are considered :

* The signals sent by the terminal to *kill*, *interrupt*, or *suspend* processes
* The signals sent by the command **kill**

The syntax of **kill** is `kill [options][signal] pid`. For example, `kill 8907` sends the
*termination* signal to the process with `pid` equal to 8907. This signal is a way to *request* a
process to terminate. This signal can be blocked, handled, and ignored. The command `kill -9 8907`
(or the equivalent command `kill -SIGKILL 8907`) sends the *kill* signal. This signal leads to an
immediate termination of the process (the process does not actually receive this signal). Unlike the
termination signal, it cannot be can be blocked, handled, or ignored. (A list of other signals are
available in `man 7 signal`) A well designed application will terminate gracefully when the signal
`SIGTERM` is received. This is why, you should always use first `SIGTERM` and then `SIGKILL` as a
last resort for terminating processes.

8. Open a text editor and send a signal to the corresponding process to terminate its execution.
   What signal should be sent if the process does not respond accordingly ?

During its *life*, a process belongs to one of the four following **states**:

* **Runnable** : The process is ready to execute
* **Sleeping** : The process is waiting for a particular event to occur
* **Zombie** : The process has finished its execution. All the resources held by the process are released back to the system, but the kernel keeps information, for the parent process, about the process termination. This *zombie* is finally removed when the parent process is informed of this information, or when the parent terminates.
* **Stopped** : The process is forbidden to run. A process is stopped with the signal `SIGSTOP` or `SIGTSTP` and restarted with `SIGCONT`.

9. Use the man pages of `ps` to display the state of each process (see, `STANDARD FORMAT SPECIFIERS`).

Several signals are sent by keyboard shortcuts, such as the `SIGINT` with `C-c` (equivalent to
`SIGTERM`, but sent to the foreground process group, see later), `SIGTSTP` with `C-z`, and `SIGQUIT`
with `C-\ ` (equivalent to `SIGINT`, but generates a core dump as well for debugging purposes).

10. Execute the command `sudo find /` and interrupt it with a keyboard shortcut.  
11. How can you resume the execution of `sudo find /` after the use of `C-z` ?

The shell offers the ability to execute *simultaneously* several programs. It also allows to
*control* their executions. That is to say, to stop and restart their execution. This is allowed
through **job control**. In the shell, a program is either executed in **background** or in
**foreground** :

* A *foreground* execution is the default behavior when a program is executed from the shell. The process is attached to the terminal : the user is able to interact with the program and has to wait the completion of its execution before being able to run another program.
* A program is executed as a *background* process by adding an ampersand (`&`) at the end of the command. In this case, the user cannot interact directly with the program (i.e., only send signals to the process), but is able to run directly another program. If such process requires to read something from the standard input or write something to the standard output, then the process is suspended.

12. What is the meaning of `(sleep 5; date)& date` ?

The list of jobs is displayed with the command `jobs` and are switched to background or foreground
with `bg [jobspec]` and `fg [jobspec]`, respectively. Each job is referred with an integer. For
example :

```
julien@zbook:~$ jobs
[1]-  Stopped                 vim
[2]+  Running                 factorial 100 > out &
```

See the `STDOUT` section of `man jobs` for more details.

In this case, a `SIGKILL` is sent to `factorial` with the command `kill -SIGKILL %2` and `vim` is
switched to foreground with `fg %1`.

The support of shell job control is based on the implementation of **process groups** and
**sessions** in the kernel. This provides an hierarchical relationship between processes. A *process
group* (often used as a synonym to the term *job*) is a collection of one or more processes. Each
process group is identified with a *process group id* (PGID) equal to the PID of the process leader.
A *session* is a collection of process groups. Each session is identified by a *session id* (SID)
equal to the PID of the process that creates the session (in our case, BASH). One of the process
group is the *forground process group* and others are the *background process groups*. Each command
or pipeline of commands started from the shell leads to the creation of one or more processes, and a
new process group that contains all of these processes.

13. First, execute the command `sudo sh -c "sync; echo 3 > /proc/sys/vm/drop_caches"` in order to
    clear caches and then get the expected behaviour of the next command. Then, execute `find / 2>
    /dev/null | sort | wc -l` in background and try the command `ps -o cmd,pgid,sid,pid`. What do
    you conclude from that ?

When you close a terminal window, the shell sends a signal `SIGHUP` to each job it has created. By
default, this leads to terminate all these jobs. In order to overcome this problem (i.e., to
continue to run the command if you close the terminal), you can make the process immune to hangups
with the **nohup** command `nohup command &`.

<!-- #14. Find an illustration of the `nohup` command.
-->

<!-- ## Process control (cont'd)

* To run your program with lower than normal priority: `nice expensive-command &`
* To start your program at a later time : `at time`

```
$ at 1113
at> date > test
at> <EOT>
job 2 at Fri Aug 22 11:13:00 2014
$ cat test
Fri Aug 22 11:13:00 CEST 2014
``` -->

# Exercises
All the following steps have to be performed in the Shell :

1. Run the command `(while true; do date; sleep 10; done)` and kill this job with a keyboard shortcut.
1. Run the previous command in background.
1. Switch this job to foreground and kill this job.
1. Run the previous command in background and kill this job with `kill`.
1. Run `vim` and find its *pid* and *ppid*.
1. Send the *kill* signal to this process.
1. Run `vim` in background and find the process in the output of `pstree`. What can you conclude ?
1. Find the *pid* of this process with `pgrep`.
1. Use the *manpages* of `pstree` to display all the parent processes of `vim` (use its *pid* as an argument).
1. Similar to `pgrep`, the `pkill` command sends a specified signal to each process instead of
   listing them on the standard output. Use `pkill` to send the *kill* signal to `vim`.
1. Open a file with `less` and find all the file descriptors for this process with `lsof -p`.
1. Keep this file opened with `less`, open a second terminal to display all the processes using this file with `fuser`.
<!-- 1. Execute the command `(while true; do date; sleep 15; done)`. Suspend this job.
What is the status of this job ? Use `bg` to resume this job in background. After this, what is the status of this job ?
1. Execute a command at a specified time that writes into a file the number of seconds since 1970-01-01 00:00:00 UTC.
1. Run `vim`, and then suspend it. Use `top` to send the signal KILL to this process (a brief help can be found by hitting the `h` key)
1. Run `passwd`, as a normal user, and find its real and effective users. What do you conclude from that ? -->
