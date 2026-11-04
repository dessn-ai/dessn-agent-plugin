# Measuring for audits

Use this for the numbers on an audit board: what a token resolves to where it renders and which source wins, contrast and the text census, the component census, how different two colours are, and counts in code. Visible-pixel share has its own file, pixels.md. The page functions were run in Chrome with these call shapes. Paste the constants you need into a program and call them as shown.

Contents: 1 Before you measure · 2 Running code in a page · 3 Token values and which source wins · 4 Contrast and the text census · 5 Component census · 6 Describing a colour · 7 Counts in code · 8 Reporting a number

## 1. Before you measure

SKILL.md, section 3, has the evidence rules. In a program they mean:
- **Measure before you arrange.** Measure each route you need through the frame you build from with `sweep(frameId, routes, fn)` (section 2), and rank. Only then place frames, each in its ranked slot. A sweep loads two pages at a time, each closed when done, and opens a route whose page or browser was lost once more. Its pages hold the preview login only, not a login or setting made in the frame's page; set one up in `fn`.
- **Measure by role.** A surface is measured by visible-pixel share (pixels.md). Text, links, icons and buttons are few pixels, so count the characters or elements that carry them and check their contrast (sections 4 and 5), which takes seconds. When the count comes out the same on every page, say so once rather than rank on it.
- **Inputs.** Frame ids are your frames' ids, routes are the app's paths, and colours are hex, as `TOKENS` returns them.
- **Reduce in the program.** A program's answer holds about 40,000 characters. Merge the pages' rows in the program and return what the board will quote. Keep those rows, so the opening, captions and tables quote the same numbers.
- **One failing page shouldn't lose the pass.** A sweep answers a failed route as `{ ok: false, error }` and goes on. List what failed under "What we didn't check".
- **Emulation lasts one program.** A setting made with `Emulation.*` ends when the program that set it ends.

## 2. Running code in a page

A page function is source text. `run` passes it one JSON argument and returns its value. `page.evaluate` takes up to 64,000 characters.

```js
const run = async (page, fn, arg) => {
  const r = await page.evaluate({ expression: '(' + fn + ')(' + JSON.stringify(arg ?? {}) + ')' })
  if (r.ok === false) throw new Error(r.error.message)
  return r.value
}
// A frame's own page, or one route of it.
const pageOf = async (frameId, route) => {
  const f = await canvas.frame(frameId), page = await f.preview.open(route ? { route } : {})
  if (page.ok === false) throw new Error(frameId + ' ' + (route ?? '') + ': ' + page.error.message)
  const ready = await page.ready({})
  if (ready.ok === false) throw new Error(frameId + ' ' + (route ?? '') + ': ' + ready.reason)
  return page
}
// Routes of one frame, two pages at a time: each answers fn(page, route), or { ok: false, error } if its page
// didn't open or get ready, or fn threw. Use the page only inside fn.
const sweep = async (frameId, routes, fn, options) => (await canvas.frame(frameId)).preview.sweep(routes, async (page, route) => {
  if (page.ok === false) throw new Error(route + ': ' + page.error.message)
  return fn(page, route)
}, options)
```

## 3. Token values and which source wins

