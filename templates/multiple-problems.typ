// Multiple Problems Practice Template
// For local development, use lib.typ directly
// After package is published, change to: #import "@preview/leetcode:0.1.0": conf, solve
#import "../lib.typ": conf, solve

// Practice mode with document styling
#show: conf.with(
  practice: true,
  show-title: true,
  show-outline: true,
  show-answer: false, // Set to true to see reference solutions
)

// ============ Problem 1: Two Sum ============
#solve(1, code-block: ```typc
let solution(nums, target) = {
  // TODO: Implement Two Sum
  none
}
```)

// ============ Problem 2: Add Two Numbers ============
#solve(2, code-block: ```typc
let solution(l1, l2) = {
  // TODO: Implement Add Two Numbers
  none
}
```)

// ============ Problem 3: Longest Substring ============
// Just view the problem (not solving yet)
#solve(3)

// ============ Problem 4: Median of Two Sorted Arrays ============
// View problem with reference answer
#solve(4, show-answer: true)
