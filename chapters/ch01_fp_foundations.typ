#import "common.typ": bdefinition, bexample, blemma, bnotice, bproposition, btheorem

== Paradigms of Computation & Lambda Calculus

Computer science grounds computational processes into two foundational paradigms originating from the mid-20th century work of Alan Turing and Alonzo Church:

1. *The Imperative Paradigm (Von Neumann Architecture):*
  - Programs are formulated as sequences of state transitions: $sigma_0 attach(arrow.r, t: c_1) sigma_1 attach(arrow.r, t: c_2) dots attach(arrow.r, t: c_n) sigma_n$.
  - The central mechanisms are mutable memory variables, assignment commands ($x := e$), iterative loops (`while`, `for`), and control transfers (`goto`, jumps).
  - The program specifies *how* a machine modifies its registers and addressable random-access memory (RAM).

2. *The Declarative / Functional Paradigm ($lambda$-Calculus):*
  - Programs are mathematical expressions denoting values.
  - Computation consists of term rewriting and substitution (specifically $beta$-reduction in Alonzo Church's $lambda$-calculus):
    $ (lambda x. e_1) space e_2 attach(arrow.r, t: beta) e_1 [x mapsto e_2] $
  - Computation is stateless and free of uncontrolled side effects: the programmer specifies *what* relationships hold and what values are defined, rather than managing CPU cycles and memory cells.

#btheorem(caption: "Church-Turing Thesis")[
  Every effectively calculable function over the natural numbers can be computed by a Turing Machine, and equivalently by an expression in the untyped $lambda$-calculus. Both models are Turing-complete and possess identical computational power.
]

=== Idiomatic Expression: GCD Case Study

To illustrate the philosophical divide between how imperative code manages state and how functional code declares equations, consider the Euclidean algorithm for computing the Greatest Common Divisor ($gcd$) of two integers $a, b in bb(N)$.

*Imperative Python:*
```python
def gcd(x: int, y: int) -> int:
    while y != 0:
        r = x % y
        x = y
        y = r
    return x
```
In Python, computation proceeds by mutating the bindings of local memory locations `x`, `y`, and `r` through successive clock steps of the loop until the condition $y = 0$ is realized.

*Declarative Haskell:*
```haskell
gcd :: Integral a => a -> a -> a
gcd x 0 = x
gcd x y = gcd y (x `mod` y)
```
In Haskell, the algorithm is expressed as a set of equational identities matching the mathematical formulation:
$ gcd(x, y) = cases(x & "if" y = 0, , gcd(y, x mod y) & "if" y != 0) $
There is no mutable variable, no hidden intermediate register, and no pointer state.

=== Syntax, Function Application, and Currying

In conventional programming languages (such as C, Java, or Python), invoking a function $f$ with arguments $x$ and $y$ requires parenthesized comma-separated tuples: `f(x, y)`.

In Haskell, OCaml, and the formal $lambda$-calculus:
- Function application is represented by mere juxtaposition: `f x y`.
- Parentheses serve exclusively for grouping expressions and defining precedence.
- Function application is strictly *left-associative*:
  $ f space x space y equiv ((f space x) space y) $

#bdefinition(caption: "Currying")[
  Let $X, Y, Z$ be types. Currying is the natural bijection between functions operating on Cartesian product pairs and functions returning intermediate functions:
  $ "curry": (X times Y -> Z) tilde.equiv (X -> (Y -> Z)) $
  In Haskell, every multi-argument function is curried by default. The type arrow `->` is *right-associative*:
  $ A -> B -> C equiv A -> (B -> C) $
]

#bexample(caption: "Stepwise Curried Evaluation")[
  Consider the expression `gcd 2 3`:
  1. `(gcd 2)` evaluates to an intermediate unary function of type `Int -> Int` which has captured the first parameter $2$.
  2. `((gcd 2) 3)` evaluates this intermediate function on the second argument $3$, yielding the final integer result $1$.
]

=== Mathematical Purity and Referential Transparency

#bdefinition(caption: "Pure Function")[
  A function $f: A -> B$ is *pure* if and only if:
  1. When invoked with identical arguments $x_1 = x_2 in A$, it always produces an identical output $f(x_1) = f(x_2) in B$.
  2. It causes no observable side effect (such as mutating global variables, performing hidden I/O, modifying arguments in place, or reading clock/hardware states).
]

A direct consequence of purity is *referential transparency*: any expression can be replaced by its evaluated result without altering the observable behavior or semantic correctness of the enclosing program.

#bnotice(caption: "Optimization Advantages of Referential Transparency")[
  Because pure functions do not depend on external state or order of execution:
  - The compiler can execute subexpressions in parallel without race conditions or locks.
  - Pure expressions can be memoized, reordered, commoned up (Common Subexpression Elimination), or lifted out of loops.
  - In production GHC compilers, compile-time transformations such as *Generalized Stream Fusion* eliminate intermediate data structures:
    Chains of transformations like
    $ "map" f compose "map" g compose "filter" p $
    are fused into a single tight loop, avoiding intermediate allocations.
]

=== Strong Static Typing and Milner's Dictum

Haskell enforces a non-negotiable Hindley-Milner static type system. Types are resolved and checked entirely at compile time.

#btheorem(caption: "Robin Milner's Polymorphism Principle (1978)")[
  *"Well-typed programs cannot go wrong."*
  In a type-sound language, a program that successfully satisfies the static type checker will never encounter undefined run-time machine crashes, invalid memory interpretations, or type confusion errors at execution time.
]
