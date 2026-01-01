// lib.typ - LeetCode Package API
// Public entrypoint for @preview/leetcode package
//
// Exported functions:
// - conf(...) — document configuration with filtering and practice mode
// - problem(id), test(id, fn), answer(id), solve(id, code-block), get-test-cases(id), get-problem-path(id)
// - get-problem-info(id) — returns metadata from problem.toml
// - filter-problems(...), available-problems — filtering utilities
// - linkedlist(arr), binarytree(arr), fill(value, n), display(value)
// - ll-node(list, id), ll-val(list, id), ll-next(list, id), ll-values(list) — linked list helpers
// - unordered-compare(a, b), float-compare(a, b), testcases(...) — testing utilities
//
// Usage examples:
//   // Default mode - show all problems with test results
//   #show: conf.with()
//
//   // Practice mode - manual control, user writes solutions
//   #show: conf.with(practice: true)
//   #problem(1)
//   #let my-solution(...) = { ... }
//   #test(1, my-solution)
//
//   // Filtered mode - show only specific problems
//   #show: conf.with(difficulty: "easy", labels: ("array",))

#import "helpers.typ": *

// ============================================================================
// Global Configuration State
// ============================================================================

// Global state for sharing configuration between conf() and solve()
#let leetcode-config = state("leetcode-config", (
  show-answer: false,
))

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

// Complete workflow: display problem + code + test solution
// Usage:
//   #solve(1, code-block: ```typst
//   let solution(nums, target) = { ... }
//   ```)
//
// Or just view the problem without solving:
//   #solve(1)
//
// Parameters:
// - id: problem ID
// - code-block: user's solution code (optional)
// - show-answer: show reference solution (auto = use global config, true/false = override)
// - extra-cases: additional test cases to add
// - default-cases: if false, only use extra-cases (ignore built-in cases)
//
// Note: Don't use # prefix in code-block (it's eval'd in code mode)
// The main function name must be "solution" when code-block is provided
#let solve(
  id,
  code-block: none,
  show-answer: auto,
  extra-cases: none,
  default-cases: true,
) = {
  // Display problem
  problem(id)

  // Determine whether to show answer (global config or local override)
  context {
    let cfg = leetcode-config.get()
    let should-show-answer = if show-answer == auto {
      cfg.show-answer
    } else {
      show-answer
    }

    if should-show-answer {
      answer(id)
    }
  }

  // If no code block provided, just show the problem (and possibly answer)
  if code-block == none {
    return
  }

  // Display user's solution code
  heading(level: 2, outlined: false, numbering: none)[My Solution \##id]
  {
    show raw: it => block(stroke: 0.8pt + gray, inset: 0.6em, it)
    code-block
  }

  // Execute the code and test
  let solution-fn = eval(code-block.text + "\n" + "solution")
  test(id, solution-fn, extra-cases: extra-cases, default-cases: default-cases)
}

// ============================================================================
// Practice Mode & Filtering API
// ============================================================================

// All available problem IDs in the repository
#let available-problems = (
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

// Filter problems by various criteria
// - ids: specific problem IDs to include (takes precedence if provided)
// - id-range: (start, end) inclusive range
// - difficulty: "easy" | "medium" | "hard"
// - labels: array of labels (matches if problem has ANY of these labels)
// All conditions are combined with AND logic (except labels which use OR internally)
#let filter-problems(
  ids: none,
  id-range: none,
  difficulty: none,
  labels: none,
) = {
  // Start with all available problems or specified IDs
  let result = if ids != none { ids } else { available-problems }

  // Filter by id-range (inclusive)
  if id-range != none {
    let (start, end) = id-range
    result = result.filter(id => id >= start and id <= end)
  }

  // Filter by difficulty
  if difficulty != none {
    result = result.filter(id => {
      let info = get-problem-info(id)
      info.at("difficulty", default: "") == difficulty
    })
  }

  // Filter by labels (OR logic: match if problem has ANY of the specified labels)
  if labels != none and labels.len() > 0 {
    result = result.filter(id => {
      let info = get-problem-info(id)
      let problem-labels = info.at("labels", default: ())
      // Check if any of the filter labels match
      labels.any(label => label in problem-labels)
    })
  }

  result
}

// Document configuration function for practice workbook mode
// Usage: #show: conf.with(ids: (1, 2, 3), difficulty: "medium", practice: true)
//
// Parameters:
// - ids: specific problem IDs to include
// - id-range: (start, end) inclusive range filter
// - difficulty: "easy" | "medium" | "hard" filter
// - labels: array of labels (matches problems with ANY of these labels)
// - practice: if true, don't auto-render problems (user controls via solve())
// - show-answer: if true, show reference solution code after each problem
// - show-title: if true, show the title page
// - show-outline: if true, show table of contents
#let conf(
  ids: none,
  id-range: none,
  difficulty: none,
  labels: none,
  practice: false,
  show-answer: false,
  show-title: true,
  show-outline: true,
  body,
) = {
  // Update global config state (for solve() to read)
  leetcode-config.update(cfg => (
    show-answer: show-answer,
  ))

  // Title page
  if show-title {
    align(center)[
      #v(3fr)
      #box(baseline: 12pt)[#image("images/logo.png", height: 48pt)]
      #h(12pt)
      #text(48pt)[*Leetcode.typ*]
      #v(6fr)
      // Authors
      #if not practice {
        text(
          size: 24pt,
        )[Gabriel Wu (#link("https://github.com/lucifer1004", "@lucifer1004"))]
      }
      #v(1fr)
      // Build date
      #text(size: 20pt)[
        #datetime.today().display("[month repr:long] [day], [year]")
      ]
      #v(2cm)
    ]
    pagebreak()
  }

  // Table of contents
  if show-outline {
    show outline.entry: set block(above: 1.2em)
    outline()
  }

  // Document styling
  counter(page).update(0)
  set smartquote(enabled: false)
  set par(justify: true)
  set page(numbering: "1")
  show link: it => {
    set text(blue)
    underline(it)
  }
  show heading.where(level: 1, outlined: true): it => {
    pagebreak(weak: true)
    it
    v(1.5em)
  }

  // Get filtered problems
  let problems-to-show = filter-problems(
    ids: ids,
    id-range: id-range,
    difficulty: difficulty,
    labels: labels,
  )

  // Render problems based on mode
  if not practice {
    // Normal mode: auto-render all filtered problems with test results
    for problem-id in problems-to-show {
      problem(problem-id)
      if show-answer {
        answer(problem-id)
      }
      test(problem-id, (..args) => none)
    }
  }
  // Practice mode: don't auto-render problems
  // User has full control via problem() and test() in body

  // Include body content (user's solutions, tests, etc.)
  body
}
