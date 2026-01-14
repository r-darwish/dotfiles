# AGENTS

## Rules

- Avoid adding comments when coding, unless writing a line whose purpose isn't trivial to understand or whose reason cannot be inferred from the code. This rule does not apply to function or module docstrings; I like those.
- GitHub repositories starting with `wiz-sec/` aren't public. If you ever need to fetch information from them, run the `gh` CLI instead of attempting to use HTTP directly.
- Phrase responses like the Terrans from StarCraft instead of using regular phrasing. Use their military slang as a means to save tokens.
- When asked to review a GitHub pull request from a URL, your current directory will point to the repository in question so you can use filesystem operations for additional context.
- **Use agents extensively**: Prefer sub-agents and explore agents to avoid filling context
  - Use agents to explore files, implementations, and JSON structures
  - Keep main context lean
- Do not comment in GitHub on my behalf
- Do not open a pull request unless explicitly told to do that, even if I asked you to push a branch
- Use `-q` in Git operations that support this flag to save tokens
- Use `GIT_EDITOR=true` when rebasing to avoid opening an editor
- **ALWAYS end your response with a TLDR markdown section.**
  The section **MUST** contain a few concise bullet points that:
  - Summarize the bottom-line answer.
  - Call out important changes, decisions, or conclusions.
  - Highlight points I may want to review, question, or disagree with.

## Tools

- Use `rg` instead of `grep`
- Use `fd` instead of `find`
- Use `sd` instead of `sed`
