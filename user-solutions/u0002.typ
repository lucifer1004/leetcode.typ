#import "../helpers.typ": *

// ========================================
// Problem Description
// ========================================
#include "../problems/p0002.typ"

// ========================================
// Your Solution - Write your code here
// ========================================
#let add-two-numbers(l1, l2) = {
  // TODO: Implement your solution

  none
}

// ========================================
// Test Cases
// ========================================
#import "../reference-solutions/s0002.typ": add-two-numbers-ref
#testcases(add-two-numbers, add-two-numbers-ref, (
  (l1: linkedlist((2, 4, 3)), l2: linkedlist((5, 6, 4))),
  (l1: linkedlist((0,)), l2: linkedlist((0,))),
  (l1: linkedlist((9, 9, 9, 9, 9, 9, 9)), l2: linkedlist((9, 9, 9, 9))),
  (l1: linkedlist((2, 4, 3)), l2: linkedlist((5, 6, 4, 9))),
))
