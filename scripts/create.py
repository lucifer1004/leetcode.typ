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

TESTCASES_TEMPLATE = """// Test cases for Problem {id:04}
// Import helpers if needed (e.g., linkedlist, fill, etc.)
// #import "../../helpers.typ": linkedlist

#let cases = (
  // Add test cases here
  // Example: (input: value),
)
"""

SOLUTION_TEMPLATE = """#import "../../helpers.typ": *

#let solution-ref({params}) = {{
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


def update_leetcode_typ(problem_id: int):
    """Insert problem include line in sorted order."""
    # Note: leetcode.typ is now excluded from package, but we keep this for local development
    if not Path("leetcode.typ").exists():
        return

    with open("leetcode.typ", "r", encoding="utf-8") as f:
        lines = f.readlines()

    # Find where includes start (after the header setup)
    include_start = 0
    for i, line in enumerate(lines):
        if line.strip().startswith('#include "problems/'):
            include_start = i
            break

    # Extract existing includes
    includes = []
    other_lines = lines[:include_start]

    for line in lines[include_start:]:
        stripped = line.strip()
        if stripped.startswith('#include "problems/'):
            includes.append(line)
        elif stripped:  # Non-include, non-empty line
            other_lines.append(line)

    # Add new include - note: we don't have user-solutions anymore, skip if that's what this was for
    # For now, we'll skip adding to leetcode.typ since it's not part of the package workflow

    # Sort by problem ID extracted from filename
    def extract_id(include_line):
        match = re.search(r"problems/(\d{4})/", include_line)
        return int(match.group(1)) if match else 0

    includes.sort(key=extract_id)

    # Write back
    with open("leetcode.typ", "w", encoding="utf-8") as f:
        f.writelines(other_lines)
        f.writelines(includes)


def create_problem(
    problem_id: int, title: str = None, func_name: str = None, params: str = ""
) -> bool:
    """Create new problem files. Returns True on success."""
    problem_dir = Path("problems") / f"{problem_id:04}"
    problem_path = problem_dir / "description.typ"
    testcases_path = problem_dir / "testcases.typ"
    solution_path = problem_dir / "solution.typ"

    # Check if directory already exists
    if problem_dir.exists():
        print(f"❌ Problem directory {problem_dir} already exists!")
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
        # Create problem directory
        problem_dir.mkdir(parents=True, exist_ok=True)

        # Create problem description
        problem_content = PROBLEM_TEMPLATE.format(title=title, description=description)
        problem_path.write_text(problem_content)
        print(f"✓ Created {problem_path}")

        # Create testcases file
        testcases_content = TESTCASES_TEMPLATE.format(id=problem_id)
        testcases_path.write_text(testcases_content)
        print(f"✓ Created {testcases_path}")

        # Create reference solution file
        ref_content = SOLUTION_TEMPLATE.format(params=params)
        solution_path.write_text(ref_content)
        print(f"✓ Created {solution_path}")

        # Update main file with sorted insertion
        update_leetcode_typ(problem_id)
        print("✓ Updated leetcode.typ")

        print(f"\n✅ Problem {problem_id:04} created successfully!")
        print("\n📝 Next steps:")
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
