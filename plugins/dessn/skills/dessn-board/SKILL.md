---
name: dessn-board
description: Lay out Dessn canvas pages a person can read without the chat. QA boards of an app's surfaces grouped by area, user flows of the app's live screens joined by labelled arrows (the main path in a row, each failure a real state of its step's screen under it), with what's broken marked where it happens when it's an audit of a flow, diagrams drawn from Mermaid or nodes and edges, title and caption notes, sections, and frames fitted to their content. Use for "put every surface of our app on a page", "map our sign-up flow", "show the checkout flow with each step and where errors go", "lay out the onboarding journey for a new user", "audit our checkout flow and flag what's broken", "draw this architecture or state diagram on the canvas", "tidy / arrange this board", "label these frames", or "make the frames fit".
---

# Boards on Dessn

A board is read by someone who wasn't in the chat. It says what it is in a title, each frame is named for what it shows, arrows say what moves the person on, and nothing overlaps or is cut off. Board writes spend no credits; every sign-in can make them (a read-only API key can't).

## The tools

- `dessn_pages_create({ project, title, private?, key })` → the page's `id` and `url`. No project yet: `newProject: '<a name>'` in place of `project` makes one whose Library is Dessn's starter app (`newProject.starter`: a small React app; a frame of it at a new route, `from: { surface: '/' }, route: '/pricing'`, plays once you write its page; refused `STARTER_COPYING` for its first ~40 s, so send it again), or answers the one made before for that name. HTML frames (`from: { html }`) are drawn, for visuals. Connecting their own code (`newProject.connectCode`) replaces this starter in the same project; their pages stay (a starter still being made isn't ready to replace yet).
- `dessn_nodes_create({ page, key, items, diagram? })` writes a batch in order: `frame` (from a Library screen `{ surface: <id, link or route> }`, or a copy `{ frame, copy: true }`), `note` (`html`: h1, h2, p, li, small, code, or Markdown; `w`, `h: 'auto'`), `text`, `image` (an uploaded asset), `arrow` (`from`, `to`, `label`, `dashed`, `heads`), `section`. Every item but an arrow takes `x, y` or a `position`: `{ rightOf | leftOf | below | above: <id or an earlier item's key>, gap?, align? }`, which slides past what is already there. Give items their own `key` so later items and arrows can name them. `dryRun: true` answers where each would land and writes nothing.
- `dessn_nodes_arrange({ page, as, ids | root | groups })`: `row`, `column`, `grid` (`perRow`), `flow` (follows the arrows from `root`, widening gaps to hold each label), `sections` (`groups: [{ heading, description?, ids }]`: a heading over each group's grid).
- `dessn_nodes_update({ page, key, changes })`: move, resize, rename, re-route a frame (`route`), edit a note (`expectedRevision` from its last read), re-label an arrow. `size: { h: 'fit' }` makes a frame as tall as its page, so nothing below the first screen is cut off (up to 4,000 px).
- `dessn_canvas_screenshot({ target: <page link>, region: 'fit' | { x, y, w, h } | { nodeId } })` pictures the board as the person will see it; `fresh: { waitMs }` waits for new frames' pictures first (they land 12 s to about 2 minutes after a frame is made).
- Each write's `key` makes a retry safe: the same key and input answer the first answer. A batch past ~40 s answers `status: 'working'`: call again with the same key for the rest.
- `dessn_program_run({ page, code })` runs one JavaScript program against the board (`canvas.*`, `dessn_guide` topic `program`): it pays when many writes depend on what earlier ones answered (a frame's height, then the notes under it; arrows in an order read off the board); a batch you can write after one read is quicker as `dessn_nodes_create`.

Every field: `dessn_guide` topic `board`.

## What goes on a board, and what plays

- **Frames of the app**: Library surfaces, copies, copies at a new route. They are the app running from its code; in Dessn a person presses Play and clicks through them. A screen, a state, a variation, a component gallery or a design-system sheet of the app is a copy whose code you write (skill **dessn-design**, "A design-system sheet").
- **HTML frames** (`from: { html }`): drawn from your HTML, sharp at any zoom and editable, with no Play (nothing in them runs; only their links open). For notes, annotations and visuals: an OG image, slides, a moodboard. Something people click and play, or a mock of a change to the app's UI, is a frame of the app (a copy of its screen's frame whose code you write), never an HTML frame.
- **Images**: real pictures, such as photos, logos, or screenshots kept as references. A picture of the app's own UI plays nothing and goes stale with its code.

## A board of screens (QA, review, an inventory)

1. `dessn_surfaces_list({ project })` lists the Library's screens (25 a call, pass `nextCursor` until null). Each has its `route`, `name`, the words it `shows` and `via`, the screen that leads to it: group them by the area of the app they belong to (their route's first segment, or the nav item that reaches them).
2. The page the person gave (a new one, `dessn_pages_create`, only when they gave none), then the frames in one `dessn_nodes_create` batch (or one per group), each named for what it shows.
3. `dessn_nodes_arrange` with `as: 'sections'` and one group per area, each with a short heading. Frames made without a size are already as tall as their pages (or fit themselves once their first picture lands: `fit.pending`).

Every screen in one call: with one frame of the app on the page, the item `{ kind: 'frame', from: { frame: <its id>, routes: 'all' }, layout: { as: 'sections' }, x, y }` makes a frame of each route in the app's route table, grouped by its first path segment (`'surfaces'`: each Library screen instead, under its own name; a list names the routes). They share that frame's sandbox, so a write to it changes them all. The answer says which routes it made, which existed and which it skipped and why.
4. A title note above the board: what this board is, for whom, as of which build.

## A user flow

<!-- dessn:user-flow -->
A flow a person asks to see ("map our sign-up flow", "show the checkout flow with each step and where errors go", "lay out the onboarding journey for a new user") is the app's own screens on their canvas in the order a person moves through them: each step a frame of the app at its route, or a copy whose code shows the state only clicks reach (an open dialog, a filled form), joined by arrows labelled with what the person does. Where it goes wrong is part of the flow. Each failure the code raises is a real state of the app: where the code sends the person (an error page, no results, a 404) is a frame at that route; what it shows in place (a field's message, a toast, an error in a dialog) is a copy of its step's frame whose code shows it, with the words the code uses. Failures sit in a row under the step they happen at, numbered after it ("2a · No file"), each joined to its step by a dashed arrow labelled with what went wrong. A failure the code never handles (nothing reads the file's rows) is a note beside its step. Step cards beside a separate row of screens, or a table of steps in the chat, leave the person to match each step to its screen.
<!-- /dessn:user-flow -->

