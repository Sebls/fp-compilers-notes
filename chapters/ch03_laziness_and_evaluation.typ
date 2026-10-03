#import "common.typ": bdefinition, btheorem, blemma, bproposition, bexample, bnotice, bexercise

== Evaluation Strategies & The Mechanics of Laziness

Haskell is a *purely functional, non-strict* programming language evaluated by *call-by-need* (lazy evaluation with graph sharing). Understanding how laziness operates at the machine level is crucial for mastering complexity, termination, and space usage.

=== Strict vs. Non-Strict Evaluation

Let $e$ be a compound expression containing a subterm $e_1$.
- *Strict Evaluation (Call-by-Value):* Subterms $e_1, e_2, dots$ are evaluated to values *before* the function $f$ is invoked. If evaluating $e_1$ diverges ($e_1 = bot$), the entire function call $f(e_1)$ diverges immediately.
- *Non-Strict Evaluation (Call-by-Name / Call-by-Need):* Function arguments are passed unevaluated into the function body. An argument is evaluated if and only if its value is strictly demanded by a primitive operation or pattern match.

#bdefinition(caption: "Bottom ($bot$) and Non-Strictness")[
Let $bot$ ("bottom") denote a non-terminating computation (an infinite loop) or an explicit runtime abort (`error "boom"`). A function $f$ is *strict* if:
$ f(bot) = bot $
A function $f$ is *non-strict* if there exists an input such that $f(bot) != bot$.
]

#bexample(caption: "Non-Strict Evaluation of Conditionals and Constants")[
Consider the constant function `const :: a -> b -> a` defined by `const x y = x`:
```haskell
const 42 (error "divergence!") -- Evaluates strictly to 42!
```
Because the second argument is never scrutinized by the function, the error branch is never evaluated.
]

=== Thunks and Graph Reduction

Under non-strict semantics, an unevaluated expression is represented in heap memory as a *thunk* (a heap allocation containing a code pointer to the suspended computation and pointers to its free variables).

When an expression's value is demanded:
1. The CPU forces the thunk by executing its suspension code.
2. *Call-by-Need Sharing:* The thunk updates its heap cell in place with the evaluated result (an indirect node or constructor). Subsequent accesses read the memoized value directly in $cal(O)(1)$ time, avoiding duplicate evaluation.

=== Infinite Data Structures

Lazy evaluation decouples *data generation* from *data consumption*. A generator can define an infinite stream, while the consumer scrutinizes only the necessary prefix.

Consider the native list type `[a]`:
```haskell
-- Standard infinite sequence of Fibonacci numbers:
fibs :: [Integer]
fibs = 0 : 1 : zipWith (+) fibs (tail fibs)
```
Evaluating `take 10 fibs` computes only the first 10 elements. The remainder of the infinite stream remains unallocated in memory.

Similarly, consider the infinite list of natural numbers `[1..]`:
```haskell
-- take 5 [1..] evaluates step-by-step:
take 5 [1..] ==> [1, 2, 3, 4, 5]
```

=== Space Leaks and Strict Evaluation (`seq`, `$!`, BangPatterns)

While laziness enables modularity and infinite data structures, excessive lazy accumulation of unevaluated thunk chains can lead to critical memory exhaustion known as *space leaks*.

Consider the naive definition of list summation:
```haskell
sumNaive :: Num a => [a] -> a
sumNaive = foldl (+) 0
```
When evaluating `foldl (+) 0 [1..1000000]`, Haskell does not compute numbers on the fly; instead, it builds a massive thunk tree:
$ (dots ((0 + 1) + 2) + dots + 1000000) $
Evaluating this deeply nested tree causes a stack overflow.

To enforce strict evaluation, Haskell provides the primitive `seq`:
```haskell
seq :: a -> b -> b
```
`seq a b` forces the evaluation of `a` to *Weak Head Normal Form (WHNF)* before returning `b`.

The strictly accumulating fold `foldl'` in `Data.List` uses strictness:
```haskell
foldl' :: (b -> a -> b) -> b -> [a] -> b
foldl' f !acc []     = acc
foldl' f !acc (x:xs) = foldl' f (f acc x) xs
```
Here, the bang pattern `!acc` forces the intermediate accumulator to be evaluated at each step, ensuring $cal(O)(1)$ auxiliary space complexity.

=== Chapter Exercises

#bexercise(caption: "Infinite Sequence Generation via Laziness", ref-source: "intro_haskell.pdf, Slide 11")[
  *Problem:* Implement the infinite sequence of natural numbers $[1, 2, 3, 4, dots]$:
  1. Using an explicit recursive generator function.
  2. Using Haskell's core lazy list primitives (`iterate` and arithmetic sequences).
]

#bexercise(caption: "Higher-Order Consecutive Element Sums", ref-source: "intro_haskell.pdf, Slide 12")[
  *Problem:* Write a point-free or lambda expression taking a list $l = [x_0, x_1, x_2, dots]$ and returning the pairwise consecutive sums $[x_0 + x_1, x_1 + x_2, dots]$. Analyze the typing and behavior of its constituent higher-order functions.
]

#bexercise(caption: "Quicksort and Operator Sections", ref-source: "intro_haskell.pdf, Slide 14")[
  *Problem:* In the canonical Haskell Quicksort implementation:
  ```haskell
  qs :: Ord a => [a] -> [a]
  qs []     = []
  qs (p:tl) = (qs $ filter (< p) tl) ++ [p] ++ (qs $ filter (>= p) tl)
  ```
  Explain the syntax `(< p)` and `(>= p)`. What are operator sections, and why is parentheses placement crucial?
]

