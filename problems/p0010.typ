#import "../helpers.typ": *
#import "../solutions/s0010.typ": *

= Regular Expression Matching

Given an input string s and a pattern p, implement regular expression matching with support for `'.'` and `'*'` where:

- `'.'` Matches any single character.​​​​
- `'*'` Matches zero or more of the preceding element.
The matching should cover the *entire* input string (not partial).

#let regular-expression-matching(s, p) = {
  // Solve the problem here
}

#testcases(
  regular-expression-matching,
  regular-expression-matching-ref, (
    (s: "aa", p: "a"),
    (s: "aa", p: "a*"),
    (s: "ab", p: ".*"),
    (s: "aab", p: "c*a*b"),
    (s: "mississippi", p: "mis*is*p*."),
    (s: "ab", p: ".*c"),
    (s: "ab", p: ".*c*"),
    (s: "香蕉x牛奶", p: "香.*牛.")
  )
)
