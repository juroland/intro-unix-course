---
title: 'UNIX : System Programming 1'
author: Julien Roland
date: 2018
---

# Process Credentials

Each process has a process ID (`pid`), a positive integer that uniquely
identifies the process on the system. The `getpid()` system call returns the
process ID of a calling process.

```C
#include <sys/types.h>
#include <unistd.h>

pid_t getpid(void);
```

The return type is `pid_t`, defined as an unsigned integer type. Its a common
practice to cast this value to `long` for printing, because there is no guarantee
that a `pid_t` will fit in a `int`.

> Exercise #
>
> Write a C program that displays the process ID. See `man getpid` for more
> details about this system call.

> Exercise #
>
> Use the command `ps -p` followed by a `pid` to display details about the process
> from the previous exercise.

# System calls

A process is able to send requests to the kernel to perform some actions. For
example, to write some data in a file or to create a nw process. These requests
called *system calls* changes the processor state from *user mode* to *kernel
mode* and give the control to the kernel. Once this action is completed, the
kernel gives back the control to the calling process.

Each system call is wrapped by a C library function. This function copies all
arguments to appropriate locations, stores the system call number in a CPU
register, and raises a particular software interrupt to give control to the
kernel. In response, the kernel invokes the appropriate system call service
routine that is identified by the number stored in the CPU register.

If there is an error during the system call, then the routine sets the global
integer variable `errno` to a positive value that identifies what went wrong. A
list of error names defined on Linux is available in `man errno`. If the call is
successful, then the corresponding C library function returns 0.  Otherwise, it
returns -1. The routine `void perror(const char *s)`, defined in `errno.h`,
produces a message on the standard error output the string `s` followed by a
message corresponding to the value of `errno`. In what follows, we sill make no
difference between a system call and its corresponding C library function.

Almost every system call indicates whether the call succeeded or failed by
returning a status value. Usually, a system call returns `-1` in order to
indicate that an error occurred and sets the global integer variable `errno` to
a positive value that specifies the type of error. An error message can be
obtained, based on this value, by calling the functions `perror()` or
`strerror()`.

# Signals

A **signal** is a software notification to a process that an event has occurred.
They are sent by the kernel (*for example, caused by an hardware exception, or
when the user typed special characters such as interrupt with `Control-C` or
suspend with `Control-Z`*) or other processes for synchronization or simple
communication purpose.

The `kill()` system call sends a given signal to another process. Its prototype
is the following (see `man 2 kill`). 

```C
#include <signal.h>
int kill(pid_t pid, int sig);
```

For example, `kill(8907, SIGTERM)` sends the *termination* signal to the process
with `pid` equal to 8907. This signal is a way to *request* a process to
terminate. This signal can be blocked, handled, and ignored. A list of other
signals is available in `man 7 signal`. A well designed application will
terminate gracefully when the signal `SIGTERM` is received. That is to say, a
handler for cleaning up temporary files and releasing other resources. It is
worth noting that a process is not always able to send a signal to any process.
The rules are available in the `man 2 kill`. If the process doesn't have
permission, then `kill()` returns -1 and `errno` is set to `EPERM`.

Once a signal is delivered to the target process, one of the following default
action is performed (depends on the signal):

* The signal is ignored
* The process is terminated (killed)
* The process is suspended
* The process is resumed

A program is able to change the default action that occurs when a signal is
delivered with the system call `signal()`. The function prototype is the
following.

```C
#include <signal.h>
typedef void (*sighandler_t)(int);
sighandler_t signal(int signum, sighandler_t handler);
```

Where `sighangler_t` defines a type of pointer to a function passing an `int`
and returning `void`. The first parameter, `signum`, identifies the signal
whose action is to be changed. The second parameter, `handler`, is a pointer to
the function that has to be called when the signal, `signum`, is delivered. The
integer argument passed to the handler, by the kernel, identifies the signal
that caused the invocation, because the same handler might be configured to
catch different types of signals (with multiple call to `signal()`).

Several signals are sent by keyboard shortcuts, such as the `SIGINT` with
`Control-c` (equivalent to `SIGTERM`, but sent to the foreground process group,
see later), `SIGTSTP` with `Control-z`, and `SIGQUIT` with `Control-\ `
(equivalent to `SIGINT`, but generates a core dump as well for debugging
purposes).

> Exercise #
>
> Write a program that prints the value of a counter every 3 seconds, increasing
> as it prints. Create a signal handler that prints a message when the signal
> `SIGINT` is delivered. Use the `SIGQUIT` signal to this process to terminate
> the program. Explain the result.

