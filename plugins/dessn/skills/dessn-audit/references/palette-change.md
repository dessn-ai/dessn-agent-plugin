# Palette change: a new colour across the product

Use this for a proposed new value of a colour or colour token, shown as today beside proposed across the product's screens. Examples: a warmer grey, a darker accent blue, a softer border, a new brand palette. It is not for whether an existing theme holds up (dark-mode.md), or for contrast as the question itself (accessibility.md). Read board-anatomy.md and writing.md together in the program that makes the proposed build, with pixels.md when the value paints a surface, whose share of the screen is then the measure; the three fit in one read.

Contents: The question and the opening · What the value does decides its checks · Evidence, in order · Making the proposed side · Screens, ranking and tiers · The beats · What great looks like

Most examples come from one board about a warmer light grey, and a few imagine a darker accent blue. Their words and numbers show the pattern. Write yours from this product's evidence.

## The question and the opening

A palette ask is a yes-or-no decision, so title it as one, in the product's name, with no hex: "Should Acme's lightest grey be a little warmer?" or "Should Acme's links and buttons be a darker blue?" The lede says why it's asked and what you compared ("…where that grey is used today, and how ten screens would look with the new one").

Write the short answer in this order:
1. **The verdict and its condition:** "Yes, with one check first."
2. **What changes, in plain roles:** "The light grey used for backgrounds, panels and hover states would turn slightly warmer."
3. **Where you'd notice it:** "…mostly where it meets white cards, dividers and borders, which don't change."
4. **The guardrail:** "Text stays just as readable."
5. **Any exception the evidence found, by section:** "Dark mode stays the same, apart from a few buttons covered in section 4." Leave this out when there is none.

Give three numbers, one for each job, each over a sentence that works as its yardstick:
- **Magnitude:** the most a screen shows the change. "64% of the editor is this grey. No other screen we compared has more." For a fill, text or links, count the elements or characters instead.
- **Guardrail:** the tightest contrast the change touches. "4.58 : 1 for the mid-grey text. 4.5 : 1 is the minimum, so it still passes."
- **Risk:** the places that won't follow, or the reach if nothing escapes. "1 place has the old grey written straight into the code, so it won't change with the rest."

The opening image shows the change where it lives, as values. For a surface, show old and new as two panels filled with the value, each holding chips of the colours it meets most, labelled in plain words, with name and hex in small print. For a fill, text or line colour, show old and new as chips on the surfaces they sit on; the text itself shows in the frames. A near-neutral shift is invisible on its own and readable beside its neighbours.

The recommendation is its own boxed note. When one check decides whether the change works, end the box with "Check one thing first" and the step that checks it.

## What the value does decides its checks

The reach table (evidence step 3) says what the value is used for. Most values do several things, so run every row that applies:
- **A surface** (page, panel, canvas, hover fill). Rank by visible-pixel share. Show its edges against what it meets, and check the text on it.
- **A fill behind text** (buttons, badges, selected chips). Count the elements that carry it (`CENSUS` with `background-color`), and check each label on it: 4.5 : 1, or 3 : 1 for large text. Resolve its hover, pressed, focus and disabled shades too. A new base colour that lands on or next to its own unchanged hover shade (ΔE under about 0.01) makes hover invisible. Show the states that carry the risk as evidence step 8 says: in frames where they hold, as chips of their shade where they don't, never as a drawn button. The fill needs 3 : 1 against what it sits on only when nothing else marks the control or its state. A labelled button is marked by its label, so a fill under 3 : 1 there is a softer edge rather than a fail, and the board says it in those words. A fill that alone shows a state, such as a selected chip or a toggle that is on, still needs 3 : 1.
- **Text, icons or links.** Check it against every surface it sits on (the `TEXT` rows in that colour). Check that links still stand apart from body text, with 3 : 1 between them or an underline. Rank by characters or elements, because thin text is few pixels.
- **Borders, focus rings and selected outlines.** These need 3 : 1 against the surfaces beside them. Decorative dividers are exempt; say which is which.
- **Tints and mixes** (`bg-primary/10`, `color-mix`, a translucent copy). They change too, but the pixel count doesn't see them. List them from the code count as "changes too, not in the pixel share".
- **Several values at once** (a new brand palette). Give one row per token, old to new, and rank screens by the combined share of every changed colour. Then run the rows above for each value.

## Evidence, in order

Run this as one research pass, reading code and pages in parallel. The code is in measuring.md.

