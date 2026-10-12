#!/usr/bin/env python3
"""PreToolUse hook: Scan file writes/edits for hardcoded secrets before they land.

Checks Write and Edit tool calls for patterns matching API keys, private keys,
database URLs with passwords, and other secrets. Blocks the write if found.

Fails open on any error — secret scanning should never break the workflow.
"""

import sys
import json
import re

SECRET_PATTERNS = [
    # AWS
    (r'AKIA[0-9A-Z]{16}', 'AWS Access Key ID'),
    # Generic sk- keys (Stripe, OpenAI, Anthropic, etc.)
    (r'sk-[a-zA-Z0-9_-]{20,}', 'Secret key (sk-...)'),
    (r'sk_live_[a-zA-Z0-9]{20,}', 'Stripe live secret key'),
    (r'sk_test_[a-zA-Z0-9]{20,}', 'Stripe test secret key'),
    # Private keys
    (r'-----BEGIN (?:RSA |EC |DSA |OPENSSH )?PRIVATE KEY-----', 'Private key block'),
    # Database URLs with embedded passwords
    (r'(?:postgres|mysql|mongodb(?:\+srv)?)://[^:\s]+:[^@\s]+@[^\s]+', 'Database URL with password'),
    # GitHub tokens
    (r'ghp_[A-Za-z0-9]{36}', 'GitHub PAT'),
    (r'gho_[A-Za-z0-9]{36}', 'GitHub OAuth token'),
    (r'ghs_[A-Za-z0-9]{36}', 'GitHub App token'),
    (r'github_pat_[A-Za-z0-9_]{22,}', 'GitHub fine-grained PAT'),
    # Google
    (r'AIza[A-Za-z0-9_-]{35}', 'Google API key'),
    # Slack
    (r'xox[bpras]-[0-9a-zA-Z-]{10,}', 'Slack token'),
    # Anthropic
    (r'sk-ant-[a-zA-Z0-9_-]{20,}', 'Anthropic API key'),
    # Twilio
    (r'SK[0-9a-fA-F]{32}', 'Twilio API key'),
    # SendGrid
    (r'SG\.[A-Za-z0-9_-]{22}\.[A-Za-z0-9_-]{43}', 'SendGrid API key'),
    # Vercel
    (r'vercel_[A-Za-z0-9_-]{24,}', 'Vercel token'),
    # Supabase
    (r'sbp_[A-Za-z0-9]{40,}', 'Supabase service key'),
    # Firebase
    (r'(?i)firebase[_-]?(?:api[_-]?key|token)\s*[:=]\s*["\']?[A-Za-z0-9_-]{20,}', 'Firebase key'),
]

# Files where secret-like patterns are expected
SKIP_PATTERNS = [
    r'\.example$',
    r'\.template$',
    r'\.sample$',
    r'secret-scan-gate\.py$',
    r'\.test\.[jt]sx?$',
    r'\.spec\.[jt]sx?$',
    r'__tests__/',
    r'test/',
    r'fixtures/',
    r'mocks/',
    r'\.md$',
]


def should_skip(filepath):
    return any(re.search(p, filepath) for p in SKIP_PATTERNS)


def scan(content):
    if not content:
        return []
    findings = []
    seen = set()
    for pattern, label in SECRET_PATTERNS:
        for match in re.finditer(pattern, content):
            value = match.group()
            if value in seen:
                continue
            seen.add(value)
            redacted = value[:8] + "..." + value[-4:] if len(value) > 16 else value[:8] + "..."
            findings.append((label, redacted))
    return findings


def main():
    try:
        data = json.loads(sys.stdin.read())
        tool = data.get("tool_name", data.get("tool", ""))
        params = data.get("tool_input", data.get("parameters", {}))

        if tool == "Write":
            content = params.get("content", "")
            filepath = params.get("file_path", "")
        elif tool == "Edit":
            content = params.get("new_string", "")
            filepath = params.get("file_path", "")
        else:
            return

        if should_skip(filepath):
            return

        findings = scan(content)
        if findings:
            lines = [f"  {label}: {value}" for label, value in findings[:5]]
            print(f"BLOCKED: Potential secrets detected in {filepath}")
            print("\n".join(lines))
            if len(findings) > 5:
                print(f"  ... and {len(findings) - 5} more")
            print("\nMove secrets to environment variables and reference via process.env")
            sys.exit(1)

    except json.JSONDecodeError:
        pass
    except Exception:
        pass


if __name__ == "__main__":
    main()
