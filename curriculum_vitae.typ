#let data = toml("assets/curriculum_vitae_sample.toml")

#import "modules/catppuccin_latte.typ": colors
#import "modules/page_din_5008.typ"

// Accent colors
#colors.insert("primary", colors.mauve)
#colors.insert("complement", colors.lavender)

// ============================================================================

#set text(lang: data.lang)

#let glossary = yaml("assets/glossary.yaml")
#let headers = yaml("assets/curriculum_vitae_headers.yaml")

#set page(paper: "a4", margin: (left: 2.5cm, rest: 2cm), fill: colors.base)
#set text(
  font: "ZurichBT Nerd Font",
  size: 11pt,
  fill: colors.text,
  ligatures: false,
  lang: data.lang,
)
#set list(marker: text(fill: colors.complement)[●])

// Icon and name
#let entry(icon: none, content) = {
  set align(horizon)
  if icon == none {
    for (_, subcats) in glossary.pairs() {
      for (_, entries) in subcats.pairs() {
        for entry in entries {
          if entry.at(1) == content {
            stack(
              dir: ltr,
              spacing: 0.5em,
              text(fill: colors.primary, 12pt, entry.at(0)),
              content,
            )
          }
        }
      }
    }
  } else {
    stack(
      dir: ltr,
      spacing: 0.5em,
      text(fill: colors.primary, 20pt, icon),
      content,
    )
  }
}

// header with contact, pic and personals
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

#table(
  columns: (1fr, auto),
  align: (horizon + center, horizon + center),
  stroke: none,
  stack(
    dir: ttb,
    spacing: 1em,
    entry(
      icon: `󱋊`,
      data.languages.map(lang => [#lang.language#super[#lang.proficiency]])
      .join(text(fill: colors.primary, " | ")),
    ),
    entry(icon: `󰃭`, data.birthdate),
    stack(
      dir: ltr,
      spacing: 2em,
      entry(
        icon: ``,
        link("https://github.com/" + data.social.github)[#data.social.github],
      ),
      entry(icon: ``, link(
        "https://www.linkedin.com/in/" + data.social.linkedin,
      )[#data.social.linkedin]),
      entry(
        icon: ``,
        link(
          "https://www.xing.com/profile/Nils_Harbke/cv" + data.social.xing + "/cv",
        )[#data.social.xing],
      ),
    ),
  ),
  image(data.picture, width: 6em),
)

#[= #text(
    size: 16pt,
    fill: gradient.linear(colors.primary, colors.complement),
    headers.technologies.at(data.lang),
  )]
#v(1em)
#columns(
  3,
  gutter: 1em,
  for (index, pair) in glossary.pairs().enumerate() {
    let (category, subcategories) = pair
    box(
      stack(
        dir: ttb,
        spacing: 0.5em,
        align(center, text(weight: "bold", headers.at(category).at(data.lang))),
        v(0.5em),
        rect(
          inset: 0.75em,
          stroke: 1.5pt + gradient.linear(colors.complement, colors.primary, angle: 45deg),
          radius: 5pt,
          width: 100%,
          subcategories.pairs()
          // Remove empty subcategories
          .filter(elem => {
            elem.at(1).filter(e => {
              for job in data.jobs {
                for h in job.highlights {
                  if e.at(1) == h {
                    return true
                  }
                }
                for t in job.tools {
                  if e.at(1) == t {
                    return true
                  }
                }
              }
              return false
            }).len() > 0
          })
          .map(elem => {
            set text(size: 0.8em)
            let entries = {
              elem.at(1).filter(e => {
                for job in data.jobs {
                  for h in job.highlights {
                    if e.at(1) == h {
                      return true
                    }
                  }
                  for t in job.tools {
                    if e.at(1) == t {
                      return true
                    }
                  }
                }
                return false
              })
            }
            stack(spacing: 0.5em, align(left, text(
              weight: "bold",
              fill: colors.primary,
              headers.at(elem.at(0)).at(data.lang),
            )), entries.map(e => e.at(1)).join("  "))
          }).join(
            line(
              length: 100%,
              stroke: 1pt + gradient.linear(colors.base, colors.complement, colors.base),
            ),
          ),
        ),
      ),
    )
    if (2, 5).contains(index) {
      colbreak()
    } else {
      v(0.5em)
    }
  },
)
#v(1.5em)

#[= #text(
    size: 16pt,
    fill: gradient.linear(colors.primary, colors.complement),
    headers.journey.at(data.lang),
  )]
#v(1em)
#for job in data.jobs {
  box[#grid(
      columns: (-2.5cm, 2.5cm, 1fr),
      gutter: 0em,
      // 1. Column: time range
      align(center)[#stack(
          dir: ttb,
          spacing: 1em,
          align(center)[#job.span.end],
          align(center)[],
          align(center)[#job.span.begin],
        )],
      box(width: 1fr),
      // 2. Column: content
      box(
        width: 1fr,
      )[
        == #job.title #text(fill: colors.primary)[\@] #job.location
        #v(0.5em)
        #stack(
          dir: ltr,
          spacing: 1em,
          ..job.highlights.map(
            tool => rect(
              inset: 0.75em,
              stroke: 1.5pt + gradient.linear(colors.complement, colors.primary, angle: 45deg),
              height: 2em,
              radius: 50%,
            )[
              #entry(tool)
            ],
          ),
        )
        #text(size: 0.8em)[#job.tools.join("  ")]
        #line(
          length: 100%,
          stroke: 1pt + gradient.linear(colors.base, colors.complement, colors.base),
        )
        #box(width: 1fr)[
          #for achievement in job.achievements {
            [- #par(justify: true, achievement)]
            v(0.5em)
          }
        ]
      ],
    )]
  v(1.5em)
}

#box(width: 1fr)[
  #[= #text(
      size: 16pt,
      fill: gradient.linear(colors.primary, colors.complement),
      headers.certificates.at(data.lang),
    )]
  #v(1em)
  #for cert in data.certificates [
    #grid(
      columns: (-2.5cm, 2.5cm, 1fr),
      box(width: 1fr),
      align(center + horizon)[#cert.span.end],
      [== #cert.title
        #cert.location],
      v(0em),
    )
  ]
]
#v(1.5em)

#[= #text(
    size: 16pt,
    fill: gradient.linear(colors.primary, colors.complement),
    headers.activities.at(data.lang),
  )]
#v(1em)
#align(
  center,
  stack(
    dir: ltr,
    spacing: 0.5em,
    ..data.interests.map(
      a => align(
        horizon,
        rect(
          inset: 0.75em,
          stroke: 1.5pt + gradient.linear(colors.complement, colors.primary, angle: 45deg),
          height: 2em,
          radius: 50%,
        )[#a],
      ),
    ),
  ),
)
