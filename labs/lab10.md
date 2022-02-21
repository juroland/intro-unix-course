---
title: "UNIX System Programming"
author: Julien Roland
date: 2017
---

## System calls

* A process is able to **send requests to the kernel** to perform some actions. For
example, to write some data in a file or to create a new process. These requests
are called **system calls**.

**Each system call is wrapped by a C library function** :

* This function copies all arguments to appropriate locations
* Stores the system call number in a CPU register
* Raises a particular software interrupt to give control to the kernel. 
* In response, the kernel invokes the appropriate system call service routine that is identified
  by the number stored in the CPU register.


## The `open()` System Call

A given file is associated to a new file descriptor with the following system call (see `man 2
open`):

```C
int open(const char *pathname, int flags);
int open(const char *pathname, int flags, mode_t mode);
```

For example :

```C
myfd = open("/home/julien/file.txt", O_RDONLY | O_APPEND)
```

## File Descriptors

* A process refers to an open file with a file descriptor, *i.e.*, a non-negative
integer. This value refers to a **table of file descriptors** maintained for each
process by the kernel.

* Each entry in this table contains the following information:
    * A set of flags (in practice there is only the *close on exec* flag)
    * A reference to the open file descriptor in a system wide open file descriptor
      table called the *open file table* that contains further details on the open
      files (file offset, status flag, i-node pointer)

## Standards File Descriptors

When a process is started by the shell it starts with three standards file descriptors :

* 0 : standard input (`STDIN_FILENO` as defined in `unistd.h`)
* 1 : standard output (`STDOUT_FILENO`)
* 2 : standard error (`STDERR_FILENO`)

## The `open()` system call and the File Table

```C
myfd = open("/home/julien/file.txt", O_RDONLY | O_APPEND)
```

* This call creates an entry in the process file descriptor table identified by `myfd`.

* This entry points to a new entry in the **open file table** combining an **access mode** equal to
  `O_RDONLY` (read-only) and the **status flag** `O_APPEND` (the file **offset** is moved to the end
  of the file).

* This second entry points to the in-memory i-node table. A table that contains an entry for each
  *active* file in the system.

## File descriptors, open file descriptors, and i-nodes

\centerline{\includegraphics[scale=0.8]{image/file_tables.pdf}}

(From *The Linux Programming Interface*, by Michael Kerrisk, p.95)

## The `close()` System Call

* When a process terminates, all of its file descriptors are automatically closed
  in order to release its associated kernel resources.
* There exists a maximal number of file descriptors for each process. In order to avoid running out
  of file descriptors, it is important to close explicitly file descriptors as soon as they are
  unneeded with the system call `close()` :

```C
#include <unistd.h>
int close(int fd);
```

(see `man 2 close` for more details).

## Duplicating File descriptors

The following command send both *stdout* and *stderr* to the file `results.log` :

```C
./myscript > results.log 2>&1
```

`dup()` and `dup2()` system calls :

```C
int dup(int oldfd);
int dup2(int oldfd, int newfd);
```

## `dup()` and `dup2()` system calls

Let's make file descriptor 2 a duplicate of file descriptor 1 :

```C
close(2);       /* Frees file descriptor 2 */
newfd = dup(1); /* Should reuse file descriptor 2
                   (if descriptor 0 was open) */

/* or */

dup2(1, 2);
```

## I/O System Calls

You can use various system calls such as `read()` and `write()` to perform I/O
operations.

```C
#include <unistd.h>
ssize_t read(int fd, void *buf, size_t count);
ssize_t write(int fd, const void *buf, size_t count);
```

For example:

```C
int fd, n, nread, nwritten;
char buf[SIZE];

nread = read(fd, buf, n);
nwritten = write(fd, buf, n);
```

## I/O System Calls

The following program copy its input to its output :

```C
#define SIZE 512

int main()
{
    char buffer[SIZE]
    int nb_read = 0;
    while ((n = read(STDIN_FILENO, buf, sizeof buffer)) > 0)
        write(STDOUT_FILENO, buf, n);
    return 0;
}
```

## Changing the File Offset : `lseek()`

The **file offset** is the location in the file at which the next `read()` or `write()` starts.

```C
#include <unistd.h>
off_t lseek(int fd , off_t offset , int whence );
```

This system call is used to adjust the file offset with respect to the values of `offset` and
`whence` :

```C
/* Start of file */
lseek(fd, 0, SEEK_SET); 
/* Next byte after the end of the file */
lseek(fd, 0, SEEK_END);
/* Last byte of file */
lseek(fd, -1, SEEK_END);
/* Ten bytes prior to current location */
lseek(fd, -10, SEEK_CUR);
/* 10001 bytes past last byte of file */
lseek(fd, 10000, SEEK_END);
```

