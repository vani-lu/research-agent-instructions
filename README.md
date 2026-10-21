# Research agent instructions

This repository backs up the instructions used in `/Volumes/orico_program/research/AGENTS.md`. Edit that working file, then manually copy changes here. The `research` folder does not need to be a Git repository.

Remote: [research-agent-instructions](https://github.com/vani-lu/research-agent-instructions).

## Manual sync

Copy the current instructions into this repository without committing or pushing:

```sh
~/Documents/agent-config/sync.sh
```

Copy, review the diff, and confirm a commit and push:

```sh
~/Documents/agent-config/sync.sh --push
```

The script asks for confirmation before committing or pushing. It commits only `AGENTS.md`, uses `docs: sync research agent instructions`, and refuses to proceed when other changes are already staged. If the file is unchanged, it can still push existing commits after confirmation. A push failure leaves the local commit available for a later retry. It does not pull or overwrite remote history; resolve any rejected push in this repository before retrying.

To use another working file:

```sh
AGENTS_SOURCE=/absolute/path/to/AGENTS.md ~/Documents/agent-config/sync.sh --push
```

## Save the setup files

`sync.sh` does not commit README or script changes. To publish these setup files yourself:

```sh
cd ~/Documents/agent-config
git add README.md sync.sh
git commit -m "docs: add manual instructions sync workflow"
git push origin main
```

## Restore instructions

Review the repository copy, then copy it back when needed:

```sh
cp ~/Documents/agent-config/AGENTS.md /Volumes/orico_program/research/AGENTS.md
```
