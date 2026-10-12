# Claude Code Starter

A small, opinionated starting configuration for someone new to Claude Code, plus
the guide I wish I had in week one.

Six commands, six rule files, two skills, three agents, two hooks and three
guides.

Deliberately small. A large configuration you did not write is harder to use
than no configuration at all, because you cannot tell which part is responsible
when something behaves oddly. Everything here is meant to be read in an
afternoon and changed the moment it stops fitting.

## Install

```bash
npm install -g @anthropic-ai/claude-code    # if you have not already

git clone https://github.com/Samueladewole/claude-code-starter.git
cd claude-code-starter
./install.sh
```

The installer backs up anything already in `~/.claude` before touching it, and
merges into an existing `settings.json` rather than replacing it. Running it
twice is safe.

Then open `~/.claude/CLAUDE.md` and answer the TODOs. That file is the highest
return on time in the whole setup.

## What is in here

```
CLAUDE.md             Template for your global instructions. Fill this in first.
settings.json         Wires the two hooks below. Merged into yours on install.
mcp.json.example      MCP servers, for later. Not installed by default.
install.sh            Idempotent installer with backups.

rules/                Reference files your CLAUDE.md can point at.
  coding-style.md       Small files, immutability, error handling
  testing.md            Coverage expectations, TDD loop, edge cases
  security.md           Pre-commit checklist, secret handling, red flags
  git-workflow.md       Commit format, what to check before committing
  writing.md            How to write prose a human wants to read
  working-with-ai.md    When to plan, what to scrutinise, how to verify

commands/             Typed as /name. Free until used.
  /plan                 Implementation plan with an approval gate
  /tdd                  Test-first workflow
  /code-review          Quality and security review of a change
  /verify               Build, types, lint, tests before you commit
  /build-fix            Fix build errors with minimal changes
  /security             OWASP-oriented audit

skills/               Fire on their own when the work matches. No typing.
  verifying-before-done     Run the check and quote the output before
                            claiming something works
  debugging-systematically  Find the cause before changing code

agents/               Specialists invoked for matching work.
  code-reviewer         Reviews changes for quality and maintainability
  security-reviewer     Flags secrets, injection, auth gaps
  planner               Breaks complex work into phases

hooks/                Run automatically, not by Claude's choice.
  secret-scan-gate.py   Blocks writes containing API keys and private keys
  block-skip-hooks.py   Blocks git commit --no-verify

docs/
  01-first-week-with-max.md   All five places Claude lives, and what each is for
  02-working-well.md          The ten corrections that matter most
  03-make-it-yours.md         Adding commands, rules, skills, hooks, MCP servers
```

## Read in this order

1. `docs/01-first-week-with-max.md` before you do anything else
2. Fill in `~/.claude/CLAUDE.md`
3. Use it on a real project for a week
4. `docs/02-working-well.md` once you have felt the friction it describes
5. `docs/03-make-it-yours.md` when something has annoyed you twice

## A word on growth

Every piece of configuration is a thing that can break, go stale, or change
behaviour in a way you later cannot explain. Add one when you have wanted it
twice. Delete one the moment you notice you have stopped using it.

The setup that helps you is the one you can still explain six months from now.

## Licence

MIT. Take it, change it, keep nothing you do not use.
