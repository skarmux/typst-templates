#let data = toml("../templates/application_letter.toml")
#let contact = toml("./assets/"+data.assets+"/contact.toml")

#import "./modules/page.typ": conf
#import "./modules/colors.typ": colors
#import "./modules/components.typ": header, hl, keyword, h6

#show: conf

//==============================================================================

#header(contact)

#hl()

#stack(
  dir: ttb,
  spacing: 1em,
  keyword(icon: ``, [#data.contact]),
  keyword(icon: ``, [*#data.company*\ #data.street\ #data.postal #data.city]),
  keyword(icon: `󰁥`, link("mailto:" + data.mail)[#data.mail]),
  keyword(icon: ``, [#data.phone]),
)

#align(right, datetime.today().display(contact.city + ", [day].[month].[year]"))

#h6([Bewerbung auf die Stelle als #data.vacancy])

#v(1em)

#data.content

#image("./assets/"+data.assets+"/signature.png", height: 3em)
