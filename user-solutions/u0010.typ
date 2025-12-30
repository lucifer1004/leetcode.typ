#import "../helpers.typ": *

// ========================================
// Problem Description
// ========================================
#include "../problems/p0010.typ"

// ========================================
// Your Solution - Write your code here
// ========================================
#let regular-expression-matching(s, p) = {
  // TODO: Implement your solution

  none
}

// ========================================
// Test Cases
// ========================================
#import "../reference-solutions/s0010.typ": regular-expression-matching-ref
#testcases(regular-expression-matching, regular-expression-matching-ref, (
  (s: "aa", p: "a"),
  (s: "aa", p: "a*"),
  (s: "ab", p: ".*"),
  (s: "aab", p: "c*a*b"),
  (s: "mississippi", p: "mis*is*p*."),
  (s: "ab", p: ".*c"),
  (s: "ab", p: ".*c*"),
  (s: "香蕉x牛奶", p: "香.*牛."),
))
