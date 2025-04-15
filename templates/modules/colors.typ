#let theme-colors = yaml("./colors.yaml")
#let colors = {
  // filter for base16 fields
  let out = (
    base00: none, // base
    base01: none, // mantle
    base02: none, // surface0
    base03: none, // surface1
    base04: none, // surface2
    base05: none, // text
    base06: none, // rosewater
    base07: none, // lavender
    base08: none, // red
    base09: none, // peach
    base0A: none, // yellow
    base0B: none, // green
    base0C: none, // teal
    base0D: none, // blue
    base0E: none, // mauve
    base0F: none, // flamingo
  )
  for (key, _) in out {
    out.insert(key, rgb(theme-colors.at(key)))
  }
  out
}

// set main theme colors
#colors.insert("primary", colors.base0E)
#colors.insert("complement", colors.base07)
