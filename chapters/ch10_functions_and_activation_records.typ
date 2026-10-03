#import "common.typ": bdefinition, btheorem, blemma, bproposition, bexample, bnotice, bexercise

== Functions, Activation Records & Runtime Memory Management

A complete programming language requires supporting procedural and functional abstraction: procedures, parameter passing, return values, local variables, and recursive invocation.

=== Function Calls and the Activation Record (Call Frame)

When a function $f$ is invoked, a dedicated memory structure called an *Activation Record* (or *Stack Frame*) is allocated to track its execution state.

An activation record typically contains:
1. *Actual Parameters:* Arguments passed from the caller.
2. *Return Address:* The program location (`pc`) to resume execution after returning.
3. *Dynamic Link:* Pointer to the caller's frame (enabling stack unwinding).
4. *Local Variables:* Memory allocated for variables local to the active function invocation.
5. *Temporary Workspace:* Intermediate stack values during subexpression evaluation.

=== Parameter Passing Semantics

1. *Pass-by-Value (Call-by-Value):*
   The caller evaluates each argument expression to a value and copies that value into the function's local parameter slots. Mutations within the function do not alter caller memory.
2. *Pass-by-Reference:*
   The caller passes the memory *address* (L-value) of the variable. Any assignment inside the function directly modifies the caller's variable.
3. *Pass-by-Need (Call-by-Need / Laziness):*
   As implemented in Haskell, the caller passes an unevaluated thunk pointer. The function forces the value only when scrutinized, caching the evaluated result.

=== Compiling Recursive Functions on the Stack Machine

Consider compiling the canonical recursive factorial function:
```pascal
function fact(n: integer): integer;
begin
  if n <= 1 then
    fact := 1
  else
    fact := n * fact(n - 1)
end;
```

To compile recursion onto our 17-instruction stack machine, function calls must preserve the return address and local state across recursive invocations.

*Calling Convention:*
1. *Caller Action:* Pushes the return address label onto the stack, pushes function arguments, and jumps to the function entry point:
   ```assembly
   PUSH ret_label
   PUSH 5          ;/ Argument n
   PUSH fact_entry
   GOTO
   ret_label EQU *
   ```
2. *Callee Action (Prolog):* Retrieves arguments into local frame slots or operates directly on the stack.
3. *Callee Action (Epilog):* Places the return value on the stack, fetches the saved return address, and jumps back:
   ```assembly
   ;/ Return value is at stack top; swap with return address
   SWAP
   GOTO
   ```

=== Tail Call Optimization (TCO)

#bdefinition(caption: "Tail Call Optimization")[
A function call is in *tail position* if it is the absolute final action performed before the function returns.
Tail Call Optimization replaces the standard call sequence (allocating a new stack frame) with an in-place jump (`GOTO`), reusing the existing frame and converting recursion into an $cal(O)(1)$ space iterative loop.
]

#bexample(caption: "Accumulator-Passing Tail Recursion")[
Contrast naive factorial with tail-recursive factorial:
```haskell
-- Naive recursion (O(n) stack frames):
factNaive 0 = 1
factNaive n = n * factNaive (n - 1)

-- Tail-recursive accumulator (O(1) stack space with TCO):
factTail :: Integer -> Integer
factTail n = go n 1
  where
    go 0 !acc = acc
    go k !acc = go (k - 1) (k * acc)
```
In GHC and production compilers, tail calls are compiled directly into assembly jump instructions (`jmp`), matching the performance of hand-optimized imperative loops.
]

=== Chapter Exercises

#bexercise(caption: "Recursive Function Activation & Factorial Emission", ref-source: "happy_pascal.pdf, Milestone 28 & intro_haskell.pdf, Slide 5")[
  *Problem:* Outline the stack machine calling convention for the recursive function:
  ```pascal
  function fact(n: integer): integer;
  begin
    if n <= 1 then fact := 1 else fact := n * fact(n - 1)
  end;
  ```
  Provide the symbolic assembly implementation with return address preservation and frame teardown.
]

#bexercise(caption: "Fibonacci: Naive Tree Recursion vs. Linear Accumulator", ref-source: "happy_pascal.pdf, Milestone 28")[
  *Problem:*
  1. Write the naive recursive Fibonacci function $F(n) = F(n-1) + F(n-2)$ and analyze its stack frame growth.
  2. Implement an optimized linear tail-recursive accumulator version in Haskell and explain why it compiles to $cal(O)(1)$ stack memory.
]

