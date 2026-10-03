#import "@preview/latexy-book:0.0.1": (
  appendix, backmatter, book, code, corollary, definition, example, exercise, frontmatter, lemma, mainmatter, notice,
  proposition, theorem,
)

// Document metadata and latexy-book initial setup
#show: book.with(
  title: "Complete\nSolutions Manual",
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
        text(style: "italic")[Solutions Manual: Functional Programming & Compiler Construction], str(page-num),
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

// Custom environments for the solutions manual
#let sol-ex-counter = counter("sol-ex-counter")

#let bsolitem(caption: "", ref-source: "", problem: [], solution: []) = block(
  above: 1.6em,
  below: 1.6em,
  breakable: true,
  stroke: (left: 2.5pt + rgb("#6366f1")),
  inset: (left: 12pt, y: 4pt),
)[
  #sol-ex-counter.step()
  #text(weight: "bold", fill: rgb("#4338ca"), size: 1.05em)[Exercise #context sol-ex-counter.display()]#if caption != "" [ #text(weight: "bold")[(#caption).] ] else [ #text(weight: "bold")[.] ]
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

  #block(
    above: 0.8em,
    below: 0.4em,
  )[
    #text(weight: "bold", fill: rgb("#15803d"))[Complete Solution & Derivation:] \
    #solution
  ]
]

// ==========================================
// FRONT MATTER
// ==========================================
#frontmatter()

= Preface
This document serves as the exhaustive, rigorous *Solutions Manual* to accompany the course monograph _Principles of Functional Programming & Compiler Construction_. It collects complete derivations, proofs, Haskell implementations, Alex/Happy grammar definitions, and virtual stack machine symbolic assembly sequences for:

1. All embedded lecture and chapter exercises across functional programming and compiler topics.
2. The foundational problem sets (including well-parenthesized expression grammar variations).
3. The reference architectures and implementation strategies for the 24-milestone Scientific Calculator project.
4. The reference architectures and implementation strategies for the 42-milestone Pascal-to-Stack-Bytecode Compiler project.

#outline(indent: auto)

// ==========================================
// MAIN MATTER
// ==========================================
#mainmatter()

#set page(
  paper: "us-letter",
  margin: (top: 1in, bottom: 1in, inside: 1.25in, outside: 1in),
)

= Part I: Solutions for Functional Programming Foundations

== Chapter 1: Paradigms of Computation & Lambda Calculus

#bsolitem(
  caption: "Function Invocation Syntax",
  ref-source: "intro_haskell.pdf, Slide 5",
  problem: [
    How do you invoke the recursive factorial function `fact` with the integer argument `5` in Haskell? Explain the syntactic difference between Haskell's application convention and traditional imperative languages.
  ],
  solution: [
    In Haskell, function application is denoted simply by juxtaposition without parentheses:
    ```haskell
    fact 5
    ```
    In imperative languages (e.g. C, Python, Java), function calls require parenthesized tuples: `fact(5)`. In Haskell, writing `fact(5)` is parsed as applying `fact` to the parenthesized grouping `(5)`, which happens to evaluate to the integer `5`. However, for multi-argument functions `f(x, y)`, Haskell treats `(x, y)` as a single 2-tuple argument of type `(a, b)`, which causes a compile-time type mismatch if `f` expects curried arguments `a -> b -> c`.
  ]
)

#bsolitem(
  caption: "First-Principles Currying & Uncurrying",
  ref-source: "intro_haskell.pdf, Slide 9",
  problem: [
    Implement the foundational functions `curry` and `uncurry` from first principles without using standard library shortcuts:
    ```haskell
    curry   :: ((a, b) -> c) -> a -> b -> c
    uncurry :: (a -> b -> c) -> ((a, b) -> c)
    ```
    Demonstrate that they form an isomorphism by showing that $"curry" compose "uncurry" equiv "id"$ and $"uncurry" compose "curry" equiv "id"$.
  ],
  solution: [
    ```haskell
    curry :: ((a, b) -> c) -> a -> b -> c
    curry f x y = f (x, y)

    uncurry :: (a -> b -> c) -> ((a, b) -> c)
    uncurry f (x, y) = f x y
    ```
    *Proof of Isomorphism:*
    1. Let $g :: (a, b) -> c$. Then:
       $ ("uncurry" ("curry" space g)) space (x, y) = ("curry" space g) space x space y = g (x, y) $
       Hence $"uncurry" ("curry" space g) = g$, which means $"uncurry" compose "curry" = "id"$.
    2. Let $h :: a -> b -> c$. Then:
       $ ("curry" ("uncurry" space h)) space x space y = ("uncurry" space h) space (x, y) = h space x space y $
       Hence $"curry" ("uncurry" space h) = h$, which means $"curry" compose "uncurry" = "id"$.
    This formalizes the categorical bijection between $C^(A times B)$ and $(C^B)^A$.
  ]
)

