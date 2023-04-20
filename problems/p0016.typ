#import "../helpers.typ": *
#import "../solutions/s0016.typ": *

= 3Sum Closest

Given an integer array `nums` of length `n` and an integer `target`, find three integers in `nums` such that the sum is closest to `target`.

Return the sum of the three integers.

You may assume that each input would have exactly one solution.

#let _3sum-closest(nums, target) = {
  // Solve the problem here
}

#testcases(
  _3sum-closest,
  _3sum-closest-ref, (
    (nums: (-1, 2, 1, -4), target: 1),
    (nums: (0, 0, 0), target: 1),
    (nums: (0, 1, 1), target: 2),
    (nums: range(-10, 20, step: 3), target: 20),
    (nums: range(-10, 10), target: 30)
  )
)
