#import "helpers.typ": *
#import "reference.typ": *

#outline()

#counter(page).update(0)
#set page(numbering: "1")
#set heading(numbering: "0001")
#show heading: it => {
  pagebreak(weak: true)
  it
  v(1em)
}

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

= Add Two Numbers (N/A)

= Longest Substring Without Repeating Characters

Given a string `s`, find the length of the *longest substring* without repeating characters.

#let longest-substring-without-repeating-charaters(s) = {
  // Solve the problem here
}

#testcases(
  longest-substring-without-repeating-charaters,
  longest-substring-without-repeating-charaters-ref, (
    (s: "abcabcbb"),
    (s: "bbbbb"),
    (s: "pwwkew"),
  )
)

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

= Longest Palindromic Substring

Given a string `s`, return the *longest palindromic substring* in `s`.

#let longest-palindromic-substring(s) = {
  // Solve the problem here
}

#testcases(
  longest-palindromic-substring,
  longest-palindromic-substring-ref, (
    (s: "babad"),
    (s: "cbbd"),
    (s: "abcdefgfedcbb"),
    (s: "accc"),
    (s: "a"),
    (s: "aa"),
    (s: "asasfsafdaasfsaasa")
  )
)

= Zigzag Conversion

The string "PAYPALISHIRING" is written in a zigzag pattern on a given number of rows like this:

```
P   A   H   N
A P L S I I G
Y   I   R
```

And then read line by line: "PAHNAPLSIIGYIR"

Write the code that will take a string and make this conversion given a number of rows.

#let zigzag-conversion(s, numRows) = {
  // Solve the problem here
}

#testcases(
  zigzag-conversion,
  zigzag-conversion-ref, (
    (s: "PAYPALISHIRING", numRows: 3),
    (s: "PAYPALISHIRING", numRows: 4),
    (s: "A", numRows: 1),
  )
)
