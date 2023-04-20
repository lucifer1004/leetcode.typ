#import "../helpers.typ": *
#import "../solutions/s0018.typ": *

= 4Sum

Given an array `nums` of `n` integers, return an array of all the unique quadruplets `[nums[a], nums[b], nums[c], nums[d]]` such that:

- `0 <= a, b, c, d < n`
- `a`, `b`, `c`, and `d` are *distinct*.
- `nums[a] + nums[b] + nums[c] + nums[d] == target`

You may return the answer in *any order*.

#let _4sum(nums, target) = {
  // Solve the problem here
}

#testcases(
  _4sum,
  _4sum-ref, (
    (nums: (1, 0, -1, 0, -2, 2), target: 0),
    (nums: (2, 2, 2, 2), target: 8),
    (nums: range(-5,5), target: 3),
  )
)
