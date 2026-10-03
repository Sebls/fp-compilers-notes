#import "common.typ": bdefinition, btheorem, blemma, bproposition, bexample, bnotice, bexercise

== Category Theoretic Abstractions: Functors, Applicatives & Monads

One of the central design challenges in pure functional programming is managing effects—such as partiality, non-determinism, state accumulation, and input/output—while retaining mathematical purity and equational reasoning. Haskell accomplishes this through abstractions rooted in Category Theory: *Functors*, *Applicative Functors*, and *Monads*.

=== Functors and Covariant Mapping

#bdefinition(caption: "Functor Typeclass")[
A type constructor $F$ of kind $* -> *$ is a *Functor* if it implements the mapping operator `fmap`:
```haskell
class Functor f where
  fmap :: (a -> b) -> f a -> f b
  (<$>) :: (a -> b) -> f a -> f b
  (<$>) = fmap
```
A valid functor must satisfy the two categorical *Functor Laws*:
1. *Identity Law:*
   $ "fmap" space "id" = "id" $
2. *Composition Law:*
   $ "fmap" space (f compose g) = ("fmap" space f) compose ("fmap" space g) $
]

#bexample(caption: "Functor Instances")[
1. *Maybe Functor:*
   ```haskell
   instance Functor Maybe where
     fmap _ Nothing  = Nothing
     fmap f (Just x) = Just (f x)
   ```
2. *List Functor:*
   ```haskell
   instance Functor [] where
     fmap = map
   ```
]

=== Applicative Functors

While Functors allow lifting unary functions over a context $f$, they cannot directly apply a function encapsulated inside a context $f (a -> b)$ to an argument inside $f a$. This capability is provided by *Applicative Functors*.

#bdefinition(caption: "Applicative Functor")[
A functor $F$ is an *Applicative Functor* if it provides a unit constructor `pure` and sequential application `<*>`:
```haskell
class Functor f => Applicative f where
  pure  :: a -> f a
  (<*>) :: f (a -> b) -> f a -> f b
```
]

=== Monads and Sequencing Computations

When computations produce intermediate values that dictate subsequent contextual actions, simple applicative chaining is insufficient. We require dynamic sequential composition: this is the essence of a *Monad*.

#bdefinition(caption: "Monad Typeclass")[
A type constructor $M$ of kind $* -> *$ is a *Monad* if it provides `return` and the sequencing bind operator `>>=`:
```haskell
class Applicative m => Monad m where
  return :: a -> m a
  return = pure

  (>>=)  :: m a -> (a -> m b) -> m b
  (>>)   :: m a -> m b -> m b
  m1 >> m2 = m1 >>= (\_ -> m2)
```
Every lawful monad must satisfy the three fundamental *Monad Laws*:
1. *Left Identity:*
   $ ("return" space x) >>= k quad equiv quad k space x $
2. *Right Identity:*
   $ m >>= "return" quad equiv quad m $
3. *Associativity:*
   $ (m >>= f) >>= g quad equiv quad m >>= (lambda x. f(x) >>= g) $
]

#btheorem(caption: "Typeclass Hierarchy Theorem")[
Every Monad is an Applicative Functor, and every Applicative Functor is a Functor:
$ "Monad" space m arrow.r.double "Applicative" space m arrow.r.double "Functor" space m $
]

=== The Maybe and List Monads

*1. Maybe as a Monad (Exception Handling without Traps):*
```haskell
instance Monad Maybe where
  Nothing >>= _ = Nothing
  Just x  >>= f = f x
```
If any intermediate subcomputation fails and produces `Nothing`, the failure propagates directly to the end of the chain without invoking subsequent steps.

*2. Lists as a Monad (Non-Deterministic Computation):*
```haskell
instance Monad [] where
  xs >>= f = concat (map f xs)
```
The list monad represents non-deterministic branching computations where each step may produce zero, one, or multiple candidate results.

=== The `do` Notation Syntax Sugar

Chaining raw `>>=` and lambda expressions can quickly degrade readability:
```haskell
action1 >>= (\x1 ->
  action2 >>= (\x2 ->
    mk_action3 x1 x2))
```
Haskell introduces the `do` notation as purely syntactic sugar for monadic pipelines:
```haskell
do
  x1 <- action1
  x2 <- action2
  mk_action3 x1 x2
```

=== The `IO` Monad: Interacting with the Impure World

Because Haskell is purely functional, functions cannot directly perform side effects like reading keystrokes or printing to the console without violating referential transparency.

The solution is the `IO` Monad:
```haskell
putStrLn :: String -> IO ()
getLine  :: IO String
```
A value of type `IO a` is not an $a$; it is a *pure computation recipe* that, when executed by the Haskell runtime environment, performs I/O and yields a result of type $a$.

#bexample(caption: "Interactive Echo Pipeline")[
Consider constructing an interactive terminal echo program:
```haskell
-- Monadic bind composition:
echo :: IO ()
echo = getLine >>= putStrLn

-- Equivalent do block:
echoDo :: IO ()
echoDo = do
  line <- getLine
  putStrLn ("Echo: " ++ line)
```
]
Notice that you cannot simply write `putStrLn (getLine)`: the static type checker catches the type mismatch between `IO String` and `String`, guaranteeing that untrusted impure interactions cannot infiltrate pure functions without being tracked in the type system.

=== Chapter Exercises

#bexercise(caption: "Formal Proof of Monad Laws for `Maybe`", ref-source: "intro_haskell.pdf, Slide 21")[
  *Problem:* For the standard `Maybe` monad instance:
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

#bexercise(caption: "Peeling Monadic Structure (`join`)", ref-source: "intro_haskell.pdf, Slide 24")[
  *Problem:* The flattening operation (peeling one monadic layer) is defined as:
  ```haskell
  join :: Monad m => m (m a) -> m a
  ```
  1. Implement `join` specifically by hand for `Maybe (Maybe a) -> Maybe a`.
  2. Implement `join` universally for any arbitrary `Monad m` using only `(>>=)` and `id`.
]

#bexercise(caption: "List Monad Desugaring & Sequential I/O Printing", ref-source: "intro_haskell.pdf, Slide 26")[
  *Problem:*
  1. Desugar the following list comprehension `do`-block into explicit `(>>=)` and `return`, verifying the typing at each step:
     ```haskell
     do { x <- [1, 2]; y <- [1, 5]; return (x, y) }
     ```
  2. Implement a function `printAll :: [String] -> IO ()` that prints each string on a separate line using only pure recursion or monadic bind, without using `mapM_` from Prelude.
]

