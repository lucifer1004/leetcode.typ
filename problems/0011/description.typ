#import "../../helpers.typ": display
#import "testcases.typ": cases

= Container With Most Water

You are given an integer array height of length n. There are n vertical lines drawn such that the two endpoints of the i#super[th] line are `(i, 0)` and `(i, height[i])`.

Find two lines that together with the x-axis form a container, such that the container contains the most water.

Return the maximum amount of water a container can store.

*Notice* that you may not slant the container.

#let container-diagram(height) = {
  if height.len() == 0 { return }

  // Find the optimal two lines using two-pointer approach
  let n = height.len()
  let left = 0
  let right = n - 1
  let max-area = 0
  let best-left = 0
  let best-right = n - 1

  while left < right {
    let h = calc.min(height.at(left), height.at(right))
    let area = h * (right - left)
    if area > max-area {
      max-area = area
      best-left = left
      best-right = right
    }
    if height.at(left) < height.at(right) {
      left += 1
    } else {
      right -= 1
    }
  }

  let max-height = calc.max(..height)
  let water-level = calc.min(height.at(best-left), height.at(best-right))

  // Render grid from top to bottom
  let rows = ()
  for row in range(max-height).rev() {
    // Y-axis label
    let y-label = box(
      width: 2em,
      height: 1.2em,
      align(end + horizon, text(size: 0.9em, str(row + 1))),
    )

    // Grid cells for this row
    let row-cells = (y-label,)
    for col in range(n) {
      let h = height.at(col)
      let is-selected = col == best-left or col == best-right
      let in-container = col > best-left and col <= best-right

      // Determine borders
      let borders = (:)

      // Axis lines
      if col == 0 {
        borders.insert("left", 1pt + black)
      }
      if row == 0 {
        borders.insert("bottom", 1pt + black)
      }

      // Vertical line at this position (right border)
      if row < h {
        if is-selected {
          borders.insert("right", 2pt + red)
        } else {
          borders.insert("right", 1pt + black)
        }
      }

      // Fill: only water area
      let fill-color = if row < water-level and in-container {
        rgb("#4A90E2")
      } else {
        none
      }

      let cell = box(
        width: 1.2em,
        height: 1.2em,
        inset: 1pt,
        stroke: borders,
        fill: fill-color,
      )
      row-cells.push(cell)
    }
    rows.push(row-cells)
  }

  // X-axis labels
  let x-labels = (box(width: 2em),) // Empty space for Y-axis corner
  for i in range(n) {
    x-labels.push(
      box(
        width: 1.2em,
        height: 1.5em,
        align(center + top, text(size: 0.9em, str(i))),
      ),
    )
  }
  rows.push(x-labels)

  // Flatten and render
  let all-cells = ()
  for row in rows {
    all-cells = all-cells + row
  }

  // Column gutter: only between Y-axis labels (col 0) and data (col 1+)
  let col-gutters = (0.3em,) + range(n - 1).map(_ => 0pt)

  // Row gutter: only between last data row and X-axis labels
  let num-gaps = rows.len() - 1
  let row-gutters = range(num-gaps).map(i => {
    if i == num-gaps - 1 { 0.3em } else { 0pt }
  })

  grid(
    columns: n + 1,
    column-gutter: col-gutters,
    row-gutter: row-gutters,
    ..all-cells
  )
}

#for (idx, testcase) in cases.enumerate() {
  heading(level: 2, outlined: false, numbering: none, [Example #(idx + 1)])
  [
    *height*: #display(testcase.height)
    #container-diagram(testcase.height)
  ]
}
