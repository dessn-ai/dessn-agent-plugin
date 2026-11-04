# Type audit: sizes, weights, fonts and a type scale

Use this when the question is about the product's type. That covers whether its sizes, weights, fonts and line heights are consistent (findings), or what a new type scale or font would look like across screens (a proposal). It is not for one component's label (consistency.md) or for text contrast (accessibility.md). The census code is in measuring.md, and the type-only checks are below.

Contents: The question · The yardstick · Evidence · A proposal · The specimen and its plate · The beats · Caveats · Done when

## The question

For findings: "Is Acme's type consistent?" For example: "Mostly. 88% of the text we measured uses the scale's seven sizes. The other 12% is in five sizes the scale doesn't define, and most of it is in settings tables."

For a proposal: "Would a tighter type scale make Acme easier to scan?" Answer yes or no, then say what changes, where you'd notice it, and what doesn't change.

Stats that work here:
- the share of text characters on the scale;
- the number of distinct sizes found, against the scale's steps;
- body text's characters per line, against a comfortable 45–75.

The opening's value image is the type in a frame, a real screen or the specimen (The specimen and its plate), with its plate beside it: each role's size, weight and line height, and the off-scale sizes listed in grey, as numbers. For a proposal, frame today's type and the proposed type side by side.

## The yardstick

The yardstick is the scale the code defines: font-size, line-height and weight tokens, the Tailwind or theme config, and the font families with their loaded weights. Read them first, and list each role: display, page title, section head, body, label, caption. Without a scale, the most common sizes are the norm, and say so.

## Evidence

- **Text census.** Run `TEXT` (measuring.md) on every screen with `{ by: 'type', limit: 200 }`, so every size comes back, rare ones included, with its weight, family, line height and characters. Merge the screens in the program and mark each size on or off the scale. Off-scale text in a few repeated places points to one component, so find it in code. The census covers the first screenful unless you pass `viewportOnly: false`; say which in the footnote.
- **Fonts actually rendered.** A family the CSS asks for isn't always the one that loaded. If the sandbox lacks a font file, the frames show a fallback. Check before judging letterforms:

```js
const FONTS = String.raw`() => ({ loaded: [...document.fonts].filter(f => f.status === 'loaded').map(f => f.family + ' ' + f.weight + ' ' + f.style),
  asked: [...new Set([...document.querySelectorAll('h1, h2, h3, p, button, label, td, li, a')].map(el => getComputedStyle(el).fontFamily))] })`
```

- **Line length.** Measure characters per line for body text; 45–75 reads comfortably:

```js
const LINES = String.raw`() => [...document.querySelectorAll('p, li, dd, td')].map(el => {
  const s = getComputedStyle(el), r = el.getBoundingClientRect(), lh = parseFloat(s.lineHeight) || parseFloat(s.fontSize) * 1.2
  const lines = Math.max(1, Math.round(r.height / lh)), text = el.textContent.trim()
  return { perLine: Math.round(text.length / lines), lines, size: s.fontSize, text: text.slice(0, 40) }
}).filter(row => row.lines > 1 && row.text)`
```

- **Hierarchy per screen.** On each screen, check that the page title, section heads and body step down clearly. Two heads one step apart read as one level.
- **Weights.** A weight the font doesn't have renders as the nearest one it does, so a 500 can look identical to a 400 or a 600. Check the loaded faces before calling two weights different.
- **Fonts and line heights.** The census rows carry both. Count the families in use and the line heights per size: one size set at two line heights is a finding.

## A proposal

Build, measure, then place, as palette-change.md's "Making the proposed side" does. Clone one frame of today's build (the specimen's frame, if the board uses one: The specimen and its plate) and edit the scale tokens or the font in the clone, the way it would ship. Measure every route on both builds (`sweep(frameId, routes, fn)`, measuring.md), then place the pairs in rank order with explodeState at each route. Load the new font the way the app loads fonts. If it can't load in the sandbox, say so on the board and don't judge its letterforms. Rank the pairs by how much text changes size (the census, before and after), or by where the most-read text is.

## The specimen and its plate

For type, the evidence is a frame and the plate is the values note beside it. A note sets its text in the canvas's font: the note tools refuse `@font-face`, and the product's font isn't loaded on the board under its own name, so a sample line in a note shows the wrong typeface and misrepresents the product. The plate gives the values as text, in small print: each role's family, size, line height, weight and class or token name, with any off-scale sizes listed in grey.

Show the type in a frame, in one of two ways:
- **A real screen** where the roles are used, with a pointer on each role its caption names. It is the strongest evidence, because it is the product as people see it.
- **A specimen page,** when no one screen shows the whole scale: a route that sets one line of real copy per role with the product's own type classes, tokens or text components. Name its frame and caption as a specimen ("Type specimen, built for this board"), so nobody takes it for a product screen.

A specimen page is only evidence if it renders in the product's real fonts, and it shouldn't change today's build:
- **Build it in a clone.** Clone one frame of today's build (cloneFrame, as in A proposal), add the route in the clone the way the app adds routes (dessn-mocks), and frame that route from the clone.
- **Mount it inside the app's normal layout and providers.** Fonts are often loaded by a root or group layout, so a route mounted outside it renders a fallback.
- **Check the fonts before framing it.** Run `FONTS` (Evidence) on the specimen route. If the product's family didn't load, say so on the board rather than showing the specimen: a fallback in a frame labelled as the product's type misleads more than a missing specimen.

For a proposal, add the specimen route before making the proposed build, then clone the proposed build from the specimen's frame (or add the same route to both builds), so the two specimens differ only in type. Frame them side by side. A new font's letterforms are judged in the proposed frames, which load it the way the app does.

## The beats

- **1 Today.** The scale as defined, as its frame with the values plate beside it, and the census summary: the share on scale, and the sizes in use.
- **2 What we found, or the change.** For findings: off-scale sizes grouped by cause (a component, one-off styles, a second library), each with a count and file:line. For a proposal: the new scale beside the old, what each role becomes, and what stays.
- **3 How it looks.** Frames ranked by the share of off-scale text, or pairs ranked by the share of text that changes. Put pointers on the text the caption names.
- **4 What to watch out for.** Fonts that didn't load, weights that don't exist, line lengths the change pushes past 75, and truncation where larger text meets fixed widths.
- **5 What we recommend.** Options from smallest to largest: map the strays onto the scale, add a missing step, or adopt the new scale. Give each its count.

## Caveats

- **Say when a frame shows a stand-in font.** A board once compared a stand-in serif without saying so.
- **Check each claim against every frame.** "Serif titles on every page" sat above a screen whose title was sans.
- **Sizes in rem follow the root size.** Compare computed pixels, and name the root size if it isn't 16.

## Done when

- The scale is shown in a frame (a real screen or a specimen page), its values on a plate beside it, and every claim about it is measured in characters of real text.
- The fonts that actually rendered are named, and any stand-in is disclosed.
- Every off-scale group has a count and a source.
- A proposal's pairs come from one build and differ only in type.