It is worth noting that it is impossible to change the default actions for
`SIGKILL` and `SIGSTOP` (the process is stopped, *i.e.*, forbidden to run until
being restarted by `SIGCONT`).

# File I/O

\centerline{\includegraphics[scale=0.8]{image/file_tables.pdf}}

A process refers to an open file with a file descriptor, *i.e.*, a non-negative
integer. This value refers to a table of file descriptors maintained for each
process by the kernel. Each entry in this table contains the following
information:

* A set of flags (in practice there is only the *close on exec* flag)
* A reference to the open file descriptor in a system wide open file descriptor
  table called the *open file table* that contains further details on the open
  files (file offset, status flag, i-node pointer)

When a process is started by the shell it starts with three standards
file descriptors :

* 0 : standard input (`STDIN_FILENO` as defined in `unistd.h`)
* 1 : standard output (`STDOUT_FILENO`)
* 2 : standard error (`STDERR_FILENO`)

You can use various system calls such as `read()` and `write()` to perform I/O
operations. Let us consider the following function that returns the next file
read from a file.

```C
#include <errno.h>
#include <unistd.h>

int readline(int fd, char *buf, int nbytes) {
   int numread = 0;
   int returnval;

   while (numread < nbytes - 1) {
      returnval = read(fd, buf + numread, 1);
      /* If the read() syscall was interrupted by a signal */
      if ((returnval == -1) && (errno == EINTR))
         continue;
      /* A value of returnval equal to 0 indicates end of file */
      if ( (returnval == 0) && (numread == 0) )
         return 0;
      if (returnval == 0)
         break;
      if (returnval == -1)
         return -1;
      numread++;  
      if (buf[numread-1] == '\n') {
         /* make this buffer a null-terminated string */
         buf[numread] = '\0';
         return numread; 
      }  
   }    
   /* set errno to "invalid argument" */
   errno = EINVAL;
   return -1;
}
```

> Exercise #
>
> Use the function `readline()` to write a program named `echo.c` that writes to
> the standard output everything read from standard input. The program
> terminates when it reads an end of file (generated with `Control-d`).

A given file is associated to a new file descriptor with the system call
`open()` (see `man 2 open`). For example, `myfd = open("/home/julien/file.txt",
O_RDONLY | O_APPEND)` creates an entry in the process file descriptor table
identified by `myfd`. This entry points to a new entry in the open file table
combining an access mode equal to `O_RDONLY` (read-only) and the flag `O_APPEND`
(the file offset is moved to the end of the file). This second entry points to
the in-memory i-node table. Each i-node (short for index node) describes a
particular file residing in the file system. This in-memory table contains an
entry for each *active* file in the system. All the i-nodes are stored on disk
and are loaded in memory as soon as the corresponding file is opened.

> Exercise #
>
> Based on the program skeleton `copy.c`, write a program that copies the
> content of an existing file into a new file. The name of these files should be
> provided as arguments of this program. You have to handle all the errors that
> may occur.

When a process terminates, all of its file descriptors are automatically closed
in order to release its associated kernel resources. There exists a maximal
number of file descriptors for each process. In order to avoid running out of
file descriptors, it is important to close explicitly file descriptors as soon
as they are unneeded with the system call `close()` (see `man 2 close` for more
details).

```C
#include <unistd.h>
int close(int fd);
```

> Exercise #
>
> Modify the previous program so that all the file descriptors are explicitly
> closed.

# Process creation
A process can create new processes using the **fork()** system call. In other
words, a process is *created* with the *fork()* system call. The process that
calls *fork()* is the **parent process**, and the new process is the **child
process**. Each process is identified by a **pid** (process ID) and identifies
its parent process with a **ppid** (parent process ID). This induces a tree-like
structure starting from the **init** process with a `pid` equal to 1. The new
child process is an almost exact duplicate of the parent. The child obtains
*copies* of the parent's stack, data, heap, and text segments (for better
performance, the kernel implement a *copy-on-write* strategy so that segments
are duplicated only if modified).

After the system call `fork()` has completed its work, two processes exists.
Each process continues form the point where `fork()` returns. What distinguishes
the two processes is the value returned from this function. For the parent, this
value is equal to the child process's PID, whereas for the child, this value is
equal to 0. In case of failure, the function returns -1 as usual.

Try and understand the following program :

```C
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <sys/types.h>

int main(int argc, char *argv[])
{
    pid_t pid = fork();
    if (pid == 0) {
        printf("Child process (PID = %d, parent PID = %d)\n", getpid(), getppid());
    } else if (pid != -1) { 
        printf("Parent process (PID = %d, child PID = %d)\n", getpid(), pid);
    } else {
        perror("Failed call to fork");
        return 1;
    }

    return 0;
}
```

