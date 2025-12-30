fmt:
  ruff check --fix .
  ruff format .
  typstyle -i .

create id:
  python3 scripts/create.py {{id}}

build:
  typst compile leetcode.typ build/leetcode.pdf
  pdfcpu optimize build/leetcode.pdf
