---
title: Cómo obtener las alturas de los edificios a partir de la cartografía catastral
excerpt: "La cartografía catastral a nivel de subparcelas y edificaciones ha representado desde hace décadas la volumetría de las edificaciones mediante números romanos. Ésta es una propuesta de un algoritmo para saber cómo extraer esa información automáticamente."
categories:
  - Analysis
  - Programming
  - Scripts
tags:
  - building heights
  - object oriented
  - QGIS
  - Python
  - Benidorm
---

## Introducción

Hace varios meses una compañera me preguntó si existían datos descargables o había algún modo rápido obtener el número de plantas y las alturas de todos los edificios de Benidorm.

El modelo de urbanización en altura de Benidorm suele ser estudiado por ser una alternativa a la urbanización dispersa que predomina en la región. Este modelo tiene interés en cuanto a la ocupación del suelo o la gestión de los recursos hídricos, entre otros aspectos. En este caso, el número de plantas y las alturas de los edificios, podría utilizarse para calcular el coste energético de bombear el agua potable a lo alto de esas torres... La verdad es que no sé si al final se utilizaron los datos :-?

Pues sí, hay muchas maneras de obtener esos datos... En primer lugar, en España es posible modelizar una ciudad en 3D utilizando la estupenda cartografía catastral de que disponemos. Esta idea ha sido recurrente en cursos, congresos y también lo he leído en alguna ocasión ([JIDEE08](http://www.idee.es/resources/presentaciones/JIDEE08/ARTICULOS_JIDEE2008/Articulo76.pdf)).

Por otro lado, con la llegada de los datos [LIDAR](https://es.wikipedia.org/wiki/LIDAR) no se ha hablado tanto de los datos catastrales para este fin. Sin embargo, los análisis con LIDAR, y de otras fuentes, pueden ser relativamente costosos en cuanto a procesado, filtrado, agregación, etc. Por este motivo, yo siempre prefiero consultar primero una base de datos que ya tenga preparados los datos necesarios. Si no fuese suficiente, ya trabajaremos con LIDAR o lo que sea...

Utilizando un DNI electrónico es posible descargar los ESRI Shapefiles de los con los datos volumétricos de Benidorm o de cualquier otro municipio. Es posible consultar toda la información necesaria sobre la descarga en la [Sede Electrónica de Catastro](http://www.catastro.minhap.es/ayuda/lang/castellano/ayuda_descarga_shape.htm).


## Números romanos y algo más

En [este enlace](http://www.catastro.minhap.gob.es/ayuda/manual_descriptivo_shapefile.pdf) se puede consultar la especificación técnica donde se describe el ESRI Shapefile que nos podemos descargar. Merece la pena detenerse en el "4 ANEXO I".



<figure class="half">
    <a href="{{ site.url }}/images/catastro-pnoa-wms.png"><img src="{{ site.url }}/images/catastro-pnoa-wms.png"></a>

    <a href="{{ site.url }}/images/catastro-shp.png"><img src="{{ site.url }}/images/catastro-shp.png"></a>

<figcaption>En estas imágenes vemos la capa WMS de catastro a la izquierda y el shapefile descargado a la derecha.</figcaption>

</figure>


En el shapefile, hay una columna denominada `CONSTRU` que contiene los volúmenes construidos, pero en números romanos y en combinación con varios códigos y signos. Se trata de un montón de información dentro de cada celda. Por ejemplo, `-II+IV+TZA` describe una parte de un edificio que tiene dos plantas subterráneas, cuatro plantas sobre rasante y, en lo más alto, una terraza (`TZA`). 

Esta cartografía también contiene información sobre las piscinas o las pistas deportivas, entre otros datos valiosísimos. El número de plantas se puede obtener, pero también hay que saber interpretar los códigos a partir del conocimiento de la zona de estudio. Por ejemplo, puede haber plantas en las que no haya suministro de agua potable como un vestíbulo muy elevado, una bóveda, etc.


Finalmente, le dediqué un tiempo a tratar de entender mejor estos códigos. A pesar de que habría que saber interpretar mejor la información, creo que tiene sentido sumar todos los números romános positivos de cada código y considerar aparte algunos códigos que podrían alterar nuestros cálculos. Por ejemplo, terrazas (`TZA`) o semisótanos (`SS`) podrían alterar un cálculo de alturas, ya que podrían significar alturas de 1,5 o 2 metros, en vez de los 3 metros que hemos visto en las referencias de la introducción ([JIDEE08](http://www.idee.es/resources/presentaciones/JIDEE08/ARTICULOS_JIDEE2008/Articulo76.pdf)).


## Función para obtener las plantas/alturas de los edificios

Me consta que hay scripts, más o menos *de contrabando* que circulan de disquete en disquete :-P 

No lo he buscado a fondo, pero los ejemplos que he visto de momento eran para extraer el número de plantas de la columna `CONSTRU` desde la calculadora de campos de Arcmap. Sin embargo, no eran funciones muy elegantes y no servían para edificios de más de 40 alturas (en Benidorm esto se nota mucho) Todo ello sin llegar a hablar de software libre.

Mis primeros proyectos de programación GIS también fueron VBScript para la calculadora de campos de ArcGIS, después probé con Python, pero desde entonces no había vuelto a trabajar con la calculadora de campos de un SIG de escritorio. Particularmente, me gusta la productividad de este tipo de scripts para tareas sencillas.

<figure>
    <a href="{{ site.url }}/images/catastro-qgis-field-calculator.png"><img src="{{ site.url }}/images/catastro-qgis-field-calculator.png"></a>
<figcaption>Una vez insertada la función desde el editor de funciones, queda guardada y ya la podemos utilizar.</figcaption>
</figure>

En este caso me pareció apropiado probar con Python y la calculadora de campos de QGIS, ya que tiene una documentación excelente ([qgistutorials](http://www.qgistutorials.com/es/docs/custom_python_functions.html)). Quien sabe, quizás más adelante me anime con los plugins con PyQGIS :)

El script (al final del post) consiste en una función que hace lo siguiente:

1. Elimina las plantas bajo rasante y los caracteres innecesarios
2. Trocea el código y extrae los números romanos
3. Utiliza una función de Mark Pilgrim's para convertir los números romanos a enteros
4. Suma todos los valores de cada parte de edificio.
5. Guarda el resultado en una columna nueva


El número de plantas o las alturas se obtendrían ejecutando la función así:

```python
get_cadastre_building_floors("CONSTRU")
get_cadastre_building_floors("CONSTRU") * 3
```


## Resultados y discusión

Los resultados no se pueden entender sin recordar el hecho de que los elementos representados en la capa GIS son *partes de edificios*, no edificios enteros (ver [documentación](http://www.catastro.minhap.gob.es/ayuda/manual_descriptivo_shapefile.pdf)). Entonces, un único edificio puede estar representado por varias partes, cada una con un número distinto de plantas...

De un modo ágil se pueden repasar los resultados:

1. Comprobando que la lectura de los números romanos da el resultado apropiado.
2. Revisando esta [página web](https://es.wikipedia.org/wiki/Anexo:Rascacielos_de_Benidorm) sobre los rascacielos de Benidorm se puede valorar cómo de precisos son los cálculos que acabamos de realizar.


| CONSTRU     |plantas  |altura (3m)|
|-------------|---------|-----------|
| -I+L        | 50      | 150       |
| -I+XLVIII   | 48      | 144       |
| -I+XLV      | 45      | 135       |
| -I+XLV      | 45      | 135       |
| -V+SS+XLIV  | 44      | 132       |
| -V+SS+XLIV  | 44      | 132       |
| -IV+SS+XLIV | 44      | 132       |
| -IV+SS+XLIV | 44      | 132       |
| -V+SS+XLIV  | 44      | 132       |
| -V+SS+XLIII | 43      | 129       |


En esta tabla se muestran los resultados para los 10 edificios (partes de edificios) más altos de Benidorm. Al comparar estos datos con los de la web anterior se puede ver que:

1. El edificio Intempo (192 metros / 47 plantas) no estaba construido cuando se digitalizó esta capa.
2. La altura media de las plantas es mayor de 3 metros, quizás por los elementos de diseño que buscan competir por ser los edificios más altos.
3. Los primeros 4 valores de plantas se corresponden con partes del Gran Hotel Bali (186 metros / 52 plantas).


<figure>
    <a href="{{ site.url }}/images/catastro-gran-bali.png"><img src="{{ site.url }}/images/catastro-gran-bali.png"></a>
<figcaption>El Gran Hotel Bali de Benidorm. Ortofoto del WMS del PNOA y, en superposición, la capa SHP de catastro con las alturas calculadas.</figcaption>
</figure>


Independientemente de que se puedan extraer las alturas utilizando la codificación actual, entiendo que es cuestión de no mucho tiempo en que esta información deba ser publicada mediante otro tipo de formatos más flexibles (GML, GEOJSON, etc).


## Código a mejorar...

Aquí os dejo el gist con la función. Es un buen punto de partida para lo que queráis hacer ;)

<script src="https://gist.github.com/benizar/64167bfdff1b0ed146ac.js"></script>

