---
name: dessn-cloud-code
description: Work with the app's code in Dessn's cloud when there is no local checkout. Find a surface from the person's words, find the code behind it, explain how it's built, change it on a copy, look at the result, put it on a board beside the original, and undo, all through the Dessn MCP. Use when the user has no code locally (a PM or designer with Claude Desktop, claude.ai or Claude Code in an empty folder) and wants to understand, change or explore a surface of their Dessn project, such as "where does this text come from", "change the copy on the pricing page", "how is the empty state built", "make this friendlier and show me".
---

# The app's code in Dessn's cloud

Every Dessn project holds its app's whole repository: the Library and every frame are a checkout of it on a cloud sandbox. You can search it, read it and change copies of it through the Dessn MCP with no clone. The person sees each change as a live frame.

## The loop

1. **Find the project.** `dessn_projects_search({ query: '<project name>' })` gives its `link`. A link the person pasted goes to `dessn_canvas_get`.
2. **Find the surface from their words.** `dessn_surfaces_list({ project, query })` matches a Library surface's name, its route and the words its picture shows, so "the Completed view" or "the empty state" finds it. Each surface has a `route` and a `link`.
3. **Find the code behind it.** Search for the exact words on the screen: `dessn_files_list({ at: <project or surface link>, grep: 'No completed projects' })`. It answers each file and line with the lines around it, which is enough to explain it and to write an edit. Find nothing? Try a shorter piece. Text may be split over elements, come from data (`dessn.mocks/`), or be uppercased by CSS. Then search for the component's name to find where it's used. `path` (a folder) and `glob` (`'**/*.tsx'`) narrow a search; `regex: true` takes a pattern.
4. **Read and explain.** `dessn_files_read({ at, path, from, to })` reads the lines around a match. `as: 'outline'` gives a long file's components and functions with their lines, and `paths: [...]` reads several files in one call. `dessn_canvas_get` on a frame lists its `entryFiles` (the files its picture renders). Explain what you found in the person's terms: which component, what decides when it shows, where its words and data come from. Name the files and lines so they can check.
5. **Copy, always.** Never edit the original: other people see it. Put the surface on a page and copy it:
   - `dessn_pages_create({ project, title: '<the change>', private: true, key })` makes a page only they see (or use a page they named).
   - `dessn_nodes_create({ page, key, items: [{ kind: 'frame', from: { surface: '<route>' }, x: 0, y: 0 }] })` adds the original.
   - `dessn_nodes_create({ page, key, items: [{ kind: 'frame', from: { frame: <its id>, copy: true }, position: { rightOf: <its id> } }] })` adds the copy, on its own sandbox.
   - A change that shows only in a state (an empty list, a search with no results, another tab): give the original that state's route, and the copy keeps it (`route: '/?view=completed&search=zzz'` on the frame item), so the board itself shows before and after. If no route reaches the state, say so; change the app's sample data only when the person asks.
6. **Edit the copy.** `dessn_files_write({ at: <the copy's link>, key, files: [{ path, edits: [{ oldString, newString }] }] })`. Copy `oldString` exactly from the search's or the read's lines. The answer waits for the build and gives `build` (compile, runtime and type errors) and `picture`. A failed edit says why and shows the nearest lines; fix it and send it again.
7. **Look.** Check the write's picture (`picture.landed`, or its `nextCall`), or call `dessn_canvas_screenshot({ target: <the copy's link> })`. Compare it with the original. If the write's answer has `fit`, send its `nextCall` so the frame shows the whole page.
8. **Put it on the board.** The original and the copy sit side by side. Add a note above or beside them saying what changed and where, for example "Empty state message: src/views/Completed.tsx:42, 'No completed projects' → 'Nothing finished yet. Your wins will show up here'": `dessn_nodes_create({ page, key, items: [{ kind: 'note', html: '<p>…</p>', position: { above: <copy id> } }] })`. Give the person the page link and a picture of it.
9. **Undo if it goes wrong.** `dessn_canvas_get` on the copy lists its `history` (newest first, each with a `seq`). `dessn_files_write({ at: <copy>, key, restore: <seq> })` brings that version back as a new entry, so nothing is lost. `restore: 'undo'` undoes the last restore.

## When you can't edit directly

Writing a frame's code is open to the person's own agent on their own computer, signed in from it: Claude Code, Codex, Cursor or the Dessn CLI. A web connector (claude.ai, or a Claude Desktop custom connector) or an API key gets `forbidden` on step 6. Everything else above still works for them. For the change itself, either:

- ask Dessn's design agent: `dessn_design_send` with the copy's page, the file and line you found, and the exact change. A design run spends the person's credits and takes 3-10 minutes; when they asked for this change, their ask is the go-ahead. `dessn_design_status` follows it; or
- tell the person a local client can make the edit itself (https://mcp.dessn.ai/install has each one's line).

## Good to know

- The first search or read of a frame whose sandbox is asleep wakes it (10 to 30 s, `woke: true`). The next calls are quick.
- A search reads the frame's files as they are now. A read without a cursor does too, once the frame's build is saved.
- `.dessn/` files and `dessn.mocks/` are Dessn's own preview setup (`kind: 'reference'`). Read them to understand the frame, but change the app's own files.
- When someone later takes the copy's change into a clone, it goes as git: `dessn_files_list({ at: <the copy's link>, changes: true })` lists it against the commit the code came from, and `dessn_files_read({ at, diff: true })` is the patch to `git apply` (skill **dessn-sync**).
- Writes take a `key` of your own: the same call with the same key never writes twice, so a retry is safe.
