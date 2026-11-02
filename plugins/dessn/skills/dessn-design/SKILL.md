---
name: dessn-design
description: Design on Dessn frames the way Dessn's own design agent does. Explore the app before designing, reuse its design system (dessn_designSystem_get), make variations and new states as frame copies whose code you edit directly, check every result against a real picture, and stay in the app's idiom. For a new surface or a bold change with little design system to lean on, a brief first, one visual group at a time and a look at each picture. Use for "make variations / options / alternatives of a surface", "redesign this", "explore different directions", "design a landing page", "a design-system sheet / style guide", "show it at phone, tablet and desktop widths", "try a denser / darker / bigger version", "show the empty / error / loading state", or any change to what a Dessn frame shows.
---

# Design on Dessn

A frame is the user's real app running from its own code, so a design here is a code change to a copy of the app, seen in its real picture. Dessn's promise to the person is fidelity to their production app: the screen they see is built from their own components, styles and data. A component recreated by hand breaks that promise even when it looks the same, so reuse and extend what the app has.

## 1. Understand the app before changing it

- **Find the surface.** `dessn_surfaces_list({ project, query })` finds a Library surface by name, route or the words it shows (each has `id`, `route`, `link` and `via`, the surface that leads to it). A link the person gave goes to `dessn_canvas_get`, which on a frame answers its route and its `entryFiles`, the source files its picture renders.
- **Look at it.** `dessn_canvas_screenshot({ target: <frame or Library link> })`. Look at two or three other surfaces of the same app as well (`route` pictures another surface of the same frame): the parts the ask needs often live on another surface. A state is a route too (`/?view=completed`), or a saved `state`; a frame with prototype controls lists them in `dessn_canvas_get`, and where your screenshot takes `controls` and `switches` it pictures the frame at other values without changing it.
- **Read its code.** `dessn_files_read({ at: <frame link>, paths: [...] })` reads the entry files in one call; `as: 'outline'` first for a long file, then line ranges. `dessn_files_list({ at, grep: '<words on the screen or a component name>' })` searches inside the code and answers each file and line with the lines around it; `glob` lists files by pattern.
- **Read its design system.** `dessn_designSystem_get({ project })` gives an overview: the components the app really uses (file:line, props, variants, how often), its tokens, and how each kind of UI is done here (lists, tables, forms, dialogs, nav), with the app's own examples. Then ask it about what the request needs, which is often not on this screen yet:
  - `kind: 'components', q: 'badge'`: a component by name, purpose or prop;
  - `similar: '<a JSX snippet or a description>'`: the app's components most like what you were about to write;
  - `kind: 'tokens'`: colours, spacing, type, radii with their values;
  - a kind of UI (`kind: 'table'`, `'form'`, `'dialog'`, …): the app's own examples of it;
  - a small or one-file app: `kind: 'blocks'` (the markup it repeats by class name) and `kind: 'classes'` (its CSS classes and rules). Such an app's design system is its classes and repeated blocks: `.card`, `.stats > article` are its components, and the values its stylesheet repeats are its tokens.

## 2. Put the work where the person can compare it

- **The page the person gave.** A page link, or a page they named, is where the work goes: beside the original on it (`dessn_canvas_get` on the page lists its frames with bounds). Only when they gave none, make one: `dessn_pages_create({ project, title, private: true, key })` answers its `id` and `url` (private: seen only by them; leave `private` out for one the team should see).
- **The original on it**, when it isn't there yet: `dessn_nodes_create({ page, key, items: [{ kind: 'frame', from: { surface: <surface id or route> }, name, x: 0, y: 0 }] })`.
- **Each variation is a copy**: `{ kind: 'frame', from: { frame: <original's id or link>, copy: true }, name: 'Dashboard · compact', position: { rightOf: <original's id or an earlier item's key> } }`, all copies in one `dessn_nodes_create` batch (give each item its own `key` so the next can sit `rightOf` it). A copy runs on its own sandbox with the original's code; the call waits while it takes it. Writing the original changes the original, so the original stays as it is.
- **Phone, tablet and desktop side by side**: frames of the original's own sandbox at each width, `{ kind: 'frame', from: { frame: <the original>, state: <its route> }, size: { w: 375 }, position: { rightOf: <the original> } }` (and `w: 768`). Each is the same code at another width, so a fix to that code shows in all of them. A desktop app's page is measured at desktop width, so such a frame keeps its source's height until you give one: `dessn_canvas_screenshot({ target: <it>, fullPage: true })` renders it at its width, and that answer's `height` is the one to send (`dessn_nodes_update`, `size: { w: 375, h }`). `copy: true` at a width makes a separate sandbox instead, for a variant. A phone layout keeps what the desktop gives, the way phone apps do: the brand and a way to each of the app's places in one row at the top (the logo and a menu button with the sidebar's other parts behind it, or the 2 or 3 places as tabs), the main action, body text of 14 to 16 px. A sidebar dropped leaves no way around; one stacked whole above the page pushes the page's own heading off the first screen. A screenshot under 1,024 px wide says either in `issues`, and a sideways scroll or text under 12 px: what is missing from a picture doesn't show in it.
- Name every frame for its idea, so the board reads without the chat.

