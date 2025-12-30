#import "../helpers.typ": *

// ========================================
// Problem Description
// ========================================
#include "../problems/p0051.typ"

// ========================================
// Your Solution - Write your code here
// ========================================
#let n-queens(n) = {
  // TODO: Implement your solution

  none
}

// ========================================
// Test Cases
// ========================================
#import "../reference-solutions/s0051.typ": n-queens-ref
#testcases(
  n-queens,
  n-queens-ref,
  (
    (n: 1),
    (n: 2),
    (n: 4),
  ),
  comparator: unordered-compare,
  render-chessboard: true,
)
