---
name: dessn-sync
description: Move code between the person's local clone of their app and Dessn with git, both ways, through the Dessn MCP. Push the local checkout to a Dessn frame (their own copy) and put frames of its routes on a board; or take a Dessn frame's change home into the clone as git (status, a patch to git apply, its commits for git am, a bundle to git fetch) and build it. Use when the user codes locally in a clone of a Dessn project's repository, such as "push my local changes to Dessn", "put my branch on the board", "sync my working tree to Dessn", "take this frame's change into my repo", "bring the design from Dessn into my code", "apply this frame".
---

# Sync a local checkout with Dessn, both ways

A Dessn project holds its app's repository: the Library and every frame are checkouts of it on cloud sandboxes. Someone who codes in their own clone pushes their working tree to a frame's **copy** in one call, and gets back the build and its picture. Their own git (index, branch, stash) is never touched.

## The push

1. **Find the project and a surface.** `dessn_projects_search({ query })` gives the project's `link`; `dessn_surfaces_list({ project, query })` its Library surfaces, each with a `route` and a `link`.
2. **A copy to push to.** The Library's own frames are never written. Make a page and a copy on it, once:
   - `dessn_pages_create({ project, title: 'Local · <branch>', private: true, key })`
   - `dessn_nodes_create({ page, key, items: [{ kind: 'frame', from: { frame: <the surface's link>, copy: true }, x: 0, y: 0 }] })`: its answer's `results[0].id` is the copy; its link is `<page>?frameId=<id>`.

   Push to the same copy for every later change: it keeps what was last pushed.
