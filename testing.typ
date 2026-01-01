// testing.typ - Test framework for running and displaying test cases
// Depends on: display

#import "display.typ": display

#let testcases(
  solution,
  reference,
  inputs,
  comparator: none,
  custom-display: none,
  custom-output-display: none,
) = {
  // Default comparator: direct equality
  let compare = if comparator == none {
    (a, b) => a == b
  } else {
    comparator
  }

  v(2em)
  heading(level: 2, outlined: false, numbering: none, [Test Results])

  let idx = 0
  for input in inputs {
    let expected = reference(..input.values())
    let yours = solution(..input.values())
    let pass = compare(expected, yours)
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
