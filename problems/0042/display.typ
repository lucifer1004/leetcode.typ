// Trapping Rain Water - custom display with water visualization
#import "../../helpers.typ": display

#let custom-display(input) = {
  let height = input.height

  // Show raw data first
  [*height:* #display(height)]
  linebreak()

  if height.len() == 0 { return }

  // Calculate water level at each position
  let n = height.len()
  let left-max = height.map(_ => 0)
  let right-max = height.map(_ => 0)

  // Left pass
  left-max.at(0) = height.at(0)
  for i in range(1, n) {
    left-max.at(i) = calc.max(left-max.at(i - 1), height.at(i))
  }

  // Right pass
  right-max.at(n - 1) = height.at(n - 1)
  for i in range(n - 1).rev() {
    right-max.at(i) = calc.max(right-max.at(i + 1), height.at(i))
  }

  // Water at each position
  let water = range(n).map(i => calc.max(
    0,
    calc.min(left-max.at(i), right-max.at(i)) - height.at(i),
  ))
  let max-height = calc.max(..height)

  // Render main grid with Y-axis labels
  let rows = ()
  for row in range(max-height).rev() {
    // Y-axis label
    let y-label = box(
      width: 2em,
      height: 1.2em,
      align(right + horizon, text(size: 0.9em, str(row + 1))),
    )

    // Grid cells for this row
    let row-cells = (y-label,)
    for col in range(n) {
      let h = height.at(col)
      let w = water.at(col)
      let water-level = h + w

      // Determine borders: left border for first column, bottom border for bottom row
      let borders = (:)
      if col == 0 {
        borders.insert("left", 1pt + black)
      }
      if row == 0 {
        borders.insert("bottom", 1pt + black)
      }

      let cell = if row < h {
        box(width: 1.2em, height: 1.2em, fill: black, stroke: borders)
      } else if row < water-level {
        box(width: 1.2em, height: 1.2em, fill: rgb("#4A90E2"), stroke: borders)
      } else {
        box(width: 1.2em, height: 1.2em, stroke: borders)
      }
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
