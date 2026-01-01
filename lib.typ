// lib.typ - LeetCode Package API
// Public entrypoint for @preview/leetcode package
//
// Exported functions:
// - problem(id), test(id, fn), answer(id), solve(id, code-block), get-test-cases(id), get-problem-path(id)
// - get-problem-info(id) — returns metadata from problem.toml
// - linkedlist(arr), binarytree(arr), fill(value, n), display(value)
// - ll-node(list, id), ll-val(list, id), ll-next(list, id), ll-values(list) — linked list helpers
// - unordered-compare(a, b), float-compare(a, b), testcases(...) — testing utilities

#import "helpers.typ": *

// Comparator dispatch table - add new comparators here
#let comparators = (
  "unordered-compare": unordered-compare,
  "float-compare": float-compare,
)

// Helper to format problem ID
#let format-id(id) = {
  let id-str = str(id)
  while id-str.len() < 4 {
    id-str = "0" + id-str
  }
  id-str
}

// Get problem metadata from problem.toml
#let get-problem-info(id) = {
  let id-str = format-id(id)
  let path = "problems/" + id-str + "/problem.toml"
  toml(path)
}

// Badge styling constants
#let badge-inset = (x: 6pt, y: 3pt)
#let badge-radius = 3pt
#let badge-font-size = 9pt
#let badge-stroke-width = 0.5pt

// Difficulty badge colors
#let difficulty-colors = (
  easy: rgb("#00b8a3"),
  medium: rgb("#ffc01e"),
  hard: rgb("#ff375f"),
)

// Create a difficulty badge
#let difficulty-badge(level) = {
  let color = difficulty-colors.at(level, default: gray)
  box(
    fill: color.lighten(80%),
    stroke: badge-stroke-width + color,
    inset: badge-inset,
    radius: badge-radius,
  )[
    #text(fill: color.darken(20%), weight: "semibold", size: badge-font-size)[
      #upper(level)
    ]
  ]
}

// Create a label badge
#let label-badge(label) = {
  box(
    fill: gray.lighten(90%),
    stroke: badge-stroke-width + gray.lighten(50%),
    inset: badge-inset,
    radius: badge-radius,
  )[
    #text(fill: gray.darken(40%), size: badge-font-size)[#upper(label)]
  ]
}

// Render problem description by ID with difficulty badge and labels
#let problem(id, show-badge: true, show-labels: true) = {
  let id-str = format-id(id)
  let info = toml("problems/" + id-str + "/problem.toml")

  // First include the description
  {
    show heading.where(level: 1): it => {
      it
      if show-badge and "difficulty" in info {
        difficulty-badge(info.difficulty)
        h(0.3em)
      }
      if show-labels and "labels" in info {
        for label in info.labels {
          label-badge(label)
          h(0.3em)
        }
        linebreak()
      }
    }
    include ("problems/" + id-str + "/description.typ")
  }
}

// Get test cases for a problem
#let get-test-cases(id) = {
  let id-str = format-id(id)
  let path = "problems/" + id-str + "/testcases.typ"
  import path: cases
  cases
}

// Load metadata from problem.toml
// Returns (comparator, render-chessboard) tuple
#let load-metadata(id-str, default-comp, default-render) = {
  let info = toml("problems/" + id-str + "/problem.toml")

  // Resolve comparator from dispatch table
  let comp = default-comp
  if "comparator" in info {
    let comp-name = info.at("comparator")
    if comp-name in comparators {
      comp = comparators.at(comp-name)
    }
  }

  let render-chess = info.at("render-chessboard", default: default-render)
  (comp, render-chess)
}

// Automatic test with built-in test cases and metadata
#let test(
  id,
  solution-fn,
  extra-cases: none,
  comparator: none,
  render-chessboard: false,
  default-cases: true,
) = {
  let id-str = format-id(id)
  let base = "problems/" + id-str + "/"

  import (base + "solution.typ"): solution
  import (base + "testcases.typ"): cases

  let cases = if default-cases {
    if type(extra-cases) == array {
      (..cases, ..extra-cases)
    } else if type(extra-cases) == dictionary {
      (..cases, extra-cases)
    } else {
      cases
    }
  } else {
    extra-cases
  }

  // Load metadata from problem.toml
  let (comp, render-chess) = load-metadata(
    id-str,
    comparator,
    render-chessboard,
  )

  testcases(
    solution-fn,
    solution,
    cases,
    comparator: comp,
    render-chessboard: render-chess,
  )
}

// Return problem directory path (for advanced users)
#let get-problem-path(id) = {
  let id-str = format-id(id)
  "problems/" + id-str + "/"
}

// Display reference solution code (for learning)
#let answer(id) = {
  let id-str = format-id(id)
  let path = "problems/" + id-str + "/"

  // Read solution file and extract code
  let solution-content = read(path + "solution.typ")
    .replace("#import \"../../helpers.typ\": *\n", "")
    .trim()

  heading(level: 2, outlined: false, numbering: none)[Reference Solution \##id]
  raw(solution-content, block: true, lang: "typst")
}

// Complete workflow: display code + test solution
// Usage: pass a raw block with function definition ending with the function name
// The main function name must be "solution"
#let solve(id, code-block) = {
  // Display problem
  problem(id)

  // Display user's solution code
  heading(level: 2, outlined: false, numbering: none)[My Solution \##id]
  show raw: it => block(stroke: 0.8pt + gray, inset: 0.6em, it)
  code-block

  // Execute the code and test
  let solution-fn = eval(code-block.text + "\n" + "solution")
  test(id, solution-fn)
}
