#import "modules/components.typ": colors, icon, i18n, colorize, header, footer

#let data = toml("data/application.toml")
#let company = data.company
#let contact = data.contact

#set page( paper: "a4", margin: 0cm, fill: colors.base )
#set stack(spacing: 1.15em)
#set text(
  font: "FiraCode Nerd Font Propo Ret",
  size: 11pt,
  ligatures: false,
  fill: colors.text,
  lang: sys.inputs.at("lang", default: "en")
)

#context [
  #header(contact)
  
  #block(inset: (left: 2.5cm, right: 2cm))[
    #stack(spacing: 1.15em,
      text(fill: colors.yellow, weight: "bold", company.company),
      icon(``, label: i18n("Name"), [#company.contact]),
      icon(`󰁥`, label: i18n("Mail"), [#company.email]),
      icon(``, label: i18n("City"), [#company.postal #company.city]),
    )

    #let cat = colorize(read("assets/catppuccin_footer.svg"), colors.text)
    #align(center, image.decode(cat))

    #align(right)[#contact.city, #data.date]

    #text(size: 14pt, fill: colors.accent, weight: "bold", if text.lang == "en" [
      Application for the open position as #company.vacancy
    ] else if text.lang == "de" [
      Bewerbung auf die Stelle als #company.vacancy
    ] else { panic("translation for your language not available", text.lang) }
    )

    #company.application

    #let signature = colorize(read("assets/signature.svg"), colors.yellow)
    #image.decode(signature, height: 3em)
  ]

  #place(bottom, footer(contact))
]
