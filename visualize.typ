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
  import "@preview/fletcher:0.5.8": diagram, edge, node

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
