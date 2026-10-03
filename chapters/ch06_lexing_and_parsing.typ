#import "common.typ": bdefinition, btheorem, blemma, bproposition, bexample, bnotice, bexercise

== Lexical & Syntactic Analysis: Alex & Happy in Practice

In the Haskell ecosystem, lexical analyzers and syntactic parsers are generated automatically from declarative domain-specific specifications using *Alex* (the Haskell analog of Lex/Flex) and *Happy* (the Haskell analog of Yacc/Bison).

=== Structure of an Alex Lexer Specification (`.x`)

An Alex specification file contains three primary sections:
1. *Top Haskell Block (`{ ... }`):* Module header declaring exports (typically `Token(..)` and `alexScanTokens`) and necessary imports.
2. *Alex Configuration & Rules:*
   - Wrappers: `%wrapper "basic"` (simple string-to-token scanner) or `%wrapper "posn"` (tracks byte/character line and column positions via `AlexPn`).
   - Macro definitions for character sets: `$digit = [0-9]`, `$alpha = [a-zA-Z]`.
   - Token rules declared under `tokens :-`:
     `<state> regexp { \s -> TokenValue }`
3. *Bottom Haskell Block (`{ ... }`):* Definition of the `Token` algebraic data type, helper conversion functions, and error formatters.

#bexample(caption: "Alex Scanner with Source Position Tracking")[
```haskell
{
module CalcLexer (Token(..), TokenVal(..), scanTokens) where
}

%wrapper "posn"

$digit = 0-9
$alpha = [a-zA-Z]

tokens :-
  $white+                     ; -- Discard whitespace
  ";"                         { \p _ -> TK p TK_SEMI }
  "+"                         { \p _ -> TK p TK_PLUS }
  "-"                         { \p _ -> TK p TK_MINUS }
  "*"                         { \p _ -> TK p TK_MUL }
  "/"                         { \p _ -> TK p TK_DIV }
  "("                         { \p _ -> TK p TK_LPAREN }
  ")"                         { \p _ -> TK p TK_RPAREN }
  "="                         { \p _ -> TK p TK_ASSIGN }
  $digit+(\.$digit+)?([eE][\+\-]?$digit+)? { \p s -> TK p (TK_DOUBLE (read s)) }
  $alpha[$alpha $digit]*      { \p s -> TK p (TK_IDENT s) }

{
data TokenVal
  = TK_SEMI | TK_PLUS | TK_MINUS | TK_MUL | TK_DIV
  | TK_LPAREN | TK_RPAREN | TK_ASSIGN
  | TK_DOUBLE Double
  | TK_IDENT String
  deriving (Eq, Show)

data Token = TK AlexPosn TokenVal deriving (Eq, Show)

scanTokens :: String -> [Token]
scanTokens = alexScanTokens
}
```
]

=== Structure of a Happy Parser Specification (`.y`)

A Happy grammar specification consists of:
1. *Configuration Directives:*
   - `%name <function_name>`: Name of the generated parsing function (e.g., `parseCalc`).
   - `%tokentype { <Haskell_Token_Type> }`: Type of incoming tokens.
   - `%error { <error_handler> }`: Function called upon syntactic failure (`parseError :: [Token] -> a`).
2. *Token Declarations (`%token`):*
   Maps internal terminal names used in the grammar to constructor patterns over `Token`.
3. *Precedence & Associativity Directives:*
   - `%left '+' '-'`: Left-associative additive operators.
   - `%left '*' '/'`: Higher precedence multiplicative operators.
   - `%right '^'`: Right-associative exponentiation.
4. *Grammar Rules (`%%`):*
   Non-terminal production rules annotated with semantic action blocks in `{ ... }`.
   Within actions, `$1, $2, dots, $n` refer to the synthesized attributes of the $n$ symbols on the right-hand side.

#bexample(caption: "Happy Grammar with Operator Precedence and AST Construction")[
```haskell
{
module CalcParser (parseExpr) where
import CalcLexer
import ArithAST
}

%name parseExpr
%tokentype { Token }
%error { parseError }

%token
  double    { TK _ (TK_DOUBLE $$) }
  ident     { TK _ (TK_IDENT $$) }
  '+'       { TK _ TK_PLUS }
  '-'       { TK _ TK_MINUS }
  '*'       { TK _ TK_MUL }
  '/'       { TK _ TK_DIV }
  '('       { TK _ TK_LPAREN }
  ')'       { TK _ TK_RPAREN }

%left '+' '-'
%left '*' '/'
%left NEG

%%

Expr : Expr '+' Expr         { BinOp Add $1 $3 }
     | Expr '-' Expr         { BinOp Sub $1 $3 }
     | Expr '*' Expr         { BinOp Mul $1 $3 }
     | Expr '/' Expr         { BinOp Div $1 $3 }
     | '-' Expr %prec NEG    { UnOp Neg $2 }
     | '(' Expr ')'          { $2 }
     | double                { LitDouble $1 }
     | ident                 { VarRef $1 }

{
parseError :: [Token] -> a
parseError [] = error "Parse error: Unexpected end of input"
parseError (TK (AlexPn _ line col) val : _) =
  error $ "Syntax error at line " ++ show line ++ ", column " ++ show col ++ " on token " ++ show val
}
```
]

=== Lexical and Syntactic Modernization: Parser Combinators (Parsec)

While Alex and Happy remain standard tools for deterministic LALR(1) grammars, modern compiler engineering frequently leverages monadic *parser combinators* such as Haskell's `Parsec` or `Megaparsec`.
- *Advantage:* Grammars are written directly in native Haskell code without an external preprocessor phase.
- *Typing:* Parsing actions are typed statically by GHC immediately, eliminating obscure post-code-generation type errors.
- *Error Diagnostics:* Combinator parsers retain full monadic context, enabling highly descriptive error reports with expected symbol sets.

=== Chapter Exercises

#bexercise(caption: "Parenthesized Expression Parsing & Max Depth", ref-source: "compil_happy.pdf, Section 4.5 (paren-01, paren-02)")[
  *Problem:*
  1. Write a Happy grammar over tokens `'('` and `')'` that parses well-parenthesized expressions and returns the maximum nesting depth directly as an integer.
  2. Explain how source position tracking via Alex's `%wrapper "posn"` enables accurate error diagnostics.
]

#bexercise(caption: "Lexical Identifiers in Context-Free Grammars", ref-source: "compil_happy.pdf, Section 4.5 (paren-04, paren-05)")[
  *Problem:* In `paren-04`, the Happy grammar allows identifier tokens only at leaf positions:
  ```haskell
  Expr : {- empty -}             { Empty }
       | ident                   { Leaf $1 }
       | '(' Expr ')' Expr       { Node $2 $4 }
  ```
  1. Where are identifiers forbidden by this grammar? Give an example of an invalid string.
  2. How can the grammar be refactored to allow arbitrary sequences of identifiers and parenthesized groups?
]

