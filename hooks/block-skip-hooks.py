#!/usr/bin/env python3

import sys
import json
import re
from pathlib import Path
# Desktop notifications are optional. Without the sibling module the hook still
# blocks; it just stays quiet. A guard that refuses to load is a guard that
# blocks everything, which is worse than one that says nothing.
try:
    from strategic_notifications import (
        send_notification, get_project_context, log_hook_activity)
except ImportError:
    def send_notification(*_args, **_kwargs): pass
    def get_project_context(): return "this project"
    def log_hook_activity(*_args, **_kwargs): pass

def block_dangerous_commands():
    """Block potentially dangerous commands that could bypass security checks."""
    
    try:
        # Read the tool use from stdin
        tool_data = json.loads(sys.stdin.read())
        
        # Claude Code sends tool_name/tool_input; older payloads used
        # tool/parameters. Accept both so the guard cannot silently no-op.
        tool = tool_data.get('tool_name') or tool_data.get('tool')
        if tool != 'Bash':
            return

        params = tool_data.get('tool_input') or tool_data.get('parameters') or {}
        command = params.get('command', '')
        
        # Block git commits with SKIP environment variables
        skip_patterns = [
            r'SKIP_\w+=.*git\s+commit',
            r'git\s+commit.*SKIP_\w+=',
            r'export\s+SKIP_\w+=.*&&.*git\s+commit',
        ]
        
        for pattern in skip_patterns:
            if re.search(pattern, command, re.IGNORECASE):
                project_context = get_project_context()
                send_notification(
                    f"🚫 BLOCKED: Attempt to skip security checks in {project_context}",
                    "Security hook prevented bypassing of quality checks"
                )
                log_hook_activity("BLOCKED", f"Skip environment variable detected: {command}")
                
                print("❌ BLOCKED: Cannot use SKIP environment variables with git commit")
                print("This bypasses important code quality and security checks.")
                sys.exit(1)
        
        # Block --no-verify flag usage
        if re.search(r'git\s+commit.*--no-verify', command, re.IGNORECASE):
            project_context = get_project_context()
            send_notification(
                f"🚫 BLOCKED: --no-verify flag usage in {project_context}",
                "Security hook prevented bypassing of pre-commit hooks"
            )
            log_hook_activity("BLOCKED", f"--no-verify flag detected: {command}")
            
            print("❌ BLOCKED: Cannot use --no-verify flag with git commit")
            print("This bypasses important pre-commit hooks and security checks.")
            sys.exit(1)
        
        # Block modifications to linting configuration files
        config_file_patterns = [
            r'(rm|mv|cp)\s+.*\.(golangci\.yml|golangci-lint\.yml|\.pre-commit-config\.yaml)',
            r'echo.*>\s*\.(golangci\.yml|golangci-lint\.yml|\.pre-commit-config\.yaml)',
            r'sed.*\.(golangci\.yml|golangci-lint\.yml|\.pre-commit-config\.yaml)',
        ]
        
        for pattern in config_file_patterns:
            if re.search(pattern, command, re.IGNORECASE):
                project_context = get_project_context()
                send_notification(
                    f"🚫 BLOCKED: Linting config modification in {project_context}",
                    "Security hook prevented modification of quality control files"
                )
                log_hook_activity("BLOCKED", f"Linting config modification: {command}")
                
                print("❌ BLOCKED: Cannot modify linting configuration files")
                print("This could weaken code quality standards.")
                sys.exit(1)
        
        # Block potentially dangerous Go commands
        dangerous_go_patterns = [
            r'go\s+mod\s+download\s+.*@latest',  # Potentially unsafe version downloads
            r'go\s+get\s+.*@master',  # Unstable branch downloads
            r'go\s+install\s+.*@latest',  # Latest version installs without verification
        ]
        
        for pattern in dangerous_go_patterns:
            if re.search(pattern, command, re.IGNORECASE):
                project_context = get_project_context()
                send_notification(
                    f"⚠️ WARNING: Potentially unsafe Go command in {project_context}",
                    f"Command flagged for review: {command[:50]}..."
                )
                log_hook_activity("WARNING", f"Potentially unsafe Go command: {command}")
                
                print(f"⚠️ WARNING: Potentially unsafe Go command detected:")
                print(f"Command: {command}")
                print("Consider using specific versions instead of @latest or @master")
                print("Continue? (y/N): ", end="")
                
                # In a hook context, we can't wait for input, so we block by default
                print("N (auto-blocked in hook context)")
                sys.exit(1)
    
    except json.JSONDecodeError:
        # Not JSON input, ignore
        pass
    except Exception as e:
        log_hook_activity("ERROR", f"Hook error: {str(e)}")

if __name__ == "__main__":
    block_dangerous_commands()