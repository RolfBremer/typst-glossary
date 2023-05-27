// Copyright 2023 Rolf Bremer, Jutta Klebe

// gls[term]: Marks a term in the document as referenced.
// gls(glossary-term)[term]: Marks a term in the document as referenced with a
// different expression ("glossary-term") in the glossary.

// To ensure that the marked entries are displayed properly, it is also required
// to use a show rule, like the following:
// #show figure.where(kind: "jkrb_glossary"): it => {it.body}

// We use a figure element to store the marked text and an optional
// reference to be used to map to the glossary. If the latter is empty, we use the body
// for the mapping.
#let gls(entry: none, display) = figure(display, caption: entry, numbering: none, kind: "jkrb_glossary")

#let figure-title(figure) = {
    let ct = ""
    if figure.caption == none {
        if figure.body.has("text") {
            ct = figure.body.text
        }
        else {
            for cc in figure.body.children {
                if cc.has("text") {
                    ct += cc.text
                }
            }
        }
    }
    else{
        ct = figure.caption.text
    }
    return ct
}

// This function creates a glossary page with entries for every term
// in the document marked with `gls[term]`.
#let make-glossary(
    // The glossary data.
    glossary,

    // Indicate missing entries.
    missing: text(fill: red, weight: "bold")[ No glossary entry ],

    // Function to format the Header of the entry.
    heading: it => { heading(level: 2, numbering: none, outlined: false, it)}
    ) = {
    locate(loc => {
        let words = ()  //empty array
        let elements = query(figure.where(kind: "jkrb_glossary"), loc)
        let titles = elements.map(e => figure-title(e)).sorted()
        for t in titles {
            if words.contains(t) { continue }
            words.push(t)
            heading(t)
            if not glossary == none {
                if glossary.keys().contains(t) {
                    glossary.at(t).description
                    if glossary.at(t).keys().contains("link") {
                        glossary.at(t).link
                    }
                } else {
                    missing
                }
            }
        }
    })
}