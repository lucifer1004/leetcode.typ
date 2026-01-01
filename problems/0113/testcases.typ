// Test cases for Problem 0113
#import "../../helpers.typ": binarytree

#let cases = (
  (
    root: binarytree((5, 4, 8, 11, none, 13, 4, 7, 2, none, none, 5, 1)),
    target-sum: 22,
  ),
  (root: binarytree((1, 2, 3)), target-sum: 5),
  (root: binarytree(()), target-sum: 0),
)
