#import "common.typ": bdefinition, btheorem, blemma, bproposition, bexample, bnotice, bexercise

== Stack Machine Architecture: The 17-Instruction Virtual Machine

In many real-world language runtimes—including the Java Virtual Machine (JVM), the Python bytecode interpreter, and the WebAssembly abstract machine—programs are executed by an abstract *stack machine* rather than a register machine.

=== Architectural Layout: Code, Data, and Stack Memories

The virtual machine specified in the course (`mach.py`) consists of three disjoint memory areas and two control pointers:

1. `program[]`: Linear array storing executable bytecode instructions and immediate numeric operands.
2. `data[]`: Random-access array storing global variables and structured arrays indexed by integer addresses.
3. `stack[]`: LIFO (Last-In-First-Out) operand stack for arithmetic, logical evaluations, and temporary results.
4. `pc` (Program Counter): Integer register pointing to the index of the next instruction in `program[]` to be executed.
5. `sp` (Stack Pointer): Points to the next free cell in `stack[]`.

#figure(
  table(
    columns: (1.5fr, 1.2fr, 3fr),
    align: (left, left, left),
    table.header([*Category*], [*Mnemonic*], [*Formal Operational Semantics*]),
    [*Data Movement*], [`PUSH x`], [`pc++; stack[sp++] = program[pc++]`],
    [], [`LOAD`], [`pc++; stack[sp-1] = data[stack[sp-1]]`],
    [], [`STORE`], [`pc++; data[stack[sp-2]] = stack[sp-1]; sp -= 2`],
    [], [`SWAP`], [`pc++; tmp = stack[sp-1]; stack[sp-1] = stack[sp-2]; stack[sp-2] = tmp`],
    [*Arithmetic & Logic*], [`ADD`], [`pc++; stack[sp-2] = stack[sp-2] + stack[sp-1]; sp--`],
    [], [`SUB`], [`pc++; stack[sp-2] = stack[sp-2] - stack[sp-1]; sp--`],
    [], [`MUL`], [`pc++; stack[sp-2] = stack[sp-2] * stack[sp-1]; sp--`],
    [], [`DIV`], [`pc++; stack[sp-2] = stack[sp-2] / stack[sp-1]; sp--`],
    [], [`AND`], [`pc++; stack[sp-2] = stack[sp-2] & stack[sp-1]; sp-- (bit-wise)`],
    [], [`OR`], [`pc++; stack[sp-2] = stack[sp-2] | stack[sp-1]; sp-- (bit-wise)`],
    [], [`NOT`], [`pc++; stack[sp-1] = ~stack[sp-1]; (bit-wise complement)`],
    [*Control Flow*], [`BEZ x`], [`pc++; pc = (stack[--sp] == 0) ? program[pc] : pc + 1`],
    [], [`BGZ x`], [`pc++; pc = (stack[--sp] > 0) ? program[pc] : pc + 1`],
    [], [`GOTO`], [`pc = stack[--sp]`],
    [], [`STOP`], [`pc++; exit(0)`],
    [*Interactive I/O*], [`IN`], [`pc++; stack[sp++] = read_integer()`],
    [], [`OUT`], [`pc++; print(stack[--sp])`],
  ),
  caption: [Formal Specification of the 17 Minimal Machine Instructions]
)

=== The Symbolic Assembler (`asm`)

Hand-writing numeric byte offsets for `pc` jumps is notoriously brittle. The companion assembler `asm` provides symbolic assembly with label resolution and data reservation:

1. *Symbolic Jump Targets (`EQU *`):*
   ```assembly
   loop_start EQU *
   ```
   Defines the symbol `loop_start` as the current program address.
2. *Data Allocation (`DS <size>`):*
   ```assembly
   x  DS 1       ;/ Allocates 1 integer word for variable x
   arr DS 100    ;/ Allocates contiguous array of 100 words
   ```
3. *Direct Memory Jumps:*
   ```assembly
   PUSH loop_start
   GOTO
   ```
4. *Conditional Branching:*
   ```assembly
   PUSH x
   LOAD
   BEZ exit_label
   ```
   If the value of `x` is zero, execution jumps directly to `exit_label`. Otherwise, control continues to the subsequent instruction.

=== Chapter Exercises

#bexercise(caption: "Relational Comparison on the 17-Instruction Machine", ref-source: "defmachine.pdf, Slide 9")[
  *Problem:* The virtual machine does not possess a primitive comparison instruction (such as `<` or `CMP`). It provides only `BEZ` (branch if zero) and `BGZ` (branch if strictly positive).
  Given two values $A$ and $B$ at the top of the stack (with $B$ above $A$), write a minimal symbolic assembly sequence computing the boolean test $A < B$, leaving $1$ on the stack if true and $0$ if false.
]

#bexercise(caption: "Manual Assembly Compilation: Euclidean GCD", ref-source: "happy_pascal.pdf, Milestone 14 & defmachine.pdf")[
  *Problem:* Write the complete symbolic assembly program calculating the Greatest Common Divisor ($gcd$) of two integers read from standard input, using the Euclidean algorithm, and printing the result to `OUT`.
]

