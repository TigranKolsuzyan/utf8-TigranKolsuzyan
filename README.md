# UTF-8 Decoding of Unicode

## Algorithm: UTF-8 Encoding to Unicode

UTF-8 is a character encoding standard used for electronic communication. UTF-8 is capable of encoding all 1,112,064 valid Unicode values using a variable-width encoding of one to four bytes. 

In this assignment your are to a write a program that decodes a binary string that represents a series of UTF-8 encoded Unicode characters.  

This binary string is represented within a text file, say `input_1.txt`, as a series of hexadecimal numbers. Each line in the file contains a single hexadecimal number.  The end of file is denoted with the value of -1. 

## Example

As an example, consider the encoding for a 'WHITE FOUR POINTED STAR', which has a Unicode designation of U+2727.  For more info on this character see https://www.fileformat.info/info/unicode/char/2727/index.htm

When the U+2727 character is encoded as a UTF-8 string the binary encoding is:  `2# 1110 0010 1001 1100 1010 0111`.
Whereas the hexadecimal representation of this encoding is: `16# e29ca7`. 

For the purpose of the assignment, this UTF-8 string is stored within the file `input_1.txt` as:

```cat input_1.txt
e2
9c
a7
-1
```

The execution of this program is as follows:

  ```bash
  $ cat input_1.txt | java_subroutine -R null -L java/utf.j decode
  2727
  $ echo $?
  1
  ```
The output of the program is the Unicode designation for each character (with the U+ prefix), and the exit status of the program is the number of UTF-8 characters that have been successfully decoded. Notice the exit status has been stored in the shell variable '?', and then emitted to the terminal via the `echo` command.


## Algorithm Overview:

The algorithm is comprised of two major pieces.
  1. a loop that reads a series of hexadecimal values
  1. a set of instructions that decodes each UTF-8 character

The pseudo code for this loop is as follows:

  ```pseudo code
  count = 0
  LOOP
    - read 1 hexadecimal value, let v_1 be that value
    - if v_1 > 0xFF, break from the main LOOP
    - decode character
    - count ++
  END LOOP
  return count
  ```

The pseudo code for this decoding the UTF-8 is as follows:

   ```pseudo code
   - let b = bytes_to_read (v_1)
   - if b == -1, break from LOOP
   - eliminate the framing bits from v_1
   - read b-1 hexadecimal values, let v_2, v_3, v_4 be those values
   - validate each of the values are continuation bytes
     * if any are not continuation bytes then break from LOOP
   - eliminate the framing bytes from v2, etc
   - reassemble the values v_1, ... v_4, as appropriate, into v
   - print v as a hexadecimal value
   ```

## Specifications and Limitations
   1. You must use branches as demonstrated by the [Programming Workflow](./programming_workflow.md) document.
      * A branch must exist for the tasks:  'java', 'java_tac', and 'mips'.
      * Each branch must have at least 4 commits.
      * Each branch must be merged into the main branch.
      * A submission tag must exist for each branch: 'java_submitted', 'java_tac_submitted', 'mips_submitted'.
      * Such tags must be associated with a commit that is created prior to the due date.

   1. Your java_tac code may use operations with immediate values.
      - but such immediate values can only be the second operand
      - for example,  `var = var {op} imm;` is permissible.
      - for example,  `var = imm {op} var;` is *not* permissible.

   1. Refer to comp122/reference/TAC_transformation to aid you in transforming java to java_tac

   1. Refer to comp122/referenceTAC2mips.md to aid you in transliterating java_tac to MIPS.


## Tasks
Note that these instructions presume that the current working directory is: `~/classes/comp122/deliverables/40-utf8-{account}`.


### Getting Situated 

Your program will consist of the following java methods:
   1. public static int decode();
      - the pseudo for this method is provided above
      - it returns the number of UTF-8 characters decoded

   1. public static int bytes_to_read(int v);
      - example usage: `b = bytes_to_read(v);`
      - this method implements the following table

        | Condition               | b = bytes |
        |-------------------------|----------:|
        | 0x0000 <= v <=     0x7F |     1     |
        | 0x0080 <= v <=    0x7FF |     2     |
        | 0x0800 <= v <=   0xFFFF |     3     |
        | 0x1000 <= v <= 0x10FFFF |     4     |
        | otherwise               |    -1     |  

      - see Slide 21 from introduction-to-encodings.pdf


   1. public static int isContinuation(int v);
      - example usage:  value = isContinuation(v);
      - the implement of this method is as follows:
        ```java
         public static int isContinuation(int value) {
            // format of value: | ff dd dddd |
            //   where  'f' denotes a framing bit
            //   where  'd' denotes a data bit

            int retval;
         
            retval = -1;
            // eliminate the data bits from value
            value = value & 0xC0;  // 0xC0 == 0b1100 0000

            // ensure the frame bits are "10"
            if (value == 0x80) {   // 0x80 == 0b1000 0000
             retval = 0;
            }
            return retval;
        ```

