#import "../helpers.typ": *
#import "../solutions/s0014.typ": *

= Longest Common Prefix

Write a function to find the longest common prefix string amongst an array of strings.

If there is no common prefix, return an empty string `""`.

#let longest-common-prefix(strs) = {
  // Solve the problem here
}

#testcases(
  longest-common-prefix,
  longest-common-prefix-ref, (
    (strs: ("flower", "flow", "flight")),
    (strs: ("dog", "racecar", "car")),
  )
)
