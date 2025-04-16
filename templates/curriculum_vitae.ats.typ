#let data = toml("data.toml")
#let contact = toml("assets/contact.toml")
#let headers = yaml("lang.yaml")

//==============================================================================

#set page(paper: "a4")

[name: #contact.name]
[profession: #contact.profession]

