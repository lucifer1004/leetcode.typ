#import "../../helpers.typ": *

#let solution(root) = {
  if root == none or root.val == none {
    return ()
  }
  let curr = root
  let stack = ()
  let result = ()
  while curr != none or stack.len() > 0 {
    while curr != none {
      stack.push(curr)
      curr = curr.left
    }
    curr = stack.pop()
    result.push(curr.val)
    curr = curr.right
  }
  result
}
