#let data = toml("../templates/meeting_protocol.toml")

#import "./modules/page.typ": conf
#import "./modules/colors.typ": colors
#import "./modules/components.typ": company_header, hl, keyword, h6, h5

#show: conf
#set page(numbering: "1 / 1")

//==============================================================================

#table(
  columns: (auto, 1fr, auto),
  gutter: 1em, 
  stroke: none, 
  align: (x, y) => (top+left, top+center, top+right).at(x), 
  stack(
    dir: ttb,
    spacing: 1em,
    ..data.participants.leader.map(p => {
        keyword(icon: "󰆥", size: 1em, p.name)
    }),
    ..data.participants.reporter.map(p => {
        keyword(icon: "󰙏", size: 1em, p.name)
    }),
    ..data.participants.present.map(p => {
        keyword(icon: "", size: 1em, p.name)
    }),
    ..data.participants.absent.map(p => {
        keyword(icon: "󱙝", size: 1em, p.name)
    }),
  ),
  image("./assets/"+data.assets+"/logo.svg", height: 70pt),
  stack(
    dir: ttb,
    spacing: 1em,
    h6([Meeting Protocol]),
    keyword(
        icon: "󰃭", size: 1em, 
        color: colors.text, 
        datetime.today().display("[day].[month].[year]")
    ),
    data.location,
  ),
)

#align(center,h6(data.topic))

#let bubble(content) = {
  rect(
    inset: 0.75em,
    stroke: 1.5pt + gradient.linear(
        colors.complement, 
        colors.primary, 
        angle: 45deg
        ), 
    radius: 5pt, 
    width: 100%, 
    content
  )
}

#let solid(content) = {
  rect(
    inset: 0.75em,
    stroke: 1.5pt + gradient.linear(
        colors.complement, 
        colors.primary, 
        angle: 45deg
        ),
    fill: gradient.linear(
        colors.complement, 
        colors.primary, 
        angle: 45deg
        ),
    radius: 5pt, 
    width: 100%,
    text(fill: colors.base, content)
  )
}

#for item in data.agenda {
   hl()
   h6(item.issue)
   grid(
     columns: 2,
     gutter: 1em,
     ..item.findings.map(f => {
       bubble(keyword(icon:"󰛨",f))
     })
   )
   set list(marker: text(fill: colors.base)[●])
   solid(keyword(icon:"󰙁",color: colors.base, list(..item.decisions)))
   item.tasks.map(f => {
     bubble(
        table(
          columns: (1fr, auto),
          gutter: 1em, 
          stroke: none, 
          inset: 0pt,
          align: (x, y) => (horizon, horizon+right).at(x), 
          keyword(icon:"󰄱",f.desc),
          text(fill: colors.primary, weight: "bold", f.resp)
        )
     )
   }).join()
}

