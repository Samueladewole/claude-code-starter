# Common Security Rules

## Before Every Commit
- [ ] No hardcoded secrets (API keys, passwords, tokens)
- [ ] All user inputs validated with Zod
- [ ] SQL injection prevented (Drizzle handles this)
- [ ] XSS prevented (React handles most, sanitize raw HTML)
- [ ] Auth checked on every API route
- [ ] Error messages don't leak internal details
- [ ] No secrets logged

## Secret Management
- Use environment variables (process.env)
- Validate required env vars at startup
- Never commit .env files
- Rotate immediately if exposed

## Patterns to Flag Immediately
| Pattern | Severity |
|---------|----------|
| Hardcoded secrets in source | CRITICAL |
| Shell command with user input | CRITICAL |
| `innerHTML = userInput` | HIGH |
| `fetch(userProvidedUrl)` without whitelist | HIGH |
| No auth check on API route | CRITICAL |
| No rate limiting on public endpoint | HIGH |
| No Zod validation on request body | HIGH |

## Response Protocol
If CRITICAL vulnerability found:
1. STOP — Don't continue with other work
2. Document the issue clearly
3. Provide secure code example
4. Verify the fix works
5. Check for similar patterns elsewhere in codebase
