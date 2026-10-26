# AGENTS.md

Always think and respond in English if not explicitly instructed otherwise.

The **workspace root** is the directory containing this file (`research/`). A **project root** is the root of the affected repository within the workspace, such as `baba-experience/`, `baba-toolkit/`, `PyBaba/`, or `baba-manuscript/`. Unless a section states otherwise, relative paths refer to the affected project root.

The folder structure and conceptual/technical terminology sections describe `baba-experience/`. The exploratory output, Python execution, notebook, and Git workflow rules apply throughout the workspace. Follow more-specific instructions in a project's own `AGENTS.md` where present.

## baba-experience folder structure

Paths in this section are relative to `<workspace-root>/baba-experience/`.

- `data/`: Experimental data and generated analysis inputs.
  - `raw/`: Original behavioral logs, ratings, and participant index.
  - `prescreen/`: Recruitment survey and Prolific exports.
  - `organized/`: Cleaned and encoded tables before quality filtering.
  - `interim/`: Replay data, Play pickles, segmentation, landscapes, and other intermediate artifacts.
  - `processed/`: Analysis-ready tables and derived summaries.
  - `archive/`: Temporary holding area for legacy outputs pending deletion while scripts are updated and rerun.
- `scripts/`: Data extraction, replay, derivation, measurement, and validation pipelines.
  - `state_abstraction/`: Landscape and niche derivation across representations.
  - `debug/`: Diagnostic scripts and plotting example scripts. Generated exploratory plots belong in `<project-root>/tmp/<analysis-name>/` under the Exploratory output policy.
  - `tmp/`: Experimental scripts for new functionality whose long-term role is undecided. Place new exploratory scripts here until their role is established.
- `modeling/`: Model preparation, fitting, evaluation, and comparison code.
- `models/`: Saved model results, coefficients, diagnostics, and supporting artifacts.
- `notebooks/figures/`: Manuscript figure preparation notebooks.
- `notebooks/exploration/`: Exploratory notebooks with an undecided role.
- `reference/`: Retained analyses grouped by topic; keep explanations and supporting code, notebooks, figures, and tables together.
- `figures/`: Exported manuscript figures.
- `demos/`: Gameplay, replay, visualization, and data-collection demonstrations.
- `tests/`: Script and pipeline regression tests.
- `tmp/`: Git-ignored outputs from exploratory analyses, grouped by analysis name.

Keep large shared data and model outputs from maintained pipelines in `data/` and `models/`;
link them from reference topics instead of duplicating them.

## Exploratory output policy

For ad hoc analyses, diagnostics, and scripts under `scripts/tmp/`, write all generated artifacts to `<project-root>/tmp/<analysis-name>/` by default, including figures, tables, model results, manifests, caches, and logs. For example, a `baba-experience` analysis writes to `<workspace-root>/baba-experience/tmp/<analysis-name>/`. Keep exploratory scripts in `<project-root>/scripts/tmp/`, and make their default output paths temporary too. An analysis-ready table or reproducible result is not, by itself, a retained project artifact.

Before running a new or existing exploratory script, inspect its output paths. Verify with `git check-ignore` that the intended output paths are ignored, and check `git ls-files` for any already-tracked files there; ignore rules do not untrack files. Run these checks from the affected project's Git root, or use `git -C <project-root>`, with file arguments relative to that Git root. If a default points to a persistent output location, change it to the temporary analysis directory before running. Do not change `.gitignore` or untrack files automatically to satisfy this policy.

Use `data/`, `models/`, `figures/`, or `reference/` for new retained outputs only when the user's request explicitly establishes that intent or a maintained pipeline already defines the destination. A request to calculate, compare, or draw a figure does not by itself establish retention intent. Explicit user-specified output paths take precedence. Existing maintained pipelines may continue using their established output paths when rerun within the requested scope.

Do not overwrite retained outputs, move existing artifacts, or delete prior results as part of enforcing this default unless that work is within the user's requested scope.

## Python environment

The shared virtual environment is at `<workspace-root>/.venv/` with Python 3.11. `pybaba` and `baba_toolkit` are installed there as editable packages.

Always execute Python through `uv run --no-project`. Let uv discover `.venv/` in the current directory or a parent directory. Do not activate the environment or invoke `python` or `.venv/bin/python` directly.

## Python script execution

Run test scripts as background processes in the agent's own terminal, and report the process ID (PID) to the user. The agent may poll test scripts, wait for completion, and inspect their output.

If creating a log file, place it under a `tmp/` directory in the project.

Production scripts may run either in the foreground or as a background process in the agent's own terminal without prior user approval.

Run a Python script with:

`uv run --no-project file.py`

## Notebook execution

Do not try to run notebooks automatically. Ask the user to run them.

## Notebook output policy

When creating notebooks, do not add commands that save figures or CSV files to disk (for example, `savefig` or `to_csv`), including optional export cells or disabled export switches. Display plots and tables inline.

When a notebook needs a generated CSV, implement its generation and saving in a standalone script. Choose the script's output destination under the Exploratory output policy: temporary analyses use `<project-root>/tmp/<analysis-name>/`, while retained outputs require explicit user intent or an established maintained-pipeline destination. The notebook should read the CSV produced by that script for analysis or visualization.

## Git push workflow

Run Git commands from the affected project's Git root, or use `git -C <project-root>`. File arguments are relative to that Git root. When working across repositories, apply this workflow separately to each affected repository; do not assume the workspace root is a Git repository.

When the user asks to push changes:

1. Stage only the requested changes.
2. Measure and report the uncompressed Git patch size for the changes to be pushed, including binary patches (`git diff --binary`), before asking for approval. Include any outgoing commits as well as the staged changes. Report the size in MB (1 MB = 1,000,000 bytes). If it exceeds 5 MB, list specific files or file patterns that might be better added to `.gitignore`, with brief reasons; if there are no suitable candidates, say so. Do not ignore or unstage files automatically.
3. Use the `conv-commit` skill to generate the commit message.
4. Show the proposed commit message to the user and ask for approval to commit and push. Do not commit or push until the user approves.

## Python code execution

Run inline Python code with `uv run --no-project python -c "..."`, letting uv discover the shared environment from the current directory or its parents.

## Conceptual and technical terminology

“Operator” and “Functional Unit” are manuscript terms for L0 and L2 segments, respectively. “Configuration” is the manuscript term for a landscape (an accessible/inaccessible interaction repertoire pair); specify the block-instance or appearance representation for each analysis.

In scripts, code comments, identifiers, filenames, output schemas, notebooks, reports, READMEs, and technical notes, use the implementation's technical terms: `L0 segment`, `L1 segment`, `L2 segment`, `interaction`, `operation`, `landscape`, `appearance_landscape`, and `attributed_niche`, as appropriate. Do not introduce “Operator”, “Functional Unit”, or “Configuration” as technical labels.

Keep these distinctions explicit: an L0 segment comprises navigation actions followed by an interaction; an interaction is not the whole L0 segment; and a critical operation is an individual operation identified by its index in `Play.operation_sequence`, not an L0 segment label. Match terminology to what the code actually measures or labels.

## Common Patterns

- Use `GridState` with `config_type="dict"` for consistent block IDs in analysis
- `GameEnv` render modes: `"human"` (matplotlib), `"play"` (interactive pygame), `"replay"` (playback)
- Tests use plain Python `assert` statements, no pytest.
