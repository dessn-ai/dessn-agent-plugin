#!/bin/sh
# Dessn's session fact (session-start.md), once per Claude Code session: at its start (and again after a compact or a resume,
# which start from a summary), or at the person's first message when Dessn arrived mid-session. A plugin installed in a
# session is loaded by /reload-plugins, which runs no SessionStart hook, so a person who installs Dessn and then asks for a
# design never got the fact (11-04, zero-account: a real Claude Code TUI, plugin loaded by /reload-plugins and signed in,
# answered "add an empty state to the links list" with a local edit). The hook's input is one JSON object on stdin.
input=$(cat)
event=$(printf '%s' "$input" | sed -n 's/.*"hook_event_name" *: *"\([A-Za-z]*\)".*/\1/p' | head -n 1)
id=$(printf '%s' "$input" | sed -n 's/.*"session_id" *: *"\([A-Za-z0-9_-]*\)".*/\1/p' | head -n 1)
dir="${CLAUDE_PLUGIN_DATA:-${TMPDIR:-/tmp}/dessn-plugin}/sessions-told"
if [ "$event" = "SessionStart" ]; then
  if [ -n "$id" ] && mkdir -p "$dir" 2>/dev/null; then : > "$dir/$id"; find "$dir" -type f -mtime +7 -exec rm -f {} + 2>/dev/null; fi
  cat "$(dirname "$0")/session-start.md"
  exit 0
fi
# A later message: only when this session was never told (no id to go by: say nothing rather than on every message).
[ -n "$id" ] || exit 0
[ -f "$dir/$id" ] && exit 0
mkdir -p "$dir" 2>/dev/null && : > "$dir/$id"
cat "$(dirname "$0")/session-start.md"
