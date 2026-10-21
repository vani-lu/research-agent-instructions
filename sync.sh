#!/bin/sh
set -eu

repo_dir=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
source_file=${AGENTS_SOURCE:-"/Volumes/orico_program/research/AGENTS.md"}

case ${1:-} in
  '') push=false ;;
  --push) push=true ;;
  *) echo "Usage: $0 [--push]" >&2; exit 2 ;;
esac

if [ ! -f "$source_file" ]; then
  echo "Source file not found: $source_file" >&2
  exit 1
fi
if ! git -C "$repo_dir" diff --cached --quiet; then
  echo "Existing staged changes found. Commit or unstage them before syncing." >&2
  exit 1
fi
cp "$source_file" "$repo_dir/AGENTS.md"
echo "Copied $source_file to $repo_dir/AGENTS.md"
if [ "$push" = false ]; then
  git -C "$repo_dir" status --short
  echo "To review, commit, and push AGENTS.md, run: $0 --push"
  exit 0
fi
if ! git -C "$repo_dir" diff --quiet -- AGENTS.md; then
  git -C "$repo_dir" diff -- AGENTS.md
  printf 'Commit AGENTS.md and push to origin? [y/N] '
  read -r answer
  case "$answer" in
    y|Y|yes|YES) ;;
    *) echo "Copy saved locally; commit and push skipped."; exit 0 ;;
  esac
  git -C "$repo_dir" add -- AGENTS.md
  git -C "$repo_dir" commit -m "docs: sync research agent instructions"
else
  printf 'AGENTS.md is unchanged. Push existing commits to origin? [y/N] '
  read -r answer
  case "$answer" in
    y|Y|yes|YES) ;;
    *) exit 0 ;;
  esac
fi
git -C "$repo_dir" push origin HEAD
