MD_FILES := $(wildcard *.md)

lint:
	markdownlint $(MD_FILES)

.PHONY: lint
