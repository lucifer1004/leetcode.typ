#import "@preview/cetz:0.4.2" as cetz
#import cetz.tree

#let visualize-binarytree(
  root,
  direction: "down",
  spread: 0.8,
  grow: 0.6,
  radius: 0.3,
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
      circle((0, 0), radius: radius, fill: white, stroke: (thickness: 1pt))
      content((0, 0), "∅")
      return
    }

    tree.tree(
      data,
      direction: direction,
      spread: spread,
      grow: grow,

      // draw-node must draw at (0,0) in the node's local coord system :contentReference[oaicite:1]{index=1}
      draw-node: node => {
        if node.content != none or show-nulls {
          circle((0, 0), radius: radius, fill: white, stroke: (thickness: 1pt))
          content((0, 0), if node.content != none { node.content } else { "∅" })
        }
      },

      // draw-edge gets names + nodes; use names as anchors :contentReference[oaicite:2]{index=2}
      draw-edge: (source, target, parent, child) => {
        // simplest: connect node anchors directly
        if child != none and (child.content != none or show-nulls) {
          line(source + ".south", target + ".north", stroke: (thickness: 1pt))
        }
      },
    )
  })
}

#let visualize-linkedlist(
  list,
  direction: "right",
  step: .85,
  radius: .25,
) = {
  import "@preview/fletcher:0.5.8": diagram, edge, node

  if (
    type(list) != dictionary or list.at("type", default: none) != "linkedlist"
  ) {
    return ()
  }

  // Extract values from flat linked list structure with cycle detection
  let vals = ()
  let id-to-idx = (:) // Map node ID to its index in vals
  let cycle-target = none // Index where cycle points back to (if any)
  let curr = list.head
  let idx = 0
  while curr != none {
    // Check if we've visited this node before (cycle detected)
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
    edges.push(edge((last-idx, 0), (cycle-target, 0), ``, "-|>", bend: -40deg))
  }

  set text(6pt)
  diagram(
    node-fill: gradient.radial(
      blue.lighten(80%),
      blue,
      center: (30%, 20%),
      radius: 80%,
    ),
    spacing: 1.2em,
    ..nodes,
    ..edges,
  )
}
