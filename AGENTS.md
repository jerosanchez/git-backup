# AI Agents Instructions

## Markdown content

To ensure that AI-generated markdown content passes linting checks, follow these guidelines:

- Surround lists with blank lines.
- Add blank lines before and after headings.
- Do not exceed 80 characters per line unless necessary (line length is ignored, but keep lines readable).
- Use proper indentation for nested lists and code blocks.
- Use fenced code blocks (triple backticks) for code snippets.
- Avoid trailing spaces at the end of lines.
- End files with a single newline.
- Use consistent heading levels and formatting.

These rules help prevent markdownlint errors and keep documentation clean and readable.

## Bash script content

To ensure that AI-generated bash scripts are safe, readable, and pass linting checks (e.g., ShellCheck), follow these guidelines:

- Use `#!/bin/bash` as the shebang for portability.
- Prefer `set -euo pipefail` at the top for safer scripts.
- Quote all variable expansions (e.g., `"$var"`).
- Use `read -r` to avoid mangling backslashes.
- Avoid using `eval` unless absolutely necessary.
- Use functions for reusable code blocks or to improve human readability.
- Add comments for clarity and maintainability.
- Indent with 4 spaces or tabs consistently.
- Check command exit codes and handle errors.
- Prefer long-form options for commands (e.g., `--help`).

Following these rules helps prevent common errors and keeps scripts maintainable and secure.

## Makefile content

To ensure that AI-generated Makefiles are portable and avoid common errors:

- Use spaces instead of tabs for command indentation to prevent 'missing separator' errors in some environments.
- Clearly separate variable definitions and rules with blank lines.
- Use `.PHONY` at the end of the file for non-file targets (like `lint`, `clean`, etc.).
- Add comments to explain complex rules or variables.
- Keep recipes simple and readable.

These practices help prevent Makefile syntax errors and improve maintainability.
