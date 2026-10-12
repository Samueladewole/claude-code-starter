---
name: debugging-systematically
description: Use when facing a bug, a failing test, or behaviour nobody expected — find the cause before changing anything, rather than trying fixes until one sticks.
---

# Debugging Systematically

## The rule

Find the cause before you change the code. A fix applied before the cause is
known is a guess, and a guess that happens to work is worse than one that
fails, because it hides the real fault until later.

## The loop

**1. Reproduce it.** Get a command that fails every time. If it fails
intermittently, find what makes it reliable before going further: a specific
input, an order of operations, a cold cache. An intermittent bug you cannot
trigger on demand cannot be confirmed fixed either.

**2. Read the actual error.** All of it. The stack trace names a file and a
line, and the line it names is information, even when the real cause sits three
frames up. Error text skimmed is the single most common reason debugging takes
an afternoon instead of ten minutes.

**3. Narrow it.** Find the smallest input or shortest path that still fails.
Delete everything the bug does not need. Each thing removed that keeps the
failure alive is a thing proven innocent.

**4. Form one hypothesis.** State it so it can be wrong: "the date is parsed as
UTC but rendered as local, so anything after 23:00 shows tomorrow." A
hypothesis you cannot disprove is not a hypothesis.

**5. Test that one hypothesis.** Change one thing. Log one value. If you change
three things and the failure goes away, you have learned nothing and acquired
two unexplained edits.

**6. Only now, fix it.** And fix the cause, not the symptom. If a value arrives
null, find out why it is null before adding a null check. Sometimes the null
check is right. Often it buries a bug that resurfaces somewhere less convenient.

**7. Prove it.** Write a test that fails before the fix and passes after. That
test is the only durable evidence the bug is gone and the only thing stopping
it from coming back.

## Signs you have stopped debugging and started guessing

- Changing things to see what happens
- Several edits in flight at once, none of them explained
- "Let me try adding await here"
- Reaching for a library change before understanding the failure
- The error message is still unread
- You cannot say, in one sentence, what you currently believe is wrong

When you notice any of these, stop and go back to step one. Starting over
costs minutes. Guessing costs the afternoon and leaves a mess behind.

## When you are genuinely stuck

Write down what you know to be true, what you have ruled out and how, and what
you expected to happen instead. Most of the time the contradiction becomes
visible as you write it. When it does not, you now have something precise to
hand to another person.

## One thing worth saying out loud

If the bug is in code I wrote in this session, say so. Knowing whether the
fault is new or long-standing changes where it is worth looking.
