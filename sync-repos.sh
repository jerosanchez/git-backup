#!/bin/bash

set -euo pipefail

# =========================
# Configuration
# =========================

CONFIG_FILE="/etc/sync-repos/directories"
LOCAL_CONFIG="${HOME:-/root}/.config/sync-repos/directories"
LOG_FILE="/var/log/sync-repos.log"
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
sync-repos: Automatically commit and push changes in all git repositories under configured directories.

Usage:
    sync-repos.sh [--dry-run] [--show-logs|-l] [--help|-h]

Options:
    --dry-run,-t   Preview actions without making changes.
    --show-logs,-l Show the last 50 lines of the log file.
    --help, -h     Show this help message and exit.

Configuration:
    Directories to scan are listed in /etc/sync-repos/directories or ~/.config/sync-repos/directories.
    See README.md for details.
EOF
}

log() {
    # Usage: log "LEVEL" "message"
    local timestamp program level message
    
    timestamp="$(date '+%Y-%m-%dT%H:%M:%S%z')"
    program="sync-repos"
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
        log "INFO" "Would commit and push: $repo"
    else
        log "INFO" "Committing changes in $repo..."
        git add -A
        git commit -m "$COMMIT_MSG"
        log "INFO" "Pushing changes in $repo..."
        git push || log "ERROR" "Failed to push $repo"
    fi
}

push_unpushed_commits() {
    local repo="$1"
    if [[ $dry_run -eq 1 ]]; then
        log "INFO" "Would push unpushed commits: $repo"
    else
        log "INFO" "Pushing unpushed commits in $repo..."
        git push || log "ERROR" "Failed to push $repo"
    fi
}

process_repo() {
    local repo="$1"
    log "INFO" "Processing repo: $repo"
    cd "$repo" || return

    # Check if there are changes to commit
    if ! git diff --quiet || ! git diff --cached --quiet; then
        commit_and_push "$repo"
    else
        # Check for unpushed commits
        if git status -uno | grep -q "Your branch is ahead"; then
            push_unpushed_commits "$repo"
        else
            log "INFO" "No changes to commit or push in $repo"
        fi
    fi
}

show_logs() {
    if [[ -f $LOG_FILE ]]; then
        tail -n 50 "$LOG_FILE"
    else
        echo "Log file $LOG_FILE not found."
    fi
}

enable_dry_run() {
    dry_run=1
    log "INFO" "Dry run mode: No changes will be made."
}

load_directories() {
    dirs=()
    if [[ -f "$CONFIG_FILE" ]]; then
        while IFS= read -r line; do
            [[ -z "$line" || "$line" =~ ^# ]] && continue
            dirs+=("$line")
        done < "$CONFIG_FILE"
    elif [[ -f "$LOCAL_CONFIG" ]]; then
        while IFS= read -r line; do
            [[ -z "$line" || "$line" =~ ^# ]] && continue
            dirs+=("$line")
        done < "$LOCAL_CONFIG"
    fi
}

process_directories() {
    found_repo=0
    for root in "${dirs[@]}"; do
        while read -r gitdir; do
            repo=$(dirname "$gitdir")
            found_repo=1
            process_repo "$repo"
        done < <(find "$root" -type d -name ".git" 2>/dev/null)
    done
}

print_result() {
    if [[ $found_repo -eq 0 ]]; then
        log "WARNING" "No repositories found under configured directories, nothing to do."
    else
        log "INFO" "All repositories processed."
    fi
}

# =========================
# Main Program
# =========================

main() {
    # Show help if requested and exit
    if [[ "${1:-}" == "--help" || "${1:-}" == "-h" ]]; then
        show_help
        exit 0
    fi

    # Show logs if requested and exit
    if [[ "${1:-}" == "--show-logs" || "${1:-}" == "-l" ]]; then
        show_logs
        exit 0
    fi

    # Enable dry-run mode if specified
    if [[ "${1:-}" == "--dry-run" || "${1:-}" == "-t" ]]; then
        enable_dry_run
    fi

    load_directories

    # Exit if no directories are configured
    if [[ ${#dirs[@]} -eq 0 ]]; then
        log "WARNING" "No config file found, nothing to do."
        exit 0
    fi

    process_directories
    print_result
}

main "$@"
