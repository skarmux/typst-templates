#import "themes.typ": themes
#let colors = themes.at(sys.inputs.at("flavor", default: "frappe"))
#colors.insert("accent", colors.at(sys.inputs.at("accent", default: "blue")))

#let icon(glyph, color: colors.accent, size: 1.5em, label: none, content) = box(
  align( horizon)[
    #text(font: "ProFontWindows Nerd Font Mono", fill: color, size, glyph)
    #h(0.5em)
    #if sys.inputs.at("label", default: "false") == "true" and label != none [
      #text(fill: color, weight: "bold")[#label: ]
    ]
    #content
  ]
)

#let glossary = yaml("glossary.yaml")
#let icon_from_glossary(name, color: colors.accent, size: 1.5em, label: none) = {
  let glyph = none
  for (_, subcats) in glossary.pairs() {
    for (_, entries) in subcats.pairs() {
      for entry in entries {
        if entry.at(1) == name {
          glyph = entry.at(0)
          break
        }
      }
      if glyph != none { break }
    }
    if glyph != none { break }
  }
  if glyph == none {
    glyph = `` // fallback
    // panic("could not find icon in glossary", name)
  }
  icon(glyph, color: color, size: size, label: label, name)
}

#let translations = yaml("i18n.yaml")
#let i18n(name) = {
  if text.lang == "en" {
    name // english is a healthy default
  } else {
    translations.at(name).at(text.lang)
  }
}

// Coloring SVG
// Code snippet from: https://github.com/typst/typst/issues/1939#issuecomment-1680154871
#let colorize(svg, color) = {
  let blk = black.to-hex();
  // You might improve this prototypical detection.
  if svg.contains(blk) { 
    // Just replace
    svg.replace(blk, color.to-hex())
  } else {
    // Explicitly state color
    svg.replace("<svg ", "<svg fill=\""+color.to-hex()+"\" ")
  }
}

#let header(contact) = block(
  inset: 1.15em,
  fill: colors.mantle,
  align(horizon, stack(
    dir: ltr,
    stack(
      text(
        size: 2em,
        weight: "bold", 
        fill: colors.accent,
        contact.name,
      ), 
      if sys.inputs.at("label", default: "false") == "true" [
        #text(fill: colors.accent, weight: "bold", "Beruf: ")
        #contact.profession
      ] else { contact.profession },
    ),
    h(1fr),
    stack(
      icon(`󰁥`, label: i18n("Mail"), [#contact.email]),
      icon(``, label: i18n("Location"), [#contact.postal #contact.city]),
    )
  ))
)

#let footer(contact) = block(
  inset: 1.15em,
  fill: colors.mantle,
  align(
    horizon,
    grid(
      columns: (1fr, 1fr),
      gutter: 1.15em,
      if contact.at("homepage", default: none) != none {
        icon(`󰖟`, label: "Homepage", contact.homepage)
      },
      if contact.at("github", default: none) != none {
        icon(``, label: "GitHub", contact.github)
      },
      if contact.at("linkedin", default: none) != none {
        icon(``, label: "LinkedIn", contact.linkedin)
      },
      if contact.at("xing", default: none) != none {
        icon(``, label: "Xing", contact.xing)
      },
    )
  )
)


