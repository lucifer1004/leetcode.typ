#import "../helpers.typ": *
#import "../solutions/s0002.typ": *

= Add Two Numbers

You are given two *non-empty* linked lists representing two non-negative integers. The digits are stored in *reverse order*, and each of their nodes contains a single digit. Add the two numbers and return the sum as a linked list.

You may assume the two numbers do not contain any leading zero, except the number 0 itself.

#let add-two-numbers(l1, l2) = {
  // Solve the problem here
  // 
  // The linked list is defined as a special dictionary
  // with keys `val` and `next`.
  // You can see the definition in `helpers.typ`.
}

#testcases(add-two-numbers, add-two-numbers-ref, (
  (l1: linkedlist((2, 4, 3)), l2: linkedlist((5, 6, 4))),
  (l1: linkedlist((0,)), l2: linkedlist((0,))),
  (l1: linkedlist((9, 9, 9, 9, 9, 9, 9)), l2: linkedlist((9, 9, 9, 9))),
  (l1: linkedlist((2, 4, 3)), l2: linkedlist((5, 6, 4, 9))),
))
