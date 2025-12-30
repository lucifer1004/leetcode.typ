#let fill(value, n) = range(n).map(_ => value)

#let display(value) = {
  if type(value) == array {
    [[#value.map(display).join(", ")]]
  } else if type(value) == dictionary and value.type == "linkedlist" {
    let ret = ()
    let now = value
    while now.next != none {
      ret.push(display(now.val))
      now = now.next
    }
    if ret.len() == 0 {
      $emptyset$
    } else {
      ret.join(" -> ")
    }
  } else {
    repr(value)
  }
}

// The implementation is not efficient since we can only do clones
#let linkedlist(arr) = {
  let now = (val: none, next: none, type: "linkedlist")
  for i in range(arr.len()) {
    now = (val: arr.at(arr.len() - 1 - i), next: now, type: "linkedlist")
  }
  now
}

#let testcases(solution, reference, inputs) = {
  let cells = ()

  // Header
  for key in inputs.first().keys() {
    cells.push(strong(key))
  }
  cells.push([*Expected*])
  cells.push([*Your Output*])
  cells.push([*Status*])

  // Test cases
  for input in inputs {
    for key in input.keys() {
      cells.push(display(input.at(key)))
    }

    let expected = reference(..input.values())
    let yours = solution(..input.values())

    cells.push(display(expected))
    cells.push(display(yours))

    // Status indicator
    if expected == yours {
      cells.push(text(fill: green)[✓ Pass])
    } else {
      cells.push(text(fill: red)[✗ Fail])
    }
  }

  v(2em)
  heading(level: 2, outlined: false, numbering: none, [Test Results])
  table(
    align: center,
    columns: fill(1fr, inputs.first().len() + 3), // +3 for expected, yours, status
    ..cells,
  )
}
