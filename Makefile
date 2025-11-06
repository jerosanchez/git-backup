MD_FILES := $(wildcard *.md) LICENSE
SH_FILES := $(wildcard *.sh)

lint:
	@echo "Linting markdown files..."
	@markdownlint $(MD_FILES)
	@echo "Linting shell scripts..."
	@shellcheck $(SH_FILES)

install:
	@echo "Installing sync-repos to /usr/local/bin..."
	sudo cp sync-repos.sh /usr/local/bin/sync-repos
	@echo "Installing systemd service..."
	@sed "s/%SYNC_REPOS_USER%/$$USER/g; s/%SYNC_REPOS_GROUP%/$$USER/g" sync-repos.service | sudo tee /etc/systemd/system/sync-repos.service > /dev/null
	@echo "Reloading systemd daemon..."
	sudo systemctl daemon-reload
	@echo "Enabling sync-repos service..."
	sudo systemctl enable sync-repos.service
	@echo "Creating log file /var/log/sync-repos.log if it does not exist..."
	sudo touch /var/log/sync-repos.log
	sudo chown $$USER:$$USER /var/log/sync-repos.log
	sudo chmod 644 /var/log/sync-repos.log
	@echo "---------------------------------------------------"
	@echo "Service will run as user: $$USER"
	@echo "Remember to create /etc/sync-repos/directories or ~/.config/sync-repos/directories!"
	@echo "See README.md for configuration instructions."
	@echo "---------------------------------------------------"

uninstall:
	@echo "Uninstalling sync-repos from /usr/local/bin..."
	sudo rm -f /usr/local/bin/sync-repos
	@echo "Removing systemd service..."
	sudo systemctl disable --now sync-repos.service || true
	sudo rm -f /etc/systemd/system/sync-repos.service
	@echo "Reloading systemd daemon..."
	sudo systemctl daemon-reload
	@echo "---------------------------------------------------"
	@echo "Config files in /etc/sync-repos and ~/.config/sync-repos are NOT removed."
	@echo "Manual removal required if you wish to delete configuration."
	@echo "---------------------------------------------------"

.PHONY: lint install uninstall
