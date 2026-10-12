# Common Coding Style Rules

## File Organization
- Many small files > few large files (300 lines max, 800 absolute max)
- Organize by feature/domain, not by type
- Flat structures over deep nesting

## Immutability
- ALWAYS create new objects, NEVER mutate
- Use spread operator, map, filter over mutation
- Prefer `const` over `let`, never `var`

## Functions
- Keep under 50 lines
- Single responsibility
- Early returns over deep nesting (max 4 levels)
- Descriptive names — the name IS the documentation

## Error Handling
- ALWAYS handle errors explicitly
- No empty catch blocks
- User-friendly messages in UI, detailed logs on server
- Never silently swallow errors

## Input Validation
- Validate at system boundaries (API routes, form submissions)
- Use Zod schemas — fail fast with clear errors
- Never trust external data

## Code Quality Checklist
- [ ] Readable and well-named
- [ ] Functions small (<50 lines)
- [ ] Files focused (<300 lines)
- [ ] No deep nesting (>4 levels)
- [ ] Proper error handling
- [ ] No hardcoded values
- [ ] No mutation (immutable patterns)
- [ ] No console.log in production code
