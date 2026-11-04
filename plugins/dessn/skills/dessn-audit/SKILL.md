---
name: dessn-audit
description: Design audits and proposed design-system changes on the canvas, with the product's real screens as evidence, such as a new colour, grey or colour token across surfaces, dark mode or theming, type scale, spacing and layout rhythm, component consistency (buttons, inputs, cards), contrast and accessibility, or a general review of polish across screens and window sizes. Use when the person asks what a change would look like across screens, whether something is consistent or holds up ("how does dark mode hold up", "are our buttons consistent"), or to review tokens, colours, type or spacing across the product. Not for mapping a user flow (dessn-board), designing one screen, or a page that only shows the design system (dessn-design).
---

# Design audits on the canvas

On Dessn's MCP, what this skill's programs do:

| It says | You call |
|---|---|
| a program on the board; `canvas.*` | `dessn_nodes_create` and `dessn_nodes_update`, or one `dessn_program_run` with the same `canvas` and `project` |
| `canvas.viewBoard`, "view the board" | `dessn_canvas_screenshot({ target: <page>, region: 'fit' })`: its `issues` carry each fix |
| `updateHtml` | `dessn_nodes_update` with `html` and `expectedRevision` |
| `f.files`, `f.bash`, "code reads", counts in code | `dessn_files_list` with `grep`, `dessn_files_read` |
| `page.snapshot`, a look at one element | `dessn_canvas_screenshot({ target: <frame>, steps: [{ read: <where> }, { shot: true }] })` answers its box, text and styles |
| `run(page, TEXT \| CENSUS \| TOKENS)`, `pixels(page)` | The same code on a `steps` call: `dessn_canvas_screenshot({ target: <frame>, route?, steps: [{ measure: 'text' }, { measure: 'census', selector, props }, { measure: 'tokens', names }, { measure: 'pixels', colours }] })` answers each as its step's `measured` |
| `page.evaluate` of your own code, `sweep` | One `steps` call per route; code of your own doesn't run. Say on the board what you measured and what you didn't |
| `canvas.point`, a pointer | A `pointer` item in `dessn_nodes_create`: `{ kind: 'pointer', frame, element, name, token }` (or `canvas.point` in a `dessn_program_run`) |
| `caption:` on a frame | `caption` on its `dessn_nodes_create` item |
| `skills.read` | The files in this skill's `references/`, or the resource `skill://dessn-audit/references/<file>`. `dessn_guide({ topic: 'audit' })` holds this file with board-anatomy.md and writing.md |

An audit board answers one question about the product's design for whoever decides, with the product's own screens as evidence. From afar it reads as the question, the answer, the recommendation and where the answer shows most. Up close, each claim has its number, its source and its pixels. This file holds what every audit shares. Each kind of audit has its own file in references/, and so do the measuring, the layout and the writing. Read the ones your request needs, when you need them.

## 1. Pick the kind

Pick the row that names the property the person wants to decide about, whatever words they use.

| The person asks about… | Kind | Read |
|---|---|---|
| a new or changed colour: a grey, brand colour, accent, tint or colour token ("what would this grey look like across our screens", "try this hex") | palette change (proposal) | `references/palette-change.md` |
| whether a theme holds up (dark mode, a high-contrast theme, a second brand theme), or what a new theme would look like | theme (findings, or a proposal) | `references/dark-mode.md` |
| type: sizes, weights, fonts, line height, or a new type scale or font | type (findings or proposal) | `references/type-scale.md` |
| spacing, padding, corner radius, density, alignment, layout rhythm, or a new value for one of them | spacing (findings or proposal) | `references/spacing.md` |
| one component or pattern across screens, including its own type, spacing and colours: buttons, inputs, cards, tables, tabs, icons, empty states | consistency (findings) | `references/consistency.md` |
| contrast, readable text, keyboard focus, target size, screen-reader names, WCAG | accessibility (findings) | `references/accessibility.md` |
| anything else across screens, or nothing above fits: polish, "what feels off", a critique of an area, other window sizes, content that stretches a screen (long names, empty, error and loading states), elevation, shadows or motion. Say which lens you chose in your first update. | general review (findings) | `references/general-review.md` |

How to read the table:
- **Two rows fit.** Read both kind files. The one that names the decision sets the board's question, and the other adds its measure and a beat. For example, a new grey that must hold up in dark mode reads palette-change.md and dark-mode.md.
- **An explain ask.** "How does our type scale work?" or "document our colours for the team" asks for no verdict. Use the kind file's yardstick, evidence and Today beat, under a title such as "How does Acme's type scale work?". Skip the verdict, risks and options unless the evidence turns up a problem.
- **One screen.** When the scope is a single screen, its states, tabs and regions become the scope list, and the ranking unit is the cause or the region.
- **Neighbouring skills.** A journey across screens belongs to dessn-board's "A user flow". A screen that can't reach the state you need is a copy whose code shows it (dessn-design).

