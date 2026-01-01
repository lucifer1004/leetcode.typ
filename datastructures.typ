// datastructures.typ - Pure data structure definitions
// No external dependencies - this is a leaf module in the DAG

// Flat linked list structure with string ID pointers
// This avoids O(n) deep copies on every .next access
#let linkedlist(arr) = {
  if arr.len() == 0 {
    return (type: "linkedlist", head: none, nodes: (:))
  }
  let nodes = (:)
  for (i, val) in arr.enumerate() {
    let id = str(i)
    let next = if i + 1 < arr.len() { str(i + 1) } else { none }
    nodes.insert(id, (val: val, next: next))
  }
  (type: "linkedlist", head: "0", nodes: nodes)
}

// Get node by ID (or none if invalid)
#let ll-node(list, id) = {
  if id == none { none } else { list.nodes.at(id, default: none) }
}

// Get value at current node
#let ll-val(list, id) = {
  let node = ll-node(list, id)
  if node == none { none } else { node.val }
}

// Get next node ID
#let ll-next(list, id) = {
  let node = ll-node(list, id)
  if node == none { none } else { node.next }
}

// Iterate over all values (returns array)
#let ll-values(list) = {
  let vals = ()
  let curr = list.head
  while curr != none {
    vals.push(ll-val(list, curr))
    curr = ll-next(list, curr)
  }
  vals
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

