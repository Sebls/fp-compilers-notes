// Mathematical & Operational environments in latexy-book style
#let def-counter = counter("def-counter")
#let thm-counter = counter("thm-counter")

#let bdefinition(caption: "", body) = block(
  above: 1.4em,
  below: 1.4em,
  breakable: true,
)[
  #def-counter.step()
  #text(weight: "bold")[Definition #context def-counter.display()]#if caption != "" [ #text(weight: "bold")[(#caption).] ] else [ #text(weight: "bold")[.] ]
  #text(style: "italic")[#body]
]

#let btheorem(caption: "", body) = block(
  above: 1.4em,
  below: 1.4em,
  breakable: true,
)[
  #thm-counter.step()
  #text(weight: "bold")[Theorem #context thm-counter.display()]#if caption != "" [ #text(weight: "bold")[(#caption).] ] else [ #text(weight: "bold")[.] ]
  #text(style: "italic")[#body]
]

#let blemma(caption: "", body) = block(
  above: 1.4em,
  below: 1.4em,
  breakable: true,
)[
  #thm-counter.step()
  #text(weight: "bold")[Lemma #context thm-counter.display()]#if caption != "" [ #text(weight: "bold")[(#caption).] ] else [ #text(weight: "bold")[.] ]
  #text(style: "italic")[#body]
]

#let bproposition(caption: "", body) = block(
  above: 1.4em,
  below: 1.4em,
  breakable: true,
)[
  #thm-counter.step()
  #text(weight: "bold")[Proposition #context thm-counter.display()]#if caption != "" [ #text(weight: "bold")[(#caption).] ] else [ #text(weight: "bold")[.] ]
  #text(style: "italic")[#body]
]

#let bexample(caption: "", body) = block(
  above: 1.4em,
  below: 1.4em,
  breakable: true,
)[
  #text(weight: "bold")[Example.]#if caption != "" [ #text(weight: "bold")[(#caption).] ]
  #body
]

#let bnotice(caption: "", body) = block(
  above: 1.4em,
  below: 1.4em,
  breakable: true,
)[
  #text(weight: "bold")[Remark.]#if caption != "" [ #text(weight: "bold")[(#caption).] ]
  #body
]

#let ex-counter = counter("ex-counter")

#let bexercise(caption: "", ref-source: "", body) = block(
  above: 1.4em,
  below: 1.4em,
  breakable: true,
  stroke: (left: 2pt + rgb("#6366f1")),
  inset: (left: 10pt, y: 4pt),
)[
  #ex-counter.step()
  #text(weight: "bold", fill: rgb("#4338ca"))[Exercise #context ex-counter.display()]#if caption != "" [ #text(weight: "bold")[(#caption).] ] else [ #text(weight: "bold")[.] ]
  #if ref-source != "" [
    #text(size: 8pt, fill: rgb("#6b7280"), style: "italic")[[Ref: #ref-source]] \
  ]
  #body
]

