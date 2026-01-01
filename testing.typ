// testing.typ - Test framework for running and displaying test cases
// Depends on: display
//
// Testcase format:
//   (
//     input: (param1: value1, param2: value2),  // Function parameters
//     explanation: [Optional Typst content],     // Optional explanation
//   )
//
// Validation modes:
//   1. comparator(expected, yours) => bool  - Compare two outputs
//   2. validator(input, expected, yours) => bool  - Validate output against input

#import "display.typ": display

#let testcases(
  solution,
  reference,
  cases,
  comparator: none,
  custom-validator: none, // New: validator(input, expected, yours) => bool
  custom-display: none,
  custom-output-display: none,
) = {
  // Determine validation function
  // Priority: custom-validator > comparator > default equality
  let validate = if custom-validator != none {
    // Validator takes (input, expected, yours)
    custom-validator
  } else if comparator != none {
    // Wrap comparator to match validator signature
    (input, expected, yours) => comparator(expected, yours)
  } else {
    // Default: direct equality
    (input, expected, yours) => expected == yours
  }

  v(2em)
  heading(level: 2, outlined: false, numbering: none, [Test Results])

  let idx = 0
  for case in cases {
    // Extract input from case (new format uses .input, supports both)
    let input = if "input" in case { case.input } else { case }

    let expected = reference(..input.values())
    let yours = solution(..input.values())
    let pass = validate(input, expected, yours)
    let color = if pass { green } else { red }

    block(
      breakable: false,
      inset: 0.6em,
      width: 100%,
    )[
      #heading(level: 2, outlined: false, numbering: none, [Case #(idx + 1)])

      // Display input using custom-display if provided, otherwise default per-key
      #if custom-display != none {
        custom-display(input)
      } else {
        for key in input.keys() {
          strong(key + ": ")
          display(input.at(key))
          linebreak()
        }
      }

      // Display explanation if present
      #if "explanation" in case and case.explanation != none {
        block(
          inset: (left: 0.5em, top: 0.3em, bottom: 0.3em),
          stroke: (left: 2pt + gray.lighten(50%)),
        )[
          #text(size: 0.9em, fill: gray.darken(20%))[#case.explanation]
        ]
      }

      // Display output using custom-output-display if provided, otherwise default
      #let render-output = if custom-output-display != none {
        custom-output-display
      } else {
        display
      }

      #table(
        columns: (1fr, 1fr),
        column-gutter: 1em,
        stroke: 0.8pt + gray,
        inset: 0.6em,
        strong("Expected"),
        table.cell(stroke: color)[#strong("Your Output")],
        render-output(expected),
        table.cell(stroke: color)[#render-output(yours)],
      )
    ]
    idx += 1
  }
}
