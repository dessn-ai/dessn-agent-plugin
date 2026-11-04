# Accessibility audit: contrast, text size, focus, targets and names

Use this when accessibility is the question itself: text and control contrast, readable text size, visible keyboard focus, target size, and controls without a name. It is not for the contrast guardrail inside a colour proposal, which palette-change.md covers. The text census is in measuring.md, and the checks only this audit needs are below.

Contents: The question · Evidence · Ranking and tiers · The beats · Caveats · Done when

## The question

Frame the question the way the reader would ask it: "Can everyone read and use Acme?" or "Does Acme meet WCAG AA?" The answer gives the count first, then the worst case, then the one fix that clears most. For example: "Not yet. 14% of the text we measured is below the minimum contrast, most of it one grey used for helper text. Keyboard focus is invisible on 3 of 9 screens."

Stats that work here:
- the share of text characters below their minimum;
- the worst contrast, against 4.5 : 1;
- the number of screens where focus doesn't show.

The opening's value image is the worst failing pair as values: a chip of the text colour on its real background, with its ratio and the minimum beside it. The text itself shows in its frame, since a note can't set it in the product's font.

When the scope is one screen ("audit contrast on our dashboard"), its states, tabs and regions are the scope list, and the ranking unit is the cause or the region.

## Evidence

- **Text contrast.** Run `TEXT` (measuring.md) on every screen. The minimums are:
  - 4.5 : 1 for body text;
  - 3 : 1 for large text (24 px, or 18.66 px at weight 700);
  - 7 : 1 for AAA.

  Disabled text is exempt. Placeholder text is not.
- **Non-text contrast.** Borders of inputs, icons that carry meaning, and focus rings need 3 : 1 against what's next to them. Resolve their colours with `TOKENS`, and compute the ratio with the same formula.
- **Text size.** List text under 12 px from the census rows, with where it appears. 12 px is a readability convention, not a WCAG rule, so call it one.
- **Focus.** Press Tab through each screen and read where focus lands and whether it shows. An element with no outline and no shadow while focused probably shows nothing. Confirm with a picture before you say so.

```js
const FOCUS = String.raw`() => {
  const el = document.activeElement
  if (!el || el === document.body) return null
  const s = getComputedStyle(el), r = el.getBoundingClientRect()
  return { tag: el.tagName.toLowerCase(), text: (el.innerText || el.getAttribute('aria-label') || '').trim().slice(0, 40), rect: [r.x, r.y, r.width, r.height].map(Math.round),
    outline: s.outlineStyle !== 'none' && parseFloat(s.outlineWidth) > 0 ? s.outlineWidth + ' ' + s.outlineStyle + ' ' + s.outlineColor : null, shadow: s.boxShadow !== 'none' ? s.boxShadow : null }
}`

const tab = async page => {
  await page.send({ method: 'Input.dispatchKeyEvent', params: { type: 'keyDown', key: 'Tab', code: 'Tab', windowsVirtualKeyCode: 9 } })
  await page.send({ method: 'Input.dispatchKeyEvent', params: { type: 'keyUp', key: 'Tab', code: 'Tab', windowsVirtualKeyCode: 9 } })
  return run(page, FOCUS)
}
const stops = []
for (let i = 0; i < 25; i++) stops.push(await tab(page))
return stops
```

- **Target size.** Run `CENSUS` (measuring.md) on interactive elements (`button, a[href], [role=button], input, select`), with `props: ['width', 'height']`. A target under 24 × 24 px fails WCAG 2.2 AA (2.5.8) unless an exception applies. The main ones: a 24 px circle centred on it overlaps no other target (enough space around it), it sits inline in text, an equivalent control elsewhere meets the size, or the browser draws it. Check the space around each small target before calling it a fail. 44 is the comfortable size for touch.
- **Names.** These are controls that a screen reader can't name, because they have no text, no label and no aria name. Most are icon-only buttons.

```js
const UNNAMED = String.raw`() => [...document.querySelectorAll('button, a[href], [role=button], [role=link], input:not([type=hidden]), select, textarea')]
  .filter(el => { const r = el.getBoundingClientRect(); return r.width > 0 && r.height > 0 })
  .filter(el => !((el.innerText || '').trim() || el.getAttribute('aria-label') || el.getAttribute('aria-labelledby') || el.title || (el.labels && el.labels.length) || el.getAttribute('alt') || el.querySelector('img[alt]:not([alt=""]), svg title')))
  .map(el => { const r = el.getBoundingClientRect(); return { tag: el.tagName.toLowerCase(), cls: String(el.getAttribute('class') || '').slice(0, 60), rect: [r.x, r.y, r.width, r.height].map(Math.round) } })`
```

## Ranking and tiers

Rank screens by the share of text characters that fail. Give focus and target failures their own columns, not a mixed score. Name tiers by what the reader risks: "Hard to read for many people", "Hard to use without a mouse", "Holds up".

## The beats

- **1 Today.** The colours that carry text, as a plate. Show each text colour as a chip on the backgrounds it sits on, with the ratio in small print and the verdict in words. The text itself shows in the frames.
- **2 What we found.** The failures, grouped by cause: one grey token, a component's focus style, icon-only buttons. Give each its count and source.
- **3 How it looks.** Frames ranked by failing share, with pointers on each failing text, each invisible focus and each small target the caption names. A focus state is a state frame: tab to the element, take a state, and make a frame of it. If the frame doesn't hold focus, say so.
- **4 What to watch out for.** What automated checks can't see: reading order, motion, captions, and the quality of screen-reader labels. Also note text over images, which the census can't measure.
- **5 What we recommend.** Fixes ordered by how many failures each clears, with the token or component to change: "Darken the helper-text grey to about #6B6B6B: clears 11 of 14 failures."

## Caveats

- **Truncate ratios, never round them up.** 4.499 is a fail.
- **Composite translucent colours first.** Text at 60% opacity is a different colour from its token.
- **Existing failures are the finding here,** not something to hedge.

## Done when

- Every screen in scope has a failing share, and the worst screen is framed.
- Each failure group has a cause, a count and a fix, and the fixes are ordered by what they clear.
- Focus, targets and names are checked, or listed under "What we didn't check".
