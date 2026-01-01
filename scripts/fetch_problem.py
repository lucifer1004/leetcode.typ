#!/usr/bin/env python3
"""
Fetch LeetCode problem data from GraphQL API.

Usage:
    python scripts/fetch_problem.py 1           # Fetch problem #1 info
    python scripts/fetch_problem.py 1 --save    # Fetch and save to drafts/
    python scripts/fetch_problem.py 1-10 --save # Fetch problems 1-10
    python scripts/fetch_problem.py two-sum     # Fetch by slug

Output is saved to drafts/ directory as JSON files for manual review.
Use scripts/create.py to create actual problem files in problems/ directory.

Note: This uses LeetCode's public GraphQL API. Be respectful of rate limits.
"""

import argparse
import json
import sys
import time
from pathlib import Path
from typing import Optional

# Optional: requests for API calls
try:
    import requests
except ImportError:
    print("Error: requests library required. Install with: pip install requests")
    sys.exit(1)

# LeetCode GraphQL endpoint
LEETCODE_GRAPHQL_URL = "https://leetcode.com/graphql"

# GraphQL query for problem data
QUESTION_QUERY = """
query questionData($titleSlug: String!) {
  question(titleSlug: $titleSlug) {
    questionId
    questionFrontendId
    title
    titleSlug
    difficulty
    content
    topicTags {
      name
      slug
    }
    exampleTestcases
    codeSnippets {
      langSlug
      code
    }
    hints
  }
}
"""

# API endpoint for problems list
LEETCODE_PROBLEMS_API = "https://leetcode.com/api/problems/algorithms/"

# Output directory
DRAFTS_DIR = Path("drafts")


def fetch_problems_list() -> dict:
    """Fetch list of all problems to get ID -> slug mapping."""
    headers = {
        "User-Agent": "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7)",
    }

    try:
        response = requests.get(LEETCODE_PROBLEMS_API, headers=headers)
        response.raise_for_status()
        data = response.json()

        problems = data.get("stat_status_pairs", [])

        # Create mapping: frontend_id -> question_data
        result = {}
        for p in problems:
            stat = p.get("stat", {})
            frontend_id = stat.get("frontend_question_id")
            if frontend_id and isinstance(frontend_id, int):
                result[frontend_id] = {
                    "questionId": str(stat.get("question_id", "")),
                    "questionFrontendId": str(frontend_id),
                    "title": stat.get("question__title", ""),
                    "titleSlug": stat.get("question__title_slug", ""),
                    "difficulty": {1: "Easy", 2: "Medium", 3: "Hard"}.get(
                        p.get("difficulty", {}).get("level"), "Unknown"
                    ),
                    "isPaidOnly": p.get("paid_only", False),
                }
        return result
    except requests.RequestException as e:
        print(f"Error fetching problems list: {e}", file=sys.stderr)
        return {}


def fetch_problem_detail(title_slug: str) -> Optional[dict]:
    """Fetch detailed problem data from GraphQL API."""
    headers = {
        "Content-Type": "application/json",
        "User-Agent": "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7)",
        "Referer": f"https://leetcode.com/problems/{title_slug}/",
    }

    payload = {
        "query": QUESTION_QUERY,
        "variables": {"titleSlug": title_slug},
    }

    try:
        response = requests.post(LEETCODE_GRAPHQL_URL, json=payload, headers=headers)
        response.raise_for_status()
        data = response.json()
        return data.get("data", {}).get("question")
    except requests.RequestException as e:
        print(f"Error fetching problem {title_slug}: {e}", file=sys.stderr)
        return None


def save_problem_data(problem_id: int, data: dict, force: bool = False) -> bool:
    """Save raw problem data to drafts directory as JSON."""
    DRAFTS_DIR.mkdir(parents=True, exist_ok=True)

    output_file = DRAFTS_DIR / f"{problem_id:04d}.json"

    if output_file.exists() and not force:
        print(f"  File {output_file} already exists. Use --force to overwrite.")
        return False

    output_file.write_text(json.dumps(data, indent=2, ensure_ascii=False))
    print(f"✓ Saved {output_file}")
    return True


