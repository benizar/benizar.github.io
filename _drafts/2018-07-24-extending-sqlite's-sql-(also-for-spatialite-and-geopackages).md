---
title: Extending SQLite's SQL (also for Spatialite and Geopackages)
excerpt: "How to create user-defined functions in SQLite."
categories: [Analysis]
tags: [sqlite,extension,user-defined-function,stored procedure]
---

# Introduction
SQLite is expected to be very important between GIS users and this is because **two of the most promising GIS formats are based on SQLite: [Spatialite](https://www.gaia-gis.it/gaia-sins/) and [Geopackages](https://www.geopackage.org/)**. This way, understanding the basics of SQLite can be very useful for understanding these GIS data formats.

I'm not writing a SQLite tutorial or a post about Geopackages advantages, there are many interesting resources for that. However, if you want to read a little, there are some related links at the end of this post.

Geopackages are good for many different reasons and one can expect to find all of our favorite features in this GIS data format.

I'm a huge fan of Postgres *extensibility*. There are many options for extending Postgres. You can create new operators, aggregates, functions, types, etc... and pack everything in a custom extension. For GIS users, PostGIS is probably the most interesting example of Postgres extensibility.

In Postgres, everytime I need to create a complex parametrized query, I can use `CREATE FUNCTION` and encapsulate it. This makes it easier to read/write complex queries (or Postgis geoprocesses) and improves code (re)usability. I would like to have such useful utilities in other databases but... **Wait! SQLite is not intended to have stored functions, so `CREATE FUNCTION` does not work**. However, in SQLite you can map functions from several programming languages (C, PHP, Python, Perl, .NET, among others) to SQL functions, namely **user-defined functions** and pack them in **Run-Time Loadable Extensions**. This should work also for Spatialite and Geopackages.

There are various ways of extending SQLite, but using its **C API** seems more straightforward and portable. I guess that everything done this way has to work in the most used GIS (QGIS, ArcGIS, etc). Let's do some tests...

# Experimenting
I'm working with Ubuntu 16.04, SQLite 3.11.0 and QGIS 2.8.

First, I install `sqlite3` and the `libsqlite3-dev`. Note that you also need a `dev` library for installing Postgres extensions.
```bash
sudo apt-get install sqlite3 libsqlite3-dev
```

## Sample extension
There are some official SQLite extensions and some useful source code to read and get some ideas. After exploring some resources I've created a simple `ifelse` function based on [this example](http://www.digitage.co.uk/digitage/library/linux/creating-a-custom-function-for-sqlite3).

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

Then, we can compile it
```bash
gcc -shared -fPIC -o ifelse.so ifelse.c -lsqlite3
```

## SQLite command-line testing

Open a terminal and create a test database. I'm creating a dummy landuse/landcover (lulc) database.
```bash
sqlite3 lulc
```

Add some test data
```sql
CREATE TABLE lulc (cover text NOT NULL);
INSERT INTO lulc VALUES('FOR');
INSERT INTO lulc VALUES('FOR');
INSERT INTO lulc VALUES('URB');
INSERT INTO lulc VALUES('FOR');
INSERT INTO lulc VALUES('URB');
```

Now we load the extension
```sql
SELECT load_extension('/path/to/extension/ifelse.so', 'ifelse_init');
```

And test it
```sql
SELECT ifelse(cover='FOR', 'Forest', 'Urban') FROM lulc;
#Forest
#Forest
#Urban
#Forest
#Urban
```

Now, we can exit sqlite and connect again.
```bash
.quit

sqlite3 lulc
```

Finally, we can check that it is necessary to load this extension everytime we connect to the database.
```sql
SELECT ifelse(cover='FOR', 'Forest', 'Urban') FROM lulc;
Error: no such function: ifelse

SELECT load_extension('./ifelse.so', 'ifelse_init');
SELECT ifelse(cover='FOR', 'Forest', 'Urban') FROM lulc;
#Forest
#Forest
#Urban
#Forest
#Urban
```

# Working with geopackages in QGIS
Need to enable extension loading...
no such function: sqlite3_enable_load_extension


# Conclusions

# Resources

Geopackages:

- [these slides](http://www.justobjects.org/download/geopackage/foss4g2013_geopackage.pdf)
- [this page](http://switchfromshapefile.org/)
- [this](https://mappinggis.com/2015/09/geocsv-geopackage-y-geojson-las-nuevas-alternativas-al-shapefile/)
- [this one](https://mappinggis.com/2017/06/geopackage-para-novatos-uso-en-arcgis-qgis-publicacion-en-geoserver/). 

SQLite:

- [SQLite user-defined-functions](https://stackoverflow.com/a/2108921)
- [Runtime Loadable Extension](https://www.sqlite.org/loadext.html)
- [IfElse function](http://www.digitage.co.uk/digitage/library/linux/creating-a-custom-function-for-sqlite3)

