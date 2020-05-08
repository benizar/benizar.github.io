---
title: Using OBS Studio with V4L2 for making my videoconferences more appealing
categories: [Multimedia]
tags: [obs, virtual webcam, chroma key,ubuntu,skype,hangout,zoom]
---

# Introduction



## The Basics

My working environment includes and old laptop with Ubuntu 16.04 LTS and the following videoconferencing platforms. For particular use:

- Skype for Linux
- Google hangout, working from firefox and chrome, (I can't share screen from firefox, but it's my favourite web browser).
- I recently met [Jitsi Meet](https://jitsi.org/jitsi-meet/) which works quite well too.

And for a more professional use:

- Teams for Linux, with paid account from my University.
- Zoom client for Linux version 3.5 (specifically 3.5.361976.0301), with a paid account from a conference I'm attending.



# Setting up your computer


This excelent [post](https://srcco.de/posts/using-obs-studio-with-v4l2-for-google-hangouts-meet.html) from srcco.de explains how to use this approach for using it with Google Meet, while Justin Warren makes a more detailed post explaining [How To Use OBS Studio With Zoom](https://www.eigenmagic.com/2020/04/22/how-to-use-obs-studio-with-zoom/).



I'm still using Ubuntu Xenial (16.04) but 
sing [liboobs-1-dev](https://packages.ubuntu.com/xenial/liboobs-1-dev) as an alternative to

```bash
# APT install basics
sudo apt install obs-studio
sudo apt install v4l2loopback-dkms
sudo apt install qtbase5-dev

# Get obs-studio source code
git clone --recursive https://github.com/obsproject/obs-studio.git

# Build plugins
git clone https://github.com/CatxFish/obs-v4l2sink.git
cd obs-v4l2sink
mkdir build && cd build
cmake -DLIBOBS_INCLUDE_DIR="../../obs-studio/libobs" -DCMAKE_INSTALL_PREFIX=/usr ..
make -j4
sudo make install
```


## Starting a session with a virtual camera

```bash
# Removing previous devices
sudo modprobe -r v4l2loopback

# Creating a new device with #10 id
sudo modprobe v4l2loopback video_nr=10 card_label="OBS Video Source" exclusive_caps=1
```

Now, I'm ready to start OBS and connect the webcam

And sometimes it will be necessary to check the `obs-v4l2sink` plugin. Go to tools>


I let the autostart off because... This is necessary when changing videoconferencing platform, because each platform may accept different video input formats. For example, I have tested these in my computer:

YUV420:
Hangout, Zoom

YUV2:
Skype, Yitsi




## Are there any problems?

I found the answer [here](https://unix.stackexchange.com/a/427800) or at least I can start the process from zero.

It can be done by removing the v4l2loopback module:

```bash
sudo modprobe -r v4l2loopback
```

and then we can check that all the virtual devices are gone

```bash
ls -l /dev/video*
```


# References


- [obs-v4l2sink sources](https://github.com/CatxFish/obs-v4l2sink)
