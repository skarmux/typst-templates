#let data = toml("./data.toml")
#let contact = toml("./assets/contact.toml")

#import "./modules/page.typ": conf
#import "./modules/colors.typ": colors
#import "./modules/components.typ": header, hl, keyword, h6

#show: conf

//==============================================================================

#header(contact)

#hl()

#v(1fr)

#align(
    right,
    datetime.today().display(
        contact.city + ", [day].[month].[year]"
    )
)

#h6(data.headline)

#v(1em)

#stack(
    dir: ttb,
    spacing: 2em,
    data.interest,
    data.qualification,
    data.conclusion,
    image("./assets/"+data.assets+"/signature.png", height: 3em)
)

