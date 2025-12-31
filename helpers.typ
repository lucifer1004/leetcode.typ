#import "visualize.typ": visualize-binarytree, visualize-linkedlist

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
      return align(center)[#value.map(chessboard).join(line(length: 80%))]
    }
    if value.len() == 0 {
      return [[]]
    }
    if value.len() > 210 {
      let start = value.slice(0, 100)
      let end = value.slice(-100)
      let omitted = value.len() - 200
      return [[#start.map(x => display(x)).join(", "), $...$ #omitted items omitted $...$, #end.map(x => display(x)).join(", ")]]
    }
    [[#value.map(x => display(x)).join(", ")]]
  } else if (
    type(value) == dictionary
      and value.at("type", default: none) == "linkedlist"
  ) {
    let ret = ()
    let now = value
    while now.next != none {
      ret.push(now.val)
      now = now.next
    }

    // Only visualize linkedlist if it's small
    if ret.len() <= 8 {
      return visualize-linkedlist(value)
    }
    ret.map(display).join($->$)
  } else if (
    type(value) == dictionary
      and value.at("type", default: none) == "binarytree"
  ) {
    return visualize-binarytree(value, show-nulls: false)
  } else if type(value) == str {
    if value.len() > 1050 {
      let start = value.slice(0, 500)
      let end = value.slice(-500)
      let omitted = value.len() - 1000
      return display(
        start + " [..." + str(omitted) + " characters omitted ...] " + end,
      )
    }
    "\"" + value.codepoints().join(sym.zws) + "\""
  } else {
    repr(value)
  }
}

// The implementation is not efficient since we can only do clones
#let linkedlist(arr) = {
  let now = (val: none, next: none, type: "linkedlist")
  for val in arr.rev() {
    now = (val: val, next: now, type: "linkedlist")
  }
  now
}

#let binarytree(arr) = {
  let n = arr.len()
  if n == 0 or arr.at(0) == none {
    return (val: none, left: none, right: none, type: "binarytree")
  }

  // left/right child index arrays, length n, init to none
  let left = ()
  let right = ()
  for _ in range(n) {
    left.push(none)
    right.push(none)
  }

  // queue of indices (implemented by array + head pointer)
  let q = (0,)
  let qh = 0
  let pos = 1

  while qh < q.len() and pos < n {
    let parent = q.at(qh)
    qh += 1

    // left child
    if pos < n {
      if arr.at(pos) != none {
        left.at(parent) = pos
        q.push(pos)
      }
      pos += 1
    }

    // right child
    if pos < n {
      if arr.at(pos) != none {
        right.at(parent) = pos
        q.push(pos)
      }
      pos += 1
    }
  }

  // expand indices into nested dicts
  let dfs(i) = (
    val: arr.at(i),
    left: if left.at(i) == none { none } else { dfs(left.at(i)) },
    right: if right.at(i) == none { none } else { dfs(right.at(i)) },
    type: "binarytree",
  )

  dfs(0)
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
      inset: 0.6em,
      width: 100%,
    )[
      #heading(level: 2, outlined: false, numbering: none, [Case #(idx + 1)])

      #for key in input.keys() {
        strong(key + ": ")
        display(input.at(key), render-chessboard: render-chessboard)
        linebreak()
      }

      #table(
        columns: (1fr, 1fr),
        column-gutter: 1em,
        stroke: 0.8pt + gray,
        inset: 0.6em,
        strong("Expected"),
        table.cell(stroke: color)[#strong("Your Output")],
        display(expected, render-chessboard: render-chessboard),
        table.cell(stroke: color)[#display(
          yours,
          render-chessboard: render-chessboard,
        )],
      )
    ]
    idx += 1
  }
}
