---
name: dessn-board
description: Lay out Dessn canvas pages a person can read without the chat. QA boards of an app's surfaces grouped by area, user flows of the app's live screens joined by labelled arrows (the main path in a row, each failure a real state of its step's screen under it), diagrams drawn from Mermaid or nodes and edges, title and caption notes, sections, and frames fitted to their content. Use for "put every surface of our app on a page", "map our sign-up flow", "show the checkout flow with each step and where errors go", "lay out the onboarding journey for a new user", "draw this architecture or state diagram on the canvas", "tidy / arrange this board", "label these frames", or "make the frames fit".
---

# Boards on Dessn

A board is read by someone who wasn't in the chat. It says what it is in a title, each frame is named for what it shows, arrows say what moves the person on, and nothing overlaps or is cut off. Board writes spend no credits; every sign-in can make them (a read-only API key can't).

## The tools

- `dessn_pages_create({ project, title, private?, key })` → the page's `id` and `url`. No project yet: `newProject: '<a name>'` in place of `project` makes one whose Library is Dessn's starter app (`newProject.starter`: a small React app; a frame of it at a new route, `from: { surface: '/' }, route: '/pricing'`, plays once you write its page; refused `STARTER_COPYING` for its first ~40 s, so send it again), or answers the one made before for that name. HTML frames (`from: { html }`) are drawn, for visuals. Connecting their own code (`newProject.connectCode`) sets it up in a new project; this starter stays as it is.
- `dessn_nodes_create({ page, key, items, diagram? })` writes a batch in order: `frame` (from a Library screen `{ surface: <id, link or route> }`, or a copy `{ frame, copy: true }`), `note` (`html`: h1, h2, p, li, small, code, or Markdown; `w`, `h: 'auto'`), `text`, `image` (an uploaded asset), `arrow` (`from`, `to`, `label`, `dashed`, `heads`), `section`. Every item but an arrow takes `x, y` or a `position`: `{ rightOf | leftOf | below | above: <id or an earlier item's key>, gap?, align? }`, which slides past what is already there. Give items their own `key` so later items and arrows can name them. `dryRun: true` answers where each would land and writes nothing.
- `dessn_nodes_arrange({ page, as, ids | root | groups })`: `row`, `column`, `grid` (`perRow`), `flow` (follows the arrows from `root`, widening gaps to hold each label), `sections` (`groups: [{ heading, description?, ids }]`: a heading over each group's grid).
- `dessn_nodes_update({ page, key, changes })`: move, resize, rename, re-route a frame (`route`), edit a note (`expectedRevision` from its last read), re-label an arrow. `size: { h: 'fit' }` makes a frame as tall as its page, so nothing below the first screen is cut off (up to 4,000 px).
- `dessn_canvas_screenshot({ target: <page link>, region: 'fit' | { x, y, w, h } | { nodeId } })` pictures the board as the person will see it; `fresh: { waitMs }` waits for new frames' pictures first (they land 12 s to about 2 minutes after a frame is made).
- Each write's `key` makes a retry safe: the same key and input answer the first answer. A batch past ~40 s answers `status: 'working'`: call again with the same key for the rest.
- `dessn_program_run({ page, code })` runs one JavaScript program against the board (`canvas.*`, `dessn_guide` topic `program`): it pays when many writes depend on what earlier ones answered (a frame's height, then the notes under it; arrows in an order read off the board); a batch you can write after one read is quicker as `dessn_nodes_create`.

Every field: `dessn_guide` topic `board`.

## What goes on a board, and what plays

- **Frames of the app**: Library surfaces, copies, copies at a new route. They are the app running from its code; in Dessn a person presses Play and clicks through them. A screen, a state, a variation, a component gallery or a design-system sheet of the app is a copy whose code you write (skill **dessn-design**, "A design-system sheet").
- **HTML frames** (`from: { html }`): drawn from your HTML, sharp at any zoom and editable, with no Play (nothing in them runs; only their links open). For visuals: an OG image, slides, a moodboard. Something people click and play is a frame of the app, never an HTML frame.
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

A step's words (what the person does there, what can go wrong) go in a caption under its frame.

- Find the steps in the app itself: the Library's screens and their `via` (which screen links to which), the routes in the code (`dessn_files_list` with `grep` for the router or the links, `dessn_files_read` for the nav; `dessn_canvas_get` on any frame of the app lists its `routes`), and the conditions that change what a screen shows (empty, error, loading, permission). A step the Library has no screen for is still a route of the app: `from: { frame, state: '/signup' }` makes its frame on that frame's sandbox. Write the plan once: each step's name, how it is reached (a route, or a route plus a query the app's mocks read), the action that leads there, a one or two line caption.
- The main path runs left to right, numbered "1 · Cart", "2 · Shipping".
- Each frame is a live screen at its real route (`from: { surface: '/checkout/shipping' }`, or `route` on the item). A state only clicks reach (an open dialog, a filled form) is a copy of the step's frame whose code shows that state (dessn-design), or Dessn's design agent can make it (`dessn_design_send`).
- Arrows go after the nodes they join. Each label says what the person does or what happens ("Click Pay", "Payment fails"); keep one meaning per style (solid for the main path, dashed for going back or a failure).
- One `dessn_nodes_create` batch for the frames, captions and arrows, then `dessn_nodes_arrange({ as: 'flow', root: <step 1> })` lays it out and makes room for every label.

## An inspiration board

Sites the person admires, side by side: one `dessn_nodes_create` with a frame item per site, `from: { url: 'https://…' }`, in a row (`x` 1600 apart) or a grid, on the person's page (a new private one when they gave none) with a title note saying what the board collects. Each frame is a static capture of the live page, named `Reference · <site>` with its address in a caption under it (only your own agent on your own computer captures sites; at most 3 at once, a fourth answers `waiting` with when to send the same call again). Designs drawn from them go beside the references as the app's own frames (dessn-design), never as copies of the pages.

## A diagram from text

`dessn_nodes_create({ page, key, diagram: { mermaid: 'flowchart LR\n  A[Sign up] -->|verify email| B[Workspace]\n  B -.->|skip| C[Invite]', position: { rightOf: <a node> } } })` draws boxes joined by bound, labelled arrows, laid out by the board's flow layout. `flowchart LR` or `TD`, links `A -->|label| B`, `-.->` dashed, `---` without a head, and state-diagram transitions (`New --> Doing : start`) all work; so does `{ nodes: [{ id, label, tint? }], edges: [{ from, to, label }] }`. Boxes are tinted by what they say (done green, failed red, in progress amber) unless you give a `tint` per node (or Mermaid `style A fill:#...`, `classDef`), or one `tint` for all. Its boxes and arrows come back keyed `<key>:<node id>` and `<key>::e1`, so you can change any of them afterwards.

## Notes that read well

- A title note over the board (`h1` and one `p`), a short caption under each frame or step (one or two lines, the frame's width or less), a note beside a frame for a point that needs explaining.
- Notes measure themselves with `h: 'auto'`. Keep them short: the frames are the content.

## Check it like a reader

Picture the whole page (`region: 'fit'`, with `fresh` after new frames) and look:

- Is every label and caption readable at that zoom, and does every arrow go from the thing that leads on to the step it leads to, without crossing a frame?
- Does anything overlap, or is a frame cut off at its bottom (fit it) or left with empty space below its content (fit crops that too)?
- Does the title say what the board is, and does every frame have a name that says what it shows?

## Done means

The board reads on its own, every frame is named and fitted, every arrow is labelled, and your reply links the page and says what is on it and what isn't (a state you couldn't reach, and why).
