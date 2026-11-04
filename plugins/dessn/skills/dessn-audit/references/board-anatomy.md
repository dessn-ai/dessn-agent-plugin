# Board anatomy: how an audit board is laid out

Use this when you place the board. It covers the layers, the size each role takes, plates, the grid, the opening, a beat, the evidence rows, risks and the decision, for proposals and for findings. The kind file says what goes in each beat for your kind of audit, and writing.md says how to word it.

Contents: Two layers · Sizes · Plates · The grid · The opening · A beat · Evidence rows · Findings boards · Risks · The decision · Before you reply

## Two layers

- **Annotation layer: your voice.** It uses the canvas's sans, ink and grey, with hairline rules. It has no fills, tints, shadows or rounded boxes. Emphasis comes from ink, used in three places: a box with a line of about 4 px around the recommendation and around the recommended option, and the first risk's top rule. The recommended option's "Recommended" label may be an outlined pill, the board's one rounded shape.
- **Amber means pointing,** and nothing else. It marks three things: the point tool's lines, a line from a "Where to look" note to the element it names, and the legend's key for them.
- **Product layer: the evidence.** Frames are the product's UI and type, running its code. Plates are the product's values (chips, ramps, bars, and type values written as text: family, size, line height, weight, token name) on a white panel, in its variables (Plates).
- **Keep the two apart.** A plate reads as evidence by its white panel and the product's colours. Its words are in the canvas's sans, like every note's, because a note can't load the product's font.

## Sizes

The note kit sets most roles. Use its classes, so every role keeps one size across the board. The middle sizes the kit lacks take an inline size. Use two weights, 400 and 600.

| Role | Size | Write it as |
|---|---|---|
| Board title: the question | 280, one line | `.title` |
| Title lede | 72, grey, two or three lines | `<p class="muted" style="font-size:72px;max-width:36em">` |
| Beat head: grey numeral and name | 200 | `.beat`, numeral in a `.num` |
| Key number | 176, over a 48 grey yardstick | `.stat`, then `p.muted` |
| Recommendation headline | about 144 | `.claim` with `font-size:144px`, in the boxed note |
| Tier head: name, then range in grey | 128, range 72 on the same line | `<h2 style="font-size:128px">Most noticeable <span class="num" style="font-size:72px;white-space:nowrap;margin-left:24px">About half the screen</span></h2>` |
| Beat claim | 112 | `.claim`, in a note about 2,600 wide so it wraps |
| Caption head, plate title, section head | 96, grey index, measure at 64 | `h2` with a `.num` index and a trailing `.num` |
| Short answer | 84 | `.answer` |
| Risk headline, index head | 72 | `<h3 style="font-size:72px">` |
| Option title, step head | 64 | `h3` |
| Beat explainer, tier sentence, caption sentence | 56, softer ink | `.lede` |
| Body | 48 | `p` |
| Kicker, label, source, footnote | 40, grey | `small`, with tokens and paths in `code` |

The stat's yardstick is a 48 grey `p.muted` rather than the kit's 40 `<small>`, on purpose: it has to read at fit beside a 176 number.

**Text widths.** The kit caps each line at about 70 characters (`p` at about 1,630 px, `.lede` 1,790, `.answer` 2,860, a loose `small` 1,600), because a longer line is hard to follow back to its start when someone zooms in to read it. Keep the cap, and make each note as wide as its text. When a note has to be wider, such as the short answer above a row of three stats, give the width to columns (a grid of two or three, 120 apart) or leave the text in its left part, rather than lifting the cap to fill it.

At fit, a whole audit board shows at about 0.05–0.1 zoom. The title, beat names and big numbers read there, and claims and captions read from about 0.1. When a note is short of room, cut words or widen the note rather than shrink the type.

## Plates

A plate shows the product's values on a white panel, coloured with the product's own variables, so a swatch can't drift from the token file. The white is itself a value (the product's surface), which is why a plate may have a fill when other notes don't. It holds values only: chips, ramps, bars and type values written as text (family, size, line height, weight, token name), never a rebuilt component or a type sample.

Name a chip by its colour and role ("White card surface", "Divider") rather than drawing a small piece of interface. A labelled "Hover row" block or a blue "Rest" button reads as a fake component beside real frames, and a state belongs in a frame. A plate whose rows are only words is a note, so set it as one. Set a plate's own words on the board's ladder (title 96, subtitle 56, rows 48, labels and footnote 40), so it reads as part of the same board.

Each plate has three parts:
- a title that is a claim, with its source (a file or a token) at the right;
- a subtitle that states the whole result;
- a footnote at the end that defines its verdict words and its method.

