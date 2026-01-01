// For local development, use lib.typ directly
// After package is published, change to: #import "@preview/leetcode:0.1.0": problem, test
#import "../lib.typ": problem, test

// ============================================
// Problem 1: Two Sum
// ============================================
#problem(1)

#let solution(nums, target) = {
  // TODO: Implement Two Sum
  none
}

// Use built-in test cases
#test(1, solution)

// ============================================
// Problem 2: Add Two Numbers
// ============================================
#pagebreak()
#problem(2)

// You can reuse the same 'solution' name for different problems
#let solution(l1, l2) = {
  // TODO: Implement Add Two Numbers
  none
}

// Use built-in test cases
#test(2, solution)

// ============================================
// Problem 3: Longest Substring Without Repeating Characters
// ============================================
#pagebreak()
#problem(3)

#let solution(s) = {
  // TODO: Implement solution
  none
}

// Or add extra test cases
#test(3, solution, extra-cases: (
  (s: "abcabcbb"),
  (s: "bbbbb"),
  (s: "pwwkew"),
  (s: "myowntest"),
))