**First find how this product writes tokens,** and build every search from that. It might use CSS variables (`--surface: #F4F4F4`), a Tailwind config (`colors.gray[50]`), a JS theme object (MUI's `palette.primary.main`, Chakra, styled-components) or SCSS variables (`$gray-50`). A search built for the wrong form counts zero.

A token file says what a value should be, but what paints is decided in the page. A shared UI library, a theme provider or a CSS-in-JS runtime can inject its own copy after the app's file, and win. `TOKENS` resolves CSS variables where they render (pass `scope`, a selector, for a theme set on a wrapper). It returns the raw value and the sRGB hex it paints, whatever format it was written in. `DECLARED` lists every stylesheet rule that sets a variable, in cascade order, and the value that won. With equal selectors, the last rule wins. For a JS theme, read the value off an element that uses it (`getComputedStyle`).

```js
const TOKENS = String.raw`({ names, scope }) => {
  const host = (scope && document.querySelector(scope)) || document.body
  const probe = host.appendChild(document.createElement('i')), paint = new OffscreenCanvas(1, 1).getContext('2d', { willReadFrequently: true })
  const out = {}
  for (const name of names) {
    const raw = getComputedStyle(probe).getPropertyValue(name).trim()
    if (!raw) { out[name] = null; continue }
    probe.style.backgroundColor = 'var(' + name + ')'
    paint.clearRect(0, 0, 1, 1); paint.fillStyle = getComputedStyle(probe).backgroundColor; paint.fillRect(0, 0, 1, 1)
    const [r, g, b, a] = paint.getImageData(0, 0, 1, 1).data
    out[name] = { raw, hex: '#' + [r, g, b].map(v => v.toString(16).padStart(2, '0')).join(''), alpha: +(a / 255).toFixed(2) }
  }
  probe.remove()
  return out
}`

const DECLARED = String.raw`(name) => {
  const rows = [], owners = [...document.querySelectorAll('style, link[rel=stylesheet]')]
  const walk = (rules, from) => { for (const r of rules) { const v = r.style && r.style.getPropertyValue(name); if (v) rows.push({ from, selector: r.selectorText, value: v.trim() }); if (r.cssRules) walk(r.cssRules, from) } }
  for (const sheet of [...document.styleSheets, ...(document.adoptedStyleSheets || [])]) {
    const from = sheet.href || (sheet.ownerNode ? sheet.ownerNode.tagName.toLowerCase() + ' #' + owners.indexOf(sheet.ownerNode) : 'adopted')
    try { walk(sheet.cssRules, from) } catch { rows.push({ from, unreadable: true }) }
  }
  const inline = document.documentElement.style.getPropertyValue(name)
  if (inline) rows.push({ from: 'html style attribute', value: inline.trim() })
  return { wins: getComputedStyle(document.documentElement).getPropertyValue(name).trim(), declared: rows }
}`

const page = await pageOf(frameId)
return { values: await run(page, TOKENS, { names: ['--surface', '--text-muted'] }), declared: await run(page, DECLARED, '--surface') }
```

When two sources declare a variable, that is a risk to name: which one ships? Settle it the way the change would ship. Edit the value in a cloned sandbox and see whether the resolved value moves. Also search the product's own packages for a copy that no file in the app shows (section 7).

**Naming colours.** `meets` (pixels.md) and the text census return hex. To name one, resolve the product's surface and line aliases with `TOKENS` and match the hex. Then call it by its plain role ("white", "divider", "border") and put the token in small print. Draw its chip with that token, not the hex.

## 4. Contrast and the text census

WCAG 2.x contrast works like this. Linearize each channel, take the luminance `L = 0.2126 R + 0.7152 G + 0.0722 B`, then compute `(L lighter + 0.05) / (L darker + 0.05)`. Composite a translucent colour over what is behind it first. The minimums are:
- 4.5 : 1 for body text;
- 3 : 1 for large text (24 px, or 18.66 px at weight 700);
- 3 : 1 for what identifies a control or a state, such as input borders, focus rings and icons that carry meaning (decorative dividers are exempt);
- 7 : 1 for "passes easily" (AAA).

Disabled text is exempt.

`TEXT` walks every visible run of text on the page. For each one it finds the effective background by compositing each ancestor's colour until one is opaque, then computes the contrast. It groups the runs by colour, background, size and weight, with a character count and an example; each row also carries the font family and line height. `failingShare` is the share of characters below their minimum. Text over an image or a gradient comes back as such: judge it from the picture, and say so. `by: 'type'` groups by size, weight, family and line height instead, without colours, for a type audit. `viewportOnly` (the default) keeps the first screenful. Say so in the footnote, or pass `false` for the whole page.

```js
const TEXT = String.raw`({ within = 'body', viewportOnly = true, by = 'colour', limit = 40 } = {}) => {
  const paint = new OffscreenCanvas(1, 1).getContext('2d', { willReadFrequently: true })
  const rgba = css => { paint.clearRect(0, 0, 1, 1); paint.fillStyle = css; paint.fillRect(0, 0, 1, 1); const [r, g, b, a] = paint.getImageData(0, 0, 1, 1).data; return [r, g, b, a / 255] }
  const over = (top, under) => top.slice(0, 3).map((v, i) => v * top[3] + under[i] * (1 - top[3]))
  const lin = v => (v /= 255) <= 0.04045 ? v / 12.92 : ((v + 0.055) / 1.055) ** 2.4
  const lum = ([r, g, b]) => 0.2126 * lin(r) + 0.7152 * lin(g) + 0.0722 * lin(b)
  const ratio = (a, b) => { const [hi, lo] = [lum(a), lum(b)].sort((x, y) => y - x); return (hi + 0.05) / (lo + 0.05) }
  const hex = c => '#' + c.slice(0, 3).map(v => Math.round(v).toString(16).padStart(2, '0')).join('')
  const behind = el => {
    const layers = []
    for (let e = el; e; e = e.parentElement) {
      const s = getComputedStyle(e)
      if (s.backgroundImage !== 'none') return null
      const c = rgba(s.backgroundColor); if (c[3] > 0) layers.push(c); if (c[3] >= 1) break
    }
    return layers.reverse().reduce((under, top) => over(top, under), [255, 255, 255])
  }
  const groups = new Map(), root = document.querySelector(within) || document.body
  const walker = document.createTreeWalker(root, NodeFilter.SHOW_TEXT)
  let total = 0
  for (let node; (node = walker.nextNode());) {
    const text = node.textContent.trim(), el = node.parentElement
    if (!text || !el) continue
    const s = getComputedStyle(el), range = document.createRange(); range.selectNodeContents(node)
    const r = range.getBoundingClientRect()
    if (!r.width || !r.height || s.visibility === 'hidden' || +s.opacity === 0) continue
    if (viewportOnly && (r.bottom < 0 || r.top > innerHeight || r.right < 0 || r.left > innerWidth)) continue
    const size = parseFloat(s.fontSize), weight = +s.fontWeight, family = s.fontFamily.split(',')[0].trim().replace(/^["']|["']$/g, ''), lineHeight = s.lineHeight
    const example = text.slice(0, 40), rect = [r.x, r.y, r.width, r.height].map(Math.round)
    let key, row
    if (by === 'type') { key = [size, weight, family, lineHeight].join('|'); row = groups.get(key) || { size, weight, family, lineHeight, chars: 0, example, rect } }
    else {
      const bg = behind(el), fg = rgba(s.color), large = size >= 24 || (size >= 18.66 && weight >= 700)
      const shown = bg && over(fg, bg), cr = bg ? Math.floor(ratio(shown, bg) * 100) / 100 : null
      key = [hex(fg), bg ? hex(bg) : 'image', size, weight].join('|')
      row = groups.get(key) || { fg: hex(fg), bg: bg ? hex(bg) : 'over an image or gradient', size, weight, family, lineHeight, ratio: cr, needs: large ? 3 : 4.5, exempt: !!el.closest(':disabled, [aria-disabled="true"]'), chars: 0, example, rect }
    }
    row.chars += text.length; total += text.length; groups.set(key, row)
  }
  const rows = [...groups.values()].sort((a, b) => b.chars - a.chars)
  const failing = rows.filter(r => r.ratio != null && !r.exempt && r.ratio < r.needs)
  return { chars: total, groups: rows.length, failingShare: total ? +(100 * failing.reduce((n, r) => n + r.chars, 0) / total).toFixed(1) : 0, failing: failing.slice(0, limit), rows: rows.slice(0, limit) }
}`

// Every screen, reduced to what the board quotes: each screen's failing share and worst rows, and the groups merged across screens.
const results = await sweep(frameId, routes.map(r => r.route), page => run(page, TEXT, {}))
const screens = routes.map((r, i) => results[i]?.ok === false ? { ...r, failed: results[i].error.message } : { ...r, ...results[i] })
const merged = new Map()
for (const s of screens) for (const row of s.rows ?? []) { const k = [row.fg, row.bg, row.size, row.weight].join('|'), m = merged.get(k) || { ...row, chars: 0, screens: 0 }; m.chars += row.chars; m.screens++; merged.set(k, m) }
return { screens: screens.map(s => s.failed ? s : { name: s.name, chars: s.chars, failingShare: s.failingShare, worst: s.failing.slice(0, 5) }),
  groups: [...merged.values()].sort((a, b) => b.chars - a.chars).slice(0, 40) }
```

For a proposed colour, compute the ratios in the program with the same formula, from `TOKENS` values resolved in the proposed frame, before and after. Name anything that crosses from pass to fail. Colours that already fail are existing issues.

## 5. Component census

`CENSUS` groups every element a selector matches by the computed values you name, so each group is one variant. `height` and `width` are the rendered size, and any other name is a CSS property. `shared` is a selector the shared component always carries, such as a class or data attribute from its source. Each row's `shared` counts how many of its elements carry it.

```js
const CENSUS = String.raw`({ selector, props, shared }) => {
  const groups = new Map()
  for (const el of document.querySelectorAll(selector)) {
    const r = el.getBoundingClientRect(), s = getComputedStyle(el)
    if (!r.width || !r.height || s.visibility === 'hidden') continue
    const values = props.map(p => p === 'height' ? Math.round(r.height) + 'px' : p === 'width' ? Math.round(r.width) + 'px' : s.getPropertyValue(p))
    const key = values.join(' | ')
    const row = groups.get(key) || { values: Object.fromEntries(props.map((p, i) => [p, values[i]])), count: 0, shared: 0, examples: [] }
    row.count++
    if (shared && el.matches(shared)) row.shared++
    if (row.examples.length < 3) row.examples.push({ tag: el.tagName.toLowerCase(), text: (el.innerText || el.getAttribute('aria-label') || '').trim().replace(/\s+/g, ' ').slice(0, 40), rect: [r.x, r.y, r.width, r.height].map(Math.round) })
    groups.set(key, row)
  }
  return [...groups.values()].sort((a, b) => b.count - a.count)
}`

const props = ['height', 'border-radius', 'padding-left', 'font-size', 'font-weight', 'background-color', 'color', 'border-top-color']
return sweep(frameId, routes.map(r => r.route), page => run(page, CENSUS, { selector: 'button, [role=button], a[class*=btn], input[type=submit]', props, shared: '[data-slot=button]' }))
```

Merge the pages' rows by `values` in the program. Values 1 px apart are often one variant rendered differently (a border, or zoom), so check before calling them two. Say what the selector caught and what it left out.

## 6. Describing a colour

Describe a colour in OKLCH. L is lightness (0–1). C is chroma: 0 is pure grey, and a small C is a tint or "warmth". H is the hue in degrees. ΔE in OKLab says how different two colours are: about 0.005 shows only beside the old colour, and under about 0.01 is a near match. Put plain words in the sentence ("a touch lighter and slightly yellow") and the numbers in a footnote.

```js
const oklch = hex => {
  const [r, g, b] = [1, 3, 5].map(i => parseInt(hex.slice(i, i + 2), 16) / 255).map(v => v <= 0.04045 ? v / 12.92 : ((v + 0.055) / 1.055) ** 2.4)
  const l = Math.cbrt(0.4122214708 * r + 0.5363325363 * g + 0.0514459929 * b), m = Math.cbrt(0.2119034982 * r + 0.6806995451 * g + 0.1073969566 * b), s = Math.cbrt(0.0883024619 * r + 0.2817188376 * g + 0.6299787005 * b)
  const L = 0.2104542553 * l + 0.793617785 * m - 0.0040720468 * s, A = 1.9779984951 * l - 2.428592205 * m + 0.4505937099 * s, B = 0.0259040371 * l + 0.7827717662 * m - 0.808675766 * s
  return { L, C: Math.hypot(A, B), H: (Math.atan2(B, A) * 180 / Math.PI + 360) % 360, lab: [L, A, B] }
}
const deltaE = (a, b) => Math.hypot(...oklch(a).lab.map((v, i) => v - oklch(b).lab[i]))
```

## 7. Counts in code

Count usage in lines and files, in each form the codebase writes a token (section 3). Leave out tests, stories, node_modules and the token files themselves, and say so in the footnote. `rg` searches from the app's root and skips what `.gitignore` skips. It exits 1 when nothing matches. Exit 2 is an error, such as a missing folder, and must not read as zero.

```js
const f = await canvas.frame(frameId)
const NOT = `-g '!node_modules' -g '!*.{test,spec,stories}.*'`
const count = async (pattern, exclude = '') => {
  const r = await f.bash(`rg -c -i ${NOT} ${exclude} -e '${pattern}' .`)
  if (r.exitCode > 1 && !r.stdout.trim()) throw new Error('rg: ' + (r.stderr || 'exit ' + r.exitCode))
  const files = r.stdout.trim().split('\n').filter(Boolean)
  return { lines: files.reduce((n, row) => n + Number(row.split(':').pop()), 0), files: files.length }
}
const END = '([^A-Za-z0-9_/-]|$)'   // a tint (bg-x/10) is its own form
// Tailwind and CSS variables; for a JS theme, search its path instead, e.g. `palette\\.primary\\.main|theme\\.colors\\.primary`.
const forms = alias => ({
  utilities: `(^|[^A-Za-z0-9_-])(bg|text|border|ring|fill|stroke|outline|divide|from|via|to|shadow|accent|caret|decoration|placeholder)-${alias}${END}`,
  hover: `hover:(bg|text|border)-${alias}${END}`,
  tints: `(bg|text|border|ring|fill|stroke|outline|divide|from|via|to)-${alias}/`,
  variable: `var\\(--${alias}\\)`,
})
// The value written straight into code: 6- and 8-digit hex, 3-digit when it has one, and rgb().
const copies = hex => {
  const h = hex.slice(1).toLowerCase(), [r, g, b] = [0, 2, 4].map(i => parseInt(h.slice(i, i + 2), 16))
  const short = h[0] === h[1] && h[2] === h[3] && h[4] === h[5] ? `|#${h[0]}${h[2]}${h[4]}([^0-9a-f]|$)` : ''
  return `#${h}([^0-9a-f]|$)|#${h}ff([^0-9a-f]|$)${short}|rgba?\\(\\s*${r}[\\s,]+${g}[\\s,]+${b}([^0-9]|$)`
}
const skip = `-g '!src/styles/tokens.css'`   // your token files
const uses = {}
for (const alias of aliases) uses[alias] = Object.fromEntries(await Promise.all(Object.entries(forms(alias)).map(async ([form, p]) => [form, await count(p, skip)])))
const where = await f.bash(`rg -n -i ${NOT} ${skip} -e '${copies(OLD)}' .`)
return { uses, hardCoded: await count(copies(OLD), skip), where: where.stdout.slice(0, 3000), newAlready: await count(copies(NEW)) }
```

- **Every alias first.** Include each variable that resolves to the value, following aliases of aliases, in each theme block, since light and dark can differ.
- **Shared class constants, one hop.** A class string in a shared file reaches every component that uses it, so count those too ("10 lines, which reach all 393 secondary buttons").
- **Config and packages.** Look at palette entries in a Tailwind or theme config. Look for the value in the product's own packages under node_modules (`rg -l -i` on their dist), where a runtime copy shows up.
- **Near matches.** A proposed value may already exist, or nearly. Pull every hex from the palette configs (`rg -o -i '#[0-9a-f]{6}'`) and keep those within ΔE 0.01 of the new value (section 6).
- **Theme escapes.** Look for components forced into one theme: a `data-theme="light"` wrapper, a `.light` class inside dark, or a prop that turns theming off.

## 8. Reporting a number

- **Round so a fail never reads as a pass.** Truncate contrast to two decimals, so 4.499 is "4.49 : 1", a fail. Give shares of 10% or more as whole numbers, and shares under 10% to one decimal.
- **Give every number its yardstick in the sentence:** "4.5 : 1 is the minimum for body text"; "no other page we compared has more"; "of the 122 buttons we measured on 12 pages".
- **State the method once,** in a footnote under the index or the plate, rather than in every caption.
- **Name the scope beside the claim:** "…so the percentages only cover these pages".
