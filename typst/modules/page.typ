#import "colors.typ": colors

#let conf(doc) = [
    #set page(
        paper: "a4", 
        margin: (left: 2.5cm, rest: 2cm),
        fill: colors.base,
    )
    #set text(
        font: "ZurichBT Nerd Font",
        size: 11pt,
        fill: colors.text,
        ligatures: false,
    )
    #set list(marker: text(fill: colors.complement)[●])
    #doc
]
