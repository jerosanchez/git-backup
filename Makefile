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
	@echo "Creating log file /var/log/git-backup.log if it does not exist..."
	sudo touch /var/log/git-backup.log
	sudo chmod 644 /var/log/git-backup.log
	@echo "---------------------------------------------------"
	@echo "Remember to create /etc/git-backup/directories or ~/.config/git-backup/directories!"
	@echo "See README.md for configuration instructions."
	@echo "---------------------------------------------------"

uninstall:
	@echo "Uninstalling git-backup from /usr/local/bin..."
	sudo rm -f /usr/local/bin/git-backup
	@echo "Removing systemd service..."
	sudo systemctl disable --now git-backup.service || true
	sudo rm -f /etc/systemd/system/git-backup.service
	@echo "Reloading systemd daemon..."
	sudo systemctl daemon-reload
	@echo "---------------------------------------------------"
	@echo "Config files in /etc/git-backup and ~/.config/git-backup are NOT removed."
	@echo "Manual removal required if you wish to delete configuration."
	@echo "---------------------------------------------------"

.PHONY: lint install uninstall
