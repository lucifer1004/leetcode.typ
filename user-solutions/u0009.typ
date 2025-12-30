#import "../helpers.typ": *

// ========================================
// Problem Description
// ========================================
#include "../problems/p0009.typ"

// ========================================
// Your Solution - Write your code here
// ========================================
#let palindrome-number(x) = {
  // TODO: Implement your solution

  none
}

// ========================================
// Test Cases
// ========================================
#import "../reference-solutions/s0009.typ": palindrome-number-ref
#testcases(palindrome-number, palindrome-number-ref, (
  (x: 121),
  (x: -121),
  (x: 10),
))
