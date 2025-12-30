#import "../helpers.typ": *

// ========================================
// Problem Description
// ========================================
#include "../problems/p0003.typ"

// ========================================
// Your Solution - Write your code here
// ========================================
#let longest-substring-without-repeating-charaters(s) = {
  // TODO: Implement your solution

  none
}

// ========================================
// Test Cases
// ========================================
#import "../reference-solutions/s0003.typ": (
  longest-substring-without-repeating-charaters-ref,
)
#testcases(
  longest-substring-without-repeating-charaters,
  longest-substring-without-repeating-charaters-ref,
  (
    (s: "abcabcbb"),
    (s: "bbbbb"),
    (s: "pwwkew"),
  ),
)
