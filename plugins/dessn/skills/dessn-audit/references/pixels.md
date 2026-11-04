# Visible-pixel share

Use this when a number on the board is how much of a page a colour paints: a palette change's ranking, light patches in a dark theme, or the old colour left over after an edit. It needs `run`, `pageOf` and `sweep` from measuring.md.

Contents: Why pixels · The code · Measuring before you place · Reading the result · Limits

## Why pixels

Box areas overstate a colour, because children paint over it: one board summed the boxes of elements with a grey background and called a page 100% grey where 49% showed. Count the pixels in the page's picture that are exactly the colour instead. That counts only what is painted and visible, leaving out the white cards, text, borders and images on top.

## The code

`PIXELS` decodes one band of the page's picture inside the page and counts it: each colour's pixels, the elements that paint them, the colours one colour touches (`meets`), and the pixels at least as light as `bright` (a luminance from 0 to 1), whatever their colour. `pixels` captures the page in bands and adds them up. For each colour it returns the share of the page and the elements that paint most of it (`paintedBy`: selector, text, box and share).

It works in bands because every call's arguments and answer go into the program's replay log. One value over 1 MB fails the whole program, not just the call, with "…is too large to record durably". A band of about 200,000 pixels stays under that even for a photo.

```js
const PIXELS = String.raw`async ({ png, top = 0, colours = [], meets, bright, cell = 24 }) => {
  const bytes = Uint8Array.from(atob(png), ch => ch.charCodeAt(0))
  const bmp = await createImageBitmap(new Blob([bytes], { type: 'image/png' }), { colorSpaceConversion: 'none', premultiplyAlpha: 'none' })
  const w = bmp.width, h = bmp.height, ctx = new OffscreenCanvas(w, h).getContext('2d', { willReadFrequently: true })
  ctx.drawImage(bmp, 0, 0)
  const d = ctx.getImageData(0, 0, w, h).data
  const int = c => { const x = c.replace('#', ''); return parseInt(x.length === 3 ? [...x].map(v => v + v).join('') : x.slice(0, 6), 16) }, hexOf = n => '#' + n.toString(16).padStart(6, '0')
  const want = new Map(colours.map(c => [int(c), { px: 0, cells: new Map() }])), target = meets ? int(meets) : -1, near = new Map()
  const at = (x, y) => { const i = (y * w + x) * 4; return (d[i] << 16) | (d[i + 1] << 8) | d[i + 2] }
  const lin = [...Array(256)].map((_, v) => (v /= 255) <= 0.04045 ? v / 12.92 : ((v + 0.055) / 1.055) ** 2.4), light = { px: 0, cells: new Map() }
  const tally = (row, c, x, y) => {
    row.px++
    // Only solid pixels say who paints them: a lone match is anti-aliasing at a text or border edge.
    if (x + 1 < w && at(x + 1, y) === c && (y + 1 === h || at(x, y + 1) === c)) { const k = Math.floor(x / cell) + ',' + Math.floor(y / cell); if (!row.cells.has(k)) row.cells.set(k, { x, y, px: 0 }); row.cells.get(k).px++ }
  }
  for (let y = 0; y < h; y++) for (let x = 0; x < w; x++) {
    const c = at(x, y), row = want.get(c)
    if (row) tally(row, c, x, y)
    if (bright !== undefined && 0.2126 * lin[c >> 16] + 0.7152 * lin[(c >> 8) & 255] + 0.0722 * lin[c & 255] >= bright) tally(light, c, x, y)
    if (c === target) for (const [X, Y] of [[x + 1, y], [x - 1, y], [x, y + 1], [x, y - 1]]) {
      if (X < 0 || Y < 0 || X >= w || Y >= h) continue
      const n = at(X, Y); if (n !== target) near.set(n, (near.get(n) || 0) + 1)
    }
  }
  // Who paints a pixel: the first element up from the top one whose background shows (an image, or any colour not fully transparent).
  const probe = new OffscreenCanvas(1, 1).getContext('2d', { willReadFrequently: true })
  const shows = css => { probe.clearRect(0, 0, 1, 1); probe.fillStyle = '#000'; probe.fillStyle = css; probe.fillRect(0, 0, 1, 1); return probe.getImageData(0, 0, 1, 1).data[3] > 0 }
  const painter = (x, y) => {
    for (let el = document.elementFromPoint(x, y + top); el; el = el.parentElement) {
      const s = getComputedStyle(el)
      if (s.backgroundImage !== 'none' || shows(s.backgroundColor)) return el
    }
    return document.documentElement
  }
  const describe = el => { const r = el.getBoundingClientRect(), cls = [...el.classList].slice(0, 2)
    return { sel: el.tagName.toLowerCase() + (el.id ? '#' + CSS.escape(el.id) : cls.map(c => '.' + CSS.escape(c)).join('')), text: (el.innerText || '').trim().replace(/\s+/g, ' ').slice(0, 50), rect: [r.x, r.y, r.width, r.height].map(Math.round) } }
  const summary = row => { const by = new Map()
    for (const s of row.cells.values()) { const el = painter(s.x + 0.5, s.y + 0.5); by.set(el, (by.get(el) || 0) + s.px) }
    return { px: row.px, by: [...by].sort((a, b) => b[1] - a[1]).slice(0, 8).map(([el, px]) => ({ ...describe(el), px })) } }
  const out = { w, h, colours: Object.fromEntries(colours.map(c => [c, summary(want.get(int(c)))])) }
  if (bright !== undefined) out.bright = summary(light)
  if (meets) out.near = [...near].sort((a, b) => b[1] - a[1]).slice(0, 8).map(([n, edges]) => [hexOf(n), edges])
  return out
}`

// The page's first screenful, band by band (a clip is in page coordinates, hence the scroll).
const pixels = async (page, arg = {}) => {
  const [w, h, sx, sy] = await run(page, '() => [innerWidth, innerHeight, scrollX, scrollY]')
  const rows = Math.max(1, Math.floor(200000 / w)), bands = []
  for (let top = 0; top < h; top += rows) {
    const shot = await page.send({ method: 'Page.captureScreenshot', params: { format: 'png', clip: { x: sx, y: sy + top, width: w, height: Math.min(rows, h - top), scale: 1 } } })
    if (shot.ok === false) throw new Error(shot.error.message)
    const r = await page.send({ method: 'Runtime.evaluate', params: { expression: '(' + PIXELS + ')(' + JSON.stringify({ ...arg, png: shot.value.data, top }) + ')', awaitPromise: true, returnByValue: true } })
    if (r.ok === false) throw new Error(r.error.message)
    if (r.value.exceptionDetails) throw new Error(r.value.exceptionDetails.exception?.description ?? r.value.exceptionDetails.text)
    bands.push(r.value.result.value)
  }
  const share = px => +(100 * px / (w * h)).toFixed(2)
  const total = parts => { const by = new Map(); let px = 0
    for (const part of parts) { px += part.px; for (const p of part.by) { const k = p.sel + p.rect, had = by.get(k); if (had) had.px += p.px; else by.set(k, { ...p }) } }
    return { share: share(px), paintedBy: [...by.values()].sort((a, b) => b.px - a.px).slice(0, 6).map(({ px, ...p }) => ({ ...p, share: share(px) })) } }
  const out = { size: [w, bands.reduce((n, b) => n + b.h, 0)], colours: Object.fromEntries((arg.colours ?? []).map(c => [c, total(bands.map(b => b.colours[c]))])) }
  if (arg.bright !== undefined) out.bright = total(bands.map(b => b.bright))
  if (arg.meets) { const near = new Map(); for (const b of bands) for (const [c, n] of b.near) near.set(c, (near.get(c) || 0) + n)
    out.meets = [...near].sort((a, b) => b[1] - a[1]).slice(0, 5).map(([colour, edges]) => ({ colour, edges })) }
  return out
}
```

