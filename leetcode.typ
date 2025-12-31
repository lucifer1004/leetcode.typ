#import "lib.typ": problem, test
#import "helpers.typ": testcases

#align(center)[
  #v(3fr)
  #box(baseline: 12pt)[#image("images/logo.png", height: 48pt)]
  #h(12pt)
  #text(48pt)[*Leetcode.typ*]
  #v(6fr)
  // Authors
  #text(
    size: 24pt,
  )[Gabriel Wu (#link("https://github.com/lucifer1004", "@lucifer1004"))]
  #v(1fr)
  // Build date
  #text(size: 20pt)[
    #datetime.today().display("[month repr:long] [day], [year]")
  ]
  #v(2cm)
]
#pagebreak()

#show outline.entry: set block(above: 1.2em)
#outline()

#counter(page).update(0)
#set smartquote(enabled: false)
#set par(justify: true)
#set page(numbering: "1")

#show heading.where(level: 1, outlined: true): it => {
  pagebreak(weak: true)
  it
  v(1.5em)
}

#let available-problems = (
  1,
  2,
  3,
  4,
  5,
  6,
  7,
  8,
  9,
  10,
  11,
  12,
  13,
  14,
  15,
  16,
  17,
  18,
  19,
  20,
  21,
  22,
  23,
  24,
  25,
  26,
  42,
  51,
  94,
  110,
  144,
  145,
)

// Display all problems
#for problem-id in available-problems {
  problem(problem-id)
  // Test with placeholder (to show built-in test results)
  test(problem-id, (..args) => none)
}
