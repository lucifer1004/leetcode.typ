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

// Default validator - direct equality
#let default-validator = (input, expected, yours) => expected == yours

// Built-in validators dispatch table
// All validators have signature: (input, expected, yours) => bool
#let validators = (
  "default": default-validator,
  "unordered-compare": (input, expected, yours) => unordered-compare(
    expected,
    yours,
  ),
  "float-compare": (input, expected, yours) => float-compare(expected, yours),
  // "custom" is a special value - loads from validator.typ
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

// Load validator from problem.toml
// Returns validator function with signature (input, expected, yours) => bool
#let load-validator(id-str, base) = {
  let info = toml("problems/" + id-str + "/problem.toml")

  // Check for custom validator file first
  if info.at("validator", default: none) == "custom" {
    import (base + "validator.typ"): validator
    return validator
  }

  // Check for named validator in dispatch table
  if "validator" in info {
    let val-name = info.at("validator")
    if val-name in validators {
      return validators.at(val-name)
    }
  }

  // Default validator
  default-validator
}

// Automatic test with built-in test cases and metadata
#let test(
  id,
  solution-fn,
  extra-cases: none,
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
  let info = toml(base + "problem.toml")

  // Load validator (handles both named and custom validators)
  let val = load-validator(id-str, base)

  // Try to load custom-display from display.typ if flag is set
  let custom-disp = none
  if info.at("custom-display", default: false) {
    import (base + "display.typ"): custom-display
    custom-disp = custom-display
  }

  // Try to load custom-output-display from display.typ if flag is set
  let custom-output-disp = none
  if info.at("custom-output-display", default: false) {
    import (base + "display.typ"): custom-output-display
    custom-output-disp = custom-output-display
  }

  testcases(
    solution-fn,
    solution,
    cases,
    validator: val,
    custom-display: custom-disp,
    custom-output-display: custom-output-disp,
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
