#let data = toml("data/cv.toml")

#import "modules/components.typ": colors, i18n, icon, icon_from_glossary, header, footer

#set par(justify: true)
#set list(
  body-indent: 1.618em,
  marker: text(fill: colors.accent)[  ],
  spacing: 1.618em,
)
#set text(
  font: "FiraCode Nerd Font Propo Ret",
  fill: colors.text,
  lang: sys.inputs.at("lang", default: "en")
)
#set stack(spacing: 1.15em)
#set page(
  fill: colors.base,
  margin: (left: 2cm, right: 2cm, top: 2cm, bottom: 2cm),
)
#show heading: set block(below: 1.15em, above: 1.15em)
#show heading.where(level: 1): set text(fill: colors.accent)
#show heading.where(level: 2): set text(fill: colors.yellow)
#show heading.where(level: 3): set text(fill: colors.green)

#context [

  #place(
    dx: -2cm,
    dy: -2cm,
    block(
      width: 100% + 4cm,
      header(data.contact)
    )
  )
  // Add additional height of the header to the page margin
  // and add an empty line space on top. No idea why there
  // needs to be 2-times the empty line spaceng of 1.15em
  #v(2cm - measure(header(data.contact)).height + 2 * 1.15em)

  #let render-job(job) = [
    == #job.title #h(1fr) #job.location
    #job.span.duration  #job.span.begin -- #job.span.end
    #block(breakable: false)[
      ===  #i18n("Tools")
      #for tool in job.tools {
        box(inset: (right: 1.15em / 2), rect(
          inset: (left: 1.15em / 3, right: 1.15em / 3),
          // outset: (right: 1.15em),
          stroke: 1.5pt + colors.mantle,
          radius: 25%,
          icon_from_glossary(baseline: -2pt, color: colors.red, tool)
        ))
      }
    ]
    ===  #i18n("Accomplishments")
    // Prevent linebreak inside `C++`:
    // https://github.com/typst/typst/issues/1941
    #show "C++": box[C++]
    #for achievement in job.achievements [- #achievement.trim()]
  ]
  #let hline() = line(length: 100%, stroke: (paint: colors.mantle, thickness: 1.5pt, cap: "round"))

  = #i18n("Professional Experience")
  #data.jobs.map(render-job).join(hline())

  #let render-project(project) = [
    #block(breakable: false)[
      #grid(
        columns: (1fr, auto),
        box()[
          == #project.title
          // #project.span.duration  #project.span.begin -- #project.span.end
          #if project.at("url", default: none) != none { icon(``, baseline: -1pt, project.url) }

          #if project.at("github", default: none) != none { icon(`󰊤`, baseline: -1pt, project.github) }

          ===  #i18n("Tools")
          #for tool in project.tools {
            box(inset: (right: 1.15em / 2), rect(
              inset: (left: 1.15em / 3, right: 1.15em / 3),
              // outset: (right: 1.15em),
              stroke: 1.5pt + colors.mantle,
              radius: 25%,
              icon_from_glossary(baseline: -2pt, color: colors.red, tool)
            ))
          }
        ],
        if project.at("image", default: none) != none {
          box(
            stroke: 1.5pt + colors.mantle,
            clip: true, radius: 1em, image(
              height: 8em,
              project.image
            )
          )
        }
      )
      ===  #i18n("Description")
      // Prevent linebreak inside `C++`:
      // https://github.com/typst/typst/issues/1941
      #show "C++": box[C++]
      #for achievement in project.achievements [- #achievement.trim()]
    ]
  ]

  #v(2.3em)

  = #i18n("Personal Projects")
  #data.projects.map(render-project).join(hline())

  #v(2.3em)

  #block(breakable: false)[
    = #i18n("Certificates")
    #for cert in data.certificates [
      == #cert.title #h(1fr) #cert.span.end
      #cert.location
    ]
  ]

  #v(2.3em)

  #block(breakable: false)[
    = #i18n("Languages")
    #for lang in data.languages [
      == #lang.language
      #i18n("Proficiency"): #lang.proficiency
    ]
  ]

  #place(
    bottom,
    dx: -2cm,
    dy: +2cm,
    block(
      width: 100% + 4cm,
      footer(data.contact)
    )
  )
]