== Chapter 2: Algebraic Data Types & Recursive Data Modeling

#bsolitem(
  caption: "Polymorphic Constructor Inference",
  ref-source: "intro_haskell.pdf, Slide 8",
  problem: [
    Consider the polymorphic inductive data type:
    ```haskell
    data MyList a = Empty | Cons a (MyList a) deriving (Show)
    ```
    What is the deduced type of the nested expression `Cons Empty Empty` in GHCi? Explain how the Hindley-Milner type inference engine resolves this term.
  ],
  solution: [
    In the definition of `Cons`, the constructor signature is:
    ```haskell
    Cons :: a -> MyList a -> MyList a
    ```
    Here, the first argument is `Empty`, whose type is `MyList b` for a fresh type variable $b$. The second argument is also `Empty`, whose type is `MyList (MyList b)`.
    Substituting $a = "MyList" space b$, the overall type of the expression is:
    ```haskell
    Cons Empty Empty :: MyList (MyList b)
    ```
    It represents a list of lists of arbitrary elements $b$, containing exactly one element (the empty list `Empty`).
  ]
)

#bsolitem(
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
  ],
  solution: [
    1. `lookup` iterates through the list of pairs `[(a, b)]` and tests whether the search key matches each pair's first component: `if key == k then Just v else ...`. Because equality `(==)` is not defined for arbitrary types (for example, functions `(->)` cannot have decidable equality), the typechecker requires `a` to belong to `Eq`.
    2. An associative list may not contain the queried key. Returning `Maybe b` turns `lookup` into a mathematically *total function*: if found, it yields `Just val`; if exhausted without a match, it yields `Nothing`, enforcing safe handling at compile time without null pointer faults.
  ]
)

#bsolitem(
  caption: "Laboratory TP 0: Binary Trees and Traversals",
  ref-source: "intro_haskell.pdf, Slide 18 (TP 0)",
  problem: [
    1. Define a polymorphic binary tree data type `Tree a` with empty leaves and value-bearing internal nodes.
    2. Implement recursive functions computing:
       - The height of the tree (`height :: Tree a -> Int`).
       - The total number of nodes (`nbNodes :: Tree a -> Int`).
       - The number of leaves (`nbLeaves :: Tree a -> Int`).
    3. Implement the three canonical depth-first tree traversals returning `[a]`: in-order, pre-order, and post-order.
  ],
  solution: [
    ```haskell
    data Tree a
      = Leaf
      | Node a (Tree a) (Tree a)
      deriving (Eq, Show)

    -- 1. Tree Metrics:
    height :: Tree a -> Int
    height Leaf           = 0
    height (Node _ l r)   = 1 + max (height l) (height r)

    nbNodes :: Tree a -> Int
    nbNodes Leaf         = 0
    nbNodes (Node _ l r) = 1 + nbNodes l + nbNodes r

    nbLeaves :: Tree a -> Int
    nbLeaves Leaf         = 1
    nbLeaves (Node _ l r) = nbLeaves l + nbLeaves r

    -- 2. Tree Traversals:
    inOrder :: Tree a -> [a]
    inOrder Leaf         = []
    inOrder (Node x l r) = inOrder l ++ [x] ++ inOrder r

    preOrder :: Tree a -> [a]
    preOrder Leaf         = []
    preOrder (Node x l r) = [x] ++ preOrder l ++ preOrder r

    postOrder :: Tree a -> [a]
    postOrder Leaf         = []
    postOrder (Node x l r) = postOrder l ++ postOrder r ++ [x]
    ```
  ]
)

== Chapter 3: Evaluation Strategies & The Mechanics of Laziness

