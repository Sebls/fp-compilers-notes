#import "@preview/latexy-book:0.0.1": (
  appendix, backmatter, book, code, corollary, definition, example, exercise, frontmatter, lemma, mainmatter, notice,
  proposition, theorem,
)

// Document metadata and latexy-book initial setup
#show: book.with(
  title: "Complete\nExercise Manual",
  subtitle: "Functional Programming Foundations\n& Compiler Construction Laboratories",
  author: "",
  date: datetime.today().display("[month repr:long] [day], [year]"),
  titlepage: true,
)

// =============================================================================
// TYPOGRAPHY & VISUAL AESTHETICS (Exact Monograph LaTeX Style matching main notes)
// =============================================================================

#set page(
  paper: "us-letter",
  margin: (top: 1in, bottom: 1in, inside: 1.25in, outside: 1in),
  header: context {
    let page-num = counter(page).get().first()
    if page-num > 2 [
      #set text(font: "New Computer Modern", size: 8.5pt)
      #grid(
        columns: (1fr, auto),
        text(style: "italic")[Exercise Manual: Functional Programming & Compiler Construction], str(page-num),
      )
      #v(-0.4em)
      #line(length: 100%, stroke: 0.4pt + luma(130))
    ]
  },
  footer: none,
)

#set text(
  font: "New Computer Modern",
  size: 10pt,
  lang: "en",
)
#set par(
  justify: true,
  leading: 0.58em,
  first-line-indent: 1.5em,
)
#show raw: set text(font: ("DejaVu Sans Mono", "Courier New"), size: 8.2pt)
#show math.equation: set text(font: "New Computer Modern Math")

#show raw.where(block: false): it => box(
  fill: rgb("#f3f4f6"),
  inset: (x: 3.5pt, y: 0pt),
  outset: (y: 3pt),
  radius: 2.5pt,
  baseline: 0%,
  text(fill: rgb("#1f2937"), style: "normal", weight: "regular", it)
)

#show raw.where(block: true): it => {
  let lang = if it.has("lang") and it.lang != none and it.lang != "" {
    upper(it.lang)
  } else {
    none
  }

  block(
    width: 100%,
    breakable: true,
    above: 1.4em,
    below: 1.4em,
    stroke: (left: 2.5pt + rgb("#3b82f6"), rest: 0.5pt + rgb("#e5e7eb")),
    fill: rgb("#f8fafc"),
    radius: (right: 4pt),
    inset: (x: 12pt, top: 10pt, bottom: 10pt),
    [
      #set text(style: "normal")
      #set par(justify: false, first-line-indent: 0pt, leading: 0.6em)
      #if lang != none [
        #place(
          top + right,
          dx: 6pt,
          dy: -4pt,
          box(
            fill: rgb("#e2e8f0"),
            inset: (x: 5pt, y: 2.5pt),
            radius: 3pt,
            text(size: 6.5pt, weight: "bold", fill: rgb("#475569"), lang)
          )
        )
      ]
      #it
    ]
  )
}

#show heading.where(level: 1): it => block(above: 2.5em, below: 1.6em)[
  #text(weight: "bold", size: 1.7em)[#it.body]
]
#show heading.where(level: 2): it => block(above: 2.0em, below: 1.2em)[
  #text(weight: "bold", size: 1.3em)[#it.body]
]
#show heading.where(level: 3): it => block(above: 1.5em, below: 0.9em)[
  #text(weight: "bold", size: 1.08em)[#it.body]
]

// Custom environments for the exercises manual
#let ex-counter = counter("ex-manual-counter")

