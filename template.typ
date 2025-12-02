// Some definitions presupposed by pandoc's typst output.
#let blockquote(body) = [
  #set text( size: 0.92em )
  #block(inset: (left: 1.5em, top: 0.2em, bottom: 0.2em))[#body]
]

#let horizontalrule = [
  #line(start: (25%,0%), end: (75%,0%))
]

#let endnote(num, contents) = [
  #stack(dir: ltr, spacing: 3pt, super[#num], contents)
]

#show terms: it => {
  it.children
    .map(child => [
      #strong[#child.term]
      #block(inset: (left: 1.5em, top: -0.4em))[#child.description]
      ])
    .join()
}

// Some quarto-specific definitions.

#show raw.where(block: true): set block(
    fill: luma(230),
    width: 100%,
    inset: 8pt,
    radius: 2pt
  )

#let block_with_new_content(old_block, new_content) = {
  let d = (:)
  let fields = old_block.fields()
  fields.remove("body")
  if fields.at("below", default: none) != none {
    // TODO: this is a hack because below is a "synthesized element"
    // according to the experts in the typst discord...
    fields.below = fields.below.amount
  }
  return block.with(..fields)(new_content)
}

#let empty(v) = {
  if type(v) == "string" {
    // two dollar signs here because we're technically inside
    // a Pandoc template :grimace:
    v.matches(regex("^\\s*$")).at(0, default: none) != none
  } else if type(v) == "content" {
    if v.at("text", default: none) != none {
      return empty(v.text)
    }
    for child in v.at("children", default: ()) {
      if not empty(child) {
        return false
      }
    }
    return true
  }

}

// Subfloats
// This is a technique that we adapted from https://github.com/tingerrr/subpar/
#let quartosubfloatcounter = counter("quartosubfloatcounter")

#let quarto_super(
  kind: str,
  caption: none,
  label: none,
  supplement: str,
  position: none,
  subrefnumbering: "1a",
  subcapnumbering: "(a)",
  body,
) = {
  context {
    let figcounter = counter(figure.where(kind: kind))
    let n-super = figcounter.get().first() + 1
    set figure.caption(position: position)
    [#figure(
      kind: kind,
      supplement: supplement,
      caption: caption,
      {
        show figure.where(kind: kind): set figure(numbering: _ => numbering(subrefnumbering, n-super, quartosubfloatcounter.get().first() + 1))
        show figure.where(kind: kind): set figure.caption(position: position)

        show figure: it => {
          let num = numbering(subcapnumbering, n-super, quartosubfloatcounter.get().first() + 1)
          show figure.caption: it => {
            num.slice(2) // I don't understand why the numbering contains output that it really shouldn't, but this fixes it shrug?
            [ ]
            it.body
          }

          quartosubfloatcounter.step()
          it
          counter(figure.where(kind: it.kind)).update(n => n - 1)
        }

        quartosubfloatcounter.update(0)
        body
      }
    )#label]
  }
}

// callout rendering
// this is a figure show rule because callouts are crossreferenceable
#show figure: it => {
  if type(it.kind) != "string" {
    return it
  }
  let kind_match = it.kind.matches(regex("^quarto-callout-(.*)")).at(0, default: none)
  if kind_match == none {
    return it
  }
  let kind = kind_match.captures.at(0, default: "other")
  kind = upper(kind.first()) + kind.slice(1)
  // now we pull apart the callout and reassemble it with the crossref name and counter

  // when we cleanup pandoc's emitted code to avoid spaces this will have to change
  let old_callout = it.body.children.at(1).body.children.at(1)
  let old_title_block = old_callout.body.children.at(0)
  let old_title = old_title_block.body.body.children.at(2)

  // TODO use custom separator if available
  let new_title = if empty(old_title) {
    [#kind #it.counter.display()]
  } else {
    [#kind #it.counter.display(): #old_title]
  }

  let new_title_block = block_with_new_content(
    old_title_block, 
    block_with_new_content(
      old_title_block.body, 
      old_title_block.body.body.children.at(0) +
      old_title_block.body.body.children.at(1) +
      new_title))

  block_with_new_content(old_callout,
    block(below: 0pt, new_title_block) +
    old_callout.body.children.at(1))
}

// 2023-10-09: #fa-icon("fa-info") is not working, so we'll eval "#fa-info()" instead
#let callout(body: [], title: "Callout", background_color: rgb("#dddddd"), icon: none, icon_color: black) = {
  block(
    breakable: false, 
    fill: background_color, 
    stroke: (paint: icon_color, thickness: 0.5pt, cap: "round"), 
    width: 100%, 
    radius: 2pt,
    block(
      inset: 1pt,
      width: 100%, 
      below: 0pt, 
      block(
        fill: background_color, 
        width: 100%, 
        inset: 8pt)[#text(icon_color, weight: 900)[#icon] #title]) +
      if(body != []){
        block(
          inset: 1pt, 
          width: 100%, 
          block(fill: white, width: 100%, inset: 8pt, body))
      }
    )
}


// Los gehts
#let quarto-letter(

    title: none,
    logo: none,
    logowidth: none,
    logoascent: none,
    unterschrift: none,
    anhang: none,
    lang: none,
    fontname: none,     // preferred safe name for font
    fontsize: none,     // preferred safe name for font size
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
  
// map YAML keys to safe internal names (accept both `fontname` and legacy `font`, and `fontsize` and legacy `font-size`)
let actual_fontname = if fontname != none { fontname } else if font != none { font } else { none }
let actual_fontsize = if fontsize != none { fontsize } else if `font-size` != none { `font-size` } else { 11pt }

// produce a Typst font object and size (safe because `font` builtin is not shadowed)
let main_font = if actual_fontname != none { font(actual_fontname) } else { none }
let main_font_size = actual_fontsize

set text(
  font: main_font,
  size: main_font_size
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

#show: quarto-letter.with(

    title: "",
    lang: "de",
    logo: "\_extensions/quarto-letter/blanklogo.png",
          unterschrift: "\_extensions/quarto-letter/Unterschrift.png",
        empfaenger: ("Donald Duck", "1375 East Buena Vista Drive", "32830 Lake Buena Vista, Florida", "United States"),
    logowidth: 90mm,
    logoascent: 0mm,
    anhang: "",
    fontname: "Inter",
    fontsize: 11pt,
        paper: "a4",
    numbering: "1.",
    number-align: center,
    mtop: 35mm,
    mbottom: 30mm,
    mright: 20mm,
    mleft: 20mm,
    footer-pre: "Seite",
    datum: "24.12.2022",
    sendgraduate: "",
    sendvorname: "Julio S.",
    sendnachname: "Solís Arce",
    sendstrasse: "1737 Cambridge Street",
    sendplz: "2138",
    sendort: "Cambridge, MA",
    sendfirstline: "Harvard University",
    sendtelefon: "+1 617-495-2097",
    sendemail: "jsolisarce\@g.harvard.edu",
    sendwww: "juliosolisar.github.io",
    aktenzeichen: "22-A-01",
    betreff: "Application to Fellowship",
    subjectword: "Betreff",
    opening: "Dear Sir or Madam,",
    closing: "Best,",
          anlagen: ("Resume", "Cover Letter"),
    )

#lorem(100)
#lorem(100)




