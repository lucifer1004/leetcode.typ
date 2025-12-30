#import "../helpers.typ": *

// ========================================
// Problem Description
// ========================================
#include "../problems/p0006.typ"

// ========================================
// Your Solution - Write your code here
// ========================================
#let zigzag-conversion(s, numRows) = {
  // TODO: Implement your solution

  none
}

// ========================================
// Test Cases
// ========================================
#import "../reference-solutions/s0006.typ": zigzag-conversion-ref
#testcases(zigzag-conversion, zigzag-conversion-ref, (
  (s: "PAYPALISHIRING", numRows: 3),
  (s: "PAYPALISHIRING", numRows: 4),
  (s: "A", numRows: 1),
))
