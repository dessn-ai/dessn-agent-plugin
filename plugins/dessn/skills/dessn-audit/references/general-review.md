# General review: findings across screens

Use this when the ask is a review that isn't about a single property. Examples: "audit our settings pages", "what feels inconsistent", "critique the onboarding", "is this area polished enough to ship". It is also the fallback when no other kind fits. When a theme of the review turns out to be one property, such as colour, type, spacing, one component or contrast, the SKILL.md's routing table names that kind's file. Read it for that theme's measure.

Contents: The question and the lens · Walking the screens · A finding · Grouping and ranking · The beats · Caveats · Done when

## The question and the lens

Turn the ask into a question someone can decide on: "Is Acme's settings area ready for the redesign handoff?" or "What makes onboarding feel unfinished?" Then choose the lens and say it in your first update. A lens is what you judge against, such as:
- the product's own system (tokens, components, patterns used elsewhere);
- a task (can a new user finish setup?);
- a standard (WCAG, platform conventions).

One lens, stated, keeps the findings comparable.

The opening's value image is the worst finding's evidence as values (a count, a pair of values side by side), or a short index of the themes with their counts.

The answer gives the verdict and the few themes that explain most of the findings. For example: "Not yet. Three things make it feel unfinished: two different form styles, empty states with no next step, and error messages in developer language. All three are fixable in the shared components."

## Walking the screens

- **Write the scope list first:** the screens, and the states that matter for the question (empty, error, loading, long content, permission-limited). Each ends up framed, or listed under "What we didn't check".
- **Open every screen in one pass.** For each one, read a text outline (`page.snapshot`) and a picture, and run the censuses the lens needs (measuring.md).
- **Compare like with like.** Put the same pattern side by side across screens, such as page headers, primary actions, empty states and form layouts. Inconsistencies show up there, not one screen at a time.
- **Read the code behind a suspicious spot** before calling it a bug. It may be a deliberate variant, a feature flag or mock data.

## Window sizes and content

- **Other window sizes.** Frames stay at their own size, about 1440 × 900, so the board's frames show that size. To measure narrower, open a page, set `Emulation.setDeviceMetricsOverride` (for example 390 × 844, mobile) and run the censuses or read `page.snapshot` in the same program, since the setting ends with it. Report what breaks (horizontal scroll, clipped or overlapping text, controls under 24 px) with counts. Say on the board that the frames show desktop and the narrow findings come from emulated pages.
- **Content that stretches a screen.** Long names, other languages, empty, error and loading states. Set the data or state the screen needs through its mock data (dessn-mocks), take a state and make a frame of it, or list it under what you didn't check.

## A finding

Each finding has:
- **where:** the frame, and the element to point at;
- **what the person sees:** in plain words;
- **why it matters:** the principle or the task it gets in the way of;
- **evidence:** a value, a count or a comparison frame;
- **severity:**
  - it blocks a task;
  - it confuses or slows someone down;
  - it's polish;
- **the fix:** where it lives (a token, a shared component, one screen).

Say what works too. A review that only lists problems reads as a complaint, and the good patterns are the fix for the bad ones.

## Grouping and ranking

Group the findings into three to five themes, each headed by a claim ("Empty states leave people with no next step"). Rank the themes by severity, then by reach: how many screens and how often people see them. Within a theme, rank instances the same way, and always frame the worst one. Say the counting rule once on the board ("counted per screen, not per instance").

## The beats

- **Opening.** The question, the verdict, and one number per top theme ("4 of 6 empty states have no action").
- **1 Today.** The scope, and what already works well, in one plate or a few frames beside the beat's head.
- **2 What we found.** The themes, one note each: the claim, the count, the cause and the fix location.
- **3 How it looks.** Frames grouped by theme under tier heads that name what the reader sees. Each caption names the finding, and each finding small at fit gets a pointer. A comparison points at both sides.
- **4 What to watch out for.** What the lens didn't cover, states not captured, and findings that may be intentional. Ask about those.
- **5 What we recommend.** Fixes ordered by what they clear, shared components first, each with its reach. Then the ask, and the steps.

## Caveats

- **A critique of a mock state is a critique of the mock.** Check that what you're judging is the product's behaviour, not missing data.
- **Absolutes need a search.** "Nothing suggests what the product can do" fails when a subtitle on the same screen does.
- **Keep the lens.** Switching from "consistency with the system" to personal taste halfway makes the findings incomparable.

## Done when

- The lens is stated, and every finding is judged against it.
- Every theme is a claim with a count, and the worst instance of each is framed with a pointer.
- Every scope item is framed, or listed under "What we didn't check".
- What works is on the board next to what doesn't.
