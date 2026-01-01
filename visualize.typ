// visualize.typ - Data structure visualization
// Depends on: cetz, fletcher (external packages)

#import "@preview/cetz:0.4.2" as cetz
#import cetz.tree as cetz-tree

// Binary tree visualization defaults
#let DEFAULT-TREE-SPREAD = 1.2 // Horizontal gap between siblings
#let DEFAULT-TREE-GROW = 1.5 // Vertical gap between levels
#let DEFAULT-TREE-NODE-SIZE = 1.8em // Fixed node size
#let DEFAULT-STROKE-THICKNESS = 0.8pt

// Default node fill - gradient matching linked list style
#let DEFAULT-NODE-FILL = gradient.radial(
  blue.lighten(80%),
  blue,
  center: (30%, 20%),
  radius: 80%,
)

// Default edge stroke color
#let DEFAULT-EDGE-STROKE = blue.darken(20%)

// Next pointer style (for 116/117) - bright orange, thicker
#let DEFAULT-NEXT-STROKE = orange.lighten(20%)

// Linked list visualization defaults
#let DEFAULT-LIST-SPACING = 1.2em
#let DEFAULT-LIST-FONT-SIZE = 6pt
#let DEFAULT-CYCLE-BEND = -40deg

// Calculate node positions for binary tree visualization
// Uses iterative post-order for widths, then iterative pre-order for positions
// Returns: dict(id -> (x, y))
#let calc-tree-positions(tree, h-gap: 0.8, v-gap: 1.0) = {
  if tree.root == none {
    return (:)
  }

  // Step 1: Collect all nodes in post-order (children before parents)
  // Using iterative approach with explicit stack
  let post-order = ()
  let stack = ((id: tree.root, visited: false),)

  while stack.len() > 0 {
    let item = stack.pop()
    let id = item.id

    if item.visited {
      post-order.push(id)
    } else {
      // Push back as visited, then push children
      stack.push((id: id, visited: true))
      let right = (tree.get-right)(id)
      let left = (tree.get-left)(id)
      if right != none { stack.push((id: right, visited: false)) }
      if left != none { stack.push((id: left, visited: false)) }
    }
  }

  // Step 2: Calculate subtree widths bottom-up
  let widths = (:)
  for id in post-order {
    let left = (tree.get-left)(id)
    let right = (tree.get-right)(id)
    let lw = if left != none { widths.at(left).total } else { 0 }
    let rw = if right != none { widths.at(right).total } else { 0 }

    let total = if lw == 0 and rw == 0 {
      1
    } else if lw == 0 {
      rw
    } else if rw == 0 {
      lw
    } else {
      lw + h-gap + rw
    }
    widths.insert(id, (left: lw, right: rw, total: total))
  }

  // Step 3: Assign positions top-down (BFS/pre-order)
  let positions = (:)
  let queue = ((id: tree.root, x: 0, y: 0),)

  while queue.len() > 0 {
    let item = queue.remove(0)
    let id = item.id
    let x = item.x
    let y = item.y

    positions.insert(id, (x, y))

    let left = (tree.get-left)(id)
    let right = (tree.get-right)(id)
    let w = widths.at(id)

    if left != none {
      let lw = widths.at(left)
      // Left child x = parent x - (right subtree width of left child) - gap/2
      let left-x = x - lw.right - h-gap / 2
      if right == none { left-x = x - h-gap / 2 }
      queue.push((id: left, x: left-x, y: y + v-gap))
    }

    if right != none {
      let rw = widths.at(right)
      // Right child x = parent x + (left subtree width of right child) + gap/2
      let right-x = x + rw.left + h-gap / 2
      if left == none { right-x = x + h-gap / 2 }
      queue.push((id: right, x: right-x, y: y + v-gap))
    }
  }

  positions
}

