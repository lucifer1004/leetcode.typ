fmt:
  ruff check --fix .
  ruff format .
  typstyle -i .

create id:
  python3 scripts/create.py {{id}}
