# obsidian-project-memory

Two [Claude Code](https://claude.com/claude-code) **skills** that give each of your projects a small, durable memory inside your Obsidian vault. Claude reads that memory later to recover full context fast.

- **`obsidian-project-memory`** — creates a per-project folder with four files.
- **`obsidian-project-update`** — updates those files when the project moves.

Each project gets its own folder. Two projects never share a file.

## The four files

| File | Role |
|------|------|
| `README.md` | Stable overview — what it is, why it matters, who it is for, useful links, how AI should help. |
| `STATUS.md` | Current snapshot — where it stands, next action, blockers, what needs review. |
| `progress.md` | Dated diary — what happened, what changed, what should happen next. |
| `Decision.md` | Decision record — what was decided, why, and when to revisit. |

The create skill may add an extra file or subfolder when a project clearly needs one, but the four files are the default.

## Prerequisite: Obsidian access

These skills **assume Claude already has read, create, and edit access to your Obsidian vault** — through the [Obsidian MCP server](https://github.com/modelcontextprotocol) or direct filesystem access. The skills do **not** set up that access.

Set it up first. Your own tool-approval prompts still apply — Claude asks before each file write unless you have allow-listed the path.

## Install

Clone the repo, then link **both** skill folders into your Claude Code skills directory:

```bash
git clone https://github.com/kaushikhegde11/obsidian-project-memory /tmp/opm
ln -s /tmp/opm/obsidian-project-memory ~/.claude/skills/obsidian-project-memory
ln -s /tmp/opm/obsidian-project-update ~/.claude/skills/obsidian-project-update
```

(Or copy the two folders instead of symlinking. Keep the repo somewhere stable if you symlink.)

Claude Code discovers the skills on the next session.

## First run: configuration (works with any folder)

These skills hardcode **no** vault structure. On first use, the skill asks:

1. Your **vault root** path.
2. Which **folder** should hold project memory — any folder you like: `Projects memory`, `2. Source Material/Projects`, `Areas/Projects`, or `""` for the vault root.
3. Your **date format**.

It saves the answers to `project-memory-config.yaml` and reuses them after that. To reconfigure, edit or delete that file.

### Configure by hand instead

```bash
cp ~/.claude/skills/obsidian-project-memory/project-memory-config.example.yaml \
   ~/.claude/skills/obsidian-project-memory/project-memory-config.yaml
```

`project-memory-config.example.yaml` documents every field. Your real `project-memory-config.yaml` is gitignored — it holds a machine path and is never committed.

## Usage

Create memory for a project:

```
/obsidian-project-memory
set up project memory for <project name>
<paste the project context>
```

Later, log an update:

```
/obsidian-project-update
update <project name>: shipped X, decided Y because Z, next is W
```

The update skill refreshes `STATUS.md`, prepends a dated `progress.md` entry, appends any decision to `Decision.md`, and touches `README.md` only if the project's direction changed. If context is missing, the skills ask before inventing it.

## Security

These skills run entirely on your machine, only under the folder you configure, with no network calls. See [`SECURITY.md`](SECURITY.md). A `scripts/check-secrets.sh` guard helps contributors avoid committing personal paths, emails, or keys.

## Related

- [obsidian-notes-skill](https://github.com/kaushikhegde11/obsidian-notes-skill) — files and formats notes into your Obsidian vault (Zettelkasten / PARA / flat / custom) with a first-run setup wizard.

## License

[MIT](LICENSE).
