#import "../helpers.typ": *

// ========================================
// Problem Description
// ========================================
#include "../problems/p0018.typ"

// ========================================
// Your Solution - Write your code here
// ========================================
#let _4sum(nums, target) = {
  // TODO: Implement your solution

  none
}

// ========================================
// Test Cases
// ========================================
#import "../reference-solutions/s0018.typ": _4sum-ref
#testcases(_4sum, _4sum-ref, (
  (nums: (1, 0, -1, 0, -2, 2), target: 0),
  (nums: (2, 2, 2, 2), target: 8),
  (nums: range(-5, 5), target: 3),
))
