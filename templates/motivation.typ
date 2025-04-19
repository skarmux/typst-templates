#import "modules/components.typ": colors, icon, i18n, colorize, header, footer

#let data = toml("data/motivation.toml")
#let company = data.company
#let contact = data.contact

#set page( paper: "a4", margin: 0cm, fill: colors.base )
#set stack(spacing: 1.15em)
#set text(
  font: "Arial",
  size: 11pt,
  ligatures: false,
  fill: colors.text,
  lang: sys.inputs.at("lang", default: "en")
)

#context [
  #header(contact)
  
  #block(inset: (left: 2.5cm, right: 2cm))[
    #text(fill: colors.yellow, weight: "bold", company.company)\
    #icon(``, label: i18n("Name"), [#company.contact])\
    #icon(`󰁥`, label: i18n("Mail"), [#company.email])\
    #icon(``, label: i18n("City"), [#company.postal #company.city])\

    #let cat = colorize(read("assets/catppuccin_footer.svg"), colors.text)
    #align(center, image.decode(cat))

    #align(right)[#contact.city, #data.date]

    #text(size: 14pt, fill: colors.accent, weight: "bold",
    if text.lang == "en" [
        Motivational Letter
    ] else if text.lang == "de" [
        Motivationsschreiben
    ] else { panic("translation for your language not available", text.lang) }
    )

    #company.interest,
    #company.qualification,
    #company.conclusion,

    #let signature = colorize(read("assets/signature.svg"), colors.yellow)
    #image.decode(signature, height: 3em)
  ]

  #place(bottom, footer(contact))
]
