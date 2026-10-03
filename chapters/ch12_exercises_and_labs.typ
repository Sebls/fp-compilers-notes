#import "common.typ": bdefinition, btheorem, blemma, bproposition, bexample, bnotice

== Practical Problem Sets, Laboratory Exercises & Milestones

This appendix collects the complete laboratory exercises, milestones, and development problem sets from the course curriculum (including the parenthesized expressions parser, the scientific calculator, and the 42-stage Pascal-to-bytecode compiler). Full step-by-step solutions and implementation code are provided in the companion *Solutions Manual* (`solutions.pdf`).

=== Problem Set 1: Lexing and Parsing Well-Parenthesized Expressions

*Context:* A language of well-parenthesized expressions over characters `(` and `)`.
Examples of valid strings: `""`, `"()"`, `"()()(())"`, `"(()())"`.

==== Exercise 1.1: Maximum Parenthesis Depth
*Objective:* Write a Happy grammar that directly computes the maximum nesting depth of well-parenthesized expressions as an integer.

==== Exercise 1.2: Generalized Parse Tree Generation
*Objective:* Modify the grammar to produce an explicit multi-way tree (generalized rose tree) representing the nested syntactic hierarchy.


=== Problem Set 2: The Extended Scientific Calculator (Complete 24 Milestones)

#bnotice(caption: "Laboratory Roadmap")[
  Source: `compil_happy.pdf`, Section 5 (Pages 6–7). The student is tasked with incrementally extending `CalculatriceLexer.x`, `CalculatriceParser.y`, and `Calcul.hs` across 24 consecutive capabilities:
]

1. *Overall command syntax:* Design the interactive line evaluation discipline (single-line commands vs. statements separated by `;`).
2. *Double-precision IEEE 754 float literals:* Support standard decimal notations as well as scientific exponent representations (e.g. `31.4156E-1`, `0.5e+3`).
3. *Addition and subtraction:* Declare left-associative binary operators `+` and `-`.
4. *Multiplication and division:* Declare left-associative `*` and `/` with higher precedence over addition/subtraction.
5. *Unary negation:* High-precedence prefix `-` (using Happy's `%prec NEG` directive).
6. *Parenthesized subexpressions:* Handle arbitrary nesting of parentheses `(` and `)`.
7. *Transcendental & mathematical functions:* Implement built-in functions `sin`, `cos`, `tan`, `sqrt`, `exp`, `log`.
8. *Exponentiation operator:* Add right-associative power operator `^` (e.g. `2 ^ 3 ^ 2 = 512`).
9. *Mathematical constants:* Pre-load standard mathematical constants `pi` ($pi approx 3.141592653589793$) and `e` ($e approx 2.718281828459045$).
10. *Variable assignment & environment usage:*
    - Parse assignments `x = expr` and evaluate variable occurrences.
    - Handle unbound identifiers with graceful error reporting.
    - Provide a built-in command to display all currently bound variables in the environment.
11. *Boolean literals:* Support `true` and `false` (internally mapped to $1.0$ and $0.0$ Double representations).
12. *Logical operators:* Boolean operations `and`, `or`, `not`.
13. *Relational comparisons:* Comparison operators `<`, `<=`, `>`, `>=`, `==`, `!=`.
14. *Clean session termination:* Support `quit` and `exit` commands to terminate the REPL gracefully.
15. *Syntax error recovery:* Intercept parser and lexical errors without terminating or crashing the interactive loop.
16. *Conditional execution:* Implement inline ternary expressions or statements `if cond then e1 else e2`.
17. *Multi-expression lines:* Allow multiple sequential expressions or assignments on a single line separated by semicolons `;`.
18. *Comment elimination:* Strip line comments (`// ...`) and block comments (`/* ... */`).
19. *IEEE 754 special values:* Handle $+infinity$, $-infinity$, and `NaN` without runtime panics.
20. *Compound assignment operators:* Implement shorthand assignments `+=`, `-=`, `*=`, `/=`.
21. *Unicode mathematical symbols:* Support the Unicode character `π` as an alias for `pi`.
22. *Implicit multiplication:* Parse algebraic juxtaposition such as `2 pi r` as `2 * pi * r`.
23. *Direct exponent shorthand:* Parse expressions like `pi r 2` or `pi r ^ 2`.
24. *End-to-End Validation:* Verify that complex algebraic formulas such as $4 / 3 pi r^3$ evaluate with exact double-precision accuracy.

=== Problem Set 3: Pascal-to-Stack-Bytecode Compiler (Complete 42 Milestones)

#bnotice(caption: "Graded Semester Project Roadmap")[
  Source: `happy_pascal.pdf`, Section 2 (Pages 2–3). The project consists of engineering a complete compiler from a Pascal-like language down to the 17-instruction stack virtual machine (`mach.py`) through 42 incremental milestones:
]