## 2. Read in steps

A program's answer holds about 40,000 characters. Read in steps, each in one program that returns the joined text itself:
1. **The kind file with `references/measuring.md`,** in the same program that puts the question up as the board's title. The title needs only the kit's `.title` class and section 4 below.
2. **Before you measure or place anything else:** `references/board-anatomy.md` and `references/writing.md`, with `references/pixels.md` when you measure how much of a screen a colour paints (a surface, or light patches in a dark theme). The three fit in one read.
3. **A second kind file,** when two rows fit, in a read of its own.

```js
const read = files => Promise.all(files.map(resource => skills.read({ package: 'skill://system/dessn-audit', resource }))).then(parts => parts.join('\n\n'))
return read(['references/palette-change.md', 'references/measuring.md'])
```

## 3. Evidence first

- **Follow each value to what a frame renders.** A token file says what a value should be. A runtime copy, a theme wrapper or a value written straight into the code can beat it, so resolve the value in the page.
- **Keep a scope list** of the screens, states and themes the question covers. Each one ends up on the board or under "What we didn't check", and the worst case always appears.
- **Measure before you arrange.** Measure every screen through the frames you build from, rank them, then place each frame once, in its ranked slot. One ranking uses one declared measure. A second measure is a second column, never a re-sort.
- **Measure what is seen, with the measure the value's role calls for.** A surface is measured by the pixels that show, because cards paint over its boxes and box areas overstate it (pixels.md). Text, links, icons and small fills such as buttons are few pixels, so count the elements or characters that carry them and check their contrast; that takes seconds. A value that plays both roles, such as an accent that also fills a header, is measured both ways. When the measure doesn't separate the screens (one main button on each), say so in a line rather than ranking on noise, and spend the time on the evidence that decides the question, such as the states and the text on the value.
- **Give every number what it counts and a yardstick,** such as "64% of the screen" or "4.5 : 1 is the minimum for body text", so a fail never reads as a pass.
- **Back every absolute with a search or a render.** "Dark mode is unaffected" and "already handled" are true only after one. Otherwise, narrow the claim.
- **Accuracy comes first,** then speed, then visible progress. A slower true board beats a fast one that contradicts itself.

## 4. The story every audit shares

Every audit belongs to one of two families:
- **Proposal:** a change someone is considering. Today sits beside proposed. Each pair comes from the same code and data and differs only in the change, and the board says how the proposed side was made.
- **Findings:** how something holds up. Instances are ranked by severity, worst first, each with where it is and why.

The board runs through these beats. Merge any beat that adds nothing. The board's shape is yours to choose. Two principles guide it: keep each beat's evidence close to its claim, about two panels across beside its head, and lay the beats out like a page, in rows read left to right, then down, numbered in that order, so the reader never jumps back up to find the next beat. A beat whose evidence needs the width spans a full row. A report reads best about the shape of a screen, because long, sparse rows make the reader pan and shrink everything at fit. Journeys and flows can run wide, because left to right is their story (board-anatomy.md, "Shape").
- **Opening.** Put the question as the title, in the reader's words, and say why it's asked. Then the short answer: the verdict first, with its condition. Give two or three numbers, each over its yardstick. Give the recommendation its own headline, with the one thing to check or fix first when there is one. Say how to read the board. A reader who stops here has the answer.
- **1 Today.** Show what exists now: the real values, and where each shows up by plain role. Put them on plates of values (chips, ramps, counts, type values as text: family, size, line height, weight, token name), never a rebuilt component. How the product's type looks shows in a frame, since a note can't load its font (board-anatomy.md, "Plates").
- **2 The change, or what we found.** For a proposal: new beside old, what stays the same around it, what it does to contrast, and the states no screenshot shows. For findings: the causes, each with its count and source.
- **3 How it looks.** Rank the frames by the measure, under tier heads named by what the reader sees, with the range beside each. When the measure doesn't separate them, say so in the beat's claim and order the frames by the role each shows. Each caption gives the index, name and measure on one line, then one or two plain sentences, then the source in small print. Point at what each caption names.
- **4 What to watch out for.** Put each risk under an action kicker (Check first, Fix alongside, Tidy up, Check after shipping) with its test. End with what the board doesn't prove.
- **5 What we recommend.** List the options from smallest to largest, each with its cost, and mark the one you recommend. Put the ask in one line. Number the steps so someone who didn't see the chat can run them.

