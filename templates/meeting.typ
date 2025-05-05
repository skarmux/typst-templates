#let data = toml("data/meeting.toml")

#import "modules/components.typ": colors, colorize, i18n, icon, icon_from_glossary

#set page(
  paper: "a4",
  margin: (left: 2.5cm, rest: 2cm),
  numbering: "1 / 1",
  fill: colors.base,
)
#set text(
  font: "FiraCode Nerd Font Propo Ret",
  size: 11pt,
  ligatures: false,
  fill: colors.text,
)
#set stack(spacing: 1.15em)
#show heading.where(level: 1): set text(fill: colors.accent)
#show heading.where(level: 2): set text(fill: colors.accent)

#for p in data.meeting.participants {
  if "role" not in p [
    #icon(` `, p.name)\
  ]
  else if p.role == "log" [
    #icon(`󰙏`, color: colors.green, p.name)\
  ]
  else if p.role == "mod" [
    #icon(`󰆥`, color: colors.yellow, p.name)\
  ]
}

#place(top+right, [
  #let today = datetime.today().display("[day].[month].[year]")
  #icon(`󰃭`, today)
  
  #data.meeting.room
])

#let logo = colorize(read("assets/logo.svg"), colors.accent)
#place(top+center, image.decode(logo, height: 2.5cm))

#align(center, [= #data.meeting.topic])

#let bubble(color: colors.accent, content) = rect(
  inset: 0.75em,
  stroke: 1.5pt + color,
  radius: 5pt, 
  width: 100%, 
  content
)

#data.meeting.agendas.map(item => [
   == #item.issue
   #grid(
     columns: 2,
     gutter: 1em,
     ..item.findings.map(f => {
       bubble(
         color: colors.yellow,
         icon(`󰛨`, color: colors.yellow, f)
       )
     })
   )
   #set list(marker: text(fill: colors.accent)[●])
   #bubble(
     color: colors.accent,
     icon(`󰙁`, color: colors.accent, box(list(..item.decisions)))
   )
   #item.tasks.map(f => {
     bubble(
       color: colors.green,
        table(
          columns: (1fr, auto),
          gutter: 1em, 
          stroke: none, 
          inset: 0pt,
          align: (x, y) => (horizon, horizon+right).at(x), 
          icon(`󰄱`, color: colors.green, f.description),
          text(fill: colors.green, weight: "bold", f.responsible)
        )
     )
   }).join()
]).join(line(length: 100%, stroke: (paint: colors.mantle, thickness: 1.5pt, cap: "round")))
