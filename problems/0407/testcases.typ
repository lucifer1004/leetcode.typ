#let cases = (
  // Example 1: 3x6 grid, traps 4 units of water
  (
    input: (
      heightMap: (
        (1, 4, 3, 1, 3, 2),
        (3, 2, 1, 3, 2, 4),
        (2, 3, 3, 2, 3, 1),
      ),
    ),
  ),
  // Example 2: 5x5 grid (bowl shape)
  (
    input: (
      heightMap: (
        (3, 3, 3, 3, 3),
        (3, 2, 2, 2, 3),
        (3, 2, 1, 2, 3),
        (3, 2, 2, 2, 3),
        (3, 3, 3, 3, 3),
      ),
    ),
  ),
  // Example 3: 3x3 simple bowl
  (
    input: (
      heightMap: (
        (1, 2, 1),
        (2, 0, 2),
        (1, 2, 1),
      ),
    ),
  ),
  // Example 4: flat surface (no water)
  (
    input: (
      heightMap: (
        (1, 1, 1),
        (1, 1, 1),
        (1, 1, 1),
      ),
    ),
  ),
  // Example 5: 2x2 grid (too small to trap water)
  (
    input: (
      heightMap: (
        (1, 2),
        (2, 1),
      ),
    ),
  ),
)
