# AGENTS.md

Always think and respond in English if not explicitly instructed otherwise. Use the following guidelines when working with code in this directory:

## Python environment

Virtual environment is at `.venv/` with Python 3.11. `pybaba` and `baba_toolkit` is already installed there (editable install). 

## Python script execution

Run test scripts as background processes in the agent's own terminal. Redirect stdout and stderr to a log file, and report both the process ID (PID) and log-file path to the user. The agent may poll test scripts, wait for completion, and inspect their output.

For production scripts, ask the user for approval before starting, since they may take a long time. An approved production script may run either in the foreground or as a background process in the agent's own terminal. If the user denies approval, provide the command line so the user can run it in another terminal.

Let uv discover the virtual environment in the current or parent directory:

`uv run --no-project file.py`

## Notebook execution

Do not try to run notebooks automatically. Ask the user to run them.

## Git push workflow

When the user asks to push changes:

1. Stage only the requested changes.
2. Use the `conv-commit` skill to generate the commit message.
3. Show the proposed commit message to the user and ask for approval to commit and push. Do not commit or push until the user approves.

## Python code execution

(1) Run `source .venv/bin/activate` in root `research` directory to activate. If located in project sub-folders, run `source ../.venv/bin/activate`.
(2) Run `python -c "..."` to execute python code.

## Conceptual and technical terminology

Use manuscript-level conceptual terminology only in draft notes (for example, `baba-experience/notes/draft-*.md`). “Operator” and “Functional Unit” are manuscript terms for L0 and L2 segments, respectively.

In scripts, code comments, identifiers, filenames, output schemas, notebooks, reports, READMEs, and non-draft technical notes, use the implementation's technical terms: `L0 segment`, `L1 segment`, `L2 segment`, `interaction`, and `operation`, as appropriate. Do not introduce “Operator” or “Functional Unit” as technical labels.

Keep these distinctions explicit: an L0 segment comprises navigation actions followed by an interaction; an interaction is not the whole L0 segment; and a critical operation is an individual operation identified by its index in `Play.operation_sequence`, not an L0 segment label. Match terminology to what the code actually measures or labels.

## Common Patterns

- Use `GridState` with `config_type="dict"` for consistent block IDs in analysis
- `GameEnv` render modes: `"human"` (matplotlib), `"play"` (interactive pygame), `"replay"` (playback)
- Tests use plain Python `assert` statements, no pytest.
- Read @terminology.md for common terms like Grid, Cell, Block, UID, Attention, Move, Peer.