Scope the variables to classes with prefixed names, because a note's :root is the canvas. Declare the primitives and the aliases together on both classes. The proposed class re-declares only the changed primitive, on the same element. An alias resolves where it is declared, so overriding the primitive on a child changes nothing.

```html
<style>
.now, .new { --p-grey-50: #F4F4F4; --p-grey-200: #DEDEDE; --p-surface-low: var(--p-grey-50); --p-border: var(--p-grey-200) }
.new { --p-grey-50: #F6F4F0 }
.chip { height: 300px; border: 3px solid var(--p-border); background: var(--p-surface-low) }
</style>
<div class="now"><div class="chip"></div></div>
<div class="new"><div class="chip"></div></div>
```

Set near-white chips on the surface they live on, with a border in the product's border colour: on the canvas grey, a light-grey chip vanishes. Put dark chips on the product's dark surface.

Show type in frames, never as a sample on a plate. A note can't load a font (the note tools refuse `@font-face`), and the product's font isn't loaded on the board under its own name, so a sample in a note shows the canvas's font or a fallback and misrepresents the product. A plate may give the family, size, line height, weight and class or token name as text. To show how text looks, frame a real page where it's used, or a specimen page built from the product's own type styles in a clone of today's build and named as one (type-scale.md, "The specimen and its plate").

## The grid

- **Columns.** A spine column on the left, about 2,600 wide, holds each beat's head. To its right sit two content columns, each one pair wide (1,440 + 120 + 1,440 = 3,000), about 520 apart. A wide note spans both (6,520). More evidence wraps into the next row rather than adding a third column.
- **Between beats.** Leave about 900 of space, with a hairline across its middle as wide as the beats' column, so beats read as chapters.
- **Inside a beat.** A tier head sits about 400 above its frames, which leaves room for the frame labels. Captions go about 90 below the frames, and about 480 separates one row's captions from the next tier head.
- **Notes.** Make every note `h: 'auto'`, so it is exactly as tall as its content. Notes in a row start level, and a top rule, where the row has one, makes them read as a row; their bottoms can differ. A box or plate hugs its content (in a grid, `align-items:start`), because an outline or a white panel around empty space reads as something missing.
- **Room.** Plan each group's room before you place it: the title and opening, beat heads, captions and pointer notes. The title and the opening under it take about 3,400, because the answer wraps at the kit's measure, so the first beat's hairline goes about 3,850 down. Then the board doesn't jump when the answer arrives. Measure the opening's notes (`measureHtml`) before you place them, and if they come out taller than their room, cut words rather than move the beats.
- **Shape.** This grid is a default, and the shape is your call. Two principles guide it. First, keep each beat's evidence close to its claim, about two panels across beside or under its head. Second, lay the beats out like a page: in rows read left to right, then down, numbered in that order. The numbers then only move forward, and the reader never jumps back up to find the next beat. Beats that run down one column and back up another break this: the reader finishes 3 at the bottom and has to climb to find 4. Two beats can share a row, each about half the width. A beat whose evidence needs the width, such as the pairs, spans a full row, and so can the opening. Aim for about the shape of a screen, 1 to 1.6 wide for each 1 tall. Long, sparse rows make the reader pan from a head to its evidence, and a thin strip of beats stacked in one column shrinks everything at fit. Journeys and flows can run wide, because left to right is their story. A compact board that reads at a larger zoom beats a wide one that doesn't.

## The opening

**The title note.** An eyebrow ("Acme · Colour proposal") in small grey. The question at 280, on one line. The title lede says why it's asked and what you looked at.

**The opening under the title**, about 160 below it, keeps to the spine and the two content columns:
1. **The change or finding in context,** in the spine column. The kind file says what goes here, such as a swatch with its neighbours, the worst case, or for type the specimen's frame. Add one grey line saying what to see.
2. **The short answer,** two columns wide, beside it. A "The short answer" kicker, then `.answer` at the kit's measure, in the note's left part. Under it, two or three stats in a row across the note, each with a hairline on its left and the number over its yardstick sentence.
3. **The recommendation,** one column under the answer, boxed in ink. It holds the kicker "Our recommendation", the headline and one body line. When one check or fix comes before everything else, add a hairline, then "Check one thing first" (or "Fix first") and a sentence ending with the step that does it.
4. **How to read this board,** one column, beside the recommendation. A row per thing, each with its key on the left:
   - the frames: for a proposal, "today on the left, proposed on the right"; for findings, "worst first", or "light on the left, dark on the right". Say they are the only place the product's interface and type appear, and nothing on the board redraws them;
   - the amber lines end on the exact spot, and their note names it. Draw the key as the line itself, e.g. `<span style="display:inline-block;width:200px;height:6px;background-color:var(--brand-amber)"></span>`;
   - white panels show the product's values, in its own colours and variables.

