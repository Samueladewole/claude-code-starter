# Common Git Workflow Rules

## Commit Messages
Format: `<type>: <description>`

Types: feat, fix, refactor, docs, test, chore, perf, ci

Examples:
- `feat: add subscription billing with Stripe`
- `fix: prevent race condition in payment webhook`
- `refactor: extract auth middleware from route handlers`

## Before Committing
1. Run `/verify` (or at minimum: typecheck + lint + tests)
2. Review `git diff` — understand every change
3. Stage specific files (not `git add .`)
4. No console.log, no TODO without ticket, no commented-out code

## PR Workflow
1. Analyze full commit history (not just latest commit)
2. Use `git diff [base-branch]...HEAD` for full picture
3. Write comprehensive summary with test plan
4. Push with `-u` flag

## Never
- Force push to main/master
- Skip hooks (`--no-verify`)
- Commit .env files or secrets
- Amend published commits without team awareness
