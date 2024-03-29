#let data = toml("assets/curriculum_vitae_sample.toml")

#import "modules/catppuccin_latte.typ": colors
#import "modules/page_din_5008.typ"

// Accent colors
#colors.insert("primary", colors.mauve)
#colors.insert("complement", colors.lavender)

// ============================================================================

#set text(lang: data.lang)

// Icon and name
#let entry(icon: none, content) = {
  set align(horizon)
  stack(
    dir: ltr,
    spacing: 0.5em,
    text(fill: colors.primary, 20pt, icon),
    content,
  )
}

#table(
  columns: (auto, 1fr, 1fr),
  gutter: 1em,
  stroke: none,
  align: (x, y) => (left, horizon + center, horizon + left).at(x),
  stack(dir: ttb, spacing: 1em, text(
    size: 25pt,
    weight: "bold",
    gradient.linear(colors.primary, colors.complement),
    data.name,
  ), text(weight: "bold", data.profession)),
  stack(
    dir: ttb,
    spacing: 1em,
    entry(
      icon: ``,
      align(horizon + left, [#data.street #data.number \ #data.postal #data.city]),
    ),
  ),
  stack(
    dir: ttb,
    spacing: 1em,
    entry(icon: `󰁥`, link("mailto:" + data.email)[#data.email]),
    entry(icon: ``, data.phone),
  ),
)

#line(
  length: 100%,
  stroke: 1pt + gradient.linear(colors.base, colors.complement, colors.base),
)

// Briefkopf

#stack(
  dir: ttb,
  spacing: 1em,
  // entry(icon: ``, [HR Person]),
  entry(icon: ``, [*Company Name*\ Street xx\ xxxxx City]),
  entry(icon: `󰁥`, link("mailto:" + "xxx@x.x")[xxx\@x.x]),
  entry(icon: ``, [+xx xxxx xxxxxx]),
)

#align(right, datetime.today().display(data.city + ", [day].[month].[year]"))
#[= #text(
    size: 14pt,
    fill: gradient.linear(colors.primary, colors.complement),
    [Application for position as developer],
  )]

#v(1em) // ====================================================================

Dear Mr./Ms. from company,

Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor
incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis
nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.
Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu
fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in
culpa qui officia deserunt mollit anim id est laborum.

#v(1em) // ====================================================================

Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor
incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis
nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.
Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu
fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in
culpa qui officia deserunt mollit anim id est laborum.

#v(1em) // ====================================================================

Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor
incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis
nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.
Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu
fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in
culpa qui officia deserunt mollit anim id est laborum.

#v(1em) // ====================================================================

With kind regards,

#image("assets/signature_sample.png", height: 3em)