<!-- dessn:flow-map -->
A flow board shows a product's real screens in the order a person moves through them: the happy path in one row, left to
right, routes the person chooses above it, what the system does (waits, errors, dead ends, other ways in) below it, each
edge in the column of the step where it happens. Someone who never saw the chat understands it in a minute.

Someone asking to audit a flow gets this board with what's broken marked on it: each problem a numbered red disc on the frame where it happens, and the same number in "Where people get stuck" at the top with its words and its step.

**The parts,** the way Dessn's design agent builds them (its flow skill and its `buildFlow`, so its boards and yours read alike):

| Part | Where | What it holds |
|---|---|---|
| Title | Top left, `x` = the first column − 2600, `w` 6400 | One line saying whose journey and to where, a lede of 1–2 plain lines. Its `h1` is 380 px, so it reads at fit |
| Where people get stuck | Beside the title, on the next column past it, `w` 3000 | The findings, numbered, worst first: 2–4 words, the step's id, then a grey line saying how bad it is and what the person meets, with where the code says so (`file:line`) in small print. A finding the code shows and the screen doesn't (a request that never goes out, a message that's untrue) belongs here too, with what you read to know it: a reader acts on a list they can rank and trace |
| Not shown | 3400 right of it, `w` 3000 | Each state you couldn't put on the board, and why, and what you couldn't check from here (which path production gives people, say) |
| A lane heading | In the gutter left of its row, `w` 2000, level with the row's top | The lane's name and one line. The happy path first, routes the person chooses above it, what the system does (waits, errors, dead ends, other ways in) below it |
| A frame | `x` = column × 2640, `y` = row × 2400, one screen each, `size: { w: 1440, h: 900 }` | Named `{id} · {name}`, at most 15 characters: a name tag past that is cut at fit. An edge state sits in the column of the step where it happens, numbered after it ("2a"); two in one column stack down |
| A caption | 90 under its frame, its frame's width | The id, the name, 1–2 lines quoting the screen's own words, and "Way out:" the control that leads on (or "None") |
| A disc | On a frame with a finding: `x` = its right edge − 160, 180 above its top | The finding's number |
| START, END | 160 left of the first step and right of the last, on the row's centre line | Joined to them with an unlabelled arrow |
| A marker for another way in | 60 left of its screen, `w` 520, on its centre line | An `h3` in the grey ("From 1 ·<br>bad email", "Invite email opened"), with an unlabelled arrow to the screen |

Those gaps (1200 between columns, 1500 under a row) hold the arrows' labels, the captions and the name tags, which keep their size on screen as the board zooms out. Ten columns of 2640 make a board too wide for much but the title to read at fit, so merge states that look the same. Two paths to one goal (an old flow and its replacement, a flag or a cohort that decides) both go on it, each a lane, with a line saying who gets which.

**Find the steps:**

- `dessn_surfaces_list({ project, query })`: the Library's screens with `route`, `shows` (the words on them) and `via` (the screen that leads there). A route with a state token in its query is a state setup saved. On a large app this is most of the inventory, and it wakes no sandbox.
- `dessn_files_list({ at: <a frame>, grep })` and `dessn_files_read`, many paths in one call, for the guards and routers, the conditions that change a screen, the form rules and their error messages. `dessn_canvas_get` on a frame lists its `routes`. The first search wakes a sleeping frame (20–30 s); the ones after take seconds.
- **A surface's name is the Library's label for it, not text on its screen.** Setup names a saved state for the designers
  ("Permissions", "Referral", "Email check"); the screen itself prints its own words ("Allow microphone access"). The words
  a state shows are in its surface's `shows`, in the route's own copy in code (its component and the
  strings it renders: one sign-in form's locale file says "Email is required" where the field prints "Required"), and in
  the surface's saved picture (`dessn_canvas_screenshot` of its link). On one meeting-notes app, three plans of six
  named states by their surface names, and the screens never said those words.
- A frame the Library has no surface for: make one frame of the app first, then `from: { frame: <its id or an earlier item's key>, state: '<route>' }` on the same sandbox, in the same batch. A state only clicks reach: the Library may already hold it (a route with a state token); else a copy whose code shows it (`from: { frame, copy: true }`, then `dessn_files_write`), or a line in "Not shown". Press through a step you doubt with `dessn_canvas_screenshot({ target, steps })`, which answers what each press changed.
- **See a state before it goes on the board.** `dessn_canvas_screenshot({ target: <a frame>, route: [<up to 12 routes>] })` pictures them together, and `frames: [<links>]` the frames you placed: a 404, an error screen, grey placeholders or a page cut off aren't the step, and the board's picture at fit is too small to tell. Such a step gets a mock or a copy that shows it, or a line in "Not shown". This is what the design agent's proof does for each of its frames.

**Build it,** in two `dessn_nodes_create` calls. The header first, since each answer gives its `bounds.h`:

```json
[
  {"kind":"note","key":"title","title":"From sign-in to the app","html":"<h1 style=\"font-size:380px;letter-spacing:-0.035em;text-wrap:balance\">From sign-in to the app</h1><p class=\"lede\" style=\"font-size:96px;text-wrap:pretty\">1–2 plain lines on whose journey it is and where it ends</p>","w":6400,"h":"auto","x":-2600,"y":0},
  {"kind":"note","key":"stuck","title":"Where people get stuck","html":"<hr><h2>Where people get stuck</h2><h3><span style=\"color:var(--brand-red);font-variant-numeric:tabular-nums\">1</span> Only \"Required\" <span class=\"num\">1a</span></h3><p style=\"color:var(--canvas-muted-foreground)\">Medium. What the person sees and why it stops them, in one line.<br><small><code>src/login/form.tsx:42</code></small></p>","w":3000,"h":"auto","x":5280,"y":0},
  {"kind":"note","key":"notShown","title":"Not shown","html":"<hr><h2>Not shown</h2><p style=\"color:var(--canvas-muted-foreground)\">Their email inbox (outside the product)</p>","w":3000,"h":"auto","x":8680,"y":0}
]
```

The top row then goes 600 under the tallest header note's end. Here that is `y` 2000. Everything else in one batch, frames before what names them, so each step lands whole (frame, name, caption, disc, arrows):

```json
[
  {"kind":"note","key":"lane:0","title":"Happy path","html":"<h2 style=\"font-size:180px;letter-spacing:-0.03em\">Happy path</h2><p style=\"font-size:64px;color:var(--canvas-muted-foreground)\">What most people do</p>","w":2000,"h":"auto","x":-2600,"y":2000},
  {"kind":"note","key":"START","title":"START","html":"<h2>START</h2>","w":420,"h":"auto","x":-580,"y":2380},
  {"kind":"note","key":"END","title":"END","html":"<h2>END</h2>","w":400,"h":"auto","x":4240,"y":2380},
  {"kind":"note","key":"lane:1","title":"Held by the form","html":"<h2 style=\"font-size:180px;letter-spacing:-0.03em\">Held by the form</h2><p style=\"font-size:64px;color:var(--canvas-muted-foreground)\">What the system does to them</p>","w":2000,"h":"auto","x":-2600,"y":4400},
  {"kind":"frame","key":"1","name":"1 · Sign in","from":{"surface":"/login"},"size":{"w":1440,"h":900},"x":0,"y":2000},
  {"kind":"note","key":"cap:1","title":"1 · Sign in · caption","html":"<div style=\"display:grid;grid-template-columns:150px 1fr\">\n  <h3 style=\"font-weight:400;font-variant-numeric:tabular-nums\">1</h3>\n  <div><h3>Sign in</h3><p style=\"color:color-mix(in srgb,var(--canvas-foreground) 35%,var(--canvas-muted-foreground))\">What the person sees and can do, in the screen's own words.</p><small>Way out: Continue with email</small></div>\n</div>","w":1440,"h":"auto","position":{"below":"1","gap":90,"align":"left"}},
  {"kind":"frame","key":"2","name":"2 · Verify","from":{"frame":"1","state":"/login/verify"},"size":{"w":1440,"h":900},"x":2640,"y":2000},
  {"kind":"note","key":"cap:2","title":"2 · Verify · caption","html":"<div style=\"display:grid;grid-template-columns:150px 1fr\">\n  <h3 style=\"font-weight:400;font-variant-numeric:tabular-nums\">2</h3>\n  <div><h3>Verify</h3><p style=\"color:color-mix(in srgb,var(--canvas-foreground) 35%,var(--canvas-muted-foreground))\">\"Check your email.\" The code they typed.</p><small>Way out: Resend</small></div>\n</div>","w":1440,"h":"auto","position":{"below":"2","gap":90,"align":"left"}},
  {"kind":"frame","key":"1a","name":"1a · No email","from":{"surface":"<the state's own surface>"},"size":{"w":1440,"h":900},"x":0,"y":4400},
  {"kind":"note","key":"cap:1a","title":"1a · No email · caption","html":"<div style=\"display:grid;grid-template-columns:150px 1fr\">\n  <h3 style=\"font-weight:400;font-variant-numeric:tabular-nums;color:var(--brand-red)\">1a</h3>\n  <div><h3>No email</h3><p style=\"color:color-mix(in srgb,var(--canvas-foreground) 35%,var(--canvas-muted-foreground))\">The field says only \"Required\".</p><small>Way out: type an email</small></div>\n</div>","w":1440,"h":"auto","position":{"below":"1a","gap":90,"align":"left"}},
  {"kind":"note","key":"disc:1a","title":"Stuck 1 · 1a","html":"<div style=\"width:160px;height:160px;border-radius:50%;background:var(--brand-red);color:#fff;display:flex;align-items:center;justify-content:center;font-size:88px;font-weight:600;line-height:1;font-variant-numeric:tabular-nums\">1</div>","w":160,"h":160,"x":1280,"y":4220},
  {"kind":"arrow","from":"START","to":"1"},
  {"kind":"arrow","from":"1","to":"2","label":"Continue"},
  {"kind":"arrow","from":"2","to":"END"},
  {"kind":"arrow","from":{"key":"1","side":"right"},"to":{"key":"1a","side":"right"},"label":"No email","color":"red","dashed":true}
]
```

The grid is the layout, so `dessn_nodes_arrange` isn't part of this: it would fold the lanes into one line. Take `dessn_canvas_screenshot({ target: <page>, region: 'fit', fresh: { waitMs: 120000 } })` once the frames have their pictures: its `issues` name what overlaps, each with the call that fixes it, and a `region` shows a part close up.

**Arrows.** An arrow along a row joins the frames as it is. One that changes rows leaves and enters on the right side of both frames (`from: { key, side: 'right' }, to: { key, side: 'right' }`), so it runs down the gap between columns, clear of the captions and name tags, with room for its label; bottom to top it would cross both. Two leaving one frame on one side in one direction stack their labels: give the second `side: 'left'`, or a marker instead of a line (the part above). Labels keep their size on screen, so past about 20 characters one wraps and stands taller than its line: the control's words, shortened. `color` and `dashed` are `dessn_nodes_create` fields.

- Arrows are thin. Colour says **which path**, dash says **who moves the person**. The board has no key: an arrow's label is the only words it carries, so it says what happens in the product's words.

  | Meaning | `color` | `dashed` | Label |
  |---|---|---|---|
  | The person acts on the happy path | `ink` | no | the control's on-screen words |
  | The happy path moves on by itself ("Payment clears") | `ink` | yes | the event |
  | A route the person chooses (hand-off, detour, setup) | `blue` | no | the control's words |
  | A way in from an entry marker (an invite email, a link) | `blue` | no | none: the marker names it |
  | The system holds or redirects them: a wait, an empty state, a rule, a policy | `gray` | yes | the condition |
  | A failure or refusal the product handles | `red` | yes | the condition |
  | A way back (Retry, Back, Connect another) | `gray` | no | the control's words |

### Completeness: what belongs on the board

The journey includes every way into it and out of it. Walk this list for every step:

- **Every branch of every router and guard** on the path (after sign-in, onboarding, an invite link),
  **including the default one**, such as a returning user who already has a workspace. Each branch
  gets a screen, or a line in "Not shown".
- **Ways in:** signed out, an invite, deep or email link, a returning user, joining someone else's
  account. A state reached only by a link (a stale link, a not-found page) starts from its own
  "From a link" marker, never from a happy-path screen.
- **Waits and empty states:** a slow job in progress, a pending approval, a first run with no data.
  Each kind of state the person names (empty, error, wait) shows on the board under that word: in a
  screen's name, a lane heading or a "Not shown" line. When the happy path's first-run screen is the
  empty state, its name says so ("8 · Empty home").
- **Failures of every action that writes**: create, save, send, share, generate, import, pay. Show what
  the product shows when the request fails. Also show **everything that blocks the final action**: a
  missing connection, ownership or role, a feature flag, required fields, a limit.
- **Permission and role variants** that look different, such as a read-only viewer: one frame each.
- **Steps outside the product** (a sign-in provider, a payment page, an app install, an email): the
  return, its failure, and what anyone else involved sees. Another person's part starts from a marker
  naming how they enter ("Invite email opened"), then their first screen. It never hangs off the
  sender's screen.
- **Ways out:** the recovery each edge screen offers (Retry, Back, Connect another), and what a request
  leads to ("Request sent").
- **Every checkpoint between an action and its result**, such as draft, then scheduled, then sent. Show
  the state the action really creates: check the status or flag it sets in the code.

Merge states that look the same. Skip hover-only or momentary states unless the flow depends on them.
Build only one journey when two have different goals (an admin configuring billing is separate), and
offer the other at the end.

### Truth

- **A frame keeps its slot and its caption gets a body only after you saw it show that state** (its picture, or `steps`); until then
  the caption is its name. A skeleton, a spinner, the parent screen or a different record is not the
  state.
- **Captions claim only what the frame shows**: the words on screen, the people, the counts, the
  status. Anything true in code but not visible goes in the report.
- **Keep one object through the whole journey:** the same account, record, meeting or dataset from step
  to step, including the hand-offs and the recipient's view. Point every scenario at it. Never swap in
  another existing record because it already has the later state; mock the state on the same one.
- **Never show an end-state marker before the step that makes it** (a "Shared" badge before Share).
- **Anything you can't render goes on the "Not shown" list**, never onto a look-alike.
- The report must match the board: count the frames with `dessn_canvas_get`, don't recall them.

### Your reply

Briefly:
  - the screens by row, counted with `dessn_canvas_get`;
  - how to reproduce each one (its route, parameter or token);
  - the "Not shown" states, and why;
  - anything you assumed, and any product bug you noticed.
<!-- /dessn:flow-map -->

## An inspiration board

Sites the person admires, side by side: one `dessn_nodes_create` with a frame item per site, `from: { url: 'https://…' }`, in a row (`x` 1600 apart) or a grid, on the person's page (a new private one when they gave none) with a title note saying what the board collects. Each frame is a static capture of the live page, named `Reference · <site>` with its address in a caption under it (only your own agent on your own computer captures sites; at most 3 at once, a fourth answers `waiting` with when to send the same call again). Designs drawn from them go beside the references as the app's own frames (dessn-design), never as copies of the pages.

## A diagram from text

`dessn_nodes_create({ page, key, diagram: { mermaid: 'flowchart LR\n  A[Sign up] -->|verify email| B[Workspace]\n  B -.->|skip| C[Invite]', position: { rightOf: <a node> } } })` draws boxes joined by bound, labelled arrows, laid out by the board's flow layout. `flowchart LR` or `TD`, links `A -->|label| B`, `-.->` dashed, `---` without a head, and state-diagram transitions (`New --> Doing : start`) all work; so does `{ nodes: [{ id, label, tint? }], edges: [{ from, to, label }] }`. Boxes are tinted by what they say (done green, failed red, in progress amber) unless you give a `tint` per node (or Mermaid `style A fill:#...`, `classDef`), or one `tint` for all. Its boxes and arrows come back keyed `<key>:<node id>` and `<key>::e1`, so you can change any of them afterwards.

## Notes that read well

- A title note over the board, a short caption under each frame or step (one or two lines, the frame's width or less), a note beside a frame for a point that needs explaining.
- Notes measure themselves with `h: 'auto'`. Keep them short: the frames are the content.

How Dessn's own design agent writes on a board:

<!-- dessn:canvas-principles -->
Frames run the product's code, so every piece of product UI (a screen, a state, a component) lives in a frame. Notes explain it in the canvas's own sans, ink and grey (var(--canvas-muted-foreground)); fills, badges and shadows compete with frames. A note may show a value, like a colour chip or a type token's size and weight, but never a rebuilt component: beside real frames it looks fake. How the product's type looks is shown in a frame too (a screen that uses it, or a specimen page built from the product's own type styles and labelled as one), since a note sets text in the canvas's font and a sample there shows the wrong typeface. For a state no frame shows, make a frame of that state, or say it wasn't captured.

A board is read without you: the question, a plain answer and a recommendation first, then numbered beats, each headed by a one-sentence claim beside its evidence, so heads alone carry the argument. Shape the board to the story: across, down or a mix.

Write as a designer to a founder: what they'll see first, then why; everyday words and full sentences; code and hex in small print; every number with a yardstick; each caveat beside its claim. A head claims only what everything under it shows; absolutes need a search.

Type must read zoomed out to fit. Starting points beside ~1440px frames: title ~280/600, one line; beat head ~200, grey numeral, over a ~112 claim; answer ~84; caption head 96, grey index, ~64 measure; body 48–56; small 40 grey. One size per role, two weights, lines under ~75 characters.

A chat answer needs no board, a reference frame no note. Accuracy first, then speed, then visible progress: the question goes up in your first write, then each unit lands whole (frame, caption, pointers) in the write checking it. Anything small at fit gets a pointer. Fix in place; write the answer once the evidence is in, and reread the board against it at the end.

Those roles are classes a note already has: `.title`, `.beat` with a grey `.num`, `.claim`, `.answer`, `.stat`, `.lede`, and plain `h1` (200), `h2` (96), `h3` (64), `p` (48), `small` (40). Grey is `var(--canvas-muted-foreground)`.
<!-- /dessn:canvas-principles -->

## Check it like a reader

Picture the whole page (`region: 'fit'`, with `fresh` after new frames) and look:

- Is every label and caption readable at that zoom, and does every arrow go from the thing that leads on to the step it leads to, without crossing a frame?
- Does anything overlap, or is a frame cut off at its bottom (fit it) or left with empty space below its content (fit crops that too)?
- Does the title say what the board is, and does every frame have a name that says what it shows?

## Done means

The board reads on its own, every frame is named and fitted, every arrow is labelled, and your reply links the page and says what is on it and what isn't (a state you couldn't reach, and why).
