MD_FILES := $(wildcard *.md) LICENSE

lint:
	@markdownlint $(MD_FILES)

.PHONY: lint
