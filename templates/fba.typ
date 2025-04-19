
// Benennung der PDF-Datei:
// `Nachname - Vorname - Titel der Arbeit -- Jahr.pdf`

#set page(
  margin: (left: 3cm, rest: 2.5cm),
  number-align: bottom + right,
  // FIXME footer with 1.25cm height
)
#set text(
  font: "Arial",
  size: 12pt,
  lang: "de",
  region: "AT",
)
// Blocksatz, Zeilenabstand 1.5
#set par(justify: true, leading: 1.5em)

// Maximal Gliederungstiefe 3
// Minimum 2 Unterpunkte, Maximum 5
#show heading.where(level: 1): set text(size: 14pt, weight: "bold")
#show heading.where(level: 2): set text(size: 12pt)
#show heading.where(level: 3): set text(size: 12pt)

// Tabellen
// - gemäß Harvard Style ausweisen
// - fortlaufende Nummerierung
// - Tabellen/Abbildungen benennen und Quelle ange-
//   ben (im Fließtext und Literaturverzeichnis). Siehe
//   Kapitel 7 „Erstellen eines Abbildungs- und Tabellen-
//   verzeichnisses“
// TODO

// NOTE:
// Wörtliches Zitat (direkt): (Karmasin, Ribing, 2014, S. 112)
// Sinngemäßes Zitat (indirekt): (vgl. Karmasin, Ribing, 2014, S. 112)
// Fehlende Kenntnisse angeben: (N.N, o.O., o.J./o.Jg., S. 112)


// Deckblatt
#align(center)[
  #text( size: 20pt /* 16-20pt */, weight: "bold")[
    #upper([Arbeitstitel])
  ]
  
  #text(size: 12pt)[
    Untertitel
  ]
  #v(1fr)
  #text(size: 26pt, weight: "bold")[
    Fachbereichsarbeit
  ]
  
  #text(size: 12pt)[
  zur Erlangung des Diploms\
  für den gehobenen Dienst für Gesundheits- und Krankenpflege
  ]
  #v(1fr)
  #text(size: 12pt)[
    Beurteilerin oder (!) Beurteiler\
    Vor- und Zuname
  ]
  #v(1fr)
  #text(size: 12pt)[
    vorgelegt von\
    Vor- und Zuname
  ]
]

#pagebreak()
#set page(numbering: "I")
#set heading(outlined: false)
#counter(page).update(1) // Reset

// Ehrenwörtliche Erklärung
= Ehrenwörtliche Erklärung
#v(2em)
Ich erkläre hiermit, dass ich die vorliegende Arbeit selbständig und ohne Benutzung
anderer als der genannten Materialien angefertigt habe. Alle aus fremden Quellen
direkt oder indirekt übernommenen Gedanken sind als solche kenntlich gemacht.
Außerdem habe ich die Reinschrift der Arbeit einer Korrektur unterzogen.
#v(2em)
Die Arbeit wurde bisher keiner anderen Prüfungskommission vorgelegt. Ich bin
mir bewusst, dass eine falsche Erklärung rechtliche Folgen haben kann.
#v(5em)
Ort, Abgabedatum #h(50%) Unterschrift

#pagebreak()

// (Optional) Vorwort

// (1 Seite) Kurzzusammenfassung (Deutsch) / Abstract (Englisch)
#block(height: 1fr)[
  = Kurzzusammenfassung
  *Problemdarstellung* #lorem(15)\
  *Ziel* #lorem(15)\
  *Methodik* #lorem(15)\
  *Ergebnisse* #lorem(15)\
  *Diskussion bzw. Schlussfolgerung* #lorem(15)\
]
#block(height: 1fr)[
  = Abstract
  *Problem* #lorem(15)\
  *Aim* #lorem(15)\
  *Method* #lorem(15)\
  *Results* #lorem(15)\
  *Conclusion* #lorem(15)\
]

#pagebreak()

// Inhaltsverzeichnis
#show outline.entry.where(level: 1): set text(weight: "bold")
#outline(indent: auto)

#set page(numbering: "1")
#set heading(numbering: "1.1.1", outlined: true)
#counter(page).update(1) // Reset

// (1-2 Seiten) Einleitung
= Einleitung
== Relevanz des Themas
#lorem(50)
== Problemdarstellung
#lorem(35)
== Fragestellung
#lorem(25)
== Ziel der Arbeit
#lorem(20)

#pagebreak()

// (35-40 Seiten) Hauptteil
= Hauptteil
== Begriffsdefinitionen je nach Thematik
#lorem(800)
== Inhaltliche Bearbeitung der Thematik
#lorem(2000)

#pagebreak()

// (1-3 Seiten) Schluss
= Schlussteil
== Zusammenfassende Darstellung des Hauptteils
#lorem(400)
== Beantwortung der Fragestellung als Ergebnis
#lorem(200)
== Diskussion / Schlussfolgerung
#lorem(180)
== Ausblick
#lorem(100)
== Bedeutung für die Praxis
#lorem(300)

#pagebreak()

// Literaturverzeichnis
= Literaturverzeichnis

// (Optional) Anhang
// (Optional) Abbildungsverzeichnis
// (Optional) Tabellenverzeichnis
// (Optional) Abkürzungsverzeichnis

