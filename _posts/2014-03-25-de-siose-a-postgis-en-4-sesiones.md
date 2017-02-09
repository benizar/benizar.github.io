---
title: ¡¡De SIOSE a PostGIS en 4 sesiones!!
excerpt: "En este no tan viejo post de GIS&Chips empecé a trabajar con bases de datos no relacionales. En este caso utilicé Xpath para analizar campos de datos XML, lo cual estaba muy bien. Sin embargo, ahora estoy trabajando con JSONB por disponer de mejor indexación, operadores, etc"
categories:
  - Analysis
  - Presentation
  - Programming
tags:
  - landuse
  - object oriented geodatabases
  - PostGIS
  - PostgreSQL
  - programación
  - SIOSE
---

**Nota:** Este es un *no tan viejo* post que he recuperado del blog de GIS&Chips. Actualmente estoy trabajando con bases de datos de este tipo (document stores), pero utilizando la potencia del tipo de dato JSONB.
{: .notice--info}

Hola a todos, en este post quiero compartir la presentación de un seminario temático que impartí dentro de la asignatura “SIG aplicado a la Ordenación del Territorio” en el Grado de Geografía de la Universidad de Alicante.

<iframe src="//www.slideshare.net/slideshow/embed_code/key/khIYoy0rWxNnlW" width="595" height="485" frameborder="0" marginwidth="0" marginheight="0" scrolling="no" style="border:1px solid #CCC; border-width:1px; margin-bottom:5px; max-width: 100%;" allowfullscreen> </iframe> <div style="margin-bottom:5px"> <strong> <a href="//www.slideshare.net/BeniZaragoz/de-siose-a-postgis-en-cuatro-sesiones" title="De SIOSE a PostGIS en cuatro sesiones" target="_blank">De SIOSE a PostGIS en cuatro sesiones</a> </strong> from <strong><a target="_blank" href="//www.slideshare.net/BeniZaragoz">Benito M Zaragozí</a></strong> </div>


## Introducción

El curso tuvo lugar hace un par de meses, durante 4 sesiones de 2 horas:

  1. En la primera sesión hice una introducción en la que me refería a las ventajas de saber utilizar SQL y tener un conocimiento de ciertos estándares para explotar la información geográfica.
  2. En una segunda sesión expliqué la utilidad de la base de datos del SIOSE (Sistema de información sobre Ocupación del Suelo de España), ya que ésta nos puede ahorrar mucho trabajo en proyectos SIG que desarrollemos por toda España.
  3. En la tercera sesión exploramos una solución en la que se combinan SQL y Xpath para generar reclasificaciones personalizadas del SIOSE desde PostgreSQL/PostGIS.
  4. Finalmente los alumnos tuvieron algo de tiempo para practicar y generar una reclasificación del SIOSE para separar aquellos usos del suelo susceptibles de albergar un vertedero de residuos de todos los usos del suelo que no lo admitirían. Todo esto como parte de una asignatura práctica.

Los que hayáis trabajado con la capa del SIOSE probablemente revisaréis la presentación y este post con interés, ya que las alternativas son generalmente muy trabajosas. Espero que a los demás también os resulte interesante.

## Información Geográfica y lenguajes de programación

Hace muy poco que tuvimos en las redes sociales un debate muy interesante sobre la necesidad de que los Geógrafos dominemos algún lenguaje de programación. Un compañero de GIS&Chips hizo algunos comentarios sobre esta cuestión en un post anterior. No hace falta decir que estos razonamientos se pueden aplicar a cualquier otra disciplina que analice la información geográfica.

En Twitter, yo voté que los geógrafos deberíamos adquirir unos conocimientos básicos de programación con SQL y un lenguaje interpretado, como Python o R. Lamentablemente, un tweet se queda corto y la mejor manera de apoyar mi punto de vista es con casos de uso como éste del SIOSE. Se trataba de obtener una clasificación de usos del suelo a partir de la capa del SIOSE y con el menor trabajo posible.

Básicamente, la capa del SIOSE es una base de datos relacional que contiene tres elementos fundamentales:

  1. Un campo, nombrado por defecto `the_geom`, de tipo Geometry que describe los polígonos de usos del suelo.
  2. Un campo `code_2009` que contiene un código alfanumérico que describe los usos del suelo de cada polígono en menos de 256 caracteres.
  3. Un último campo `xml_2009` asociado, que contiene una estructura XML (eXtensible Markup Language) donde se almacenan las coberturas y porcentajes. Esto tiene muy poco que ver con un ESRI Shapefile y creo que ningún SIG de escritorio permite interpretar un XML dentro de una tabla... Sí, para manejar esta base de datos es necesario saber de bases de datos, saber programar o tener muchas ganas de trabajar.

