// lib.typ - LeetCode Package API
// Public entrypoint for @preview/leetcode package

#import "helpers.typ": (
  chessboard, display, fill, is-chessboard, linkedlist, testcases,
  unordered-compare,
)

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

  import (base + "solution.typ"): solution-ref
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
    }
    render-chess = metadata.at("render-chessboard", default: false)
  }

  testcases(
    solution-fn,
    solution-ref,
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

  // Read solution file and extract code starting from #let solution-ref
  let solution-content = read(path + "solution.typ")
  let lines = solution-content.split("\n")
  let start-line = 0

  for (lineno, line) in lines.enumerate() {
    if line.contains("#let solution-ref") {
      start-line = lineno
      break
    }
  }

  // Extract solution code (skip the last empty line if any)
  let end-line = lines.len()
  let solution-code = lines.slice(start-line, end-line).join("\n").trim()

  heading(level: 2, outlined: false, numbering: none)[Reference Solution \##id]
  raw(solution-code, block: true, lang: "typst")
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
