#import "page.typ": colors
#let glossary = yaml("../assets/glossary.yaml")

#let keyword(icon: none, size: 1em, color: colors.complement, content) = {
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
        box(width: 1.1em, text(fill: color, size, icon)), 
        content,
    )
}

#let hl(color: colors.complement) = {
    line(
      length: 100%, 
      stroke: 1pt + gradient.linear(colors.base, color, colors.base),
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
    image("../assets/"+assets_source+"/logo.svg", height: 6em) 
}

#let header(profile) = {
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
          profile.name,
        ), 
        text(weight: "bold", profile.profession),
      ), 
      stack(
        dir: ttb, 
        spacing: 1em, 
        keyword(
          icon: ``, 
          align(
            horizon + left, 
            [#profile.street \ #profile.postal #profile.city]
          ),
        ),
      ), 
      stack(
        dir: ttb, 
        spacing: 1em, 
        keyword(
          icon: `󰁥`, 
          link("mailto:" + profile.email)[#profile.email]
        ), 
        keyword(icon: ``, profile.phone),
      ),
    )
}

