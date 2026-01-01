// For local development, use lib.typ directly
// After package is published, change to: #import "@preview/leetcode:0.1.0": problem, test
#import "../lib.typ": problem, test

// Display the problem statement
#problem(1)

// Your solution implementation
#let solution(nums, target) = {
  // TODO: Implement your solution here
  // This example problem expects you to return indices of two numbers that add up to target

  none
}

// Test your solution against the reference (uses built-in test cases)
#test(1, solution)
