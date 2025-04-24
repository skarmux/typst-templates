#let data = toml("data/cv.toml")

#import "modules/components.typ": colors, i18n, icon, icon_from_glossary, header, footer

#set par(justify: true)
#set list(
  body-indent: 1.618em,
  marker: text(fill: colors.accent)[ ],
  spacing: 1.618em,
)
#set text(
  // font: "ProFontWindows Nerd Font",
  font: "Arial",
  fill: colors.text,
  lang: sys.inputs.at("lang", default: "en")
)
#set stack(spacing: 1.15em)
#set page(
  fill: colors.base,
  margin: (left: 2cm, right: 2cm, top: 2cm, bottom: 2cm),
)
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

  #block()[
    = #i18n("Professional Experience")
    #for job in data.jobs [
      == #job.title #h(1fr) #job.location
      #job.span.duration  #job.span.begin -- #job.span.end
      #block(breakable: false)[
        === #i18n("Tools")
        #for tool in job.tools {
          box(inset: (right: 1.15em / 2), rect(
            inset: (left: 1.15em / 3, right: 1.15em / 3),
            // outset: (right: 1.15em),
            stroke: 1.5pt + colors.mantle,
            radius: 25%,
            icon_from_glossary(color: colors.red, tool)
          ))
        }
      ]
      #block(breakable: false)[
        === #i18n("Accomplishments")
        #for achievement in job.achievements [- #achievement.trim()]
      ]
      #line(length: 100%, stroke: (paint: colors.mantle, thickness: 1.5pt, cap: "round"))
    ]
  ]

  #block(breakable: false)[
    = #i18n("Certificates")
    #for cert in data.certificates [
      == #cert.location
      #text(fill:colors.green)[#i18n("Institution"):] #cert.title
    ]
  ]

  #line(length: 100%, stroke: (paint: colors.mantle, thickness: 1.5pt, cap: "round"))

  #block(breakable: false)[
    = #i18n("Languages")
    #for lang in data.languages [
      == #lang.language
      #text(fill:colors.green)[#i18n("Proficiency"):] #lang.proficiency
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
