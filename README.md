# leetcode.typ - Solving LeetCode problems in Typst

![Logo](images/logo.png)

A showcase project demonstrating Typst's capabilities by implementing LeetCode solutions entirely in Typst's scripting language, with automatic test case visualization.

## Features

- 🎨 Beautiful PDF output with automatic formatting
- 📝 Test case visualization with side-by-side comparison
- 🔧 Live preview while coding
- ✅ Automatic pass/fail indicators for test cases
- 🚀 Clean separation between problems, solutions, and references

## Prerequisites

Install [typst](https://github.com/typst/typst):

```bash
# macOS
brew install typst

# Other platforms: see https://github.com/typst/typst#installation
```

## Quick Start

### Working on a Problem

1. **Open a user solution file**
   ```bash
   # For example, Problem 1 - Two Sum
   code user-solutions/u0001.typ
   ```

2. **Start live preview**
   ```bash
   typst watch user-solutions/u0001.typ
   ```
   Or use [Tinymist](https://github.com/Myriad-Dreamin/tinymist), which is a powerful integrated language service for Typst.

3. **Write your solution**
   Find the "Your Solution" section in the file and implement the function:
   ```typst
   #let two-sum(nums, target) = {
     // Your implementation here
   }
   ```

4. **See results instantly**
   The PDF updates automatically, showing:
   - Your output
   - Expected output
   - ✓ Pass / ✗ Fail status

### Creating a New Problem

```bash
python3 scripts/create.py 19
```

This will interactively prompt you for:
- Problem title
- Function name (auto-generated from title)
- Function parameters
- Problem description (optional)

And automatically creates:
- `problems/p0019.typ` - Problem description
- `user-solutions/u0019.typ` - Your workspace
- `reference-solutions/s0019.typ` - Reference solution
- Updates `leetcode.typ` to include the new problem

**Non-interactive mode:**
```bash
python3 scripts/create.py 20 \
  --title "Valid Parentheses" \
  --func "valid-parentheses" \
  --params "s"
```

### Building the Complete PDF

```bash
typst compile leetcode.typ
```

This generates `leetcode.pdf` with all problems.

## Project Structure

```
leetcode.typ/
├── problems/              # Problem descriptions (read-only)
│   ├── p0001.typ         # Two Sum
│   ├── p0002.typ         # Add Two Numbers
│   └── ...
│
├── user-solutions/        # Your workspace (edit here!)
│   ├── u0001.typ         # Problem + your code + tests
│   ├── u0002.typ
│   └── ...
│
├── reference-solutions/   # Reference implementations
│   ├── s0001.typ
│   ├── s0002.typ
│   └── ...
│
├── helpers.typ           # Utility functions
├── leetcode.typ          # Main file (includes all problems)
└── scripts/
    └── create.py         # Tool to create new problems
```

## File Format

### User Solution File (`user-solutions/u0001.typ`)

This is your main workspace. Each file contains:

```typst
#import "../helpers.typ": *

// ========================================
// Problem Description
// ========================================
#include "../problems/p0001.typ"

// ========================================
// Your Solution - Write your code here
// ========================================
#let two-sum(nums, target) = {
  // TODO: Implement your solution
  
  none
}

// ========================================
// Test Cases
// ========================================
#import "../reference-solutions/s0001.typ": two-sum-ref
#testcases(two-sum, two-sum-ref, (
  (nums: (2, 7, 11, 15), target: 9),
  (nums: (3, 2, 4), target: 6),
  (nums: (3, 3), target: 6),
))
```

**Key sections:**
1. **Problem Description** - Automatically included from `problems/`
2. **Your Solution** - Write your implementation here
3. **Test Cases** - Automatically compares your output with reference

### Problem File (`problems/p0001.typ`)

Pure problem statement, reusable across the project:

```typst
= Two Sum

Given an array of integers `nums` and an integer `target`, return indices...
```

### Reference Solution (`reference-solutions/s0001.typ`)

The expected implementation:

```typst
#import "../helpers.typ": *

#let two-sum-ref(nums, target) = {
  // Reference implementation
  ...
}
```

## Tips & Tricks

### Viewing a Single Problem

```bash
# Quick preview of just one problem
typst watch user-solutions/u0005.typ
```

### Hiding Reference Solutions

Comment out the import if you want to work without seeing the reference:

```typst
// #import "../reference-solutions/s0001.typ": two-sum-ref
```

### Adding More Test Cases

Just add entries to the test cases tuple:

```typst
#testcases(two-sum, two-sum-ref, (
  (nums: (2, 7, 11, 15), target: 9),
  (nums: (3, 2, 4), target: 6),
  // Add your own:
  (nums: (0, 0), target: 0),
))
```

### Helper Functions Available

See `helpers.typ` for utilities:
- `linkedlist(array)` - Create a linked list
- `display(value)` - Format output
- `testcases(fn, ref, inputs)` - Run test suite
- `testcases(fn, ref, inputs, comparator: fn)` - Run test suite with custom comparator
- `unordered-compare` - Comparator for problems where order doesn't matter

#### Using Custom Comparators

For problems that specify "You may return the answer in any order", use the `unordered-compare` comparator:

```typst
#testcases(solution, solution-ref, (
  (input: value),
), comparator: unordered-compare)
```

You can also define your own comparators for special cases:

```typst
// Example: Compare with floating point tolerance
#let float-compare(a, b) = {
  calc.abs(a - b) < 0.0001
}

#testcases(solution, solution-ref, inputs, comparator: float-compare)
```

## Why Typst?

This project explores using Typst not just as a typesetting system, but as a functional programming language for algorithm implementation. While not optimal for production code, it demonstrates:

- Typst's expressiveness as a scripting language
- Pattern matching and functional programming concepts
- Beautiful output generation
- An interesting constraint for problem-solving

## Example Output

See [build/leetcode.pdf](./build/leetcode.pdf) for example output.

## Contributing

Feel free to add more problems! Use `python3 scripts/create.py <id>` to maintain consistency.

## License

This is a personal learning project. LeetCode problems belong to LeetCode.