1. **Where it's declared.** Find how the product writes tokens and the token's line, and every alias that resolves to it in each theme block. Read the ramp it sits in: every step, with its chroma when warmth or tint is the point. For example: "The ten lightest are pure neutral; only the two darkest lean warm."
2. **What actually paints.** Resolve the token in a frame. List the rules that declare it and which one wins. If a library or runtime injects its own copy after the app's file, editing the token file changes nothing, and that becomes the first risk.
3. **Where it's used.** Count lines and files per alias, by form, tints included. Show an alias with no uses and label it "not used by the app". Follow shared class constants one hop to the components they reach. This is the reach table: it says what the value does.
4. **Copies that won't follow, and the new value already there.** Look for the old value written straight into code, a spare alias holding the same value, and palette entries in a config. Search for the new value too, and for near matches in the palette configs. Say so if it already exists.
5. **Other themes.** Check whether each theme block remaps every alias. Then search for what escapes the remap: components forced into light, portals mounted outside the theme root, and hard-coded copies. "Dark mode is unaffected" is only true after that search.
6. **What it meets.** Take `meets` from the frames (usually a white surface, a divider and a border), and name each colour by its token and plain role. Edge contrast against each, old and new, is about 1.1 : 1 for near-whites. Report its direction in words ("a little softer", "a little crisper"), not pass or fail.
7. **What sits on it, and what it sits on.** Run the contrast checks its role calls for (the section above), old and new. Name any crossing. Colours that already fail are an existing issue that the change neither causes nor fixes.
8. **States no screenshot shows.** For each alias that serves hover, pressed, selected, open menus or loading placeholders, note whether a frame shows it. A resting element that shares the token is the nearest proof, such as a selected item that uses the hover colour. To show a state itself, force it in the page, take a state and make a frame of it. A frame keeps focus and what the markup holds (an open menu, a selection), but not a CSS hover or press, so check that it shows the state. Where it doesn't, the state is a chip of its shade, and the board says so.

## Making the proposed side

Both sides must come from the same code and data, differing only in the change. Otherwise pixel differences come from the data, and the shares can't be compared. Build, measure, then place:
1. **Make the change the way it would ship.** Clone one frame of today's build into a spot beside the planned grid, and edit the token line in the clone. Check that it took: the token resolves to the new value in the clone.
2. **Measure every route on both builds** before placing any pair: today's through the frame you cloned from, the proposal's through the clone. Use the measure the value's role calls for. For a surface, that is visible-pixel share (pixels.md, "Measuring before you place"), and the old colour's `remainder` near zero confirms the edit reached every screen. For text, links, icons or a small fill, it is the elements or characters that carry it and their contrast (measuring.md, sections 4 and 5), and the token resolving to the new value on each route confirms the edit. Rank.
3. **Place the pairs in rank order.** Make each frame with explodeState at its route, named by its rank and a short screen name ("02 Settings", then "02 new"), the pair's first frame with its caption head. The clone is itself one proposed screen: move it into its pair's slot and rename it with `updateNode` rather than making its route twice.

```js
const clone = await canvas.cloneFrame({ pageId, sourceFrameId: todayId, name: 'Proposed build', route: '/editor', position: { x: 18000, y: 0 } })
await clone.files.edit('src/styles/tokens.css', { oldString: '--grey-50: #F4F4F4;', newString: '--grey-50: #F6F4F0;' })
// …measure and rank (for this grey, pixels.md), then for each screen in rank order:
const today = await (await canvas.frame(todayId)).explodeState('/settings', { name: '02 Settings', position: { x: 6640, y: 9800 }, caption: '<h2><span class="num">02</span> Settings <span class="num">57%</span></h2>' })
await clone.explodeState('/settings', { name: '02 new', position: { rightOf: today.id, gap: 120, align: 'top' } })
```

- **If the edit doesn't take** because a runtime copy wins, that is your first finding. Preview with a stronger rule only to show the look. A preview rule that always wins can look better than the real ship, so say on the board, beside that risk, that the real app would look different until the copy is fixed.
- **Disclose the method, whatever it is,** in the legend or a risk. When you added preview-only code, removing it is a step in section 5.

## Screens, ranking and tiers

Pick screens from where the token paints in code, not from the nav. Take the largest painted areas (a page background, a canvas, an upload area), the menus and settings, and a few screens where it's only a detail. Cover every role the value plays and the top of the ranking. The rest go under "What we didn't check". One grey with wide reach needed ten pairs.

Rank by the measure the value's role calls for. For a surface, that is the share of each proposed frame that is exactly the new colour, in visible pixels rather than element boxes. Today's share of the old colour should agree with it within about half a point. Where the value paints text, links, icons or small fills, as most accents do, rank by the elements or characters that carry it; when it also fills a surface, rank by pixel share and give the count as a second column. When every screen shows the value the same way, such as one main button each, skip the ranking and the tiers: say so in the beat's claim, choose screens that cover each role the value plays, and give the room to its states and the text on it. Number screens 01, 02… in rank order, so the index is the rank, or in reading order when there is no ranking.

Break tiers at the big jumps in this product's data. Name each tier by how noticeable the change is, with the range from the data beside it. One board had "Most noticeable · about half the screen or more", "Noticeable in one area · about a sixth of the screen" and "Easy to miss · less than 4%". Give each tier head one sentence on what the colour is in those screens: "Here the grey is a large backdrop: the canvas, the page behind a form."

## The beats

