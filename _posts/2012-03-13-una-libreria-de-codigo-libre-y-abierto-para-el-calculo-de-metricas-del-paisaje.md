---
title: Una librería de código libre y abierto para el cálculo de métricas del paisaje
categories:
  - Analysis
  - Writtings
  - Programming
tags:
  - csharp
  - fragstats
  - GIS
  - landmetrics
  - NetTopologySuite
---
Hola a todos, os presento un artículo de investigación que algunos miembros de GIS&Chips publicamos el mes pasado en la revista “Environmental modelling & software”. Trata de la creación de un API libre y abierto para el cálculo de las métricas del paisaje.



<figure class="half">
    <a href="{{ site.url }}/images/landmetrics-diy-poster.jpg"><img src="{{ site.url }}/images/landmetrics-diy-poster.jpg"></a>
    <a href="{{ site.url }}/images/landmetrics-diy-sharpdevelop.jpg"><img src="{{ site.url }}/images/landmetrics-diy-sharpdevelop.jpg"></a>

    <figcaption>Figura 1. Librería 'landmetrics_diy'. Se puede ver un póster (izquierda) y una captura de la pantalla del código en SharpDevelop (derecha).</figcaption>
</figure>

La utilidad de las métricas del paisaje en distintas aplicaciones ha sido generalmente aceptada y ha provocado que existan muchos paquetes de software diseñados para proporcionar cálculos y análisis de los patrones estructurales del paisaje. Es posible obtener más información [aquí](<http://www.umass.edu/landeco/research/fragstats/documents/fragstats_documents.html>)

Tras examinar detenidamente las herramientas más utilizadas (Fragstats, V-Late, PA4, etc), se ha podido extraer una serie de puntos fuertes y débiles con la finalidad de crear una lista de las características deseables en este tipo de software. Tras dicho análisis se consideró necesario el diseño de un API sin limitaciones en los datos de entrada, capaz de calcular a partir de datos vectoriales o raster, etc. Este API debería facilitar no sólo la construcción de aplicaciones propias, sino que también debería permitir añadir nuevas métricas y la investigación de nuevos paradigmas relacionados con las métricas del paisaje. Con estas premisas se ha comenzado a desarrollar una propuesta, basada en estándares abiertos y software libre, que se ha denominado landmetrics-DIY (*Do It Yourself*). Podéis encontrar una versión alfa junto con un sencillo interfaz de usuario en GitHub:

```bash
git clone https://github.com/benizar/landmetrics_diy.git
```

Tendréis que volver a añadir las referencias a NTS y os daréis cuenta de que el desarrollo está aún muy verde. Era solamente una primera propuesta, pero creemos que las directrices definidas en el artículo deberían marcar los criterios a seguir en el desarrollo de proyectos geoespaciales científicos de este tipo.

Por el momento, este API puede calcular unas 40 métricas del paisaje a partir de ficheros vectoriales Shapefile de ESRI, pero estamos trabajando para completar su contenido, siguiendo las líneas que se explica en el artículo.

Aquellos que estéis interesados en saber más, podéis ver el poster que hemos añadido al principio del post o podréis encontrar el artículo en [ScienceDirect](<http://www.sciencedirect.com/science/article/pii/S1364815211002209>)

Hasta pronto.