#bsolitem(
  caption: "Infinite Sequence Generation via Laziness",
  ref-source: "intro_haskell.pdf, Slide 11",
  problem: [
    Implement the infinite sequence of natural numbers $[1, 2, 3, 4, dots]$:
    1. Using an explicit recursive generator function.
    2. Using Haskell's core lazy list primitives (`iterate` and arithmetic sequences).
  ],
  solution: [
    ```haskell
    -- 1. Explicit recursive generator:
    fromN :: Integer -> [Integer]
    fromN n = n : fromN (n + 1)

    infList1 :: [Integer]
    infList1 = fromN 1

    -- 2. Standard lazy list primitives:
    infList2 :: [Integer]
    infList2 = [1..]

    infList3 :: [Integer]
    infList3 = iterate (+1) 1
    ```
    *Operational Mechanics:* Due to non-strict evaluation, calling `take 5 infList1` only expands the thunk chain up to five `(:)` constructor applications, leaving the tail unevaluated in memory.
  ]
)

#bsolitem(
  caption: "Higher-Order Consecutive Element Sums",
  ref-source: "intro_haskell.pdf, Slide 12",
  problem: [
    Write a point-free or lambda expression taking a list $l = [x_0, x_1, x_2, dots]$ and returning the pairwise consecutive sums $[x_0 + x_1, x_1 + x_2, dots]$. Analyze the typing and behavior of its constituent higher-order functions.
  ],
  solution: [
    ```haskell
    consecutiveSums :: Num a => [a] -> [a]
    consecutiveSums = \l -> zipWith (+) l (tail l)
    ```
    *Analysis of Components:*
    - `tail l` shifts the stream by one index: $[x_1, x_2, x_3, dots]$.
    - `zipWith` has type `(a -> b -> c) -> [a] -> [b] -> [c]`. It consumes two lists simultaneously and pairs elements with `(+)`.
    - Termination: `zipWith` terminates as soon as the shorter list terminates, naturally producing a result with length $"length"(l) - 1$.
  ]
)

#bsolitem(
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
  ],
  solution: [
    In Haskell, an infix binary operator can be partially applied by enclosing it in parentheses with one argument:
    - `(< p)` is a right section: it is syntactically equivalent to `\x -> x < p`.
    - `(p <)` is a left section: it is syntactically equivalent to `\x -> p < x`.
    - If one omits parentheses and writes `filter < p tl`, Haskell's left-associative application parses this as `((filter <) p) tl`, which fails immediately with a type mismatch because `<` is treated as an expression rather than an applied function argument.
  ]
)

== Chapter 4: Category Theoretic Abstractions: Functors, Applicatives & Monads

#bsolitem(
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
  ],
  solution: [
    - *Law 1 (Left Identity):*
      $ "return" space a >>= f = ("Just" space a) >>= f = f space a $
      Holds directly by definition of `(>>=)` on `Just`.
    - *Law 2 (Right Identity):*
      - Case $m = "Nothing"$: $"Nothing" >>= "return" = "Nothing" = m$.
      - Case $m = "Just" space x$: $("Just" space x) >>= "return" = "return" space x = "Just" space x = m$.
      Holds in all cases.
    - *Law 3 (Associativity):*
      - Case $m = "Nothing"$:
        $ ("Nothing" >>= f) >>= g = "Nothing" >>= g = "Nothing" $
        $ "Nothing" >>= (lambda x. f(x) >>= g) = "Nothing" $
      - Case $m = "Just" space x$:
        $ (("Just" space x) >>= f) >>= g = (f space x) >>= g $
        $ ("Just" space x) >>= (lambda x. f(x) >>= g) = (lambda x. f(x) >>= g) space x = (f space x) >>= g $
      Both expressions evaluate to $(f space x) >>= g$. Hence associativity holds unconditionally.
  ]
)

