# Making It Yours

Read this once you have used the starter for a couple of weeks and something has
started to annoy you. That annoyance is the only good reason to add
configuration.

## The order things load

```
~/.claude/CLAUDE.md          every session, on this machine
<project>/CLAUDE.md          every session, in that project
~/.claude/rules/*.md         referenced from CLAUDE.md
~/.claude/commands/*.md      only when you type /name
~/.claude/agents/*.md        only when a task matches, or you ask
~/.claude/hooks/*            automatically, on the events you wire them to
```

The first two always cost you context. Everything below them is free until
used. That is why CLAUDE.md should stay short and commands can be as long as
they need to be.

## Adding a command

A command is a Markdown file in `~/.claude/commands/`. The filename is the
command. `deploy.md` becomes `/deploy`.

```markdown
---
description: Run the pre-deploy checklist for this project
---

Check, in order, and stop at the first failure:

1. `git status` is clean
2. Tests pass
3. Typecheck passes
4. The migration list matches what is on staging

Report each as pass or fail. Do not deploy anything.
```

Write them when you have typed the same instructions three times.

## Adding a rule

Rules are reference files that CLAUDE.md points at. Use them to keep CLAUDE.md
short while still being specific. This starter's `rules/` directory is the
pattern: one file per concern.

Point at them from CLAUDE.md with one line each:

```markdown
See `~/.claude/rules/testing.md` for test requirements.
```

## Adding a hook

A hook is a script the harness runs on an event, not something Claude chooses to
call. That makes hooks the right tool for anything that must happen every time
regardless of what Claude decides.

This starter ships two, both worth keeping:

- `secret-scan-gate.py` blocks a file write containing something that looks like
  a key. It fails open, so a bug in the hook never blocks your work.
- `block-skip-hooks.py` stops `git commit --no-verify` from being used to walk
  past your own checks.

Write your own when you need a guarantee rather than a tendency.

## MCP servers

MCP servers give Claude access to things outside your filesystem: a GitHub API,
a browser, a database, a design tool.

Copy `mcp.json.example` to `~/.claude/mcp.json` and add servers one at a time.
Keys go in your shell profile as environment variables and get referenced as
`${VAR_NAME}`. Never paste a key into the JSON file itself; it will end up in a
commit eventually.

Add one. Use it for a week. Then add another. A list of twelve servers where
four are broken and you cannot remember which is worse than three that work.

## Subagents

A subagent is a separate Claude with its own context window, given a narrow job,
reporting back only its conclusion. Good for work that would otherwise flood
your main session with file contents, such as searching a large codebase or
reviewing a diff from a fresh perspective.

They cost real tokens and you cannot watch them work. Use one when the work is
genuinely independent, not because parallel sounds faster.

## Keeping it in git

Put `~/.claude` under version control, or keep a separate repository and sync
into it. Either way you want three things: history of what changed, a way back
when a change makes everything worse, and the ability to set up a new machine in
one command.

Two rules learned the hard way:

**One direction.** Decide which copy is the real one and sync the other way
only. Two copies that both get edited will drift, and you will not notice for
months.

**Never commit secrets.** `settings.local.json`, anything with a key in it, and
your session history all stay out. Check your `.gitignore` before the first
push, not after.
