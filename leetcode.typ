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
#show link: it => {
  set text(blue)
  underline(it)
}
#show heading.where(level: 1, outlined: true): it => {
  pagebreak(weak: true)
  it
  v(1.5em)
}

// All available problem IDs
// Use range() for consecutive problems, individual IDs for sparse ones
#let discover-problems() = {
  (
    ..range(1, 27), // 1-26
    33,
    35,
    39,
    42,
    46,
    ..range(48, 52), // 48-51
    ..range(53, 57), // 53-56
    62,
    69,
    70,
    72,
    76,
    78,
    94,
    101,
    104,
    110,
    ..range(112, 114), // 112-113
    116,
    121,
    144,
    145,
    155,
    200,
    ..range(206, 208), // 206-207
    ..range(209, 211), // 209-210
    289,
    347,
    547,
    785,
    814,
    997,
  )
}

#let available-problems = discover-problems()

// Display all problems
#for problem-id in available-problems {
  problem(problem-id)
  // Test with placeholder (to show built-in test results)
  test(problem-id, (..args) => none)
}
