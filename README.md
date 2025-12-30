# leetcode - LeetCode Problem-Solving Framework in Typst

![Logo](images/logo.png)

A Typst package for solving LeetCode problems with beautiful PDF output and automatic test case visualization. Import the package and start coding – built-in test cases included!

## Features

- 📦 **Zero Setup**: Import and start solving – built-in test cases for all problems
- 🎨 **Beautiful Output**: Automatic formatting with professional PDF rendering  
- 📝 **Test Visualization**: Side-by-side comparison of your output vs. expected results
- ✅ **Auto-Validation**: Instant pass/fail indicators
- 🚀 **21 Problems**: Curated collection of classic LeetCode problems
- 🔧 **Extensible**: Custom comparators, chessboard rendering, and more

## Installation

```typst
#import "@preview/leetcode:0.1.0": problem, test
```

## Quick Start

Create a new `.typ` file:

```typst
#import "@preview/leetcode:0.1.0": problem, test

// Display the problem
#problem(1)

// Write your solution
#let solution(nums, target) = {
  let d = (:)
  for (i, num) in nums.enumerate() {
    if str(target - num) in d {
      return (d.at(str(target - num)), i)
    }
    d.insert(str(num), i)
  }
  none
}

// Test with built-in test cases!
#test(1, solution)
```

If you want to display your solution, you can try

```typst
#import "@preview/leetcode:0.1.0": solve

#solve(1, ```typc
let solution(nums, target) = {
  let d = (:)
  let ans = (-1, -1)
  for (i, num) in nums.enumerate() {
    if str(target - num) in d {
      return (d.at(str(target - num)), i)
    }
    d.insert(str(num), i)
  }
  ans
}
```)
```

- The main function name needs to be `solution` when using the `solve()` API.

Compile:
```bash
typst compile my-solution.typ
```

Or live preview:
```bash
typst watch my-solution.typ
```

## Available Problems

| ID | Title | Difficulty |
|----|-------|------------|
| 1 | Two Sum | Easy |
| 2 | Add Two Numbers | Medium |
| 3 | Longest Substring Without Repeating Characters | Medium |
| 4 | Median of Two Sorted Arrays | Hard |
| 5 | Longest Palindromic Substring | Medium |
| 6 | Zigzag Conversion | Medium |
| 7 | Reverse Integer | Medium |
| 8 | String to Integer (atoi) | Medium |
| 9 | Palindrome Number | Easy |
| 10 | Regular Expression Matching | Hard |
| 11 | Container With Most Water | Medium |
| 12 | Integer to Roman | Medium |
| 13 | Roman to Integer | Easy |
| 14 | Longest Common Prefix | Easy |
| 15 | 3Sum | Medium |
| 16 | 3Sum Closest | Medium |
| 17 | Letter Combinations of a Phone Number | Medium |
| 18 | 4Sum | Medium |
| 19 | Remove Nth Node From End of List | Medium |
| 20 | Valid Parentheses | Easy |
| 51 | N-Queens | Hard |

## Multiple Problems in One File

Solve multiple problems by reusing the `solution` name:

```typst
#import "@preview/leetcode:0.1.0": problem, test

// Problem 1
#problem(1)
#let solution(nums, target) = { /* ... */ }
#test(1, solution)

// Problem 2
#pagebreak()
#problem(2)
#let solution(l1, l2) = { /* ... */ }
#test(2, solution)
```

## Advanced Usage

### Adding Extra Test Cases

Add your own test cases on top of built-in ones:

```typst
#import "@preview/leetcode:0.1.0": problem, test

#problem(1)
#let solution(nums, target) = { /* ... */ }

// Built-in cases + your extra cases
#test(1, solution, extra-cases: (
  (nums: (99, 1), target: 100),
  (nums: range(1000), target: 999),
))
```

### Using Only Custom Test Cases

Override built-in cases completely:

```typst
#test(1, solution, 
  extra-cases: (
    (nums: (1, 2, 3), target: 5),
  ),
  default-cases: false)
```

### Unordered Output

For problems with "return answer in any order":

```typst
#import "@preview/leetcode:0.1.0": problem, test

#problem(15)  // 3Sum
#let solution(nums) = { /* ... */ }

// Metadata is handled automatically!
#test(15, solution)  // Uses unordered-compare automatically
```

### Chessboard Rendering

For problems like N-Queens:

```typst
#import "@preview/leetcode:0.1.0": problem, test

#problem(51)
#let solution(n) = { /* ... */ }

// Chessboard rendering enabled automatically!
#test(51, solution)
```

### Viewing Reference Solutions

Stuck on a problem? View the reference solution code:

```typst
#import "@preview/leetcode:0.1.0": problem, solution

#problem(1)
// ... tried but couldn't solve it ...

// Display the reference solution code
#solution(1)
```

### Manual Reference Access

For advanced control:

```typst
#import "@preview/leetcode:0.1.0": problem, get-test-cases, get-problem-path

// Get built-in test cases
#let cases = get-test-cases(1)

// Get problem directory path
#let path = get-problem-path(1)
#import (path + "solution.typ"): solution-ref
```

## API Reference

### Main Functions

- `problem(id)` - Display problem statement
- `test(id, fn)` - Test with built-in cases (recommended)
- `test(id, fn, extra-cases: (...), default-cases: false)` - Customize test cases
- `solution(id)` - Display reference solution code (when stuck)
- `get-test-cases(id)` - Get built-in test cases
- `get-problem-path(id)` - Get problem directory path

### Helper Functions

- `testcases(fn, ref, cases, ...)` - Manual test comparison
- `linkedlist(array)` - Create linked list from array
- `display(value)` - Format values for output
- `unordered-compare(a, b)` - Compare ignoring order
- `fill(value, n)` - Create array with n copies
- `chessboard(board)` - Render chessboard visualization

## Examples

Check out [templates/](templates/) for examples:
- `single-problem.typ` - Single problem workflow
- `multiple-problems.typ` - Multiple problems in one file

## Architecture

Each problem is organized as:

```
problems/XXXX/
├── description.typ    # Problem statement
├── solution.typ       # Reference solution
└── testcases.typ      # Test cases + metadata
```

**Testcases can use helper functions**:
```typst
// testcases.typ
#import "../../helpers.typ": linkedlist

#let cases = (
  (head: linkedlist((1, 2, 3)), n: 2),
)
```

This design ensures:
- **High cohesion**: All files for a problem are together
- **Built-in tests**: No need to write test cases
- **Metadata support**: Comparators and rendering options included
- **Helper access**: Testcases can use linkedlist, fill, etc.

## Tips

### Linked Lists

```typst
#import "@preview/leetcode:0.1.0": linkedlist

#let l1 = linkedlist((1, 2, 3))
#let l2 = linkedlist((4, 5, 6))
```

### Live Preview

Use Typst's watch mode or [Tinymist](https://github.com/Myriad-Dreamin/tinymist) for instant feedback.

### Adding Your Own Test Cases

Mix built-in and custom cases:

```typst
#test(1, solution, extra-cases: (
  (nums: (0, 0), target: 0),
  (nums: range(100), target: 99),
))
```

## Why Typst?

This project explores Typst as a functional programming language for algorithms, demonstrating:

- **Expressive syntax** for pattern matching and FP
- **Beautiful output** with minimal effort
- **Rapid feedback** with live preview
- **Creative constraints** that enhance problem-solving

## Contributing

Maintained at [github.com/lucifer1004/leetcode.typ](https://github.com/lucifer1004/leetcode.typ).

To add problems, use:
```bash
python3 scripts/create.py <problem-id>
```

## License

MIT License - see LICENSE file for details.

LeetCode problems © LeetCode.
