# Common Testing Rules

## Coverage
- Minimum 80% for all code
- 100% required for: financial calculations, auth logic, security-critical code

## TDD Workflow (Mandatory for new features)
1. RED — Write failing test
2. GREEN — Write minimal implementation
3. REFACTOR — Improve while tests stay green
4. REPEAT

## Test Types
| Type | What | Framework |
|------|------|-----------|
| Unit | Individual functions | Vitest |
| Integration | API endpoints, DB ops | Vitest + supertest |
| E2E | Critical user flows | Playwright |

## Edge Cases to Always Test
- Null/undefined input
- Empty arrays/strings
- Invalid types
- Boundary values (min/max)
- Error paths (network failures, DB errors)
- Special characters (Unicode, SQL chars)

## Anti-Patterns to Avoid
- Testing implementation details instead of behavior
- Tests depending on each other (shared state)
- Asserting too little
- Not mocking external dependencies
- Skipping the RED phase

## Agent Support
- Use `/tdd` command for new features
- Use tdd-guide agent proactively
- Use `/verify` before every commit
