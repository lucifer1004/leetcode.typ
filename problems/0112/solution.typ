#import "../../helpers.typ": *

#let solution(root, target-sum) = {
  if root.val == none {
    return false
  }

  let dfs(node, sum) = {
    if node == none or node.val == none {
      return false
    }
    let result = node.val + sum == target-sum
    result = (
      result
        or dfs(node.left, node.val + sum)
        or dfs(node.right, node.val + sum)
    )
    result
  }

  dfs(root, 0)
}
