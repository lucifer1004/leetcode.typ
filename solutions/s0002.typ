#import "../helpers.typ": *

#let add-two-numbers-ref(l1, l2) = {
  let p = ()
  let carry = 0
  while l1.val != none or l2.val != none {
    let x = if l1.val != none { l1.val } else { 0 }
    let y = if l2.val != none { l2.val } else { 0 }
    let sum = x + y + carry
    carry = calc.floor(sum / 10)
    p.push(calc.mod(sum, 10))
    if l1.next != none {
      l1 = l1.next
    }
    if l2.next != none {
      l2 = l2.next
    }
  }
  if carry > 0 {
    p.push(carry)
  }
  linkedlist(p)
}
