# Claude Code Starter

A ready-made setup for Claude Code, plus the guide I wish I had in my first
week.

**New to all this?** Start at [Setting up](#setting-up) and follow it line by
line. You do not need to understand any of it yet. It takes about ten minutes
and you cannot break anything.

**Done this before?** Three commands:

```bash
npm install -g @anthropic-ai/claude-code
git clone https://github.com/Samueladewole/claude-code-starter.git
cd claude-code-starter && ./install.sh
```

---

## What this actually is

Claude Code is Claude running in your terminal, able to read and change files
in a real project. Out of the box it knows nothing about how you like to work.

This repo fills that in: a set of standing instructions, some shortcuts, and a
few safety nets. It is small on purpose. You will be able to read all of it in
an afternoon and change anything that does not suit you.

---

## Setting up

### What you need first

**A paid Claude plan** (Pro or Max). Claude Code signs in with the same
account you use on claude.ai. There is no API key and no separate bill.

**Node.js**, which is a program that lets your computer run the installer.
You may already have it.

### Step 1 — Open the terminal

The terminal is a window where you type commands instead of clicking.

- **Mac**: press `Cmd + Space`, type `Terminal`, press Enter.
- **Windows**: you need WSL, which runs Linux inside Windows. Open PowerShell
  as administrator, run `wsl --install`, restart, then open the Ubuntu app.
  Everything below happens in that Ubuntu window, not in PowerShell.
- **Linux**: `Ctrl + Alt + T`.

A window opens with a blinking cursor. Commands get typed there and run when
you press Enter. Nothing happens until you press Enter.

### Step 2 — Check you have Node.js

Type this and press Enter:

```bash
node --version
```

If you see something like `v20.11.0`, you are fine as long as the first number
is 18 or higher. Skip to step 3.

If you see `command not found`, install it:

- **Mac**: go to [nodejs.org](https://nodejs.org), download the LTS version,
  open the file, click through the installer. Then **close the terminal
  window and open a new one** — it will not notice Node until you do.
- **Windows (in Ubuntu)**: `sudo apt update && sudo apt install nodejs npm`
- **Linux**: `sudo apt install nodejs npm`, or whatever your distribution uses.

Run `node --version` again. You should get a number now.

### Step 3 — Install Claude Code

```bash
npm install -g @anthropic-ai/claude-code
```

This takes a minute or two and prints a lot of text. That is normal. As long
as it ends without the word `error`, it worked.

If it fails with a permissions complaint, see
[If something goes wrong](#if-something-goes-wrong) below.

### Step 4 — Download this setup

```bash
git clone https://github.com/Samueladewole/claude-code-starter.git
```

This copies this repo into a folder on your computer, in whichever directory
your terminal is currently sitting. That is usually your home folder, which is
fine.

### Step 5 — Run the installer

```bash
cd claude-code-starter
./install.sh
```

`cd` means "go into that folder". The second line runs the installer.

### Step 6 — Check it worked

The installer finishes by telling you exactly what it put on your computer:

```
What you have now
  CLAUDE.md   yes — edit this first
  rules       6 files
  commands    6 commands
  agents      3 agents
  hooks       2 hooks
  skills      5 linked
```

If every line has a number next to it, you are done. If a line says `0` or
`MISSING`, the installer will have printed a short explanation under "Worth
knowing". Fix that and run `./install.sh` again. Running it twice is safe.

---

## Now do the one thing that matters

Open this file in a text editor:

```
~/.claude/CLAUDE.md
```

The `~` means your home folder. On a Mac you can open it with:

```bash
open -e ~/.claude/CLAUDE.md
```

It is full of TODOs: what you build, what language you use, how you want to
be spoken to, things you never want Claude to do. **Fill them in.** Ten
minutes here is worth more than every other file in this repo combined,
because that file loads into every conversation you ever have.

Writing nothing is fine too. It just means Claude guesses, and it will guess
the most common setup on the internet rather than yours.

---

## Your first real session

Go into a project you actually work on and start Claude:

```bash
cd ~/path/to/your/project
claude
```

The first time, it opens a browser window to log in. Use your Claude account.

Then try asking a question before asking for any changes. Something like
"what does this project do?" Watch how it explores the files. That tells you
whether it understood your code before you let it touch anything.

Two habits worth forming on day one:

**Commit your work before you start.** Then if a change goes wrong,
`git checkout .` undoes all of it and you have lost nothing.

**Leave the permission prompts on.** Claude asks before editing files or
running commands. Keep it that way for a week. You will learn what it tends
to do, and you will catch the one time in twenty where it wants to do
something you did not intend.

---

## If something goes wrong

**`command not found: npm`**
Node.js is not installed, or you did not open a new terminal window after
installing it. Go back to step 2.

**`command not found: git`**
On a Mac, run `xcode-select --install` and click through the prompt. On
Ubuntu, `sudo apt install git`.

**`EACCES` or `permission denied` when installing Claude Code**
npm is trying to write somewhere it is not allowed. The clean fix:

```bash
mkdir -p ~/.npm-global
npm config set prefix ~/.npm-global
echo 'export PATH=~/.npm-global/bin:$PATH' >> ~/.zshrc
source ~/.zshrc
npm install -g @anthropic-ai/claude-code
```

If your shell is bash rather than zsh, use `~/.bashrc` in place of `~/.zshrc`.

**`./install.sh: Permission denied`**
Run `chmod +x install.sh`, then `./install.sh` again.

**`claude: command not found` after installing it**
Close the terminal window and open a new one. If it still happens, the
permissions fix above usually sorts it.

**The installer said it could not reach GitHub**
You were offline, or a network blocked it. Everything except the skills
installed. Run `./install.sh` again when you have a connection.

**Something else**
Open an issue on this repo, or ask Claude itself. Paste the exact error text
rather than describing it.

---

## What is in here

You do not need to read this section to get started. It is here for when you
want to know what the installer put on your machine.

```
CLAUDE.md             Your standing instructions. Loads into every session.
settings.json         Wires up the two hooks below.
mcp.json.example      Connections to outside tools. For later.
install.sh            The installer.

rules/                Reference files your CLAUDE.md can point at.
  coding-style.md       Small files, immutability, error handling
  testing.md            Coverage expectations, TDD loop, edge cases
  security.md           Pre-commit checklist, secret handling, red flags
  git-workflow.md       Commit format, what to check before committing
  writing.md            How to write prose a human wants to read
  working-with-ai.md    When to plan, what to scrutinise, how to verify

commands/             Things you type, starting with a slash.
  /plan                 Implementation plan with an approval gate
  /tdd                  Test-first workflow
  /code-review          Quality and security review of a change
  /verify               Build, types, lint, tests before you commit
  /build-fix            Fix build errors with minimal changes
  /security             OWASP-oriented audit

skills/               Not files in this repo. The installer links five from
                      github.com/Samueladewole/claude-skills, so the same
                      file never lives in two places:
  writing-plans             Turn a vague task into a plan worth approving
  executing-plans           Work a plan task by task, verifying each
  verifying-before-done     Run the check and quote the output before
                            claiming something works
  debugging-systematically  Find the cause before changing code
  reducing-entropy          Bias toward deletion

agents/               Specialists Claude calls in for matching work.
  code-reviewer         Reviews changes for quality and maintainability
  security-reviewer     Flags secrets, injection, auth gaps
  planner               Breaks complex work into phases

hooks/                Run automatically, whatever Claude decides.
  secret-scan-gate.py   Blocks writes containing API keys and private keys
  block-skip-hooks.py   Blocks git commit --no-verify

docs/
  01-first-week-with-max.md   All five places Claude lives, and what each is for
  02-working-well.md          The ten corrections that matter most
  03-make-it-yours.md         Adding commands, rules, skills, hooks, MCP servers
```

**The difference between a command and a skill**, since it trips everyone up:
you type a command when you want it. A skill fires on its own when your work
matches what it is for. Neither costs you anything until it is used.

---

## Read in this order

1. `docs/01-first-week-with-max.md` before anything else. A paid Claude plan
   is five different products and most people only ever find one.
2. Fill in `~/.claude/CLAUDE.md`.
3. Use it on a real project for a week.
4. `docs/02-working-well.md` once you have felt the friction it describes.
5. `docs/03-make-it-yours.md` when something has annoyed you twice.

---

## Flags

```bash
./install.sh                 everything, including five skills
./install.sh --no-skills     config only
./install.sh --help          what the flags do
```

Safe to run more than once. Anything it replaces is backed up to
`~/.claude-backups/`, a `CLAUDE.md` you have edited is never overwritten, and
an existing `settings.json` is merged rather than replaced.

---

## A word on growth

There are nearly 400 more skills at
[claude-skills](https://github.com/Samueladewole/claude-skills), plus hooks,
MCP servers and subagents you have not touched. Resist all of it for now.

Every piece of configuration is something that can break, go stale, or change
behaviour in a way you later cannot explain. When you have twenty of them and
something behaves oddly, you will not know which one did it.

Add one when you have wanted it twice. Delete one the moment you notice you
have stopped using it. The setup that helps you is the one you can still
explain six months from now.

---

## Licence

MIT, see `LICENSE`. Everything here is original work. Take it, change it, keep
nothing you do not use.
