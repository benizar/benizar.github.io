---
title: Extending Geopackages via SQLite's Run-Time Loadable extensions
excerpt: "Testing if Geopackages functionality can be extended via SQLite extensions. Can this work in QGIS?"
categories: [Analysis]
tags: [sqlite,spatialite,geopackage,extension,user-defined-function,stored procedure]
---

# Introduction
SQLite is expected to be very important for GIS users. **Two of the most promising GIS formats are based on SQLite: [Spatialite](https://www.gaia-gis.it/gaia-sins/) and [Geopackage](https://www.geopackage.org/)**. This way, understanding the basics of SQLite can be very useful for making the most of these data formats.

> Spatialite and Geopackage [...] understanding the basics of SQLite can be very useful for making the most of these data formats.

Geopackages are good for many different reasons and one can expect to find all of our favorite features in this GIS data format. In this sense, I'm a huge fan of Postgres *extensibility*. There are many options for extending Postgres. You can create new operators, aggregates, functions, types, etc... and pack everything in a custom extension. PostGIS is probably the most interesting example of Postgres extensibility. In Postgres, every-time we need to create a complex parametrized query, we can use `CREATE FUNCTION` and encapsulate it. This makes it easier to read/write complex queries (or Postgis geoprocesses) and improves code (re)usability. I would like to have such useful features in other databases and it would be amazing to have this features when working with Geopackages.

After my very first searches, I have learnt that **SQLite is not intended to have stored functions, so `CREATE FUNCTION` does not work**. However, in SQLite we can map functions from several programming languages (C, PHP, Python, Perl, .NET, among others) to SQL functions, namely **user-defined functions** and pack them in **Run-Time Loadable extensions**. It would be amazing if this approach could work also for Spatialite and Geopackages.

> SQLite is not intended to hold stored functions, so `CREATE FUNCTION` does not work [...] Run-Time Loadable Extensions. It would be amazing if this approach could work also for Spatialite and Geopackages.

There are various ways for extending SQLite, but using its **C API** seems more straightforward and portable. I guess that everything done this way should work in the most used GIS (QGIS, ArcGIS, etc). Let's do some tests...


# Experimenting
I'm working with Ubuntu 16.04, SQLite 3.11.0 and QGIS (2.8 and 3.0). First, install `sqlite3` and the `libsqlite3-dev`.
```bash
sudo apt-get install sqlite3 libsqlite3-dev
```

I'm not installing QGIS directly on my Ubuntu. Instead, I'm using dockers for testing on different QGIS versions without complications (check the [kartoza QGIS docker lib](https://github.com/kartoza/docker-qgis-desktop) for mor info).

## Sample extension
There are some official SQLite extensions and source code to read and get some ideas. After exploring some resources, I've created a simple `ifelse` function based on [this example](http://www.digitage.co.uk/digitage/library/linux/creating-a-custom-function-for-sqlite3).

```c
/* ifelse.c */

#include "sqlite3ext.h"
SQLITE_EXTENSION_INIT1;

#include <stdlib.h>

typedef sqlite3_int64 i64;

static void ifelseFunc(sqlite3_context *context, int argc, sqlite3_value **argv) {
        int flag = sqlite3_value_int(argv[0]);
        char *v1 = (char *)sqlite3_value_text(argv[1]);
        char *v2 = (char *)sqlite3_value_text(argv[2]);

        if (flag != 0)
                sqlite3_result_text(context, v1, -1, SQLITE_TRANSIENT);
        else
                sqlite3_result_text(context, v2, -1, SQLITE_TRANSIENT);
}


int ifelse_init( sqlite3 *db, char **error, const sqlite3_api_routines *api )
{
    SQLITE_EXTENSION_INIT2(api);

    sqlite3_create_function( db, "ifelse", 3, SQLITE_ANY, 
            NULL, ifelseFunc, NULL, NULL);

    return SQLITE_OK;
}
```

Then, compile it to get the binaries.
```bash
gcc -shared -fPIC -o ifelse.so ifelse.c -lsqlite3
```

## SQLite command-line testing

We need to be sure that this will work on a raw SQLite database, from the command-line, so I'm creating a dummy Landuse/Landcover (LULC) database.
```bash
sqlite3 lulc
```

After inserting some test data, we will use the `ifelse` function to print a description for two LULC codes (FOR -> Forest; URB -> Urban).
```sql
CREATE TABLE lulc (cover text NOT NULL);
INSERT INTO lulc VALUES('FOR');
INSERT INTO lulc VALUES('FOR');
INSERT INTO lulc VALUES('URB');
INSERT INTO lulc VALUES('FOR');
INSERT INTO lulc VALUES('URB');
```

Now, load the extension via the SQL function and the command-line, which should print an empty line.
```sql
SELECT load_extension('/path/to/extension/ifelse.so', 'ifelse_init');
```

The `ifelse` function can be tested and it works as expected.
```sql
SELECT ifelse(cover='FOR', 'Forest', 'Urban') FROM lulc;
--Forest
--Forest
--Urban
--Forest
--Urban
```

Finally, it can be checked that it is necessary to load this extension every-time we connect to the database. So `.quit` from sqlite3 and try to use the function again.

```sql
sqlite3 lulc
SELECT ifelse(cover='FOR', 'Forest', 'Urban') FROM lulc;
Error: no such function: ifelse
```

As you can see, it is necessary to load the extension every-time we connect to the lulc database.
```sql
SELECT load_extension('./ifelse.so', 'ifelse_init');
SELECT ifelse(cover='FOR', 'Forest', 'Urban') FROM lulc;
--Forest
--Forest
--Urban
--Forest
--Urban
```

## Working with geopackages in QGIS

Unfortunatelly, I have tested this approach via `DBmanager` in QGIS 3.0, but it didn't work. The extension can't be loaded using this approach. The `load_extension()` call returns a pretty clear message: `Not authorized`.

<figure class="half">

    <a href="{{ site.url }}/images/qgis28-spatialite-loading-extension.png"><img src="{{ site.url }}/images/qgis28-spatialite-loading-extension.png"></a>

    <a href="{{ site.url }}/images/qgis3-gpkg-not-loading-extension.png"><img src="{{ site.url }}/images/qgis3-gpkg-not-loading-extension.png"></a>

<figcaption>SQLite <em>load_extension()</em> doesn't work since QGIS 3.0.</figcaption>

</figure>

We can do this test in QGIS 2.8 and it will work correctly for Spatialite. However, Geopackages were not so well supported before QGIS 3.0. This difference between QGIS versions is due to a change in the Python version used since QGIS 3.x (see this answer on [gis.stackexchange](https://gis.stackexchange.com/a/280524)). 


# Conclusions

We have revised how to use the SQLite C API and it seems a very powerful approach for distributing data with some useful logic. For example, imagine that you want to distribute some data to GIS users, avoiding to describe complex parametrized queries. This could be achieved through Run-Time Loadable extensions...

I think that the most recent Python distributions are blocking this mechanism for some security reasons and this is directly incorporated into QGIS. However, this functionality seems very useful and I hope that there has to be a way of loading extensions without compiling QGIS from sources.



# Resources

These are some resources I have revised for writing this post.

## Geopackages

- [FOSS4G-2013 slides](http://www.justobjects.org/download/geopackage/foss4g2013_geopackage.pdf)
- [Switch from Shapefile](http://switchfromshapefile.org/)
- [Comparing GEOCSV, Geopackage and Geojson (spanish)](https://mappinggis.com/2015/09/geocsv-geopackage-y-geojson-las-nuevas-alternativas-al-shapefile/)
- [Geopackages in ArcGIS, QGIS and Geoserver (spanish)](https://mappinggis.com/2017/06/geopackage-para-novatos-uso-en-arcgis-qgis-publicacion-en-geoserver/). 

## SQLite

- [SQLite user-defined-functions](https://stackoverflow.com/a/2108921)
- [Runtime Loadable Extension](https://www.sqlite.org/loadext.html)
- [IfElse function](http://www.digitage.co.uk/digitage/library/linux/creating-a-custom-function-for-sqlite3)

