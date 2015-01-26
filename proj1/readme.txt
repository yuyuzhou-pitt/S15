Readme/Report for compiler project 1.
Yuyu Zhou
yuz69@pitt.edu


Contents
--------
I. Test environment
II. How to build
III. How to test
IV. Test report
    1. Identifier
    2. String constants
    3. Tokens
    4. String Table
V. Clarification
P.S. Output of the test result


I. Test environment
-------------------
  This code has been tested on machine oxygen.cs.pitt.edu.
  - OS: CentOS release 6.5
  - kernel: 2.6.32-431.11.2.el6.x86_64
  - flex: flex-2.5.35-8.el6.x86_64

II. How to build
----------------
  Run make to get the executable mylex file:
  $ tar xvf yuz69_proj1.tar
  $ cd code/
  $ make
  $ ls
  $ makefile  mylex  mylex.c  mylex.l  token.h

III. How to test
----------------
  Run ./mylex with the test files under test_cases/:
  $ cd code/
  $ ./mylex < ../test_cases/test1.mjava
  $ ./mylex < ../test_cases/test2.mjava

IV. Result analysis
-------------------
1. Identifier
Rule: 
id                       [a-zA-Z][a-zA-Z0-9]*

Descriptions:
- Beginning with a letter, and followed by a sequence of (upper or lower case) letters or digits
- Upper and lower case are not distinguished
- Reuse the index if it's already in the String Table
- Use yytext to get the identifier and put into String Table

Results: 
- These identifiers are matched in test1.mjava and stored in the String Table:
    test1.mjava: myid abd klse
    test2.mjava: this will be used as the correct p2 test main x i system readln println end
- Same identifiers point to the same index of the String Table:
    test1.mjava: abd and AbD point to the same index (11)
    test2.mjava: i in line 10, 13, and 16 point to the same index (48)
                 System in line 14, 15, and 18 point to the same index (50)
                 println in line 15, and 18 point to the same index (64)
- Report Error when matching 55alf, as it starts with digits 
- Report Error when matching |, as it connot be recognized


2. String constants
Rules:
\'(\\.|[^\\'\n])*("\n")   { 
                          printf("Error: line %d: Uneding String.\n", yyline);
                          yyline+=1;yycolumn=0;
                          }
\'(\\.|[^\\'\n])*(\')     {
                          if ((yytext[yyleng-1] == '\\') && (yytext[yyleng] == '\''))
                              yymore();
                          else {
                              yycolumn+=yyleng;
                              yystring=yytext;
                              yylength=yyleng;
                              return(SCONSTnum);
                              }
                          }

