---
name: conv-commit
description: Generate a one-line conventional commit message, or prepare and carry out an explicitly requested Git commit-and-push workflow with approval.
---

# Conventional Commit Workflow

## Commit Message
Generate a commit message in the format: `<type>: <description>`

### Context Priority
1. **Chat History**: If the user triggers the skill without additional text (e.g., just typing `/conv-commit`), summarize the key changes discussed in the current session.
2. **User Input**: If the user provides a brief description (e.g., `/conv-commit update readme`), use that text as the primary source.
3. **Git Diff**: If the user specifies a repository or directory (e.g., `/conv-commit changes in 'my-app'`), analyze the staged `git diff` for that path to determine the message.

### Constraints
* **Format**: Strictly one line. No markdown blocks, quotes, or explanations.
* **No Scope**: Never add a scope or parentheses after the type. Use `docs: update landscape documentation`, not `docs(landscape): update documentation`.
* **Grammar**: Lowercase only. Use the imperative mood (e.g., "add" not "added").
* **Length**: Maximum 80 characters.
* **Message-only safety**: When asked only for a commit message, do not stage files or execute `git commit` or `git push`; output only the string.

### Allowed Types
`feat`, `fix`, `docs`, `style`, `refactor`, `test`, `chore`, `ci`, `build`, `perf`, `revert`

### Examples
* **Empty Call**: User: "/conv-commit" (after discussing a bug fix)
  Output: fix: resolve null pointer in auth handler
* **User Input**: User: "/conv-commit add logout button"
  Output: feat: add logout functionality to navbar
* **Repo Target**: User: "/conv-commit changes in the 'ui-kit' repo"
  Output: style: update button padding and font-weight

## Commit and Push Workflow

Use this workflow only when the user explicitly asks to commit and push changes.

1. Run Git commands from the affected repository root, or use `git -C <project-root>`. Treat file arguments as relative to that root. When changes span repositories, apply the workflow separately to each repository.
2. Inspect the working tree and stage only the changes requested by the user. Preserve unrelated staged and unstaged work.
3. Before requesting approval, measure the uncompressed binary-inclusive patch size of the proposed commit: the byte length of `git diff --cached --binary HEAD --`. This measures the diff from `HEAD` to the index, not the full sizes of affected files.
4. Report the size in decimal MB, where 1 MB is 1,000,000 bytes. If it exceeds 5 MB, identify specific files or patterns that may be better added to `.gitignore`, with brief reasons. If none are suitable, say so. Do not ignore or unstage files automatically.
5. Generate the proposed commit message using the rules above, show it to the user, and ask for approval to commit and push.
6. Do not execute `git commit` or `git push` until the user explicitly approves. Approval applies only to the staged patch and proposed message shown to the user; if either changes materially, show the updated proposal and request approval again.
7. After approval, commit and push the approved changes, then report the result.
