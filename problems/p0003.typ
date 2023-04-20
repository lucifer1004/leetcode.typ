#import "../helpers.typ": *
#import "../solutions/s0003.typ": *

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