Consider defining the following methods.  With these methods, you can more easily test each of them to ensure they are working correct.

  ```java
  public static int eliminate_bits_2(int value);
  public static int eliminate_bits_3(int value);
  public static int eliminate_bits_4(int value);
  ```

Each of these methods should, effectively, contain only one line of code.  After they work correctly, you might want copy the relevant line/s of code into the body of your `encode` method.

Your manual testing could be performed as follows:

  ```bash
  $ java_subroutine -L java/utf8.j -R hex eliminate_bits_2 0xCF
  0x0000000f
  $
  ```

### Test_cases:
  1. Review the files in `test_cases`
     1. decode.sth_case
     1. isContinuation.sth_case
     1. bytes_to_read.sth_case

  1. Do not assume that these test cases are correct!

  1. Create at least four additional cases for each method
     - Refer to your deliverables/22-utf8-encodings-{account} directory
     - Refer to https://www.fileformat.info/info/unicode/char/a.htm
     - You may share your test cases with your colleagues.

  1. Commit your changes onto the `main` branch.

Remember, do NOT rely solely on automated testing. You need to test your code during the development process.


### Java: `utf8.j`

  1. Remember to following the [Programming Workflow](./programming_flow.md))
  1. Touch the file java/utf8.j
  1. Add and commit the file
  1. Implement the methods: `bytes_to_read` and then `encode` 
  1. Perform manual testing as you develop your solution
  1. Continue working on your solution until you have a working solution.
  1. Run `make test_java` to invoke the automated testing.
  1. Finish your Java Task   

### Java_tac: `utf8.j`  
  1. Start the `java_tac` Task
  1. Incrementally work on your `java_task` task
  1. Review you TAC code to ensure
     1. all variables are declared at the top of our method
     1. all variables are initialized (as appropriate) 
        - *after* the variable declarations.

     1. labels have be inserted for all control flow statements
     1. each label is associated with 
         - a null statement (`;`), or
         - a control flow statement: `if`, `for`, `while`, `do`, etc.
     1. a `break` or `continue` is at the end of code blocks   (`{}`)
     1. the control arms of each control-flow statement has been simplified
     1. immediate values are only located in the last operand position
  1. Finish the `java_tac` task.


### MIPS: `utf8.s`
  1. Start the `mips` Task with the file `mips/utf8.s`
  1. Copy your java_tac code into `mips/utf8.s`
  1. Edit your code by commenting out, etc., your java code
  1. Include the following code into `mips/utf8.s`
     ```mips
                    .text
                    .globl decode
                    .globl isContinuation
                    .globl bytes_to_read
                    # insert .globl for any other methods
                    # that you want to test

                    .text
                    .include "include/stack.s"
                    .include "include/syscalls.s"
                    .include "include/subroutine.s"
                    .include "include/io.s"
     ```

  1. Incrementally work on your `mips` task to transliterate each of your java_tac statements.

  1. Recall that the TAC -> MIPS mapping for method calls.

     | Java TAC                | MIPS Macro                |
     |-------------------------|---------------------------|
     | c = method(b);          | call method a             |
     |                         | move c, $v0               |
     |                         |                           |
     | c = method(a, b);       | call method a b           |
     |                         | move c, $v0               |
     |                         |                           |
     | method(a);              | call method a             |
     |                         |                           |
     | method(a, b);           | call method a b           |
     |                         |                           |


  1. Finish the `mips` task.

 
### Finish the assignment: 
At this point, you have completed the assignment and you have submitted it. But now you have a chance to "confirm" that when the Professor grades the assignment, it is based upon what you believe you submitted.

In short, perform one more test to make sure everything is as it should be.

  ```bash
  git switch main
  make confirm
  ```

Make any alterations to your previous work to ensure you maximize your score.  Note you must remember to reset and to republish your "submission" tags correctly.  The tags are what the Professor uses to determine *what* to grade.



