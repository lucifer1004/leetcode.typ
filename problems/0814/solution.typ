#import "../../helpers.typ": *

#let solution(root) = {
  if root == none or root.val == none {
    return none
  }

  root.left = solution(root.left)
  root.right = solution(root.right)

  if root.left == none and root.right == none and root.val == 0 {
    return none
  }
  root
}
