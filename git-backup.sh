#!/bin/bash
# Backup contents under specific directories to Git repositories

DIRS=("$HOME/Tasks" "$HOME/Notes")
COMMIT_MSG="backup: $(date '+%Y%m%d%H%M%S')"

echo "Scanning for git repositories under: ${DIRS[*]} ..."

DRY_RUN=0
if [[ "$1" == "--dry-run" ]]; then
    DRY_RUN=1
    echo "🟡 Dry run mode: No changes will be made."
fi

commit_and_push() {
    local repo="$1"
    if [[ $DRY_RUN -eq 1 ]]; then
        echo "  - Would commit and push: $repo"
    else
        echo "  - Committing changes..."
        git add -A
        git commit -m "$COMMIT_MSG"
        echo "  - Pushing..."
        git push || echo "  ! Failed to push $repo"
    fi
}

push_unpushed_commits() {
    local repo="$1"
    if [[ $DRY_RUN -eq 1 ]]; then
        echo "  - Would push unpushed commits: $repo"
    else
        echo "  - Pushing unpushed commits..."
        git push || echo "  ! Failed to push $repo"
    fi
}

process_repo() {
    local repo="$1"
    echo "→ Processing repo: $repo"
    cd "$repo" || return

    # Check if there are changes to commit
    if ! git diff --quiet || ! git diff --cached --quiet; then
        commit_and_push "$repo"
    else
        # Check for unpushed commits
        if git status -uno | grep -q "Your branch is ahead"; then
            push_unpushed_commits "$repo"
        else
            if [[ $DRY_RUN -eq 1 ]]; then
                echo "  - No changes to commit/push."
            else
                echo "  - No changes to commit/push."
            fi
        fi
    fi
}

for ROOT in "${DIRS[@]}"; do
    find "$ROOT" -type d -name ".git" 2>/dev/null | while read -r gitdir; do
        repo=$(dirname "$gitdir")
        process_repo "$repo"
    done
done

echo "✅ All repositories processed."
