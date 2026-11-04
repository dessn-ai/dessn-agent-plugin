# Spacing audit: spacing, radius, density and alignment

Use this when the question is about layout rhythm. That covers whether spacing, padding, corner radius and alignment follow the system (findings), or what a denser or roomier layout would look like (a proposal). It is not for one component's own padding (consistency.md) or for type sizes (type-scale.md). The census code is in measuring.md, and the spacing-only checks are below.

Contents: The question · The yardstick · Evidence · A proposal · The plate · The beats · Caveats · Done when

## The question

For findings: "Is Acme's spacing consistent?" For example: "Mostly. 81% of the gaps we measured are on the 4-pixel scale. The rest cluster in the settings forms, where fields sit 10 and 14 pixels apart."

For a proposal: "What would a more compact table look like?" Answer with how many more rows fit, what gets tighter, and what stays the same.

Stats that work here:
- the share of gaps on the scale;
- the number of distinct gap values found;
- for density: rows per screen before and after.

The opening's value image is the scale as bars with the off-scale values that occur most beside them in grey, or for a density proposal, rows per screen before and after.

## The yardstick

The yardstick is the spacing scale and radius scale the code defines: spacing tokens, the Tailwind or theme config, and layout components with fixed gaps. With a 4- or 8-pixel base, say which one. Without a scale, the most common values are the norm, and say so.

## Evidence

- **Gaps between stacked blocks,** counted by value:

```js
const GAPS = String.raw`({ within = 'main, [role=main], body' } = {}) => {
  const root = document.querySelector(within) || document.body, counts = new Map()
  const shown = el => { const r = el.getBoundingClientRect(), s = getComputedStyle(el); return r.width > 0 && r.height > 0 && s.visibility !== 'hidden' && s.position !== 'absolute' && s.position !== 'fixed' }
  for (const parent of [root, ...root.querySelectorAll('*')]) {
    const kids = [...parent.children].filter(shown)
    for (let i = 1; i < kids.length; i++) {
      const a = kids[i - 1].getBoundingClientRect(), b = kids[i].getBoundingClientRect()
      if (b.top < a.bottom - 1 || Math.abs(a.left - b.left) > 2) continue
      const gap = Math.round(b.top - a.bottom), row = counts.get(gap) || { gap, count: 0, example: null }
      row.count++; if (!row.example) row.example = (kids[i].innerText || '').trim().slice(0, 40); counts.set(gap, row)
    }
  }
  return [...counts.values()].sort((a, b) => b.count - a.count)
}`
```

- **Padding and radius.** Run `CENSUS` (measuring.md) on containers and cards, with `props: ['padding-top', 'padding-left', 'border-radius', 'gap']`. Values off the scale, repeated in one place, point to one component.
- **Alignment.** Count the distinct left edges of headings, text, forms and tables within a column. More than two or three edges in one column means something is out of line:

```js
const LEFTS = String.raw`({ within = 'main, [role=main], body' } = {}) => {
  const root = document.querySelector(within) || document.body, xs = new Map()
  for (const el of root.querySelectorAll('h1, h2, h3, h4, p, label, table, form, ul, ol')) {
    const r = el.getBoundingClientRect(); if (!r.width || !r.height) continue
    const x = Math.round(r.left); xs.set(x, (xs.get(x) || 0) + 1)
  }
  return [...xs].sort((a, b) => b[1] - a[1]).map(([x, count]) => ({ x, count }))
}`
```

- **Density.** Measure control heights and row heights (`CENSUS` with `height`), and count how many rows or cards fit in the first screenful.

## A proposal

Build, measure, then place, as palette-change.md's "Making the proposed side" does. Clone one frame of today's build and change the spacing tokens or the component's padding in the clone, the way it would ship. Measure every route on both builds (`sweep(frameId, routes, fn)`, measuring.md), then place the pairs in rank order with explodeState at each route. Rank by how much each page gains or loses: rows that fit, or the height of the first screenful's content.

## The plate

Show the scale as bars, each labelled with its value and the number of uses found. Put the off-scale values beside them in grey. Show radius as chips of each value. These are values, never a rebuilt layout.

## The beats

- **1 Today.** The scale as defined, and the census in one line: the share on scale, and the values in use.
- **2 What we found, or the change.** For findings: off-scale values grouped by cause, each with a count and file:line. For a proposal: the new values, and what each container or row becomes.
- **3 How it looks.** Frames ranked by off-scale share, or pairs ranked by the change. A pointer on a gap points at both elements that bound it, so the reader sees which space is meant.
- **4 What to watch out for.** Text that wraps or truncates when things tighten, touch targets that drop below 24 px, and spacing that's intentional (a hero section, marketing pages).
- **5 What we recommend.** Fix the few components that cause most strays, then the one-offs. For a proposal: the change itself, then where it shouldn't apply.

## Caveats

- **A 1 px difference is often a border.** Check whether a border explains it before calling it a stray.
- **Margins can collapse.** Measure the rendered gap (as `GAPS` does), not the declared margin.
- **Compare densities at the same frame size and data.** More rows fit on a taller frame.

## Done when

- The scale is shown, and the share on scale is measured on every page in scope.
- Every off-scale group has a count and a source.
- Pointers name both sides of a gap.
- A proposal's pairs come from one build and differ only in spacing.
