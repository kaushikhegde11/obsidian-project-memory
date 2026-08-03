# Security

## What these skills can do

`obsidian-project-memory` and `obsidian-project-update` are sets of instructions for Claude Code. They have no runtime of their own. When Claude follows them, Claude:

- reads and writes Markdown files **only** under the folder you configure in `project-memory-config.yaml`;
- creates the project folders and the four memory files inside it;
- makes **no network calls** and sends **no data** anywhere.

They require no credentials and store none.

## Prerequisite

These skills assume Claude already has read, create, and edit access to your Obsidian vault — through the Obsidian MCP server or direct filesystem access. The skills do not grant that access. You set it up, and your own tool-approval prompts still apply per file action.

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
