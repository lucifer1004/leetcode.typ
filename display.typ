// display.typ - Display and visualization logic
// Depends on: datastructures, utils, visualize

// No imports needed - linkedlist now has closure methods
#import "utils.typ": chessboard, is-chessboard
#import "visualize.typ": visualize-binarytree, visualize-linkedlist

// Display thresholds - avoid magic numbers
#let MAX-ARRAY-DISPLAY = 210
#let MAX-ARRAY-PREVIEW = 100
#let MAX-STRING-DISPLAY = 1050
#let MAX-STRING-PREVIEW = 500
#let MAX-LINKEDLIST-VISUALIZE = 8

// Main display function with integrated type dispatch
#let display(value, render-chessboard: false) = {
  if type(value) == array {
    // Array display logic
    if render-chessboard and is-chessboard(value) {
      return chessboard(value)
    }
    if render-chessboard and value.len() > 0 and is-chessboard(value.at(0)) {
      return align(center)[#value.map(chessboard).join(line(length: 80%))]
    }
    if value.len() == 0 {
      return [[]]
    }
    if value.len() > MAX-ARRAY-DISPLAY {
      let start = value.slice(0, MAX-ARRAY-PREVIEW)
      let end = value.slice(-MAX-ARRAY-PREVIEW)
      let omitted = value.len() - 2 * MAX-ARRAY-PREVIEW
      return [[#start.map(x => display(x, render-chessboard: render-chessboard)).join(", "), $...$ #omitted items omitted $...$, #end.map(x => display(x, render-chessboard: render-chessboard)).join(", ")]]
    }
    [[#value.map(x => display(x, render-chessboard: render-chessboard)).join(", ")]]
  } else if type(value) == dictionary {
    let t = value.at("type", default: none)
    if t == "linkedlist" {
      // Linked list display - use closure method
      let vals = (value.values)()
      if vals.len() <= MAX-LINKEDLIST-VISUALIZE {
        visualize-linkedlist(value)
      } else {
        vals
          .map(v => display(v, render-chessboard: render-chessboard))
          .join($->$)
      }
    } else if t == "binarytree" {
      // Binary tree display
      // Auto-detect if tree has populated next pointers
      let has-next = value
        .nodes
        .values()
        .any(n => n.at("next", default: none) != none)
      visualize-binarytree(value, show-nulls: false, show-next: has-next)
    } else {
      repr(value)
    }
  } else if type(value) == str {
    // String display logic
    if value.len() > MAX-STRING-DISPLAY {
      let start = value.slice(0, MAX-STRING-PREVIEW)
      let end = value.slice(-MAX-STRING-PREVIEW)
      let omitted = value.len() - 2 * MAX-STRING-PREVIEW
      return display(
        start + " [..." + str(omitted) + " characters omitted ...] " + end,
      )
    }
    "\"" + value.codepoints().join(sym.zws) + "\""
  } else {
    repr(value)
  }
}
