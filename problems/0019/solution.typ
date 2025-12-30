#import "../../helpers.typ": *

#let solution-ref(head, n) = {
  let values = ()
  let node = head
  while node.next != none {
    values.push(node.val)
    node = node.next
  }

  let remove-index = values.len() - n
  let filtered = ()
  for i in range(values.len()) {
    if i != remove-index {
      filtered.push(values.at(i))
    }
  }
  linkedlist(filtered)
}
