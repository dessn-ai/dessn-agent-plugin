# Dessn

<!-- copy:intro -->
[Dessn](https://dessn.ai) is a design canvas where every frame is your real app, running live from its own code. This plugin gives your coding agent Dessn's tools (the Dessn MCP, signed in with your Dessn account) and Dessn's design skills.
<!-- /copy:intro -->

## What it brings

- Explore your app's surfaces and the code behind them, and reuse its design system, with file and line.
- Make variations as copies of a frame, each its own running app, side by side on a page.
- Lay out boards, user flows with labelled arrows and diagrams your team can open and comment on.
- Move code between your local checkout and a frame with git, both ways.
- Ask Dessn's own design agent for a change and follow its progress.

The skills: `dessn` (start here), `dessn-design`, `dessn-board`, `dessn-audit`, `dessn-design-system`, `dessn-sync` and `dessn-cloud-code`.

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

## What it runs and what it reaches

- **Network:** one endpoint, the Dessn MCP at `https://mcp.dessn.ai/mcp`, signed in with OAuth in your browser (PKCE; no
  password or key is stored by the plugin). Nothing else is downloaded or called.
- **Claude Code session note:** `session-fact.sh` prints `session-start.md` (a short description of what Dessn does) once
  per session, at its start or at your first message when Dessn was installed mid-session. It makes no network call and
  writes only an empty marker file per session in the plugin's data folder (removed after 7 days). Codex and Cursor don't
  run it.

<!-- copy:quotes -->
## What teams say

> “The way that it looks on Dessn is the way that we have it in production.”
> Cristian, Founding Product Designer, Lette

> “It is using our design system, it is following our design rules…”
> Elyse, Staff Design Engineer, Color

> “It went through our entire application, and I could watch it reason… It popped up two or three areas where I was like, ‘Oh, that’s right. That field is hidden on that flow in the back.’”
> Alex Michaels, Head of Product at RISR
<!-- /copy:quotes -->

## Support

- Help: service@dessn.ai (https://www.dessn.com/support)
- Privacy policy: https://www.dessn.com/privacy
- Terms: https://www.dessn.com/terms

## License

MIT. See [LICENSE](LICENSE).
