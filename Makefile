MD_FILES := $(wildcard *.md) LICENSE
SH_FILES := $(wildcard *.sh)

lint:
	@echo "Linting markdown files..."
	@markdownlint $(MD_FILES)
	@echo "Linting shell scripts..."
	@shellcheck $(SH_FILES)

.PHONY: lint
