#import "../helpers.typ": *
#import "../solutions/s0007.typ": *

= Reverse Integer

Given a signed 32-bit integer x, return x with its digits reversed. If reversing x causes the value to go outside the signed 32-bit integer range $[-2^31, 2^31 - 1]$, then return 0.

*Assume the environment does not allow you to store 64-bit integers (signed or unsigned).*

#let reverse-integer(x) = {
  // Solve the problem here
}

#testcases(
  reverse-integer,
  reverse-integer-ref, (
    (x: 123),
    (x: -123),
    (x: 120),
    (x: 0),
    (x: 23498423),
    (x: -213898800),
    (x: 1534236469),
    (x: 2147483647),
    (x: -2147483648),
  )
)
