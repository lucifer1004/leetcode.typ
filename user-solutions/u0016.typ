#import "../helpers.typ": *

// ========================================
// Problem Description
// ========================================
#include "../problems/p0016.typ"

// ========================================
// Your Solution - Write your code here
// ========================================
#let _3sum-closest(nums, target) = {
  // TODO: Implement your solution

  none
}

// ========================================
// Test Cases
// ========================================
#import "../reference-solutions/s0016.typ": _3sum-closest-ref
#testcases(_3sum-closest, _3sum-closest-ref, (
  (nums: (-1, 2, 1, -4), target: 1),
  (nums: (0, 0, 0), target: 1),
  (nums: (0, 1, 1), target: 2),
  (nums: range(-10, 20, step: 3), target: 20),
  (nums: range(-10, 10), target: 30),
))
