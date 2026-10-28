#!/bin/sh
set -eu

repo_dir=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
source_file=${AGENTS_SOURCE:-"/Volumes/orico_program/research/AGENTS.md"}
skill_source_file=${CONV_COMMIT_SOURCE:-"$HOME/.codex/skills/conv-commit/SKILL.md"}
skill_repo_file="$repo_dir/skills/conv-commit/SKILL.md"
eli5_source_file=${ELI5_SOURCE:-"$HOME/.codex/skills/eli5/SKILL.md"}
eli5_repo_file="$repo_dir/skills/eli5/SKILL.md"

case ${1:-} in
  '') push=false ;;
  --push) push=true ;;
  *) echo "Usage: $0 [--push]" >&2; exit 2 ;;
esac

if [ ! -f "$source_file" ]; then
  echo "Source file not found: $source_file" >&2
  exit 1
fi
if [ ! -f "$skill_source_file" ]; then
  echo "Skill source file not found: $skill_source_file" >&2
  exit 1
fi
if [ ! -f "$eli5_source_file" ]; then
  echo "Skill source file not found: $eli5_source_file" >&2
  exit 1
fi
if ! git -C "$repo_dir" diff --cached --quiet; then
  echo "Existing staged changes found. Commit or unstage them before syncing." >&2
  exit 1
fi
cp "$source_file" "$repo_dir/AGENTS.md"
mkdir -p "$(dirname -- "$skill_repo_file")"
cp "$skill_source_file" "$skill_repo_file"
mkdir -p "$(dirname -- "$eli5_repo_file")"
cp "$eli5_source_file" "$eli5_repo_file"
echo "Copied agent instructions, conv-commit skill, and eli5 skill into $repo_dir"
if [ "$push" = false ]; then
  git -C "$repo_dir" status --short
  echo "To review, commit, and push the synced configuration, run: $0 --push"
  exit 0
fi
if [ -n "$(git -C "$repo_dir" status --short -- AGENTS.md skills/conv-commit/SKILL.md skills/eli5/SKILL.md)" ]; then
  git -C "$repo_dir" status --short -- AGENTS.md skills/conv-commit/SKILL.md skills/eli5/SKILL.md
  git -C "$repo_dir" diff -- AGENTS.md skills/conv-commit/SKILL.md skills/eli5/SKILL.md
  printf 'Commit synced configuration and push to origin? [y/N] '
  read -r answer
  case "$answer" in
    y|Y|yes|YES) ;;
    *) echo "Copy saved locally; commit and push skipped."; exit 0 ;;
  esac
  git -C "$repo_dir" add -- AGENTS.md skills/conv-commit/SKILL.md skills/eli5/SKILL.md
  git -C "$repo_dir" commit -m "chore: sync agent configuration"
else
  printf 'Synced configuration is unchanged. Push existing commits to origin? [y/N] '
  read -r answer
  case "$answer" in
    y|Y|yes|YES) ;;
    *) exit 0 ;;
  esac
fi
git -C "$repo_dir" push origin HEAD
