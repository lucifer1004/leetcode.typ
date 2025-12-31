# AGENTS Guide

This repository is a Typst package for solving LeetCode problems. It provides a framework with built-in test cases, reference solutions, and beautiful PDF rendering. Use this guide to understand the architecture and contribute.

## Project Architecture

This is now a **Typst package** (`@preview/leetcode`) with domain-driven design:

```
problems/XXXX/           # Each problem is self-contained
├── description.typ      # Problem statement
├── solution.typ         # Reference solution (#let solution)
└── testcases.typ        # Built-in test cases + metadata
```

### Key Files

- `lib.typ` — Package API entrypoint (exports `problem()`, `test()`, etc.)
- `helpers.typ` — Shared utilities (`linkedlist`, `display`, `testcases`, comparators)
- `leetcode.typ` — Generates complete PDF with all problems (excluded from package)
- `templates/` — Example usage files for package users (excluded from package)
- `scripts/create.py` — Scaffolds new problems in the correct structure
- `typst.toml` — Package manifest

## Adding a Problem

1. Run `just create <id>` or `python3 scripts/create.py <id>` to generate:
   ```
   problems/XXXX/
   ├── description.typ
   ├── solution.typ
   └── testcases.typ
   ```

2. Fill in the generated files:
   - **description.typ**: Problem title and description
   - **testcases.typ**: Add test cases (can import helpers if needed)
     ```typst
     #import "../../helpers.typ": linkedlist
     #let cases = (
       (input: value),
     )
     ```
   - **solution.typ**: Implement `solution` function

3. For problems needing special handling, add metadata to `testcases.typ`:
   ```typst
   #let metadata = (
     comparator: "unordered-compare",
     render-chessboard: true,
   )
   ```

## Testing Your Changes

### Test a Single Problem

Package users would use:
```typst
#import "@preview/leetcode:0.1.0": problem, test

#problem(1)
#let solution(nums, target) = { /* your implementation */ }
#test(1, solution)
```

For local testing, use `lib.typ` directly:
```typst
#import "lib.typ": problem, test

#problem(1)
#let solution(nums, target) = { /* your implementation */ }
#test(1, solution)
```

### Generate Complete PDF

```bash
just build
# or
typst compile leetcode.typ build/leetcode.pdf
```

This creates a comprehensive PDF with all 21 problems and their reference solutions.

## Architecture Principles

### Domain-Driven Design

✅ **High Cohesion**: All files for Problem 1 live in `problems/0001/`
- Easy to find everything related to a problem
- Clear ownership and organization
- Simple to add/remove problems

✅ **Built-in Test Cases**: Users get test cases automatically
- No need to write test cases manually
- Consistent testing across all problems
- Metadata for special requirements (comparators, rendering)

✅ **Unified API**: Single `test()` function with flexible modes
```typst
// Use built-in cases
#test(1, solution)

// Add extra cases
#test(1, solution, extra-cases: ((nums: (99, 1), target: 100),))

// Only custom cases
#test(1, solution, extra-cases: (...), default-cases: false)
```

### Import Patterns

**In testcases.typ** (if using helpers):
```typst
#import "../../helpers.typ": linkedlist
```

**In solution.typ**:
```typst
#import "../../helpers.typ": *
```

**In user code** (package users):
```typst
#import "@preview/leetcode:0.1.0": problem, test, linkedlist
```

## Helpers Module

`helpers.typ` provides:

- **Data structures**: `linkedlist(array)` — creates linked list nodes
- **Display**: `display(value, render-chessboard: false)` — pretty-prints values
- **Testing**: `testcases(fn, ref, cases, ...)` — renders test results
- **Comparators**: `unordered-compare(a, b)` — order-insensitive comparison
- **Utilities**: `fill(value, n)`, `chessboard(board)`, `is-chessboard(value)`

When extending helpers:
- Keep backward-compatible signatures
- Favor reusable utilities over problem-specific code
- Document complex functions

## Public API Functions

The `lib.typ` exports these functions for users:

- **`problem(id)`** — Display problem description
- **`test(id, fn, ...)`** — Test solution with built-in/custom cases
- **`solution(id)`** — Display reference solution code (for learning)
- **`get-test-cases(id)`** — Get built-in test cases
- **`get-problem-path(id)`** — Get problem directory path

These are all available via `#import "@preview/leetcode:0.1.0": problem, test, solution`

## Package Development

### Local Testing

Use `lib.typ` directly instead of package import:
```typst
#import "lib.typ": problem, test
```

### Before Releasing

1. ✅ All problems compile without errors: `just build`
2. ✅ Test the package API with example files in `templates/`
3. ✅ Update version in `typst.toml`
4. ✅ Update README with new features
5. ✅ Verify exclusions are correct (no user-solutions, build/, etc.)

### Excluded from Package

These files exist in the repo but are excluded from the published package:
- `leetcode.typ` — local development tool
- `templates/` — examples (referenced in README)
- `scripts/` — maintenance tools
- `build/` — compiled PDFs
- `Justfile`, `AGENTS.md` — development docs

## Common Tasks

### Add a new test case to existing problem

Edit `problems/XXXX/testcases.typ`:
```typst
#let cases = (
  // existing cases
  (nums: (1, 2, 3), target: 6),  // add this
)
```

### Fix a reference solution

Edit `problems/XXXX/solution.typ` and implement `solution` function.

### Update problem description

Edit `problems/XXXX/description.typ`. 
⚠️ If using images, use path `../../images/pXXXX.png`

### Test metadata handling

Problems with metadata automatically apply comparators/rendering:
```typst
// In testcases.typ
#let metadata = (
  comparator: "unordered-compare",
  render-chessboard: true,
)

// User doesn't need to specify these!
#test(51, solution)  // Automatically uses metadata
```

## Verification Checklist

Before committing:

1. ✅ Run `just build` — ensures complete PDF compiles
2. ✅ Check `just fmt` — format Python code
3. ✅ New problems have at least one test case
4. ✅ Reference solution passes its own tests
5. ✅ Documentation updated (README, AGENTS.md)
6. ✅ No references to old structure (user-solutions/, reference-solutions/)

## Migration Notes

**Old structure (before package conversion)**:
```
problems/pXXXX.typ
reference-solutions/sXXXX.typ  
user-solutions/uXXXX.typ
```

**New structure (domain-driven)**:
```
problems/XXXX/
├── description.typ
├── solution.typ
└── testcases.typ
```

Key changes:
- Unified `test()` API instead of separate `test-auto()` and `test()`
- Test cases are data files (can import helpers if needed)
- Metadata in testcases.typ for special requirements
- Package-first design for easy distribution

Happy Typst hacking! 🚀
