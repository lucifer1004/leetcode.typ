#import "../../helpers.typ": binarytree

// Test cases for Populating Next Right Pointers
// Input: root (binary tree)
// Expected output: tree with next pointers populated
// We verify by checking that each node's next points to correct node ID

#let cases = (
  // Perfect binary tree [1,2,3,4,5,6,7]
  // After: 1->none, 2->3, 3->none, 4->5, 5->6, 6->7, 7->none
  (root: binarytree((1, 2, 3, 4, 5, 6, 7))),
  // Single node
  (root: binarytree((1,))),
  // Empty tree
  (root: binarytree(())),
  // Two levels [1,2,3]
  (root: binarytree((1, 2, 3))),
)