## Processes : Credentials

Each process has a process ID (`pid`), a positive integer that uniquely
identifies the process on the system.

The `getpid()` system call returns the process ID of a calling process :

```C
#include <sys/types.h>
#include <unistd.h>

pid_t getpid(void);
```

The return type is `pid_t`, defined an unsigned integer type. Its a common
practice to cast this value to long for printing, because there is no guarantee
that a `pid_t` will fit in a int.

See `man getpid` for more details.

## Process creation

* A process can create new processes using the **fork()** system call.
* The **parent process** : the process that calls *fork()*
* The **child process** : the new process
* **ppid** : parent process ID.

This induces a tree-like structure starting from the **init** process with a `pid` equal to 1.

## The `fork()` System Call

After the system call `fork()` has completed its work, two processes exists.
Each process continues form the point where `fork()` returns.


```C
pid_t pid = fork();
if (pid == 0) {
    printf("Child (PID=%d, PPID=%d)\n",
           getpid(), getppid());
} else if (pid != -1) {
    printf("Parent (PID=%d, Child PID=%d)\n",
           getpid(), pid);
} else {
    perror("Failed call to fork");
    return 1;
}
```

What distinguishes the two processes is the value returned from this function.
For the parent, this value is equal to the child process's PID, whereas for the
child, this value is equal to 0. In case of failure, the function returns -1 as
usual.

## Parent and Child processes : Common attributes

Among others, the following attributes are **inherited** (copies) after a call to `fork()`:

* Stack segment
* Data segment
* Heap segment
* Open file descriptors
* ...

Among others, the following attributes are **shared** after a call to `fork()`:

* Text segment
* File offsets
* Open file status flags
* Named semaphores (see later)
* ...

## Process Termination

A process can terminate either *normally* using the `_exit()` system call or
*abnormally* when terminated by a signal.

```C
#include <unistd.h>
void _exit(int status);
```

* The `status` argument defines the termination status of the process. This value
  is obtained by the parent process when it calls `wait()`.
* Although this variable is defined as `int`, only the least significant 8 bits are made
  available to the parent process.
* By convention, a **termination status of 0 indicates a successful termination**.

## Process Termination (cont'd)

It's recommended to use the `exit()` library function (defined as part of the
C standard library), instead of calling `_exit()` directly.

```C
#include <stdlib.h>
void exit(int status);
```

Indeed, further actions are performed by `exit()`:

* Exit handlers are called (see `atexit()` and `on_exit()` for registering exit handlers)
* The `stdio` stream buffers are flushed
* The `_exit()` system call is invoked with the corresponding `status` value

## Process Termination (cont'd)

```C
return n;
```

*vs*

```C
exit(n);
````

* The `return n` statement at the end of the `main()` function is **equivalent** to calling
  `exit(n)` (unless variables local to `main()` are accessed during exit which results in undefined
  behavior).

* Starting from the *C99* standard, if the main function does not contain a `return statement`, then
  by default it returns `0`.

## Monitoring Child Processes

The `wait()` system call suspends the execution of the calling process until one
of its children terminates.

```C
#include <sys/wait.h>
pid_t wait(int *status);
```

* has an output parameter, `int *status`, stores the termination status of that child
* returns the `PID` of the terminated child, or `-1` on error.

## Monitoring Child Processes (cont'd)

For example the following loop is used to wait for all children of the calling process to terminate.

```C
int status;
pid_t childPid;
while ((childPid = wait(&status)) != -1)
    printf("Child process : %ld\n", (long) childPid);

