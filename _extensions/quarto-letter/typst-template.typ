
// Los gehts
#let quarto-letter(

    title: none,
    logo: none,
    logowidth: none,
    logoascent: none,
    unterschrift: none,
    anhang: none,
    lang: none,
    font: none,
    font-size: none,
    title-size: none,
    paper: none,
    numbering: none,
    number-align: none,
    mtop: none,
    mbottom: none,
    mleft: none,
    mright: none,
    footer-pre: none,
    datum: none,
    sendgraduate: none,
    sendvorname: none,
    sendnachname: none,
    sendstrasse: none,
    sendplz: none,
    sendort: none,
    sendfirstline: none,
    sendtelefon: none,
    sendemail: none,
    sendwww: none,
    aktenzeichen: none,
    betreff: none,
    subjectword: none,
    opening: none,
    closing: none,
    empfaenger: none,
    anlagen: none,




  // Hauptinhalt des Dokuments
  body
) = {

  // Pfade escapen
  //------------------------------------------
  let logo_path = logo.replace("\\", "")
  let sendemail = sendemail.replace("\\", "")
  let sendgraduate = sendgraduate.replace("~", " ")
  let opening = opening.replace("~", " ")
  let betreff = betreff.replace("~", " ")
  let empfaenger = empfaenger.map(e => e.replace("~", " "))
  
  // Farben definieren
  let HSNRblue1 = rgb("185191")
  let HSNRblue2 = rgb("07A1E2")

  // blaue Überschriften

  show heading.where(level: 1): it => block(
    // hellblau bei stufe 2
    text(HSNRblue1)[#it.body
                    #v(5mm)]
  )

  show heading.where(level: 2): it => block(
    // hellblau bei stufe 2
    text(HSNRblue2)[#it.body
                    #v(2mm)]
  )

  show heading.where(level: 3): it => block(
    // hellblau bei stufe 2
    text(HSNRblue2)[#it.body
                    #v(2mm)]
  )


  // Link-Farbe
  show link: set text(fill: rgb("185191"))

  // Seitengröße und -ränder festlegen, Faltmarken einfügen
  set page(
    paper: paper,
    margin: (
        top: mtop,
        bottom: mbottom,
        left: mleft,
        right: mright
    ),
    numbering: numbering,
    number-align: number-align,
    header: align(center)[#image(logo_path, width: logowidth)],
    header-ascent: logoascent,
    footer: align(right)[#text(9pt)[Seite #context counter(page).display("1 von 1", both: true,)]],
    background: {
        //  Set A - should be correct?
        place(top + left, dx: -0cm, line(start: (0%, +10.3cm ), end: (8%, +10.3cm), stroke: (thickness: 0.2pt, paint: black))) 
        place(top + left, dx: -0cm, line(start: (0%, +15.1cm ), end: (6%, +15.1cm), stroke: (thickness: 0.2pt, paint: black)))
        place(top + left, dx: -0cm, line(start: (0%, +20.5cm ), end: (8%, +20.5cm), stroke: (thickness: 0.2pt, paint: black)))
        //  Set B - experimental
        // place(top + left, dx: -0cm, line(start: (0%, 50mm  ), end: (4%, 50mm), stroke: (thickness: 0.1pt,paint: red)))
        // place(top + left, dx: -0cm, line(start: (0%, 50%   ), end: (6%, 50%), stroke: (thickness: 0.1pt,paint: red)))
        // place(top + left, dx: -0cm, line(start: (0%, 155mm ), end: (4%, 155mm), stroke: (thickness: 0.1pt,paint: red)))
    }
  )

  v(15mm) //insgesamt 40mm Abstand vom Rand
  
  // Adressfelder
  //-------------
  grid(columns: (1fr, 1fr),
       align: (left, right),

       // Empfängerin
       //------------
       box()[#underline()[#text(7pt)[#sendvorname #sendnachname | #sendstrasse | #sendplz #sendort]]
             #v(-1mm)
             #h(5mm)
             #box()[
                    #text(11pt)[
                      #for e in empfaenger [
                            #e #v(-2mm)
                            ]
                        ]
                   ]

            ],

       // Absender
       //---------
       box()[#align(right)[
                           #text(11pt, weight: "extrabold")[#sendgraduate #sendvorname #sendnachname]
                           #v(-3mm)
                           #text(8pt, weight: "bold")[#sendfirstline]
                           #v(1mm)
                           #text(8pt)[#sendstrasse]
                           #v(-4mm)
                           #text(8pt)[#sendplz] #text(8pt)[#sendort]
                           #v(-1mm)
                           #if sendtelefon != "" [
                            #text(8pt)[Telefon: #sendtelefon]
                           ]
                           #v(-2mm)
                           #if sendemail != "" [
                            #text(8pt)[#sendemail]
                           ]
                           #v(-3mm)
                           #if sendwww != "" [
                            #text(8pt)[#sendwww]
                           ]
                           #linebreak()
                           #if aktenzeichen != "" [
                              #text(8pt)[Aktenzeichen: #aktenzeichen]
                           ]
                           #v(-3mm)
                           #text(8pt)[Datum: #datum]
                           ]
            ]
       )
  //----------------------
  //---- Ende Adressfelder


  // Abstand
  v(15mm)

  // Betreff
  text(12pt, weight: "bold")[#subjectword: #betreff]

  v(5mm)

  text()[#opening]

  // Abstand
  v(5mm)

  // Hauptteil des Dokuments
  // Blocksatz verwenden?
  // set par(justify: true)
  body

  // Abstand
  v(5mm)

  block[#text()[#closing]]

  if unterschrift != none [
    #let unterschrift = unterschrift.replace("\\", "")
    #image(unterschrift, width: 40mm)
    #v(-6mm)
  ] else [#v(6mm)]

  block[#text()[#sendgraduate #sendvorname #sendnachname]]

  v(5mm)

  if anlagen != none [
    #if type(anlagen) == str [  // a single attachment
      #text(11pt)[Anlage:
      - #anlagen
      ]
    ] else if type(anlagen) == array [                      // multiple attachments. also handles empty entries in the list.
      #text(11pt)[Anlagen(n):
        #for a in anlagen [
          #if a != "" [
            - #a
          ]
        ]
      ]
    ]
  ]
}
