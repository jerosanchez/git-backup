<!-- markdownlint-disable MD041 -->
<!-- GitHub Actions Badges -->
[![Lint](https://github.com/jerosanchez/sync-repos/actions/workflows/lint.yml/badge.svg)](https://github.com/jerosanchez/sync-repos/actions/workflows/lint.yml)
[![Beta](https://img.shields.io/badge/status-beta-orange)](https://shields.io/)

> **⚠️ This project is in beta and not suited for production use. Features and behavior may change. Use at your own risk.**

# README

`sync-repos` is a utility to automatically commit and push changes in all git repositories found under specified directories. It can be run manually or automatically before system shutdown using a `systemd` service.

This tool is especially useful for automating backups of personal knowledge bases and project folders. For example, you can use it to keep your [Obsidian](https://obsidian.md/) vaults safely versioned and synced to remote repositories, back up notes, task lists, or code projects stored in git. It is also handy for ensuring that any changes in your documentation, research, or configuration folders are regularly committed and pushed without manual intervention.

## Features

- Scans specified folders for git repositories
- Flexible configuration via global and user config files
- Commits any pending changes with a timestamped message
- Pushes local commits to remote
- Supports a dry-run mode to preview actions
- Logs all actions to `/var/log/sync-repos.log` for easy review

## Installation

1. **Clone or copy the repository to your system.**

2. **Run the install command:**

    ```shell
    cd sync-repos
    make install
    ```

    This will:
    - Copy `sync-repos.sh` to `/usr/local/bin/sync-repos` (without the `.sh` extension)
    - Install the `sync-repos.service` systemd unit to `/etc/systemd/system/sync-repos.service`
    - Reload systemd and enable the service

3. **Review or edit the directories to be backed up:**

- Create `/etc/sync-repos/directories` or `~/.config/sync-repos/directories` as described below.

## Configuration

`sync-repos` supports specifying which directories to scan for git repositories using configuration files:

- **Global config:** `/etc/sync-repos/directories`
- **User config:** `~/.config/sync-repos/directories`

The script will use the global config if present, otherwise the user config. If neither exists, no git repository will be comitted and/or pushed automatically.

**To create a config file:**

1. For system-wide configuration (all users):

    Create the file using your editor, for example:

    ```shell
    sudo mkdir -p /etc/sync-repos
    sudo nano /etc/sync-repos/directories
    ```

2. For per-user configuration:

    Create the file using your editor, for example:

    ```shell
    mkdir -p ~/.config/sync-repos
    nano ~/.config/sync-repos/directories
    ```

Then add lines like:

```text
# List directories to scan for git repositories
/home/youruser/Tasks
/home/youruser/Notes
/home/youruser/Projects
```

**Config file priority:**

If `/etc/sync-repos/directories` exists, it will be used. Otherwise, the script will use `~/.config/sync-repos/directories` if present.  
If neither configuration file exists, the script will exit successfully without committing or pushing any repositories.

To change which directories are backed up, simply edit the appropriate config file.

## Uninstallation

To uninstall `sync-repos`, run:

```shell
cd /path/to/git-backup/repo
make uninstall
```

This will remove the installed binary and systemd service, but **will not delete your configuration files** in `/etc/sync-repos` or `~/.config/sync-repos`.  
If you wish to remove those config files, you must do so manually.

## Usage

- **Manual run:**

  ```shell
  /usr/local/bin/sync-repos
  ```

  - Add `--dry-run` to preview actions without making changes.
  - Manual runs will use `/etc/sync-repos/directories` if present, otherwise `~/.config/sync-repos/directories`.

- **Automatic run before shutdown (systemd service):**

  The systemd service will run the backup script before shutdown, reboot, or halt.

  > **Note:**  
  > The service requires the global config file `/etc/git-backup/directories` to be present.  
  > If this file does not exist, the service will not back up any directories.

## Logs

The output from the backup script is redirected to `/var/log/sync-repos.log` by the systemd service.

To view recent logs:

```shell
sync-repos --show-logs
```

To filter logs related to this tool:

```shell
grep 'sync-repos' /var/log/sync-repos.log
```

You can also use `less` or other tools for easier navigation:

```shell
less /var/log/sync-repos.log
```

## Contributing

If you'd like to contribute, please read CONTRIBUTING.md for guidelines on reporting issues, submitting patches, coding style, and testing.

See: [CONTRIBUTING.md](CONTRIBUTING.md)