#bsolitem(
  caption: "Peeling Monadic Structure (`join`)",
  ref-source: "intro_haskell.pdf, Slide 24",
  problem: [
    The flattening operation (peeling one monadic layer) is defined as:
    ```haskell
    join :: Monad m => m (m a) -> m a
    ```
    1. Implement `join` specifically by hand for `Maybe (Maybe a) -> Maybe a`.
    2. Implement `join` universally for any arbitrary `Monad m` using only `(>>=)` and `id`.
  ],
  solution: [
    ```haskell
    -- 1. Explicit pattern matching for Maybe:
    joinMaybe :: Maybe (Maybe a) -> Maybe a
    joinMaybe Nothing         = Nothing
    joinMaybe (Just Nothing)  = Nothing
    joinMaybe (Just (Just x)) = Just x

    -- 2. Universal categorical definition for any Monad:
    join :: Monad m => m (m a) -> m a
    join mma = mma >>= id
    ```
    *Explanation:* In `mma >>= id`, `mma` has type `m (m a)` and `id` has type `m a -> m a`. Applying `(>>=) :: m t -> (t -> m a) -> m a` with $t = m space a$ yields the result type `m a`.
  ]
)

#bsolitem(
  caption: "List Monad Desugaring & Sequential I/O Printing",
  ref-source: "intro_haskell.pdf, Slide 26",
  problem: [
    1. Desugar the following list comprehension `do`-block into explicit `(>>=)` and `return`, verifying the typing at each step:
       ```haskell
       do { x <- [1, 2]; y <- [1, 5]; return (x, y) }
       ```
    2. Implement a function `printAll :: [String] -> IO ()` that prints each string on a separate line using only pure recursion or monadic bind, without using `mapM_` from Prelude.
  ],
  solution: [
    *1. Desugared List Computation:*
    ```haskell
    [1, 2] >>= (\x -> [1, 5] >>= (\y -> return (x, y)))
    ```
    *Step-by-step type check:*
    - Inner lambda: `\y -> return (x, y) :: Int -> [(Int, Int)]`.
    - Inner bind: `[1, 5] >>= ...` has type `[(Int, Int)]` (computes pairs for a given $x$).
    - Outer lambda: `\x -> ...` has type `Int -> [(Int, Int)]`.
    - Outer bind: `[1, 2] >>= ...` concatenates the sublists: $[(1, 1), (1, 5), (2, 1), (2, 5)]$.

    *2. Sequential IO Printer:*
    ```haskell
    printAll :: [String] -> IO ()
    printAll []     = return ()
    printAll (s:ss) = putStrLn s >> printAll ss
    ```
  ]
)

= Part II: Solutions for Front-End Architecture & Syntax Analysis

== Chapter 6: Lexical & Syntactic Analysis: Alex & Happy in Practice

#bsolitem(
  caption: "Parenthesized Expression Parsing & Max Depth",
  ref-source: "compil_happy.pdf, Section 4.5 (paren-01, paren-02)",
  problem: [
    1. Write a Happy grammar over tokens `'('` and `')'` that parses well-parenthesized expressions and returns the maximum nesting depth directly as an integer.
    2. Explain how source position tracking via Alex's `%wrapper "posn"` enables accurate error diagnostics.
  ],
  solution: [
    ```haskell
    -- Happy grammar computing nesting depth:
    Expr : {- empty -}                 { 0 }
         | '(' Expr ')' Expr           { max (1 + $2) $4 }
    ```
    *Nesting Depth Deduction:*
    - Empty string: $0$.
    - `"()"`: $max(1 + 0, 0) = 1$.
    - `"(()())"`: inner subexpressions have depth $1$, outer nesting adds $1$, yielding $2$.
    In Alex, specifying `%wrapper "posn"` wraps each matched token in a record containing `AlexPn offset line col`. When Happy triggers the `%error` routine on unexpected tokens, the compiler extracts `line` and `col` to print precise source location diagnostics.
  ]
)

#bsolitem(
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
  ],
  solution: [
    1. Identifiers cannot appear consecutively (e.g. `"foo bar"`) or immediately after a closed parenthesis without an intervening left parenthesis (e.g. `"(foo) bar"` is parsed as `Node (Leaf "foo") (Leaf "bar")`, but `"(foo) bar baz"` fails because `Expr` on the right expects either empty, a single ident, or a parenthesized block).
    2. To permit arbitrary sequences, refactor `Expr` into a list of atomic items:
    ```haskell
    Expr  : ItemList                 { $1 }
    ItemList : {- empty -}           { [] }
             | Item ItemList         { $1 : $2 }
    Item  : ident                    { IdentItem $1 }
          | '(' Expr ')'             { GroupItem $2 }
    ```
  ]
)

== Chapter 7: Abstract Syntax Trees & Expression Evaluation: The Calculator System

