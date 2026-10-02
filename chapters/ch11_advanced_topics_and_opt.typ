#import "common.typ": bdefinition, btheorem, blemma, bproposition, bexample, bnotice

== Advanced Topics: Type Checking, Optimizations & Native Code Generation

Beyond basic stack bytecode generation, modern compilers perform advanced static analysis, structural type checking, and optimization passes to generate high-performance native machine code.

=== Static Typing: The Hindley-Milner Type System & Algorithm W

Haskell and ML infer principal types without requiring explicit type annotations through the *Damas-Hindley-Milner (HM)* type inference system.

#btheorem(caption: "Principal Type Theorem")[
For every typable term $e$ in the core ML/$lambda$-calculus, there exists a unique *principal type scheme* $sigma = forall alpha_1 dots alpha_n . tau$ such that every valid type for $e$ is an instance of $sigma$.
]

Algorithm W executes type inference via three operations:
1. *Type Variable Generation:* Fresh variables $alpha, beta, dots$ are assigned to unbound lambda abstractions and intermediate expressions.
2. *Constraint Generation:* Equations between types are accumulated from AST application and pattern-matching nodes.
3. *Robinson First-Order Unification:* Resolves systems of type equations $tau_1 tilde.equiv tau_2$ by computing the Most General Unifier ($"mgu"$) or reporting a compile-time type mismatch error.

=== Compiler Optimization Passes

Before emitting machine instructions, an optimizing compiler traverses intermediate code through several optimization passes:

1. *Constant Folding & Propagation:*
   Replaces static arithmetic subexpressions with their evaluated literals at compile time:
   $ (3 times 4) + x quad attach(arrow.r, t: "fold") quad 12 + x $
2. *Common Subexpression Elimination (CSE):*
   Detects redundant evaluations of identical expressions within a basic block and replaces subsequent occurrences with references to the first result.
3. *Short-Circuit Boolean Evaluation:*
   Lowers logical operators `and` and `or` into conditional branches:
   In `A and B`, if `A` evaluates to false ($0$), `B` is skipped entirely.
4. *Dead Code Elimination (DCE):*
   Prunes unreachable instructions, unreferenced basic blocks, and assignments to dead variables that never influence observable outputs.

=== Lowering to Native Target Code: The x86-64 NASM Backend

The final stage of the course compiler pipeline translates abstract stack machine programs into real 64-bit Intel/AMD assembly via `to_nasm.py`.

In x86-64:
- The virtual stack pointer `sp` is mapped to the CPU hardware stack pointer register `rsp`.
- General-purpose 64-bit registers `rax`, `rbx`, `rcx`, `rdx` execute arithmetic instructions.
- System calls (`sys_write`, `sys_exit`) interact directly with the operating system kernel.

#bexample(caption: "Translating Virtual Stack Instructions to x86-64 NASM Assembly")[
Consider how virtual machine instructions map to concrete x86-64 NASM mnemonics:

```assembly
; Virtual: PUSH 42
push qword 42

; Virtual: ADD
pop  rbx          ; Pop right operand into rbx
pop  rax          ; Pop left operand into rax
add  rax, rbx     ; rax = rax + rbx
push rax          ; Push computed sum back to stack

; Virtual: LOAD
pop  rax          ; Pop memory address into rax
mov  rbx, [data + rax*8] ; Read 64-bit word from data segment
push rbx

; Virtual: STORE
pop  rbx          ; Pop value to store
pop  rax          ; Pop target memory address
mov  [data + rax*8], rbx ; Store into memory array

; Virtual: STOP
mov  rax, 60      ; sys_exit syscall number on Linux x86-64
xor  rdi, rdi     ; Exit status 0
syscall
```
]
This mapping bridges high-level functional theory with physical silicon execution, completing the end-to-end journey from $lambda$-calculus to register hardware.
