#import "../helpers.typ": *

// ========================================
// Problem Description
// ========================================
#include "../problems/p0019.typ"

// ========================================
// Your Solution - Write your code here
// ========================================
#let remove-nth-node-from-end-of-list(head, n) = {}

// ========================================
// Test Cases
// ========================================
#import "../reference-solutions/s0019.typ": remove-nth-node-from-end-of-list-ref
#testcases(
  remove-nth-node-from-end-of-list,
  remove-nth-node-from-end-of-list-ref,
  (
    (head: linkedlist((1, 2, 3, 4, 5)), n: 2),
    (head: linkedlist((1,)), n: 1),
    (head: linkedlist((1, 2)), n: 1),
  ),
)
