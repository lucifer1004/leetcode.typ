#import "../helpers.typ": *

// ========================================
// Problem Description
// ========================================
#include "../problems/p0014.typ"

// ========================================
// Your Solution - Write your code here
// ========================================
#let longest-common-prefix(strs) = {
  // TODO: Implement your solution

  none
}

// ========================================
// Test Cases
// ========================================
#import "../reference-solutions/s0014.typ": longest-common-prefix-ref
#testcases(longest-common-prefix, longest-common-prefix-ref, (
  (strs: ("flower", "flow", "flight")),
  (strs: ("dog", "racecar", "car")),
))
