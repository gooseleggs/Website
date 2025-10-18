module.exports = {
  meta: {
    title: "Smithcave Blog",
    description: "My random thoughts.",
    lang: "en",
    siteUrl: "https://thesmithcave.nz/",
  },
  feed: { // used in feed.xml.njk
    subtitle: "These are my random thoughts",
    filename: "atom.xml",
    path: "/atom.xml",
    id: "https://thesmithcave.nz/",
    authorName: "Kelvin Smith",
  },
  hero: { // used in hero section of main page ie. index.html.njk
    title: "Smithcave blog",
    description: "These are my random thoughts"
  }
}
