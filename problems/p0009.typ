#import "../helpers.typ": *
#import "../solutions/s0009.typ": *

= Palindrome Number

Given an integer `x`, return `true` if `x` is a *palindrome*, and `false` otherwise.

#let palindrome-number(x) = {
  // Solve the problem here
}

#testcases(
  palindrome-number,
  palindrome-number-ref, (
    (x: 121),
    (x: -121),
    (x: 10),
  )
)
