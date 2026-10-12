# Working Well With Claude Code

Everything here is a correction to a mistake most people make in their first
month. None of it is about prompting tricks.

## 1. Context is the whole job

Claude is excellent at writing code and poor at guessing which code you meant.
Almost every bad result traces back to missing context rather than missing
ability.

Before a non-trivial task, ask yourself what a new engineer joining your team
would need to know to do it. Then say that. Which files, which patterns to
follow, what already exists, what must not break.

For anything multi-file or architectural, plan first and build second. Have it
produce a plan, read the plan, correct the plan, then let it execute. Correcting
a plan costs a paragraph. Correcting a finished implementation costs an hour.

For a one-line bug fix, skip all of this and just ask.

## 2. Not all code deserves the same scrutiny

Split your codebase in two.

**Core**: things other code depends on. Auth, database schemas, API handlers,
shared utilities, migrations. Mistakes here compound and spread. Read every
diff. Demand tests. Never accept "it works" as evidence.

**Leaf**: things nothing depends on. A page component, a dashboard widget, a
one-off script. Mistakes here stay put. Check that the feature works and move
on. Imperfect code is fine; it is cheap to replace.

The failure mode is treating all code as leaf. The waste is treating all code as
core.

## 3. Decide how you will verify before you build

Ask: how will I know this works without reading the code?

In order of how much they are worth on AI-written code:

1. **Use the feature.** Open it, click it, watch it work.
2. **End-to-end tests.** A user does X, the system does Y.
3. **Integration tests.** The boundary between two parts holds.
4. **Unit tests.** Isolated logic behaves.

Unit tests rank last on purpose. A model can write passing unit tests for
broken behaviour without ever noticing, because it wrote both sides. An
end-to-end test is harder to fool because it asserts on the outcome you
actually wanted.

When you ask for tests, ask for two or three end-to-end ones covering the happy
path and the main failure, and review those first. If the tests are right and
they pass, you can trust a lot.

## 4. Manage the session

Long sessions get worse, not better. Names drift, old decisions linger,
abandoned approaches keep influencing new code.

A rhythm that works: explore, plan, clear the context, execute from the plan.
When a human would take a break, clear it. When you switch from figuring out
what to build to actually building it, clear it.

Do not clear mid-implementation when the current state matters.

## 5. Commit constantly

Every working state is a checkpoint. Commit before you start something
ambitious. Then a bad run costs you one `git checkout .` instead of an evening.

This matters more as tasks get longer. The thing that makes long autonomous runs
safe is not better supervision, it is cheap recovery.

## 6. Give it the error, not a description of the error

Paste the stack trace. Paste the failing test output. Paste the actual command
and the actual output. A summary in your own words throws away the detail that
would have located the bug.

## 7. Let it read the internet when the answer is out there

Library versions, API changes, error messages nobody has seen before. Say "look
this up" rather than accepting a confident answer about a library that changed
six months ago.

## 8. Push back

If the output is wrong, say what is wrong and why. Do not start over. The
conversation already holds all the context you spent effort building, and a
correction keeps it.

Equally: if it tells you your approach has a problem, consider that it might be
right before overruling it.

## 9. Keep the configuration small

You will be tempted to collect commands, hooks, skills and MCP servers. Most of
them you will never use, and every one is a thing that can break, go stale, or
quietly change behaviour in ways you have forgotten about.

Add a piece of configuration when something has annoyed you twice. Not before.

## 10. It is not a search engine or an oracle

It is a capable colleague who has read a great deal, cannot see your screen,
does not know what happened in your standup, and will occasionally be confidently
wrong. Treat it that way and the whole thing clicks.
