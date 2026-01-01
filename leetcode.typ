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

// Discover problems dynamically by scanning the problems directory
// Each problem directory has a problem.toml file
#let discover-problems() = {
  // Read all problem.toml files and extract problem IDs
  let problem-dirs = (
    "0001",
    "0002",
    "0003",
    "0004",
    "0005",
    "0006",
    "0007",
    "0008",
    "0009",
    "0010",
    "0011",
    "0012",
    "0013",
    "0014",
    "0015",
    "0016",
    "0017",
    "0018",
    "0019",
    "0020",
    "0021",
    "0022",
    "0023",
    "0024",
    "0025",
    "0026",
    "0042",
    "0050",
    "0051",
    "0094",
    "0110",
    "0112",
    "0113",
    "0144",
    "0145",
    "0200",
    "0289",
    "0814",
  )
  problem-dirs.map(d => int(d))
}

#let available-problems = discover-problems()

// Display all problems
#for problem-id in available-problems {
  problem(problem-id)
  // Test with placeholder (to show built-in test results)
  test(problem-id, (..args) => none)
}
