# Dessn

Dessn is a design canvas where every frame is your real app, running from its own code, with sample data standing in for
the backend. This plugin connects your coding agent to Dessn: the Dessn MCP (`https://mcp.dessn.ai/mcp`, signed in once
with your Dessn account in your browser) and Dessn's design skills.

## What it brings

- Explore your app's surfaces and the code behind them, and reuse its design system, with file and line.
- Make variations as copies of a frame, each its own running app, side by side on a page.
- Lay out boards, user flows with labelled arrows and diagrams your team can open and comment on.
- Move code between your local checkout and a frame with git, both ways.
- Ask Dessn's own design agent for a change and follow its progress.

The skills: `dessn` (start here), `dessn-design`, `dessn-board`, `dessn-sync` and `dessn-cloud-code`.

An agent on your own computer (Claude Code, Codex, Cursor) can also edit a frame's code directly and capture a live site as
a frame. From claude.ai, Claude Desktop's connector or ChatGPT, your agent asks Dessn's design agent for those instead.

## Install

Every client, with copy buttons: https://mcp.dessn.ai/install

- **Claude Code:** `claude plugin marketplace add https://mcp.dessn.ai/plugins/marketplace.json && claude plugin install dessn@dessn`,
  then `/reload-plugins`, then `/mcp`, pick `plugin:dessn:dessn` and Authenticate.
- **Codex:** `codex plugin marketplace add https://mcp.dessn.ai/plugins.git && codex plugin add dessn@dessn`
- **Claude Desktop, claude.ai, Cowork:** Customize › Connectors › Add custom connector › `https://mcp.dessn.ai/mcp`.

You need a Dessn account with a project: https://create.dessn.ai. Frame and board writes spend no credits; runs of Dessn's
design agent do.

## Support

- Help: hello@dessn.ai
- Privacy policy: https://www.dessn.com/privacy
- Terms: https://www.dessn.com/terms

## License

MIT. See [LICENSE](LICENSE).