Beats take single numerals and screens two digits, so they never collide. Heads carry the argument: each head is a claim the evidence under it proves, never a label.

## 5. How the notes look

A board looks considered when a few habits hold in every note and plate, whatever the kind of audit. board-anatomy.md has the sizes and the markup.
- **One ladder.** Each role keeps one size across the board (board-anatomy.md, "Sizes"), and plates use the same steps for their titles, rows and footnotes. A size between two steps reads as a slip, not a nuance.
- **Lines a reader can follow.** Keep the kit's measure, about 70 characters a line, because a longer line is hard to follow back to its start when someone zooms in to read it. When a note is wider than its text, give the room to columns or make the note narrower, rather than stretching the line.
- **Boxes as tall as their content.** Notes in a row start level, under a top rule where the row has one; their bottoms may differ. A box or a white plate around empty space reads as something missing.
- **Emphasis once.** Only the recommendation, and the option it names, are boxed in ink, and the first risk's top rule is the only other ink line. Everything else is set apart by size, weight, grey and space, with hairlines between, so those still stand out.
- **Two voices, kept apart.** Your words are in the canvas's sans and ink. A plate is the product's values on a white panel, in its own variables: chips, ramps and bars, each named by its colour and role. It doesn't draw a piece of the interface or set a sample of the product's type: both live in frames, because a drawn copy beside them reads as fake and a note can't show the product's font. Code, tokens and paths are small mono print wherever they appear.
- **Rows that line up.** Captions under a row of frames start level, and so do the pointer notes under them, so the row reads as one line of evidence.

## 6. Build it where they can watch

1. **Put the question up as the title in your first program on the board,** the one that reads the kind file. Then research in parallel: the code reads, the token values and the counts.
2. **Place the Today beat in the program that starts the measuring,** with what the code reads already give: its head, its claim unless it waits on a count, and plates of the definition, ramp, token pairs or reach. The person sees the work begin, at no cost in time. A census or ratio the beat quotes from the pages goes in with `updateHtml` when its counts land. Leave room above it for the opening (board-anatomy.md, "Room"), so nothing moves when the answer arrives. Then measure every screen in scope, and rank where the measure separates them. For a proposal, make the proposed build earlier, in the program that reads board-anatomy.md (the kind file says how), so the measuring covers both sides.
3. **Write the opening once the measures are in:** the short answer, its numbers and the recommendation. You know the answer then, and the top of the board shouldn't stay a bare title for most of the run. The reconcile read checks it against everything beneath it.
4. **Place the rest in reading order, one beat or tier per program,** on a grid planned with room for the notes still to come: its head, then its frames in their ranked slots with caption heads (the `caption` option), with their captions and pointers filled in from the measures. Each part of the story then arrives whole, rather than all the frames, then all the pointers, then all the words.
5. **View the board after the first beat of evidence,** and fix its `issues` in place, so the beats after it don't repeat them.
6. **Reconcile before replying,** with the reconcile read in writing.md, which reads the board back and checks the answer last. Then view again.
7. **Reply briefly:** the answer, the recommendation, what wasn't checked, and anything you want the person to decide.

## References

Kinds (read one with measuring.md):
- `references/palette-change.md` (18k): a proposed colour across screens, as close to a finished board as a method gets. It covers the question, what the value's role decides, the evidence in order, how to make and measure the proposed side, ranking and tiers, every beat's plates, captions, pointers, risks, options and steps, and a "what great looks like" check.
- `references/dark-mode.md` (9k): whether a theme holds up, or a new theme: how it switches, token pairs, text contrast, light leaks and their causes.
- `references/type-scale.md` (8k): type consistency, or a new scale or font.
- `references/spacing.md` (6k): spacing, radius, density and alignment, or a new value for one of them.
- `references/consistency.md` (6k): one component or pattern across screens: the census, the yardstick and variants.
- `references/accessibility.md` (6k): contrast, text size, focus, target size and names.
- `references/general-review.md` (6k): a review across screens against a stated lens, window sizes and content included.

Shared:
- `references/measuring.md` (19k): tested page code for token values and which source wins, contrast and the text census, the component census, describing a colour, and counts in code.
- `references/pixels.md` (10k): visible-pixel share, for a surface or light patches, measured before any frame is placed.
- `references/board-anatomy.md` (16k): layers, sizes and text widths in the note kit, plates, the grid and the board's shape, the opening, beats, evidence rows, findings boards, risks and the decision.
- `references/writing.md` (7k): plain-language patterns with before and after, and the reconcile read.
