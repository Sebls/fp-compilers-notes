#import "common.typ": bdefinition, btheorem, blemma, bproposition, bexample, bnotice

== Practical Problem Sets, Laboratory Exercises & Solutions

This appendix collects the complete laboratory exercises, milestones, and development problem sets from the course curriculum (including the parenthesized expressions parser, the scientific calculator, and the 42-stage Pascal-to-bytecode compiler), accompanied by complete formal specifications and solutions.

=== Problem Set 1: Lexing and Parsing Well-Parenthesized Expressions

*Context:* A language of well-parenthesized expressions over characters `(` and `)`.
Examples of valid strings: `""`, `"()"`, `"()()(())"`, `"(()())"`.

==== Exercise 1.1: Maximum Parenthesis Depth
*Objective:* Write a Happy grammar that directly computes the maximum nesting depth as an integer.

*Solution:*
```haskell
Expression : {- empty -}                               { 0 }
           | '(' Expression ')' Expression             { max (1 + $2) $4 }
```
*Verification:*
- For `""`: matches empty rule $arrow.r 0$.
- For `"()"`: $1 + 0 = 1$, followed by $0 arrow.r max(1, 0) = 1$.
- For `"(())"`: inner is $1$, outer is $1 + 1 = 2$. Correct.

==== Exercise 1.2: Generalized Parse Tree Generation
*Objective:* Modify the grammar to produce an explicit multi-way tree (generalized rose tree) representing the nested syntactic hierarchy.

*Solution:*
```haskell
data Parens = Node [Parens] deriving (Eq, Show)
```
Grammar rules:
```haskell
Expr : {- empty -}             { [] }
     | '(' Expr ')' Expr       { Node $2 : $4 }
```

=== Problem Set 2: The Extended Scientific Calculator (24 Milestones)

The laboratory assignment tasks students with implementing an extensible interactive calculator in Haskell using Alex and Happy across 24 incremental milestones:

1. *Double precision floats:* Support numeric inputs such as `31.4156E-1`.
2. *Binary arithmetic:* Left-associative `+`, `-`, `*`, `/`.
3. *Unary negation:* High-precedence prefix `-`.
4. *Transcendental functions:* `sin`, `cos`, `tan`, `sqrt`, `exp`, `log`.
5. *Power operator:* Right-associative exponentiation `^`.
6. *Mathematical constants:* Pre-bound values `pi` ($pi approx 3.141592653589793$) and `e` ($e approx 2.718281828459045$).
7. *Stateful variables & assignments:* `a = 2`, `b = a + 1`.
8. *Boolean logic & comparison:* Relational operators `<`, `<=`, `>`, `>=`, `==`, `!=` and logical `and`, `or`, `not` represented numerically ($1.0$ for true, $0.0$ for false).
9. *Error resilience:* Graceful handling of division by zero and unbound variables without crashing the REPL loop.
10. *Multi-statement lines & comments:* Separating expressions with `;` and stripping comments `//` and `/* ... */`.
11. *Implicit multiplication:* Parsing algebraic syntax like `2*pi*r` as well as implicit `2 pi r`.

=== Problem Set 3: Pascal-to-Stack-Bytecode Compiler (42 Milestones)

The semester compilation project requires engineering an end-to-end compiler translating a Pascal-like imperative programming language into 17-instruction stack machine assembly. Below is the structured milestone roadmap with compilation strategies:

==== Stage I: Scalar Expressions and I/O (Milestones 1–7)
- *M1–M3: Integer literals and Display:*
  `print 42;` $arrow.r$ `PUSH 42 \n OUT`.
- *M4–M6: Arithmetic Precedence:*
  Lowering `+`, `-`, `*`, `/` using standard post-order traversal with operator precedence (`%left '+' '-'`, `%left '*' '/'`).
- *M7: Comments:*
  Alex regular expressions discarding line comments `;/.*` and block comments `\{[^\}]*\}`.

==== Stage II: Variables and Sequential Statements (Milestones 8–11)
- *M8: Variable Declaration:*
  `var x : integer;` emits `x DS 1` into the data segment.
- *M9–M10: Assignment and Variable References:*
  `x := e;` emits `PUSH x`, evaluates `e`, then emits `STORE`.
  Referencing `x` in an expression emits `PUSH x \n LOAD`.
- *M11: Interactive Input:*
  `read(x);` emits `PUSH x \n IN \n STORE`.

==== Stage III: Structured Control Flow (Milestones 12–15)
- *M12: Conditional Branching (`if-then-else`):*
  Generate unique labels using a state monad `counter`:
  Evaluate condition; emit `BEZ else_lbl`; compile `then` branch; emit `PUSH end_lbl \n GOTO`; emit `else_lbl EQU *`; compile `else` branch; emit `end_lbl EQU *`.
- *M14: While Loops (Euclidean GCD Algorithm):*
  ```pascal
  while y <> 0 do
  begin
    r := x mod y;
    x := y;
    y := r;
  end;
  ```
  Lowering emits label `loop_start EQU *`, conditional test with `BEZ loop_end`, loop body, and unconditional backward jump `PUSH loop_start \n GOTO`.
- *M15: Fixed-Size Arrays (Sieve of Eratosthenes):*
  `var primes : array[100] of integer;` emits `primes DS 100`.
  Array write `primes[i] := 1;` compiles address computation `PUSH primes \n <eval i> \n ADD`, followed by `<eval 1> \n STORE`.

==== Stage IV: Functions and Procedures (Milestones 22–28)
- *M22–M24: Parameter Passing by Value:*
  Push arguments in left-to-right order; callee accesses arguments at negative stack offsets relative to frame pointer.
- *M26–M28: Recursive Activation Records (Factorial & Fibonacci):*
  Callee saves return address and frame pointer, allocates local variables, and restores caller state on exit via `SWAP \n GOTO`.

==== Stage V: Advanced Optimizations (Milestones 29–42)
- *M38: Short-circuit boolean evaluation:*
  Transform `A and B` into conditional jumps where `B` is not evaluated if `A` is false.
- *M41: Partial evaluation / Constant folding:*
  AST transformation collapsing constant subterms `Lit a + Lit b` $arrow.r$ `Lit (a + b)`.
- *M42: Array bounds checking:*
  Inject assertion bytecode before array accesses verifying $0 <= "index" < "bound"$, aborting with `STOP` on violation.
