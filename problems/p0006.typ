#import "../helpers.typ": *
#import "../solutions/s0006.typ": *

= Zigzag Conversion

The string "PAYPALISHIRING" is written in a zigzag pattern on a given number of rows like this:

```
P   A   H   N
A P L S I I G
Y   I   R
```

And then read line by line: "PAHNAPLSIIGYIR"

Write the code that will take a string and make this conversion given a number of rows.

#let zigzag-conversion(s, numRows) = {
  // Solve the problem here
}

#testcases(
  zigzag-conversion,
  zigzag-conversion-ref, (
    (s: "PAYPALISHIRING", numRows: 3),
    (s: "PAYPALISHIRING", numRows: 4),
    (s: "A", numRows: 1),
  )
)
