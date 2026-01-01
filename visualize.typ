// visualize.typ - Data structure visualization
// Depends on: cetz, fletcher (external packages)

#import "@preview/cetz:0.4.2" as cetz
#import cetz.tree

// Binary tree visualization defaults
#let DEFAULT-TREE-SPREAD = 0.8
#let DEFAULT-TREE-GROW = 0.6
#let DEFAULT-TREE-RADIUS = 0.3
#let DEFAULT-STROKE-THICKNESS = 1pt

// Linked list visualization defaults
#let DEFAULT-LIST-SPACING = 1.2em
#let DEFAULT-LIST-FONT-SIZE = 6pt
#let DEFAULT-CYCLE-BEND = -40deg

#let visualize-binarytree(
  root,
  direction: "down",
  spread: DEFAULT-TREE-SPREAD,
  grow: DEFAULT-TREE-GROW,
  radius: DEFAULT-TREE-RADIUS,
  show-nulls: false,
) = {
  // dict tree -> CeTZ tree node array
  // CeTZ node format: ([content], child1, child2, ...)
  let to-cetz(node) = {
    if (
      type(node) != dictionary or node.at("type", default: none) != "binarytree"
    ) {
      return none
    }
    if node.val == none {
      none
    } else {
      let v = node.val
      let l = to-cetz(node.left)
      let r = to-cetz(node.right)
      (text(repr(v)), l, r)
    }
  }

  let data = to-cetz(root)
  cetz.canvas({
    import cetz.draw: *

    if data == none {
      circle((0, 0), radius: radius, fill: white, stroke: (
        thickness: DEFAULT-STROKE-THICKNESS,
      ))
      content((0, 0), "∅")
      return
    }

    tree.tree(
      data,
      direction: direction,
      spread: spread,
      grow: grow,

      draw-node: node => {
        if node.content != none or show-nulls {
          circle((0, 0), radius: radius, fill: white, stroke: (
            thickness: DEFAULT-STROKE-THICKNESS,
          ))
          content((0, 0), if node.content != none { node.content } else { "∅" })
        }
      },

      draw-edge: (source, target, parent, child) => {
        if child != none and (child.content != none or show-nulls) {
          line(source + ".south", target + ".north", stroke: (
            thickness: DEFAULT-STROKE-THICKNESS,
          ))
        }
      },
    )
  })
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