#let visualize-binarytree(
  tree,
  spread: DEFAULT-TREE-SPREAD,
  grow: DEFAULT-TREE-GROW,
  node-size: DEFAULT-TREE-NODE-SIZE,
  show-nulls: false,
  show-next: false,
  node-fill: DEFAULT-NODE-FILL,
) = {
  import "@preview/fletcher:0.5.8": diagram, edge, node

  // Validate input
  if (
    type(tree) != dictionary or tree.at("type", default: none) != "binarytree"
  ) {
    return none
  }

  // Handle empty tree
  if tree.root == none or tree.nodes.len() == 0 {
    return {
      set text(6pt)
      diagram(
        node-fill: gray.lighten(60%),
        spacing: 1.2em,
        node((0, 0), "∅", width: node-size, height: node-size, shape: "circle"),
      )
    }
  }

  // Calculate positions
  let positions = calc-tree-positions(tree, h-gap: spread, v-gap: grow)

  // Build nodes with fixed size
  let nodes = ()
  for (id, pos) in positions {
    let val = (tree.get-val)(id)
    nodes.push(node(
      pos,
      repr(val),
      width: node-size,
      height: node-size,
      shape: "circle",
    ))
  }

  // Build tree edges (parent -> children)
  let tree-edges = ()
  for (id, pos) in positions {
    let left = (tree.get-left)(id)
    let right = (tree.get-right)(id)
    if left != none and left in positions {
      tree-edges.push(edge(
        pos,
        positions.at(left),
        stroke: DEFAULT-EDGE-STROKE,
      ))
    }
    if right != none and right in positions {
      tree-edges.push(edge(
        pos,
        positions.at(right),
        stroke: DEFAULT-EDGE-STROKE,
      ))
    }
  }

  // Build next edges (horizontal dashed arrows, subtle style)
  let next-edges = ()
  if show-next {
    for (id, pos) in positions {
      let next-id = (tree.get-next)(id)
      if next-id != none and next-id in positions {
        let target-pos = positions.at(next-id)
        // Only draw if target is on the same level
        if calc.abs(pos.at(1) - target-pos.at(1)) < 0.01 {
          next-edges.push(edge(
            pos,
            target-pos,
            stroke: (
              paint: DEFAULT-NEXT-STROKE,
              thickness: 0.6pt,
              dash: "dashed",
            ),
            "->",
            bend: 25deg,
          ))
        }
      }
    }
  }

  set text(6pt)
  diagram(
    node-fill: node-fill,
    node-stroke: DEFAULT-EDGE-STROKE,
    spacing: 1.2em,
    ..nodes,
    ..tree-edges,
    ..next-edges,
  )
}

#let visualize-linkedlist(
  list,
  direction: "right",
  spacing: DEFAULT-LIST-SPACING,
  font-size: DEFAULT-LIST-FONT-SIZE,
) = {
  import "@preview/fletcher:0.5.8": diagram, edge, node

  if (
    type(list) != dictionary or list.at("type", default: none) != "linkedlist"
  ) {
    return ()
  }

  // Handle empty linked list - display special ∅ node
  if list.head == none or list.nodes.len() == 0 {
    return {
      set text(font-size)
      diagram(
        node-fill: gray.lighten(60%),
        spacing: spacing,
        node((0, 0), "∅"),
      )
    }
  }

  // Extract values from flat linked list structure with cycle detection
  let vals = ()
  let id-to-idx = (:)
  let cycle-target = none
  let curr = list.head
  let idx = 0
  while curr != none {
    if curr in id-to-idx {
      cycle-target = id-to-idx.at(curr)
      break
    }
    let node-data = list.nodes.at(curr, default: none)
    if node-data == none { break }
    id-to-idx.insert(curr, idx)
    vals.push(node-data.val)
    curr = node-data.next
    idx += 1
  }

  let nodes = vals
    .enumerate()
    .map(it => {
      let idx = it.at(0)
      let val = it.at(1)
      let display-val = if val != none { repr(val) } else { "∅" }
      node((idx, 0), display-val)
    })

  let edges = range(vals.len() - 1).map(i => {
    edge((i, 0), (i + 1, 0), ``, "-|>")
  })

  // Add cycle edge if cycle was detected
  if cycle-target != none and vals.len() > 0 {
    let last-idx = vals.len() - 1
    edges.push(edge(
      (last-idx, 0),
      (cycle-target, 0),
      ``,
      "-|>",
      bend: DEFAULT-CYCLE-BEND,
    ))
  }

  set text(font-size)
  diagram(
    node-fill: gradient.radial(
      blue.lighten(80%),
      blue,
      center: (30%, 20%),
      radius: 80%,
    ),
    spacing: spacing,
    ..nodes,
    ..edges,
  )
}
