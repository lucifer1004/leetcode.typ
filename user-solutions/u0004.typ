#import "../helpers.typ": *

// ========================================
// Problem Description
// ========================================
#include "../problems/p0004.typ"

// ========================================
// Your Solution - Write your code here
// ========================================
#let median-of-two-sorted-arrays(nums1, nums2) = {
  // TODO: Implement your solution

  none
}

// ========================================
// Test Cases
// ========================================
#import "../reference-solutions/s0004.typ": median-of-two-sorted-arrays-ref
#testcases(median-of-two-sorted-arrays, median-of-two-sorted-arrays-ref, (
  (nums1: (1, 3), nums2: (2,)),
  (nums1: (1, 2), nums2: (3, 4)),
  (nums1: range(100, step: 3), nums2: range(200, step: 6)),
))
