#let data = toml("../templates/motivational_letter.toml")
#let contact = toml("./assets/"+data.assets+"/contact.toml")

#import "./modules/page.typ": conf
#import "./modules/colors.typ": colors
#import "./modules/components.typ": header, hl, keyword, headline

#show: conf

//==============================================================================

#include "../../modules/header.typ"

#hl()

#v(1fr)

#align(
    right,
    datetime.today().display(
        contact.city + ", [day].[month].[year]"
    )
)

#headline(data.headline)

#v(1em)

#stack(
    dir: ttb,
    spacing: 2em,
    data.interest,
    data.qualification,
    data.conclusion,
    image("./assets/"+data.assets+"/signature.png", height: 3em)
)

