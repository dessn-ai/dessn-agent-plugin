# Consistency audit: one component or pattern across pages

Use this when the question is whether one component or pattern is consistent across the product. That covers buttons, inputs, selects, cards, tables, tabs, badges, icons, empty states and page headers. It is not for type as a whole (type-scale.md) or spacing as a whole (spacing.md), though a component's own type and padding belong here. The census code is in measuring.md.

Contents: The question · The yardstick · Census · Pages and frames · The plate · The beats · Caveats · Done when

## The question

Ask the reader's question: "Are Acme's buttons consistent?" The answer compares how many variants exist with how many the system defines. It says where the stray ones are, and whether they come from the shared component or from one-off code. For example: "Mostly. The shared button covers 90 of the 122 buttons we measured on 12 pages, in the four sizes it defines. The other 32 are hand-built in six more variants, most of them on the billing pages."

Stats that work here:
- the share of instances that are the shared component;
- the number of variants found, against the number defined;
- the worst page's count.

The opening's value image is the variant row: each variant's height, radius and weight as numbers, its fill and text colour as chips, and its count, with the system's own variants first.

## The yardstick

The yardstick is the system's own definition. Read the shared component's source for its size and variant maps and its class lists, and read its tokens for heights, radius and weights. That is what a right instance looks like. If there is no definition, the most common variant is the norm, and say so on the board.

## Census

- **Collect every instance on every page in one pass.** Use `CENSUS` with a selector that catches the component and its look-alikes. For buttons that is `button, [role=button], a[class*=btn], input[type=submit]`, plus the product's own button classes.
- **Record the computed values that make a variant:** height, radius, horizontal padding, font size and weight, fill, text colour and border.
- **Mark whether each element is the shared component.** Pass as `shared` a class or data attribute that the component's source always sets.
- **In code, count the shared component's uses against hand-built ones.** For example, count lines that render `<Button` against lines that render a raw `<button` with its own classes (measuring.md, "Counts in code").
- **State the denominator on the board:** what counted, what didn't (nav tabs, list rows, icon-only controls) and how many pages. A board once said "4 of 122" where the 122 included nav tabs, and only the chat said so.
- **Cluster the rows.** Identical values are one variant. Values 1 px apart are often one variant rendered differently, so check before calling them two.
- **Compare colours as resolved hex.** Several near-identical blacks or blues are a finding in themselves, so keep it even when the ask was about size.
- **Decide on separate kits.** A second kit inside the product, such as an admin area or an editor with its own small controls, is either in the census or named as out of scope.

## Pages and frames

- **Frame one page per distinct variant family,** where that variant is most visible.
- **Always frame the worst offender,** and one page where the shared component is used as designed, for comparison.
- **Point at each instance the caption names.** A comparison ("50 vs 48 px") points at both instances, not one.
- **Treat states as part of consistency.** Hover, focus, disabled and loading can differ even when rest looks the same. Make state frames of them, or list them under what you didn't check.

## The plate

The plate is a table of variants. Each row gives:
- the variant's count and where it appears;
- its values: height, radius and weight as numbers, with the fill and text colour as chips;
- whether it is the shared component.

Values are allowed, but never draw the component itself: the frames show it.

## The beats

- **1 Today.** The system's definition (its sizes, its variants and where it lives) and the census in one line, denominator included.
- **2 What we found.** The variants, grouped by cause: hand-built copies, overridden classes, a second library, old code. Give each its count and file:line.
- **3 How it looks.** Frames ranked by how many instances on each page are off the system. Captions name the variant and its values, with pointers on each instance.
- **4 What to watch out for.** States not checked, what the denominator leaves out, and differences that may be intentional, such as destructive actions or marketing pages. Ask about those rather than calling them wrong.
- **5 What we recommend.** Two directions, each with counts:
  - **fix the system first:** add the missing size to the shared component;
  - **migrate first:** replace the hand-built instances.

  Recommend one, and give the order of pages.

## Caveats

- **A head must match its own table.** "One corner" above radii of 6 and 8 contradicts itself.
- **Read the opening's recommendation against beats 4 and 5 last,** and change whichever is wrong, so the opening can't reverse them.
- **Keep findings from earlier passes unless you've disproved them.** Dropping a real colour finding makes the second board worse than the first.

## Done when

- The denominator is on the board, and every count uses it.
- Every variant family has a frame, and a pointer on each instance its caption names.
- The yardstick (the system's definition) is shown beside the variants.
- States are framed, or listed as not checked.
- The options say what each one costs, in instances and files.
