# AGENTS Guide

This repository solves LeetCode problems entirely in [Typst](https://typst.app/). Each problem lives in its own pair of user/reference solution files with a shared helpers module for rendering rich PDF output. Use this guide to onboard quickly.

## Project Map

- `problems/pXXXX.typ` — read-only problem statements.
- `user-solutions/uXXXX.typ` — editable workspace for each problem: imports helpers, includes the problem text, exposes a `#let` function you must implement, and defines local tests.
- `reference-solutions/sXXXX.typ` — canonical implementations; used as ground-truth for tests.
- `helpers.typ` — shared utilities such as `fill`, `display`, chessboard rendering, and `testcases`.
- `leetcode.typ` — roots the PDF; simply imports every `user-solutions/*`.
- `scripts/create.py` — scaffolds new problems and keeps `leetcode.typ` sorted.

## Adding a Problem

1. Run `python3 scripts/create.py <id>` (or the non-interactive form described in `README.md`) to generate:
   - `problems/p<id>.typ`
   - `user-solutions/u<id>.typ`
   - `reference-solutions/s<id>.typ`
   and to update `leetcode.typ`.
2. Review the generated stubs. The script lets you override the function name and parameters; ensure the names stay in kebab-case to match Typst conventions.
3. When committing, include all three new files plus the updated `leetcode.typ`.

## Solving a Problem

1. Work inside `user-solutions/uXXXX.typ`:
   - Keep the `#import "../helpers.typ": *` at the top.
   - Implement the function in the “Your Solution” section. Typst functions return values directly; avoid global state because Typst closures capture by value.
2. Use `typst watch user-solutions/uXXXX.typ` (or Tinymist) for a rapid PDF preview focused on one problem.
3. The `#testcases` macro compares your solution with the reference. Arguments:
   - `solution` / `reference` functions
   - a tuple of dictionaries describing inputs (`(n: 4,)`, etc.)
   - optional `comparator` (e.g., `unordered-compare` for order-insensitive arrays)
   - optional `render-chessboard: true` to use the chessboard visualizer for board-like outputs (N-Queens).
4. When you need custom comparators or displays, add them to `helpers.typ` and import them where needed.

## Improving Display & Helpers

- `helpers.typ` offers:
  - `display(value, render-chessboard: false)` — recursively renders values. Pass `render-chessboard: true` from `#testcases` to render `'Q'`/`.` boards using the built-in `chessboard` helper; otherwise plain arrays are shown.
  - `testcases(...)` — renders each example as a boxed block mimicking LeetCode’s “Example” layout. It accepts the `render-chessboard` flag to forward into every `display`.
  - Comparators such as `unordered-compare` for set-like outputs.
- When extending helpers:
  - Keep existing function signatures backward-compatible (prefer optional parameters, default values).
  - Favor reusable utilities over per-problem tweaks.
  - If you add domain-specific renderers (e.g., linked lists), wire them into `display` via simple type checks.

## Reference Solutions

Reference files mirror the user solution signature with a `-ref` suffix. They should remain deterministic and side-effect free, as `testcases` runs them on every refresh. When updating helpers, ensure you do not break any reference implementations; rebuild `leetcode.typ` locally (`typst compile leetcode.typ`) if in doubt.

## Verification Checklist

Before opening a PR or finalizing a change:
1. Run `typst watch user-solutions/uXXXX.typ` (or compile `leetcode.typ`) to verify the PDF renders without errors.
2. Ensure all new problems include at least one representative testcase.
3. Keep documentation (README, this AGENTS guide) in sync when you modify workflows.

Happy Typst hacking!
