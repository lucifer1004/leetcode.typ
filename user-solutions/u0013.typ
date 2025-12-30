#import "../helpers.typ": *

// ========================================
// Problem Description
// ========================================
#include "../problems/p0013.typ"

// ========================================
// Your Solution - Write your code here
// ========================================
#let roman-to-integer(s) = {
  // TODO: Implement your solution

  none
}

// ========================================
// Test Cases
// ========================================
#import "../reference-solutions/s0013.typ": roman-to-integer-ref
#testcases(roman-to-integer, roman-to-integer-ref, (
  (s: "III"),
  (s: "LVIII"),
  (s: "MCMXCIV"),
))
