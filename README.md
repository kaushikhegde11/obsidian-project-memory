# obsidian-project-memory

Two agent instruction sets that give each of your projects a small, durable memory inside your Obsidian vault. An assistant reads that memory later to recover full context fast.

- **`project-memory`** — creates a per-project folder with four files.
- **`update-project-memory`** — updates those files when the project moves.

They run in **[Claude Code](https://claude.com/claude-code)** as skills and in **[OpenAI Codex](https://developers.openai.com/codex/cli)** as custom prompts, from the same source files. Any other agent that can read and write files can use them too — the instructions never name a specific tool.

Each project gets its own folder. Two projects never share a file.

## The four files

| File | Role |
|------|------|
| `README.md` | Stable overview — what it is, why it matters, who it is for, useful links, how AI should help. |
| `STATUS.md` | Current snapshot — where it stands, next action, blockers, what needs review. |
| `progress.md` | Dated diary — what happened, what changed, what should happen next. |
| `Decision.md` | Decision record — what was decided, why, and when to revisit. |

The create skill may add an extra file or subfolder when a project clearly needs one, but the four files are the default.

## Prerequisite: vault access

These instructions **assume the assistant already has read, create, and edit access** to your Obsidian vault — through the [Obsidian MCP server](https://github.com/modelcontextprotocol), plain filesystem tools, or a sandbox mount. They do **not** set up that access.

Set it up first. Your own tool-approval prompts still apply — the assistant asks before each file write unless you have allow-listed the path.

## Install

```bash
git clone https://github.com/kaushikhegde11/obsidian-project-memory ~/src/obsidian-project-memory
cd ~/src/obsidian-project-memory

bash scripts/install.sh --both      # Claude Code + Codex
# or: --claude / --codex
# add --copy to copy the Claude skills instead of symlinking
```

The installer never overwrites anything without asking. Keep the clone somewhere stable if you symlink.

### What it does, by hand

**Claude Code** — symlink (or copy) both skill folders into the skills directory:

```bash
ln -s ~/src/obsidian-project-memory/project-memory        ~/.claude/skills/project-memory
ln -s ~/src/obsidian-project-memory/update-project-memory ~/.claude/skills/update-project-memory
```

Claude Code discovers the skills on the next session.

**Codex** — copy both prompts into the Codex prompts directory:

```bash
mkdir -p ~/.codex/prompts
cp codex/prompts/project-memory.md        ~/.codex/prompts/
cp codex/prompts/update-project-memory.md ~/.codex/prompts/
```

Codex exposes them as `/project-memory` and `/update-project-memory` on the next session.

Codex only runs a custom prompt when you type its slash command. To let Codex reach for them on its own — when you say "log progress on X" with no command — append the block in [`codex/AGENTS-snippet.md`](codex/AGENTS-snippet.md) to `~/.codex/AGENTS.md`.

> **Codex sandbox note.** Codex defaults to `workspace-write`: it can write the current directory and little else. Your vault normally sits outside that, so add it as a writable root (`--add-writable-root <vault path>`, or `sandbox_workspace_write.writable_roots` in `~/.codex/config.toml`). Without it the prompt falls back to printing each file for you to paste.

## First run: configuration (works with any folder)

These instructions hardcode **no** vault structure. On first use the assistant asks:

1. Your **vault root** path.
2. Which **folder** should hold project memory — any folder you like: `Projects memory`, `2. Source Material/Projects`, `Areas/Projects`, or `""` for the vault root.
3. Your **date format**.

It saves the answers and reuses them after that. To reconfigure, edit or delete the config file.

Config is looked up in this order, first hit wins — so one file can serve every agent:

1. `$PROJECT_MEMORY_CONFIG`
2. `~/.config/project-memory/config.yaml` — canonical
3. `~/.claude/skills/project-memory/project-memory-config.yaml`
4. `~/.codex/project-memory-config.yaml`

### Configure by hand instead

```bash
mkdir -p ~/.config/project-memory
cp project-memory-config.example.yaml ~/.config/project-memory/config.yaml
```

`project-memory-config.example.yaml` documents every field. Real config files are gitignored — they hold a machine path and are never committed.

## Usage

Same commands in both tools.

Create memory for a project:

```
/project-memory
set up project memory for <project name>
<paste the project context>
```

Later, log an update:

```
/update-project-memory
update <project name>: shipped X, decided Y because Z, next is W
```

The update half refreshes `STATUS.md`, prepends a dated `progress.md` entry, appends any decision to `Decision.md`, and touches `README.md` only if the project's direction changed. If context is missing, it asks before inventing it.

## Repo layout

```
project-memory/SKILL.md           source of truth — create
update-project-memory/SKILL.md    source of truth — update
codex/prompts/*.md                generated from the SKILL.md bodies
codex/AGENTS-snippet.md           optional auto-trigger block for Codex
scripts/install.sh                installer for either or both tools
scripts/build-codex-prompts.sh    regenerates codex/prompts (--check verifies)
scripts/check-secrets.sh          pre-commit guard
```

The Codex prompts are generated, not hand-edited. **Edit `SKILL.md`, then run:**

```bash
bash scripts/build-codex-prompts.sh          # regenerate
bash scripts/build-codex-prompts.sh --check  # fail if stale
```

## Security

These instructions run entirely on your machine, only under the folder you configure, with no network calls. See [`SECURITY.md`](SECURITY.md). A `scripts/check-secrets.sh` guard helps contributors avoid committing personal paths, emails, or keys.

## Related

- [obsidian-notes-skill](https://github.com/kaushikhegde11/obsidian-notes-skill) — files and formats notes into your Obsidian vault (Zettelkasten / PARA / flat / custom) with a first-run setup wizard.

## License

[MIT](LICENSE).