if (errno != ECHILD) /* ECHILD : there is no children */
    printf("An unexpected error...interrupt,
            or invalid argument\n");
```

The value of `status` can be inspected with macros such as `WIFEXITED(status)`
which returns true if the child process terminated normally. Other macros can be
found in man pages (`man 2 wait`).

## Program Execution

A process can replace the program that it is running by a new program with one
of the `exec()` family of functions (`man 3 exec`).

```C
#include <unistd.h>
int execv(const char *pathname, char * const argv[]);
```

This function never returns on success and returns `-1` on error.

* `pathname` : the pathname of the program to be loaded in this process's memory.
* `argv` : a `NULL` terminated array that contains the command-line arguments
to be passed to this program. This argument corresponds to the `argv` argument
of the C `main()` function.

## Program Execution (cont'd)

The following program creates a child process to run `/bin/ls` with `argv[0]` equal to
`ls` and `argv[1]` equal to `-l`.

```C
   pid_t childpid = fork();
   if (childpid == -1)  {
       perror("Failed to fork");
       return 1; 
   } else if (childpid == 0) {  /* child code */
       execl("/bin/ls", "ls", "-l", NULL);
       perror("Child failed to exec ls");
       return 1; 
   } else if (childpid != wait(NULL)) {  /* parent code */
       perror("Failed to wait due to signal or error");
       return 1;
   }
```

## Program Execution (cont'd)

Among others, the following attributes are **preserved** after a call to an `exec()` function:

* Process IDs (PID, PPID, PGID, Session ID, Read IDs)
* Open file descriptors (unless the close-on-exec flag `FD_CLOEXEC` is enabled)
* File offsets and status
* Working directory
* ..

The following attribute are **never** preserved after a call to an `exec()` function:

* Text segment
* Stack segment
* Data segment
* Heap segment
* ...

## Interprocess Communication : Pipes

A **pipe** is an unidirectional data channel that is used for communication
*between related processes*. This buffer is maintained in kernel memory and is
managed in a first-in-first-out manner.

```C
/*                ________________________
*                |       byte stream      |
*  pipefd[1] --> | unidirectional channel | --> pipefd[0]
* (write end)    |________________________|    (read end)
*/

#include <unistd.h>
int pipe(int pipefd[2]);
```

* The usual `read()` and `write()` are used to perform `I/O` on the pipe.
* This channel is *byte stream* (*i.e.*, no concept of message boundaries).

## Pipe : The `read()` System Call

A `read()`, with the file descriptor `pipefd[0]`, is **destructive**. Reading `n` bytes from a pipe
containing `p` bytes has the following semantics:

* **`p = 0`, write end open** : block.
* **`p = 0`, write end closed** : return 0 (EOF).
* **`p < n`** : read `p` bytes.

## Pipe : The `write()` System Call

A `write()` of `n` bytes with the file descriptor `pipefd[1]` has the following semantics:

* **`n <= PIPE_BUF`, read end open** : atomically write `n` bytes; if there is
    no sufficient space, then block until sufficient space is available on the
    pipe.
* **`n >= PIPE_BUF`, read end open** : write `n` bytes; if there is
    no sufficient space, then block until sufficient space is available on the
    pipe; the kernel may transfer the data in multiple smaller pieces, and
    therefore the data may be interleaved.
* **read end closed** : `SIGPIPE` + `EPIPE`.

## Pipe : Atomic Write

* A write to a pipe is guaranteed to be atomic as long as no more than `PIPE_BUF`
bytes are written at a time.^[For example, on Linux, the value of `PIPE_BUF` is
equal to 4096 bytes. The pipe capacity is 65536 bytes and can be changed by a
call to `fcntl()`with a size between the system page size and the value in
`/proc/sys/fs/pipe-max-size`.]
* This means that data written by multiple process on the same pipe won't be intermingled if they
  write no more than `PIPE_BUF` bytes.

## Pipe : Reader and Writer processes

```C
int filedes[2];
pipe(filedes);

switch (fork()) {
case -1:
    errExit("fork");
case 0: /* Child */
    close(filedes[1]);
    /* Child now reads from pipe */
    break;
default: /* Parent */
    close(filedes[0]);
    /* Parent now writes to pipe */
    break;
}
```

*Errors for each system call should be handled properly.*

## Pipe : The `close()` System Call

It is important to close unused pipe file descriptors for the following reasons:

* To ensure that a process doesn't exhaust its limited set of file descriptors.
* So that the reading process is able to see an end-of-file when the writing
    process has completed its output.
    * For this purpose, the reading process also has to close its write end of
        the pipe.
* So that the writing process is notified if it tries to write to a process for
    which no process has open the read file descriptor.
    * For this purpose, the writing process has to close the read end.
      Otherwise, the process might block indefinitely when it calls `write()`
      on a full pipe.

## System calls : errors

* If the call is successful, then the corresponding C library function returns 0.  Otherwise, it
returns -1.

```C
int fd = open("file.txt", O_RDONLY);
if (fd == -1) {
    if (errno == ENOENT)
        fprintf(stderr, "No such file or directory\n");
    /* ... */
}
```

* If there is an error during the system call, then the routine sets the global
integer variable `errno` to a positive value that identifies what went wrong.
* A list of error names defined on Linux is available in `man errno`.

## System calls : errors (cont'd)

* The routine `void perror(const char *s)`, produces a message on the standard
  error output the string `s` followed by a message corresponding to the value of `errno`.

```C
int fd = open("file.txt", O_RDONLY);
if (fd == -1) {
    /* A message...: No such file or directory */
    perror("A message..."); 
}
```

Similarly, the `strerror()` function can be used to get a string describing a given error number :

```C
#include <string.h>
char *strerror(int errnum);
```