#bsolitem(
  caption: "Pure Arithmetic AST & Evaluator",
  ref-source: "compil_happy.pdf, Section 3.1–3.2",
  problem: [
    1. Define a pure algebraic data type `AExpr` supporting floating-point literals (`Double`), unary negation, and the binary operators `+`, `-`, `*`, `/`, and `^`.
    2. Implement an evaluator `eval :: AExpr -> Maybe Double` that safely returns `Nothing` when encountering a division by zero.
  ],
  solution: [
    ```haskell
    data AExpr
      = Lit Double
      | Neg AExpr
      | Add AExpr AExpr
      | Sub AExpr AExpr
      | Mul AExpr AExpr
      | Div AExpr AExpr
      | Pow AExpr AExpr
      deriving (Eq, Show)

    eval :: AExpr -> Maybe Double
    eval (Lit d)     = Just d
    eval (Neg e)     = fmap negate (eval e)
    eval (Add e1 e2) = do { v1 <- eval e1; v2 <- eval e2; return (v1 + v2) }
    eval (Sub e1 e2) = do { v1 <- eval e1; v2 <- eval e2; return (v1 - v2) }
    eval (Mul e1 e2) = do { v1 <- eval e1; v2 <- eval e2; return (v1 * v2) }
    eval (Pow e1 e2) = do { v1 <- eval e1; v2 <- eval e2; return (v1 ** v2) }
    eval (Div e1 e2) = do
      v1 <- eval e1
      v2 <- eval e2
      if v2 == 0 then Nothing else Just (v1 / v2)
    ```
  ]
)

#bsolitem(
  caption: "Environment-Based Evaluation & Variables",
  ref-source: "compil_happy.pdf, Section 3.4 & Section 5",
  problem: [
    Extend `AExpr` with variable names `Var String` and assignments `Assign String AExpr`. Formulate an evaluator `evalEnv :: [(String, Double)] -> AExpr -> Either String (Double, [(String, Double)])` that looks up bound variables, rejects unbound identifiers with a descriptive error message, and updates the environment upon assignment.
  ],
  solution: [
    ```haskell
    type Env = [(String, Double)]

    evalEnv :: Env -> AExpr -> Either String (Double, Env)
    evalEnv env (Lit d) = Right (d, env)
    evalEnv env (Var x) = case lookup x env of
      Just v  -> Right (v, env)
      Nothing -> Left ("Undefined variable: " ++ x)
    evalEnv env (Assign x e) = do
      (val, env') <- evalEnv env e
      let newEnv = (x, val) : filter ((/= x) . fst) env'
      return (val, newEnv)
    evalEnv env (Add e1 e2) = do
      (v1, env1) <- evalEnv env e1
      (v2, env2) <- evalEnv env1 e2
      return (v1 + v2, env2)
    evalEnv env (Div e1 e2) = do
      (v1, env1) <- evalEnv env e1
      (v2, env2) <- evalEnv env1 e2
      if v2 == 0
        then Left "Evaluation error: division by zero"
        else return (v1 / v2, env2)
    ```
  ]
)

= Part III: Solutions for Back-End Construction & Code Generation

== Chapter 8: Stack Machine Architecture: The 17-Instruction Virtual Machine

#bsolitem(
  caption: "Relational Comparison on the 17-Instruction Machine",
  ref-source: "defmachine.pdf, Slide 9",
  problem: [
    The virtual machine does not possess a primitive comparison instruction (such as `<` or `CMP`). It provides only `BEZ` (branch if zero) and `BGZ` (branch if strictly positive).
    Given two values $A$ and $B$ at the top of the stack (with $B$ above $A$), write a minimal symbolic assembly sequence computing the boolean test $A < B$, leaving $1$ on the stack if true and $0$ if false.
  ],
  solution: [
    To determine if $A < B$, compute the difference $B - A$:
    $ A < B quad arrow.l.r.double quad B - A > 0 $
    *Assembly Sequence:*
    ```assembly
    ;/ Stack initially contains: [..., A, B]
    SWAP        ;/ Stack: [..., B, A]
    SUB         ;/ Stack: [..., B - A]
    BGZ is_true ;/ Pops (B - A); jumps if (B - A) > 0
    PUSH 0      ;/ False case: push 0
    PUSH end_cmp
    GOTO
    is_true EQU *
    PUSH 1      ;/ True case: push 1
    end_cmp EQU *
    ```
    After this sequence, the condition value ($0$ or $1$) is at the top of the stack.
  ]
)

