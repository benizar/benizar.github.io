---
title: La utilidad de los códigos QR en el campo de las TIG (1ª parte)

categories:
  - Analysis
  - ProTip
  - Programming
tags:
  - geodatabases
  - GIS
  - LaTeX
  - QR codes
  - Proximity
  - Ubiquitous
---

Los códigos QR (Quick Response), ¿están vivos o muertos?, ¿qué aplicaciones geográficas tienen?, ¿queda algo por hacer? Tras una rápida búsqueda por Internet encontramos abundante información sobre estos códigos de barras bidimensionales creados en 1994. La información que encontramos es contradictoria y apunta en dos direcciones: o bien los QR están de moda y cada vez se utilizan más, o por el contrario su uso es más marginal y los usuarios van perdiendo interés.

img
Ejemplo de tarjeta ID con código QR


En este nuevo post presentaré las características básicas de los códigos QR en el contexto de lo que podríamos llamar *TIG de proximidad* (RFID, NFC, Bluetooth, Realidad Aumentada, etc). Entre otras aplicaciones, estas tecnologías nos permiten ofrecer información de contexto en el mismo lugar en el que esta información puede ser más necesaria (ubicuidad). Entre dichas *TIG de proximidad*, los códigos QR se distinguen por ser la opción *a priori* más económica y la más versátil, por lo que vale la pena dedicar algo de tiempo a entenderlos mejor.