<figure>
    <a href="{{ site.url }}/images/gisandchips/siose_campos.png"><img src="{{ site.url }}/images/gisandchips/siose_campos.png"></a>
    <figcaption>Figura 1. Campos disponibles en la base de datos relacional del SIOSE.</figcaption>
</figure>


Evidentemente, para consultar una base de datos y procesar un XML, podríamos utilizar casi cualquier lenguaje de programación. Para la mayoría habrá APIs que trabajen con geometrías OGC y estructuras XML. Sin embargo, en la siguiente figura se puede ver una clasificación de lenguajes de programación según productividad (resultados por tiempo invertido) y versatilidad (cosas que podemos hacer con un mismo lenguaje).


<figure class="half">
    <a href="{{ site.url }}/images/gisandchips/programming_languages.png"><img src="{{ site.url }}/images/gisandchips/programming_languages.png"></a>
    <figcaption>Figura 2. Clasificación práctica de varios lenguajes de programación.</figcaption>
</figure>
  

Como se puede ver, he situado al SQL como el primer lenguaje justo por debajo de los *Query Builder*, que son los entornos de consulta típicos de los SIG de escritorio. Estos entornos de consulta permiten explorar los datos con una versión reducida del SQL, por lo que este lenguaje debería ser bastante accesible para usuarios habituales de SIG. Además, utilizando SQL podemos explotar casi toda la potencia de PostgreSQL y PostGIS. Esto nos dará mucho juego a la hora de hacer todo tipo de consultas y operaciones espaciales (y no espaciales). Con SQL podemos utilizar todas las funciones espaciales de PostGIS, alrededor de un millar de funciones de análisis con geometrías vectoriales, ráster, 3D, LiDAR, etc... todo eso son muchos botones.


## Sistema de Información sobre la Ocupación del Suelo de España (SIOSE)

