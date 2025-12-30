#import "../helpers.typ": *

// ========================================
// Problem Description
// ========================================
#include "../problems/p0001.typ"

// ========================================
// Your Solution - Write your code here
// ========================================
#let two-sum(nums, target) = {
  // TODO: Implement your solution

  none
}

// ========================================
// Test Cases
// ========================================
#import "../reference-solutions/s0001.typ": two-sum-ref
#testcases(two-sum, two-sum-ref, (
  (nums: (2, 7, 11, 15), target: 9),
  (nums: (3, 2, 4), target: 6),
  (nums: (3, 3), target: 6),
  (nums: (0, 0), target: 1),
  (nums: range(1, 100, step: 3), target: 191),
))
