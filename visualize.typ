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
  head,
  direction: "right",
  step: .85,
  radius: .25,
) = {
  if (
    type(head) != dictionary or head.at("type", default: none) != "linkedlist"
  ) {
    return ()
  }

  let vals = ()
  let curr = head
  while curr != none {
    vals.push(curr.val)
    curr = curr.next
  }
  cetz.canvas({
    import cetz.draw: *

    if head.val == none {
      circle((0, 0), radius: radius, fill: white, stroke: (thickness: 1pt))
      content((0, 0), "∅")
      return
    }

    // explicit point construction helpers (avoid tuple concatenation)
    let pos(i) = if direction == "down" { (0.0, -step * i) } else {
      (step * i, 0.0)
    }
    let x(p) = p.at(0)
    let y(p) = p.at(1)

    let edge-start(p) = if direction == "down" { (x(p), y(p) - radius) } else {
      (x(p) + radius, y(p))
    }

    let edge-end(p) = if direction == "down" { (x(p), y(p) + radius) } else {
      (x(p) - radius, y(p))
    }

    // nodes
    for i in range(vals.len()) {
      let v = vals.at(i)
      let p = pos(i)
      if v != none {
        circle(p, radius: radius, fill: white, stroke: (thickness: 1pt))
        content(p, repr(v))
      }
    }

    // edges
    for i in range(vals.len() - 1) {
      let a = pos(i)
      let b = pos(i + 1)

      let s = edge-start(a)
      let t = edge-end(b)

      if vals.at(i + 1) != none {
        line(s, t, mark: (end: "straight"), stroke: (thickness: 1pt))
      }
    }
  })
}
