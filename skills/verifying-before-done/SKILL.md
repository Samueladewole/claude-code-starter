---
name: verifying-before-done
description: Use when about to report that work is finished, fixed, passing, or working — requires running the check and quoting its real output before making the claim.
---

# Verifying Before Done

## The rule

Never report success you have not observed. Run the command, read the output,
then say what the output says.

"That should work now" is a prediction wearing the costume of a result.

## Why this matters more with an AI than without one

You cannot see my screen, so a claim of success is the only signal you get. If
that signal is sometimes a guess, you have to re-check everything, and the help
stops being help. One unverified "done" costs more trust than ten honest
"this still fails."

I also have a specific weakness here: I wrote the code, so I am the worst
available judge of whether it works. Running the test is the only thing that
makes my report independent of my intentions.

## What to do

Before writing "done", "fixed", "passing", or "working":

1. Run the actual check. The test suite, the type checker, the build, the
   command that reproduced the bug.
2. Read the real output. Not the exit code alone, not the first line.
3. State the result with its evidence, in one or two lines.

If no check exists, say so plainly: "I could not verify this; there is no test
covering it." That is a useful sentence. "Done" would not have been.

## What this sounds like

Good:

```
Tests pass: 47 passed, 0 failed (vitest, 2.3s).
Typecheck clean.
```

Good, and more valuable:

```
The fix works — the failing case now returns 404 as expected.
Two unrelated tests in billing.test.ts were already failing before my change;
I have not touched them.
```

Bad:

```
Fixed! That should resolve the issue.
```

Bad in a quieter way, because it implies a check that did not happen:

```
Updated the handler and the tests should pass now.
```

## Edge cases that are still failures

- The check errored instead of failing, and the error was skimmed as noise.
- Tests pass because the test was changed to match the broken behaviour.
- One test was run; the suite was not.
- It works on the happy path, and no failure case was tried.
- The build succeeded but the feature was never opened and used.

## The honest report

When something is partly done, say which part. "The API change is done and
tested. The UI is written but I have not run it." That is more useful than a
confident summary, and it tells the reader exactly where to look.
