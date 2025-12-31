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
#outline()
#counter(page).update(0)
#set smartquote(enabled: false)
#set par(justify: true)
#set page(numbering: "1")
#set heading(numbering: (..nums) => {
  let chars = str(nums.pos().at(0)).clusters().rev()
  while chars.len() < 4 {
    chars.push("0")
  }
  chars.rev().join() + "."
})
#show heading: it => {
  if it.level == 1 {
    pagebreak(weak: true)
  }
  it
  v(1em)
}
#let solution-placeholder(..args) = {
  none
}
// Helper function to display a problem with its reference solution
#let show-problem(id) = {
  // Show problem description
  problem(id)
  // Test with placeholder (to show built-in test results)
  test(id, solution-placeholder)
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
  51,
)
// Display all problems
#for problem in available-problems {
  show-problem(problem)
}
