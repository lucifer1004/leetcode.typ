#import "../helpers.typ": *

// ========================================
// Problem Description
// ========================================
#include "../problems/p0005.typ"

// ========================================
// Your Solution - Write your code here
// ========================================
#let longest-palindromic-substring(s) = {
  // TODO: Implement your solution

  none
}

// ========================================
// Test Cases
// ========================================
#import "../reference-solutions/s0005.typ": longest-palindromic-substring-ref
#testcases(longest-palindromic-substring, longest-palindromic-substring-ref, (
  (s: "babad"),
  (s: "cbbd"),
  (s: "abcdefgfedcbb"),
  (s: "accc"),
  (s: "a"),
  (s: "aa"),
  (s: "asasfsafdaasfsaasa"),
))
