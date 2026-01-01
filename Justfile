fmt:
  ruff check --fix .
  ruff format .
  typstyle -i .
  prettier --write .

# Create a new problem (usage: just create 22)
create id:
  python3 scripts/create.py {{id}}

# Update docs/index.html with actual problem count
update-docs:
  python3 scripts/update_docs.py

# Build the complete PDF with all problems
build:
  typst compile leetcode.typ build/leetcode.pdf
  pdfcpu optimize build/leetcode.pdf
