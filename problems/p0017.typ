#import "../helpers.typ": *
#import "../solutions/s0017.typ": *

= Letter Combinations of a Phone Number

Given a string containing digits from `2-9` inclusive, return all possible letter combinations that the number could represent. Return the answer in *any order*.

A mapping of digits to letters (just like on the telephone buttons) is given below. Note that 1 does not map to any letters.

#align(center)[#image("../images/p0017.png", width: 300pt)]

#let letter-combinations-of-a-phone-number(digits) = {
  // Solve the problem here
}

#testcases(
  letter-combinations-of-a-phone-number,
  letter-combinations-of-a-phone-number-ref, (
    (digits: "23"),
    (digits: ""),
    (digits: "2")
  )
)