**1 Today.** The claim says what the value does now: "One light grey fills Acme's backgrounds, hovers and selected menu items." Use two plates:
- **The ramp.** Show every step in one strip, with the changed step outlined and labelled ("This grey"), and the token and hex under each step in small print. Add a bracket over any group ("pure neutral", "slightly warm") and a sentence on what the step sits next to ("between white and the divider grey"). A footnote defines warmth as OKLCH chroma, and a source line ends it.
- **The reach.** Give one row per alias, by plain role ("Where you see it"). Each row has a chip, a few examples in words, and its lines of code as a bar with "N lines in M files". Add a total row, and a footnote on what was counted.

**2 The proposal.** The claim is the change and what it leaves alone: "Make that grey a little warmer, and leave everything else as it is." Its plates answer four questions, each under a head that is a claim written from this product's evidence:
- **Where does the change show?** An old/new swatch with its neighbours, then a table of edges: each neighbour against the value, today and new, with the verdict in words. Say so if the new value already exists in the code. The footnote gives the ratios, OKLCH and ΔE.
- **What changes that no screenshot shows?** Each state alias as a chip of its colour, marked "Not shown in the screenshots", with the nearest resting proxy by pair number. When a state carries the risk and a frame can hold it (evidence step 8), frame it instead and list it here by its frame's number.
- **What stays the same?** Neighbour chips, each with its plain role, token, hex and uses, plus a row for each other theme ("Dark mode: no change, except…").
- **Does what sits on it stay readable?** Each text colour as a chip named by its role ("Label text"), on the old and the new value, with the ratio in small print; the words themselves show in the pairs. Give the verdict in words: "Passes easily", "Passes, just. The minimum is 4.5.", "Too faint, before and after", "Exempt, because it's disabled".

On the grey board the heads read "The new grey shows where it meets other colours", "Hovers, menus and loading states change too", "Everything around the grey stays the same" and "Text stays just as readable". A darker accent might read "White labels on the main button get easier to read" and "Hover is now too close to the resting button".

**3 How it would look.** The claim says where the change shows most, for example "You'll notice it most on screens with large grey backgrounds". When the screens are ranked, an index of every screen goes under the beat head, grouped by tier. Each row is index · name · a bar · the measure. Add one sentence of method, and one line of small print saying how closely today and new agree and how much old colour remains. Unranked, skip the index, since the captions name each screen. Then give the pairs (today left, new right), under their tier heads when ranked, with captions and pointers.
- **Captions.** A caption reads "01 Editor 64%". Then one sentence with a yardstick: "The canvas is the grey, so about two-thirds of the screen warms." Then the token and file:line in small print.
- **Pointers.** Point at the element each caption names, on every proposed frame, including a whole backdrop ("Canvas"). A pair can go without one only when a "Where to look" note covers it, with its own line to the element or by pair number.
- **Where to look.** The eye should go where changed and unchanged colours meet, which is rarely one spot. Put a "Where to look" note in a free slot of the tier, beside the pair it points into (board-anatomy.md).

**4 What to watch out for.** Size the claim to the risk: "One check decides whether the change takes effect at all, and a few smaller spots need care." Write one note per risk:
- The kicker names the action: Check first, Fix alongside, Tidy up, Check after shipping, or What we didn't check.
- Then give a headline claim, and a plain body: what, why, the consequence, and how this board could mislead. End with the source in small print.
- Calibrate the hedges ("probably wins", "may cancel"), and pair each with a test someone can run.
- The last note is "What this board doesn't prove". It lists the states not captured and their nearest proxy, the themes not shown, and the preview method, and says "the percentages only cover these screens".

**5 What we recommend.** The options come from the evidence, ordered from smallest to largest, each costed from the usage counts. On the grey board they were: this value alone; it and its neighbours, so hovers and dividers keep their relationship ("touches at least N more lines, and the new colours still need picking"); and the whole ramp, a brand decision after which text contrast needs checking again.

Box the recommended option. Put the ask in one line: "A yes on option A. Then step 1 runs before any code changes." Start each step with a verb, and make it runnable without the chat. For example:
1. Check which source wins (when two declare it): a console line, and what each answer means.
2. Make the change: the diff.
3. Fix the copies that won't follow: file:line for each.
4. Remove any preview-only code.
5. Look at the states no screenshot shows, and at one screen in each other theme.

## What great looks like

Check with viewBoard before replying:
- A yes-or-no title in the reader's words, and an answer that opens with the verdict and its condition.
- Each opening number matches its beat and has a yardstick. The opening image shows old and new with what they meet or sit on.
- Today shows the whole ramp and the reach by plain role, with counts. The proposal covers where it shows, the unshown states, what stays (other themes too) and the contrast its role calls for.
- Every scope screen is framed or under "What we didn't check", and the top screen by the measure is on the board.
- Pairs are ranked by one measure, under tiers named by how noticeable the change is, and the remainder is reported once. Where the measure doesn't separate the screens, the board says so and covers each role instead.
- A pointer on every proposed frame, or a "Where to look" note that covers it.
- The main risk appears in the answer, the recommendation box, the risks and step 1, and the preview method is on the board.
- Options run smallest first with their costs, the ask is one line, and the steps run without the chat.
