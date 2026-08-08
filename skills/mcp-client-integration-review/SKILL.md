---
name: mcp-client-integration-review
description: Review an MCP server integration from each configured client through the safest available real operation. Use when inspecting or diagnosing MCP connectivity, discovery, authentication, or tool availability for any agent client.
---

# Review MCP Client Integration

Registration is not usability. Check every client independently.

## Safety boundary

- Treat review as read-only: do not add, remove, or rewrite configuration unless
  the user asked for integration changes.
- Do not initiate OAuth, paid model calls, or external writes without authority.
- Redact secrets. Record environment names and only non-sensitive values needed
  to explain launch behaviour.

## Per-client contract

1. Read the effective configuration: executable, arguments, cwd, server name,
   and redacted environment.
2. Run the client’s own MCP status or health command.
3. Verify initialization and tool discovery when exposed.
4. Prefer a tool declared read-only for the final call. If no safe call exists,
   stop at `tools-listed`; do not label the client `usable`.
5. Capture timeout, stderr, and child exit status on failure.

## Matrix

Report `configured | initialized | tools-listed | safe-call | build | evidence`
for each client. Never transfer success from one client to another.

Good: “configured=true, initialized=false, health command returned X.”
Bad: “All clients work because a direct SDK client connected.”
