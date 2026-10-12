# Vibe Coding Responsibly — Meta-Coordination Rules

Adapted from Anthropic guidance on working effectively with coding agents.
Principle: Forget the code exists, but not the product.

This rule file governs HOW all other skills, commands, and rules get applied.
It is the orchestration layer, not a coding skill.

---

## 1. Be Claude's PM

Before writing code, act as a product manager — not a typist.

**For non-trivial tasks (multi-file, new features, architectural changes):**
- Spend effort on context gathering BEFORE execution — explore the codebase, identify files, understand patterns, build a plan
- Ask: "What would a new engineer on this team need to know to succeed at this task?"
- Capture the plan as a document (in chat or file), then execute from it
- The plan should define WHAT and WHY, not over-constrain HOW — models do best when not over-constrained on implementation details
- Use `/plan` for the structured version of this

**For simple tasks (bug fix, single-file tweak):**
- Skip the PM phase. Just do it.

## 2. Leaf Nodes vs Core Architecture

Not all code deserves the same level of scrutiny. Tier your work:

### Core Architecture (high scrutiny)
Files that other code depends on. Changes here compound. Tech debt here is dangerous.
- Auth middleware, API route handlers, database schemas, shared utilities
- State management, data models, service layers, config/env setup
- Anything in `lib/`, `server/`, `middleware/`, schema files, migration files

**Rules for core:**
- Human-review every change. Read the diff.
- Apply `/code-review` and `/security` after changes
- Write thorough tests (unit + integration + E2E)
- Require 100% test coverage on auth/payment/security (existing rule)
- Refactor for clarity — extensibility matters here

### Leaf Nodes (lighter scrutiny)
End features that nothing else depends on. Self-contained. Replaceable.
- Individual page components, UI features, one-off scripts
- Anything in `app/*/page.tsx`, feature-specific components, standalone utilities
- Marketing pages, dashboards, admin panels

**Rules for leaves:**
- Verify at the PRODUCT level — does the feature work? Does it look right?
- E2E and acceptance tests matter more than unit tests
- Tech debt is acceptable — these are replaceable
- Trust Claude more. Review tests and behavior, not every line.
- Apply `/verify` (build + types + lint + tests pass) as minimum gate

### How to classify
When planning a task, explicitly identify which files are core vs leaf:
- Core: "This changes the auth middleware — full human review required"
- Leaf: "This adds a new dashboard widget — verify it works, tests pass"

## 3. Design for Verifiability

Before building, ask: "How will a human confirm this works WITHOUT reading the code?"

**During planning (`/plan`):**
- Define acceptance criteria that are testable at the product level
- Design human-verifiable inputs and outputs at system boundaries
- Identify what "done" looks like to a user, not just to a test suite

**Verification hierarchy (from most to least trustworthy for AI code):**
1. **Product verification** — use the feature, see it work
2. **E2E tests** — test the full path a user would take
3. **Integration tests** — test system boundaries and contracts
4. **Unit tests** — test isolated logic (can be gamed by AI — green tests, wrong behavior)

**Key insight:** For AI-generated code, E2E tests are more trustworthy than unit tests because the AI can write passing unit tests for broken behavior. Prefer minimal, general end-to-end tests over exhaustive implementation-specific tests.

When using `/tdd`:
- Start with 2-3 E2E tests covering happy path + key error cases
- Write them at the product level (user does X → system does Y)
- THEN write implementation. THEN add unit tests for edge cases.
- Review the tests FIRST — if the tests are right and they pass, confidence is high

## 4. Session Management

Long sessions accumulate context noise. Manage them deliberately.

**The plan-compact-execute pattern:**
1. **Explore** — find relevant files, understand patterns, identify constraints
2. **Plan** — synthesize into a plan document capturing requirements + approach
3. **Compact** — at this natural stopping point, compact or start fresh session
4. **Execute** — work from the plan in a clean context

**When to compact or start fresh:**
- After completing a logical phase (planning done, feature done, review done)
- When context feels noisy (names drifting, patterns inconsistent)
- Before switching from exploration mode to execution mode
- At any point where a human would "take a break and come back"

**When NOT to compact:**
- Mid-implementation when state matters
- When the current context has important discoveries not yet documented

## 5. Tech Debt Strategy

Tech debt is the ONE thing that can't be validated without reading the code.
Contain it strategically:

- **Leaf nodes:** Tech debt is acceptable. These are self-contained and replaceable. When the next model is better, regenerate them.
- **Core architecture:** Tech debt is dangerous. Other things depend on this. Invest human review time here. Keep it clean, extensible, understandable.
- **The containment rule:** Never let vibe-coded leaf node patterns leak into core. If a leaf node grows into something other code depends on, it graduates to core — refactor it first.

## 6. Command Orchestration

This is how the meta-layer maps to existing commands based on task context:

| Task Type | Commands to Apply | Review Intensity |
|-----------|-------------------|------------------|
| Core architecture change | `/plan` → `/tdd` → `/code-review` → `/security` → `/verify` | Full human review |
| New feature (leaf) | `/plan` (light) → build → `/verify` | Review tests + product behavior |
| Bug fix (core) | `/tdd` → `/code-review` → `/verify` | Read the diff |
| Bug fix (leaf) | Fix → `/verify` | Confirm it works |
| UI component | Apply design rules → build → `/verify` | Visual review |
| Refactor | `/plan` → `/code-review` → `/verify` | Full human review |

## 7. The Exponential

The length of tasks AI can handle is doubling every ~7 months. Prepare for this:

- Structure work so longer autonomous runs remain safe and recoverable
- Use git commits as checkpoints — commit working states before big changes
- Design features with clear boundaries so they can be built independently
- Invest in acceptance tests and E2E tests — they scale as task size grows
- The skills that matter most are: knowing what to build, defining requirements, designing verification, understanding the product. Implementation becomes commodity.

**The mindset shift:** You are not an individual contributor who writes code. You are a technical product manager who defines what good looks like and verifies the result. The code is the assembly — you work above it.

---

## Summary

```
Before coding:  Be the PM. Gather context. Define acceptance criteria.
During coding:  Core = full rigor. Leaf = trust + verify product behavior.
After coding:   Verify at the product level first, code level second.
Always:         Contain tech debt to leaves. Protect core architecture.
                Compact at natural stopping points. The exponential is real.
```

## Deep Dive References
- `/plan` — structured planning with approval gate
- `/tdd` — test-driven development workflow
- `/code-review` — quality + security review
- `/verify` — pre-commit verification
- `/security` — OWASP security audit
- `/build-fix` — fix build errors minimally

The table above also names `/dev`, a single command chaining plan → build →
review → verify. This starter does not ship it: run the four in sequence until
you know whether you want them chained. See docs/03-make-it-yours.md.
