#import "../helpers.typ": *

// ========================================
// Problem Description
// ========================================
#include "../problems/p0007.typ"

// ========================================
// Your Solution - Write your code here
// ========================================
#let reverse-integer(x) = {
  // TODO: Implement your solution

  none
}

// ========================================
// Test Cases
// ========================================
#import "../reference-solutions/s0007.typ": reverse-integer-ref
#testcases(reverse-integer, reverse-integer-ref, (
  (x: 123),
  (x: -123),
  (x: 120),
  (x: 0),
  (x: 23498423),
  (x: -213898800),
  (x: 1534236469),
  (x: 2147483647),
  (x: -2147483648),
))
