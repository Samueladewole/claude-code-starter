# Your First Week With Claude Max

Max gives you one subscription across several different products. Most new
subscribers use one of them and never find the others, so start here.

## The five places Claude lives

| Where | What it is for |
|---|---|
| **claude.ai** (browser) | Thinking, writing, research, anything with documents |
| **Desktop app** (Mac/Windows) | The same, plus connectors to your own files and apps |
| **Mobile app** | Capture and quick questions. Voice input is genuinely good |
| **Claude Code** (terminal) | Writing and changing code in a real repository |
| **IDE extension** (VS Code, JetBrains) | Claude Code, inside your editor |

Same subscription, same account, same conversation history on the first three.
Claude Code is separate: it runs on your machine and touches your actual files.

## Day one: claude.ai

**Start a Project, not a chat.** A Project is a folder with memory. You give it
files and a short instruction about what it is for, and every conversation
inside it inherits that context. One Project per real thing in your life. A
chat you start from the home page forgets everything the moment you close it.

**Turn on the connectors you already use.** Gmail, Calendar and Drive are the
useful ones. Once connected, "what did I agree to in that thread last Tuesday"
becomes a question you can actually ask.

**Learn what Artifacts are.** When Claude writes something substantial, a
document, a chart, a small web app, it appears in a panel beside the chat
instead of scrolling past in the message. You can edit it, iterate on it, and
publish it as a private page with its own link.

## Day two: pick the right model

You can switch models in the picker. The default is usually right, but it helps
to know the shape of the choice:

- **Opus** is the deep one. Hard reasoning, long multi-step work, code you care about.
- **Sonnet** is the balanced one. Fast and strong for most everyday work.
- **Haiku** is the quick one. Simple, high-volume tasks where speed matters.

If an answer feels shallow, move up. If you are waiting around for something
simple, move down. That is the whole heuristic.

## Day three: Claude Code

```bash
npm install -g @anthropic-ai/claude-code
cd ~/some/real/project
claude
```

It authenticates with the same Max account, no API key and no extra billing.

Three things to internalise before anything else:

**It reads before it writes.** Ask a question about the codebase first. "What
does this service actually do?" Watch how it explores. That tells you whether
it understood the repo before you let it change anything.

**Permission modes matter.** By default it asks before editing files or running
commands. Leave it that way for a week. You will learn what it wants to do, and
you will catch the one time in twenty where it wants to do something you did
not intend.

**It works best on a clean git branch.** Commit before you start. Then whatever
happens, `git diff` tells you the truth and `git checkout .` undoes it.

## Day four: make it yours

`~/.claude/CLAUDE.md` loads into every session on your machine. Your stack, your
conventions, the things you never want it to do. This single file is the
difference between an assistant that guesses your setup and one that knows it.

This starter ships a template. Fill it in. Ten minutes there saves you from
correcting the same thing all week.

## Day five: stop doing it the slow way

The common mistake is to use Claude as a faster autocomplete, one function at a
time. The actual gain comes from handing over a whole task with clear
boundaries and verifiable output.

Not: "write a function that validates an email"
But: "add email validation to the signup flow, with tests, and show me the diff"

Read `docs/02-working-well.md` next. It is short and it is the part that
separates people who find this useful from people who find it frustrating.

## What to ignore for now

Skills, hooks, MCP servers, subagents and custom commands are all real and all
useful. None of them need your attention in week one. The handful this starter
installs work on their own without you learning anything about them first.

A large configuration you do not understand is worse than a small one you do.
Grow it when something annoys you twice, and read docs/03-make-it-yours.md when
that happens.
