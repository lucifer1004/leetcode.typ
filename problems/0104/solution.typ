#import "../../helpers.typ": *

#let solution(root) = {
  // Empty tree check
  if root.val == none {
    return 0
  }

  let max-depth(node) = {
    if node == none or node.val == none {
      return 0
    }
    let left = max-depth(node.left)
    let right = max-depth(node.right)
    1 + calc.max(left, right)
  }

  max-depth(root)
}

