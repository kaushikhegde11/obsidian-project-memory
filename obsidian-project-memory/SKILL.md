---
name: obsidian-project-memory
description: Create and maintain per-project "memory" notes in the user's Obsidian vault. Each project gets its own folder with four files — README.md (stable overview), STATUS.md (current snapshot), progress.md (dated diary), Decision.md (decisions + rationale). The storage folder is configurable — no fixed vault structure. Use whenever the user says "project memory", "store memory about my project", "set up project notes", "track this project in Obsidian", "make a README/STATUS for <project>", or pastes project context to file. Companion skill: obsidian-project-update updates these files later. One project per folder — never mix two projects in one file.
---

# Obsidian Project Memory

Store durable, structured memory about a single project in the Obsidian vault. An AI assistant (or the user) reads these files later to recover full context fast.

This skill **creates** a project's memory. Its companion, `obsidian-project-update`, **updates** it.

## Prerequisite: Obsidian access
This skill assumes Claude **already has read, create, and edit access** to your Obsidian vault — through the Obsidian MCP server or direct filesystem access. This skill does not set up that access. If Claude cannot read or write the vault, stop and ask the user to grant access first.

## Configuration (no fixed folders)
This skill hardcodes no vault structure. It reads `project-memory-config.yaml` from this skill's own folder:
- `vault_root` — absolute path to the vault.
- `projects_folder` — the folder that holds each project's memory folder. Any folder the user chooses (for example `Projects memory`, `2. Source Material/Projects`, `Areas/Projects`, or `""` for the vault root).
- `date_format` — date style for the logs.

If the file is missing or incomplete, run a short setup:
1. Ask for the vault root. You may reuse `~/.claude/skills/obsidian-notes-skill/vault-config.yaml` `vault_root` if it exists.
2. Ask which folder should hold project memory. The user may pick or type **any** folder.
3. Ask the date format (default `DD-MM-YYYY`).
4. Save `project-memory-config.yaml`.

`project-memory-config.example.yaml` documents every field.

## Location and rule
- Base path: `<vault_root>/<projects_folder>/<Project Name>/`.
- Create `<projects_folder>` if it does not exist.
- **One project = one folder. Never put two projects in the same file or folder.**
- The folder name is the project name (keep it readable; spaces are fine).

## The four core files
Create all four on first setup.

### 1. `README.md` — stable overview (changes rarely)
```
# <Project Name>

## What it is
<one or two short paragraphs>

## Why it matters
<the problem it solves / the value>

## Who it is for
<target users or audience>

## Useful links
- <url> — <label>

## How AI should help
- <clear, durable guidance for an assistant working on this project>
```

### 2. `STATUS.md` — current snapshot
```
# <Project Name> — Status

_Last updated: <DATE>_

## Where it stands
<current state in a few lines>

## Next action
- [ ] <the next concrete step>

## Blockers
- <blocker, or "none">

## Needs review
- <anything awaiting a decision or review, or "none">
```

### 3. `progress.md` — dated diary (newest entry on top)
```
# <Project Name> — Progress log

## <DATE>
- What happened: <...>
- What changed: <...>
- Next: <...>
```

### 4. `Decision.md` — decision record
```
# <Project Name> — Decisions

## <short decision title> — <DATE>
- Decision: <what was decided>
- Why: <the reasoning>
- Revisit: <when or what should trigger a re-look>
```

## Intake (ask before writing)
1. **Project name.** It becomes the folder name.
2. **Context.** Ask the user to describe the project, or read the context they pasted. Pull out: what it is, why it matters, who it is for, links, current status, recent progress, and any decisions with reasons.
3. **Missing context.** If a required `README.md` field (what / why / who / how AI should help) or the current status is missing and you cannot infer it safely, **ask the user. Do not invent it.**

## Create
- Folder does not exist → create it and write all four files from the context.
- Folder already exists → this is an update. Use the `obsidian-project-update` skill instead.

## Sorting content into the right file
- Stable facts (what/why/who/links/AI guidance) → `README.md`.
- Present state, next step, blockers, review items → `STATUS.md`.
- Anything that happened on a date → `progress.md`.
- A choice plus its reason → `Decision.md`.

## Extra files (keep it minimal)
Create an extra file or subfolder only when the project clearly needs it — for example `architecture.md`, `links.md`, or a `research/` subfolder. Do not add structure the project does not need. The four core files are the default.

## Rules
- Assumes Obsidian read/create/edit access (see Prerequisite).
- One project per folder. Never mix projects.
- Date every `progress.md` and `Decision.md` entry in the configured format.
- When context is missing, ask. Do not fabricate status, decisions, or history.
