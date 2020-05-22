---
title: Choosing a desktop marker app for Ubuntu 18.04 LTS
categories: [Multimedia]
tags: [desktop marker,screen capture,ardesia,gromit,pylote,ubuntu,epic pen]
excerpt: "In this post I explain the main features of two desktop bookmarking apps in Ubuntu 18.04: Pylote and Gromit-MPX. Both tools come in handy when making presentations, pointing to something during a video recording, or can even improve the way I've been taking screenshots for my documentation."
---

# Introduction

In the last few months many professionals have stopped leaving home to go to work and, among these, there are a good number of people who, like me, are trying to find the best way to work from home.

In my office I have to work with different operating systems but at home there is only Ubuntu. This is why in the last few weeks I have had to go back to review a good number of apps that I haven't used on a daily basis for a long time.

In this post I am going to talk about those applications that we use when we are making a presentation with the computer and we want to point, write or draw something in a spontaneous way. This is about the desktop annotation tools.

## My needs

First or second thing I made two months ago, when the coronavirus changed our lives, was to setup my working environment. I'm still on it but I feel that I'm very close to solve all the minor problems I experienced in the begining. I had to upgrade my personal computers from Ubuntu 16.04 to Ubuntu 18.04. Many new programs have dependencies that make very awful to instal some programs.

In a streaming web conference, I saw one presentation where the researcher was using [epicpen](https://epic-pen.com/) for pointing out things on his slides and figures. That was much more better than using the mouse pointer. Epicpen is still in development but it's pretty cool and has many features. The main problem with this app right now is that it's not designed to be multiplatform and it's not FOSS. I'm not a designer, I just want to sketch a couple of *messy* lines and arrows, so I'm not even considering a comercial software.

Actually, working from home there is a wish list of the desirable characteristics these programs should have. This apps should be capable of:

- Drawing points, lines and polygons of at least 4 or 5 colours.
- Writing text using any of both options, using the keyboard or writing with a digitizing tablet.
- Draw on top of my documents and figures without being too anoying for the people watching (e.g. too many buttons and controls arround).
- Speeding up my presentation (e.g. shortcuts for switching pens, colours, etc)
- Working in a two monitor configuration (e.g. when recording video I don't want the app occuping my space).
- When preparing software tutorials, it would be awesome to draw over expanded app menus, but I think I'm asking for too much :)


# Ardesia

A few years ago, I used to use [Ardesia](https://code.google.com/archive/p/ardesia/) for sketching over the screen. A GPL licensed software that was able to do almost all I needed. However, this project is no longer maintained by its creator. It was working with difficulties in Ubuntu 16.04 but it was still distributed from official packages. It's a pitty because it was very useful.

In case you want to try it (under your own responsibility), Ardesia's code is available from different repositories and it still works in Ubuntu 18.04. I have installed it following the project README with a few small changes: 

```bash
# Install Ardesia on Ubuntu 18.04
# Use code from non trusted repositories at your on risk!
# libpng12-dev is no longer available, use libpng-dev
sudo apt-get install gcc make automake autoconf intltool libtool libtool-bin libxml2-dev libgsf-1-dev libgtk-3-dev libatk1.0-dev libx11-dev libpng-dev libglib2.0-dev libgconf2-dev libfontconfig1-dev libfreetype6-dev libgsl0-dev libc6-dev xdg-utils librsvg2-dev

# Download sources from github. I just made a fork.
git clone https://github.com/benizar/ardesia.git
cd ardesia/

# Compile as a *.deb package
sudo apt-get install devscripts
./autogen.sh
make deb
sudo dpkg -i ardesia_1.2-1_amd64.deb
```

Now, run it with parameters so you can control its behaviour
```bash
ardesia --help
ardesia -g south -d -t 50
```

# Pylote


# Gromit-MPX

<script src="https://gist.github.com/benizar/5d5e08b9b1f82619a747cea547ba236a.js"></script>

# Conclusions


