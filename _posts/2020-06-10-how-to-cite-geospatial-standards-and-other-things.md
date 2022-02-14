---
title: How to cite geospatial standards and other GIS things
excerpt: "I found a template for manging ISO and OGC standards as Bibtex entries. This may be useful for citing documents that are not indexed by Google Scholar or if Mendeley can't find a DOI for the PDF document."
categories: [Analysis]
tags: [bibliography,bibtex,standards,iso/iec,ogc,gis,geospatial]
---

Nowadays, there are tons of tools for managing and formating your references, some of the most useful options are to use Google Scholar for **reference management** and Mendeley (desktop+web) for **document management** (mostly for PDFs). I use the GS for getting Bibtex or APA7 formated references when I don't need to reread the document or Mendeley when it's a document I would like to keep.

These tools were practical enough since this year I started using Zotero and Cablibre for managing my collections of papers and digital books. I will share a few toughts of this in a future post.

Right now, I'm mostly interested in having a complete Bibtex database for my references and this can be done by using any of the previous solutions (FOSS or not). However, there are certain specific ocasions where you can't find an already formated reference in GS or there is no DOI code that can be used by Mendeley or Zotero to compile the Bibtex entry. In those ocasions you need to do it the old way...


## Can't found a Bibtex entry in the previous options?

This was the case when I was trying to cite ISO and OGC standards for a paper (these don't have DOI or ISBN). As usual in life, many people share the same problem you have. Ismael Olea shares a solution in [this post](https://olea.org/diario/2018/10/19/how_to_cite_ISO_standards.html). This is how the SQL standard looks like following his suggestions:

```tex
@techreport{iso_sql_2016,
  address = {Geneva, CH},
  type = {Standard},
  title = {Information technology -- {Database} languages -- SQL -- {Part} 1: {Framework}},
  shorttitle = ISO/IEC 9075-1:2016,
  url = {https://www.iso.org/standard/63555.html},
  language = {en},
  number = ISO/IEC TR 9075-1:2016,
  institution = {International Organization for Standardization},
  author = {ISO Central Secretary},
  year = {2016}
}
```

I think it would be useful to keep a repository of those documents and items that are not usually cited. I appreciate VERY MUCH the way GS, Mendeley, Calibre and Zotero help us with these arduous tasks. 

{: .notice--info}
**A small tip:** Did you know that Calibre helps you in finding metadata for PDF books? It even downloads the covers from Amazon!!! You should try it ;)

