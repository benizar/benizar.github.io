---
title: Group zipping GIS Files made easy
categories: [Programming, Data Management]
tags: [multi-file formats, gnu parallel, command-line tools]
---

If you work with Geographic Information System (GIS) data, you're likely familiar with multi-file formats such as ESRI Shapefiles or SAGA GIS raster files. These file formats consist of several individual files with different extensions that need to be kept together to maintain their spatial information. If you're sharing or storing these files, it can be cumbersome to handle each file-group individually, especially if the files need to be compressed. This is where a bash script called **Group Zipping** comes in handy.

In this post, I propose a Bash script that helps compress ***GIS files that come in multiple files***. Here, I explain how the script works and highlight some of its features, such as parallelization, software and folder checks, filters, and a variety of available compression formats.

## Understanding multi-file GIS formats

There are many well-known multi-file formats outside of the GIS domain. Here are some examples:

- Microsoft Office documents (.docx, .xlsx, .pptx) are actually ZIP archives that contain multiple files, including XML files and media assets.
- Java JAR files are ZIP archives that contain compiled Java classes and resources.
- Adobe PDF files can contain multiple components, such as fonts, images, and metadata.
- EPUB files, used for e-books, are also ZIP archives that contain multiple HTML, CSS, and media files.
- Git repositories consist of multiple files that represent the codebase, including code files, configuration files, and metadata.

These are just a few examples, but there are many other multi-file formats in various domains, such as multimedia, software development, and scientific research.

As you can see, multi-file formats are a really common aproach for structuring (text based) data but they are usually combined into single containter, mostly for practical reasons. However, in other ocasions the formats are used without such combination.

Before we dive into the script, let's take a moment to review some examples of GIS formats that come in multiple *separate* files.

### ESRI Shapefiles

ESRI Shapefiles (or just *Shapefiles* or *shapes*) are a popular GIS format that store vector data, such as points, lines, and polygons. As you probably know, a complete shapefile consists of at least three files:

- `.shp`: the file that contains the geometry of the features (points, lines, polygons) in the shapefile.
- `.dbf`: the file that contains the attribute data (e.g. names, population, etc.) for the features in the shapefile.
- `.shx`: the file that contains the index of the features in the `.shp` file.

Optionally, a shapefile may also have other files associated:

- `.prj`: the file that contains the projection information for the shapefile
- `.sbn` and `.sbx`: files used for spatial indexing

Maybe, shapefiles are being replaced by other more modern formats but they are still widely used in many contexts. The structure of a shapefile is stil one of the first explanations in many "Intro to GIS" courses.

### SAGA Raster Files

SAGA raster files are another common GIS format that store raster data, such as elevation, temperature, rainfall, etc... A SAGA raster file consists of at least two files:

- `.sdat`: the file that contains the actual data
- `.sgrd`: the file that contains metadata about the data, such as the extent, resolution, and projection information

Optionally, a SAGA raster file may also have:

- `.sdat.aux.xml`: an auxiliary XML file that can store additional metadata or coordinate system information
- `.sdat.prj`: a file containing the projection information for the raster dataset
- `.sdat.cpg`: a file that specifies the encoding of the raster dataset
- `.sdat.vat.dbf`: a dBase file containing a value attribute table (VAT) for the raster dataset

Other GIS formats, such as GeoTIFF, NetCDF, and or KML/KMZ, also can store data in multiple files, maybe containing an external projection file or multimedia associated files that are referenced in the attribute table. Regardless of the format, it's important to properly organize and compress the files to avoid losing data or metadata, and to make it easier to share or store the data.

## Introducing the Bash Script

To help manage and compress multi-file GIS formats, I propose a Bash script that compresses files sharing a common prefix before the first dot in their filenames. Sometimes this pattern (*before the first dot*) is not the same as a 3-4 characters extension (e.g. in the case of `.sdat.aux.xml`, which is a composed extension). The script can work with many other formats but I have tested it with ESRI Shapefiles and SAGA rasters. Of course, it may also be useful in non GIS applications.

The main features of this script include:

