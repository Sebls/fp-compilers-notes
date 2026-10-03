#import "common.typ": bdefinition, btheorem, blemma, bproposition, bexample, bnotice, bexercise

== Abstract Syntax Trees & Expression Evaluation: The Calculator System

Before generating target assembly or virtual machine instructions, a compiler represents input programs as *Abstract Syntax Trees (ASTs)*. We develop a complete, incremental scientific calculator language supporting floating-point arithmetic, symbol environments, unary/binary operations, and transcendental functions.

=== The Abstract Syntax Tree (AST) Data Type

We define an expressive recursive data type `AExpr` modeling arithmetic expressions:

```haskell
module ArithExpression where

type Ident = String

data BinOp = Add | Sub | Mul | Div | Pow deriving (Eq, Show)
data UnOp  = Neg | Sin | Cos | Tan | Exp | Log | Sqrt deriving (Eq, Show)

data AExpr
  = LitDouble Double
  | VarRef Ident
  | Binary BinOp AExpr AExpr
  | Unary UnOp AExpr
  | Assign Ident AExpr
  | Sequence [AExpr]
  deriving (Eq, Show)
```

=== Environments and Variable Lookup

Evaluating expressions containing variables requires an *evaluation environment* mapping identifier strings to concrete floating-point numbers:

```haskell
type Env = [(Ident, Double)]

lookupVar :: Ident -> Env -> Either String Double
lookupVar name [] = Left ("Undefined variable identifier: " ++ name)
lookupVar name ((k, v):xs)
  | name == k  = Right v
  | otherwise  = lookupVar name xs

extendEnv :: Ident -> Double -> Env -> Env
extendEnv name val env = (name, val) : filter (\(k, _) -> k /= name) env
```

=== Total Evaluation with the `Either` Error Monad

To handle run-time anomalies—such as division by zero, logarithms of non-positive numbers, or accessing unbound variables—we formulate the evaluator using `Either String Double`:

```haskell
evalExpr :: AExpr -> Env -> Either String (Double, Env)
evalExpr (LitDouble d) env = Right (d, env)

evalExpr (VarRef x) env = do
  val <- lookupVar x env
  return (val, env)

evalExpr (Assign x expr) env = do
  (val, env') <- evalExpr expr env
  let newEnv = extendEnv x val env'
  return (val, newEnv)

evalExpr (Unary Neg e) env = do
  (v, env') <- evalExpr e env
  return (-v, env')

evalExpr (Unary Sqrt e) env = do
  (v, env') <- evalExpr e env
  if v < 0
    then Left "Domain error: square root of negative number"
    else return (sqrt v, env')

evalExpr (Binary Div e1 e2) env = do
  (v1, env1) <- evalExpr e1 env
  (v2, env2) <- evalExpr e2 env1
  if v2 == 0
    then Left "Arithmetic error: Division by zero"
    else return (v1 / v2, env2)

evalExpr (Binary Add e1 e2) env = do
  (v1, env1) <- evalExpr e1 env
  (v2, env2) <- evalExpr e2 env1
  return (v1 + v2, env2)

evalExpr (Binary Mul e1 e2) env = do
  (v1, env1) <- evalExpr e1 env
  (v2, env2) <- evalExpr e2 env1
  return (v1 * v2, env2)

evalExpr (Binary Pow e1 e2) env = do
  (v1, env1) <- evalExpr e1 env
  (v2, env2) <- evalExpr e2 env1
  return (v1 ** v2, env2)
```

=== Interactive REPL (Read-Eval-Print Loop)

Using the monadic `IO` facilities developed earlier, the interactive calculator loop maintains the environment across user inputs:

```haskell
calcLoop :: Env -> IO ()
calcLoop env = do
  putStr "calc> "
  input <- getLine
  if input `elem` ["quit", "exit"]
    then putStrLn "Exiting calculator. Goodbye."
    else case parseLine input of
      Left err -> do
        putStrLn ("Parse error: " ++ err)
        calcLoop env
      Right ast -> case evalExpr ast env of
        Left evalErr -> do
          putStrLn ("Runtime error: " ++ evalErr)
          calcLoop env
        Right (result, nextEnv) -> do
          putStrLn ("## " ++ show result)
          calcLoop nextEnv
```
This architecture neatly decouples scanning, parsing, semantic evaluation, and stateful I/O into clean, mathematically testable components.

=== Chapter Exercises

#bexercise(caption: "Pure Arithmetic AST & Evaluator", ref-source: "compil_happy.pdf, Section 3.1–3.2")[
  *Problem:*
  1. Define a pure algebraic data type `AExpr` supporting floating-point literals (`Double`), unary negation, and the binary operators `+`, `-`, `*`, `/`, and `^`.
  2. Implement an evaluator `eval :: AExpr -> Maybe Double` that safely returns `Nothing` when encountering a division by zero.
]

#bexercise(caption: "Environment-Based Evaluation & Variables", ref-source: "compil_happy.pdf, Section 3.4 & Section 5")[
  *Problem:* Extend `AExpr` with variable names `Var String` and assignments `Assign String AExpr`. Formulate an evaluator `evalEnv :: [(String, Double)] -> AExpr -> Either String (Double, [(String, Double)])` that looks up bound variables, rejects unbound identifiers with a descriptive error message, and updates the environment upon assignment.
]

