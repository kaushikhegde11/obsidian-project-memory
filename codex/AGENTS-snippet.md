# AGENTS.md snippet — optional

The two `/project-memory` and `/update-project-memory` prompts only fire when you
type the slash command. If you also want Codex to reach for them on its own — when
you say "log progress on X" without the command — append the block below to your
Codex instructions file:

- global: `~/.codex/AGENTS.md`
- per-project: `AGENTS.md` at the repo root

Copy from the line after this paragraph.

---

## Project memory (Obsidian)

The user keeps durable per-project memory in an Obsidian vault: one folder per
project holding `README.md` (stable overview), `STATUS.md` (current snapshot),
`progress.md` (dated diary, newest first), and `Decision.md` (decisions with
rationale).

- When the user asks to **set up** project memory, track a project, or pastes
  project context to file — follow `~/.codex/prompts/project-memory.md`.
- When the user asks to **update** a project, log progress, record a decision, or
  refresh the status — follow `~/.codex/prompts/update-project-memory.md`.

Config lives at `~/.config/project-memory/config.yaml` (`vault_root`,
`projects_folder`, `date_format`). Read it before writing anything. Never
hardcode a vault folder, and never fabricate status, decisions, or history — ask.

The vault usually sits outside the workspace sandbox. If a write is refused, ask
the user to add the vault path as a writable root rather than guessing another
location.
