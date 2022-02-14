---
title: Using OBS Studio with V4L2 for making my videoconferences more appealing
excerpt: "In this post, I share the software configuration in Ubuntu to make video-conferences using a green chroma screen and your favorite video-conferencing software."
categories: [Multimedia]
tags: [obs, virtual webcam, chroma key,ubuntu,skype,hangout,zoom]
---

# Introduction

Nowadays, I'm doing more videoconferences, presentations and recording classes for my students using OBS (+ other software). When I find some time, I'm using a chroma background for my videos, so I considered to use the chroma for videoconferences and other online meetings.

There are many apps for doing this dinamically through the use of virtual webcams. In windows, we even could use Snapcam for adding special effects and in Ubuntu we could use [Webcamoid](https://github.com/webcamoid/webcamoid) for this. However, I wanted to do this using OBS because I would like to have more control over the scene, for example, I could show parts of my desktop or some slides without the need of sharing the screen. 

My working environment includes and old laptop with Ubuntu 16.04 LTS, a PC with 18.04 LTS, and I use the following videoconferencing platforms.

- For particular use:

    - **Skype** for Linux (ver. 8.59.0.77).
    - **Hangout**, working from firefox and chrome (I can't share screen from firefox, but it's my favourite web browser).
    - I recently met [Jitsi Meet](https://jitsi.org/jitsi-meet/) which works quite well too.

- And for a more professional use:

    - **Teams** for Linux, with a paid account from my University. Webcam was not working with the desktop app, so now I'm working from Chrome web browser.
    - **Zoom** client for Linux version 3.5 (specifically 3.5.361976.0301), with a paid account from a conference I'm attending.

In this post I'm explaining how I'm working with OBS-studio as a virtual webcam. This way I'm able to use the same configurations, scenes and shortcuts I have created for my videotutorials.


# Setting up the computer

Installing all the necessary packages for using this approach is not as straightforward as I would like but there is a lot of information arround to make it done.

This excelent [post](https://srcco.de/posts/using-obs-studio-with-v4l2-for-google-hangouts-meet.html) from *srcco.de* explains how to use this approach for using it with Google Meet, while Justin Warren makes a more detailed post explaining [How To Use OBS Studio With Zoom](https://www.eigenmagic.com/2020/04/22/how-to-use-obs-studio-with-zoom/).

After reading this and other references that I attach at the end of this post, I installed everything using the following commands:

```bash
# APT install basics
sudo apt-get install obs-studio
sudo apt install v4l2loopback-dkms
sudo apt install qtbase5-dev

sudo apt-get install libobs-dev      # In Ubuntu Bionic Beaver (18.04)
#sudo apt-get install liboobs-1-dev   # In Ubuntu Xenial (16.04)

# Build plugin
git clone --recursive https://github.com/obsproject/obs-studio.git
git clone https://github.com/CatxFish/obs-v4l2sink.git
cd obs-v4l2sink
mkdir build && cd build
cmake -DLIBOBS_INCLUDE_DIR="../../obs-studio/libobs" -DCMAKE_INSTALL_PREFIX=/usr ..
make -j4
sudo make install
```

I'm not sure if we still need the sources for `libobs` after installing the repository from APT. Another problem is that the plugins are not installed in the correct directory. Probably, we could provide a parameter to the make install command but I ended up doing as most of people do things:

```bash
cp /usr/lib/obs-plugins/v4l2sink.so /usr/lib/x86_64-linux-gnu/obs-plugins/
```

If you are installing `obs-v4l2sink` for the first time, maybe you can answer my doubts and remove unnecessary installation steps.


# Starting a session with a virtual camera

```bash
# Removing previous devices
sudo modprobe -r v4l2loopback

# Creating a new device with #10 id
sudo modprobe v4l2loopback video_nr=10 card_label="OBS Video Source" exclusive_caps=1
```

Now, I'm ready to start OBS and connect the webcam. Sometimes it will be necessary to check the `obs-v4l2sink` plugin. Go to `Tools > V42L Video Output` 

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


# Final thoughts
This is an old draft I prepared during the first lockdown of the COVID pandemics  (almost 1,5 years old). Problably there are better solutions for this now, because configuring OBS and virtual cameras before every videoconference was quite painful and I ended up showing my *very tidy* office when I work from home.

If I had an oportunity I would like to show you the usage in a short video. Another problem for using this approach is that you need a chroma screen in every location you need to do a videoconference, and that's not very practical.


# References

- [How to use OBS as a virtual webcam it with Google Meet](https://srcco.de/posts/using-obs-studio-with-v4l2-for-google-hangouts-meet.html)
- [How To Use OBS Studio With Zoom](https://www.eigenmagic.com/2020/04/22/how-to-use-obs-studio-with-zoom/)
- [obs-v4l2sink sources and docs](https://github.com/CatxFish/obs-v4l2sink)
- [deb plugin is not installed in the correct directory](https://github.com/CatxFish/obs-v4l2sink/issues/14)
- [Extra step needed for Ubuntu 18.04 64 bit](https://github.com/CatxFish/obs-v4l2sink/issues/30)
- [Parse webcam video format (useful when using older devices)](https://www.enmimaquinafunciona.com/pregunta/153782/webcam-real-redirigir-a-una-camara-web-virtual-via-terminal)
- [Use webcam simultaneously in two or more applications](https://www.timdejong.nl/blog/use-webcam-two-applications-under-linux-simultaneously-using-v4l2loopback?__cf_chl_jschl_tk__=77f36dc55acd078dd8c5f0b5ee442c3e96fffacf-1589389530-0-AfIWKSYj-YSsWxE57lZZ5u26QN9Xwqtupxx6VoP68iUJAiXP1_EI0ClHUEB9dP81tINrflcXY0Bch2lXEmcSkbx8uBKmlWOa-AE4G8uoMCsxmlyVZVDm7TINXC9StrQRjgcP-Q23Dy_o7MnIfmZtWxj5ArEFmaMVOEsOVUOJ23Un7-lFM3WaDoeXZjvxVgTA611X5e1pqmZEmTXYL1QBqHEY9_yVLari5mumf-fTLRl8xR2uWCZiHXp4TtIRMa5t-ujhOJPKCK5GcmsGpe3SZmzh31tcJJToI-A8aY3Pv3rVZFivi-IYMMRq93z9I6wWvwAijCcsNuwY9t4_HOulIs1MXGCjV6lVBamH4NHOSy49LKfRpxF3i_mdKZeNy0sHf3t1cVcghNsjPJL4ZawC8urJ_0v3QBdSyUIEkLFyFl0pKvxWay1GeGXg68fdgxNZYg)
- [Using webcamoid as a virtual camera in Ubuntu (using v4l2loopback or akvcam)](https://github.com/webcamoid/webcamoid/wiki/Virtual-camera-support)
