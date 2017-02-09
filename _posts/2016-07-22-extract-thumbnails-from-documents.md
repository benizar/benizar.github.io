---
title:  "Extracting thumbnails from a PDF page"
excerpt: "Use ImageMagick from command-line for extracting thumbnails from any PDF."
categories: 
  - Snippets
tags: [thumbnails, image processing, ImageMagick, bash]
---

Yesterday, I wanted to extract several thumbnails for publishing in this website. I usually do this kind of tasks using Gimp. However, I think that I will need to do this too many times in the future. For this reason, I tried to do it using [ImageMagick](http://www.imagemagick.org) ... Now, I have decided that I really like it. According to its website, 

> ImageMagic is a software suite to create, edit, compose, or convert bitmap images. It can read and write images in a variety of formats (over 200) including PNG, JPEG, JPEG-2000, GIF, TIFF, DPX, EXR, WebP, Postscript, PDF, and SVG. Use ImageMagick to resize, flip, mirror, rotate, distort, shear and transform images, adjust image colors, apply various special effects, or draw text, lines, polygons, ellipses and Bézier curves.

The functionality of ImageMagick is typically utilized from the command-line so, virtually, it can be exploded by programs written in any programming language. I tested the `convert` command to automate the following steps:

1. Convert the first page of a PDF to PNG.
2. Adjust the image quality.
3. Resize it (my PDFs are A4 format, so resizing to 10% is enough for a miniature).
4. Set the background colour.
5. Add a thin black border.
6. Save the miniature into the images folder.
7. Use a loop for batch processing.

For example, this is the code used to prepare one of the miniatures included in the CV section of this website: 

``` bash
convert -density 300 -resize %10 \
        -background white -alpha remove -bordercolor black -border 1 \
        download/curriculum_eng.pdf[0] images/curriculum_eng.png
```

The following image is the result of processing [PDF]({{ site.url }}/download/cvn_english.pdf)

![cvn_english]({{ site.url }}/images/cvn_english.png){: .align-left}

The `convert` command can be used to *convert* between image formats as well as resize an image, blur, crop, despeckle, dither, draw on, flip, join, re-sample, and much more. See the [Command Line Processing](http://www.imagemagick.org/script/command-line-processing.php) documentation for learning more about its possibilities.

Sometimes, I need to process image files for accomplishing different tasks (watermarks, resizing, crop, convert to grayscale, etc). In the future, I will commit such new scripts [here]({{ site.url }}/images/convert_commands.md).

I hope you enjoyed this post ;)
