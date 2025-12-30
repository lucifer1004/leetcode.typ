#import "../helpers.typ": *

// ========================================
// Problem Description
// ========================================
#include "../problems/p0012.typ"

// ========================================
// Your Solution - Write your code here
// ========================================
#let integer-to-roman(num) = {
  // TODO: Implement your solution

  none
}

// ========================================
// Test Cases
// ========================================
#import "../reference-solutions/s0012.typ": integer-to-roman-ref
#testcases(integer-to-roman, integer-to-roman-ref, (
  (num: 3),
  (num: 58),
  (num: 1994),
))
