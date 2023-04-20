#let zip(..lists) = {
  let lists = lists.pos()
  if lists == () {
    ()
  } else {
    let ret = ()
    let len = lists.fold(
      lists.first().len(), 
      (a, b) => if a > b.len() { b.len() } else { a }
    )

    for i in range(0, len) {
      let curr = ()
      for list in lists {
        curr.push(list.at(i))
      }
      ret.push(curr)
    }

    ret
  }
}

#let flatten(list) = {
  let ret = ()
  for item in list {
    if type(item) == "array" {
      for sub in flatten(item) {
        ret.push(sub)
      }
    } else {
      ret.push(item)
    }
  }
  ret
}

#let fill(value, n) = {
  let ret = ()
  for i in range(n) {
    ret.push(value)
  }
  ret
}

#let display(value) = {
  if type(value) == "array" {
    // display arrays
    [[#value.map(display).join(", ")]]
  } else if type(value) == "dictionary" and value.type == "linkedlist" {
    // display linked lists
    let ret = ()
    let now = value
    while now.next != none {
      ret.push(display(now.val))
      now = now.next
    }
    [#ret.join(" -> ")]
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
  for key in inputs.first().keys() {
    cells.push(strong(key))
  }
  cells.push([*answer*])
  cells.push([*yours*])
  for input in inputs {
    for key in input.keys() {
      cells.push(display(input.at(key)))
    }
    cells.push(display(reference(..input.values())))
    cells.push(display(solution(..input.values())))
  }

  v(2em)
  heading(level: 2, outlined: false, numbering: none, [Test Cases])
  table(
    align: center,
    columns: fill(1fr, inputs.first().len() + 2),
    ..cells,
  )
}
