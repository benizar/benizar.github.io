---
title:  "Customize animated titles in OpenShot"
excerpt: "How to create animated titles in OpenShot with transparent background. Solving a bug and discovering python scripting in Blender."
categories: [Multimedia, Teaching]
tags: [animations, video editing, OpenShot, Blender, python]
---

Educational videos are a great teaching tool, so I have been learning how to create them by using FOSS. Unfortunately, I have not found a free software that has everything you need to create a quality educational video. Probably, even commercial programs have their own limitations and several programs are always needed.


## Nice features in OpenShot

In this post I want to comment why I think that OpenShot is a very interesting software that you should try for preparing your educational videos.

After some tests in Ubuntu 15.10 and the recommended software versions. I must admit that OpenShot seems to lack stability and crashes too often when performing quite simple tasks. For plain video editing I prefer the Kdenlive stability. However, I think that OpenShot is much more intuitive and has some interesting features related to effects and animations.

[OpenShot](http://www.openshot.org/) is a free, simple-to-use, feature-rich video editor for Linux, Windows and Mac. Of course, it has many good things, but I'm very impressed with the amazing **Animated Title Editor**. You can [read this post](http://www.openshotvideo.com/2010/06/new-feature-3d-animated-titles.html) about it.

<figure class="half">
    <a href="{{ site.url }}/images/Overlay_3D_Title.png"><img src="{{ site.url }}/images/Overlay_3D_Title.png"></a>
</figure>

This feature is presented as easy-to-use templates that execute python scripts in Blender, so there is no need to learn Blender to include some nice animations in your educational videos.


## A problem with customization

In the above mentioned post, it seems that in these animated titles have *full alpha (i.e. transparency), and can be composited on top of any other video, such as the screenshot above of the chimpanzee*. However, it appears to be a problem with this, and I was not able to do so.

I have found info on this bug [here](https://bugs.launchpad.net/openshot/+bug/1365851) and [here](https://www.mp-development.de/blog/18-openshot-blender-titelanimation-transparenz-fehler). There is a workaround for achieving transparent background on your animated titles. It implies that you have to edit those python scripts that execute Blender.

As explained in those links, you have to edit the phython-script files in /usr/share/pyshared/openshot/blender/scripts/

In each script search for 

```python            
'color' : [0.8,0.8,0.8],
'alpha' : 1.0,
```

and add this line

```python            
'alpha_mode' : 'TRANSPARENT',
```

Then search for

```python
except:
    bpy.context.scene.render.image_settings.file_format = params["file_format"]
    bpy.context.scene.render.image_settings.color_mode = params["color_mode"]
```

and add these lines

```python
try:
    bpy.context.scene.render.alpha_mode = params["alpha_mode"]
except:
    pass
```

## Already edited scripts

In the above mentioned link, [mEon](https://launchpad.net/~me.on.line) shared all the modified scripts in a dropbox public link. That link is still active, but I want to collaborate to the diffusion of these scripts by sharing an additional link:

- [mEon link](https://dl.dropboxusercontent.com/u/1383938/usr-share-pyshared-openshot-blender-scripts.tar.gz)
- [My link]({{ site.url }}/download/usr-share-pyshared-openshot-blender-scripts.tar.gz)


## Opportunities

All those animated titles are very nice, but I wonder how can I create more customized animations with a little python scripting. Take a look at the [Blender Wiki example on using python scripts](https://wiki.blender.org/index.php/Doc:2.4/Manual/Extensions/Python/Example). 

I'm sure that I can found many other scripts somewhere in the Internet. I will keep you informed ;)
