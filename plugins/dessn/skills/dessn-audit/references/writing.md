# Writing an audit board

Use this when you write the title, the short answer, the heads, captions, risks and steps. Write for someone who decides and wasn't in the chat: a founder, a designer, an engineer lead. Write as a designer explaining the work to them: what they'll see first, then why it matters. Each pattern below has a before and an after.

Contents: The title and the answer · Heads carry the argument · Plain words · Numbers · Caveats and hedges · Options and steps · The reconcile read

## The title and the answer

**Ask the reader's question, in the product's name.** Use third person, and keep the hex out.
- Before: "What if our grey were #F4F3EF?"
- After: "Should Acme's lightest grey be a little warmer?"

**Answer first, then what they'll see, then what doesn't change.** Keep the mechanism out of the answer.
- Before: "One primitive changes and six semantic tokens follow it, so every light-mode page fill, hover and selected state warms a little (ΔE 0.005). Text contrast holds."
- After: "Yes, with one check first. The light grey used for backgrounds, panels and hover states would turn slightly warmer. You'll mostly notice it where it meets white cards, dividers and borders, which don't change. Text stays just as readable."

**The answer says yes, no or mostly.** "A quiet shift that softens the product" never answers.

## Heads carry the argument

**A head is a claim the evidence under it proves, not a label.**
- Before: "Breaks / Off / Holds"
- After: "Text is hard to read on three pages" / "Two pages keep bright light-mode panels" / "Five pages read well in dark"

**Size the claim to its evidence.**
- Before: "4 What to watch out for. A few places could keep the old grey."
- After: "4 What to watch out for. One check decides whether the change takes effect at all, and a few smaller spots need care."

**A head claims only what's under it.** Check it against its own table.
- Before: "One shared button, four sizes, one corner." (It sat above a table with corners of 6 and 8.)
- After: "One shared button, in four sizes and two corner radii."

**Name tiers by what the reader sees,** with the measure beside the name: "Most noticeable · about half the page or more", not "Tier 1 · >40%".

## Plain words

Put the plain word in the sentence, and the code name in small print, unless the name is the subject.

| In the sentence | In small print |
|---|---|
| named colours | semantic tokens |
| the colour file | tokens.css |
| the shared UI library | the package name and version |
| written straight into the code | hard-coded |
| loading placeholders | skeletons |
| side menu | side nav |
| main button | CTA, primary |
| a touch lighter and slightly yellow | +0.003 L, hue 91° |
| warmth (defined in a footnote) | OKLCH chroma |

- Use one idea per sentence, in full sentences. Before: "Warmer and a touch lighter; contrast holds." After: "The new grey is a touch lighter and slightly warmer. Text on it stays just as readable."
- Leave out metaphors. "Does most of the quiet work" makes the reader decode it. Say what it does.
- Leave out shorthand such as asChild, 12 / 500 and H1–H5. Write "a 12-pixel label in medium weight" instead.

## Numbers

**Every number needs a yardstick the reader already knows.**
- Before: "1,117 places in code"
- After: "1,127 lines in 434 files use this grey, through six named colours"
- Before: "4.58 : 1"
- After: "4.58 : 1. 4.5 : 1 is the minimum for readable text, so it still passes."

**Give a verdict word with the number beside it,** and define the verdict in a footnote: "Passes, just (4.58 : 1)", "Too faint, before and after", "A little softer".

**Show the denominator on the board.**
- Before: "4 of 122 buttons are off-size"
- After: "4 of the 122 buttons we measured on 12 pages are off-size. The 122 include nav tabs and list rows."

**Rank on one measure.** A page ranked by failing text can't be headlined by its bright area.

## Caveats and hedges

**Put each caveat beside its claim.** A limit stated only in the chat reply isn't on the board.
- After: "The percentages cover the first screenful of these ten pages only."

**Calibrate hedges, and pair each one with its test.** "The shared library probably wins, because it loads after the app's file. Step 1 in section 5 shows how to check."

**An absolute needs a search.**
- Before: "Dark mode doesn't use this grey."
- After: "Dark mode stays the same, apart from a few buttons locked to light mode (section 4)."

**Say each conclusion once, then point back to it:** "covered in section 4". Put the method once under the index, not in every caption.

## Options and steps

**Order options from smallest to largest, and give each its cost.**
- Before: "C · A brand call, not a token fix."
- After: "C · Warm the whole grey scale. That includes the text colours, so text contrast would need checking again. It's a brand decision rather than a colour fix." The exact scope goes in small print.

**State the ask as one line someone can say yes to:** "A yes on option A. Then step 1 runs before any code changes."

**Start steps with a verb, and make them runnable without the chat.** Each gives what to run and what each result means: "Check which colour file wins. Run this in the browser console. `#F4F4F4` means the library still sets it; change it there too."

## The reconcile read

Before replying, read the board as text, from the board itself rather than from memory: every note's words (`htmlNodes`, then `readHtml` for each, reduced to their text in the program) and every frame's name (`listNodes`). A sentence written early goes stale when a later program adds a frame or changes a count, and your memory of it keeps the old version. Then:
1. **Read the heads alone,** top to bottom. They should tell the story, and each should be a claim.
2. **Check each head against what's under it.** The count, the table and the frame must agree with it.
3. **Check every number in the opening** against the beat it comes from.
4. **Check every reference.** "The first three" must match how the options are lettered, and "section 4" must be section 4.
5. **Check the scope list.** Every item on it is framed, or listed under "What we didn't check".
6. **Check the recommendation.** The recommendation box, the options and the steps must say the same thing. Read the answer against them last, and change whichever is wrong, so the opening can't disagree with them.
7. **Check names and small words.** Each page keeps one name everywhere: frame, caption, index, stats and reply. Counts written as words ("ten pages", "three places") match what is on the board, and no tool words or leftover markup show (a stray `rg`, a `</code>` in the text).