#let bexitem(caption: "", ref-source: "", problem: []) = block(
  above: 1.6em,
  below: 1.6em,
  breakable: true,
  stroke: (left: 2.5pt + rgb("#6366f1")),
  inset: (left: 12pt, y: 4pt),
)[
  #ex-counter.step()
  #text(weight: "bold", fill: rgb("#4338ca"), size: 1.05em)[Exercise #context ex-counter.display()]#if caption != "" [ #text(weight: "bold")[(#caption).] ] else [ #text(weight: "bold")[.] ]
  #if ref-source != "" [
    #text(size: 8pt, fill: rgb("#6b7280"), style: "italic")[[Ref: #ref-source]] \
  ]

  #block(
    above: 0.8em,
    below: 0.8em,
    fill: rgb("#f8fafc"),
    inset: 8pt,
    radius: 3pt,
    stroke: 0.5pt + rgb("#e2e8f0")
  )[
    #text(weight: "bold", fill: rgb("#1e293b"))[Problem Statement:] \
    #problem
  ]
]

// ==========================================
// FRONT MATTER
// ==========================================
#frontmatter()

= Preface
This document serves as the comprehensive, self-contained *Exercise & Laboratory Problem Manual* to accompany the course monograph _Principles of Functional Programming & Compiler Construction_. It collects every theoretical exercise, derivation prompt, laboratory exercise, and incremental project milestone across:

1. All core functional programming foundations (Lambda calculus, ADTs, laziness, monads, and category theory).
2. Modern front-end compiler engineering (Alex lexers, Happy LALR(1) parsers, AST design, and evaluation environments).
3. Back-end compiler engineering and machine architectures (the 17-instruction virtual stack machine, code generation, and activation records).
4. The full 24-milestone Scientific Calculator and 42-milestone Pascal-to-Bytecode compiler specifications.

For the corresponding step-by-step solutions, formal proofs, and complete code listings, please consult the companion *Solutions Manual* (`solutions.pdf`).

#outline(indent: auto)

// ==========================================
// MAIN MATTER
// ==========================================
#mainmatter()

#set page(
  paper: "us-letter",
  margin: (top: 1in, bottom: 1in, inside: 1.25in, outside: 1in),
)

= Part I: Functional Programming Foundations

== Chapter 1: Paradigms of Computation & Lambda Calculus

#bexitem(
  caption: "Function Invocation Syntax",
  ref-source: "intro_haskell.pdf, Slide 5",
  problem: [
    How do you invoke the recursive factorial function `fact` with the integer argument `5` in Haskell? Explain the syntactic difference between Haskell's application convention and traditional imperative languages.
  ]
)

#bexitem(
  caption: "First-Principles Currying & Uncurrying",
  ref-source: "intro_haskell.pdf, Slide 9",
  problem: [
    Implement the foundational functions `curry` and `uncurry` from first principles without using standard library shortcuts:
    ```haskell
    curry   :: ((a, b) -> c) -> a -> b -> c
    uncurry :: (a -> b -> c) -> ((a, b) -> c)
    ```
    Demonstrate that they form an isomorphism by showing that $"curry" compose "uncurry" equiv "id"$ and $"uncurry" compose "curry" equiv "id"$.
  ]
)

== Chapter 2: Algebraic Data Types & Recursive Data Modeling

#bexitem(
  caption: "Polymorphic Constructor Inference",
  ref-source: "intro_haskell.pdf, Slide 8",
  problem: [
    Consider the polymorphic inductive data type:
    ```haskell
    data MyList a = Empty | Cons a (MyList a) deriving (Show)
    ```
    What is the deduced type of the nested expression `Cons Empty Empty` in GHCi? Explain how the Hindley-Milner type inference engine resolves this term.
  ]
)

#bexitem(
  caption: "Typeclass Analysis: `lookup`",
  ref-source: "intro_haskell.pdf, Slide 10",
  problem: [
    Analyze the full type signature of the association list lookup function:
    ```haskell
    lookup :: Eq a => a -> [(a, b)] -> Maybe b
    ```
    Explain:
    1. Why the typeclass constraint `Eq a` is mathematically required.
    2. Why the return type is `Maybe b` rather than simply `b` or throwing an exception.
  ]
)

