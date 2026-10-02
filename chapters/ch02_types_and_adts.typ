#import "common.typ": bdefinition, btheorem, blemma, bproposition, bexample, bnotice

== Algebraic Data Types & Recursive Data Modeling

The core expressive power of functional programming stems from *Algebraic Data Types (ADTs)*. An ADT is defined by the `data` keyword and allows constructing sum types (disjoint unions) and product types (records/tuples).

=== Sum Types and Constructors

#bdefinition(caption: "Algebraic Data Type")[
An Algebraic Data Type $T$ is declared by specifying its set of data constructors $C_1, dots, C_k$, each accepting zero or more field types:
$ "data" space T = C_1 space tau_(1,1) dots tau_(1,m_1) bar.v dots bar.v C_k space tau_(k,1) dots tau_(k,m_k) $
Values of type $T$ are constructed inductively by applying one of the constructors $C_i$ to appropriate argument values.
]

Consider the inductive definition of an integer linked list:
```haskell
data IntList = Nil | Cons Int IntList
```
Here:
- `Nil` is the base constructor (nullary, representing the empty list $emptyset$).
- `Cons` is the inductive constructor, taking an `Int` head and a recursive tail of type `IntList`.

=== Pattern Matching

Computation over ADTs is conducted via *pattern matching*, which deconstructs algebraic values into their constituent components based on constructor forms. Pattern matching can be structured via equational clauses or through `case ... of` blocks.

```haskell
-- Equational pattern matching:
safeHead :: IntList -> Int
safeHead Nil        = error "safeHead: empty list has no head"
safeHead (Cons x _) = x

-- Equivalent case analysis:
safeHeadCase :: IntList -> Int
safeHeadCase l = case l of
  Nil      -> error "safeHeadCase: empty list"
  Cons x _ -> x
```

The `case l of` construct inspects the evaluated form (the *scrutinee*) of `l`, testing each pattern sequentially from top to bottom and evaluating the expression corresponding to the first matching constructor branch. The underscore wildcard `_` matches any subterm without binding an identifier, discarding unneeded values.

=== Parametric Polymorphism

Writing distinct list implementations for `Int`, `Double`, and `String` violates software reusability and leads to massive code duplication. In Hindley-Milner type systems, we introduce *type variables* (designated by lowercase identifiers like `a`, `b`) to obtain universally quantified generic data structures:

```haskell
data List a = Nil | Cons a (List a)
```
Here, `List` is a *type constructor* of kind $* -> *$. It takes any ground type $a$ and yields the concrete type `List a`.

=== Typeclasses and Ad-Hoc Polymorphism

While parametric polymorphism operates uniformly across all types without inspecting their structure, many operations require specific capabilities (e.g., equality testing, numeric addition, serialization). Haskell resolves this via *typeclasses*.

#bdefinition(caption: "Typeclass")[
A typeclass defines an abstract interface comprising method signatures:
```haskell
class Eq a where
  (==) :: a -> a -> Bool
  (/=) :: a -> a -> Bool
  x /= y = not (x == y)
```
A concrete type $T$ becomes an instance of a typeclass by providing implementations for its minimal complete definition:
```haskell
instance Eq a => Eq (List a) where
  Nil         == Nil         = True
  Cons x xs   == Cons y ys   = (x == y) && (xs == ys)
  _           == _           = False
```
]

Important standard typeclasses in Haskell:
- `Eq`: Supports equality tests `(==)` and `(/=)`.
- `Ord`: Extends `Eq` with total ordering relations (`<`, `<=`, `>`, `>=`, `compare`).
- `Show`: Provides string rendering (`show :: a -> String`).
- `Read`: Parses textual representations into typed values (`read :: Read a => String -> a`).
- `Num`, `Integral`, `Fractional`, `Floating`: Structure algebraic number hierarchies.

=== The Maybe Type and Handling Partiality

Functions in classical mathematics and programming are frequently *partial*: their domain of definition does not cover the entire input type.
- Example 1: Integer division by zero (`div x 0`).
- Example 2: Extracting the head of an empty list (`head []`).
- Example 3: Looking up a non-existent key in an associative map (`lookup k m`).

In imperative languages, partiality is typically handled by returning sentinel null pointers (e.g., `NULL`, `None`) or throwing unhandled run-time exceptions, which undermine referential transparency and cause crashes.

Haskell enforces explicit type-level partiality using the `Maybe` type:
```haskell
data Maybe a = Nothing | Just a
```
A total head function is thus specified as:
```haskell
totalHead :: List a -> Maybe a
totalHead Nil        = Nothing
totalHead (Cons x _) = Just x
```
The return type `Maybe a` informs both the compiler and downstream callers that failure is a possible outcome. The programmer is forced by the type checker to match and handle both `Nothing` and `Just` branches, completely eliminating null pointer exceptions at compile time.
