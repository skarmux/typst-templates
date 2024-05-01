#let data = toml("../templates/curriculum_vitae.toml")
#let contact = toml("./assets/"+data.assets+"/contact.toml")
#let glossary = yaml("./assets/glossary.yaml")
#let headers = yaml("./curriculum_vitae_translations.yaml")

#import "./modules/page.typ": conf
#import "./modules/colors.typ": colors
#import "./modules/components.typ": header, hl, keyword, h6

#show: conf
#set par(justify: true)

//==============================================================================

#header(contact)

#table(
  columns: (1fr, auto),
  align: (horizon + center, horizon + center), 
  stroke: none, 
  stack(
    dir: ttb, 
    spacing: 1em, 
    keyword(
      icon: `󱋊`, 
      data.languages.map(lang => [#lang.language#super[#lang.proficiency]])
        .join(text(fill: colors.primary, " | ")),
    ), 
    stack(
      dir: ltr, 
      spacing: 2em, 
      keyword(
        icon: ``, 
        link(
          "https://github.com/" + data.social.github
        )[#data.social.github],
      ), 
      keyword(
        icon: ``, 
        link(
          "https://www.linkedin.com/in/" + data.social.linkedin,
        )[#data.social.linkedin]), 
      keyword(
        icon: ``, 
        link(
          "https://www.xing.com/profile/" + data.social.xing + "/cv",
        )[#data.social.xing],
      ),
    ),
  ),
  image("./assets/"+data.assets+"/profile.gif", width: 6em),
)

= #h6(headers.technologies.at("de"))
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
        align(
          center, 
          text(weight: "bold", headers.at(category).at("de"))
          ), 
        v(0.5em), 
        rect(
          inset: 0.75em, 
          stroke: 1.5pt + gradient.linear(
            colors.complement, 
            colors.primary, 
            angle: 45deg
            ), 
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
          .map(
            elem => {
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
              stack(
                spacing: 0.5em, align(
                  left, text(
                    weight: "bold", 
                    fill: colors.primary, 
                    headers.at(elem.at(0)).at("de"),
                  ),
                ), entries.map(e => e.at(1)).join("  "),
              )
            },
          ).join(hl()),
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

= #h6(headers.journey.at("de"))
#v(1em)
#for job in data.jobs {
  box[#grid(
      columns: (-2.5cm, 2.5cm, 1fr), gutter: 0em,
      // 1. Column: time range
      align(
        center,
      )[#stack(
          dir: ttb, 
          spacing: 1em, 
          align(center)[#job.span.end], 
          align(center)[], 
          align(center)[#job.span.begin],
        )], box(width: 1fr),
      // 2. Column: content
      box(
        width: 1fr,
      )[
        == #job.title #text(fill: colors.primary)[\@] #job.location
        #v(0.5em)
        #stack(
          dir: ltr, spacing: 1em, ..job.highlights.map(
            tool => rect(
              inset: 0.75em, 
              stroke: 1.5pt + gradient.linear(
                colors.complement, 
                colors.primary, 
                angle: 45deg
                ), 
              height: 2em, 
              radius: 50%,
            )[
              #keyword(size:11pt, tool)
            ],
          ),
        )
        #text(size: 0.8em)[#job.tools.join("  ")]
        #line(
          length: 100%, 
          stroke: 1pt + gradient.linear(
            colors.base, 
            colors.complement, 
            colors.base
            ),
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

#box(
  width: 1fr,
)[
  = #h6(headers.certificates.at("de"))
  #v(1em)
  #for cert in data.certificates [
    #grid(
      columns: (-2.5cm, 2.5cm, 1fr), 
      box(width: 1fr), 
      h(1fr), 
      [*#cert.title*\ #cert.location], 
      v(0em)
    )
  ]
]
#v(1.5em)

= #h6(headers.activities.at("de"))
#v(1em)
#align(
  center, stack(
    dir: ltr, 
    spacing: 1em, 
    ..data.interests.map(
      a => align(
        horizon, 
        rect(
          inset: 0.75em, 
          stroke: 1.5pt + gradient.linear(
            colors.complement, 
            colors.primary, 
            angle: 45deg
          ), 
          height: 2em,
          radius: 50%,
        )[#a],
      ),
    ),
  ),
)