No pretendo repetir una descripción detallada del SIOSE, que se puede encontrar en su [documentación](<http://www.siose.es/documentacion>), sino que quiero relatar la sensación que me produjo mi primer contacto con el SIOSE. La sensación de que trabajar con estos datos no es tan fácil como algunos dicen.

Os recomiendo leer [esta comunicación](<http://www.sigte.udg.edu/jornadassiglibre2012/uploads/articulos_12/art17.pdf>) presentada a las Jornadas de SIG Libre de 2012. Entre otras cuestiones, trata de los problemas de memoria y ancho de banda a la hora de compartir la capa del SIOSE mediante protocolos estándar. Sin embargo lo más interesante es todo lo relacionado con el modelo de datos, del cual admiten que es más complejo de lo habitual en SIG. En esta comunicación también se reconoce que los servicios de visualización y explotación del SIOSE tienen que mejorar con ayuda de la comunidad de usuarios. Creo que estaremos todos de acuerdo en que el objetivo de una IDE es solamente proporcionar acceso a los datos y que deben ser los usuarios los que los exploten.


### Clasificación Orientada a Objetos

La primera cuestión interesante es la buena publicidad de la que goza el SIOSE. Se trata de una clasificación de usos del suelo Orientada a Objetos (OO). Esto significa que es una clasificación muy flexible, que permite que reclasifiquemos el SIOSE de acuerdo a nuestras necesidades. Por ejemplo, no es lo mismo decir que un lugar/polígono tiene un uso *Forestal, Matorral Denso y Viviendas Aisladas*, que *Forestal 50%, Matorral Denso 48% y Viviendas Aisladas 2%*. En algunos proyectos podríamos querer reclasificar todo el polígono como Monte Alto o cualquier otro adjetivo/categoría que nos interese. En cambio, si fuese un 20% de cobertura de Viviendas Aisladas, la cosa cambia mucho.

Todo esto de la clasificación OO está muy bien. Sin embargo, estamos hablando de dos paradigmas diferentes, los SIG más utilizados funcionan con un paradigma **Relacional**, mientras que la clasificación es **Orientada a Objetos**.


### ¿Cómo se come esto?

Los SIG habituales tratarán de desplegarnos la información geográfica en una tabla-relacional y pintarán las geometrías en otra ventana, pero los datos OO no se prestan a esto, sino que se parecen más bien a un árbol jerárquico. Entonces, ¿cómo gestionar una clasificación Orientada a Objetos dentro de una base de datos Relacional? La respuesta es que no lo haces, guardas la clasificación del polígono en una celda y después utilizas alguna herramienta distinta para leer la estructura OO. En este caso, alguna herramienta que permita gestionar ficheros o estructuras XML.

A continuación podemos ver un ejemplo de clasificación OO de los usos del suelo (`xml_2009`) de una parcela al azar:

<script src="https://gist.github.com/benizar/9739541.js"></script>

La otra opción es utilizar el código alfanumérico de usos del suelo, almacenado en el campo `code_2009`, pero esto da mucho trabajo ya que hay centenares de combinaciones de todo tipo. Aún siendo un gran usuario de SQL, habría que esforzarse por hacer clasificaciones que tuvieran en cuenta los porcentajes y todos los niveles de agregación. Además, habría que consultar la documentación para encontrar la descripción de cada etiqueta (ver [este documento](<http://www.siose.es/SIOSEtheme-theme/documentos/pdf/Desc_Mod_Datos_Rotulo_SIOSE_v1.1.pdf>). Aquí va un ejemplo de código alfanumérico *sencillito*:

```sql
R(50LFNfzrr_40CNFpl_10SDNfc)
```

Cobertura compuesta en “Mosaico regular” formado por tres clases simples:

- 50% Frutales. No cítricos; atributos *forzado* y *regadío regado*
- 40% Coníferas; atributo *plantación*
- 10% Suelo desnudo; atributo *función cortafuegos*


### ¿Puedo reclasificar el SIOSE con las herramientas que conozco?

Bueno, dependerá de las herramientas que conozcas...

En la web de documentación del SIOSE vemos que hay herramientas y extensiones SIG (ArcGIS y Geomedia) que se utilizan en la creación y mantenimiento del SIOSE, pero éstas no parecen estar disponibles para descarga y, lo más importante, no son FOSS.

Si esta pregunta se la hace un experto en SIG con conocimientos de programación, estoy seguro de que encontrará una manera de que esta tarea no se convierta en un suplicio. En cambio, si esta pregunta se la hace un analista SIG que no conoce ningún lenguaje de programación y que solamente utiliza las opciones de un *Query Builder*, lo más probable es que trate de reclasificar los usos del suelo casi manualmente, ya que no hay herramientas en los SIG que procesen un XML, ni otras funciones que trabajen con strings y distingan los textos de los porcentajes numéricos.

## Reclasificar el SIOSE con PostgreSQL+PostGIS

Al descargar los datos del [Terrasit](<http://terrasit.gva.es/es/descargas>), la descarga se hace por municipios, es más actualizada pero requiere un mayor preprocesado. En cambio, si descargamos los datos del [CNIG](<http://centrodedescargas.cnig.es/CentroDescargas/catalogo.do>) podemos descargar toda una provincia de golpe y ahorrarnos el paso de unir los municipios.

En la presentación veréis que realizamos varias tareas de preprocesado de la capa del SIOSE-Terrasit. Importamos los datos con el comando shp2pgsql, los unimos en una misma capa, detectamos y eliminamos los polígonos repetidos, recortamos los polígonos según la zona de estudio y finalmente hicimos una clasificación de aquellos polígonos recortados en el borde de la zona de estudio. Esta clasificación sirve para asegurarnos de que la clasificación sea ajustada en los bordes de la zona, ya que al recortar los polígonos la clasificación del SIOSE pierde su representatividad. Podéis ver el resultado en la siguiente figura:

<figure>
    <a href="{{ site.url }}/images/gisandchips/siose2postgis1.png"><img src="{{ site.url }}/images/gisandchips/siose2postgis1.png"></a>
    <figcaption>Figura 3. Fases de procesado de la base de datos del SIOSE.</figcaption>
</figure>


Todas estas tareas de preprocesado resultan muy sencillas con SQL y se pueden automatizar fácilmente para trabajar otras zonas de estudio. En este punto, llegamos a la tarea verdaderamente importante: reclasificar el SIOSE con el mínimo trabajo posible.

Al final de la diapositiva nº33 de la presentación se muestra un ejemplo de cómo sería utilizar expresiones regulares para trocear el campo `code_2009` reclasificar los datos. ¡¡Menudo dolor de cabeza!! Menos mal que PostgreSQL es tremendamente potente y, entre muchas otras herramientas (recordad pl/R o PostGIS, sin ir más lejos), permite evaluar expresiones de Xpath para procesar estructuras XML, todo esto desde una consola de SQL. Viendo las alternativas, ¡¡esto es alucinante!!

Según la Wikipedia, XPath (XML Path Language) es un lenguaje que permite construir expresiones que recorren y procesan un documento XML. La idea es parecida a las expresiones regulares para seleccionar partes de un texto sin atributos (plain text). XPath permite buscar y seleccionar teniendo en cuenta la estructura jerárquica del XML. XPath fue creado para su uso en el estándar XSLT, en el que se usa para seleccionar y examinar la estructura del documento de entrada de la transformación. A continuación, en este GIST os muestro un ejemplo básico para reclasificar la capa de usos del SIOSE a partir del campo `xml_2009`, que como veis es de tipo xml y no string:

Aunque me cuesta explicarlo brevemente, la función `xpath(expresión, campo xml)`, requiere un campo de tipo xml, como el campo `xml_2009` del SIOSE, y una expresión como: 

```sql
//COBERTURA[@ID='EDF' and @Sup>20]/@ID
``` 

que explora solamente el segundo nivel del XML (Leyéndolo como un árbol jerárquico, “/” es el primer nivel, “//” el segundo y así sucesivamente) y selecciona todos los registros donde el tipo de cobertura es mayor que 20EDF (Edificaciones recubriendo un 20%). Esta función devuelve un array de 0 o 1 elementos según si existe o no existe la cobertura EDF en este nivel jerárquico del XML.

En el ejemplo, se utilizan expresiones similares de Xpath para cada uso que nos interese reclasificar como apto para acoger un vertedero de residuos y, finalmente, aunque no es necesario, se hace lo contrario para no dejar celdas vacías.

El resultado final de la reclasificación se puede apreciar en la siguiente ampliación de la zona de estudio (en rojo las zonas no aptas):


<figure>
    <a href="{{ site.url }}/images/gisandchips/siose2postgis.png"><img src="{{ site.url }}/images/gisandchips/siose2postgis.png"></a>
    <figcaption>Figura 4. Captura del resultado de la consulta.</figcaption>
</figure>



Como se puede apreciar, seguramente hemos dejado de considerar usos no aptos, como el cementerio (código ECM), por lo que el objetivo de los alumnos era extender la consulta anterior para completar la reclasificación de modo razonado.

La consulta se puede optimizar mucho, pero esta aproximación resulta más didáctica, ya que parte de otra reclasificación que se hacía en la sesión anterior del curso.


## Conclusiones y trabajo futuro

La principal conclusión es que solamente utilizando SQL ya se pueden acceder a herramientas muy potentes propias de los lenguajes de programación más versátiles (operaciones geométricas, expresiones regulares, estadísticas y, en este caso, procesado de XML). Además, el SQL es un lenguaje muy maduro utilizado en todo tipo de disciplinas, lo cual es una ventaja para su aprendizaje.

Por otro lado, el caso del SIOSE viene bien para volver a plantearnos la cuestión del paradigma de Orientación a Objetos. Bases de datos como la del SIOSE podrían servir como impulsoras del uso de las bases de datos OO que fueron planteadas ya a principios de los años ‘90 y que parece que estemos evitando en el mundillo de los GIS. Lo cierto es que sí que hay una necesidad. Cada vez hay más datos disponibles y cada vez son más complejos...

No es menos importante fijarse en la cantidad de trabajo que nos ahorra el SIOSE. A pesar de que su manejo requiera un cierto esfuerzo, fijaos en el detalle de la digitalización de los polígonos y el enorme rango de categorías que diferencia. Los que hemos digitalizado usos del suelo alguna vez, sabremos apreciar este recurso como se merece.

Este breve test con PostGIS y Xpath no debería terminar aquí. Desde hace escasamente una semana, he entrado a participar en un proyecto de investigación sobre Ecología y Paisaje donde los usos del suelo serán, como no, una capa de información imprescindible. Creo que trataré de desarrollar un plugin de QGIS que construya expresiones de Xpath y las ejecute en el servidor de PostgreSQL para generar consultas ágiles del campo XML del SIOSE. Os tendre informados si hago algo parecido.