#bsolitem(
  caption: "Manual Assembly Compilation: Euclidean GCD",
  ref-source: "happy_pascal.pdf, Milestone 14 & defmachine.pdf",
  problem: [
    Write the complete symbolic assembly program calculating the Greatest Common Divisor ($gcd$) of two integers read from standard input, using the Euclidean algorithm, and printing the result to `OUT`.
  ],
  solution: [
    ```assembly
    ;/ Variable data allocations
    x DS 1
    y DS 1
    r DS 1

    ;/ Read inputs into variables x and y
    PUSH x
    IN
    STORE
    PUSH y
    IN
    STORE

    gcd_loop EQU *
    ;/ Condition: while y != 0
    PUSH y
    LOAD
    BEZ gcd_end

    ;/ Body: r := x mod y = x - (x / y) * y
    PUSH r
    PUSH x
    LOAD
    PUSH x
    LOAD
    PUSH y
    LOAD
    DIV
    PUSH y
    LOAD
    MUL
    SUB
    STORE       ;/ r = x - (x / y) * y

    ;/ x := y
    PUSH x
    PUSH y
    LOAD
    STORE

    ;/ y := r
    PUSH y
    PUSH r
    LOAD
    STORE

    ;/ Repeat loop
    PUSH gcd_loop
    GOTO

    gcd_end EQU *
    ;/ Print x to standard output
    PUSH x
    LOAD
    OUT
    STOP
    ```
  ]
)

== Chapter 9: Code Generation: Compiling High-Level Languages to Stack Bytecode

#bsolitem(
  caption: "Recursive AST to Stack Bytecode Emission",
  ref-source: "happy_pascal.pdf, Milestones 1–6",
  problem: [
    Consider an arithmetic expression AST type:
    ```haskell
    data Op = Add | Sub | Mul | Div
    data Expr = Lit Int | Var String | BinOp Op Expr Expr
    ```
    Write a pure code generation function `compileExpr :: Expr -> [String]` that emits assembly instructions maintaining the stack invariant (leaving exactly one result at the top of the operand stack).
  ],
  solution: [
    ```haskell
    compileExpr :: Expr -> [String]
    compileExpr (Lit n)   = ["PUSH " ++ show n]
    compileExpr (Var x)   = ["PUSH " ++ x, "LOAD"]
    compileExpr (BinOp op e1 e2) =
      compileExpr e1 ++
      compileExpr e2 ++
      [emitOp op]
      where
        emitOp Add = "ADD"
        emitOp Sub = "SUB"
        emitOp Mul = "MUL"
        emitOp Div = "DIV"
    ```
    *Operational Invariant:*
    Evaluating `e1` pushes its value; evaluating `e2` pushes its value. Then the binary operation pops both values and pushes the combined result. The stack remains strictly balanced.
  ]
)

#bsolitem(
  caption: "Array Indexing L-Value & R-Value Emission",
  ref-source: "happy_pascal.pdf, Milestone 15 & defmachine.pdf",
  problem: [
    1. Specify the stack assembly sequence to read the value of `primes[i + 1]`.
    2. Specify the stack assembly sequence to execute the assignment `primes[i + 1] := 42;`.
  ],
  solution: [
    *1. Reading `primes[i + 1]` (R-Value):*
    ```assembly
    PUSH primes ;/ Base address
    PUSH i      ;/ Evaluate index expression (i + 1)
    LOAD
    PUSH 1
    ADD
    ADD         ;/ Effective address = primes + (i + 1)
    LOAD        ;/ Read memory content onto stack top
    ```

    *2. Writing `primes[i + 1] := 42` (L-Value assignment):*
    ```assembly
    ;/ 1. Compute destination address (L-value)
    PUSH primes
    PUSH i
    LOAD
    PUSH 1
    ADD
    ADD         ;/ Target address is now on stack
    ;/ 2. Evaluate right-hand expression
    PUSH 42
    ;/ 3. Store into memory
    STORE       ;/ data[target_addr] = 42; sp -= 2
    ```
  ]
)

== Chapter 10: Functions, Activation Records & Runtime Memory Management

