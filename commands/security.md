---
description: Run security review on current codebase. Checks OWASP Top 10, hardcoded secrets, input validation, auth, and dependencies.
---

# Security Review

Run a comprehensive security audit on the current project or specified files.

## Instructions

1. **Scan for hardcoded secrets**
   - Search for API keys, passwords, tokens, connection strings in source
   - Check `.env` files are in `.gitignore`
   - Verify no secrets in git history (`git log -p | grep -i "password\|secret\|api_key"`)

2. **OWASP Top 10 Check**
   - Injection: Parameterized queries? Input sanitized?
   - Broken Auth: Passwords hashed (bcrypt/argon2)? JWT validated? Sessions secure?
   - Sensitive Data: HTTPS enforced? PII encrypted? Logs sanitized?
   - XSS: Output escaped? CSP headers set?
   - Broken Access: Auth on every route? CORS configured?
   - Misconfiguration: Debug mode off? Security headers set?

3. **Dependency audit**
   - Run `pnpm audit` or `npm audit --audit-level=high`
   - Flag known CVEs

4. **Code pattern scan**

   | Pattern | Severity | Fix |
   |---------|----------|-----|
   | Hardcoded secrets | CRITICAL | Use `process.env` |
   | String-concatenated SQL | CRITICAL | Parameterized queries (Drizzle handles this) |
   | `innerHTML = userInput` | HIGH | Use `textContent` or DOMPurify |
   | `fetch(userProvidedUrl)` | HIGH | Whitelist allowed domains |
   | No auth check on route | CRITICAL | Add auth middleware |
   | No rate limiting | HIGH | Add rate limiting |
   | No Zod validation on input | HIGH | Add Zod schema validation |

5. **Generate report**

```
SECURITY AUDIT: [PASS/FAIL]

Secrets:     [OK/X found]
Injection:   [OK/X risks]
Auth:        [OK/X issues]
XSS:         [OK/X risks]
Dependencies: [OK/X CVEs]
Validation:  [OK/X missing]

Overall: [SAFE/AT RISK]
```

## Arguments

$ARGUMENTS can be:
- (empty) — Full project scan
- `<file-path>` — Scan specific file
- `auth` — Focus on authentication/authorization code
- `api` — Focus on API endpoints
- `deps` — Dependency audit only
