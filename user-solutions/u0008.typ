#import "../helpers.typ": *

// ========================================
// Problem Description
// ========================================
#include "../problems/p0008.typ"

// ========================================
// Your Solution - Write your code here
// ========================================
#let string-to-integer(s) = {
  // TODO: Implement your solution

  none
}

// ========================================
// Test Cases
// ========================================
#import "../reference-solutions/s0008.typ": string-to-integer-ref
#testcases(string-to-integer, string-to-integer-ref, (
  (s: "42"),
  (s: "   -42"),
  (s: "4193 with words"),
))
