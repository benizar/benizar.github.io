---
title: 'Procesamiento de imágenes digitales con C# (y una aplicación para el análisis de parcelas agrícolas).'
excerpt: "Viejo post sobre una estupenda librería en .NET para el procesamiento y análisis de imágenes digitales."
categories:
  - Analysis
  - Programming
tags:
  - AForge.NET
  - csharp
  - Spatial Data Mining
  - Procesamiento digital de imagenes
  - RAPID
  - GEOBIA
  - Transformada de Hough
---

**Nota:** Este es un viejo post que he recuperado del blog de GIS&Chips. AForge.NET es un framework estupendo cuyo proyecto continúa muy vivo. Este framework ha continuado creciendo desde que lo utilicé por primera vez y además ha proporcionando proyectos relacionados muy interesantes como [Accord.NET](http://accord-framework.net/) para machine learning o un porting muy util para Java/Android llamado [Catalano Framework](https://github.com/DiegoCatalano/Catalano-Framework).
{: .notice--info}

En este artículo voy a exponer una aplicación de ejemplo que he realizado con C# utilizando Aforge.NET. Dicha aplicación trata (y a veces lo consigue) de distinguir si una parcela dada puede ser una plantación  agrícola arbórea mediante el análisis de la Transformada de Hough, y luego se posibilita el conteo automático de los árboles. Al tratarse de un programa con finalidad didáctica los análisis se realizan para una sola parcela y por pasos muy definidos. No obstante, cabe pensar que su mayor utilidad vendría de un análisis masivo de parcelas.

<figure class="half">
    <a href="{{ site.url }}/images/gisandchips/hough_direcciones.jpg"><img src="{{ site.url }}/images/gisandchips/hough_direcciones.jpg"></a>
    <a href="{{ site.url }}/images/gisandchips/hough_direcciones2.jpg"><img src="{{ site.url }}/images/gisandchips/hough_direcciones2.jpg"></a>
    <figcaption>Direcciones principales según la transformada de Hough. A la Izquierda se podría realizar un recuento de árboles, a la derecha no sería posible.</figcaption>
</figure>


En primer lugar, Aforge.NET es un Framework con distintas librerías que abarcan un amplio rango de campos relacionados con el tratamiento digital de imágenes. Se trata de un proyecto GNU GPL disponible en <http://code.google.com/p/aforge/>. Es un proyecto consolidado pero también muy prometedor, en el que Andrew Kirillov tiene un gran trabajo realizado.

Según vemos en la página Web entre sus librerías se encuentran:


- **AForge.Imaging** library with image processing routines and filters;
- **AForge.Vision** computer vision library;
- **AForge.Neuro** neural networks computation library;
- **AForge.Genetic** evolution programming library;
- **AForge.Fuzzy** fuzzy computations library;
- **AForge.MachineLearning** machine learning library;
- **AForge.Robotics** library providing support of some robotics kits;
- **AForge.Video** set of libraries for video processing
- etc…

Se me ocurre que alguien se podría plantear un **AForge.GIS**. Pensaremos en ello...

Nosotros hemos trabajado únicamente con Aforge.Imaging, pero salta a la vista la potencialidad que prácticamente todas las librerías tendrían para realizar análisis espaciales.

## Introducción
Actualmente, al trabajar en cuestiones de teledetección aplicada a fotografías aéreas e imágenes de satélite se esta aplicando cada vez más el paradigma del Análisis Orientado a Objetos (AOO), pasando de hablar de los valores de los píxeles, a las propiedades de los objetos. Podríamos resumirlo como: teledetección orientada a objetos.

No voy a tratar de hablar de análisis orientado a objetos, pues considero que hay abundante información en Internet.

Solamente por sentar el ejemplo que vamos a trabajar en este artículo, “Objeto” sería una parcela agrícola que podría tener múltiples “propiedades” como un área, perímetro, otros índices de forma… pero también tendría propiedades basadas en la respuesta espectral de la superficie que encierra, por ejemplo los valores de un índice de vegetación. También serían propiedades muy descriptivas de la parcela aquellas que describan la estructura generada por la distribución de los píxeles. Así pues, para una sola parcela podríamos tener muchísimas propiedades que la describieran, claro está, siempre unas lo harían mejor que otras.

En AForge.Imaging están disponibles distintas funciones de análisis para la extracción de estas propiedades o características a partir de una imagen, como por ejemplo la Transformada de Fourier, distintos algoritmos de detección de bordes y la que nos interesa aquí: La **Transformada de Hough**.

En definitiva, hemos elaborado una aplicación de escritorio que calcula la transformada de Hough para la imagen aérea de una parcela, y después de aplicar unas sencillas reglas para decidir si se trata de una parcela agrícola y arbórea, permite contar automáticamente los árboles de dicha parcela.

## La Transformada de Hough

Se trata de una técnica utilizada para extraer elementos, con una forma particular, a partir de una imagen. Es comúnmente aplicada para encontrar y describir líneas rectas en una imagen, aunque también se pueden hallar círculos y otras formas. En la carpeta de ejemplos de AForge podéis encontrar el ejemplo en el que me he basado, en el cual se aplica Hough para hallar líneas y círculos dentro de una imagen.

Aquí no vamos a explicar los fundamentos de cálculo, sino la interpretación que podemos hacer de los resultados en nuestro caso del análisis de parcelas.

En concreto uno de los datos que obtenemos aplicando Hough es la inclinación de cada una de todas las líneas rectas halladas, como también la intensidad de cada línea (en nuestro caso tendrán mayor intensidad las líneas que más árboles atraviesen).

Solamente viendo la imágen del principio podríamos intuir cuales serían las inclinaciones/direcciones de las dos líneas de mayor intensidad halladas por Hough, pero como se ve en la imagen no hay una coincidencia exacta debido a pequeños detalles (los árboles no están homogéneamente separados, la parcela no es cuadrada…).

En la primera figura (imágen de la derecha) vemos como las direcciones principales son muy similares, y esto nos indica que difícilmente la parcela tendrá la estructura necesaria para realizar el conteo de árboles.

**Nota:**  En la primera figura, líneas rojas no son las de mayor intensidad, solamente muestran las direcciones.
{: .notice--info}

## Reglas de decisión

Una vez calculado Hough usamos algunas estadísticas de las líneas halladas para crear reglas de decisión que ayuden a distinguir automáticamente la estructura de la parcela.

De un modo arbitrario a partir de las pocas parcelas vistas he decidido que serán plantaciones arbóreas aquellas parcelas cumplan lo siguiente:

- aquellas parcelas que tengan una diferencia angular entre las dos direcciones principales comprendida entre 80 y 120,
- o que el % de líneas en la 1ª dirección no sea mucho mayor que el % de la 2ª (<2x).

Estas reglas deberían ser más complejas y basadas en algún clasificador estadístico o matemático. Pero para ser didáctico es más que suficiente.

## Rough Agricultural Plots IDentifier (RAPID)

RAPID es el nombre que le hemos dado a nuestra aplicación de ejemplo. Es un identificador *basto* de parcelas agrícolas. No hay que esperar maravillas, pero veréis que acierta bastante.


<figure class="half">
    <a href="{{ site.url }}/images/gisandchips/RAPID.jpg"><img src="{{ site.url }}/images/gisandchips/RAPID.jpg"></a>
    <figcaption>Vista de la aplicación en funcionamiento.</figcaption>
</figure>


La aplicación muestra una barra de tareas donde se secuencian los pasos de análisis y a medida que se realiza cada paso se activan nuevos botones.

Los botones son:

- OpenImage: permite añadir imágenes propias.
- Binarize: binariza la imagen aplicando el umbral especificado en el cuadro de texto.
- Calc Hough: calcula la transformada de Hough para la imagen binaria y muestra algunas estadísticas en es cuadro de la derecha. También muestra un mensaje sobre la adecuación, o no, de la parcela.
- Count Trees: realiza el recuento de árboles de la imagen binaria y muestra el resultado en el cuadro “Trees estimation”. Este último no debería activarse en caso de que no se cumplieran las condiciones establecidas en nuestras reglas, pero se activa para facilitar todo tipo de pruebas.


Por último, y para ahorrar tiempo se ha añadido una galería de imágenes de parcelas extraídas del visor del SIGPAC (<http://sigpac.mapa.es/fega/visor/> ). He intentado que haya cierta variedad. Hay algunas parcelas donde resulta fácil el recuento (1, 2, 6, 8 ), pero también es muy interesante ver como se rechazan las otras parcelas. En algunos casos el conteo de árboles sería difícil incluso manualmente sobre la imagen.

En el caso de la parcela 8 de los ejemplos, vemos que RAPID hace un recuento bastante preciso de los olivos de la parcela 8 de los ejemplos (SIGPAC = 148; RAPID +/- 150, según el Threshold). Por supuesto que seríamos más precisos si elimináramos los ruidos que los bordes de la parcela introducen en el análisis.



<figure class="half">
    <a href="{{ site.url }}/images/gisandchips/parcela8_sigpac.jpg"><img src="{{ site.url }}/images/gisandchips/parcela8_sigpac.jpg"></a>
    <a href="{{ site.url }}/images/gisandchips/parcela8_rapid.jpg"><img src="{{ site.url }}/images/gisandchips/parcela8_rapid.jpg"></a>
    <figcaption>Ejemplo de conteo de árboles.</figcaption>
</figure>


Podéis ajustar el umbral, y veréis como el recuento mejora en algunas imágenes. Esto también se podría automatizar.

Otra cuestión es que hemos trabajado sobre una imagen RGB, pero es evidente que la distinción de los árboles mejoraría mucho si dispusiéramos de una banda de infrarrojo próximo y la combináramos con las otras antes de realizar la binarización.

## Algunas cosas sobre el código

La mayor parte del código que he escrito se corresponde con aspectos del UI, lo que da una idea de cómo de bueno es AForge.

He organizado el código en un fórmulario y tres clases. Hay una clase para binarizar una imagen aplicando unos pocos filtros, otra para obtener las estadísticas de Hough y la última realiza el recuento de *blobs*, en este caso árboles.

Solamente me interesa destacar el uso de FilterSequence que permite predefinir el uso de varios filtros, lo cual resulta muy práctico.

```csharp
// binarization filtering sequence

FiltersSequence filter = new FiltersSequence(

new ContrastCorrection(),

new Mean(),

new GrayscaleBT709(),

new Threshold()

);
```

Por otra parte, si usando filtros y otras herramientas notáis que hacen justo lo contrario de lo que deberían, es porque justamente están haciendo lo contrario. Deberéis aplicar un `Invert()` al Bitmap. Esto me pasaba con el `BlobCounter()`, pues me devolvía la cuenta de todo lo que no eran árboles. También deberéis invertir la imagen si queréis usar filtros del tipo `Erosion()` o `Dilatation()`.

El código fuente lo podéis obtener desde github:

```bash
git clone https://github.com/benizar/rapid.git
```

## Referencias

- De nuevo la página del proyecto: <http://code.google.com/p/aforge/>
- Para entender mejor esta técnica podéis consultar <http://en.wikipedia.org/wiki/Hough_transform>
- Antes del verano asistí a un curso en Valencia (Esp.) donde aprendí bastante de este tema. Como me gustó bastante os adjunto la referencia por si lo repiten de nuevo el año que viene: Teledetección aplicada a la actualización de cartografía de ocupación del suelo: técnicas de clasificación orientada a objetos. Curso teórico-práctico. <http://cgat.webs.upv.es/bigfiles/c_objetos/index.html>

