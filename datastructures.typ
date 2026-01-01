// datastructures.typ - Pure data structure definitions
// No external dependencies - this is a leaf module in the DAG

// Linked list with closure-based accessors
// Closures capture the internal nodes dict, avoiding O(n) parameter copying
//
// Usage:
//   let list = linkedlist((1, 2, 3))
//   let curr = list.head
//   while curr != none {
//     let val = (list.get-val)(curr)
//     curr = (list.get-next)(curr)
//   }
//   let all-vals = (list.values)()
//
#let linkedlist(arr) = {
  if arr.len() == 0 {
    return (
      type: "linkedlist",
      head: none,
      get-val: id => none,
      get-next: id => none,
      get-node: id => none,
      values: () => (),
      len: () => 0,
      nodes: (:),
    )
  }

  let nodes = (:)
  for (i, val) in arr.enumerate() {
    let id = str(i)
    let next = if i + 1 < arr.len() { str(i + 1) } else { none }
    nodes.insert(id, (val: val, next: next))
  }

  (
    type: "linkedlist",
    head: "0",
    // Closure accessors - O(1) without copying the whole structure
    get-val: id => if id == none { none } else { nodes.at(id).val },
    get-next: id => if id == none { none } else { nodes.at(id).next },
    get-node: id => if id == none { none } else { nodes.at(id) },
    values: () => nodes.values().map(n => n.val),
    len: () => nodes.len(),
    // Keep nodes for visualization (read-only)
    nodes: nodes,
  )
}

// Binary tree from level-order array
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