Este post es el primero de una serie de tres. Aquí introduciré algunos aspectos generales sobre los QR y su uso. Os presento un interesante ejemplo de código en LaTeX que os permitirá generar e incluir QRs en distintos tipos de documentos. El ejemplo que he escogido es el de generar tarjetas de identificación QR para los asistentes al [XVI Congreso Nacional de TIG](http://congresotig.ua.es/index.php/tig/tig2014). En un segundo post, trataremos las aplicaciones geográficas que se les ha dado a los QR. Y finalmente, en un tercer post os hablaré de una idea que queremos desarrollar utilizando esta tecnología.


## Códigos QR (Quick Response Codes)

Desde mi punto de vista, cualquier tecnología que me permita alimentar una base de datos geográfica es susceptible de ser considerada TIG o formar parte de un SIG. No olvidéis esta idea mientras avanzamos en la lectura de este post.

Los códigos QR son un código de barras bidimensional (BIDI) diseñado a finales de los ‘90 y publicado como un [estándar ISO](http://www.google.com/url?q=http%3A%2F%2Fwww.worldcat.org%2Ftitle%2Finformation-technology-automatic-identification-and-data-capture-techniques-bar-code-symbology-qr-code-technologies-de-linformation-techniques-didentification-automatique-et-de-capture-de-donnees-symboles-de-codes-a-barres-code-qr%2Foclc%2F60816353%3Flang%3Den&sa=D&sntz=1&usg=AFQjCNEGtOMKXXDKrwOh6eZmPcUch_t4nw). La apariencia simple de estos códigos puede engañar y en realidad su especificación completa es bastante compleja. Ahora me voy a limitar a hacer un resumen de las características fundamentales que debemos tener en cuenta:

- **Lector de QR**: Como cualquier código de barras, es necesario tener un dispositivo que lo escanee, lea los datos que contiene y haga algo con ellos (p.ej.: esto es lo que hacen los escáneres en las cajas de los supermercados). Los smartphones y tablets actuales están preparados para esto y existen un gran número de aplicaciones para leer QR y hacer algo con ellos. Yo por el momento he utilizado [QR Droid](https://play.google.com/store/apps/details?id=la.droid.qr&hl=es) ya que permite distintas opciones, pero hay muchas otras apps que podrían ser interesantes. Además, existen APIs, como [Zxing](http://code.google.com/p/zxing/wiki/GettingStarted) para añadir el trabajo con QR dentro de vuestras propias aplicaciones. Lo que me sorprende es que ni Apple, ni Google han incorporado esta capacidad “de serie” para los desarrolladores de sus plataformas.
  
- **Estructura**: Tres marcas principales indican la posición/orientación del código (4.1 en la imagen). Otras marcas secundarias permiten alinear correctamente el QR (4.2 y 4.3). El resto de la superficie sirve para contener los datos, pero hay unas regiones específicas que contienen información sobre cómo se ha generado el código (1 y 2). Finalmente, es necesario que el QR esté rodeado por un “foso” o una zona en un color diferenciado que evite el ruido en la lectura del QR (5). Para aprender más sobre su estructura, recomiendo que leáis la entrada a la [Wikipedia](http://en.wikipedia.org/wiki/QR_code) en inglés (mucho más completa que en castellano).


img id="docs-internal-guid-3a20a14d-8fe6-abfa-4147-fd6f5821589e" class="aligncenter" src="https://lh5.googleusercontent.com/8NiB6ZlfK5UVGezWunaFZm6nZQUsjZvJMDAyXtX4ZbYtKjXH8LMwTljciMDStnX_3FLnsFWNdp-qajToDIev_I4uYSb5urg06IeEC8e_2-tmqLQeBDHuHQqBqw

- **Corrección de errores**: La redundancia de los datos permite que aunque algunas partes del QR no fuesen legibles, esta información pueda ser leída en otras regiones, por lo que no se perdería información. Hay 4 niveles de corrección de errores (bajo, medio, cuartil y alto) que se corresponden directamente con el nivel de redundancia. Esta característica permite diseñar codigos QR más atractivos, distintos de las típicas matrices en blanco y negro ([ver creative QR codes](http://mashable.com/2011/07/23/creative-qr-codes/#gallery/creative-qr-codes/5212933a51984066110000a7)).



img
QR artístico generado gracias a la *Corrección de Errores* (Redundancia)

- **Almacenamiento**: Los QR pueden contener información y no solamente links. Ésta es una confusión bastante habitual. El volumen de información que un QR code puede contener depende (1) del tipo de datos (numérico, alfanumérico, binario), (2) las dimensiones o “versión” del QR (ej: La versión 4 equivale a una matriz de 33 x 33) y el nivel de corrección de errores. Considerando todo esto, la capacidad máxima de almacenamiento sería de 4.296 caracteres alfanuméricos. Versión 40 (177×177) y corrección de errores baja (redundancia del 7%). Serían más caracteres si fuesen solo números (dígitos del 0 al 9, **¡¡pero sin espacios ni ningún tipo de separador!!**).

- **Seguridad**: En [Archive.is](http://www.google.com/url?q=http%3A%2F%2Farchive.is%2F20120801054819%2Fhttp%3A%2F%2Fwww.abc.net.au%2Ftechnology%2Farticles%2F2011%2F06%2F08%2F3238443.htm&sa=D&sntz=1&usg=AFQjCNHDVdSE8MMpW7gJ93FpJZPf_6trnw) describen un posible riesgo en los lectores de QR que pueden funcionar como virus si el software lector tiene permisos para controlar el hardware o ejecutar código... Supongo que esto no estará muy extendido y que los desarrolladores pondrán las limitaciones necesarias.


## Diagnóstico de las tendencias y aplicaciones en el uso de QR codes

En Internet podemos encontrar argumentos válidos apoyando dos tendencias opuestas: (1) el despegue de los QR (basado en estadísticas del número total estimado de escaneos y QRs existentes) o (2) su muerte temprana (basado en los hábitos de uso). Para haceros una idea podéis repasar los enlaces que añado al final de este post.

Lo cierto es que en menos de un año se ha duplicado el número estimado de QRs y se cree que éste seguirá creciendo en los próximos 5 años. Sin embargo, hay algunos hábitos de uso que hacen pensar que no existirán suficientes incentivos para que los usuarios sigan utilizando esta tecnología a medio plazo. Resumiendo: si alguien escanea uno o dos QRs y no obtiene un beneficio atractivo, se pierde el interés y se verán perjudicadas otras posibles aplicaciones TIG que quisiéramos basar en estos BIDI.

Aunque en el próximo post dedicaremos más tiempo a repasar las distintas aplicaciones (geográficas o no) de los QR, ahora cabe hacer un breve diagnóstico de (1) los usos más frecuentes y (2) la percepción de los usuarios. En definitiva, ambas cuestiones decidirán el éxito o fracaso de esta “no-tan-novedosa” tecnología en el contexto de las TIG. Así pues, los usos más comunes de los QR son:

- Obtener un cupón, un descuento o una oferta
- Acceso a un sitio web
- Acceder a información adicional
- Registro en un sitio Web
- Realizar una compra
- Activar una llamada telefónica
- Añadir un evento al calendario
- Conectarse con un colectivo en LinkedIn, Facebook o Twitter (Likes y Follows)
- Enlazar con un recurso multimedia en Internet
- Tarjetas de presentación
- etc, etc


## La percepción de los usuarios

En cuanto a los hábitos de uso, merecen especial atención aquellas webs donde los usuarios comparten sus malas experiencias con QR. Por ejemplo, en [The death of the QR codes](http://marketingland.com/the-death-of-the-qr-code-37902) se señalan cinco problemas que arrastra el uso actual de los QR (ver más casos en los comentarios dicho post):

- Las principales plataformas de smartphones no han apostado por los QR.
- La experiencia posterior a escanear el código puede ser **decepcionante**.
- El uso de QR debe **asegurar al 100% la conectividad, si esta es necesaria** para su correcto uso.
- Los comerciantes no ven la necesidad de QRs cuando ya quedan satisfechos con los clásicos códigos de barras para etiquetar los productos envasados.
- El esfuerzo (tiempo y aprendizaje) necesario para usar QR debería compensar. **No es suficiente con dar un enlace a una Web. Además, el usuario debería saber qué puede esperar del QR antes de escanearlo.**

Viendo estas tendencias y estadísticas, creo que la tecnología basada en QRs tiene un potencial muy amplio. Su uso puede ser beneficioso para los usuarios y a nosotros nos podría servir para explotar o alimentar una geodatabase. Sin embargo, antes de ponernos a imprimir QRs “como pollos sin cabeza” es necesario meditar bien las aplicaciones y el cómo enfocar los distintos problemas que hemos señalado. Para empezar a ver como funcionan estas cosas propongo el siguiente ejemplo.


## QR para la identificación de asistentes al congreso (con LaTeX)

Los miembros de GIS&Chips estamos ayudando a organizar el próximo [XVI Congreso Nacional de TIG](http://congresotig.ua.es/index.php/tig/tig2014) (Junio de 2014). Esperamos organizar varios talleres gratuitos para los inscritos, e incluso dar un premio a las mejores apps que se presenten a la cuarta sesión. Os animo a que le echéis un vistazo a la [Web](http://congresotig.ua.es/index.php/tig/tig2014) y os inscribáis si queréis conocer a gente interesante. Además, los precios de inscripción son [muy económicos](http://congresotig.ua.es/index.php/tig/tig2014/schedConf/registration) 😉

En los congresos científicos siempre llega el momento de conocer personalmente a otros investigadores y profesionales. Después de charlar con ellos llega el momento de intercambiar tarjetas de presentación para mantener el contacto. En este momento es cuando me siento un completo inútil por no tener un bonito tarjetero y unas tarjetas de calidad. En este [XVI congreso de TIG](http://congresotig.ua.es/index.php/tig/tig2014) quiero que demos una solución a los asistentes para que puedan guardar todos sus nuevos contactos sin problemas. Ésta es mi propuesta para crear una tarjeta de identificación con QR... diseño y estilo aparte!! Del diseño se ocuparán los profesionales...

Los códigos QR pueden ser generados desde prácticamente cualquier lenguaje de programación e incluso hay Webs que se dedican a eso (p. ej.: [http://www.codigos-qr.com/generador-de-codigos-qr](http://www.codigos-qr.com/generador-de-codigos-qr)). De entre las opciones que conozco, LaTeX proporciona la posibilidad de diseñar e incorporar gráficos vectoriales en vuestros documentos y también permite generar QRs en serie.

img
title="Tarjetas con QR generadas este código

El código que adjunto a continuación funciona así:

1. Cargamos los packages necesarios
2. Definimos la layout de la página. Con “AddToShipoutPicture” podemos repetir una imagen de fondo a las distintas tarjetas. A poder ser con un diseño más bonito que el mio.
3. Añadimos o cargamos un fichero CSV con los datos necesarios (saldrán de la plataforma web del congreso). Los nombres de los campos son importantes y hay campos aparentemente repetidos debido a que el package “pst-barcode” no codificará bien los acentos. Deberíamos buscar un código alfanumérico para hacer esto, pero por ahora no es tan importante.
4. Con `applyCSVfile` definimos un bucle para los registros del fichero csv.
5. En cada iteración rellenaremos una tarjeta y crearemos su QR correspondiente. El QR contendrá texto ajustado a un estándar de intercambio de contactos ([meCard](http://www.devicemedia.ca/blog/whats-the-difference-between-a-vcard-and-a-mecard/) para imprimibles o [vCard](http://www.devicemedia.ca/blog/whats-the-difference-between-a-vcard-and-a-mecard/) si el intercambio es digital).
6. Finalmente, tendremos que compilar el documento paso a paso. ¡¡Nada de compilación rápida!! (DVI->PS->PDF).
7. Et voilà!! Obtenemos un pdf con todas las tarjetas y códigos QR que podemos **leer con QR Droid**. Al escanear un código, QR Droid detecta que se trata de un formato de datos de contacto y sugiere añadirlo a la agenda de contactos, pero también da otras posibilidades como ver el contacto en un mapa (en este caso, nos mostrará la Universidad de Alicante).


img 
Opciones que nos permite QR droid tras escanear el QR del principio. Fijaos que aparece la opción de ver en el mapa.


Evidentemente, si modificamos la layout, fácilmente podemos imprimir otros documentos (p.ej.: certificados del congreso) y ahorrar un tiempo precioso. Espero que esto os ayude en otros trabajos similares.


## Consideraciones finales

Parece que nos hayamos desviado un poco del tema, pero no es así (no del todo). Como os he comentado antes “cualquier tecnología que me permita alimentar una base de datos geográfica es susceptible de ser considerada TIG”. El caso de los contactos con formato [meCard](http://www.devicemedia.ca/blog/whats-the-difference-between-a-vcard-and-a-mecard/) puede no ser del todo evidente, pero estaríamos guardando información sobre el lugar de trabajo de muchas personas en una base de datos del smartphone o tablet (todo cartografiable). Esto no queda aquí. Viendo cómo ha funcionado el caso de uso del [XVI Congreso de TIG](http://congresotig.ua.es/index.php/tig/tig2014), os resultará más sencillo entender los próximos posts y la comunicación que presentaremos el año que viene en el [XVI Congreso de TIG](http://congresotig.ua.es/index.php/tig/tig2014).

Si en vez de guardar información de contactos en formato [meCard](http://www.devicemedia.ca/blog/whats-the-difference-between-a-vcard-and-a-mecard/), pudiéramos guardar información geográfica de utilidad, el aprovechamiento no sería muy distinto de lo que hemos visto para las tarjetas del congreso. Para esto hay varias preguntas que deberemos responder:

- ¿Que aplicaciones TIG se beneficiarían de esta tecnología?
- ¿Qué información geográfica podremos almacenar en tan pocos caracteres (<4.300)?
- Añadir links, ¿es nuestra única posibilidad?
- El uso que le demos a los QRs, ¿nos servirá para alimentar una geodatabase o hay alternativas mejores?
- ¿Cómo hacer que la experiencia resulte sencilla y atractiva a los usuarios?

Un poco de paciencia, que pronto llegará el siguiente post… y algunas ideas nuevas!! 😉


## Algunos enlaces de interés:

- <http://www.smartinsights.com/mobile-marketing/qr-code-marketing/qr-codes-location-demographic-statistics/>
- <http://www.smartinsights.com/mobile-marketing/qr-code-marketing/qr-codes-location-demographic-statistics/>
- <http://www.pb.com/smb/qr-codes/marketing/statistics-trends-use>
- <http://visual.ly/qr-code-usage-statistics>
- <http://sharemarketing.wordpress.com/2011/06/04/10-things-to-with-2-d-codes-qr-codes/>
- <http://www.elblogdegerman.com/2011/07/19/el-papel-de-los-codigos-qr-en-el-marketing-actual/>
- <http://es.slideshare.net/bertheymans/qr-codes-2012-beyond-the-hype-a-look-at-statistics>
- <http://marketingland.com/the-death-of-the-qr-code-37902>
- <http://mediamusea.com/2013/02/14/uso-qr/>
