#!/usr/bin/env python3
"""Create new problem files."""

import argparse
from pathlib import Path
import re
import sys

# Template definitions
PROBLEM_TOML_TEMPLATE = """title = "{title}"
difficulty = "{difficulty}"
labels = [{labels}]
"""

DESCRIPTION_TEMPLATE = """= {id:04}. {title}

{description}
"""

TESTCASES_TEMPLATE = """// Test cases for Problem {id:04}
#let cases = (
  // Add test cases here
  // Example: (input: value),
)
"""

SOLUTION_TEMPLATE = """#import "../../helpers.typ": *

#let solution({params}) = {{
  // Reference solution implementation
  
  none
}}
"""

# Valid difficulty levels
DIFFICULTIES = ("easy", "medium", "hard")

# Common labels for reference
COMMON_LABELS = [
    "array",
    "string",
    "hash-table",
    "math",
    "two-pointers",
    "sliding-window",
    "binary-search",
    "linked-list",
    "tree",
    "graph",
    "stack",
    "queue",
    "heap",
    "dynamic-programming",
    "greedy",
    "backtracking",
    "divide-and-conquer",
    "recursion",
    "sorting",
    "bit-manipulation",
]

parser = argparse.ArgumentParser(prog="create", description="Create new problem files")

parser.add_argument("id", type=int, help="Problem ID")
parser.add_argument(
    "--title", "-t", type=str, help="Problem title (interactive if not provided)"
)
parser.add_argument(
    "--difficulty",
    "-d",
    type=str,
    choices=DIFFICULTIES,
    help="Problem difficulty (easy, medium, hard)",
)
parser.add_argument("--labels", "-l", type=str, help="Problem labels (comma-separated)")
parser.add_argument(
    "--params", "-p", type=str, default="", help="Function parameters (comma-separated)"
)


def slugify(title):
    """Convert title to function name."""
    slug = title.lower()
    slug = re.sub(r"[^\w\s-]", "", slug)
    slug = re.sub(r"[-\s]+", "-", slug)
    return slug


def create_problem(
    problem_id: int,
    title: str = None,
    difficulty: str = None,
    labels: str = None,
    params: str = "",
) -> bool:
    """Create new problem files. Returns True on success."""
    problem_dir = Path("problems") / f"{problem_id:04}"
    problem_toml_path = problem_dir / "problem.toml"
    description_path = problem_dir / "description.typ"
    testcases_path = problem_dir / "testcases.typ"
    solution_path = problem_dir / "solution.typ"

    # Check if directory already exists
    if problem_dir.exists():
        print(f"Problem directory {problem_dir} already exists!")
        return False

    # Interactive input (if not provided)
    if not title:
        title = input("Problem title: ").strip()
        if not title:
            print("Title is required")
            return False

    if not difficulty:
        print(f"Difficulty [{'/'.join(DIFFICULTIES)}]: ", end="")
        difficulty = input().strip().lower()
        if difficulty not in DIFFICULTIES:
            print(f"Invalid difficulty. Must be one of: {', '.join(DIFFICULTIES)}")
            return False

    if not labels:
        print("Labels (comma-separated, e.g., array,hash-table): ", end="")
        labels = input().strip()

    if not params:
        params = input("Function parameters (comma-separated) []: ").strip()
        params = ", ".join(p.strip() for p in params.split(",") if p.strip())

    description = input("Problem description (optional, press Enter to skip): ").strip()

    # Format labels for TOML
    label_list = [label.strip() for label in labels.split(",") if label.strip()]
    labels_toml = ", ".join(f'"{label}"' for label in label_list)

    # Create files
    try:
        # Create problem directory
        problem_dir.mkdir(parents=True, exist_ok=True)

        # Create problem.toml
        toml_content = PROBLEM_TOML_TEMPLATE.format(
            title=title, difficulty=difficulty, labels=labels_toml
        )
        problem_toml_path.write_text(toml_content)
        print(f"Created {problem_toml_path}")

        # Create problem description
        desc_content = DESCRIPTION_TEMPLATE.format(
            id=problem_id, title=title, description=description
        )
        description_path.write_text(desc_content)
        print(f"Created {description_path}")

        # Create testcases file
        testcases_content = TESTCASES_TEMPLATE.format(id=problem_id)
        testcases_path.write_text(testcases_content)
        print(f"Created {testcases_path}")

        # Create reference solution file
        ref_content = SOLUTION_TEMPLATE.format(params=params)
        solution_path.write_text(ref_content)
        print(f"Created {solution_path}")

        print(f"\nProblem {problem_id:04} created successfully!")
        print("\nNext steps:")
        print(f"   1. Add test cases to {testcases_path}")
        print(f"   2. Implement reference solution in {solution_path}")
        print('   3. Use: #import "@preview/leetcode:0.1.0": problem, test')
        print(f"   4. Then: #problem({problem_id}) and #test({problem_id}, solution)")

        return True

    except (OSError, UnicodeEncodeError) as e:
        # Clean up created directory
        if problem_dir.exists():
            import shutil

            shutil.rmtree(problem_dir)
        print(f"Error: {e}", file=sys.stderr)
        return False


def main():
    """Main entry point."""
    args = parser.parse_args()
    success = create_problem(
        args.id,
        title=args.title,
        difficulty=args.difficulty,
        labels=args.labels,
        params=args.params,
    )
    sys.exit(0 if success else 1)


if __name__ == "__main__":
    main()