Descriptions:
- A sequence of characters surrounded by single quotes (')
- Supported escape sequences: \n, \t, \\, and \'
- Escape sequence is converted into the char it represents, and it counts 1 when it stores in String Table
- Multiple line is not supported as the email states
- use yytext to get the string and put into String Table

Results:
- These string constants are matched: 
    test1.mjava: '\n\t\\\'', ''
    test2.mjava: 'End of Program'
- The single quotes (') is not stored in String Table
- Report Error when onely one single quates matched: 
    test1.mjava: 55alf', '\n\t\\\'''

3. Tokens
Rules (parts of):
consint       [0-9]+
declarations  [dD][eE][cC][lL][aA][rR][aA][tT][iI][oO][nN][sS]
int           [iI][nN][tT]
method        [mM][eE][tT][hH][oO][dD]

Descriptions:
- Each token (integer aliased with the symbolic token name) is returned by the lexical analyzer.
- Token is case insensitive
- use yyleng to indicate the column number

Results:
- All the tokens are identified as Token name in the token table.
- Case insensitive (except punctuation):
    test1.mjava: dEclarations, reTurn, claSs, voiD, method

4. String Table
The string table stores the identifiers and string constants. Please see details in Identifier and String constants.


V. Clarification Questions
--------------------------
(1) Do we support multiple line of comment, or multiple line of string?
Example:
/* multi line
   comment */

printf (' Hello
           World' );

(2) escape sequences like '\n' '\t' '\'' \\, can I only handle then when they
show up in a string? They are not legal to show up anywhere else anyway.
for string table, if I have a '\n', the output of string table will be split
into two line, is that ok?

(3) unrecognizable single, like '|', '_', could I treat them all as wrong ID
as the default?

Professor Zhang answered above questions in email:
(1) no
(2) yes, only in the string. no need to handle multiple-line string, etc.
(3) yes.


P.S.: Output of the test result
-------------------------------
-bash-4.1$ ./mylex < ../test_cases/test1.mjava
Error: line 2: Wrong ID.
Error: line 2: Uneding String.
Error: line 3: Uneding String.
Error: line 9: Wrong ID.

      Line    Column                    Token    Index_in_String_Table
         0         1                ICONSTnum
         0         4                 ASSGNnum
         0         6                    LTnum
         1        12          DECLARATIONSnum
         1        17                    IDnum            0
         3        10                SCONSTnum            5
         5         2                SCONSTnum           10
         6         3                    IDnum           11
         6         9                 CLASSnum
         7         3                    IDnum           11
         8         4                    IDnum           15
         8        11                RETURNnum
         8        18                 CLASSnum
        10         4                  VOIDnum
        10        12                METHODnum
                                       EOFnum
myid 
	\'  abd klse 

-bash-4.1$ ./mylex < ../test_cases/test2.mjava 
Error: line 0: Unmatched comments.
Error: line 12: Unmatched comments.

      Line    Column                    Token    Index_in_String_Table
         2         5                    IDnum            0
         2        10                    IDnum            5
         2        13                    IDnum           10
         2        18                    IDnum           13
         2        21                    IDnum           18
         2        25                    IDnum           21
         2        33                    IDnum           25
         2        41               PROGRAMnum
         5         7               PROGRAMnum
         5        10                    IDnum           33
         5        11                  SEMInum
         6         5                 CLASSnum
         6        10                    IDnum           36
         6        12                LBRACEnum
         7        14                METHODnum
         7        19                  VOIDnum
         7        24                    IDnum           41
         7        25                LPARENnum
         7        26                RPARENnum
         8        18          DECLARATIONSnum
         9         6                   INTnum
         9         8                    IDnum           46
         9         9                  SEMInum
        10        20                   INTnum
        10        22                    IDnum           48
        10        24                 EQUALnum
        10        26                ICONSTnum
        10        27                  SEMInum
        11        28       ENDDECLARATIONSnum
        12         2                LBRACEnum
        13         7                 WHILEnum
        13         9                LPARENnum
        13        10                    IDnum           48
        13        12                    LTnum
        13        15                ICONSTnum
        13        16                RPARENnum
        13        18                LBRACEnum
        14        30                    IDnum           50
        14        31                   DOTnum
        14        37                    IDnum           57
        14        38                LPARENnum
        14        39                    IDnum           46
        14        40                RPARENnum
        14        41                  SEMInum
        15        30                    IDnum           50
        15        31                   DOTnum
        15        38                    IDnum           64
        15        39                LPARENnum
        15        40                    IDnum           46
        15        41                RPARENnum
        15        42                  SEMInum
        16         4                    IDnum           48
        16         7                 ASSGNnum
        16         9                    IDnum           48
        16        11                  PLUSnum
        16        13                ICONSTnum
        16        14                  SEMInum
        17        17                RBRACEnum
        17        18                  SEMInum
        17        22                    IDnum           72
        17        28                 WHILEnum
        17        30                 TIMESnum
        17        31                DIVIDEnum
        18        22                    IDnum           50
        18        23                   DOTnum
        18        30                    IDnum           64
        18        31                LPARENnum
        18        47                SCONSTnum           76
        18        48                RPARENnum
        18        49                  SEMInum
        19         2                RBRACEnum
        20         1                RBRACEnum
                                       EOFnum
this will be used as the correct p2 test main x i system readln println end
end of program 
-bash-4.1$ 
