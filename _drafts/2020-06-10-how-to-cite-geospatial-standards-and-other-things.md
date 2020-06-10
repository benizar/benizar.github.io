---
title: How to cite geospatial standards and other GIS things
categories: [Analysis]
tags: [bibliography,bibtex,standards,iso/iec,ogc,gis,geospatial]
---


https://olea.org/diario/2018/10/19/how_to_cite_ISO_standards.html

For my final post-grade work I’m collecting bibliography and as the main work is around ISO/IEC documents I investigated how to to make a correct bibliography entry for these, which I realized is not very well known as you can check in this question in Tex.StackSchange.com.

I finally chose an style I show here as an example:

BibTeX:

```bibtex
@techreport{iso_central_secretary_systems_2016,
  address = {Geneva, CH},
  type = {Standard},
  title = {Systems and software engineering -- {Lifecycle} profiles for {Very} {Small} {Entities} ({VSEs}) -- {Part} 1: {Overview}},
  shorttitle = {{ISO}/{IEC} {TR} 29110-1:2016},
  url = {https://www.iso.org/standard/62711.html},
  language = {en},
  number = {ISO/IEC TR 29110-1:2016},
  institution = {International Organization for Standardization},
  author = {{ISO Central Secretary}},
  year = {2016}
}
```

```bibtex
@techreport{iso_sql_2016,
  address = {Geneva, CH},
  type = {Standard},
  title = {Information technology -- {Database} languages -- SQL -- {Part} 1: {Framework}},
  shorttitle = {{ISO}/{IEC} 9075-1:2016},
  url = {https://www.iso.org/standard/63555.html},
  language = {en},
  number = {ISO/IEC TR 9075-1:2016},
  institution = {International Organization for Standardization},
  author = {{ISO Central Secretary}},
  year = {2016}
}
```

```bibtex
@Manual{QGIS_software,
  title = {QGIS Geographic Information System},
  author = {{QGIS Development Team}},
  organization = {Open Source Geospatial Foundation},
  year = {2020},
  url = {http://qgis.osgeo.org},
}
```

```bibtex
@misc{sqlpostgres,
  author = {{PostgreSQL 12 Documentation}},
  title = {Appendix D. SQL Conformance},
  year = 2020,
  howpublished = {https://www.postgresql.org/docs/12/features.html},
  note = {Accessed: 2020-06-02}
}
```