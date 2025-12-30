#import "lib.typ": answer, problem, test

// Test Problem 1 with auto test cases
#problem(1)

#let solution(nums, target) = {
  // Simple test
  (0, 1)
}

#test(1, solution)

#answer(1)

#pagebreak()

// Test Problem 51 with metadata (chessboard rendering)
#problem(51)

#let solution(n) = {
  ()
}

#test(51, solution, extra-cases: (
  (n: 6)
))
