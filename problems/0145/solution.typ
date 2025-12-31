#import "../../helpers.typ": *

#let solution(root) = {
  if root == none or root.val == none {
    return ()
  }

  let stack = (root,)
  let output = ()

  while stack.len() > 0 {
    let node = stack.pop()
    output.push(node.val)

    if node.left != none { stack.push(node.left) }
    if node.right != none { stack.push(node.right) }
  }
  output.rev()
}
