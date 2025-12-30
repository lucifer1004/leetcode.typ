#import "../helpers.typ": *

// ========================================
// Problem Description
// ========================================
#include "../problems/p0015.typ"

// ========================================
// Your Solution - Write your code here
// ========================================
#let _3sum(nums) = {
  // TODO: Implement your solution

  none
}

// ========================================
// Test Cases
// ========================================
#import "../reference-solutions/s0015.typ": _3sum-ref
#testcases(_3sum, _3sum-ref, (
  (nums: (-1, 0, 1, 2, -1, -4)),
  (nums: (0, 1, 1)),
  (nums: (0, 0, 0)),
  (nums: range(-10, 20, step: 3)),
  (nums: range(-10, 10)),
))