#bexitem(
  caption: "Laboratory TP 0: Binary Trees and Traversals",
  ref-source: "intro_haskell.pdf, Slide 18 (TP 0)",
  problem: [
    1. Define a polymorphic binary tree data type `Tree a` with empty leaves and value-bearing internal nodes.
    2. Implement recursive functions computing:
       - The height of the tree (`height :: Tree a -> Int`).
       - The total number of nodes (`nbNodes :: Tree a -> Int`).
       - The number of leaves (`nbLeaves :: Tree a -> Int`).
    3. Implement the three canonical depth-first tree traversals returning `[a]`: in-order, pre-order, and post-order.
  ]
)

== Chapter 3: Evaluation Strategies & The Mechanics of Laziness

#bexitem(
  caption: "Infinite Sequence Generation via Laziness",
  ref-source: "intro_haskell.pdf, Slide 11",
  problem: [
    Implement the infinite sequence of natural numbers $[1, 2, 3, 4, dots]$:
    1. Using an explicit recursive generator function.
    2. Using Haskell's core lazy list primitives (`iterate` and arithmetic sequences).
  ]
)

#bexitem(
  caption: "Higher-Order Consecutive Element Sums",
  ref-source: "intro_haskell.pdf, Slide 12",
  problem: [
    Write a point-free or lambda expression taking a list $l = [x_0, x_1, x_2, dots]$ and returning the pairwise consecutive sums $[x_0 + x_1, x_1 + x_2, dots]$. Analyze the typing and behavior of its constituent higher-order functions.
  ]
)

#bexitem(
  caption: "Quicksort and Operator Sections",
  ref-source: "intro_haskell.pdf, Slide 14",
  problem: [
    In the canonical Haskell Quicksort implementation:
    ```haskell
    qs :: Ord a => [a] -> [a]
    qs []     = []
    qs (p:tl) = (qs $ filter (< p) tl) ++ [p] ++ (qs $ filter (>= p) tl)
    ```
    Explain the syntax `(< p)` and `(>= p)`. What are operator sections, and why is parentheses placement crucial?
  ]
)

== Chapter 4: Category Theoretic Abstractions: Functors, Applicatives & Monads

#bexitem(
  caption: "Formal Proof of Monad Laws for `Maybe`",
  ref-source: "intro_haskell.pdf, Slide 21",
  problem: [
    For the standard `Maybe` monad instance:
    ```haskell
    return x      = Just x
    Nothing >>= _ = Nothing
    Just x  >>= f = f x
    ```
    Prove analytically that the 3 categorical monad laws are satisfied for all values:
    1. *Left Identity:* `return a >>= f` $equiv$ `f a`.
    2. *Right Identity:* `m >>= return` $equiv$ `m`.
    3. *Associativity:* `(m >>= f) >>= g` $equiv$ `m >>= (\x -> f x >>= g)`.
  ]
)

#bexitem(
  caption: "Peeling Monadic Structure (`join`)",
  ref-source: "intro_haskell.pdf, Slide 24",
  problem: [
    The flattening operation (peeling one monadic layer) is defined as:
    ```haskell
    join :: Monad m => m (m a) -> m a
    ```
    1. Implement `join` specifically by hand for `Maybe (Maybe a) -> Maybe a`.
    2. Implement `join` universally for any arbitrary `Monad m` using only `(>>=)` and `id`.
  ]
)

#bexitem(
  caption: "List Monad Desugaring & Sequential I/O Printing",
  ref-source: "intro_haskell.pdf, Slide 26",
  problem: [
    1. Desugar the following list comprehension `do`-block into explicit `(>>=)` and `return`, verifying the typing at each step:
       ```haskell
       do { x <- [1, 2]; y <- [1, 5]; return (x, y) }
       ```
    2. Implement a function `printAll :: [String] -> IO ()` that prints each string on a separate line using only pure recursion or monadic bind, without using `mapM_` from Prelude.
  ]
)

= Part II: Solutions for Front-End Architecture & Syntax Analysis