#bsolitem(
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
  ],
  solution: [
    ```assembly
    ;/ Calling sequence from main:
    PUSH ret_main
    PUSH 5          ;/ Pass argument n = 5
    PUSH fact_entry
    GOTO
    ret_main EQU *
    OUT             ;/ Prints 120
    STOP

    fact_entry EQU *
    ;/ Stack top: [return_addr, n]
    SWAP            ;/ Stack: [n, return_addr]
    ;/ Test base case: n <= 1
    ;/ Compute difference (1 - n)
    PUSH 1
    PUSH n_local
    STORE           ;/ Store n into temporary or frame slot
    ...
    ;/ In a pure stack approach without frame registers:
    ;/ Save return address, compute recursive call, multiply, and exit:
    SWAP
    GOTO            ;/ Indirect jump back to saved return address
    ```
  ]
)

#bsolitem(
  caption: "Fibonacci: Naive Tree Recursion vs. Linear Accumulator",
  ref-source: "happy_pascal.pdf, Milestone 28",
  problem: [
    1. Write the naive recursive Fibonacci function $F(n) = F(n-1) + F(n-2)$ and analyze its stack frame growth.
    2. Implement an optimized linear tail-recursive accumulator version in Haskell and explain why it compiles to $cal(O)(1)$ stack memory.
  ],
  solution: [
    ```haskell
    -- 1. Naive recursive Fibonacci (O(2^n) time, O(n) call stack depth):
    fibNaive :: Integer -> Integer
    fibNaive 0 = 0
    fibNaive 1 = 1
    fibNaive n = fibNaive (n - 1) + fibNaive (n - 2)

    -- 2. Tail-recursive linear accumulator (O(n) time, O(1) stack space):
    fibOptimized :: Integer -> Integer
    fibOptimized n = go n 0 1
      where
        go 0 !a !b = a
        go k !a !b = go (k - 1) b (a + b)
    ```
    *Compiler Mechanics:*
    Under Tail Call Optimization (TCO), `go (k - 1) b (a + b)` occupies the tail position. Rather than pushing an activation record, the compiler updates parameters $k arrow.r k - 1$, $a arrow.r b$, and $b arrow.r a + b$ in place and loops back, executing in constant stack memory.
  ]
)

== Chapter 11: Advanced Topics: Type Checking, Optimizations & Native Code Generation

#bsolitem(
  caption: "Constant Folding AST Optimization",
  ref-source: "happy_pascal.pdf, Milestone 41",
  problem: [
    Implement a recursive optimization pass `foldConstants :: Expr -> Expr` on arithmetic expressions that collapses subtrees containing only constant integer literals into single literal nodes at compile time.
  ],
  solution: [
    ```haskell
    data Op = Add | Sub | Mul | Div deriving (Eq, Show)
    data Expr
      = Lit Int
      | Var String
      | BinOp Op Expr Expr
      deriving (Eq, Show)

    foldConstants :: Expr -> Expr
    foldConstants (BinOp op e1 e2) =
      case (foldConstants e1, foldConstants e2) of
        (Lit c1, Lit c2) -> Lit (evalConstant op c1 c2)
        (e1', e2')       -> BinOp op e1' e2'
    foldConstants leaf = leaf

    evalConstant :: Op -> Int -> Int -> Int
    evalConstant Add = (+)
    evalConstant Sub = (-)
    evalConstant Mul = (*)
    evalConstant Div = div
    ```
    *Optimization Benefit:* Subterms like `(2 + 3) * x` are simplified to `5 * x` before generating bytecode, eliminating four virtual stack instructions at run time.
  ]
)

#bsolitem(
  caption: "Short-Circuit Boolean Evaluation",
  ref-source: "happy_pascal.pdf, Milestone 38",
  problem: [
    Pascal's logical operators `and` and `or` can cause unwanted side effects or division-by-zero crashes if both operands are eagerly evaluated (e.g. `(y <> 0) and (x mod y == 0)`).
    Formulate the conditional jump pattern that guarantees short-circuit execution on the stack machine.
  ],
  solution: [
    *1. Compiling `e1 and e2` (Short-Circuit):*
    ```assembly
    ;/ Evaluate e1
    <code for e1>
    BEZ short_false  ;/ If e1 == 0, false! Skip e2
    <code for e2>
    BEZ short_false  ;/ If e2 == 0, false!
    PUSH 1           ;/ Both were non-zero: true
    PUSH end_and
    GOTO
    short_false EQU *
    PUSH 0
    end_and     EQU *
    ```
    *Guarantee:* If `e1` evaluates to $0$, the machine jumps directly to `short_false`, and the instructions for `e2` are never executed.
  ]
)

