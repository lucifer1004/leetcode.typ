#!/usr/bin/env python3
"""Generate docs from templates with actual problem data."""

import sys
import tomllib
from pathlib import Path


def get_problems() -> list[dict]:
    """Get all problems from problems/ directory."""
    problems_dir = Path("problems")
    if not problems_dir.exists():
        return []

    problems = []
    for d in sorted(problems_dir.iterdir()):
        if not d.is_dir():
            continue
        toml_path = d / "problem.toml"
        if not toml_path.exists():
            continue

        problem_id = int(d.name)
        with open(toml_path, "rb") as f:
            data = tomllib.load(f)

        problems.append(
            {
                "id": problem_id,
                "title": data.get("title", "Untitled"),
                "difficulty": data.get("difficulty", "medium").capitalize(),
            }
        )

    return problems


def generate_problem_table(problems: list[dict]) -> str:
    """Generate markdown table for README."""
    lines = [
        "| ID  | Title                                          | Difficulty |",
        "| --- | ---------------------------------------------- | ---------- |",
    ]

    for p in problems:
        # Pad title to 46 chars for alignment
        title = p["title"][:46].ljust(46)
        difficulty = p["difficulty"].ljust(10)
        lines.append(f"| {p['id']:<3} | {title} | {difficulty} |")

    return "\n".join(lines)


def generate_file(template_path: Path, output_path: Path, replacements: dict) -> bool:
    """Generate file from template with replacements."""
    if not template_path.exists():
        print(f"Error: {template_path} not found", file=sys.stderr)
        return False

    content = template_path.read_text()
    for key, value in replacements.items():
        content = content.replace(f"{{{{{key}}}}}", str(value))

    # Check if content changed
    if output_path.exists() and output_path.read_text() == content:
        return True  # No change needed

    output_path.write_text(content)
    print(f"Generated {output_path}")
    return True


def main():
    """Main entry point."""
    problems = get_problems()
    count = len(problems)
    print(f"Found {count} problems")

    table = generate_problem_table(problems)

    replacements = {
        "PROBLEM_COUNT": count,
        "PROBLEM_TABLE": table,
    }

    success = True
    success &= generate_file(
        Path("README.md.template"), Path("README.md"), replacements
    )
    success &= generate_file(
        Path("docs/index.html.template"), Path("docs/index.html"), replacements
    )

    sys.exit(0 if success else 1)


if __name__ == "__main__":
    main()
