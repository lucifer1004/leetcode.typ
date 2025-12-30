#import "../helpers.typ": *

// ========================================
// Problem Description
// ========================================
#include "../problems/p0017.typ"

// ========================================
// Your Solution - Write your code here
// ========================================
#let letter-combinations-of-a-phone-number(digits) = {
  // TODO: Implement your solution

  none
}

// ========================================
// Test Cases
// ========================================
#import "../reference-solutions/s0017.typ": (
  letter-combinations-of-a-phone-number-ref,
)
#testcases(
  letter-combinations-of-a-phone-number,
  letter-combinations-of-a-phone-number-ref,
  (
    (digits: "23"),
    (digits: ""),
    (digits: "2"),
  ),
)
