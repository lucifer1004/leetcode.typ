#import "../../helpers.typ": *

#let solution(head) = {
  if head == none or head.nodes.len() == 0 {
    return head
  }

  // Get values and reverse
  let values = ll-values(head)
  let reversed = values.rev()

  // Build new linked list
  linkedlist(reversed)
}

