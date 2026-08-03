---
name: obsidian-project-update
description: Update an existing project's memory files in Obsidian from a new instruction or status update — refresh STATUS.md, prepend a dated progress.md entry, append any new decision to Decision.md, and update README.md only if the project direction changed. Companion to obsidian-project-memory. The storage folder is configurable — no fixed vault structure. Use when the user says "update project memory", "log progress on <project>", "update the status", "record a decision", "the project changed direction", or pastes a project update. Assumes Obsidian read/edit access and that the project's memory already exists.
---

# Obsidian Project Update

Update the memory of a project that already has an `obsidian-project-memory` folder. This skill is the update half of the pair. It does not create new project memory — for that, use `obsidian-project-memory`.

## Prerequisite: Obsidian access + existing memory
- Assumes Claude **already has read, create, and edit access** to the vault — through the Obsidian MCP server or direct filesystem access. This skill does not set up access. If Claude cannot read or write the vault, stop and ask the user to grant it.
- Assumes the project's memory folder and its four files already exist. If they do not, tell the user to run `obsidian-project-memory` first.

## Configuration (no fixed folders)
Read `project-memory-config.yaml` (shared with `obsidian-project-memory`). Get `vault_root`, `projects_folder`, and `date_format`. Never hardcode a folder. If the config is missing, ask for those values and save them (same steps as `obsidian-project-memory`).

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
