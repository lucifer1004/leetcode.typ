#!/usr/bin/env python3
"""Create new problem files."""

import argparse
from pathlib import Path
import re
import sys

# Template definitions
PROBLEM_TEMPLATE = """= {title}

{description}
"""

USER_SOLUTION_TEMPLATE = """#import "../helpers.typ": *

// ========================================
// Problem Description
// ========================================
#include "../problems/p{id:04}.typ"

// ========================================
// Your Solution - Write your code here
// ========================================
#let {func_name}({params}) = {{
  // TODO: Implement your solution
  
  none
}}

// ========================================
// Test Cases
// ========================================
#import "../reference-solutions/s{id:04}.typ": {func_name}-ref
#testcases({func_name}, {func_name}-ref, (
  // Add test cases here
  // Example: (input: value),
))
"""

REFERENCE_SOLUTION_TEMPLATE = """#import "../helpers.typ": *

#let {func_name}-ref({params}) = {{
  // Reference solution implementation
  
  none
}}
"""

parser = argparse.ArgumentParser(prog="create", description="Create new problem files")

parser.add_argument("id", type=int, help="Problem ID")
parser.add_argument(
    "--title", "-t", type=str, help="Problem title (interactive if not provided)"
)
parser.add_argument(
    "--func",
    "-f",
    type=str,
    help="Function name (auto-generated from title if not provided)",
)
parser.add_argument(
    "--params", "-p", type=str, default="", help="Function parameters (comma-separated)"
)


def slugify(title):
    """Convert title to function name."""
    # Convert to lowercase and replace spaces with hyphens
    slug = title.lower()
    slug = re.sub(r"[^\w\s-]", "", slug)
    slug = re.sub(r"[-\s]+", "-", slug)
    return slug


def create_problem(
    problem_id: int, title: str = None, func_name: str = None, params: str = ""
) -> bool:
    """Create new problem files. Returns True on success."""
    problem_path = Path("problems") / f"p{problem_id:04}.typ"
    user_path = Path("user-solutions") / f"u{problem_id:04}.typ"
    solution_path = Path("reference-solutions") / f"s{problem_id:04}.typ"

    # Check if files already exist
    if problem_path.exists():
        print(f"❌ Problem file {problem_path} already exists!")
        return False
    if user_path.exists():
        print(f"❌ User solution file {user_path} already exists!")
        return False
    if solution_path.exists():
        print(f"❌ Reference solution file {solution_path} already exists!")
        return False

    # Interactive input (if not provided)
    if not title:
        title = input("Problem title: ").strip()
        if not title:
            print("❌ Title is required")
            return False

    if not func_name:
        func_name = slugify(title)
        confirm = input(f"Function name [{func_name}]: ").strip()
        if confirm:
            func_name = confirm

    if not params:
        params = input("Function parameters (comma-separated) []: ").strip()
        params = ", ".join(params.split(","))

    description = input("Problem description (optional, press Enter to skip): ").strip()

    # Create files
    try:
        # Create pure problem file
        problem_content = PROBLEM_TEMPLATE.format(title=title, description=description)
        problem_path.write_text(problem_content)
        print(f"✓ Created {problem_path}")

        # Create user solution file
        user_content = USER_SOLUTION_TEMPLATE.format(
            id=problem_id, func_name=func_name, params=params
        )
        user_path.write_text(user_content)
        print(f"✓ Created {user_path}")

        # Create reference solution file
        ref_content = REFERENCE_SOLUTION_TEMPLATE.format(
            func_name=func_name, params=params
        )
        solution_path.write_text(ref_content)
        print(f"✓ Created {solution_path}")

        # Update main file
        with open("leetcode.typ", "a", encoding="utf-8") as f:
            f.write(f'#include "user-solutions/u{problem_id:04}.typ"\n')
        print("✓ Updated leetcode.typ")

        print(f"\n✅ Problem {problem_id:04} created successfully!")
        print("\n📝 Next steps:")
        print(f"   1. Edit {user_path} to start solving")
        print(f"   2. Preview: typst watch {user_path}")
        print("   3. Add test cases in the user solution file")

        return True

    except (OSError, UnicodeEncodeError) as e:
        # Clean up created files
        problem_path.unlink(missing_ok=True)
        user_path.unlink(missing_ok=True)
        solution_path.unlink(missing_ok=True)
        print(f"❌ Error: {e}", file=sys.stderr)
        return False


def main():
    """Main entry point."""
    args = parser.parse_args()
    success = create_problem(
        args.id, title=args.title, func_name=args.func, params=args.params
    )
    sys.exit(0 if success else 1)


if __name__ == "__main__":
    main()
