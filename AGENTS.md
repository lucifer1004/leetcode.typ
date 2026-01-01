# AGENTS Guide

LeetCode problem solving framework in Typst. Built-in test cases, reference solutions, beautiful PDF rendering.

## Quick Start

```bash
# Create new problem
just create 123

# Test locally
typst compile draft.typ --root .

# Build complete PDF
just build
```

## Project Structure

```
problems/XXXX/           # Each problem is self-contained
├── problem.toml         # Metadata (title, difficulty, labels)
├── description.typ      # Problem statement
├── solution.typ         # Reference solution
├── testcases.typ        # Test cases (no expected values!)
└── display.typ          # Optional: custom display
```

### Module DAG

```
datastructures.typ → utils.typ → display.typ → testing.typ → helpers.typ
                                                    ↓
state.typ ──→ problems.typ ──→ badges.typ ──→ render.typ ──→ workbook.typ ──→ lib.typ
              validators.typ ────────────────────────↑
```

## Adding a Problem

### Required Files

**problem.toml**:

```toml
title = "Two Sum"
difficulty = "easy"
labels = ["array", "hash-table"]
# Optional: validator = "unordered-compare" | "custom"
# Optional: custom-display = true
```

**testcases.typ** — NO `expected:` field, reference solution generates it:

```typst
#let cases = (
  (input: (nums: (2, 7, 11, 15), target: 9)),
  (input: (nums: (3, 2, 4), target: 6)),
)
```

**solution.typ**:

```typst
#import "../../helpers.typ": *

#let solution(nums, target) = {
  // Implementation
}
```

### Testing

```typst
// draft.typ - basic testing
#import "lib.typ": problem, test
#problem(123)
#import "problems/0123/solution.typ": solution
#test(123, solution)
```

### Practice Mode

````typst
// my-practice.typ - practice workbook
#import "lib.typ": conf, solve

#show: conf.with(
  practice: true,
  show-answer: false,  // Set true to see reference solutions
)

// View problem + write solution + test
#solve(1, code-block: ```typc
let solution(nums, target) = {
  // Your implementation
  none
}
```)

// Just view problem (no solution yet)
#solve(15)

// View with reference answer
#solve(42, show-answer: true)

// Add extra test cases
#solve(1, code-block: ```typc
let solution(nums, target) = { ... }
```, extra-cases: (
  (input: (nums: (99, 1), target: 100)),
))
````

### Filtered Mode

```typst
// filtered.typ - auto-render filtered problems
#import "lib.typ": conf

#show: conf.with(
  difficulty: "easy",        // Filter by difficulty
  labels: ("array",),        // Filter by labels
  id-range: (1, 50),         // Filter by ID range
  show-answer: true,         // Show reference solutions
)
```

### Special Cases

| Need                   | Add to problem.toml               | Create file     |
| :--------------------- | :-------------------------------- | :-------------- |
| Unordered output       | `validator = "unordered-compare"` | —               |
| Multiple valid answers | `validator = "custom"`            | `validator.typ` |
| Custom input display   | `custom-display = true`           | `display.typ`   |
| Custom output display  | `custom-output-display = true`    | `display.typ`   |

See examples: `problems/0005/` (custom validator), `problems/0289/` (custom display), `problems/0547/` (chessboard display).

## Typst Mutability Rules

**Critical for algorithm implementation:**

| Context                     | Mutable? |
| :-------------------------- | :------: |
| In for/while loop           |    ✅    |
| Function parameter          |    ✅    |
| Closure capturing outer var |    ❌    |

### Implication: Union-Find

Closures can't modify captured state. Do modifications **in the loop**:

```typst
// find() returns (root, path) — READ-ONLY
let find(p, x) = { ... (root, path) }

for edge in edges {
  let (root, path) = find(parent, x)
  // Modify IN THE LOOP
  for node in path { parent.at(node) = root }
}
```

See: `problems/0547/solution.typ`

### Implication: Backtracking

**Option 1 (preferred): Stack simulation**

```typst
let stack = (...)
let result = ()
while stack.len() > 0 {
  result.push(...)  // ✅ Modify in loop
}
```

**Option 2: Return value accumulation** (has O(k) copy overhead)

```typst
let backtrack(...) = {
  result += backtrack(...)  // Each += copies
}
```

See: `problems/0039/solution.typ`

## Data Structures

### linkedlist / binarytree

Flat dict with string ID pointers + closure accessors:

```typst
#let list = linkedlist((1, 2, 3))
// list.head = "0"
// (list.get-val)("0") → 1
// (list.get-next)("0") → "1"
// (list.values)() → (1, 2, 3)
```

⚠️ Closures are **read-only** — they capture `nodes` but can't modify it.

See: `datastructures.typ` for full structure definitions.

## Description Style

| Type             | Syntax          | Example                      |
| :--------------- | :-------------- | :--------------------------- |
| Code identifiers | `` `name` ``    | `` `nums` ``, `` `target` `` |
| Math variables   | `$n$`           | `$n$`, `$k$`, `$m times n$`  |
| Complexity       | `$cal(O)(...)$` | `$cal(O)(n log n)$`          |
| Emphasis         | `*text*`        | `*unique*`, `*palindrome*`   |

## Common Pitfalls

```typst
// ❌ Closure can't modify outer var
let result = ()
let f() = { result.push(x) }  // Error!

// ❌ Missing input: wrapper
(nums: (1, 2, 3))
// ✅ Correct
(input: (nums: (1, 2, 3)))

// ❌ Hardcoded expected
(input: (...), expected: 42)
// ✅ Let reference solution compute it
(input: (...))
```

## Verification Checklist

- [ ] `just build` succeeds
- [ ] Reference solution passes tests
- [ ] No `expected:` in testcases
- [ ] Added to `available-problems` in `problems.typ`
