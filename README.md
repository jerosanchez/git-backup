# git-backup

`git-backup` is a utility to automatically commit and push changes in all git repositories found under specified directories (by default: `$HOME/Tasks` and `$HOME/Notes`). It can be run manually or automatically before system shutdown using a `systemd` service.

## Features

- Scans specified folders for git repositories
- Commits any pending changes with a timestamped message
- Pushes local commits to remote
- Supports a dry-run mode to preview actions
- Logs all actions to `/var/log/git-backup.log` for easy review

## Installation

1. **Clone or copy the repository to your system.**

2. **Run the install command:**

    ```shell
    cd git-backup
    make install
    ```

    This will:
    - Copy `git-backup.sh` to `/usr/local/bin/git-backup` (without the `.sh` extension)
    - Install the `git-backup.service` systemd unit to `/etc/systemd/system/git-backup.service`
    - Reload systemd and enable the service

3. **(Optional) Review or edit the directories to be backed up:**
    - Create or edit `/etc/git-backup/directories` or `~/.config/git-backup/directories` as described below.

## Configuration

`git-backup` supports specifying which directories to scan for git repositories using configuration files:

- **Global config:** `/etc/git-backup/directories`
- **User config:** `~/.config/git-backup/directories`

The script will use the global config if present, otherwise the user config. If neither exists, it does nothing.

**To create a config file:**

1. For system-wide configuration (all users):

    ```shell
    sudo mkdir -p /etc/git-backup
    sudo tee /etc/git-backup/directories <<EOF
    # List directories to scan for git repositories
    /home/youruser/Tasks
    /home/youruser/Notes
    /home/youruser/Projects
    EOF
    ```

2. For per-user configuration:

    ```shell
    mkdir -p ~/.config/git-backup
    tee ~/.config/git-backup/directories <<EOF
    # List directories to scan for git repositories
    $HOME/Tasks
    $HOME/Notes
    $HOME/PersonalWiki
    EOF
    ```

- Lines starting with `#` are treated as comments.
- Blank lines are ignored.

**Config file priority:**  
If `/etc/git-backup/directories` exists, it is used. Otherwise, `~/.config/git-backup/directories` is used. If neither exists, the script finish successfully without doing anything.

To change which directories are backed up, simply edit the appropriate config file.

## Usage

- **Manual run:**

  ```shell
  /usr/local/bin/git-backup
  ```

  - Add `--dry-run` to preview actions without making changes.
  - Manual runs will use `/etc/git-backup/directories` if present, otherwise `~/.config/git-backup/directories`.

- **Automatic run before shutdown (systemd service):**
  The systemd service will run the backup script before shutdown, reboot, or halt.

  > **Note:**  
  > The service requires the global config file `/etc/git-backup/directories` to be present.  
  > If this file does not exist, the service will not back up any directories.

## Logs

The output from the backup script is redirected to `/var/log/git-backup.log` by the systemd service.

To view recent logs:

```shell
tail -n 50 /var/log/git-backup.log
```

To filter logs related to this tool:

```shell
grep 'git-backup' /var/log/git-backup.log
```

You can also use `less` or other tools for easier navigation:

```shell
less /var/log/git-backup.log
```

## Contributing

If you'd like to contribute, please read CONTRIBUTING.md for guidelines on reporting issues, submitting patches, coding style, and testing.

See: [CONTRIBUTING.md](CONTRIBUTING.md)
