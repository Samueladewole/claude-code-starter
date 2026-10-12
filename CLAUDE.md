# Global Claude Code Instructions

This file loads into every Claude Code session on this machine. It is the single
highest-leverage file in your setup: a sentence here applies everywhere, forever,
without you typing it again.

Replace the TODOs with your own answers and delete anything that is not true of
you. An instruction you do not actually follow is worse than no instruction,
because it teaches Claude to discount the rest of the file.

Keep it short. Under 150 lines is a good ceiling. Long files get skimmed.

---

## Who I Am

- TODO: your name, and what you build
- TODO: your level — "senior backend engineer", "learning to code", "designer who ships"
- TODO: how you want to be spoken to — more or less explanation, more or less pushback

## My Stack

Name only what you actually use. "Any language" means Claude guesses, and it
will guess the most common thing on the internet rather than the thing you run.

- **Language**: TODO
- **Framework**: TODO
- **Database**: TODO
- **Testing**: TODO
- **Deploy**: TODO
- **Package manager**: TODO (name one; this prevents a lot of wrong commands)

## Code Style

- TODO: the two or three conventions you genuinely care about
- Example: strict types, no `any`, find the real type or create one
- Example: files under 300 lines; split when larger
- Example: functions under 50 lines, single responsibility
- Example: handle loading, error and empty states in every UI component

## Never Do

The negative list is often more useful than the positive one, because it stops
the specific things that annoy you.

- TODO: e.g. never commit secrets or `.env` files
- TODO: e.g. never use `--no-verify` on a commit
- TODO: e.g. never add dependencies without asking
- TODO: e.g. never refactor code next to what I asked you to change

## Always Do

- TODO: e.g. validate input at API boundaries
- TODO: e.g. check auth on every route that touches user data
- TODO: e.g. run typecheck and lint before telling me something is done

## Communication Style

- Lead with the answer, then the reasoning
- Be direct and concise
- Do not add features I did not ask for
- Do not add comments to code I did not change
- If something is ambiguous, ask rather than guess

## Active Projects

Listing these lets Claude recognise where it is without being told.

- TODO: `~/path/to/project` — one line on what it is and its stack
