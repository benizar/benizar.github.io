---
title: Geospatial Reference Information processing
excerpt: "Improving the usability of the Information system of land cover in Spain (SIOSE)"
categories:
  - Analysis
  - Presentation
  - Programming
tags:
  - landuse
  - geodatabases
  - nosql
  - postgis
  - postgresql
  - programming
  - SIOSE
---

This week I was invited to the 129th EuroSDR Board Members committee for presenting our latest research work on geospatial databases. It was a technical presentation focused on the usability gap of the Geospatial Reference Information compiled and published by the SDIs.

<iframe src="//www.slideshare.net/slideshow/embed_code/key/a41uGtC3FkeM83" width="595" height="485" frameborder="0" marginwidth="0" marginheight="0" scrolling="no" style="border:1px solid #CCC; border-width:1px; margin-bottom:5px; max-width: 100%;" allowfullscreen> </iframe> <div style="margin-bottom:5px"> <strong> <a href="//www.slideshare.net/BeniZaragoz/improving-the-usability-of-the-information-system-of-land-cover-in-spain-siose" title="Improving the usability of the Information system of land cover in Spain (SIOSE)" target="_blank">Improving the usability of the Information system of land cover in Spain (SIOSE)</a> </strong> de <strong><a target="_blank" href="//www.slideshare.net/BeniZaragoz">University of Alicante</a></strong> </div>

## Contents
In the slides we present a case study on Land Occupation databases which use an object-oriented data model following the INSPIRE technical specifications. In this case the usability gap consists on the object-relational impedance mismatch. This happens when an object-oriented data model has to be stored in a relational database.

In the second section of this presentation we describe a computational experiment for testing if there are any benefits in storing land use (LU) and land cover (LC) data in a document store database. In this experiment we used the LU/LC database of Spain (SIOSE).

The results showed that there are some benefits in terms of throughput capacity and response times for certain thematic queries. Based on these results we propose some additional improvements that could provide even better results.

This experiment was performed using the dockers containerization technology, so the experiment is completely reproducible in less than eight hours (it took weeks to prepare the experiment) by executing a few lines of code. As a suggestion, the dockers technology could be used as a way for sharing Geospatial Reference Information databases with companies or advanced users willing to use this data for research or business.

This research is going to be continued in a research project starting in 2017 and funded by the Spanish Ministry of Economy and Competitiveness. 
