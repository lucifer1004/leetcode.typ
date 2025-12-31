// Test cases for Problem 0112
// Import helpers if needed (e.g., linkedlist, fill, etc.)
#import "../../helpers.typ": binarytree

#let cases = (
  (
    root: binarytree((5, 4, 8, 11, none, 13, 4, 7, 2, none, none, none, 1)),
    target-sum: 22,
  ),
  (root: binarytree((1, 2, 3)), target-sum: 5),
  (root: binarytree(()), target-sum: 0),
)
