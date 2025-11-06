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

2. **Run the install script:**

   ```shell
   cd $HOME/Developer/utils/git-backup
   ./install.sh
   ```

   This will:
   - Copy `git-backup.sh` to `/usr/local/bin/git-backup.sh`
   - Install the `git-backup.service` systemd unit to `/etc/systemd/system/git-backup.service`
   - Reload systemd and enable the service

3. **(Optional) Review or edit the directories to be backed up:**
   - Edit `git-backup.sh` and modify the `DIRS` array as needed.

## Usage

- **Manual run:**

  ```shell
  /usr/local/bin/git-backup.sh
  ```

  - Add `--dry-run` to preview actions without making changes.

- **Automatic run before shutdown:**
  The systemd service will run the backup script before shutdown, reboot, or halt.

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
