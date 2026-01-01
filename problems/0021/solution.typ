#import "../../helpers.typ": *

#let solution(list1, list2) = {
  let ans = ()
  let curr1 = list1.head
  let curr2 = list2.head
  while ll-val(list1, curr1) != none or ll-val(list2, curr2) != none {
    let v1 = ll-val(list1, curr1)
    let v2 = ll-val(list2, curr2)
    if v1 != none and (v2 == none or v1 < v2) {
      ans.push(v1)
      curr1 = ll-next(list1, curr1)
    } else {
      ans.push(v2)
      curr2 = ll-next(list2, curr2)
    }
  }
  linkedlist(ans)
}
