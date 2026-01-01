#import "../../helpers.typ": *

#let solution(l1, l2) = {
  let p = ()
  let carry = 0
  let curr1 = l1.head
  let curr2 = l2.head
  while ll-val(l1, curr1) != none or ll-val(l2, curr2) != none {
    let x = if ll-val(l1, curr1) != none { ll-val(l1, curr1) } else { 0 }
    let y = if ll-val(l2, curr2) != none { ll-val(l2, curr2) } else { 0 }
    let sum = x + y + carry
    carry = calc.floor(sum / 10)
    p.push(calc.rem(sum, 10))
    // Always advance to next (which may be none)
    curr1 = ll-next(l1, curr1)
    curr2 = ll-next(l2, curr2)
  }
  if carry > 0 {
    p.push(carry)
  }
  linkedlist(p)
}
