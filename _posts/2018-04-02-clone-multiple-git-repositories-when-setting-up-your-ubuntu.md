---
title: "Clone multiple git repositories when setting up your Ubuntu"
excerpt: "Clone multiple git repositories at once using a bash script and lists of your projects."
categories: [Snippets]
tags: [git, clone, bash]
---

This post is to share a bash script I always wanted to write. I have been searching for a while for a simple script for automatically clonning all my git repositories, **no matter if they are stored in GitHub or Bitbucket**. I have found many interesting approaches but I finally decided to write my own solution.

The `multiple-git-clone.sh` script is stored in a Gist and allows me to create several lists of repositories (e.g. grouped by owner, project, platform, etc) and clone all in a single step.

Of course there are many improvements I could use (e.g. error management, ask for `pull` instead of `clone` if necessary, etc) but for now it is enough when setting up a new machine.

I hope you like it ;) 


<script src="https://gist.github.com/benizar/03c5ede574ac7b847413857f74bb04b3.js"></script>
