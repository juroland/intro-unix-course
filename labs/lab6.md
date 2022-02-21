## AWK : the pattern scanning and processing language

The AWK programming language was created in 1977 by **A**ho, **K**ernighan, and **W**ienberger. This
language is mainly used for parsing files (or piped streams) a line at a time. An AWK *program*
consists of a set of pattern-action statements:

```
pattern { action statements }
pattern { action statements }
...
```

An AWK program can be used just like `sed` : `awk 'program' filenames` or `awk -f cmdfile
filenames`, where `cmdfile` is the program file. Each line in the `filenames` is compared with each
*pattern* in order. If the *pattern* matches the lines, then the corresponding *action statements*
are performed. For example, `awk '/bash/ { print }' /etc/passwd` prints every line in `/etc/passwd`
that matches the regular expression `bash`. The action or the pattern can be omitted. By default,
the action is to print the line (`{ print }`). By default, the pattern matches every input line. For
example, the awk programs `'/bash/'` and `'/bash/ { print }'` are equivalent.

1. Create the user *user6* with `useradd`.
2. Using only `awk`, get the line from `/etc/passwd` whose the `uid` is 6.

AWK splits each input line into **fields** denoted by `$1`, `$2`, ..., `$NF`, where `NF` is set to
the **N**umber of **F**ields.

3. What is the meaning of  `ls -l | awk '{ print $1, $9 }'`, `ls -l | awk '/file/ { print $1, $9
   }'`, and `ls -l | awk '{ print NR, NF }'` ?
4. Using only `who`, `awk`, and `sort`, print the name and time of login sorted by time in reverse
   order (you have to use the option `-k` of `sort` in order to sort with respect to a particular
   field).

By default, the fields are separated by blanks or tabs, but the separator can be changed with the
command line option `-F` followed by the new separator between single quotes.

5. Using only `awk`, list all the `username` and `uid` fields in `/etc/passwd`.

`BEGIN` and `END` are two special patterns. `BEGIN` actions are performed before the first input
line has been read. For example, to initialize a variable:

```
$ cat /etc/passwd | awk 'BEGIN {FS = ":"}
>                        $7 == "/bin/bash" {print $1}'
root
julien
alice
```

`END` actions are performed after the last line of input has been processed.

6. Using only `awk`, print **only** (and only once) the number of lines in `/etc/passwd` (check your
   result with `wc`).
7. What is the meaning of the following program :

	```awk
		    { s = s + $5 }
		END { print s }
	```

8. Using `awk`, `ls`, and `grep`, compute the total and average file size in your current directory.

The control flow statements (`if`, `for`, `while`) are just like that in the C programming language :

```awk
	if (condition)
		actions
	else
		actions

	for (expression1; condition; expression2)
		actions

	while (condition)
	{
		actions
	}
```

The following operators are also available:

* Assignment : `=`, `+=`, `-=`, `*=`, `/=`, `%=`
* Logical operators : `expr1 || expr2`, `expr1 && expr2`, `!expr`
* Relational operators : `>`, `>=`, `<`, `<=`, `==`, `!=`, `~`, `!~`, where `~` and `~!` perform
  **regular expression comparison**. For example, `$1 !~ /J/` matches all lines whose first field
  does not contain the upper-case letter `J`.
* Arithmetic : `+`, `-`, `/`, `*`, `%`
* Increment and decrement (prefix or postfix) : `++`, `--`

9. What is the meaning of the following program (apply this program on `/etc/passwd` with `awk -f`):

	```awk
		BEGIN { FS=":" }
		      { line[NR] = $1 }
		END   { for (i = NR; i > 0; i--) print line[i] }
	```

AWK provides also the following **built-in functions** :

*  `print`, `printf` : display functions
*  `cos(expr)`, `sin(exp)`, `exp(expr)`, `log(expr)`
*  `getline()` : reads next input line; returns 0 if EOF, 1 if not
*  `index(s1, s2)` : position of string s2 in s1; returns 0 if not found
*  `int(expr)` : the integer part of expr
*  `length(s)` : length of string s
*  `split(s, a, c)` : split s into a[1]...a[n] on character c; return n
*  `sprintf(fmt,...)` : formats ... according to specification fmt, returns a string
*  `substr(s, m, n)` : n-character substring of s beginning at position m

10. The variable `$0` is set to the entire input line. Using only `awk`, list all the `username` in
    `/etc/passwd` by using the function `split()`. The use of `-F` and `FS` is *prohibited*. **Save
    this file as `lastname_firstname_1.awk`.** (2pt)

11. Write an AWK program that prints the message "Line *i* is too long" if the length of the *i-th*
    line is greater than 30. Then print on a single line the number of such lines. **Save this file
    as `lastname_firstname_2.awk`.** (4pt) For example :
    ```
    Line 1 is too long
    Line 2 is too long
    Line 5 is too long
    3
    ```

12. Explain the following program (applied on `/etc/group`):

	```awk
		BEGIN { FS=":" }
		$1 ~ /^a/ {
			print "Group :", $1;
		    print "Users :";
			split($4, users, ",");
			for (i in users)
				print users[i];
			print "+++++++";
		}
    ```

13. Explain the following program (applied on `/etc/group`):

	```awk
		BEGIN { FS=":" }
		{
		  split($4, users, ",");
		  for (i in users)
			  sum[users[i]]++;
		}
		END {
			for (name in sum)
				print name, sum[name];
		}
	```

14. Using `awk`, display `/etc/passwd` switching all the ':' separators with ';'. You might have to
    use the `printf` statement. This statement takes the form `printf format, item1, item2,...`,
    where the first argument is the format string. For example, `awk '{ printf "%-10s %s\n", $1, $2
    }' mail-list`. By default, this statement does not append a new line to its output. **Save this
    file as `lastname_firstname_3.awk`.** (4pt)

1. Try and explain the following code:
```awk
	BEGIN {
	    print "Enter your name"
		getline
		printf "hello " $0 "\n"
	}
```
Compare the use of the program with or without input file.

1. In awk, it is also possible to define functions. The syntax for a function is:
```awk
	function name (parameter-list) {
		statements
	}
```
   Write a function displayme which echoes on the standard output anything the
   user enters on the keyboard. The "main" function (*i.e.*, `BEGIN { }`) should
   deal with the entry loop (hint : what is the value returned by `getline` ?).
   The loop should end whenever the user types END. For example :
```
    awk -f ex2.awk
    Hello World
    You said : Hello World
    !
    You said : !

    You said : 
    END
    Goodbye!
```

1. Retrieve the files `namelist`, `tel` and `pin` from the campus site. Compare the following three
   awk scripts executed on the file `namelist`:
     1.
```awk
	{
    		print "Initial: " $0
    		"cat tel" | getline
    		print $0
    		print "Final: " $0 "\n"
	}
```
    1.
```awk
	{
    		print "Initial: " $0
    		"cat tel" | getline tel
    		print tel
    		print "Final: " $0 "\n"
	}
```
    1.
```awk
	{
    		print "Initial: " $0
            "cat tel" | getline tel
            print tel
    		print "Final: " $0 "\n"
    		close("cat tel")
    }
```

1. Using a single awk program, create a script displaying on the standard output the name, the room,
   the telephone number and the pin number of each user defined in `namelist`. Should the information
   not be present in the tel or in the pin files, the string N/A will be
   displayed. This program is executed as `awk -f myprog.awk namelist` and the following output
   format has to be used :
```
    Name: Mary
    Tel: N/A
    Pin: N/A
    Name: John
    Tel: 1030
    Pin: 9012
```
   **Save this file as `lastname_firstname_4.awk`.** (5pt)
