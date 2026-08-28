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

## Mavis v2 specifics (2026-08-28)

v2 uses a different MCP architecture from v1. The "is it configured" check
on `~/.minimax/mcp/mcp.json` is not enough — the runtime may silently drop
entries that match the retirement filter.

Additional checks for v2 (Mavis 3.0.67+):

1. **Process tree, not config.** Active MCPs are stdio children of the
   Electron NodeService utility process, not HTTP endpoints. Find them
   via `Get-CimInstance Win32_Process -Filter "Name='MiniMax Code.exe'" |
   Where-Object { $_.CommandLine -like '*<mcp-name>*' }`. If no
   process matches, the MCP is not loaded even if the config says it is.
2. **HTTP-MCP port 127.0.0.1:15321 is v1-only.** v2 does not bind
   this port for any MCP. If the only evidence of "active MCP" is an
   HTTP response on 15321, that is a v1 leftover, not v2.
3. **Check the plugin registry in SQLite.** v2's authoritative state
   is `~/.minimax/v2/sqlite/runtime-state.sqlite`,
   `local_runtime_plugin_official_state` table. A populated
   `effectivePlugins` array means the runtime knows about the
   plugin; an empty array with `runtimeEnabled: true` means
   "enabled, but no installations registered".
4. **Retirement filter.** `cu` and `trash` are intentionally retired
   in v2 (see `@mavis/local-runtime/src/mcp/retired-cu.ts`). The
   URL pattern `127.0.0.1:15321/mavis/mcp/cu` and
   `127.0.0.1:15321/mavis/mcp/trash` are dropped at config-load.
   If a config has those URLs, the runtime will not start them,
   and the corresponding tools will not be available. Update the
   config or use the documented alternative (`mavis-trash.cmd`
   CLI for trash; in-process `cu` runtime adapter for cu).
5. **`mavis mcp call <name> <tool>` syntax assumes the MCP is alive.**
   It will fail with "connection refused" or similar for retired
   or unconfigured MCPs. Check the process tree first, not after
   the call fails.

## Matrix

Report `configured | initialized | tools-listed | safe-call | build | evidence`
for each client. Never transfer success from one client to another.

For v2 Mavis clients, also report:
`process | registry-registered | v2-retired? | v2-filtered-reason`

Good: "configured=true, initialized=false, health command returned X."
Bad: "All clients work because a direct SDK client connected."
