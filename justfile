set dotenv-load
python := env_var_or_default("BOOK_PYTHON", "uv run --locked python")

default: build

build:
    {{python}} scripts/project.py build

check:
    {{python}} scripts/project.py check

fmt:
    {{python}} scripts/project.py fmt

corrections:
    {{python}} scripts/project.py corrections
