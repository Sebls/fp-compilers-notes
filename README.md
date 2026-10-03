# Principles of Functional Programming & Compiler Construction

## Curriculum Overview

The monograph is organized into three major parts and an appendix of laboratory problem sets:

### Part I: Foundations of Functional Programming
* **Chapter 1: Paradigms of Computation & Lambda Calculus**
  - Imperative vs. declarative computation, Euclidean GCD case study.
  - Prefix application, partial application, currying, mathematical purity, and referential transparency.
  - Robin Milner's dictum: *"Well-typed programs cannot go wrong"*.
* **Chapter 2: Algebraic Data Types & Recursive Data Modeling**
  - Sum types, product types, and constructor mechanics.
  - Exhaustive pattern matching and structural decomposition.
  - Parametric polymorphism and ad-hoc polymorphism via Haskell typeclasses.
  - Elimination of null pointers via the `Maybe` type.
* **Chapter 3: Evaluation Strategies & The Mechanics of Laziness**
  - Strict (call-by-value) vs. non-strict (call-by-need) evaluation models.
  - Thunks, graph reduction, and infinite streams.
  - Space leaks in lazy accumulators and strictness remediation (`seq`, `$!`, `BangPatterns`).
* **Chapter 4: Category Theoretic Abstractions: Functors, Applicatives & Monads**
  - `Functor` (`fmap`) and `Applicative` (`<*>`).
  - `Monad` sequencing (`>>=`, `return`) and algebraic monad laws.
  - The `Maybe` and `List` monads.
  - Desugaring `do`-notation and modeling impure effects safely via the `IO` monad.

### Part II: Front-End Architecture & Syntax Analysis
* **Chapter 5: Compiler Architecture: From Source Strings to Target Executables**
  - Classical multi-pass compiler pipeline (scanning, parsing, AST, semantic analysis, IR, code generation).
  - Formal grammars, Chomsky hierarchy, and language decidability.
  - Shift-reduce parsing mechanics, LR(1), and LALR(1) parsing tables.
* **Chapter 6: Lexical & Syntactic Analysis: Alex & Happy in Practice**
  - Declarative lexical specification files (`.x`) with Alex: basic vs. posn wrappers.
  - Declarative LALR(1) parser specifications (`.y`) with Happy: `%tokentype`, `%token`, `%left`, `%right`.
  - Precise source position reporting via `AlexPn`.
  - Modern alternatives: monadic parser combinators (Parsec / Megaparsec).
* **Chapter 7: Abstract Syntax Trees & Expression Evaluation: The Calculator System**
  - Recursive AST algebraic data structures (`AExpr`, `BinOp`, `UnOp`).
  - Evaluation environments and variable symbol lookup tables.
  - Total evaluation with the `Either String Double` error monad.
  - Interactive REPL (Read-Eval-Print Loop) architecture.

### Part III: Back-End Construction & Code Generation
* **Chapter 8: Stack Machine Architecture: The 17-Instruction Virtual Machine**
  - Architectural layout: `program[]`, `data[]`, `stack[]` with `pc` and `sp` registers.
  - Formal operational semantics for the 17 elemental stack instructions:
    `PUSH`, `LOAD`, `STORE`, `SWAP`, `ADD`, `SUB`, `MUL`, `DIV`, `AND`, `OR`, `NOT`, `BEZ`, `BGZ`, `STOP`, `GOTO`, `IN`, `OUT`.
  - The companion two-pass symbolic assembler (`asm.py`) with `EQU *` labels and `DS` data allocation.
* **Chapter 9: Code Generation: Compiling High-Level Languages to Stack Bytecode**
  - Postfix stack lowering invariant and post-order AST traversal.
  - L-Values (destination addresses) vs. R-Values (loaded data).
  - Lowering structured control flow: conditional branching (`if-then-else`) and loops (`while`).
  - Base-offset memory addressing for fixed-size arrays.
* **Chapter 10: Functions, Activation Records & Runtime Memory Management**
  - Activation record (call frame) anatomy: parameters, return addresses, dynamic links, locals.
  - Parameter passing conventions: pass-by-value, pass-by-reference, and call-by-need.
  - Compiling recursive procedures (Factorial, Fibonacci) on the stack machine.
  - Tail Call Optimization (TCO) and accumulator transformation.
* **Chapter 11: Advanced Topics: Type Checking, Optimizations & Native Code Generation**
  - Damas-Hindley-Milner (HM) type inference and Algorithm W unification.
  - Optimization passes: constant folding, common subexpression elimination (CSE), short-circuit boolean evaluation, and dead-code elimination.
  - Lowering abstract stack machine instructions to native x86-64 NASM assembly (`to_nasm.py`).

### Appendix: Laboratory Exercises & Project Milestones
* **Chapter 12: Practical Problem Sets, Laboratory Exercises & Solutions**
  - **Problem Set 1:** Grammar engineering for well-parenthesized expressions (depth calculation and generalized rose trees).
  - **Problem Set 2:** Full specification of the 24 milestones for the scientific calculator.
  - **Problem Set 3:** Milestone compilation roadmap for the 42-stage Pascal compiler project.

---

## Building the Monograph

The notes are written in [Typst](https://typst.app/) using the `latexy-book` package.

### Prerequisites
* Install Typst CLI ($v0.11+$):
  ```bash
  # macOS (Homebrew)
  brew install typst
  ```

### Compilation
To compile the publication-ready PDF:
```bash
typst compile main.typ main.pdf
```

To watch for changes during editing:
```bash
typst watch main.typ main.pdf
```
