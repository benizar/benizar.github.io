---
title: 'Usando RSAGA para procesar un raster *grande* por partes'
excerpt: "Viejo post sobre automatizar el recorte de un raster con R y SAGA GIS"
categories:
  - Analysis
tags:
  - GIS
  - R
  - GEOBIA
---

**Nota:** Este es un viejo post que he recuperado del blog de GIS&Chips. Me gustaría encontrar tiempo para explorar el uso de otras librerías GIS desde R.
{: .notice--info}

Hola a todos, hoy propongo una de las posibles soluciones a un problema que suele aparecer trabajando con GIS: ¿qué hacer cuando queremos procesar un raster “relativamente grande” y los GIS de escritorio más populares tienen problemas de memoria o no acaban el proceso?

En algunas ocasiones la solución a estos problemas sería “trocear” el raster y procesarlo por partes. Esto lo podríamos hacer con varios software y en todos ellos sería interesante poder automatizar la tarea al máximo.

<figure class="half">
	<a href="{{ site.url }}/images/gisandchips/mdt.jpg"><img src="{{ site.url }}/images/gisandchips/mdt.jpg"></a>
	<a href="{{ site.url }}/images/gisandchips/municipios.jpg"><img src="{{ site.url }}/images/gisandchips/municipios.jpg"></a>
	<figcaption>(1) Modelo digital raster y (2) Shapefile de polígonos con que trocearemos el raster.</figcaption>
</figure>


En este post propongo realizar una prueba con RSAGA, que es un modulo de R que permite acceder a las funciones disponibles en la consola de SAGA GIS. Para este post he trabajado en Windows, con R 2.10.1 y SAGA 2.0.4, aunque supongo que no habrá problemas con usar otras versiones más recientes. Además, deberéis instalar en R el paquete RSAGA.


Para esta práctica podéis [descargar ficheros de prueba]({{ site.url }}/downloads/rsaga_tests.rar) (imágenes 1 y 2), uno raster y otro vectorial (polígonos). A efectos didácticos se utilizan ficheros pequeños, pero esto resultaría más útil en caso de necesitar fragmentar más el raster. Por ejemplo, en artículos anteriores he presentado código para trabajar imágenes a nivel de parcelas agrícolas. En aquellos artículos trabajábamos las imágenes de una en una y ya estaban recortadas, pero las parcelas podrían ser miles y no queremos hacer eso a mano.

## Conociendo SAGA GIS

Lo principal, como en tantos otros casos, sería conocer como se trocea un fichero raster con SAGA GIS. Para ello abrimos la GUI de SAGA y vamos a la pestaña “modules” que tiene forma de TOC, generalmente se encuentra a la izquierda de la ventana principal. En esta pestaña podemos encontrar las distintas librerías que agrupan módulos que se relacionan por algún motivo. Explorar estas librerías y practicar con ellas es el mejor modo de estar seguro de lo que se quiere hacer.

<figure class="third">
	<a href="{{ site.url }}/images/gisandchips/toc.jpg"><img src="{{ site.url }}/images/gisandchips/toc.jpg"></a>
	<figcaption>Figura 3. TOC de SAGA GIS donde podemos explorar las librerías y los módulos disponibles.</figcaption>
</figure>




Finalmente, he decidido que lo mejor es empezar por separar el shapefile original por polígonos (shapes-tools/separate shapes) y después realizar un recorte por cada uno de los nuevos shapefiles (shapes-grid/clip grid with polygon). Practicar con el interfaz gráfico es un bueno modo de estar seguros de los parámetros que nos pide cada módulo.

Antes de empezar a usar RSAGA he tenido que averiguar los nombres exactos de los módulos y los parámetros que aceptan. Esto lo he hecho con los métodos `rsaga.get.modules()` y `rsaga.get.usage()`. Aunque generalmente se puede averiguar también viendo los nombres en el SAGA GUI o mirando en la carpeta donde se contienen las *.dll.

```r
## Abrimos la consola de R y cargamos la librería
library(RSAGA)

## Seleccionamos el fichero raster que queremos trocear y una capa vectorial que queramos usar como límites. También especificamos el directorio donde van los outputs. Para trabajar con Windows recomiendo rutas sin espacios.
raster<- file.choose()
poligonos<- file.choose()
directorio <-choose.dir()

## Consultamos hasta encontrar la herramienta que nos separa un shapefile en varios, obteniendo un shapefile por cada polígono, o lo que quisiéramos. Por ejemplo:
## rsaga.get.modules("shapes_grid")
## rsaga.get.usage("shapes_tools", 7)
## Se ejecuta el método con los parámetros necesarios.
rsaga.geoprocessor(lib="shapes_tools", module=7, param=list(SHAPES=poligonos, PATH=directorio, NAMING=0, FIELD=6))
```

Una vez ejecutado este proceso ya disponemos de un shapefile por cada polígono, esto significa que aunque el shapefile original tuviera miles de registros solamente cargaremos en memoria uno a la vez. Esto ya supone un ahorro importante de recursos.

```r
# Listamos los nuevos shapefiles
shapefiles &lt;- list.files(directorio, full.names=T, pattern="\\.shp")
## Por último utilizamos RSAGA para realizar tantos recortes del raster como polígonos habíamos extraído
for(i in 1:length(shapefiles)){
select <- shapefiles[i]
rsaga.geoprocessor(lib="shapes_grid", module=7, param=list(OUTPUT=select, INPUT=raster, POLYGONS=select))
}#fin bucle
```

## Conclusiones

Tras ver este ejemplo nos queda más claro el uso de RSAGA y se visualiza bien como se podrían automatizar gran número de tareas habituales en los GIS. Intentar realizar estas tareas herramientas básicas y generales podría ser algo trabajoso.

En nuestro fichero de prácticas había 18 polígonos por lo que nuestro resultado es una carpeta donde encontramos guardados 18 shapefiles y 18 ficheros raster. Los recortes quedan como se puede ver en la siguiente imagen:


<figure class="half">
	<a href="{{ site.url }}/images/gisandchips/recorte.jpg"><img src="{{ site.url }}/images/gisandchips/recorte.jpg"></a>
	<figcaption>Figura 4. Uno de los 18 raster resultantes de los recortes y al fondo el shapefile original.</figcaption>
</figure>


En caso de ser necesario, se podría realizar más tareas sobre todos estos ficheros, con este software o con otros programas. Incluso se plantea la posibilidad de usar multithreading en R para ejecutar tareas con RSAGA. Proximamente haremos alguna demostración de esto.

Antes de acabar, solo quiero recordar quando trabajamos con RSAGA en Windows es posible que nos afecten algunas particularidades sobre el modo en que se forman las rutas (espacios, barras de directorios…) y los mensajes de error que aparecen no son de gran ayuda.

