#import "../../helpers.typ": *

#let solution(root) = {
  let balanced(node) = if node == none or node.val == none {
    (true, 0)
  } else {
    let left = balanced(node.left)
    let right = balanced(node.right)
    (
      left.at(0) and right.at(0) and calc.abs(left.at(1) - right.at(1)) <= 1,
      calc.max(left.at(1), right.at(1)) + 1,
    )
  }
  balanced(root).at(0)
}
