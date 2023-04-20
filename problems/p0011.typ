#import "../helpers.typ": *
#import "../solutions/s0011.typ": *

= Container With Most Water

You are given an integer array height of length n. There are n vertical lines drawn such that the two endpoints of the i#super[th] line are `(i, 0)` and `(i, height[i])`.

Find two lines that together with the x-axis form a container, such that the container contains the most water.

Return the maximum amount of water a container can store.

*Notice* that you may not slant the container.

#let container-with-most-water(height) = {
  // Solve the problem here
}

#testcases(
  container-with-most-water,
  container-with-most-water-ref, (
    (height: (1, 8, 6, 2, 5, 4, 8, 3, 7)),
    (height: (1, 1))
  )
)
