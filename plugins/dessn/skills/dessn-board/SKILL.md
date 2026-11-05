---
name: dessn-board
description: Lay out Dessn canvas pages a person can read without the chat. QA boards of an app's pages grouped by area, user flows of the app's live pages joined by labelled arrows (the main path in a row, each failure a real state of its step's page under it), with what's broken marked where it happens when it's an audit of a flow, diagrams drawn from Mermaid or nodes and edges, title and caption notes, sections, and frames fitted to their content. Use for "put every surface of our app on a page", "map our sign-up flow", "show the checkout flow with each step and where errors go", "lay out the onboarding journey for a new user", "audit our checkout flow and flag what's broken", "draw this architecture or state diagram on the canvas", "tidy / arrange this board", "label these frames", or "make the frames fit".
---

# Boards on Dessn

A board is read by someone who wasn't in the chat. It says what it is in a title, each frame is named for what it shows, arrows say what moves the person on, and nothing overlaps or is cut off. Board writes spend no credits; every sign-in can make them (a read-only API key can't).

## The tools

- `dessn_pages_create({ project, title, private?, key })` → the page's `id` and `url`. No project yet: `newProject: '<a name>'` in place of `project` makes one whose Library is Dessn's starter app (`newProject.starter`: a small React app; a frame of it at a new route, `from: { surface: '/' }, route: '/pricing'`, plays once you write its page; refused `STARTER_COPYING` for its first ~40 s, so send it again), or answers the one made before for that name. HTML frames (`from: { html }`) are drawn, for visuals. Connecting their own code (`newProject.connectCode`) replaces this starter in the same project; their pages stay (a starter still being made isn't ready to replace yet).
- `dessn_nodes_create({ page, key, items, diagram? })` writes a batch in order: `frame` (from a Library screen `{ surface: <id, link or route> }`, or a copy `{ frame, copy: true }`), `note` (`html`: h1, h2, p, li, small, code, or Markdown; `w`, `h: 'auto'`), `text`, `image` (an uploaded asset), `arrow` (`from`, `to`, `label`, `dashed`, `heads`), `section`, `pointer` (`frame`, `element`, `name`, `token`: a note with an amber line into something inside a frame). A frame takes `caption`. Every item but an arrow or a pointer takes `x, y` or a `position`: `{ rightOf | leftOf | below | above: <id or an earlier item's key>, gap?, align? }`, which slides past what is already there; with neither, the next free slot, and `placed` says where. Give items their own `key` so later items and arrows can name them. `dryRun: true` answers where each would land and writes nothing.
- `dessn_nodes_arrange({ page, as, ids | root | groups })`: `row`, `column`, `grid` (`perRow`), `flow` (follows the arrows from `root`, widening gaps to hold each label), `sections` (`groups: [{ heading, description?, ids }]`: a heading over each group's grid).
- `dessn_nodes_update({ page, key, changes })`: move, resize, rename, re-route a frame (`route`), edit a note (`expectedRevision` from its last read), re-label an arrow. `size: { h: 'fit' }` makes a frame as tall as its page, so nothing below the first screen is cut off (up to 4,000 px).
- `dessn_canvas_screenshot({ target: <page link>, region: 'fit' | { x, y, w, h } | { nodeId } })` pictures the board as the person will see it; `fresh: { waitMs }` waits for new frames' pictures first (they land 12 s to about 2 minutes after a frame is made).
- Each write's `key` makes a retry safe: the same key and input answer the first answer. A batch past ~40 s answers `status: 'working'`: call again with the same key for the rest.
- `dessn_program_run({ page, code })` runs one JavaScript program against the board (`canvas.*`, `dessn_guide` topic `program`): it pays when many writes depend on what earlier ones answered (a frame's height, then the notes under it; arrows in an order read off the board); a batch you can write after one read is quicker as `dessn_nodes_create`.

Every field: `dessn_guide` topic `board`.

## What goes on a board, and what plays

- **Frames of the app**: Library surfaces, copies, copies at a new route. They are the app running from its code; in Dessn a person presses Play and clicks through them. A screen, a state, a variation or a component gallery of the app is a copy whose code you write (skill **dessn-design**). A page of the design system is skill **dessn-design-system**.
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
A flow a person asks to see ("map our sign-up flow", "show the checkout flow with each step and where errors go", "lay out the onboarding journey for a new user") is the app's own pages on their canvas in the order a person moves through them: each step a frame of the app at its route, or a copy whose code shows the state only clicks reach (an open dialog, a filled form), joined by arrows labelled with what the person does. Where it goes wrong is part of the flow. Each failure the code raises is a real state of the app: where the code sends the person (an error page, no results, a 404) is a frame at that route; what it shows in place (a field's message, a toast, an error in a dialog) is a copy of its step's frame whose code shows it, with the words the code uses. Failures sit in a row under the step they happen at, numbered after it ("2a · No file"), each joined to its step by a dashed arrow labelled with what went wrong. A failure the code never handles (nothing reads the file's rows) is a note beside its step. Step cards beside a separate row of pages, or a table of steps in the chat, leave the person to match each step to its page.
<!-- /dessn:user-flow -->

<!-- dessn:flow-map -->
A flow board shows a product's real pages in the order a person moves through them: the happy path in one row, left to
right, routes the person chooses above it, what the system does (waits, errors, dead ends, other ways in) below it, each
edge in the column of the step where it happens. Someone who never saw the chat understands it in a minute.

Someone asking to audit a flow gets this board with what's broken marked on it: each problem a numbered red disc on the frame where it happens, and the same number in "Where people get stuck" at the top with its words and its step. The plan holds the verdict as well: `answer` (the plain answer to what they asked) and `fixFirst` (the change to make first) print under the title, and a finding's `fix` (the change that clears it) under its line. A finding's `rank` (1 is fixed first) numbers its disc and orders the list; findings without one keep the steps' order. `at`, a selector in its step's page, points at the element it's about.

What to check at each step is the audit's: dessn-audit's kind files hold the checks and the probes that measure them. An accessibility audit of a flow reads `references/accessibility.md` (contrast, focus, names and targets, measured by `dessn_canvas_screenshot` `measure` steps), a consistency one `references/consistency.md`, any other review `references/general-review.md` (each also `skill://dessn-audit/references/<file>`; `dessn_guide({ topic: 'audit' })` holds the skill). This board is where its findings go.

**The parts,** the way Dessn's design agent builds them (its flow skill and its `buildFlow`, so its boards and yours read alike):

| Part | Where | What it holds |
|---|---|---|
| Title | Top left, `x` = the first column − 2600, `w` 6400 | One line saying whose journey and to where, a lede of 1–2 plain lines. Its `h1` is 380 px, so it reads at fit |
| Where people get stuck | Beside the title, on the next column past it, `w` 3000 | The findings, numbered, worst first: 2–4 words, the step's id, then a grey line saying how bad it is and what the person meets, with where the code says so (`file:line`) in small print. A finding the code shows and the page doesn't (a request that never goes out, a message that's untrue) belongs here too, with what you read to know it: a reader acts on a list they can rank and trace |
| Not shown | 3400 right of it, `w` 3000 | Each state you couldn't put on the board, and why, and what you couldn't check from here (which path production gives people, say) |
| A lane heading | In the gutter left of its row, `w` 2000, level with the row's top | The lane's name and one line. The happy path first, routes the person chooses above it, what the system does (waits, errors, dead ends, other ways in) below it |
| A frame | `x` = column × 2640, `y` = row × 2400, one page each, `size: { w: 1440, h: 900 }` | Named `{id} · {name}`, at most 15 characters: a name tag past that is cut at fit. An edge state sits in the column of the step where it happens, numbered after it ("2a"); two in one column stack down |
| A caption | 90 under its frame, its frame's width | The id, the name, 1–2 lines quoting the page's own words, and "Way out:" the control that leads on (or "None") |
| A disc | On a frame with a finding: beside its top right corner, 60 into the gap, 160 across (over the frame, the name tag covers it at fit) | The finding's number |
| START, END | 160 left of the first step and right of the last, on the row's centre line | Joined to them with an unlabelled arrow |
| A marker for another way in | 60 left of its page, `w` 520, on its centre line | An `h3` in the grey ("From 1 ·<br>bad email", "Invite email opened"), with an unlabelled arrow to the page |

Those gaps (1200 between columns, 1500 under a row) hold the arrows' labels, the captions and the name tags, which keep their size on screen as the board zooms out. Ten columns of 2640 make a board too wide for much but the title to read at fit, so merge states that look the same. Two paths to one goal (an old flow and its replacement, a flag or a cohort that decides) both go on it, each a lane, with a line saying who gets which.

**Find the steps:**

- `dessn_surfaces_list({ project, query })`: the Library's pages with `route`, `shows` (the words on them) and `via` (the page that leads there). A route with a state token in its query is a state setup saved. On a large app this is most of the inventory, and it wakes no sandbox.
- `dessn_files_list({ at: <a frame>, grep })` and `dessn_files_read`, many paths in one call, for the guards and routers, the conditions that change a page, the form rules and their error messages. `dessn_canvas_get` on a frame lists its `routes` and, while its app runs, its `mocks`: the requests a mock answers (what the frame shows from them is sample data, so a finding about it says so) and those none does. The first search wakes a sleeping frame (20–30 s); the ones after take seconds.
- **A page's name is the Library's label for it, not text on its page.** Setup names a saved state for the designers
  ("Permissions", "Referral", "Email check"); the page itself prints its own words ("Allow microphone access"). The words
  a state shows are in its saved page's `shows`, in the route's own copy in code (its component and the
  strings it renders: one sign-in form's locale file says "Email is required" where the field prints "Required"), and in
  the page's saved picture (`dessn_canvas_screenshot` of its link). On one meeting-notes app, three plans of six
  named states by their page names, and the pages never said those words.
- **A state the mocks can't show yet** (an empty list, a failing save, a loading state): a frame's mock `switches` (`dessn_canvas_get` lists them, and
  `dessn_nodes_update` with `switches` keeps a frame at one; a staff preview) or a saved page's route usually reach it. Where none does, a copy whose mock you write shows it (skill dessn-design, "When the mock data has to act"). A file write on a frame answers the build it caused (compile, runtime and type
  errors), so read that answer before you place the frame.
- A frame the Library has no saved page for: make one frame of the app first, then `from: { frame: <its id or an earlier item's key>, state: '<route>' }` on the same sandbox, in the same batch. A state only clicks reach (an open dialog, a filled form, the error under a field): the Library may already hold it (a route with a state token); else press to it with `dessn_canvas_screenshot({ target: <a frame>, steps })` and end on `{ freeze: { proof: '<words it shows>' } }`, as the design agent's flow freezes each state its plan clicks to: its `frozen.state` is a step's `from: { frame, state }`, the app itself at that moment (a staff preview for now). Where a freeze isn't open or answers `restored: false`, a copy whose code shows it (`from: { frame, copy: true }`, then `dessn_files_write`), or a line in "Not shown". Each press answers what it changed, and one that matched nothing `instead`: what the page shows to press.
- **See a state before it goes on the board.** `dessn_canvas_screenshot({ target: <a frame>, route: [<up to 12 routes>] })` pictures them together, and `frames: [<links>]` the frames you placed: a 404, an error screen, grey placeholders or a page cut off aren't the step, and the board's picture at fit is too small to tell. Such a step gets a mock or a copy that shows it, or a line in "Not shown". This is what the design agent's proof does for each of its frames.

**Build it,** in one call: `dessn_nodes_create({ page, key, flow: <the plan> })`. The plan says what the board holds; where each part goes, its sizes, the header levelled over the top row and the arrows' sides are the design agent's own code (its `buildFlow`), so your board and its read alike. The first step lands at `x`, `y` when the plan names them, else clear under what's on the page. `stuck` is a finding (`{ words, gloss, fix?, rank?, at? }`): its disc and its line in the header. `edgeOf` puts an edge state in its step's column; `stub` is another way in; `above: true` puts a lane over the happy path, which comes first:

```json
{
 "title": "From sign-in to the app",
 "lede": "1–2 plain lines on whose journey it is and where it ends",
 "answer": "An audit: the plain answer to what they asked",
 "fixFirst": "An audit: the one change to make first",
 "notShown": [
  "Their email inbox (outside the product)"
 ],
 "lanes": [
  {
   "name": "Happy path",
   "line": "What most people do",
   "steps": [
    {
     "id": "1",
     "name": "Sign in",
     "caption": "What the person sees and can do, in the page's own words.",
     "out": "Continue with email",
     "from": {
      "surface": "/login"
     }
    },
    {
     "id": "2",
     "name": "Verify",
     "caption": "\"Check your email.\" The code they typed.",
     "out": "Resend",
     "from": {
      "frame": "1",
      "state": "/login/verify"
     }
    }
   ]
  },
  {
   "name": "Held by the form",
   "line": "What the system does to them",
   "steps": [
    {
     "id": "1a",
     "name": "No email",
     "failure": true,
     "edgeOf": "1",
     "caption": "The field says only \"Required\".",
     "out": "type an email",
     "from": {
      "surface": "<the state's own surface>"
     },
     "stuck": {
      "words": "Only \"Required\"",
      "gloss": "Most people type an address the form refuses and aren't told why",
      "fix": "Say what the address needs: \"Enter an email like name@company.com\"",
      "rank": 1,
      "at": "input[type=email]"
     }
    }
   ]
  }
 ],
 "arrows": [
  {
   "from": "1",
   "to": "2",
   "label": "Continue"
  },
  {
   "from": "1",
   "to": "1a",
   "label": "No email",
   "color": "red",
   "dashed": true
  }
 ]
}
```

A step's `out` is drawn for you, as its caption's own grey "Way out: …" line, so its `caption` says what the page shows and not the way out again. The answer lists each part with its key: a step's frame under its id, its caption `<id>:caption`, its disc `disc:<id>`, a lane's head `lane:<n>`, so you can change any of them afterwards.

The grid is the layout, so `dessn_nodes_arrange` isn't part of this: it would fold the lanes into one line. Take `dessn_canvas_screenshot({ target: <page>, region: 'fit', fresh: { waitMs: 120000 } })` once the frames have their pictures: its `issues` name what overlaps, each with the call that fixes it, and a `region` shows a part close up.

**Arrows.** An arrow along a row joins the frames as it is. One that changes rows leaves and enters on the right side of both frames, which `flow` does for you (in an item, `from: { key, side: 'right' }, to: { key, side: 'right' }`), so it runs down the gap between columns, clear of the captions and name tags, with room for its label; bottom to top it would cross both. Two leaving one frame on one side in one direction stack their labels: give the second `side: 'left'`, or a marker instead of a line (the part above). Labels keep their size on screen, so past about 20 characters one wraps and stands taller than its line: the control's words, shortened. `color` and `dashed` are `dessn_nodes_create` fields.

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
  gets a page, or a line in "Not shown".
- **Ways in:** signed out, an invite, deep or email link, a returning user, joining someone else's
  account. A state reached only by a link (a stale link, a not-found page) starts from its own
  "From a link" marker, never from a happy-path page.
- **Waits and empty states:** a slow job in progress, a pending approval, a first run with no data.
  Each kind of state the person names (empty, error, wait) shows on the board under that word: in a
  page's name, a lane heading or a "Not shown" line. When the happy path's first-run page is the
  empty state, its name says so ("8 · Empty home").
- **Failures of every action that writes**: create, save, send, share, generate, import, pay. Show what
  the product shows when the request fails. Also show **everything that blocks the final action**: a
  missing connection, ownership or role, a feature flag, required fields, a limit.
- **Permission and role variants** that look different, such as a read-only viewer: one frame each.
- **Steps outside the product** (a sign-in provider, a payment page, an app install, an email): the
  return, its failure, and what anyone else involved sees. Another person's part starts from a marker
  naming how they enter ("Invite email opened"), then their first page. It never hangs off the
  sender's page.
- **Ways out:** the recovery each edge page offers (Retry, Back, Connect another), and what a request
  leads to ("Request sent").
- **Every checkpoint between an action and its result**, such as draft, then scheduled, then sent. Show
  the state the action really creates: check the status or flag it sets in the code.

Merge states that look the same. Skip hover-only or momentary states unless the flow depends on them.
Build only one journey when two have different goals (an admin configuring billing is separate), and
offer the other at the end.

### Truth

- **A frame keeps its slot and its caption gets a body only after you saw it show that state** (its picture, or `steps`); until then
  the caption is its name. A skeleton, a spinner, the parent page or a different record is not the
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
  - the pages by row, counted with `dessn_canvas_get`;
  - how to reproduce each one (its route, parameter or token);
  - the "Not shown" states, and why;
  - anything you assumed, and any product bug you noticed.
<!-- /dessn:flow-map -->

## An inspiration board

Sites the person admires, side by side: one `dessn_nodes_create` with a frame item per site, `from: { url: 'https://…' }`, in a row (`x` 1600 apart) or a grid, on the person's page (a new private one when they gave none) with a title note saying what the board collects. Each frame is a static capture of the live page, named `Reference · <site>` with its address in a caption under it (only your own agent on your own computer captures sites; at most 3 at once, a fourth answers `waiting` with when to send the same call again). Designs drawn from them go beside the references as the app's own frames (dessn-design), never as copies of the pages.

## A diagram from text

`dessn_nodes_create({ page, key, diagram: { mermaid: 'flowchart LR\n  A[Sign up] -->|verify email| B[Workspace]\n  B -.->|skip| C[Invite]', position: { rightOf: <a node> } } })` draws boxes joined by bound, labelled arrows, laid out by the board's flow layout. `flowchart LR` or `TD`, links `A -->|label| B`, `-.->` dashed, `---` without a head, and state-diagram transitions (`New --> Doing : start`) all work; so does `{ nodes: [{ id, label, tint? }], edges: [{ from, to, label }] }`. Boxes are tinted by what they say (done green, failed red, in progress amber) unless you give a `tint` per node (or Mermaid `style A fill:#...`, `classDef`), or one `tint` for all. Its boxes and arrows come back keyed `<key>:<node id>` and `<key>::e1`, so you can change any of them afterwards.

## Where frames and text go

<!-- dessn:board-craft -->
The words Dessn's own design agent reads about placing things on a board, in the MCP's calls. A board reads when it's placed this way, so its boards and yours read alike. Sizes are world px beside desktop frames; they are starting points.

Everything you place on the canvas is visible to the user. Organize it as a designer preparing a file for someone else to use. The finished collection should make sense without reading your chat. Its layout is part of the deliverable.

Read the page with dessn_canvas_get before arranging it. Its bounds are world pixels, not the screen pixels after zoom. Preserve what people placed, and reuse frames already there. Remove your own obsolete notes and duplicates only when their replacements cover the same frames. Keep unfinished requested frames visible.

Compose a compact overview: someone zoomed out should recognize the product areas and all the frame thumbnails at a glance, then zoom in to inspect a frame. For roughly 15 frames, three or four meaningful groups arranged across a few rows can work well. Choose groups by feature or journey and order frames in each group by how someone uses them. Two or three columns per group are a useful starting point; adapt to the actual content and avoid a long strip or scattered islands. Align frame edges, keep gaps consistent within groups, and leave visibly more space between groups. With 1280–1440px-wide frames, start around 160px column gaps and 240px between unlabelled rows. For labelled rows and groups, reserve the full heading/description height plus clearance above and below; 240px is not a budget for that whole stack. Keep the preview dimensions appropriate to the product. Start near the existing useful cluster or the origin on an empty board.

Place the first node deliberately, then prefer relative placement using its id or its item's key: position: { rightOf: 'first', gap: 160, align: 'top' }. For a labelled new row, build the sequence previous row → heading/description → next row; do not place the frames first and squeeze their headings into a fixed gap. Choose the previous-row anchor with the greatest bounds.y + bounds.height, so the new heading clears the entire row. For example, after choosing rowBottom and an existing nextFrame:
`{ kind: 'note', key: 'heading', title: 'Confirmation', html: '<h2>Confirmation</h2><p>What the person sees once the order is placed.</p>', w: 1440, h: 'auto', position: { below: <rowBottom>, gap: 80, align: 'left' } }`, then the frames in the same batch at `position: { below: 'heading', gap: 320, align: 'left' }`, or an existing one moved with dessn_nodes_update's `{ id: <nextFrame>, position: { below: <the note's id>, gap: 320, align: 'left' } }`.
The placement counts the note's measured height. Put any description in the same note as its heading, so the frames anchor below one node. With a 240px note, this example needs about 640px between rows (80 + 240 + 320), not 240px. Align the new group's left edge deliberately when the lowest previous frame is in another column.

leftOf/rightOf align top/center/bottom; above/below align left/center/right. Anchors must already exist: a node on the page, or an earlier item's key. These resolve once against the current bounds, not live constraints. Moving an anchor later does not move its neighbors. { x, y } lands exactly there, on top of what is there or not. A relative position starts at its gap from its anchor and slides on past what stands in its way, keeping 120 clear at the sides and 200 above and below of everything but its anchor: give the gaps above as `gap`, since a gap you give is the one it keeps from its anchor. dessn_nodes_arrange's row, column and grid take `gap` too. An omitted position finds a nearby free slot, and `placed` says where and beside which frame. A write's answer can carry `overlaps`: the node, what it lies on, by how much, and `clear`, the nearest place a gap clear. These are advisory: placement succeeded and nothing was automatically moved. Fix unintended overlaps with dessn_nodes_update before finishing. Checks use persisted frame, text and HTML bounds, excluding frame labels; still review label clearance and the full board at overview zoom.

Frame bounds cover the preview, excluding its label above it. Labels occupy about 18 screen pixels at every zoom. Leave about 30 screen pixels between the bottom of a group heading/description and the first preview to clear the label and give it breathing room: world gap = 30 / overview zoom (240px at 12.5%). On broad boards, 240–320 world pixels is a useful starting gap. Place the full heading/description stack before that clearance; an empty gap between the text and preview bounds alone does not prove their labels fit. Use concise, distinctive frame names such as Conversation, Assets and Settings; let the group heading carry shared context instead of repeating Project workspace in every label.

Use a little text with a clear hierarchy: one optional board title, one short heading per meaningful group, and notes only where they explain something useful. Write each as a note (`h: 'auto'`) in plain h1, h2, p and small and the role classes below, which already come out at sizes for overview zoom. Product UI (a page, a state, a component) lives only in frames, which run its code: a note shows values (a colour chip, a type token's size and weight), never a rebuilt component, and how the product's type looks is shown in a frame too, since a note sets text in the canvas's font, not the product's. A subtitle or group description should add information beyond its heading; omit it when it merely lists the nearby frames. Next to desktop frames, sizes are starting points chosen so the board's spine reads zoomed out to fit: the title .title (280px, one line), or an h1 (200px) on a board a few frames wide with no beats (an h1 is a .beat's size, so never both on one board); a beat's head .beat (200px, its numeral a .num), with its one-sentence claim a .claim (112px) under it; the short answer .answer (84px), and key numbers .stat (176px), each over a <small> yardstick; a group head about 128px, after a thin rule; a caption head an h2 (96px): a grey index, the name, and its measure as a trailing .num, which comes out at 64px on the same line; body a p (48px, or .lede 56px for a line read closer up); sources and labels small (40px, grey). Weight 600 and the muted grey (small, .num, .muted or var(--canvas-muted-foreground)) are there for hierarchy. Each role keeps its own size, so a beat never looks like a caption. Short of room, cut words or widen the note rather than shrinking it. If the overview feels too large, tighten empty space and rebalance groups before enlarging text. Review the complete board for recognizable thumbnails, legible headings and frame labels, a clear reading order and no overlaps. These are starting points, not a mandatory template.

To point at something inside a frame, add a pointer item to a dessn_nodes_create batch, `{ kind: 'pointer', frame, element, name, token }` (element: a CSS selector of something in the frame's page; token: what someone copies, in mono; with nothing to copy, detail: a short plain phrase in its place): it puts the note in the band under the frame at the foot of the nearest gap, beside any caption, or level with the element in a free gutter, and runs the line up the gap into the element's side, so it crosses little product and no text. One colour for every pointer keeps them apart from flow arrows; two lines sharing a run blur which ends where. Spacing starting points beside 1440 × 900 frames: a caption about 90 below its frame (under a pair's first frame, so the band under the second holds pointer notes), about 120 between the two frames of a pair, about 400 between pairs, about 700 under each row for captions and pointer notes, and 600 or more between sections. Plan the groups before placing them, leaving each its room for the notes you will write later (the title and answer, beat heads, captions and pointer notes): making room later shows as the board jumping. Shape the board to the story, across, down or a mix, with each beat's head beside its evidence. Keep gaps consistent: equal gaps read as one group, a bigger one as a new section. A frame's move carries the notes standing under it (its caption, and the pointer notes in its band: its answer's `carried` lists them); after a move or a page picture's issue, re-place a pointer with `{ kind: 'pointer', note: <its id> }`: deleting it loses the claim it carries. A before/after pair whose change is a small part of a big page (a sign-in card, a dialog, a button on a 1440 × 900 screen) reads only when its frames show that part: at the zoom a board of pairs is seen at, a 400 px card in a 1440 px frame is about 100 screen px inside a mostly empty frame, too small to judge, so give both frames the same `view` once both pictures are in (dessn_nodes_update; a page picture's `frames_differ_in_small_part` issue names the part, and its `fix` is the call); the pages still lay out at their own size and Play opens them whole.

**A note's roles.** Plain h1 (200px), h2 (96), h3 (64), p and li (48, about 70 characters a line), small (40, muted), code (mono at the size of the line it is in), b and strong (600), hr and table already come out at canvas sizes in the canvas ink in every note, and so do seven classes, one per role: .title (280, weight 600: the board's title, one line; a plain h1 titles only a board a few frames wide with no beats), .beat (200, 600: a beat's head, its numeral a .num in the grey; an h1's size, so never on a board an h1 titles), .claim (112, 600: the beat's one-sentence claim under its head), .answer (84, ink: the short answer at the top), .lede (56, a softer ink: a line read closer up), .num (muted, weight 400, tabular figures: the index and measure in a caption head, whose trailing .num comes out at 64 on the head's line, <h2><span class="num">02</span> Settings <span class="num">18%</span></h2>) and .stat (176, 600, tabular: a key number over its <small> yardstick, <p class="stat">1,127</p><small>lines in src use them</small>); your own CSS overrides any of it.

**Captions.** A frame item takes `caption`: a note's HTML, or Markdown. It goes 90 below the frame, at the frame's width, left-aligned, `h: 'auto'`, in the same call, and moves down with the frame when the frame takes its page's height; the answer's `captionId` names it. A pair's one caption goes under its first frame. A lone reference frame needs none.

**Arrows.** Connect pages in the order a person uses them: one arrow per user action, from the control the person uses (from: { id | key, element: its selector, e.g. 'button:has-text("Continue")' }) to the page it leads to, labelled with the action. Arrows stay attached and route themselves (sides, bends, spacing, obstacles) whenever nodes move or resize: never compute coordinates, sides or waypoints, and pass a side only when the person asked for one. Flows read left to right. After connecting a journey, call dessn_nodes_arrange({ page, as: 'flow', root: <its first page> }) instead of placing frames by hand; it moves only the frames connected to root, so flows the person laid out elsewhere stay put. Keep ≥ 320 px between connected columns so arrows and labels have room.
<!-- /dessn:board-craft -->

## Notes that read well

- A title note over the board, a short caption under each frame or step (one or two lines, the frame's width or less), a note beside a frame for a point that needs explaining.
- Notes measure themselves with `h: 'auto'`. Keep them short: the frames are the content.

How Dessn's own design agent writes on a board:

<!-- dessn:canvas-principles -->
Frames run the product's code, so every piece of product UI (a page, a state, a component) lives in a frame. Notes explain it in the canvas's own sans, ink and grey (var(--canvas-muted-foreground)); fills, badges and shadows compete with frames. A note may show a value, like a colour chip or a type token's size and weight, but never a rebuilt component: beside real frames it looks fake. How the product's type looks is shown in a frame too (a page that uses it, or a specimen page built from the product's own type styles and labelled as one), since a note sets text in the canvas's font and a sample there shows the wrong typeface. For a state no frame shows, make a frame of that state, or say it wasn't captured.

A board is read without you: the question, a plain answer and a recommendation first, then numbered beats, each headed by a one-sentence claim beside its evidence, so heads alone carry the argument. Shape the board to the story: across, down or a mix.

Write as a designer to a founder: what they'll see first, then why; everyday words and full sentences; code and hex in small print; every number with a yardstick; each caveat beside its claim. A head claims only what everything under it shows; absolutes need a search.

Type must read zoomed out to fit. Starting points beside ~1440px frames: title ~280/600, one line; beat head ~200, grey numeral, over a ~112 claim; answer ~84; caption head 96, grey index, ~64 measure; body 48–56; small 40 grey. One size per role, two weights, lines under ~75 characters.

A chat answer needs no board, a reference frame no note. Accuracy first, then speed, then visible progress: the question goes up in your first write, then each unit lands whole (frame, caption, pointers) in the write checking it. Anything small at fit gets a pointer. Fix in place; write the answer once the evidence is in, and reread the board against it at the end.

Those roles are classes a note already has: `.title`, `.beat` with a grey `.num`, `.claim`, `.answer`, `.stat`, `.lede`, and plain `h1` (200), `h2` (96), `h3` (64), `p` (48), `small` (40). Grey is `var(--canvas-muted-foreground)`.
<!-- /dessn:canvas-principles -->

## Check it like a reader

<!-- dessn:board-check -->
Look once after the first section lands and once before you reply: the question and answer should read, the board should fill the screen's shape, every heading and number you would quote should be legible, and each frame should agree with its caption. Fix the arrangement before enlarging type. Two looks are usually enough. Picture the whole page each time: `dessn_canvas_screenshot({ target: <page>, region: 'fit' })`, with `fresh` after new frames.

An issue is a repair to make in place, and `fix` is the call that makes it, where there is one: move a note, re-place a pointer (`{ kind: 'pointer', note }`), give a clipped note its height, lay a tall board across or enlarge a title too small at fit, say a code name in plain words; fix what `issues` names in one batch. Deleting a pointer or a caption is not a fix: it takes its claim with it.
<!-- /dessn:board-check -->

And look:

- Is every label and caption readable at that zoom, and does every arrow go from the thing that leads on to the step it leads to, without crossing a frame?
- Does anything overlap, or is a frame cut off at its bottom (fit it) or left with empty space below its content (fit crops that too)?
- Does the title say what the board is, and does every frame have a name that says what it shows?

## Done means

The board reads on its own, every frame is named and fitted, every arrow is labelled, and your reply links the page and says what is on it and what isn't (a state you couldn't reach, and why).
