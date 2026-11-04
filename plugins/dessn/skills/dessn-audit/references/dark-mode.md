# Theme audit: does dark mode (or another theme) hold up?

Use this when the question is whether a theme works across the product: dark mode, a high-contrast theme, or a second brand theme. It also covers proposing a new theme. It is not for one new colour value (palette-change.md); when a new value must also hold up in dark mode, the routing table has you read both. The measuring code is in measuring.md, and light leaks use pixels.md.

Contents: The question · How the theme switches · Evidence · Proposing a new theme · Ranking and tiers · The beats · Caveats · Done when

## The question

Frame the question the way the reader would ask it: "Is Acme's dark mode ready to ship?" or "Where does dark mode break?" The answer gives the count first, then what breaks, then why, in plain words. For example: "Mostly. Five of eight pages read well in dark. Two keep bright light-mode panels, and text on one is hard to read. Three causes explain all of it, and the biggest is one setting."

Stats that work here:
- pages that hold up, out of the scope;
- the worst text contrast, against 4.5 : 1;
- the number of causes, with the largest cause's count.

The opening's value image is the worst case as values: the failing text colour as a chip on its real dark background, with its ratio (the text itself shows in its frame), or the tokens that fall through to light, as chips on the dark surface.

## How the theme switches

Find the mechanism before you render anything, because it decides how a frame can show dark:
- **A class or attribute on html or body** (`.dark`, `data-theme`). An in-app toggle usually sets it, and stores the choice in localStorage, a cookie or the user's settings.
- **The OS setting** (`prefers-color-scheme`). CSS can read it directly, or a framework can: Tailwind's `dark:` follows the OS unless its config sets a class or selector strategy.
- **A theme provider in JS**, such as a component library's provider or CSS-in-JS themes.

These can disagree. For example, the app can switch its own tokens by class while a library's `dark:` classes follow the OS. When the toggle and the OS setting can differ, check both. Probe a page:

```js
const THEME = String.raw`() => ({ html: document.documentElement.className, attrs: [...document.documentElement.attributes].filter(a => a.name !== 'class').map(a => a.name + '=' + a.value),
  stored: (() => { try { return Object.fromEntries(Object.keys(localStorage).filter(k => /theme|mode|dark|appearance|scheme/i.test(k)).map(k => [k, localStorage.getItem(k)])) } catch { return 'unreadable' } })(),
  osDark: matchMedia('(prefers-color-scheme: dark)').matches, colorScheme: getComputedStyle(document.documentElement).colorScheme,
  surface: getComputedStyle(document.body).backgroundColor })`
// the OS path, for this program's page only: emulation lasts for the program that sets it
await page.send({ method: 'Emulation.setEmulatedMedia', params: { features: [{ name: 'prefers-color-scheme', value: 'dark' }] } })
return run(page, THEME)
```

Make the dark frames through the app's own switch. Set the choice the way the app stores it (the stored key or the setting in the data, not a click script). Reload, take a state, and make the frame from it with explodeState, so it keeps the same build and data as its light partner. Look at the new frame before ranking it: a frame that doesn't hold the theme shows light, and a pair of two light frames proves nothing.

**When dark mode follows only the OS,** emulation can measure a page but can't make a frame. It lasts only the program that sets it, and a state token doesn't carry it. Make the dark side in a clone instead, with a preview-only change that forces dark. For example, switch Tailwind's dark variant to a class and set the class on html, or move the rules inside the `prefers-color-scheme: dark` block under a class. Make the dark frames from that clone. Say on the board, beside the claims it affects, how they were made, and list removing the preview code as a step in section 5.

## Evidence

1. **Token pairs.** For every semantic colour, resolve its light and dark values in the page with each theme on (`TOKENS`), and list the aliases that have no dark value and fall through to light. The light/dark table is the Today plate, with its chips set on the product's dark surface.
2. **Text contrast in dark.** Run the text census (`TEXT`) on each page with the theme on: every text colour against its effective background, through transparency. Run it in light too, so a failure that is already there in light is named as existing.
3. **Light leaks.** Areas that stay light in dark mode. `pixels(page, { bright: 0.8 })` (pixels.md) gives the share of pixels at least that light and the elements that paint them. White text, a bright primary button or a photo is fine by design, so read the painters before calling something a leak.
4. **Causes,** each counted with file:line:
   - colours written straight into the code;
   - components locked to light (a theme prop, a `data-theme="light"` or `.light` wrapper);
   - portals mounted outside the themed root: menus, dialogs, toasts and tooltips;
   - third-party widgets and their own theme providers;
   - per-item colours picked for light: tags, avatars, chart series;
   - images, logos and illustrations with white baked in;
   - native controls without `color-scheme: dark`: scrollbars, date pickers, selects;
   - borders, elevation and focus rings tuned for light.
5. **States.** Leaks hide in menus, dialogs, toasts and focus rings. Make state frames of them, or list them under what you didn't check.

## Proposing a new theme

For a product without dark mode, or a new brand theme, build the theme in a clone the way palette-change.md builds a proposal. Add the theme block, map every alias to its new value, and switch it on in the clone. Then run this file's checks on the result: token pairs, text contrast, light leaks and their causes. The board is a proposal. Its pairs are today beside the new theme, and it follows palette-change.md's beats with this file's measures.

## Ranking and tiers

Use one declared measure per ranking. Rank by the share of text characters below their minimum, which is the reader's main risk, and show light-leak area as a second column. You can do it the other way round, but never switch measures partway: a board once ranked by failing text and headlined a page by its bright area.

Name tiers by what the reader sees: "Text is hard to read", "Bright light-mode patches remain", "Reads well in dark". Always frame the worst page, even when the cause is already known.

## The beats

- **1 Today.** How dark mode works, in one plain sentence ("A switch in settings adds a dark class to the page; some older pages follow the computer's setting instead"). Then the token-pairs plate, and the colours without a dark value.
- **2 What we found.** One note per cause, each with its count ("12 places write white straight into the code"), where it shows (by pair number), and its source.
- **3 How it looks.** Light and dark pairs of the same route and data, ranked by the measure. Each caption carries the measure in its head ("03 Reports 16% of text too faint"). Put pointers on each leak and on each failing text that is small at fit.
- **4 What to watch out for.** The OS setting against the toggle, states not captured, images, and anything the board calls handled.
- **5 What we recommend.** Fixes mapped from the causes, smallest first: tokens with no dark value, then locked components, then per-item colours. Give each the count it clears ("fixes 9 of the 14 failing texts").

## Caveats

- **"Already handled" needs a render or a search behind it.** A board once dropped its worst page as already handled.
- **"Goes dark cleanly" has to match the page's own numbers.** A page still failing 13% of its text doesn't go dark cleanly.
- **A pair differs only in theme:** the same route, data and build.
- **Put dark chips on the product's dark surface.** On the canvas grey they misread.
- **Name the switch you used** (toggle or OS) on the board, beside the claim it affects.

## Done when

- The mechanism is stated, and both the toggle and the OS paths are checked when they can differ.
- Every page in scope is framed or under "What we didn't check", and the worst page is framed.
- One measure ranks the pages. The second measure is a column, and every caption head shows the ranked measure.
- Every cause has a count and a source, and every fix names the causes it clears.
- No head claims more than its pages show.