def main():
    parser = argparse.ArgumentParser(
        description="Fetch LeetCode problem data from GraphQL API"
    )
    parser.add_argument(
        "problem",
        type=str,
        help="Problem ID (e.g., 1) or range (e.g., 1-10) or slug (e.g., two-sum)",
    )
    parser.add_argument(
        "--save",
        action="store_true",
        help="Save raw JSON data to drafts/ directory",
    )
    parser.add_argument(
        "--force",
        action="store_true",
        help="Overwrite existing files",
    )
    parser.add_argument(
        "--json",
        action="store_true",
        help="Output raw JSON data to stdout",
    )
    parser.add_argument(
        "--delay",
        type=float,
        default=1.0,
        help="Delay between requests in seconds (default: 1.0)",
    )

    args = parser.parse_args()

    # Parse problem argument
    problems_to_fetch = []

    # Check if it's a range (e.g., "1-10")
    if "-" in args.problem and args.problem.replace("-", "").isdigit():
        start, end = map(int, args.problem.split("-"))
        problems_to_fetch = list(range(start, end + 1))
    # Check if it's a single number
    elif args.problem.isdigit():
        problems_to_fetch = [int(args.problem)]
    # Otherwise treat as slug
    else:
        # Fetch by slug directly
        data = fetch_problem_detail(args.problem)
        if data:
            problem_id = int(data["questionFrontendId"])
            if args.json:
                print(json.dumps(data, indent=2, ensure_ascii=False))
            elif args.save:
                save_problem_data(problem_id, data, args.force)
            else:
                print(f"Problem: {data['title']}")
                print(f"ID: {data['questionFrontendId']}")
                print(f"Difficulty: {data['difficulty']}")
                print(
                    f"Tags: {', '.join(t['name'] for t in data.get('topicTags', []))}"
                )
                print(f"\nUse --save to save to drafts/{problem_id:04d}.json")
        else:
            print(f"Failed to fetch problem: {args.problem}")
            sys.exit(1)
        return

    # Fetch problems list for ID -> slug mapping
    print("Fetching problems list...")
    problems_map = fetch_problems_list()

    if not problems_map:
        print("Failed to fetch problems list. Try again later.", file=sys.stderr)
        sys.exit(1)

    print(f"Found {len(problems_map)} problems in database.")

    # Process each problem
    success_count = 0
    for problem_id in problems_to_fetch:
        if problem_id not in problems_map:
            print(f"✗ Problem {problem_id} not found (might be premium-only)")
            continue

        problem_info = problems_map[problem_id]

        if problem_info.get("isPaidOnly"):
            print(f"✗ Problem {problem_id} ({problem_info['title']}) is premium-only")
            continue

        title_slug = problem_info["titleSlug"]
        print(f"Fetching problem {problem_id}: {problem_info['title']}...")

        data = fetch_problem_detail(title_slug)

        if not data:
            print(f"✗ Failed to fetch problem {problem_id}")
            continue

        if args.json:
            print(json.dumps(data, indent=2, ensure_ascii=False))
        elif args.save:
            if save_problem_data(problem_id, data, args.force):
                success_count += 1
        else:
            print(f"  Title: {data['title']}")
            print(f"  Difficulty: {data['difficulty']}")
            print(f"  Tags: {', '.join(t['name'] for t in data.get('topicTags', []))}")

        # Rate limiting
        if len(problems_to_fetch) > 1:
            time.sleep(args.delay)

    if args.save and len(problems_to_fetch) > 1:
        print(
            f"\nSaved {success_count}/{len(problems_to_fetch)} problems to {DRAFTS_DIR}/"
        )


if __name__ == "__main__":
    main()
