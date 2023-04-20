#import "../helpers.typ": *
#import "../solutions/s0015.typ": *

= 3Sum

Given an integer array nums, return all the triplets `[nums[i], nums[j], nums[k]]` such that `i != j`, `i != k`, and `j != k`, and `nums[i] + nums[j] + nums[k] == 0`.

Notice that the solution set must not contain duplicate triplets.

#let _3sum(nums) = {
  // Solve the problem here
}

#testcases(
  _3sum,
  _3sum-ref, (
    (nums: (-1, 0, 1, 2, -1, -4)),
    (nums: (0, 1, 1)),
    (nums: (0, 0, 0)),
    (nums: range(-10, 20, step: 3)),
    (nums: range(-10, 10))
  )
)
