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

## Mavis v2 specifics (tested on Mavis 3.0.67.128, 2026-08-28)

> v2 paths and module names below are accurate as of Mavis 3.0.67.128. Future
> Mavis versions may shift them — verify before relying on specific paths.

v2 uses a different MCP architecture from v1. The "is it configured" check
on `~/.minimax/mcp/mcp.json` is not enough — the runtime may silently drop
entries that match the retirement filter.

Additional checks for v2 (Mavis 3.0.67+):

1. **Process tree, not config.** Active MCPs are stdio children of the
   Electron NodeService utility process, not HTTP endpoints. Find them
   via one of:
   - Windows: `Get-CimInstance Win32_Process -Filter "Name='MiniMax Code.exe'" |
     Where-Object { $_.CommandLine -like '*<mcp-name>*' }`
   - Linux / macOS: `pgrep -af '<mcp-name>'` (e.g. `pgrep -af 'matrix-mcp-stdio'`)
   If no process matches, the MCP is not loaded even if the config says it is.
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
   filter matches on:
   - the URL pattern `127.0.0.1:15321/mavis/mcp/cu` and
     `127.0.0.1:15321/mavis/mcp/trash` (and the `/mcp/cu` alias), or
   - the metadata flags `mavisBuiltinMcpServer: "cu"` plus
     `managedBy: "local-runtime"`.
   Either match causes the entry to be dropped at config-load.
   The `matrix` server has the same filter pattern but is
   re-injected as a builtin via `buildBuiltinMatrixServerConfig`.
   If a config has only the URL-trigger, the runtime will not
   start it, and the corresponding tools will not be available.
   Use the documented alternative (`mavis-trash.cmd` CLI for
   trash; in-process `cu` runtime adapter for cu).
5. **`mavis mcp call <name> <tool>` syntax assumes the MCP is alive.**
   It will fail with "connection refused" or similar for retired
   or unconfigured MCPs. Check the process tree first, not after
   the call fails.

## Matrix

Report the following fields for each client. Never transfer success from
one client to another.

| Field | Meaning |
| --- | --- |
| `configured` | True if the client has a server entry in its config. |
| `initialized` | True if the client successfully started the server. |
| `tools-listed` | True if the client received the tool manifest. |
| `safe-call` | True if a read-only call was issued and returned. |
| `build` | Identifier of the server build/version, if known. |
| `evidence` | Concrete command output that supports the row. |

For v2 Mavis clients, also report:

| Field | Meaning |
| --- | --- |
| `process` | True if a stdio child process is running for the server. |
| `registry-registered` | True if `local_runtime_plugin_official_state.effectivePlugins` lists it. |
| `v2-retired?` | True if the server is in the v2 retirement filter. |
| `v2-filtered-reason` | When filtered: the matching condition (URL pattern, metadata flag, or `none`). |

`v2-filtered-reason` example values:

- `none` — not filtered.
- `url: 127.0.0.1:15321/mavis/mcp/cu` — matched the loopback URL.
- `metadata: mavisBuiltinMcpServer+managedBy` — matched the metadata flags.
- `re-injected-as-builtin` — would be filtered as user-config, but the
  server has a separate builtin path that re-adds it (only `matrix` does this today).

Good: "configured=true, initialized=false, health command returned X."
Bad (v1): "All clients work because a direct SDK client connected."
Bad (v2): "matrix is active because mcp.json has it enabled." (The config
says `enabled: true`, but the retirement filter would drop it if it were
not re-injected via the builtin path — check the process tree.)
