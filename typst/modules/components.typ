#import "page.typ": colors
#let glossary = yaml("../assets/glossary.yaml")

#let keyword(icon: none, size: 20pt, color: colors.primary, content) = {
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
        text(fill: color, size, icon), 
        content,
    )
}

#let hl(color: colors.complement) = {
    line(
      length: 100%, 
      stroke: 1pt + gradient.linear(colors.base, color, colors.base),
    )
}

#let headline(content) = {
   text(
     size: 14pt,
     weight: "bold",
     fill: gradient.linear(colors.primary, colors.complement),
     content,
   ) 
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

