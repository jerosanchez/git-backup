MD_FILES := $(wildcard *.md) LICENSE
SH_FILES := $(wildcard *.sh)

lint:
	@echo "Linting markdown files..."
	@markdownlint $(MD_FILES)
	@echo "Linting shell scripts..."
	@shellcheck $(SH_FILES)

install:
	@echo "Installing git-backup to /usr/local/bin..."
	sudo cp git-backup.sh /usr/local/bin/git-backup
	@echo "Installing systemd service..."
	sudo cp git-backup.service /etc/systemd/system/git-backup.service
	@echo "Reloading systemd daemon..."
	sudo systemctl daemon-reload
	@echo "Enabling git-backup service..."
	sudo systemctl enable git-backup.service
	@echo "---------------------------------------------------"
	@echo "Remember to create /etc/git-backup/directories or ~/.config/git-backup/directories!"
	@echo "See README.md for configuration instructions."
	@echo "---------------------------------------------------"

.PHONY: lint install