## 3. Make each design in its copy's code

`dessn_files_write({ at: <the copy's link>, key, files: [{ path, edits: [{ oldString, newString }] }] })`:

- An edit changes only the lines that differ, and several edits to one file go in one call; they are written together only if every `oldString` matches. A miss writes nothing and answers the file's nearest lines (`near`), so the next try needs no read. A whole file (`content`) is for a new file (`allowCreate: true`) or a rewrite.
- The answer is the result: `build` (ok, or its compile, runtime and type errors, to fix in the next write) and `picture`. It comes once the build is done; the new picture lands a few seconds later (`coming`; a new copy's first one 10 to 40 s after its write). A `dessn_canvas_screenshot({ target: <the frame's link> })` sent after the write waits for that write's picture, so a write and its look go in one turn: the screenshot awaited right after the write (in one script where your client runs code). `wait: 'picture'` on the write holds its answer for the picture instead, and `picture.shows` names the headings, buttons and fields it shows that the old one did not: a change of words checked with no screenshot.
- Frames fit their pages by themselves: a copy made without a size takes its page's height again after each write (at most 4,000 px; the write's `fit` says the size, or `pending: true` until its picture lands). A frame you gave a size in px, or one made in the app, keeps it; `dessn_nodes_update({ page, key, changes: [{ id, size: { h: 'fit' } }] })` fits it.
- Time: a write takes about 5 to 15 seconds with its build and picture; writing out a 300-line file costs you about half a minute of output where an edit costs a second or two. Writes to different copies don't depend on each other.
- New files are fine (an extracted component, a variant of one): put them where the app keeps its components, in its own style, and import them where they render.
- `forbidden` on a frame write means this connection may not write frames (an API key, a web connector): `dessn_design_send` asks Dessn's design agent instead, as the person, with their credits.
- The design agent is also the better tool when the change needs Dessn's runtime: a screen behind a sign-in or a click, data the app fetches from a service, a flow mapped from the routes. `dessn_design_send({ target: <page or frame link>, message, edit? })` answers a `runId` and `pageUrl` at once; `dessn_design_status` follows it (3 to 10 minutes, the person's credits). An empty, error or loading state of an app whose data is in its code (a list in a component, a sample file) is a write to the copy: its data or a branch, seconds.

## Inspiration boards: references beside your design

When the person wants ideas from other sites ("an inspiration board for a pricing page", "put a few good onboarding flows next to ours"):

- **Capture them as references.** One `dessn_nodes_create` with a frame item per site, on the person's page (a new private one when they gave none), `from: { url: 'https://…' }`, in a row (`x` 1600 apart, same `y`) or a grid. Each becomes a static picture of that page as it is now, named `Reference · <site>` with its whole address in a caption under it, so the board says where each came from. Pick 3 or 4 public pages that open without a sign-in. At most 3 capture at once: a fourth answers `waiting`, and the same call after its `retryAt` captures it. Only your own agent on your own computer captures sites; any other connection is told to ask the design agent.
- **Read them, don't copy them.** Picture each reference full size (`dessn_canvas_screenshot({ frames: [...] })`) and note what works: the layout and hierarchy, the type scale and weights, the colour and contrast, how density and emphasis guide the eye. Then design your own frame beside them (a copy of the app's surface, sections 2 and 3) in the app's own components and tokens, borrowing those ideas. Never paste a reference's markup, copy, logos, brand colours or pictures into the design: the result is the person's product, informed by the references.
- **Say what you took.** A short note or your reply names, per reference, the idea the design borrowed.

## A design-system sheet

A sheet of the app's design system is a frame like any design: a copy of a Library surface at a new route (`route: '/design-system'`, section "A new design" below), so its specimens are the app's own classes and components rendering live, which notes and drawn boxes can only describe. What reads well, top to bottom at 1440 wide:

- **Colour by role**: every colour that carries a role, one swatch each: ground, surfaces, ink, heading and muted ink, each line colour (a border and a divider are two), the accent and its hover, the selected state, each status with its tint, a progress bar and its track. Labelled with its role, the code's name for it (a variable, or the selector and property that use it) and its hex. A plain-CSS app's roles are where its stylesheet uses each value (`color` on `:root` is the ink, `background` on `.primary` the accent). Sixty small swatches read as a dump of the stylesheet; a role left out reads as a gap.
- **Type**: each size as a line of real text at that size, with its selector, size, weight and line height.
- **Spacing and radii**: a bar per step, a corner per radius, with their values.
- **Components** in their states from the app's own markup and classes (a button default, hover and disabled; tabs with one active; a card, a tag, a field, the dialog), each labelled with its class.
- Readable at a glance, as reviewers judge it: labels about 14 px (values in the code's mono at 13), swatches of 120 to 160 px, five or six to a row, room between sections; a sheet is also seen smaller, on the board. Then a full-size picture of the frame (`fullPage: true`) and a fit.

## 4. Design with intent

- Match the freedom of the request. A refinement keeps the screen and improves one thing; a redesign may change layout. Keep the behaviour outside the change as it was: the controls, the copy and the data the person did not ask about stay where they are.
- For alternatives, make each one a different direction, in layout, hierarchy or interaction, so each answers the question differently. Three colour tweaks of one layout are one idea. Directions or looks the person asks to leave the current style differ in type and palette too (below).
- Build from the app's materials: its components with their props and variants, its classes, its tokens and repeated values, its icons and type scale. A value that isn't in the app comes from its scale (the next spacing step, a colour it already uses). Before writing new markup, `similar` tells you whether the app already has it.
- Keep the screen's data as the app shows it. Mock or sample data changes only when the ask is about data (a long list, an empty state): unrequested edits to sample data are the change reviewers most often mark down.
- One screen per frame, at the frame's own size (desktop frames are usually 1440 wide; a phone is 390 × 844, `viewport` in a screenshot). No device bezels or browser chrome drawn around it: the frame is the screen. Interactive stays interactive: buttons keep their handlers, links still go somewhere.

## A new design, or a bold change

When there's no screen to start from (a landing page, a new product's first screens) or the ask leaves the app's current look ("four genuinely different directions"), the design system decides less and your eye decides more. `dessn_guide` topic `taste` has the method; in short:

- **A brief first**, where the person sees it (a note beside the frame, or your reply's first lines): what it's for and the one thing a reader should do, the mood in a word or two, a palette taken from something real (background, surface, ink, muted ink, one accent, as hex), a type scale (families, a size and line height per role) and a spacing step.
- **A new screen (a landing page, a pricing page) is a copy at a new route.** Copy any Library surface with the route it will have (`{ kind: 'frame', from: { frame: <its link>, copy: true }, route: '/landing', name }`), then write the page as new files plus the line that routes to them. The app's global styles reach the page (rules on `body`, `header`, `main`), so scope its CSS under a root class and look for leaks in the first picture. Writing it yourself takes seconds a write and no credits; the design agent takes minutes and credits.
- **One visual group per write** (the hero, then features, then pricing), looking at each picture before writing the next.
- **Look at each frame full size** (section 5): spacing on one step, one type size per role, body text at 4.5:1 contrast or more, nothing cut off.
- **Directions are points of view**, side by side and each named for its idea: a one-line brief each before the writes (a mood, a palette from a scene of its own, a type family or pairing of its own, a layout, what leads), on the app's same data and working controls. Each rewrites the screen's markup for its own structure and restyles the app's components inside it: a new face and palette on the original's skeleton reads as a reskin, and reviewers chose directions that changed type, palette and structure over ones that kept any of them. A `frames` screenshot's `looks` says which share a face, an accent or a layout as rendered.

## 5. Check against pictures

After the last write, picture the frames you changed in one call: `dessn_canvas_screenshot({ frames: [<copy links>] })`, sent with the write itself where your client runs code (it waits for the write's picture). A page picture draws the whole board small (four desktop frames side by side come out about 300 px wide each, too small to read text or see an overflow); a frame picture is full size. Look at each as the person will:

- Does it build and render (no error overlay, `ok` true)? A picture with `ok: false` is not a check.
- Does it show the idea, at a glance, as named?
- Is anything broken: text overflowing, a part cut off at the bottom (fit it), a layout that collapsed, an element that moved that you did not mean to move?
- Is it plainly the same app: for a variation or a state, the same type, colours, components and spacing; for a direction, the same data and working controls in its own type and palette?

The page picture (`dessn_canvas_screenshot({ target: <page link>, region: 'fit', fresh: { waitMs: 30000 } })`) shows the set side by side, as the person will open it: send it in the same turn as the frames' picture, as the two don't depend on each other. Fix what is wrong with another write to that copy, then look again.

## Done means

- The original is unchanged; each variation or state is its own named copy beside it, in a row with the same top edge.
- Each uses the app's own components, classes and tokens (you can name which), and builds without errors.
- Each frame fits its content, and its picture shows its idea.
- Your reply links the page (its `url`) and each frame you made by its name (its `link`, so the person opens it in one click), and says in a line what each frame tries and why, and anything you could not verify.

## When someone is there to ask

Before spending the person's credits on a design run they did not ask for, before writing a frame on a page others use (rather than a copy), and before deleting anything, ask. Working unattended, take the reversible path (copies beside the original on the person's page, your own direct edits) and say what you chose.

Details of every field: `dessn_guide` topics `files`, `board`, `canvas` and `design-system`.
