#import "../../helpers.typ": *

#let solution(head, k) = {
  let vals = ()
  let node = head
  while node.val != none {
    vals.push(node.val)
    node = node.next
  }
  let n = vals.len()
  let ans = ()
  for i in range(0, n, step: k) {
    if i + k <= n {
      for j in range(k) {
        ans.push(vals.at(i + k - j - 1))
      }
    } else {
      for j in range(i, n) {
        ans.push(vals.at(j))
      }
    }
  }

  linkedlist(ans)
}
