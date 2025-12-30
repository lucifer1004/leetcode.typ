#import "../helpers.typ": *

// ========================================
// Problem Description
// ========================================
#include "../problems/p0011.typ"

// ========================================
// Your Solution - Write your code here
// ========================================
#let container-with-most-water(height) = {
  // TODO: Implement your solution

  none
}

// ========================================
// Test Cases
// ========================================
#import "../reference-solutions/s0011.typ": container-with-most-water-ref
#testcases(container-with-most-water, container-with-most-water-ref, (
  (height: (1, 8, 6, 2, 5, 4, 8, 3, 7)),
  (height: (1, 1)),
))
