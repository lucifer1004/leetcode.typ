// Showcase of visualizations for README
#set page(width: auto, height: auto, margin: 1em)
#set text(font: "New Computer Modern")

// Import display functions
#import "../problems/0218/display.typ": custom-display as skyline-display
#import "../problems/0042/display.typ": custom-display as rain-display
#import "../problems/0407/display.typ": custom-display as rain3d-display
#import "../problems/0011/display.typ": custom-display as container-display

= LeetCode.typ Visualizations

== 0218. The Skyline Problem
#skyline-display((
  buildings: (
    (2, 9, 10),
    (3, 7, 15),
    (5, 12, 12),
    (15, 20, 10),
    (19, 24, 8),
  ),
))

#pagebreak()

== 0407. Trapping Rain Water II (3D)
#rain3d-display((
  heightMap: (
    (3, 3, 3, 3, 3),
    (3, 2, 2, 5, 3),
    (3, 2, 5, 2, 5),
    (3, 2, 2, 5, 3),
    (3, 3, 3, 3, 3),
  ),
))

#pagebreak()

== 0042. Trapping Rain Water
#rain-display((height: (0, 1, 0, 2, 1, 0, 1, 3, 2, 1, 2, 1)))

#pagebreak()

== 0011. Container With Most Water
#container-display((height: (1, 8, 6, 2, 5, 4, 8, 3, 7)))
