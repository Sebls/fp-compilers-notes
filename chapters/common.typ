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