3. **The commit both sides share.** `dessn_canvas_get({ target: <the page or the copy's link> })` answers each frame's `upstream`: `{ repo, branch, commit, subdir? }` (so does `dessn_files_list` as `at.upstream`). `commit` (U) is the repository commit the Library was built from; the frame's own `commit` and `base` are Dessn's and no clone has them.
4. **The patch, from the person's clone, without touching their index:**

   ```sh
   U=<at.upstream.commit>
   git cat-file -e "$U^{commit}" 2>/dev/null || git fetch origin "$U"
   tmp=$(mktemp); cp "$(git rev-parse --git-dir)/index" "$tmp"
   GIT_INDEX_FILE=$tmp git add -A
   GIT_INDEX_FILE=$tmp git diff --cached --binary --full-index "$U" > /tmp/dessn.patch   # add --relative=<subdir> when at.upstream.subdir is set
   rm -f "$tmp"
   ```

   This is everything that differs from U: uncommitted edits, new files (`.gitignore` respected) and local commits. Always send the whole diff against U, never only what changed since the last push.

   No `at.upstream`, or git can neither find nor fetch it (a project from an uploaded folder, a checkout made from Dessn's own files, a remote without that commit): diff the same way against the commit your checkout started from, the one before your changes, and pass that commit as `base`. Don't fall back to writing files one by one: the copy finds the code the patch applies to (its upstream, else its own), and later pushes stay on that base.
5. **Push:** `dessn_files_write({ at: <the copy's link>, key: <new each push>, base: U, patch: <the file's text> })`. Add `frames` (below) to put routes on the board in the same call.

## What comes back

- `build`: the build the push caused (compile, runtime and type errors), and `picture` (the copy's new picture, or `nextCall` to wait for it).
- `sync.counts` and its lists: `written`; `merged` (merged with the copy's own changes, such as Dessn's preview lines or a design run's edits); `deleted`; `skipped` (Dessn's own files `.dessn/`, `dessn.mocks/`, `dessn.config.*`, plus secrets, `node_modules`, links and submodules, each with why; pass `include: ['dessn.mocks/**']` to push mocks); `conflicts`.
- **The merge is three-way from the last push.** Lines the copy changed since then stay. A local revert reverts in the copy. The same patch twice writes nothing.
- **A conflict** is a file the copy changed on the same lines since the last push. It is never written with conflict markers. `sync.conflicts[].hunk` shows both sides. Settle it locally and push again, or send that file whole without `base` (`files: [{ path, content }]`, which overwrites it).
- **A push lands whole or not at all.** A conflict, or a path outside the repository (`..`, a link, `.git`), refuses the push and no file changes. A write that fails part way puts back what it had written. Paths are the repository's, from its root, as `git diff` names them (a monorepo's `packages/…` too).
- `sync.applied: false` means nothing was pushed and no file changed. `why` says why: git's words when the patch does not apply to U (diff against `at.upstream.commit` exactly), or each refused file with its reason.
- `status: 'working'` (a sleeping copy boots in 10 to 40 s, or a big merge): send the same call again with the same key for its answer.

## Big pushes

A patch over 2 MB (a branch far from U, many binaries) goes up the upload lane, and its bytes never pass through you:

1. Send `dessn_files_write({ at, key, base: U, upload: { size: <bytes of /tmp/dessn.patch>, sha256: <shasum -a 256> } })`.
2. It answers `status: 'upload'` with `upload.command`. Run it with the file's path, `curl -fsS -T /tmp/dessn.patch '<url>'`, within 5 minutes. The URL is a credential: never print it to the person.
3. Send the same call again, with the same key and input. It applies the patch.

## Frames of what runs locally

`frames` on the push makes frames of the copy's routes once its build is done. They go on the copy's page (or `page`), laid out in a grid. Each frame shows the pushed code, and every later push rebuilds them all.

```js
dessn_files_write({ at, key, base: U, patch, frames: { routes: ['/', '/settings?tab=team'] } })
```

- `routes`: a list of routes (a query string is fine), `'all'` (every page in the app's route table), or `'surfaces'` (the Library's surfaces). A route with parameters (`/projects/:id`) takes a Library surface's concrete route, or the engine's sample (`guessed: true`). If neither exists, it's skipped and the answer says why.
- `layout: { as: 'grid' | 'sections', perRow? }`: sections group the frames by first path segment.
- The answer's `frames` lists `made` (each `id`, `route` and `size`: a frame is as tall as its page, and one whose picture is still coming says `fit.pending` and fits itself once it lands), `existing` (that route already has a frame of this copy on the page) and `skipped`. Past 24 frames, `more.nextCall` makes the rest.
- The same fan-out works without a push: `dessn_nodes_create({ page, key, items: [{ kind: 'frame', from: { frame: <copy>, routes: 'all' }, layout: { as: 'grid' }, x, y }] })`. `dessn_canvas_get` on the copy lists its `routes` while its app runs.
- Not sure of a view's route? `dessn_surfaces_list` names each Library surface's route. Views selected by a query string (`/?view=completed`) are routes too.

Give the person the page link, and `dessn_canvas_screenshot({ target: <page link> })` for a picture of the board.

## The other way: take a frame's change home

A frame is a git checkout of the same repository with its own history, so its change comes home as git. No ZIP, no file-by-file copying.

1. **Its status.** `dessn_files_list({ at: <the frame's link>, changes: true })` answers `base` (the repository commit the frame's code came from: `base.commit`, `base.repo`, `base.subdir` when the project is a folder of its repository) and each changed path: `added`, `modified`, `deleted` or `renamed` (`from`), with line counts.
   - `reference: true` marks Dessn's preview context: its mock switches and the generated mocks a frame shows data from without the backend. Read them to see what data the design expects, and never ship them. A diff leaves them out unless you pass `reference: true`.
   - `setup: 'separated'`: Dessn's Library setup also touched the file, and its lines are left out of the diff. `'included'`: they couldn't be told apart, so drop Dessn's wiring by hand. `scaffolding`: lines only Dessn's preview reads; leave them out.
2. **A branch at the base.** `base.check` says whether the clone has the commit (`git cat-file -e <commit>^{commit} || git fetch origin <commit>`). Then `git switch -c dessn-frame <base.commit>`, or stay on your branch if it still has base.commit's version of those files.
3. **The change, one of three ways:**
   - `dessn_files_read({ at, diff: true })`: a unified diff, in the answer. Write `patch` to `part.file` exactly as it is with your file tool and check `part.sha256`. A longer one comes in parts: send `nextCall` for each next part and write it to its own `part.file`, then `cat /tmp/dessn-frame.patch.part* > /tmp/dessn-frame.patch` and check `content.sha256`. Then `git apply --check /tmp/dessn-frame.patch && git apply /tmp/dessn-frame.patch` (`-3` merges it onto a branch that moved on). Apply it rather than retyping the edits: git checks every line against your files.
   - `diff: 'patch'`: the frame's own commits as an mbox: `git am -3 /tmp/dessn-frame.mbox`.
   - `diff: 'bundle'`: the frame's commits as a branch to fetch: `git fetch /tmp/dessn-frame.bundle refs/heads/dessn/frame:refs/remotes/dessn/frame`, then merge, cherry-pick or rebase it.

   `path` or `paths` narrow any of them. A bundle comes as `base64` parts the same way: join them, then `base64 -d < /tmp/dessn-frame.bundle.b64 > /tmp/dessn-frame.bundle`. Each answer's `next` spells the commands. Only a change of several MB comes as `download`: a short-lived private URL. Use it only in `curl -fsS -o <file> '<url>'`, never print it, and check `download.sha256`.
4. **Make it right, then build.** The diff is the code that renders the design: keep its frontend values (components, markup, styles, copy), and build data wiring and mocks the codebase's real way. Build the app and run its tests, and compare the result with `dessn_canvas_screenshot({ target: <the frame's link> })`. `dessn_guide` topic `implement-frame` has the rest.

"patch does not apply" means the clone isn't at `base.commit` there: check it out, or use `git apply -3`. Reading is enough with the Read permission (`dessn:read`), an API key included.

## Good to know

- Pushing is open to the person's own agent on their computer (Claude Code, Codex, Cursor, the Dessn CLI), signed in from that computer. An API key or a web connector gets `forbidden`.
- A folder with no git: send `files` with `base` instead of `patch`. Each entry is `{ path, content | contentBase64 | delete: true }`, covering every file that differs from what was last pushed, and it merges the same way.
- Writes take a `key` of your own. The same key and input never writes twice, so a retry is safe. Use a new key for each new push.
- An app that Dessn can't run (a native app, a backend Dessn has no mocks for) can still go on the board as pictures. Screenshot the local dev server and upload each picture (`dessn_files_write({ at: { assets: page }, name, upload: true })`, then an image node). They are static: use this as a fallback only.
