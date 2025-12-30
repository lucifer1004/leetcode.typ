fmt:
  ruff check --fix .
  ruff format .
  typstyle -i .

# Create a new problem (usage: just create 22)
create id:
  python3 scripts/create.py {{id}}

# Build the complete PDF with all problems
build:
  typst compile leetcode.typ build/leetcode.pdf
  pdfcpu optimize build/leetcode.pdf