== Chapter 6: Lexical & Syntactic Analysis: Alex & Happy in Practice

#bexitem(
  caption: "Parenthesized Expression Parsing & Max Depth",
  ref-source: "compil_happy.pdf, Section 4.5 (paren-01, paren-02)",
  problem: [
    1. Write a Happy grammar over tokens `'('` and `')'` that parses well-parenthesized expressions and returns the maximum nesting depth directly as an integer.
    2. Explain how source position tracking via Alex's `%wrapper "posn"` enables accurate error diagnostics.
  ]
)

#bexitem(
  caption: "Lexical Identifiers in Context-Free Grammars",
  ref-source: "compil_happy.pdf, Section 4.5 (paren-04, paren-05)",
  problem: [
    In `paren-04`, the Happy grammar allows identifier tokens only at leaf positions:
    ```haskell
    Expr : {- empty -}             { Empty }
         | ident                   { Leaf $1 }
         | '(' Expr ')' Expr       { Node $2 $4 }
    ```
    1. Where are identifiers forbidden by this grammar? Give an example of an invalid string.
    2. How can the grammar be refactored to allow arbitrary sequences of identifiers and parenthesized groups?
  ]
)

== Chapter 7: Abstract Syntax Trees & Expression Evaluation: The Calculator System

#bexitem(
  caption: "Pure Arithmetic AST & Evaluator",
  ref-source: "compil_happy.pdf, Section 3.1–3.2",
  problem: [
    1. Define a pure algebraic data type `AExpr` supporting floating-point literals (`Double`), unary negation, and the binary operators `+`, `-`, `*`, `/`, and `^`.
    2. Implement an evaluator `eval :: AExpr -> Maybe Double` that safely returns `Nothing` when encountering a division by zero.
  ]
)

#bexitem(
  caption: "Environment-Based Evaluation & Variables",
  ref-source: "compil_happy.pdf, Section 3.4 & Section 5",
  problem: [
    Extend `AExpr` with variable names `Var String` and assignments `Assign String AExpr`. Formulate an evaluator `evalEnv :: [(String, Double)] -> AExpr -> Either String (Double, [(String, Double)])` that looks up bound variables, rejects unbound identifiers with a descriptive error message, and updates the environment upon assignment.
  ]
)

= Part III: Solutions for Back-End Construction & Code Generation

== Chapter 8: Stack Machine Architecture: The 17-Instruction Virtual Machine

#bexitem(
  caption: "Relational Comparison on the 17-Instruction Machine",
  ref-source: "defmachine.pdf, Slide 9",
  problem: [
    The virtual machine does not possess a primitive comparison instruction (such as `<` or `CMP`). It provides only `BEZ` (branch if zero) and `BGZ` (branch if strictly positive).
    Given two values $A$ and $B$ at the top of the stack (with $B$ above $A$), write a minimal symbolic assembly sequence computing the boolean test $A < B$, leaving $1$ on the stack if true and $0$ if false.
  ]
)

#bexitem(
  caption: "Manual Assembly Compilation: Euclidean GCD",
  ref-source: "happy_pascal.pdf, Milestone 14 & defmachine.pdf",
  problem: [
    Write the complete symbolic assembly program calculating the Greatest Common Divisor ($gcd$) of two integers read from standard input, using the Euclidean algorithm, and printing the result to `OUT`.
  ]
)

== Chapter 9: Code Generation: Compiling High-Level Languages to Stack Bytecode

#bexitem(
  caption: "Recursive AST to Stack Bytecode Emission",
  ref-source: "happy_pascal.pdf, Milestones 1–6",
  problem: [
    Consider an arithmetic expression AST type:
    ```haskell
    data Op = Add | Sub | Mul | Div
    data Expr = Lit Int | Var String | BinOp Op Expr Expr
    ```
    Write a pure code generation function `compileExpr :: Expr -> [String]` that emits assembly instructions maintaining the stack invariant (leaving exactly one result at the top of the operand stack).
  ]
)

