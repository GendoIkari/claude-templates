#!/usr/bin/env bash
# Runs a command on an ext4 copy of the current git working tree.
#
# Projects live on the Windows filesystem (/mnt/c), where every file read from
# WSL crosses into Windows: tooling that reads thousands of small files (Node
# dependencies above all) becomes very slow. This script mirrors the working
# tree's files (tracked and untracked, not ignored) into ~/.cache/ext4-run/,
# keeps the mirror's own ignored files (dependencies, caches) between runs and
# runs the command there. Ignore rules come from git, so they match exactly.
#
# Usage: ext4-run.sh '<command>'   (from inside the working tree)
# The command runs with bash in the mirror's root; its exit code is returned.

set -euo pipefail

if [ $# -ne 1 ]; then
	echo "usage: ext4-run.sh '<command>'" >&2
	exit 2
fi

src=$(git rev-parse --show-toplevel)
git_dir=$(git rev-parse --absolute-git-dir)
cache=${XDG_CACHE_HOME:-$HOME/.cache}/ext4-run
mirror=$cache/$(basename "$src")-$(printf '%s' "$src" | sha1sum | cut -c1-12)

mkdir -p "$cache"

# Remove mirrors whose working tree no longer exists (finished worktrees).
for source_file in "$cache"/*.source; do
	[ -e "$source_file" ] || continue
	if [ ! -d "$(cat "$source_file")" ]; then
		stale=${source_file%.source}
		rm -rf "$stale" "$stale.lock" "$source_file"
	fi
done

printf '%s\n' "$src" >"$mirror.source"
# One run at a time per mirror; the lock is held until the command ends.
exec 9>"$mirror.lock"
if ! flock -n 9; then
	echo "ext4-run: another run is using $mirror; waiting" >&2
	flock 9
fi
mkdir -p "$mirror"

# Lists the ignored paths of a working tree as anchored rsync exclude rules.
ignored_rules() {
	git --git-dir="$git_dir" --work-tree="$1" \
		ls-files -z --others --ignored --exclude-standard --directory |
		tr '\0' '\n' | sed -e 's/[[*?\\]/\\&/g' -e 's|^|- /|'
}

filter=$(mktemp)
trap 'rm -f "$filter"' EXIT
{
	echo '- /.git'
	# gitflow ignores its worktrees; this keeps nested worktrees out of the
	# copy even when a project's .gitignore lacks that line.
	echo '- /.claude/worktrees/'
	# Ignored paths of the working tree are not copied, and ignored paths of
	# the mirror are excluded from deletion, so its dependencies survive.
	ignored_rules "$src"
	ignored_rules "$mirror"
} >"$filter"

# Exit code 24 means files vanished during the copy (an editor or a dev
# server writing in place): the copy is still usable.
rsync -a --delete --filter="merge $filter" "$src/" "$mirror/" || [ $? -eq 24 ]

echo "ext4-run: running in $mirror (copy of $src)" >&2
cd "$mirror"
# The copy has no .git: keep git from finding a repository above it (a
# dotfiles repo in $HOME). The command does not inherit the lock, so
# processes it leaves running do not block later runs.
GIT_CEILING_DIRECTORIES=$cache bash -c "$1" 9>&-
