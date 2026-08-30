# /update-project-memory

You were invoked as the `/update-project-memory` command. The user wants to update the memory of a project that already exists.
Follow the instructions below for this turn. Anything the user typed after the
command is the project context — read it before you start asking questions.

---

# Update Project Memory

Update the memory of a project that already has a `project-memory` folder. This skill is the update half of the pair. It does not create new project memory — for that, use `project-memory`.

Tool-neutral: it works in any coding agent that can read and write files — Claude Code (as a skill), OpenAI Codex (as an `/update-project-memory` prompt), or any other assistant with vault access. Below, "you" means whichever assistant is running these instructions.

## Prerequisite: vault access + existing memory
- Assumes you **already have read, create, and edit access** to the vault — through the Obsidian MCP server, plain filesystem tools, or your own sandbox mount. This skill does not set up access. If you cannot read or write the vault, stop and ask the user to grant it. In a sandboxed agent (Codex's default is workspace-write on the current directory only), ask the user to add the vault path as a writable root.
- Assumes the project's memory folder and its four files already exist. If they do not, tell the user to run `project-memory` first.

## Configuration (no fixed folders)
Read `project-memory-config.yaml` (shared with `project-memory`). Resolve its path in this order and use the first that exists:

1. `$PROJECT_MEMORY_CONFIG`
2. `~/.config/project-memory/config.yaml`
3. `~/.claude/skills/project-memory/project-memory-config.yaml`
4. `~/.codex/project-memory-config.yaml`

Get `vault_root`, `projects_folder`, and `date_format`. Never hardcode a folder. If no config is found, ask for those values and save them to `~/.config/project-memory/config.yaml` (same steps as `project-memory`).

## Which project
If the target project is not clear, ask which one. Resolve its folder: `<vault_root>/<projects_folder>/<Project Name>/`.

## What to update
Read the four files first. Then apply only the parts the update calls for.
1. **STATUS.md** — refresh the snapshot: where it stands, next action, blockers, needs review. Replace the old snapshot and update the `Last updated` date.
2. **progress.md** — prepend one new dated entry: what happened, what changed, next.
3. **Decision.md** — if the update contains a decision, append it: what was decided, why, when to revisit.
4. **README.md** — update **only if** the project direction or overview changed (what it is / why / who / how AI should help / links). Leave it untouched otherwise.

## Rules
- Make targeted edits. Do not overwrite a whole file when a small edit is enough. Prepend to progress, append to decisions, refresh status in place.
- One project per folder. Do not touch other projects.
- Date every new progress and decision entry in the configured format.
- If the update is ambiguous or context is missing, ask. Do not fabricate status, decisions, or history.