==== Part 1: Base Language Infrastructure (Milestones 1–21)
1. *Constant integer expressions:* Lower scalar literal expressions into `PUSH <val>`.
2. *Expression display:* Implement output statement `print expr;` emitting the bytecode instruction `OUT`.
3. *Sequential instruction streams:* Formulate a program as a list of sequential statements.
4. *Additive arithmetic:* Implement `+` and `-` with left-associative parser declarations (`%left '+' '-'`).
5. *Parenthesized expressions:* Enable subterm grouping with `(` and `)`.
6. *Multiplicative arithmetic:* Implement `*` and `/` with precedence over addition.
7. *Source comments:* Discard single-line comments (`;/ ...`) and delimited multi-line blocks (`{ ... }`).
8. *Scalar variable declarations:* Parse declarations `var x : integer;` and emit memory reservations `x DS 1`.
9. *Scalar variable assignments:* Compile `x := expr;` by pushing address `x`, evaluating `expr`, and emitting `STORE`.
10. *Variable retrieval:* Reading `x` in an expression compiles to `PUSH x \n LOAD`.
11. *Interactive standard input:* Compile statement `read(x);` into `PUSH x \n IN \n STORE`.
12. *Conditional branch (`if-then-else`):* Compile condition test and emit jump instructions `BEZ` and `GOTO` with unique label generation.
13. *Modulo and unary minus:* Lower unary `-` and modulo operator `mod` into virtual arithmetic sequences.
14. *While loops & Euclidean GCD:* Compile `while cond do S` and validate by compiling and running the Euclidean GCD algorithm.
15. *Fixed-size integer arrays & Sieve of Eratosthenes:*
    - Memory allocation `var primes : array[N] of integer;` $arrow.r$ `primes DS N`.
    - Computed indexing `primes[i] := 1;` compiles address arithmetic `PUSH primes \n <eval i> \n ADD`, followed by value evaluation and `STORE`.
    - Validate by running the Sieve of Eratosthenes prime generation algorithm.
16. *Grouped variable declarations:* Support comma-separated declarations (e.g. `var a, b, c : integer;`).
17. *Inline variable initialization:* Support initial assignments at declaration time (e.g. `var x : integer := 42;`).
18. *Boolean constants:* Recognize keywords `true` ($1$) and `false` ($0$).
19. *Relational comparisons:* Lower `<`, `<=`, `>`, `>=`, `=`, `<>` using `SUB`, `BEZ`, and `BGZ`.
20. *Boolean logical operators:* Implement `and`, `or`, `not` ensuring boolean normalization (strictly $0$ or $1$) despite bitwise virtual instructions.
21. *Program exit syscall:* Implement `exit(code)` leaving the return status integer at stack top before `STOP`.

==== Part 2: Functions, Procedures & Activation Records (Milestones 22–28)
22. *Simple subroutines:* Subroutines without return values and without arguments.
23. *Valued functions:* Functions returning a scalar integer result.
24. *Call-by-value parameters:* Passing scalar arguments evaluated caller-side.
25. *Global scope default:* Subroutine variables bind globally by default.
26. *Local scope default:* Function variables allocated locally inside the active call frame.
27. *Explicit global declarations:* Support `global x;` declarations inside local function scopes.
28. *Recursive functions & activation frame preservation:*
    - Preserve return addresses and local slots across recursive calls on the runtime stack.
    - Implement and validate recursive Factorial (`fact(n)`).
    - Implement and validate naive recursive Fibonacci (`fib(n)`) and optimized linear Fibonacci.

==== Part 3: Advanced Optimizations & Type System Extensions (Milestones 29–42)
29. *Multi-way branch (`case ... of`):* Compile switch statements into jump tables or cascading comparison ladders.
30. *Intermediate branching (`elif`):* Support cascading `elif` branches without deeply nested indentation.
31. *Symbolic constants:* Implement compile-time constants (`const MAX = 100;`) via symbol table expansion.
32. *Integer pointer type:* Support address-of (`@x`) and dereference (`p^`) operators.
33. *Pass-by-reference parameters:* Pass L-value addresses allowing callee functions to mutate caller variables.
34. *Array pass-by-reference:* Pass array base pointers to subroutines without copying buffer memory.
35. *Postfix factorial operator:* Add unary factorial operator `n!`.
36. *Strict boolean type system:* Introduce `boolean` type, enforce strict $0/1$ invariants, and reject integer-boolean mixing at compile time.
37. *Redundant subexpression optimization:* Detect repeated subexpressions and cache results into compiler-generated temporaries.
38. *Short-circuit logical evaluation:* Ensure `A and B` does not evaluate `B` when `A` is false, and `A or B` does not evaluate `B` when `A` is true.
39. *Array literal initializations:* Support declarative array initialization `var a : array[3] of integer := [10, 20, 30];`.
40. *Dynamic heap memory allocation:* Implement dynamic heap allocation for dynamically sized arrays in the data area.
41. *Constant folding optimization:* Compile-time static evaluation of constant arithmetic AST subtrees.
42. *Runtime array bounds checking:* Emit assertions verifying $0 <= "index" < "size"$ before any array load/store, halting with `STOP` on out-of-bounds violations.

