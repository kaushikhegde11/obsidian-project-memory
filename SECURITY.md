# Security

## What these instructions can do

`project-memory` and `update-project-memory` are sets of instructions for an AI coding agent — a skill in Claude Code, a custom prompt in Codex. They have no runtime of their own. When an assistant follows them, it:

- reads and writes Markdown files **only** under the folder you configure in your `project-memory` config;
- creates the project folders and the four memory files inside it;
- makes **no network calls** and sends **no data** anywhere.

They require no credentials and store none.

The two shell scripts in `scripts/` are the only executable code here. `install.sh` writes symlinks or copies into `~/.claude/skills/` and `~/.codex/prompts/` and asks before replacing anything. `build-codex-prompts.sh` writes only inside `codex/prompts/`. Neither touches the network.

## Prerequisite

These instructions assume the assistant already has read, create, and edit access to your Obsidian vault — through the Obsidian MCP server, filesystem tools, or a sandbox mount. They do not grant that access. You set it up, and your own tool-approval prompts still apply per file action.

Codex runs sandboxed (`workspace-write` by default). Granting the vault as a writable root widens that sandbox for the whole session, not just for these prompts — grant the vault path, not your home directory.

## What you should not commit

Do not commit personal or secret data:

- absolute home paths (`/Users/<name>/…`, `/home/<name>/…`);
- email addresses or other personal identifiers;
- API keys, tokens, or private keys;
- the contents of a real Obsidian vault.

Run the guard before every commit and push:

```bash
bash scripts/check-secrets.sh
```

To run it automatically, install it as a local hook:

```bash
ln -s ../../scripts/check-secrets.sh .git/hooks/pre-commit
```

## Reporting a problem

Open a private security advisory on the GitHub repository, or open an issue that does **not** include sensitive detail.
