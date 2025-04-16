#import "./page.typ": colors
#let glossary = yaml("./glossary.yaml")

#let keyword(icon: none, size: 1.618em, color: colors.complement, content) = {
  set align(horizon)
  if icon == none {
    for (_, subcats) in glossary.pairs() {
      for (_, entries) in subcats.pairs() {
        for entry in entries {
          if entry.at(1) == content {
            icon = entry.at(0)
          }
        }
      }
    }
  }
    stack(
        dir: ltr,
        spacing: 0.5em, 
        box(width: size, text(fill: color, size, icon)), 
        content,
    )
}

#let hl(color: colors.complement) = {
    line(
      length: 100%, 
      stroke: 1pt + gradient.linear(colors.base00, color, colors.base00),
    )
}

#let h5(content) = {
   text(
     size: 2.618em,
     weight: "bold",
     fill: gradient.linear(colors.primary, colors.complement),
     content,
   )
} 

#let h6(content) = {
   text(
     size: 1.618em,
     weight: "bold",
     fill: gradient.linear(colors.primary, colors.complement),
     content,
   )
} 

#let company_header(assets_source) = {
    image("../assets/logo.svg", height: 6em) 
}

#let header(contact) = {
    table(
      columns: (auto, 1fr, 1fr),
      gutter: 1em, 
      stroke: none, 
      align: (x, y) => (left, horizon + center, horizon + left).at(x), 
      stack(
        dir: ttb, 
        spacing: 1em, 
        text(
          size: 25pt, 
          weight: "bold", 
          gradient.linear(colors.primary, colors.complement), 
          contact.name,
        ), 
        text(weight: "bold", contact.profession),
      ), 
      stack(
        dir: ttb, 
        spacing: 1em, 
        keyword(
          icon: ``, 
          align(
            horizon + left, 
            [#contact.street \ #contact.postal #contact.city]
          ),
        ),
      ), 
      stack(
        dir: ttb, 
        spacing: 1em, 
        keyword(
          icon: `󰁥`, 
          link("mailto:" + contact.email)[#contact.email]
        ), 
        keyword(icon: ``, contact.phone),
      ),
    )
}

