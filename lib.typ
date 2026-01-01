// lib.typ - LeetCode Package API
// Public entrypoint for @preview/leetcode package
//
// Exported functions:
// - problem(id), test(id, fn), answer(id), solve(id, code-block), get-test-cases(id), get-problem-path(id)
// - linkedlist(arr), binarytree(arr), fill(value, n), display(value)
// - ll-node(list, id), ll-val(list, id), ll-next(list, id), ll-values(list) — linked list helpers
// - unordered-compare(a, b), float-compare(a, b), testcases(...) — testing utilities

#import "helpers.typ": *

// Helper to format problem ID
#let format-id(id) = {
  let id-str = str(id)
  while id-str.len() < 4 {
    id-str = "0" + id-str
  }
  id-str
}

// Render problem description by ID
#let problem(id) = {
  let id-str = format-id(id)
  let path = "problems/" + id-str + "/description.typ"
  include path
}

// Get test cases for a problem
#let get-test-cases(id) = {
  let id-str = format-id(id)
  let path = "problems/" + id-str + "/testcases.typ"
  import path: cases
  cases
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

  // Check if metadata exists by reading the file
  let comp = comparator
  let render-chess = render-chessboard

  let testcases-content = read(base + "testcases.typ")
  if testcases-content.contains("#let metadata") {
    import (base + "testcases.typ"): metadata

    // Resolve comparator
    if "comparator" in metadata {
      let comp-name = metadata.at("comparator")
      if comp-name == "unordered-compare" {
        comp = unordered-compare
      }
      if comp-name == "float-compare" {
        comp = float-compare
      }
    }
    render-chess = metadata.at("render-chessboard", default: false)
  }

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
