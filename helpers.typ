#let fill(value, n) = range(n).map(_ => value)

#let is-chessboard(value) = {
  if type(value) != array or value.len() == 0 {
    return false
  }
  if type(value.at(0)) != str {
    return false
  }
  let size = value.len()
  for row in value {
    if type(row) != str or row.len() != size {
      return false
    }
  }
  true
}

#let chessboard(board) = {
  if board.len() == 0 {
    return []
  }
  let width = board.at(0).len()
  let cells = ()
  for r in range(board.len()) {
    let chars = board.at(r).clusters()
    for c in range(width) {
      let ch = chars.at(c)
      let content = if ch == "Q" {
        text(weight: "bold")[Q]
      } else if ch == "." {
        text(fill: gray)[·]
      } else {
        text(weight: "bold")[ch]
      }
      cells.push(content)
    }
  }
  table(
    align: center,
    columns: fill(auto, width),
    ..cells,
  )
}

// Comparators for testcases with special requirements
#let unordered-compare(a, b) = {
  if type(a) != array or type(b) != array {
    return a == b
  }
  if a.len() != b.len() {
    return false
  }
  a.sorted() == b.sorted()
}

#let display(value, render-chessboard: false) = {
  if type(value) == array {
    if render-chessboard and is-chessboard(value) {
      return chessboard(value)
    }
    if render-chessboard and value.len() > 0 and is-chessboard(value.at(0)) {
      return align(center)[#value.map(chessboard).join(v(0.5em))]
    }
    [
      [#value.map(x => display(x)).join(", ")]
    ]
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
      ret.join($->$)
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

#let testcases(
  solution,
  reference,
  inputs,
  comparator: none,
  render-chessboard: false,
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
      stroke: 0.8pt + color,
      inset: 0.6em,
      width: 100%,
    )[
      #heading(level: 2, outlined: false, numbering: none, [
        Case #(idx + 1) 
        #h(1fr)
        #if pass {"✅"} else {"❌"}
      ])
      #v(0.3em)

      #strong("Inputs")
      #v(0.2em)
      #for key in input.keys() {
        strong(key + ": ")
        display(input.at(key), render-chessboard: render-chessboard)
        v(0.3em)
      }

      #line(stroke: 0.8pt + gray, length: 100%)
      #strong("Expected")
      #v(0.2em)
      #display(expected, render-chessboard: render-chessboard)
      #v(0.4em)
      #line(stroke: 0.8pt + gray, length: 100%)
      #strong("Your Output")
      #v(0.2em)
      #display(yours, render-chessboard: render-chessboard)
      #v(0.4em)
    ]

    v(1em)
    idx += 1
  }
}
