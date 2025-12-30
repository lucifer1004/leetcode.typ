#import "lib.typ": problem, test

// Test Problem 1 with auto test cases
#problem(1)

#let my-solution(nums, target) = {
  // Simple test
  (0, 1)
}

#test(1, my-solution)

#pagebreak()

// Test Problem 51 with metadata (chessboard rendering)
#problem(51)

#let my-solution(n) = {
  ()
}

#test(51, my-solution, extra-cases: (
  (n: 6)
))
