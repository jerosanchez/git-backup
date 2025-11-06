#!/bin/bash

set -e

SCRIPT_SRC="$(dirname "$0")/git-backup.sh"
SCRIPT_DST="/usr/local/bin/git-backup.sh"
SERVICE_SRC="$(dirname "$0")/git-backup.service"
SERVICE_DST="/etc/systemd/system/git-backup.service"

echo "Copying backup script to $SCRIPT_DST ..."
sudo cp "$SCRIPT_SRC" "$SCRIPT_DST"
sudo chmod +x "$SCRIPT_DST"

echo "Installing systemd service to $SERVICE_DST ..."
sudo cp "$SERVICE_SRC" "$SERVICE_DST"

echo "Reloading systemd daemon ..."
sudo systemctl daemon-reload

echo "Enabling git-backup.service ..."
sudo systemctl enable git-backup.service

echo "Installation complete."
