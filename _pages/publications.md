---
title: "Publications"
date: 2013-04-08
modified: 2016-01-12
excerpt: "My publications compiled using jekyll-scholar"
permalink: /publications/
---

{% include toc icon="file-text" title="By categories" %}

**Note:** This is an almost full list of my publications, but you are encouraged to check my other Profiles for aditional details. This bibliography was created using Mendeley Desktop, BibTeX, jekyll-scholar and my own CSL style [my-apa-cv.csl]({{ site.url }}/_bibliography/my-apa-cv.csl). This CSL is adapted from the [apa-cv.csl](https://github.com/citation-style-language/styles-distribution/blob/master/apa-cv.csl) format, but adding a couple of interesting changes :eyes:
{: .notice--info}



## Articles

{% bibliography --query @article %}

## Book Chapters

{% bibliography --query @incollection %}

## Conference Papers

{% bibliography --query @inproceedings %}

## PhD Thesis

{% bibliography --query @phdthesis %}


