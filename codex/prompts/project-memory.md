# /project-memory

You were invoked as the `/project-memory` command. The user wants to create project memory in their Obsidian vault.
Follow the instructions below for this turn. Anything the user typed after the
command is the project context — read it before you start asking questions.

---

# Project Memory

Store durable, structured memory about a single project in the Obsidian vault. An AI assistant (or the user) reads these files later to recover full context fast.

This skill **creates** a project's memory. Its companion, `update-project-memory`, **updates** it.

Tool-neutral: it works in any coding agent that can read and write files — Claude Code (as a skill), OpenAI Codex (as a `/project-memory` prompt), or any other assistant with vault access. Below, "you" means whichever assistant is running these instructions.

## Prerequisite: vault access
This skill assumes you **already have read, create, and edit access** to the user's Obsidian vault — through the Obsidian MCP server, plain filesystem tools, or your own sandbox mount. This skill does not set up that access. If you cannot read or write the vault, stop and ask the user to grant access first. In a sandboxed agent (Codex's default is workspace-write on the current directory only), the vault path usually sits outside the sandbox: ask the user to add it as a writable root, or fall back to printing each file as a fenced code block for the user to paste.

## Configuration (no fixed folders)
This skill hardcodes no vault structure. It reads `project-memory-config.yaml`. Resolve the config path in this order and use the first that exists:

1. `$PROJECT_MEMORY_CONFIG` — explicit override.
2. `~/.config/project-memory/config.yaml` — canonical, tool-neutral location.
3. `~/.claude/skills/project-memory/project-memory-config.yaml` — Claude Code install.
4. `~/.codex/project-memory-config.yaml` — Codex install.

Fields:
- `vault_root` — absolute path to the vault.
- `projects_folder` — the folder that holds each project's memory folder. Any folder the user chooses (for example `Projects memory`, `2. Source Material/Projects`, `Areas/Projects`, or `""` for the vault root).
- `date_format` — date style for the logs.

If no config file is found or it is incomplete, run a short setup:
1. Ask for the vault root. You may reuse `~/.claude/skills/obsidian-notes-skill/vault-config.yaml` `vault_root` if it exists.
2. Ask which folder should hold project memory. The user may pick or type **any** folder.
3. Ask the date format (default `DD-MM-YYYY`).
4. Save the answers to `~/.config/project-memory/config.yaml`, creating the folder if needed.

`project-memory-config.example.yaml` in the repo documents every field.

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
- Folder already exists → this is an update. Use the `update-project-memory` skill instead.

## Sorting content into the right file
- Stable facts (what/why/who/links/AI guidance) → `README.md`.
- Present state, next step, blockers, review items → `STATUS.md`.
- Anything that happened on a date → `progress.md`.
- A choice plus its reason → `Decision.md`.

## Extra files (keep it minimal)
Create an extra file or subfolder only when the project clearly needs it — for example `architecture.md`, `links.md`, or a `research/` subfolder. Do not add structure the project does not need. The four core files are the default.

## Rules
- Assumes vault read/create/edit access (see Prerequisite).
- One project per folder. Never mix projects.
- Date every `progress.md` and `Decision.md` entry in the configured format.
- When context is missing, ask. Do not fabricate status, decisions, or history.
