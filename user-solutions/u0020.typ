#import "../helpers.typ": *

// ========================================
// Problem Description
// ========================================
#include "../problems/p0020.typ"

// ========================================
// Your Solution - Write your code here
// ========================================
#let valid-parentheses(s) = {
  // TODO: Implement your solution

  none
}

// ========================================
// Test Cases
// ========================================
#import "../reference-solutions/s0020.typ": valid-parentheses-ref
#testcases(valid-parentheses, valid-parentheses-ref, (
  (s: "()"),
  (s: "()[]{}"),
  (s: "(]"),
  (s: "([])"),
  (s: "([)]"),
))
