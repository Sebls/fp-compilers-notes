#import "common.typ": bdefinition, btheorem, blemma, bproposition, bexample, bnotice, bexercise

== Code Generation: Compiling High-Level Languages to Stack Bytecode

With the front-end (scanning, parsing, AST construction) and target virtual machine established, we examine the backend: *code generation*. We detail how high-level structured constructs (arithmetic expressions, variable assignments, loops, conditionals, and array addressing) are translated systematically into sequence of stack machine operations.

=== Compiling Expressions: Infix to Postfix Stack Transformation

An arithmetic expression represented as an AST is compiled into stack code by performing a *post-order traversal* (compiling left subtree, right subtree, then emitting the binary opcode):

#btheorem(caption: "Stack Expression Invariant")[
Let $e$ be a well-typed scalar expression yielding value $v$. The compiled code sequence $cal(C)(e)$ satisfies the property:
$ chevron.l "Code", "Data", "Stack" chevron.r attach(arrow.r, t: cal(C)(e))^* chevron.l "Code"', "Data", "Stack" : v chevron.r $
Executing $cal(C)(e)$ pushes exactly one value ($v$) onto the operand stack without disturbing existing stack items or altering data memory.
]

#bexample(caption: "Compilation of $2 + 3 times 4$")[
The AST `Add (Lit 2) (Mul (Lit 3) (Lit 4))` is compiled into:
```assembly
PUSH 2
PUSH 3
PUSH 4
MUL
ADD
```
*Stepwise execution trace on operand stack:*
1. `PUSH 2`: `stack = [2]`
2. `PUSH 3`: `stack = [2, 3]`
3. `PUSH 4`: `stack = [2, 3, 4]`
4. `MUL`: Pops $4$ and $3$, pushes $3 times 4 = 12$. `stack = [2, 12]`
5. `ADD`: Pops $12$ and $2$, pushes $2 + 12 = 14$. `stack = [14]`
]

=== L-Values vs. R-Values in Variable Compilation

To compile variables, the compiler distinguishes between two semantic contexts:
- *R-Value (Right-hand value):* The value stored inside the variable.
  Compiled by pushing the variable address followed by `LOAD`:
  $ cal(C)_R(x) = "PUSH" space x \ "LOAD" $
- *L-Value (Left-hand address):* The memory location where a value will be written.
  Compiled by pushing only the variable address:
  $ cal(C)_L(x) = "PUSH" space x $

An assignment statement `x := e` is compiled as:
```assembly
;/ Push destination address (L-value)
PUSH x
;/ Evaluate right-hand expression (R-value)
<code for e>
;/ Store value at address
STORE
```
Under `STORE`, the machine writes the value at `stack[sp-1]` into `data[stack[sp-2]]` and pops both items (`sp -= 2`).

=== Control Flow Compilation: If-Then-Else and While Loops

Because the stack machine provides only conditional branches (`BEZ`, `BGZ`) and unconditional jumps (`GOTO`), high-level structured control statements are lowered using unique compiler-generated label pairs.

==== Compiling `if (cond) then S1 else S2`
```assembly
    <code for cond>
    BEZ else_lbl
    <code for S1>
    PUSH end_lbl
    GOTO
else_lbl EQU *
    <code for S2>
end_lbl  EQU *
```

==== Compiling `while (cond) do S`
```assembly
loop_start EQU *
    <code for cond>
    BEZ loop_end
    <code for S>
    PUSH loop_start
    GOTO
loop_end   EQU *
```

=== Array Indexing and Base-Offset Address Calculation

For an array `A` declared with size $N$ (`A DS N`), the memory address of element `A[i]` is computed dynamically at run time:
$ "Address of" space A[i] = "base"(A) + i $

To evaluate an assignment `A[i] := e`:
```assembly
;/ Compute destination L-value: address of A[i]
PUSH A
<code for i>
ADD
;/ Evaluate R-value expression
<code for e>
STORE
```
This elegant uniformity allows nested array accesses, multi-dimensional buffer lookups, and pointer dereferencing using identical stack primitives.

=== Chapter Exercises

#bexercise(caption: "Recursive AST to Stack Bytecode Emission", ref-source: "happy_pascal.pdf, Milestones 1–6")[
  *Problem:* Consider an arithmetic expression AST type:
  ```haskell
  data Op = Add | Sub | Mul | Div
  data Expr = Lit Int | Var String | BinOp Op Expr Expr
  ```
  Write a pure code generation function `compileExpr :: Expr -> [String]` that emits assembly instructions maintaining the stack invariant (leaving exactly one result at the top of the operand stack).
]

#bexercise(caption: "Array Indexing L-Value & R-Value Emission", ref-source: "happy_pascal.pdf, Milestone 15 & defmachine.pdf")[
  *Problem:*
  1. Specify the stack assembly sequence to read the value of `primes[i + 1]`.
  2. Specify the stack assembly sequence to execute the assignment `primes[i + 1] := 42;`.
]

