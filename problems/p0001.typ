#import "../helpers.typ": *
#import "../solutions/s0001.typ": *

= Two Sum

Given an array of integers `nums` and an integer `target`, return indices of the two numbers such that they add up to `target`.

You may assume that each input would have *exactly one solution*, and you may not use the same element twice.

You can return the answer in any order.

#let two-sum(nums, target) = {
  // Solve the problem here
}

#testcases(two-sum, two-sum-ref, (
  (nums: (2, 7, 11, 15), target: 9),
  (nums: (3, 2, 4), target: 6),
  (nums: (3, 3), target: 6),
  (nums: (0, 0), target: 1),
  (nums: range(1, 100, step: 3), target: 191),
))