Colours are hex as `TOKENS` returns them (`'#f4f4f4'`). An `rgb()` string matches nothing.

## Measuring before you place

Measure every page before any frame goes up, so the frames are placed once and already ranked. Measure each route through the frame you build from: today's side from one frame of today's build, and the proposed side from the clone that carries the change (the kind file says how to make it). The two sides run together, two pages a side (a sweep's own pace); their pages are spread so that no more than two boot in one browser at a time. A route whose page or browser was lost is opened once more; a page that still fails on either side is reported rather than losing the pass.

```js
// routes: [{ name, route }]; todayId and cloneId are frame ids; OLD and NEW are hex.
const side = (frameId, arg) => sweep(frameId, routes.map(r => r.route), page => pixels(page, arg), { concurrency: 2 })
const [today, next] = await Promise.all([side(todayId, { colours: [OLD], meets: OLD }), side(cloneId, { colours: [NEW, OLD] })])
return routes.map(({ name, route }, i) => {
  const t = today[i], n = next[i]
  if (t?.ok === false || n?.ok === false) return { name, route, failed: (t?.ok === false ? t : n).error.message }
  return { name, route, size: n.size, today: t.colours[OLD].share, proposed: n.colours[NEW].share, remainder: n.colours[OLD].share,
    where: n.colours[NEW].paintedBy.slice(0, 3), stragglers: n.colours[OLD].paintedBy, meets: t.meets }
})
```

For light patches in a dark theme, measure the dark pages with `{ bright: 0.8 }` and read `bright`.

## Reading the result

Read the result before you rank:
- `size` is the frame's size, 1440 × 900 for a desktop frame. If it isn't, the page isn't at the frame's viewport, so open it again.
- Today's share and the proposal's share should agree within about half a point. A bigger gap means the two sides differ in more than the change: a different build, different data or another route.
- `remainder` is the old colour still showing in the proposal. A few hundredths of a percent inside text or buttons is anti-aliasing. A block with a real share is a place that won't follow the token, and its painter says where.
- `paintedBy` names what to say in a caption ("the canvas", "the upload area") and gives a selector to point at. Check a pointer's `matches` before trusting the selector.
- `meets` gives the neighbours for a swatch and for edge contrast, usually a white surface, a divider and a border. measuring.md shows how to name them.

## Limits

- This measures the first screenful, and the footnote should say so.
- A colour at partial opacity, blended or in a gradient won't match exactly. A dialog's backdrop changes every pixel under it. Check once that a known chip reads back exactly.
- A colour that paints few pixels, such as an accent on one button per page, a link or text, gives shares too small to rank pages by. Count the elements or characters that carry it instead (measuring.md, sections 4 and 5).
- A tint of the colour (`bg-primary/10`, `color-mix`) is a different colour here. Count tints in code instead, and list them as "changes too, not in the pixel share".
- If a program fails with "too large to record durably", make the bands smaller: change 200,000 to 100,000.
