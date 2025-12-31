#import "../../helpers.typ": *

#let solution(root, target-sum) = {
  if root.val == none {
    return ()
  }

  let dfs(node, sum, path) = {
    if node == none or node.val == none {
      return ()
    }
    path.push(node.val)
    let ans = ()
    if node.val + sum == target-sum {
      ans.push(path)
    }
    let left = dfs(node.left, node.val + sum, path)
    let right = dfs(node.right, node.val + sum, path)
    (..ans, ..left, ..right)
  }

  dfs(root, 0, ())
}
