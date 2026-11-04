---
name: dessn-design-system
description: The product's own design system as a reference page of colours as the theme groups them, type, spacing and radius, key components, icons, with real values. For "show", "document" or "lay out our design system" with no change proposed; a change or a review is dessn-audit.
---

# A design system page

A design system page is a reference: someone opening the project sees the values its code really uses, named the way the code names them, and takes in the whole system at a glance. It is not a review (no verdict, ranking or recommendation) and not a rebuilt UI kit. From afar it reads as five sections; up close each swatch, style and step carries its token or style name and its value.

- **Colour.** The theme's own groups (brand, text, background, status and so on, in the order the theme declares them), each token as a swatch with its name and value. A theme with modes shows light and dark side by side.
- **Type.** The font families with the weights the product loads, then the text styles or type scale its theme names, each set in its real font at its real size, with name, size, weight and line height.
- **Spacing and radius.** The scale's steps drawn at their real lengths (bars for spacing, rounded boxes for radius) with their token names.
- **Components.** The handful the product's pages lean on (button, input, card, navigation, dialog) as real frames of the app, so what the board page shows is what the product renders. The pages are already frames' worth of the real app (`dessn_surfaces_list`): a frame of each page that shows the components, with the component names in its caption, is real and ready at once. An isolated component or state takes a new route in the app, its rebuild and its own checks, which is the slowest way to show it.
- **Icons.** The icon set or sets in use and a handful of the most used icons, drawn.

## The values are already indexed

The Library's design graph holds all of this (it is what the Design system window shows), so the page needs no reading of theme files, token modules or global CSS. Ask it with `dessn_designSystem_get`, at the project, with no frame:

```
dessn_designSystem_get({ project, kind: 'tokens' })       // its colours, by group
dessn_designSystem_get({ project, kind: 'typography' })   // its font families, text styles, and its type, spacing and radius scales
dessn_designSystem_get({ project, kind: 'icons' })        // its icon sets and most used icons
```

These are the saved answers the Design system window shows, per Library build, so a call wakes nothing. `dessn_designSystem_get({ project, kind: 'components', q })` finds a component by its job, and `dessn_surfaces_list` the pages that show it. An answer with `saved: false` says where else the values are: the app's theme, token and global CSS files, through `dessn_files_read`.

## The board

Draw the sections as plates of values on one board, laid out as a page that reads top to bottom. `skill://dessn-audit/references/board-anatomy.md` (Sizes, Plates, The grid) and dessn_guide 'board-craft' have the note kit and the text sizes: a board shows at fit at about 0.05 to 0.1 zoom, so headings of 96 to 280 px read there, captions and labels of 40 to 56 px read from about 0.1, and anything smaller is a smudge. Read it for the sizes only. Components are frames, placed with `dessn_nodes_create` items from the pages that show them (`from: { surface }`), each with its component names in its `caption`.

A first design system page is for taking in the system: the colour groups the theme names, the type styles in use, the scale steps, a few components and the main icons, with a count where more exist ("and 24 more steps"). The person can ask for any section in full. One look at the whole board (`dessn_canvas_screenshot({ target: <page>, region: 'fit' })`) catches a blank, clipped or overlapping plate; fix what it shows and the page is done.
