---
title: 'Integración de R en aplicaciones de escritorio. R, Rcom y C#'
excerpt: "Viejo post sobre una de las maneras que teníamos hace años de crear aplicaciones o interfaces de usuario que utilizasen R"
categories:
  - Programming
tags:
  - .Net
  - csharp
  - R
  - Rcom
  - WinForms
  - GIS&Chips
---

**Nota:** Este es un viejo post que he recuperado del blog de GIS&Chips. En 2016, ya hay mejores alternativas para crear interfaces de usuario para los programas desarrollados en R (Shiny, R.NET, etc). Sin embargo, me parece interesante conservar el proyecto, así que lo he lo he subido a GitHub.
{: .notice--info}

Hola a todos. Con este artículo espero escribir el primero de una larga serie de artículos sobre el mundo de R. A nuestro juicio, y el de mucha más gente éste es uno de los proyectos GNU con mayor repercusión y también uno de los más prometedores para los usuarios de información geográfica (sigue siendo prometedor, aunque ya es toda una realidad).

Para aquellos que no conozcan R ( <http://cran.r-project.org/> ), podemos decir que es un lenguaje de programación a la vez que un paquete estadístico de software, desarrollado bajo licencia GNU GPL de la Free Software Foundation. Lo más interesante de R es que se puede adaptar fácilmente a nuestros intereses mediante la instalación de nuevos paquetes. Hay muchos, y suelen englobar funciones comunes a una misma área de conocimiento. En nuestro caso, existen paquetes relacionados con el tratamiento de la información espacial y más directamente, otros que se relacionan con software GIS. Por poner algunos ejemplos, podemos interactuar desde el GUI de R con SAGA GIS, Grass6, GDAL... y utilizar muchas de sus herramientas, o bien trabajar con otros paquetes propios de R.

En este artículo no trabajaremos desde el GUI de R. Queremos mostrar como integrar R en nuestras aplicaciones de escritorio de .NET mediante objetos COM.

Para poder comenzar, deberemos instalar un servidor COM disponible en <http://cran.r-project.org/>. Entramos en la sección de software/otros/ e instalamos  [R-(D)COM Interface](http://cran.r-project.org/contrib/extra/dcom/). Por supuesto, también necesitamos tener instalado R 2.8.1. Por otra parte puede ser conveniente instalar un paquete de R llamado rcom con todas sus dependencias.

A partir de aquí, este artículo está dividido en tres partes por motivos didácticos. Primero se habla de cómo se trabaja con Rcom, después describimos cómo se usa el visor de histogramas (que es el ejemplo propuesto), y por último entramos en algunos detalles del código.

Para descargar el código fuente de R2csharp  podéis hacer un *git clone* del proyecto de GitHub:

```bash
git clone https://github.com/benizar/r2csharp.git
```

## Uso básico de Rcom
Una vez instalado el servidor COM agregamos todas las referencias a un proyecto WindowsForm  en nuestro IDE de C# y sus correspondientes using (aquí hemos trabajado con Visual C# Express Edition).

``` csharp
using STATCONNECTORCLNTLib;
using StatConnectorCommonLib;
using STATCONNECTORSRVLib;
```

Con lo que podemos crear nuestro primer objeto de conexión a R, e iniciar una sesión

```csharp
//Conexión a R
StatConnector sc1 = new STATCONNECTORSRVLib.StatConnectorClass();
sc1.Init("R");
```

A partir de aquí trabajaremos con tres métodos para interactuar con la sesión de R. Estos son:

- `sc1.EvaluateNoReturn(código de R);`
- `sc1.Evaluate(código de R);`
- `sc1.GetSymbol(nombre de un objeto de R);`


He observado que en ocasiones es indistinto el uso de las dos primeras, pero también podemos recibir una excepción en tiempo de ejecución, por lo que utilizaremos la primera para ejecutar código de R que no tiene porqué devolver ningún resultado (por ejemplo `setwd(C:/)` , asigna el directorio de trabajo de R), mientras que el resultado de `sc1.evaluate()` habitualmente querremos almacenarlo en un objeto para poder consultarlo (no tiene sentido hacer un `getwd()` para después no mostrar su valor, `sc1.Evaluate(wd<-getwd())`, con esto almacenamos el `wd` en un objeto, el cual podemos consultar desde nuestra aplicación).


Por último, `sc1.GetSymbol(wd)` nos sirve para consultar un objeto creado en nuestra sesión de R y manipularlo. Por ejemplo, podríamos querer mostrar en una etiqueta lblWD la ruta del directorio de trabajo.

```csharp
string wd = (string)sc1.GetSymbol("wd");
lblWD.Text = wd;
```

Hasta aquí ya hemos visto todo lo necesario para interactuar con R. Pero la complejidad puede ser mayor debido a las diferencias entre tipos de datos de R y de .NET. Mientras que en R hablamos entre otros de vectores, listas, matrices y dataframes (de números, caracteres...), en .NET tendremos arrays de distintos tipos o tipos simples. Deberemos consultar el tipo antes de almacenar los datos en estructuras de .NET. Esto lo podemos hacer mediante:
    

```csharp
txtType.Text = sc1.GetSymbol("wd").GetType().ToString();
```
    
donde averiguamos que la función getwd() devuelve un string de .NET. Utilizaremos `GetType()` muy amenudo. Solamente hay que pensar que estructuras como un dataframe tendrán una estructura en .NET de array de arrays de... por lo que deberemos tener muy en cuenta los tipos de cada vector miembro del dataframe (podemos entender un dataframe como un conjunto de vectores relacionados; cada vector puede ser un campo de la tabla que es un dataframe).
    

## R2csharp_histoviewer
Nuestra aplicación es algo más que un "!Hola mundo ¡". Tiene ejemplos básicos de distintas tareas habituales en R, pero en este caso realizadas desde nuestra aplicación. En esta demostración creamos un visor de histogramas con Windows Forms, que organiza la información de R de un modo claro y permite crear, mostrar, editar y eliminar dataframes de R, ejecutar una sencilla función de R ( `hist( )` ), y también crear y eliminar ficheros en el sistema operativo (imágenes, directorios...).


Podemos simular una sesión de trabajo con este visor siguiendo estos pasos (también vemos la correspondencia de las acciones en comandos de R):

1. Seleccionar cargar objeto para añadir uno a uno los tres ficheros de ejemplo (bichos.txt, spatstat.txt y usos.txt)
    `read.table()`
2. Seleccionar el objeto bichos y borrarlo
    `rm(bichos)`
3. Seleccionar un campo en el segundo listbox y crear su histograma presionando el botón Hist.
    `hist(objeto$campo)` / nos ahorra hacer un `attatch()` en R
4. Editar una celda del campo "incendio" del objeto usos. Cambiar algún 0 por 100, y creamos de nuevo el histograma. Vemos como ha cambiado el objeto de R sin necesidad de conocer la posición del dato dentro del dataframe. (para   saber que estamos editando en el row del datagridview deberá verse un lapiz sobre el "row head")
    
![Vista de la aplicación en funcionamiento]({{ site.url }}/images/rcom-histoviewer.jpg){: .align-center}
    
Evidentemente, sin que el usuario lo sepa se están realizando varios `list()`, se aplican filtros, se obtienen los `rownames()` y `colnames()`, y otras operaciones habituales en R que aquí no se necesitará teclear y cuyos resultados estarán siempre visibles. Lo cual hace que nuestro interfaz sea más amigable solo por esto.
    
## Algunas notas sobre el código:
    
Entre las tareas más interesantes en el código podemos ver un ejemplo de lectura y escritura de un dataframe en un datagridview, teniendo en cuenta los dos tipos de datos devueltos (enteros y dobles). El fichero de ejemplo spatstat.txt intercala columnas de datos dobles y enteros, claro que también podría haber `String []` u otros, pero confiamos en que estas mejoras las puedan realizar nuestros lectores.

En el flujo de trabajo habitual hay dos tipos de objetos, los que contienen nuestros datos y los que utilizamos para interactuar con R. Estos últimos los ocultamos al usuario mediante condiciones `if`.
    
A la hora de crear imágenes temporales podemos hacer que se muestren en el device de R si no especificamos ningún dispositivo de salida para `hist()`. Aunque me ha parecido más interesante integrar la gráfica en el formulario. Para esto hay que decir que existe un problema al usar el portapapeles de Windows para almacenar un metafile, que es el único formato que R nos permite. Se trata de una incompatibilidad del SO que no nos permitirá recuperar la imagen del clipboard para mostrarla en el picbox (podemos consultar algo acerca de esta cuestión en <http://support.microsoft.com/?scid=kb%3Ben-us%3B323530&x=11&y=12> ) Por este motivo, recurrimos a crear nuestro propio directorio temporal, el cual eliminamos al cerrar el formulario.
    
Hay que decir que Rcom aporta muchas posibilidades más directas para mostrar o trabajar con los datos de R. No obstante, considero que ya es mucho trabajo conocer un lenguaje de .NET y tener conocimientos de R, como para también especializarse en todas las opciones de Rcom. Para empezar está muy bien, pero en caso de trabajar a menudo con estas herramientas debería explorarse los ejemplos de Rcom, por si resultan más funcionales.

Una consideración que puedo transmitir a los lectores es que no existe ningún *binding* para C# /.NET que nos evite tener que embeber código de R en nuestra aplicación, así como existe rJava (<http://cran.r-project.org/web/packages/rJava/index.html>). En caso de disponer de tal posibilidad la hubiésemos utilizado por múltiples motivos, sobretodo por el uso de un solo lenguaje de programación, lo que facilita la comprensión y sencillez del código y también la depuración de la aplicación.

No es necesario advertir que un buen conocimiento de R y las funciones que se quiera aplicar es fundamental para diseñar el mejor interfaz de usuario posible. Pero en determinados casos donde se debe efectuar análisis exploratorios de los datos el esfuerzo se verá compensado por la comodidad y la rapidez en el trabajo. Incluso pensándolo bien, en equipos de trabajo donde haya investigadores o técnicos que no dominen R la creación de un interfaz de este tipo puede ser más que interesante.
    
## Algunas referencias:

En <http://www.codeproject.com/> existe un ejemplo de aplicación para C# (<http://www.codeproject.com/KB/cs/RtoCSharp.aspx>) donde se repasan las posibilidades básicas para interactuar con R. También hay varios ejemplos de código disponibles para VB6 en la carpeta donde se nos instala el COM Server (por defecto "C:\Archivos de programa\R\(D)COM Server\samples"). Por último, la lista de distribución de Rcom donde se tratan muchas cuestiones relacionadas está en <http://mailman.csd.univie.ac.at/pipermail/rcom-l/>.
    
## Datos de ejemplo:

- [Descargar usos.txt]({{ site.url }}/downloads/usos.txt)
    
- [Descargar spatstat.txt]({{ site.url }}/downloads/spatstat.txt)

- [Descargar bichos.txt]({{ site.url }}/downloads/bichos.txt)
