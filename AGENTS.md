# AGENTS Guide

This repository is a Typst package for solving LeetCode problems. It provides a framework with built-in test cases, reference solutions, and beautiful PDF rendering. Use this guide to understand the architecture and contribute.

## Project Architecture

This is a **Typst package** (`@preview/leetcode`) with modular, DAG-based design:

```
problems/XXXX/           # Each problem is self-contained
├── problem.toml         # Metadata (title, difficulty, labels, comparator)
├── description.typ      # Problem statement
├── solution.typ         # Reference solution (#let solution)
└── testcases.typ        # Built-in test cases (pure data)
```

### Module Structure (DAG - No Circular Dependencies)

```
  datastructures.typ  ← pure data structures, no dependencies
         ↑
     utils.typ        ← utility functions
         ↑
    display.typ       ← depends on utils, datastructures, visualize
         ↑
    testing.typ       ← depends on display
         ↑
    helpers.typ       ← re-exports all modules (backward compatibility)
         ↑
      lib.typ         ← package API entrypoint
```

### Key Files

| File                 | Purpose                                                      |
| -------------------- | ------------------------------------------------------------ |
| `lib.typ`            | Package API entrypoint (exports `problem()`, `test()`, etc.) |
| `helpers.typ`        | Re-exports all helper modules for backward compatibility     |
| `datastructures.typ` | Data structures: `linkedlist`, `binarytree`, `ll-*` helpers  |
| `utils.typ`          | Utilities: `fill`, `chessboard`, comparators                 |
| `display.typ`        | Display logic: `display()` function                          |
| `testing.typ`        | Test framework: `testcases()` function                       |
| `visualize.typ`      | Visualization: binary tree and linked list rendering         |
| `leetcode.typ`       | Generates complete PDF (excluded from package)               |
| `scripts/create.py`  | Scaffolds new problems                                       |
| `typst.toml`         | Package manifest                                             |

## Adding a Problem

1. Run `just create <id>` or `python3 scripts/create.py <id>` to generate:

   ```
   problems/XXXX/
   ├── problem.toml      # Metadata
   ├── description.typ   # Problem statement
   ├── solution.typ      # Reference solution
   └── testcases.typ     # Test cases
   ```

2. The script will prompt for:
   - **Title**: Problem name
   - **Difficulty**: `easy`, `medium`, or `hard`
   - **Labels**: Comma-separated tags (e.g., `array,hash-table`)
   - **Parameters**: Function parameters for the solution

3. Fill in the generated files:
   - **testcases.typ**: Add test cases
     ```typst
     #let cases = (
       (nums: (1, 2, 3), target: 6),
     )
     ```
   - **solution.typ**: Implement `solution` function

4. For problems needing special handling, add to `problem.toml`:
   ```toml
   comparator = "unordered-compare"
   render-chessboard = true
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

This creates a comprehensive PDF with all 38 problems and their reference solutions.

## Architecture Principles

### Domain-Driven Design

- **High Cohesion**: All files for Problem 1 live in `problems/0001/`
- **Built-in Test Cases**: Users get test cases automatically
- **Metadata Support**: Comparators and rendering options in `problem.toml`

### Modular Design (DAG)

- **No circular dependencies**: Each module only imports from modules above it
- **Single responsibility**: Each file has one clear purpose
- **Backward compatibility**: `helpers.typ` re-exports everything

### Unified API

```typst
// Use built-in cases
#test(1, solution)

// Add extra cases
#test(1, solution, extra-cases: ((nums: (99, 1), target: 100),))