#bexitem(
  caption: "Array Indexing L-Value & R-Value Emission",
  ref-source: "happy_pascal.pdf, Milestone 15 & defmachine.pdf",
  problem: [
    1. Specify the stack assembly sequence to read the value of `primes[i + 1]`.
    2. Specify the stack assembly sequence to execute the assignment `primes[i + 1] := 42;`.
  ]
)

== Chapter 10: Functions, Activation Records & Runtime Memory Management

#bexitem(
  caption: "Recursive Function Activation & Factorial Emission",
  ref-source: "happy_pascal.pdf, Milestone 28 & intro_haskell.pdf, Slide 5",
  problem: [
    Outline the stack machine calling convention for the recursive function:
    ```pascal
    function fact(n: integer): integer;
    begin
      if n <= 1 then fact := 1 else fact := n * fact(n - 1)
    end;
    ```
    Provide the symbolic assembly implementation with return address preservation and frame teardown.
  ]
)

#bexitem(
  caption: "Fibonacci: Naive Tree Recursion vs. Linear Accumulator",
  ref-source: "happy_pascal.pdf, Milestone 28",
  problem: [
    1. Write the naive recursive Fibonacci function $F(n) = F(n-1) + F(n-2)$ and analyze its stack frame growth.
    2. Implement an optimized linear tail-recursive accumulator version in Haskell and explain why it compiles to $cal(O)(1)$ stack memory.
  ]
)

== Chapter 11: Advanced Topics: Type Checking, Optimizations & Native Code Generation

#bexitem(
  caption: "Constant Folding AST Optimization",
  ref-source: "happy_pascal.pdf, Milestone 41",
  problem: [
    Implement a recursive optimization pass `foldConstants :: Expr -> Expr` on arithmetic expressions that collapses subtrees containing only constant integer literals into single literal nodes at compile time.
  ]
)

#bexitem(
  caption: "Short-Circuit Boolean Evaluation",
  ref-source: "happy_pascal.pdf, Milestone 38",
  problem: [
    Pascal's logical operators `and` and `or` can cause unwanted side effects or division-by-zero crashes if both operands are eagerly evaluated (e.g. `(y <> 0) and (x mod y == 0)`).
    Formulate the conditional jump pattern that guarantees short-circuit execution on the stack machine.
  ]
)

= Part IV: Course Laboratories & Semester Projects

== Problem Set 1: Lexing and Parsing Well-Parenthesized Expressions

#bexitem(
  caption: "Parenthesis Depth Parser",
  ref-source: "compil_happy.pdf (paren-01)",
  problem: [
    Write a Happy grammar that directly computes the maximum nesting depth of well-parenthesized expressions as an integer.
  ]
)

#bexitem(
  caption: "Rose Tree Parse Generation",
  ref-source: "compil_happy.pdf (paren-03)",
  problem: [
    Modify the grammar to produce an explicit multi-way tree (generalized rose tree) representing the nested syntactic hierarchy.
  ]
)

== Problem Set 2 & 3: Architectures for the 24 Calculator and 42 Pascal Milestones

#bexitem(
  caption: "Incremental Calculator Pipeline Architecture (24 Milestones)",
  ref-source: "compil_happy.pdf, Section 5",
  problem: [
    How should the scanner (`CalculatriceLexer.x`), parser (`CalculatriceParser.y`), and runtime REPL (`Calcul.hs`) be structured to systematically satisfy all 24 milestones (from Double numbers to Unicode variables and implicit multiplication)?
  ]
)

#bexitem(
  caption: "Pascal Compiler Code Generator Architecture (42 Milestones)",
  ref-source: "happy_pascal.pdf, Section 2",
  problem: [
    Provide the overall architecture for the 42-stage Pascal compiler translating Pascal ASTs into 17-instruction symbolic bytecode, specifically addressing label generation, memory reservation, and activation records.
  ]
)
