#import "@preview/latexy-book:0.0.1": (
  appendix, backmatter, book, code, corollary, definition, example, exercise, frontmatter, lemma, mainmatter, notice,
  proposition, theorem,
)

// Document metadata and latexy-book initial setup
#show: book.with(
  title: "Principles of Functional Programming & Compiler Construction",
  subtitle: "From Lambda Calculus and Monadic Semantics to Stack Virtual Machines and Native Code",
  author: "",
  date: datetime.today().display("[month repr:long] [day], [year]"),
  titlepage: true,
)

// =============================================================================
// TYPOGRAPHY & VISUAL AESTHETICS (Exact Monograph LaTeX Style)
// =============================================================================

// Page layout: Standard US-Letter
#set page(
  paper: "us-letter",
  margin: (top: 1in, bottom: 1in, inside: 1.25in, outside: 1in),
  header: context {
    let page-num = counter(page).get().first()
    if page-num > 2 [
      #set text(font: "New Computer Modern", size: 8.5pt)
      #grid(
        columns: (1fr, auto),
        text(style: "italic")[Principles of Functional Programming & Compiler Construction], str(page-num),
      )
      #v(-0.4em)
      #line(length: 100%, stroke: 0.4pt + luma(130))
    ]
  },
  footer: none,
)

// Font setup: Knuth's Computer Modern Roman & Math
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

// Enhanced code presentation: distinct container, left accent border, and language badge
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


// Heading hierarchy: Unboxed, clean LaTeX amsbook chapter and section styling
#show heading.where(level: 1): it => block(above: 2.5em, below: 1.6em)[
  #text(weight: "bold", size: 1.7em)[#it.body]
]
#show heading.where(level: 2): it => block(above: 2.0em, below: 1.2em)[
  #text(weight: "bold", size: 1.3em)[#it.body]
]
#show heading.where(level: 3): it => block(above: 1.5em, below: 0.9em)[
  #text(weight: "bold", size: 1.08em)[#it.body]
]

// ==========================================
// FRONT MATTER
// ==========================================
#frontmatter()

= Foreword
This monograph provides a rigorous, self-contained mathematical and computational treatment of modern functional programming and compiler design. Grounded in Alonzo Church's $lambda$-calculus, Robin Milner's type theory, and modern compiler architecture, these notes synthesizes some of the content presented during my computer science master's option in 2025-2026.

Starting with the algebraic foundations of pure computation, pattern matching, laziness, and monadic category theory, the text transitions directly into practical compiler engineering: lexical scanning with Alex, LALR(1) parsing with Happy, intermediate representation design, stack machine architecture, symbolic assembly emission, and lowering to native x86-64 machine instructions.

#outline(indent: auto)

// ==========================================
// MAIN MATTER
// ==========================================
#mainmatter()

#set page(
  paper: "us-letter",
  margin: (top: 1in, bottom: 1in, inside: 1.25in, outside: 1in),
)

= Part I: Foundations of Functional Programming
#include "chapters/ch01_fp_foundations.typ"
#include "chapters/ch02_types_and_adts.typ"
#include "chapters/ch03_laziness_and_evaluation.typ"
#include "chapters/ch04_monads_and_io.typ"

= Part II: Front-End Architecture & Syntax Analysis
#include "chapters/ch05_compiler_architecture.typ"
#include "chapters/ch06_lexing_and_parsing.typ"
#include "chapters/ch07_ast_and_evaluation.typ"

= Part III: Back-End Construction & Code Generation
#include "chapters/ch08_stack_machine_architecture.typ"
#include "chapters/ch09_code_generation.typ"
#include "chapters/ch10_functions_and_activation_records.typ"
#include "chapters/ch11_advanced_topics_and_opt.typ"

// ==========================================
// APPENDIX
// ==========================================
#appendix()

= Course Laboratories, Milestones & Practical Exercises
#include "chapters/ch12_exercises_and_labs.typ"

// ==========================================
// BACK MATTER
// ==========================================
#backmatter()


#bibliography("refs.bib", full: true)
