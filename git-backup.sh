#!/bin/bash

set -euo pipefail

# =========================
# Configuration
# =========================

CONFIG_FILE="/etc/git-backup/directories"
LOCAL_CONFIG="$HOME/.config/git-backup/directories"
LOG_FILE="/var/log/git-backup.log"
COMMIT_MSG="backup: $(date '+%Y%m%d%H%M%S')"

# =========================
# Globals
# =========================

dirs=()
dry_run=0
found_repo=0

# =========================
# Helper functions
# =========================

show_help() {
    cat <<EOF
git-backup: Automatically commit and push changes in all git repositories under configured directories.

Usage:
    git-backup.sh [--dry-run] [--help|-h]

Options:
    --dry-run   Preview actions without making changes.
    --help, -h  Show this help message and exit.

Configuration:
    Directories to scan are listed in /etc/git-backup/directories or ~/.config/git-backup/directories.
    See README.md for details.
EOF
}

log_git_backup() {
    # Usage: log_git_backup "LEVEL" "message"
    local timestamp program level message
    
    timestamp="$(date '+%Y-%m-%dT%H:%M:%S%z')"
    program="git-backup"
    level="${1:-INFO}"
    message="$2"

    echo "$message"

    if [[ "${dry_run:-0}" -eq 0 ]]; then
        if [[ -w "$LOG_FILE" || ( ! -e "$LOG_FILE" && -w "$(dirname "$LOG_FILE")" ) ]]; then
            # Structured log: program name, timestamp, log level, message
            echo "$program [$timestamp] [$level] $message" >> "$LOG_FILE"
        fi
    fi
}

commit_and_push() {
    local repo="$1"
    if [[ $dry_run -eq 1 ]]; then
        log_git_backup "INFO" "Would commit and push: $repo"
    else
        log_git_backup "INFO" "Committing changes in $repo..."
        git add -A
        git commit -m "$COMMIT_MSG"
        log_git_backup "INFO" "Pushing changes in $repo..."
        git push || log_git_backup "ERROR" "Failed to push $repo"
    fi
}

push_unpushed_commits() {
    local repo="$1"
    if [[ $dry_run -eq 1 ]]; then
        log_git_backup "INFO" "Would push unpushed commits: $repo"
    else
        log_git_backup "INFO" "Pushing unpushed commits in $repo..."
        git push || log_git_backup "ERROR" "Failed to push $repo"
    fi
}

process_repo() {
    local repo="$1"
    log_git_backup "INFO" "Processing repo: $repo"
    cd "$repo" || return

    # Check if there are changes to commit
    if ! git diff --quiet || ! git diff --cached --quiet; then
        commit_and_push "$repo"
    else
        # Check for unpushed commits
        if git status -uno | grep -q "Your branch is ahead"; then
            push_unpushed_commits "$repo"
        else
            log_git_backup "INFO" "No changes to commit or push in $repo"
        fi
    fi
}

# =========================
# Main Program
# =========================

# Show help if requested and exit
if [[ "${1:-}" == "--help" || "${1:-}" == "-h" ]]; then
    show_help
    exit 0
fi

# Enabled dry-run mode if specified
if [[ "${1:-}" == "--dry-run" ]]; then
    dry_run=1
    log_git_backup "INFO" "Dry run mode: No changes will be made."
fi

# Load directories from config files
if [[ -f "$CONFIG_FILE" ]]; then
    while IFS= read -r line; do
        # Skip empty lines and comments
        [[ -z "$line" || "$line" =~ ^# ]] && continue
        dirs+=("$line")
    done < "$CONFIG_FILE"
elif [[ -f "$LOCAL_CONFIG" ]]; then
    while IFS= read -r line; do
        [[ -z "$line" || "$line" =~ ^# ]] && continue
        dirs+=("$line")
    done < "$LOCAL_CONFIG"
fi

if [[ ${#dirs[@]} -eq 0 ]]; then
    log_git_backup "WARNING" "No config file found, nothing to do."
    exit 0
fi

# Process each directory
for root in "${dirs[@]}"; do
    while read -r gitdir; do
        repo=$(dirname "$gitdir")
        found_repo=1
        process_repo "$repo"
    done < <(find "$root" -type d -name ".git" 2>/dev/null)
done

# Display final status
if [[ $found_repo -eq 0 ]]; then
    log_git_backup "WARNING" "No repositories found under configured directories, nothing to do."
else
    log_git_backup "INFO" "All repositories processed."
fi
