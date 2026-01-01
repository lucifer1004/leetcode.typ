// Single Problem Practice Template
// For local development, use lib.typ directly
// After package is published, change to: #import "@preview/leetcode:0.1.0": conf, solve
#import "../lib.typ": conf, solve

// Practice mode with document styling
#show: conf.with(
  practice: true,
  show-title: false,
  show-outline: false,
  show-answer: false, // Set to true to see reference solution
)

// ============ Problem 1: Two Sum ============
#solve(1, code-block: ```typc
let solution(nums, target) = {
  // TODO: Implement your solution here
  // Return indices of two numbers that add up to target

  none
}
```)