// Only custom cases
#test(1, solution, extra-cases: (...), default-cases: false)
```

## Module Reference

### datastructures.typ

Pure data structure definitions, no dependencies.

| Function            | Description                               |
| ------------------- | ----------------------------------------- |
| `linkedlist(arr)`   | Create flat linked list from array        |
| `ll-node(list, id)` | Get node by ID                            |
| `ll-val(list, id)`  | Get value at node ID                      |
| `ll-next(list, id)` | Get next node ID                          |
| `ll-values(list)`   | Get all values as array                   |
| `binarytree(arr)`   | Create binary tree from level-order array |

**Linked list structure** (flat dict with string ID pointers):

```typst
(
  type: "linkedlist",
  head: "0",
  nodes: (
    "0": (val: 1, next: "1"),
    "1": (val: 2, next: none),
  )
)
```

### utils.typ

Utility functions, no external dependencies.

| Function                  | Description                     |
| ------------------------- | ------------------------------- |
| `fill(value, n)`          | Create array with n copies      |
| `is-chessboard(value)`    | Check if value is a 2D board    |
| `chessboard(board)`       | Render chessboard visualization |
| `unordered-compare(a, b)` | Compare ignoring order          |
| `float-compare(a, b)`     | Compare floats with tolerance   |

### display.typ

Display logic, depends on datastructures, utils, visualize.

| Constant                   | Value | Description                     |
| -------------------------- | ----- | ------------------------------- |
| `MAX-ARRAY-DISPLAY`        | 210   | Array truncation threshold      |
| `MAX-ARRAY-PREVIEW`        | 100   | Elements to show when truncated |
| `MAX-STRING-DISPLAY`       | 1050  | String truncation threshold     |
| `MAX-LINKEDLIST-VISUALIZE` | 8     | Max nodes for visual rendering  |

| Function                                   | Description             |
| ------------------------------------------ | ----------------------- |
| `display(value, render-chessboard: false)` | Format value for output |

### testing.typ

Test framework, depends on display.

| Function                                      | Description                  |
| --------------------------------------------- | ---------------------------- |
| `testcases(solution, reference, inputs, ...)` | Run and display test results |

### visualize.typ

Data structure visualization, depends on external packages (cetz, fletcher).

| Constant               | Value  | Description                   |
| ---------------------- | ------ | ----------------------------- |
| `DEFAULT-TREE-SPREAD`  | 0.8    | Binary tree horizontal spread |
| `DEFAULT-TREE-GROW`    | 0.6    | Binary tree vertical grow     |
| `DEFAULT-TREE-RADIUS`  | 0.3    | Node circle radius            |
| `DEFAULT-LIST-SPACING` | 1.2em  | Linked list node spacing      |
| `DEFAULT-CYCLE-BEND`   | -40deg | Cycle edge bend angle         |

| Function                          | Description                                  |
| --------------------------------- | -------------------------------------------- |
| `visualize-binarytree(root, ...)` | Render binary tree diagram                   |
| `visualize-linkedlist(list, ...)` | Render linked list diagram (supports cycles) |

### lib.typ

Package API entrypoint, re-exports helpers and adds high-level functions.

| Function                | Description                                 |
| ----------------------- | ------------------------------------------- |
| `problem(id)`           | Display problem description with difficulty |
| `test(id, fn, ...)`     | Test solution with built-in/custom cases    |
| `answer(id)`            | Display reference solution code             |
| `solve(id, code-block)` | Display code and test in one call           |
| `get-test-cases(id)`    | Get built-in test cases                     |
| `get-problem-path(id)`  | Get problem directory path                  |
| `get-problem-info(id)`  | Get metadata from problem.toml              |

**Comparator dispatch table** (extensible):

```typst
#let comparators = (
  "unordered-compare": unordered-compare,
  "float-compare": float-compare,
)
```

## Import Patterns

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

**For fine-grained imports** (advanced):

```typst
#import "datastructures.typ": linkedlist, ll-values
#import "utils.typ": unordered-compare
```

## Package Development

### Local Testing

Use `lib.typ` directly instead of package import:

```typst
#import "lib.typ": problem, test
```

### Before Releasing

1. Run `just build` — ensures complete PDF compiles
2. Test the package API with example files in `templates/`
3. Update version in `typst.toml`
4. Update README with new features
5. Verify exclusions are correct

### Excluded from Package

These files exist in the repo but are excluded from the published package:

- `leetcode.typ` — local development tool
- `templates/` — examples (referenced in README)
- `scripts/` — maintenance tools
- `build/` — compiled PDFs
- `draft.typ` — scratch file
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

### Add a new comparator

1. Add function to `utils.typ`:

   ```typst
   #let my-compare(a, b) = { /* ... */ }
   ```

2. Add to dispatch table in `lib.typ`:

   ```typst
   #let comparators = (
     "unordered-compare": unordered-compare,
     "float-compare": float-compare,
     "my-compare": my-compare,  // add this
   )
   ```

3. Use in problem.toml:
   ```toml
   comparator = "my-compare"
   ```

### Add a new data structure

1. Add to `datastructures.typ` (no dependencies allowed)
2. Add visualization to `visualize.typ` if needed
3. Update `display.typ` to handle the new type
4. Export from `helpers.typ` (automatic via `*`)

## Verification Checklist

Before committing:

1. Run `just build` — ensures complete PDF compiles
2. Run `just fmt` — format Python code
3. New problems have at least one test case
4. Reference solution passes its own tests
5. Documentation updated (README, AGENTS.md)
6. No circular dependencies in module imports

## Problem Metadata (problem.toml)

Each problem has a `problem.toml` file with metadata:

```toml
title = "Two Sum"
difficulty = "easy"
labels = ["array", "hash-table"]

# Optional fields (with defaults)
# comparator = "unordered-compare"
# render-chessboard = true
```

**Required fields**:

- `title`: Problem name
- `difficulty`: `"easy"`, `"medium"`, or `"hard"`
- `labels`: Array of topic tags

**Optional fields** (for special handling):

- `comparator`: Custom comparison function for test results
- `render-chessboard`: Display 2D arrays as chessboards

**Common labels** (based on LeetCode categories):

- `array`, `string`, `hash-table`, `math`
- `two-pointers`, `sliding-window`, `binary-search`
- `linked-list`, `tree`, `graph`
- `stack`, `queue`, `heap`
- `dynamic-programming`, `greedy`, `backtracking`
- `divide-and-conquer`, `recursion`
- `sorting`, `bit-manipulation`

## Linked List Data Structure

The linked list uses a **flat dict with string ID pointers** instead of nested dicts:

**Old (nested, O(n²) traversal)**:

```typst
(val: 1, next: (val: 2, next: (val: 3, next: none)))
```

**New (flat, O(n) traversal)**:

```typst
(
  type: "linkedlist",
  head: "0",
  nodes: (
    "0": (val: 1, next: "1"),
    "1": (val: 2, next: "2"),
    "2": (val: 3, next: none),
  )
)
```

**Benefits**:

- O(1) node access instead of O(n) deep copy
- Supports cyclic linked lists (just point next to existing ID)
- More memory efficient for large lists

**Usage in solutions**:

```typst
#let solution(head) = {
  // Option 1: Get all values as array (most common)
  let vals = ll-values(head)

  // Option 2: Manual traversal
  let curr = head.head
  while curr != none {
    let val = ll-val(head, curr)
    // ... process val ...
    curr = ll-next(head, curr)
  }
}
```

Happy Typst hacking!
