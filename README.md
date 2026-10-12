# Claude Code Starter

A small, opinionated starting configuration for someone new to Claude Code, plus
the guide I wish I had in week one.

Six commands, six rule files, five skills, three agents, two hooks and three
guides.

Deliberately small. A large configuration you did not write is harder to use
than no configuration at all, because you cannot tell which part is responsible
when something behaves oddly. Everything here is meant to be read in an
afternoon and changed the moment it stops fitting.

## Before you start

You need two things:

- **A Claude account** on a paid plan (Pro or Max). Claude Code signs in with
  it; there is no API key to set up and no separate bill.
- **Node.js 18 or newer**, which is what provides `npm`. Check with
  `node --version`. If that says "command not found", install it from
  [nodejs.org](https://nodejs.org) or, on a Mac with Homebrew,
  `brew install node`.

Git is already on macOS and most Linux systems. On Windows, use WSL.

## Install

Three commands. The third one does everything else.

```bash
npm install -g @anthropic-ai/claude-code
git clone https://github.com/Samueladewole/claude-code-starter.git
cd claude-code-starter && ./install.sh
```

That gives you the rules, commands, agents and hooks in this repo, and pulls
five skills from
[claude-skills](https://github.com/Samueladewole/claude-skills), where the
full collection of 380-odd lives. The installer prints exactly what landed, so
you never have to guess whether it worked.

It is safe to run twice. Anything it replaces is backed up to
`~/.claude-backups/`, a `CLAUDE.md` you have edited is never overwritten, and
an existing `settings.json` is merged rather than replaced.

Nothing here aborts halfway. If Claude Code is not on your PATH yet, or you
are offline, it installs what it can, tells you what it skipped, and fixes
itself when you rerun.

```bash
./install.sh --no-skills     # config only
./install.sh --help          # what the flags do
```

Then open `~/.claude/CLAUDE.md` and answer the TODOs. Ten minutes there beats
every other file combined.

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

skills/               Not in this repo — pulled from claude-skills so the
                      same file never lives in two places. install.sh links
                      five to begin with:
  writing-plans             Turn a vague task into a plan worth approving
  executing-plans           Work a plan task by task, verifying each
  verifying-before-done     Run the check and quote the output before
                            claiming something works
  debugging-systematically  Find the cause before changing code
  reducing-entropy          Bias toward deletion

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

MIT, see `LICENSE`. Everything here is original work. Take it, change it,
keep nothing you do not use.
