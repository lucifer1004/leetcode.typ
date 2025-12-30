#import "../helpers.typ": *

// This problem is an excellent example where the stdlib can greatly save our effort
#let integer-to-roman-ref(num) = {
  numbering("I", num)
}
