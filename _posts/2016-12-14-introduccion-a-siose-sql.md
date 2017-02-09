---
title: Introducción a la geodatabase del SIOSE
excerpt: "Qué es el SIOSE y varios modos para consultarlo. Se trata de una breve introducción para ganar confianza..."
categories:
  - Analysis
  - Presentation
  - Programming
tags:
  - landuse
  - landcover
  - PostGIS
  - PostgreSQL
  - SIOSE
  - SQL
---

Hola a todos, en este post quiero compartir dos nuevas presentaciones de un seminario temático que he impartido dentro de la asignatura "SIG aplicado a la Ordenación del Territorio" en el Grado de Geografía de la Universidad de Alicante.

Recomiendo leer el [post anterior]({{ site.baseurl }}{% post_url 2014-03-25-de-siose-a-postgis-en-4-sesiones %}) sobre este tema y toda la documentación disponible. En esta ocasión no se profundiza tanto en la modelización de datos y se estudia la base de datos del SIOSE con SQL y la funcionalidad de PostGIS.



## SQL para geógrafos. 

En esta presentación se asume que el público conoce el uso de un SIG y ha digitalizado usos del suelo. A continuación, se presenta SQL en un contexto profesional y se describe la base de datos del SIOSE. 

<iframe src="//www.slideshare.net/slideshow/embed_code/key/AN129irZ88iYjg" width="595" height="485" frameborder="0" marginwidth="0" marginheight="0" scrolling="no" style="border:1px solid #CCC; border-width:1px; margin-bottom:5px; max-width: 100%;" allowfullscreen> </iframe> <div style="margin-bottom:5px"> <strong> <a href="//www.slideshare.net/BeniZaragoz/introduccin-a-la-geodatabase-del-siose-i" title="Introducción a la geodatabase del SIOSE (I)" target="_blank">Introducción a la geodatabase del SIOSE (I)</a> </strong> de <strong><a target="_blank" href="//www.slideshare.net/BeniZaragoz">Benito M Zaragozí</a></strong> </div>



## Introducción a SQL. 

En esta segunda presentación se trabaja con Postgres/Postgis por primera vez. El objetivo es dar un rápido vistazo a SQL y entender que para consultar el SIOSE con libertad es necesario conocer algún lenguaje de consulta.

<iframe src="//www.slideshare.net/slideshow/embed_code/key/75ixuFKfB7qW8g" width="595" height="485" frameborder="0" marginwidth="0" marginheight="0" scrolling="no" style="border:1px solid #CCC; border-width:1px; margin-bottom:5px; max-width: 100%;" allowfullscreen> </iframe> <div style="margin-bottom:5px"> <strong> <a href="//www.slideshare.net/BeniZaragoz/introduccin-a-la-geodatabase-del-siose-ii" title="Introducción a la geodatabase del SIOSE (II)" target="_blank">Introducción a la geodatabase del SIOSE (II)</a> </strong> de <strong><a target="_blank" href="//www.slideshare.net/BeniZaragoz">Benito M Zaragozí</a></strong> </div>

## Datos utilizados

Los datos del SIOSE utilizados en estas presentaciones están disponibles en varios enlaces. Por ejemplo, en el [Centro de Descargas](http://www.siose.es/descargar) del CNIG (España) o en la sección de descargas del [Terrasit](http://terrasit.gva.es/es/descargas) (Comunidad Valenciana).

No obstante, los alumnos que asistieron a dichas sesiones pueden encontrar interesante trabajar directamente con los `backups` creados y restaurados varias veces en clase:

- [siose_terrasit.backup]({{ site.url }}/download/siose_terrasit.backup)
- [siose_cnig.backup]({{ site.url }}/download/siose_cnig.backup)

Las versiones del software son las que vienen con el [OSGeo Live GIS Disc 9.5](https://live.osgeo.org/es/download.html). Salvo alguna modificación, esta version de OSGeo es la instalada en el Aula de Geomática del Instituto Interuniversitario de Geografía, 

Una vez más, os animo a conocer el SIOSE ;)

