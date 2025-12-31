#import "../../helpers.typ": *

#let solution(head) = {
  let vals = ()
  let node = head
  while node.val != none {
    vals.push(node.val)
    node = node.next
  }
  let n = vals.len()
  for i in range(n) {
    if calc.rem(i, 2) == 1 {
      let tmp = vals.at(i - 1)
      vals.at(i - 1) = vals.at(i)
      vals.at(i) = tmp
    }
  }

  linkedlist(vals)
}