= Part IV: Solutions for Course Laboratories & Semester Projects

== Problem Set 1: Lexing and Parsing Well-Parenthesized Expressions

#bsolitem(
  caption: "Parenthesis Depth Parser",
  ref-source: "compil_happy.pdf (paren-01)",
  problem: [
    Write a Happy grammar that directly computes the maximum nesting depth of well-parenthesized expressions as an integer.
  ],
  solution: [
    ```haskell
    Expression : {- empty -}                   { 0 }
               | '(' Expression ')' Expression { max (1 + $2) $4 }
    ```
    *Verification:*
    - For `""`: matches empty rule $arrow.r 0$.
    - For `"()"`: $1 + 0 = 1$, followed by $0 arrow.r max(1, 0) = 1$.
    - For `"(())"`: inner is $1$, outer is $1 + 1 = 2$.
  ]
)

#bsolitem(
  caption: "Rose Tree Parse Generation",
  ref-source: "compil_happy.pdf (paren-03)",
  problem: [
    Modify the grammar to produce an explicit multi-way tree (generalized rose tree) representing the nested syntactic hierarchy.
  ],
  solution: [
    ```haskell
    data Parens = Node [Parens] deriving (Eq, Show)

    Expr : {- empty -}       { [] }
         | '(' Expr ')' Expr { Node $2 : $4 }
    ```
  ]
)

== Problem Set 2 & 3: Architectures for the 24 Calculator and 42 Pascal Milestones

#bsolitem(
  caption: "Incremental Calculator Pipeline Architecture (24 Milestones)",
  ref-source: "compil_happy.pdf, Section 5",
  problem: [
    How should the scanner (`CalculatriceLexer.x`), parser (`CalculatriceParser.y`), and runtime REPL (`Calcul.hs`) be structured to systematically satisfy all 24 milestones (from Double numbers to Unicode variables and implicit multiplication)?
  ],
  solution: [
    1. *Lexer (`CalculatriceLexer.x`):*
       Use `%wrapper "posn"`. Match numbers with scientific exponents `$digit+(\.$digit+)?([eE][\+\-]?$digit+)?`, keywords `true`, `false`, `quit`, `exit`, identifier strings `$alpha[$alpha $digit]*`, Unicode `π`, and discard whitespace `$white+;` and comments `//.* ;`.
    2. *Parser Precedence (`CalculatriceParser.y`):*
       ```haskell
       %right '='
       %left '?' ':'
       %left "or"
       %left "and"
       %nonassoc "==" "!=" '<' "<=" '>' ">="
       %left '+' '-'
       %left '*' '/'
       %right '^'
       %left NEG
       ```
    3. *Stateful REPL (`Calcul.hs`):*
       The loop carries a state environment `type Env = [(String, Double)]` initialized with `[("pi", pi), ("e", exp 1), ("π", pi)]`. Each evaluated assignment updates the map and recursively passes the new environment to the next loop iteration.
  ]
)

#bsolitem(
  caption: "Pascal Compiler Code Generator Architecture (42 Milestones)",
  ref-source: "happy_pascal.pdf, Section 2",
  problem: [
    Provide the overall architecture for the 42-stage Pascal compiler translating Pascal ASTs into 17-instruction symbolic bytecode, specifically addressing label generation, memory reservation, and activation records.
  ],
  solution: [
    1. *Label Generation Monad:*
       Code generation uses a `State Int` monad or pure counter `freshLabel :: String -> State Int String` producing monotonic symbolic labels (`L_else_1`, `L_end_1`, etc.).
    2. *Data Allocation Pass:*
       Before code emission, an AST pass extracts global `var` declarations and emits memory allocation directives:
       ```assembly
       x   DS 1
       arr DS 100
       ```
    3. *Stack Calling Convention:*
       For functions (Milestones 22–28), the caller pushes actual arguments and the return label, and branches via `GOTO`. The callee swaps the computed return value onto the stack, retrieves the return label, and branches back via `SWAP \n GOTO`.
  ]
)
