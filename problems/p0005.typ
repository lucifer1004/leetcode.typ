#import "../helpers.typ": *
#import "../solutions/s0005.typ": *

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