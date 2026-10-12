---
description: Restate requirements, assess risks, and create step-by-step implementation plan. WAIT for user CONFIRM before touching any code.
---

# Plan Command

This command invokes the **planner** agent to create a comprehensive implementation plan before writing any code.

## What This Command Does

1. **Restate Requirements** - Clarify what needs to be built
2. **Identify Risks** - Surface potential issues and blockers
3. **Create Step Plan** - Break down implementation into phases
4. **Wait for Confirmation** - MUST receive user approval before proceeding

## When to Use

Use `/plan` when:
- Starting a new feature
- Making significant architectural changes
- Working on complex refactoring
- Multiple files/components will be affected
- Requirements are unclear or ambiguous

## How It Works

The planner agent will:

1. **Analyze the request** and restate requirements in clear terms
2. **Break down into phases** with specific, actionable steps
3. **Identify dependencies** between components
4. **Assess risks** and potential blockers
5. **Security assessment** (MANDATORY — never skip):
   - Auth & access control: who can access this? What middleware/guards are needed?
   - Input validation: what user input enters the system? Zod schemas defined?
   - Data exposure: what sensitive data is involved? PII, financial, credentials?
   - Attack surface: new API routes, webhooks, file uploads, third-party integrations?
   - OWASP check: injection, XSS, CSRF, SSRF, broken access control risks?
   - Compliance: any regulation that applies to this data? (GDPR, HIPAA, PCI-DSS, local law)
   - Secrets: any new API keys, tokens, or credentials needed? Stored in env vars only?
   - Rate limiting: public endpoints must have rate limits
6. **Estimate complexity** (High/Medium/Low)
7. **Present the plan** and WAIT for your explicit confirmation

## Example Usage

```
User: /plan I need to add real-time notifications when markets resolve

Agent (planner):
# Implementation Plan: Real-Time Market Resolution Notifications

## Requirements Restatement
- Send notifications to users when markets they're watching resolve
- Support multiple notification channels (in-app, email, webhook)
- Ensure notifications are delivered reliably
- Include market outcome and user's position result

## Implementation Phases

### Phase 1: Database Schema
- Add notifications table with columns: id, user_id, market_id, type, status, created_at
- Add user_notification_preferences table for channel preferences
- Create indexes on user_id and market_id for performance

### Phase 2: Notification Service
- Create notification service in lib/notifications.ts
- Implement notification queue using BullMQ/Redis
- Add retry logic for failed deliveries
- Create notification templates

### Phase 3: Integration Points
- Hook into market resolution logic (when status changes to "resolved")
- Query all users with positions in market
- Enqueue notifications for each user

### Phase 4: Frontend Components
- Create NotificationBell component in header
- Add NotificationList modal
- Implement real-time updates via Supabase subscriptions
- Add notification preferences page

## Dependencies
- Redis (for queue)
- Email service (SendGrid/Resend)
- Supabase real-time subscriptions

## Risks
- HIGH: Email deliverability (SPF/DKIM required)
- MEDIUM: Performance with 1000+ users per market
- MEDIUM: Notification spam if markets resolve frequently
- LOW: Real-time subscription overhead

## Security Assessment
- **Auth**: Notification endpoints require authenticated user. Verify user owns the positions being queried.
- **Input validation**: Zod schema on notification preferences update. Validate market_id exists.
- **Data exposure**: Notification payloads may contain position amounts — ensure only the position owner sees their data.
- **Access control**: Users must only see their own notifications. Add `where user_id = currentUser.id` on all queries.
- **Rate limiting**: Notification preferences endpoint needs rate limiting (10 req/min).
- **Consent**: Email notifications may require prior opt-in under your jurisdiction's privacy law. Add a consent check before dispatch.
- **Secrets**: SendGrid/Resend API key via env var, never hardcoded.

## Estimated Complexity: MEDIUM
- Backend: 4-6 hours
- Frontend: 3-4 hours
- Testing: 2-3 hours
- Total: 9-13 hours

**WAITING FOR CONFIRMATION**: Proceed with this plan? (yes/no/modify)
```

## Important Notes

**CRITICAL**: The planner agent will **NOT** write any code until you explicitly confirm the plan with "yes" or "proceed" or similar affirmative response.

If you want changes, respond with:
- "modify: [your changes]"
- "different approach: [alternative]"
- "skip phase 2 and do phase 3 first"

## Integration with Other Commands

After planning:
- Use `/tdd` to implement with test-driven development
- Use `/build-fix` if build errors occur
- Use `/code-review` to review completed implementation

## Related Agents

This command invokes the `planner` agent provided by ECC.

For manual installs, the source file lives at:
`agents/planner.md`
