# Dessn for your agent

[Dessn](https://dessn.ai) is a design canvas where every frame is your real app, running live from its own code. This plugin gives your coding agent Dessn's tools (the Dessn MCP, signed in with your Dessn account) and Dessn's design skills.

## Install

All of these, with copy buttons: https://mcp.dessn.ai/install

- **Claude Code:** `claude plugin marketplace add dessn-ai/dessn-agent-plugin && claude plugin install dessn@dessn` (from this repository), or `claude plugin marketplace add https://mcp.dessn.ai/plugins/marketplace.json && claude plugin install dessn@dessn`, then in Claude Code `/reload-plugins` (a session already running when it was installed loads it only then), `/mcp` → `plugin:dessn:dessn` → Authenticate.
- **Codex:** `codex plugin marketplace add https://mcp.dessn.ai/plugins.git && codex plugin add dessn@dessn`
- **Cursor:** add the MCP (`{"mcpServers":{"dessn":{"url":"https://mcp.dessn.ai/mcp"}}}` in `~/.cursor/mcp.json`), then `npx skills add https://mcp.dessn.ai -a cursor -g -y`
- **VS Code (GitHub Copilot):** `code --add-mcp '{"name":"dessn","type":"http","url":"https://mcp.dessn.ai/mcp"}'`, then `npx skills add https://mcp.dessn.ai -a github-copilot -g -y`
- **Claude Desktop, claude.ai, Cowork:** Customize → Connectors → Add custom connector → `https://mcp.dessn.ai/mcp`.
- **Any other agent:** `npx skills add https://mcp.dessn.ai`

## The skills

- `dessn`: start here. Connecting, finding projects and pages, which tool does which job.
- `dessn-design`: explore an app before designing, reuse its design system, make variations as frame copies, check them against real pictures.
- `dessn-board`: boards of an app's surfaces, user flows with labelled arrows, diagrams from text, frames that fit.
- `dessn-audit`: design audits and proposed design-system changes across screens.
- `dessn-design-system`: a page that shows the app's design system.
- `dessn-sync`: bring local code changes onto a Dessn frame.
- `dessn-cloud-code`: work with the app's code in Dessn's cloud, with no local checkout.

The same skills come from the Dessn MCP itself, as prompts (`/dessn:design` in Claude Code) and resources (`skill://dessn-design/SKILL.md`), so a client with nothing installed has them too.

## Layout

- `plugins/dessn/`: the plugin (`.claude-plugin/`, `.codex-plugin/`, `.cursor-plugin/`, `.mcp.json`, `skills/`).
- `.claude-plugin/marketplace.json`, `.agents/plugins/marketplace.json`, `.cursor-plugin/marketplace.json`: this repository as a marketplace for Claude Code, Codex and Cursor.

## Support

- Help: hello@dessn.ai
- Privacy policy: https://www.dessn.com/privacy
- Terms: https://www.dessn.com/terms

## License

MIT. See [LICENSE](LICENSE).
