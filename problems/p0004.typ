#import "../helpers.typ": *
#import "../solutions/s0004.typ": *

= Median of Two Sorted Arrays

Given two sorted arrays `nums1` and `nums2` of size `m` and `n` respectively, return the *median* of the two sorted arrays.

The overall run time complexity should be $cal(O)(log (m+n))$.

#let median-of-two-sorted-arrays(nums1, nums2) = {
  // Solve the problem here
}

#testcases(
  median-of-two-sorted-arrays,
  median-of-two-sorted-arrays-ref, (
    (nums1: (1, 3), nums2: (2,)),
    (nums1: (1, 2), nums2: (3, 4)),
    (nums1: range(100, step: 3), nums2: range(200, step: 6)),
  )
)
