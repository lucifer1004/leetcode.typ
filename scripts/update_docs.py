#!/usr/bin/env python3
"""Generate docs/index.html from template with actual problem count."""

from pathlib import Path


def count_problems() -> int:
    """Count problem directories in problems/."""
    problems_dir = Path("problems")
    if not problems_dir.exists():
        return 0
    return len([d for d in problems_dir.iterdir() if d.is_dir()])


def generate_html(count: int) -> bool:
    """Generate index.html from template."""
    template_path = Path("docs/index.html.template")
    output_path = Path("docs/index.html")

    if not template_path.exists():
        print(f"Error: {template_path} not found")
        return False

    content = template_path.read_text()
    content = content.replace("{{PROBLEM_COUNT}}", str(count))

    output_path.write_text(content)
    print(f"Generated {output_path} with {count} problems")
    return True


def main():
    """Main entry point."""
    count = count_problems()
    print(f"Found {count} problems")
    success = generate_html(count)
    exit(0 if success else 1)


if __name__ == "__main__":
    main()