> Exercise #
>
> Write a program that illustrates that the child process gets its
> own copy of the stack and data segments. For this purpose, declare a variable
> that is allocated in the data segment, and a second variable allocated in the
> stack segment. For this purpose, you may have to use `sleep()` declared in
> `unistd.h` (see `man 3 sleep`).

> Exercise #
>
> Display the *ppid* of a process before and after its parent process complete its
> execution. What do you conclude ?

> Exercise #
>
> Write a program that illustrates that file descriptors are shared by child and
> parent processes after a `fork()`. For example, the program open a file in
> write only (without the `O_APPEND` flag enabled), then it calls `fork()`. The
> child process write a finite sequence of digits in the file and the parent
> process write a finite sequence of letters. Use `sleep()` in order to
> interlace the execution of the two processes. What happens if the file is
> opened after the call to `fork()` ?

The `wait()` system call suspends the execution of the calling process until one
of its children terminates. This function has an output parameter (`int
*status`) that stores the termination status of that child once the call is
completed. This function also returns the `PID` of the terminated child, or `-1`
on error. For example the following loop is used to wait for all children of the
calling process to terminate.

```C
#include <sys/wait.h>
/* pid_t wait(int *status); */

int status;
pid_t childPid;
while ((childPid = wait(&status)) != -1)
    printf("Child process : %ld\n", (long) childPid);

if (errno != ECHILD) /* ECHILD : there is no children */
    printf("An unexpected error...interrupt, or invalid argument\n");
```

> Exercise #
>
> With the help of the `wait()` system call, transform the program of the
> previous exercise so that all the digits appear before all the letters in
> the output file. Do not use the `O_APPEND` flag when opening the output file.

The value of `status` can be inspected with macros such as `WIFEXITED(status)`
which returns true if the child process terminated normally. Other macros can be
found in man pages (`man 2 wait`).

The `waitpid()` system call allows to wait for a particular child whose process
`ID` is equal to a given `pid`:

```C
pid_t waitpid(pid_t pid, int *status, int options);
```

Moreover, instead of waiting for a process to terminate, this system calls
suspends execution of the calling process until the child has change state.
That is to say, the child terminated; the child was stopped by a signal; or the
child was resumed by a signal.

The value of `options` can include zero or more of the following options:

* `WNOHANG` : Return immediately if no child specified by `pid` has yet changed 
state
* `WUNTRACED` : Also return when a child process is `stopped` by a signal
* `WCONTINUED` : Also return when a child has been resumed by delivery of a 
`SIGCONT` signal

> Exercise #
>
> Write a program that illustrates the use of `WUNTRACED` and
> `WCONTINUED`. Use the command `kill -SIGSTOP` to stop the child process and
> `kill -SIGCONT` to continue the execution of the child process.

The following program creates a fan of `n` processes (a parent process and `n-1` child processes),
where `n` is passed as a command-line argument.

```C
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <sys/wait.h>
#include <errno.h>

pid_t r_wait(int *stat_loc) {
   pid_t retval;
   while (((retval = wait(stat_loc)) == -1) && (errno == EINTR)) ;
   return retval;
}

int main(int argc, char *argv[]) {
   pid_t childpid;
   int i, n;

   if (argc != 2) {
      fprintf(stderr, "Usage: %s n\n", argv[0]);
      return 1;
   }
   n = atoi(argv[1]);
   for (i = 1; i < n; i++)
      if ((childpid = fork()) <= 0)
         break;

   while(r_wait(NULL) > 0) ;    /* wait for all of your children */ 
   fprintf(stderr, "i:%d  process ID:%ld  parent ID:%ld  child ID:%ld\n",
           i, (long)getpid(), (long)getppid(), (long)childpid);
   return 0;
}
```

> Exercise #
>
> Explain what happens when you replace the test `(childpid = fork()) <= 0` of
> the previous program with `(childpid = fork()) > 0`. 

> Exercise #
>
> Explain what happens when you replace the test `(childpid = fork()) <= 0` of
> the previous program with `(childpid = fork()) == -1`.

> Exercise #
>
> How can you modify the program so that you can use `pstree` (for example,
> `pstree 4` shows the running processes rooted at the process with PID equal
> to 4) to see the processes that are created ?

> Exercise #
>
> What happens if you interchange the `while` loop and `fprintf` statements ?

> Exercise #
>
> What happens if you replace the `while` loop with the statement `wait(NULL);`
> ?