## A beat

The spine note holds, from the top:
1. The `.beat`: a grey numeral and the name.
2. About 72 below, the `.claim`.
3. About 48 below that, a `.lede` explainer of two to four plain sentences. Instructions for reading the evidence go here, never in the claim.

The beat's evidence sits in the content columns to the right, starting at the same top, at most about two panels across. Further evidence wraps into rows beneath, so it stays close to the claim it proves. A beat that spans a full row (Shape) can run its evidence wider, in rows beside or under its head. Beats take single numerals and pages take two digits, so they never collide.

## Evidence rows

- **Tier head.** A hairline, then the name and its range on one baseline (the Sizes table), then one `.lede` sentence on what the evidence in this tier has in common. It spans the content columns.
- **Pairs.** Today on the left, proposed on the right, 120 apart, about two pairs to a row. Name the first frame by its index and a short page name that fits over it at fit, about ten characters ("03 Editor"), and the second by what differs ("03 new", "03 dark"). A frame label is the largest text over the frames at fit, so it should say which page it is, and a long one is cut off.
- **Caption.** Use the `caption` option on the pair's first frame. It has three parts:
  - a head line: index, name and measure;
  - one or two sentences on what changes and what stays, with a yardstick;
  - a source line, `token · file:line`, with each segment unbroken.
- **Pointers.** Point at the element each caption names, one pointer per spot, on every frame whose caption names one. Give its name in plain words; the token is what someone would copy. The band under the pair's second frame is theirs.
- **Where to look.** When a change is spread out, put a note in a free slot of the tier, beside the pair it points into, that says where the eye should go ("where the warm grey meets the white fields"). Refer to other pairs by number. It may draw one amber line of its own to the element it names in the pair's proposed frame. Centre the note on that element's height (the frame's top plus the element's box from the measure) so the line runs straight across the gutter, check the selector with `f.findElement`, then connect them:

```js
await canvas.connect({ pageId, from: lookNote.id, to: { id: frameId, element: 'span:text-is("Submitted")' }, color: 'amber', heads: 'none', line: 'straight' })
```

- **Index.** When the pages are ranked, list every page under the beat's spine note in rank order, grouped by tier, under a 72 head: index, name, a bar and the measure. Add one sentence of method, and one line of small print for agreement, remainder and scope. When they aren't, skip it: the captions already name each page.

## Findings boards

A findings board ranks instances by severity instead of pairing today with proposed. The frames are:
- single frames, worst first, each one frame wide (1,440) with about 700 between, so pointer notes fit beside the captions, and each named by its index and page ("03 Reports"). Wrap them into rows about as wide as two pairs, so the worst stay near the beat's head; or
- pairs of the same route that differ in one thing, such as light and dark, laid out as proposal pairs.

The legend describes the frames the board has. The recommendation's second part is "Fix first" and the fix that clears the most, or nothing when no fix comes first. A caption head carries the ranked measure ("03 Reports 16% of text too faint"). Put a pointer on each instance the caption names. With single frames, the gutter to a frame's right (`side: 'right'`) is the usual place for its notes.

## Risks

Place the risk notes in the content columns, two to a row, starting level under their top rules. Each risk note has:
- a rule on top: ink for the first and biggest risk, hairline for the rest;
- a kicker naming the action (Check first, Fix alongside, Tidy up, Check after shipping, or What we didn't check), in ink for the first risk and grey for the rest;
- a 72 headline that claims the risk;
- a body covering what, why, the consequence, and how this board could mislead, at the kit's measure;
- the source, in small print.

"What this board doesn't prove" comes last, two columns wide, about 200 below the risk rows, its items in two columns or a short list at the kit's measure.

## The decision

- **Options,** two columns wide. A head ("Three ways to go, from smallest to largest"), then one column per option: its letter, a title, a body with its cost, and its scope in small print. Box the recommended option in ink and label it "Recommended".
- **The ask,** under a rule. The kicker "What we need from you", then the ask in one line at the answer's size, weight 600.
- **Next steps,** two columns wide. Each step has a grey number, an `h3` head that starts with a verb, one body sentence, and its detail in small print: a console line with what each result means, a diff, or file:line.

## Before you reply

View the board at fit, then view a region. At fit, the question, the answer, the beat names and the numbers should read, and every frame should agree with its caption. Fix `issues` in place: re-place pointers rather than delete them. Then run the reconcile read in writing.md.
