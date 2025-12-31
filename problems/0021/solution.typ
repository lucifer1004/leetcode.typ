#import "../../helpers.typ": *

#let solution(list1, list2) = {
  let ans = ()
  while list1.val != none or list2.val != none {
    if list1.val != none and (list2.val == none or list1.val < list2.val) {
      ans.push(list1.val)
      list1 = list1.next
    } else {
      ans.push(list2.val)
      list2 = list2.next
    }
  }
  linkedlist(ans)
}
