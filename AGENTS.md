# AGENTS.md

Always think and respond in English if not explicitly instructed otherwise. Use the following guidelines when working with code in this directory:

## Python environment

Virtual environment is at `.venv/` with Python 3.11. `pybaba` and `baba_toolkit` is already installed there (editable install). 

## Python script execution

Run test scripts as background processes in the agent's own terminal. Redirect stdout and stderr to a log file, and report both the process ID (PID) and log-file path to the user. The agent may poll test scripts, wait for completion, and inspect their output.

Production scripts may run either in the foreground or as a background process in the agent's own terminal without prior user approval.

Let uv discover the virtual environment in the current or parent directory:

`uv run --no-project file.py`

## Notebook execution

Do not try to run notebooks automatically. Ask the user to run them.

## Notebook output policy

When creating notebooks, do not add commands that save figures or CSV files to disk (for example, `savefig` or `to_csv`), including optional export cells or disabled export switches. Display plots and tables inline.

If a CSV is important enough to persist, implement its generation and saving in a standalone script. The notebook should read the CSV produced by that script for analysis or visualization.

## Git push workflow

When the user asks to push changes:

1. Stage only the requested changes.
2. Measure and report the uncompressed Git patch size for the changes to be pushed, including binary patches (`git diff --binary`), before asking for approval. Include any outgoing commits as well as the staged changes. Report the size in MB (1 MB = 1,000,000 bytes). If it exceeds 5 MB, list specific files or file patterns that might be better added to `.gitignore`, with brief reasons; if there are no suitable candidates, say so. Do not ignore or unstage files automatically.
3. Use the `conv-commit` skill to generate the commit message.
4. Show the proposed commit message to the user and ask for approval to commit and push. Do not commit or push until the user approves.

## Python code execution

(1) Run `source .venv/bin/activate` in root `research` directory to activate. If located in project sub-folders, run `source ../.venv/bin/activate`.
(2) Run `python -c "..."` to execute python code.

## Conceptual and technical terminology

Use manuscript-level conceptual terminology only in draft notes (for example, `baba-experience/notes/draft-*.md`). “Operator” and “Functional Unit” are manuscript terms for L0 and L2 segments, respectively. “Configuration” is the manuscript term for a landscape (an accessible/inaccessible interaction repertoire pair); specify the block-instance or appearance representation for each analysis; reserve it for Markdown draft notes.

In scripts, code comments, identifiers, filenames, output schemas, notebooks, reports, READMEs, and non-draft technical notes, use the implementation's technical terms: `L0 segment`, `L1 segment`, `L2 segment`, `interaction`, `operation`, `landscape`, `appearance_landscape`, and `attributed_niche`, as appropriate. Do not introduce “Operator”, “Functional Unit”, or “Configuration” as technical labels.

Keep these distinctions explicit: an L0 segment comprises navigation actions followed by an interaction; an interaction is not the whole L0 segment; and a critical operation is an individual operation identified by its index in `Play.operation_sequence`, not an L0 segment label. Match terminology to what the code actually measures or labels.

## Common Patterns

- Use `GridState` with `config_type="dict"` for consistent block IDs in analysis
- `GameEnv` render modes: `"human"` (matplotlib), `"play"` (interactive pygame), `"replay"` (playback)
- Tests use plain Python `assert` statements, no pytest.