- In terms of compression formats, the script supports several commonly used formats, including gzip, bzip2, xz, zip, lzma, lzip, lrzip, and 7zip. By default, the script uses gzip, but you can choose a different format using the `-f` or `--format` option.
- The script uses GNU Parallel to compress files in parallel, which can significantly reduce the compression time for large datasets. By default, the script uses only 1 of the CPU cores available in the system as the maximum number of parallel jobs. However, you can specify a lower or higher value using the `-j` or `--jobs option`. It's worth noting that running too many parallel jobs can overload the system and lead to slower processing times, so it's recommended to use a conservative number of jobs, especially if you're compressing large files or working on a system with limited resources.
- The script also performs a series of checks to ensure that the required software and folders are available before starting the compression process. If any issues are detected, the script will print an error message and exit with a non-zero status code.
- Additionally, the script allows you to filter the input files by specifying a pattern using the `-p` or `--pattern` option. The pattern can be any string that matches the common prefix of the files you want to compress.

The script provides some flexibility but to further optimize the compression process, here are some additional tips:

- Read and write to different disks: If possible, read the files from one disk and write the compressed files to another. This can help reduce disk contention and speed up the overall process.
- Limit the number of parallel jobs: Depending on the available resources, it may be more efficient to limit the number of parallel jobs to a smaller number. Experiment with different values to find the optimal number of jobs for your system.

The script could be adapted for different requirements and situations, but now it assumes that compressing is the main task of the computer when it is executed.

## Usage

The script supports the following parameters:

- `-h, --help`: Display the help message and exit.
- `-i, --input-folder`: The folder containing the files to compress (default: current directory).
- `-o, --output-folder`: The folder where compressed files will be saved (default: input folder).
- `-f, --format`: The compression format to use (supported: gzip, bzip2, xz; default: gzip).
- `-p, --pattern`: The pattern to filter file names in the input folder (e.g., '*pattern*'; default: all files).
- `-j, --jobs`: The number of parallel jobs to run (default: number of CPU cores).

Maybe a couple of examples will clarify what the script does.

### Example 1: Compressing an ESRI Shapefile

Let's say you have the following files in a folder:

```bash
some-streets-file.dbf
some-streets-file.prj
some-streets-file.shp
some-streets-file.shx
```

You can compress them using the following command:

```bash
./group-zipping.sh -i /path/to/files -o /path/to/output -f gzip -p 'streets'
```

This will create a file called `some-streets-file.tar.gz` in the output folder. The same with other shapefiles stored in the input folder.

### Example 2: Compressing a SAGA raster file group

Let's say you have the following SAGA raster file in a folder:

```bash
some-elevation-file.sdat
some-elevation-file.sgrd
some-elevation-file.sprj
some-elevation-file.mgrd
some-elevation-file.sdat.aux.xml
```

You can compress the file-group using the following command:

```bash
./group-zipping.sh -i /path/to/files -o /path/to/output -f gzip -p 'elevation'
```

This will create a file called `some-elevation-file.tar.gz` in the output folder. Again, this will do the same for the other SAGA raster files present in the input folder.


## Some last thoughts
The `group-zipping.sh` script can be a useful tool for compressing such groups of files. It supports several compression formats and includes several parameters that can be customized to fit your specific needs. With its support for parallelization, software and folder checks, the pattern filter... this script can help you to save time and disk space when working with large groups of GIS files.

In my case, I had 36 *medium sized* (3GB) SAGA raster files to compress. Nowadays, I'm working on Ubuntu 22.04 and I have all the dependencies installed (tar, gzip, GNU Parallel, etc). I achieved reducing the file sizes to 1/3 while keeping all associated files toghether (this means storing 30 GB instead of 100 GB). Using a `-j 8` parameter this was done in about 20 minutes in my personal computer. 

It took some time to write the script but I feel it won't be the last time I will be compressing my results like this.

I think there is still room for improvements. Maybe I will try to:

- Implement other compression formats.
- Develop a progress bar and more feedback for the user (but not affecting much the main tasks).
- Create unit tests to ensure there are no undesired effects.


## The Script

Read the code and try the script taking some precautions (e.g. backup copies, etc). I have not tested all the compression formats (zip and gzip work for me) but I think that they work in a similar way, so it should work correctly. Here I share the README file and the Bash script. They are stored as a GitHub gist.

<script src="https://gist.github.com/benizar/e07d68c1b765df46f6911094aad2f921.js"></script>

