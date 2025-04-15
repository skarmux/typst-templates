#import "colors.typ": colors

#let conf(doc) = [
  #set page(paper: "a4", margin: (left: 2.5cm, rest: 2cm), fill: colors.base00)
  #set text( font: "ProFontWindows Nerd Font", size: 11pt, fill: colors.base05, ligatures: false )
  #set list(marker: text(fill: colors.complement)[])
  #doc
]
