# Making videotutorials on ubuntu

Ubuntu 18.04

### Recording a desktop session

It is important to adjust your monitor's resolution to 16:9 and something close to Youtube's HQ (¿1280x720?). When the resolution is higher, the screen elements will be too small...


## Change cursor size

- [How to Change Cursor Size on Ubuntu Desktop](https://vitux.com/how-to-change-cursor-size-on-ubuntu-desktop/)

```bash
gsettings get org.gnome.desktop.interface cursor-size
```

24 is the default cursor size (*small*), in pixels, for an Ubuntu desktop. Following pixel values correspond to the sizes you see in the graphical Settings utility:

24: Default

32: Medium

48: Large

64: Larger

96: Largest

You can change the cursor size from these options through the following command:

```bash
gsettings set org.gnome.desktop.interface cursor-size [sizeInPixels]
```

You will see the changes in the cursor size inmediately. Also, the graphical Settings utility will be sinchronized, so you don't need to worry about that.



## Set resolutions using multiple monitors

- [How to set resolutions with xrandr using multiple monitors](https://askubuntu.com/a/107092)


See my blog post and/or man xrandr for additional options (setting a resolution or dpi or frequency).

Post back, with the output of xrandr -q if you require specific help with your monitors.

Note: xrandr does not work with proprietary drivers.

[Proprietary drivers support](https://www.linuxquestions.org/questions/linux-hardware-18/xrandr-with-proprietary-nvidia-drivers-828508/)


[xrandr man page](http://manpages.ubuntu.com/manpages/precise/man1/xrandr.1.html)








[5 best screen recorders for Linux](https://www.addictivetips.com/ubuntu-linux-tips/best-screen-recorders-for-linux/)

1. Simple Screen Recorder
2. Kazam
3. [RecordMyDesktop](https://elsoftwarelibre.com/2016/02/22/grabar-la-pantalla-de-ubuntu-con-recordmydesktop/)
4. OBS

Record only monitor #1 
(Configure the monitor at the lowest resolution available, e.g. 1280x720)

```bash
recordmydesktop -o /home/benizar/out.ogv --display=$DISPLAY --width=1280 --height=720 --fps=15 --no-sound --on-the-fly-encoding --delay=10
```

Record monitor #2

```bash
recordmydesktop -o /home/benizar/out.ogv --display=$DISPLAY --width=1024 --height=768 -x=1680 -y=0 --fps=15 --no-sound --delay=10
```

### Display keyboard and mouse on screen

- Key-mon
- [Screenkey](https://gitlab.com/screenkey/screenkey)
- [Screenkey](https://www.linuxadictos.com/muestra-las-teclas-que-presionas-en-pantalla-con-screenkey.html) or [here in english](https://www.thregr.org/~wavexx/software/screenkey/)

The latest Screenkey 0.9 is available in the main WebUpd8 PPA. To add the PPA and install the app in Ubuntu, Linux Mint and derivatives, use the following commands:

```bash
sudo add-apt-repository ppa:nilarimogard/webupd8
sudo apt update
sudo apt install screenkey fonts-font-awesome
```

```bash
sudo apt-get update && apt-get install -y \
  python-gtk2 \
  python-setuptools \
  python-setuptools-git \
  python-distutils-extra \
  git
```

```bash
git clone https://github.com/wavexx/screenkey.git
cd Screenkey	
sudo ./setup.py install
```

Or it can directly been executed without any installation
```bash	
./screenkey
```



### Audio

- Micro
- Audacity


### Encode audios

For MP3, I strongly suggest using LameInstall Lame , considered by many (including me) THE best MP3 encoder, specially for VBR.

sudo apt-get install lame

And to encode:

lame -V 5 file.wav file.mp3

This will create a high-quality MP3 VBR file around ~130kbps, which is great for casual listening. Use -V 3 for average bitrates around ~200kbps

If you want to create id3v1 and id3v2 tags at the same time, you can use:

lame -V 5 --add-id3v2 --pad-id3v2 --ignore-tag-errors --ta artist --tl album --tt title --tn track --ty year --tg genre --tc comment file.wav file.mp3

For OGG, the most traditional encoder is VorbisInstall Vorbis

sudo apt-get install vorbis-tools

And to encode:

oggenc -q 3 -o file.ogg file.wav

Ogg is VBR by default. -q 3 stands for default quality, you may change 3 from -1 to 10, or omit the option. Also, output file is optional. If you omit -o file.ogg it will automatically create a file with same name as input and .ogg extension. It also supports multiple input files (you can encode several at once, for example, using *.wav)

And for tagging:

oggenc -a artist -t title -l album -G genre -c comment -o file.ogg file.wav

Last but not least, since you seem to be very interested in encoding, an amazing forum for audio technical details and awesome source of knowledge is HydrogenAudio

And, for GUI, you said it yourself: soundconverter is a great choice. It does have VBR for MP3 (for OGG, its the format's default, so don't worry).

### Editing video

- Kdenlive
- OpenShot


### Images and animations

- Inkscape
- Gimp
- Blender

### Draw on Desktop

- Ardesia
- Pylote
- Gromit-mpx con [este excelente post](https://ubuntinux.blogspot.com/2018/12/anotaciones-en-pantalla-con-gromit-mpx.html?m=1) de alguien que sabe de lo que habla. Escribir lo que uno quiere comunicar parece hoy más importante que nunca.
- flameshot


### Subtitles

- Aegisub


### OBS

OBS is an "All in one" software for creating videotutorials in a...

### Free and open resources

Recursos de audio:

  - Fresound.org
  - http://www.freesfx.co.uk
  - http://audionautix.com/
  - Youtube https://www.youtube.com/watch?v=o7lli0WLtsc


Recursos de imágen:

  - Wikimedia Commons
  - Open Clip Art
  - https://pixabay.com/en/


Recursos de Vídeo:

  - Archive.org
  - Youtube, Vimeo, etc

