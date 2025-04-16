#let data = toml("data/curriculum_vitae.toml")
#let contact = toml("assets/contact.toml")
#let headers = yaml("i18n/curriculum_vitae.yaml")

//==============================================================================

#set page(paper: "a4")

[name: #contact.name]
[profession: #contact.profession]

