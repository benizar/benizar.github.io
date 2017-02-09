# Making videotutorials on ubuntu

Ubuntu 15.10

## Tools and resources

- Unity tweak tool
  - Big mouse pointer
  - Themes, etc

- Gnome dconf editor
  - Zoom in/out con AltGr + F6/F7
  - Highlight mouse pointer with control

### Recording a desktop session

It is important to adjust your monitor's resolution to 16:9 and something close to Youtube's HQ (¿1280x720?). When the resolution is higher, the screen elements will be too small...

- Kazam
- recordMyDesktop

Record only monitor #1 
(Configure the monitor at the lowest resolution available, e.g. 1280x720)
recordmydesktop -o /home/benizar/out.ogv --display=$DISPLAY --width=1280 --height=720 --fps=15 --no-sound --on-the-fly-encoding --delay=10

Record monitor #2
recordmydesktop -o /home/benizar/out.ogv --display=$DISPLAY --width=1024 --height=768 -x=1680 -y=0 --fps=15 --no-sound --delay=10

### Display keyboard and mouse on screen

- Key-mon
- Screenkey

The latest Screenkey 0.9 is available in the main WebUpd8 PPA. To add the PPA and install the app in Ubuntu, Linux Mint and derivatives, use the following commands:

sudo add-apt-repository ppa:nilarimogard/webupd8
sudo apt update
sudo apt install screenkey fonts-font-awesome


Arch Linux users can install Screenkey via AUR (not updated to the latest 0.9 version at the time I'm writing this article).

For other Linux distributions, download Screenkey via GitHub.

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

