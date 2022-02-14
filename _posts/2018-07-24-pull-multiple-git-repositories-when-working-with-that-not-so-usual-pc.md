---
title: "Pull multiple git repositories when working with that not-so-usual PC"
excerpt: "Pull multiple git repositories at once using a simple bash script."
categories: [Snippets]
tags: [git, pull, bash]
---

At least, every few days I change my workplace and I work on a different computer (home-laptop-work). For this reason, I usually need to ensure that I'm using the latest version of each repository.

After writing a [script to facilitate the task of clonning several Git repositories]({{ site.baseurl }}{% post_url 2018-04-02-clone-multiple-git-repositories-when-setting-up-your-ubuntu %}), it is logical to consider the same when I need to pull them. In this post I want to share the script I use to automatically pull all my git repositories in one step, **no matter if they are stored in GitHub, GitLab or Bitbucket**. Practically, its the same script proposed by [douglas](https://gist.github.com/douglas/1287372), but simpler and following my personal naming convention...

The `multiple-git-pull.sh` script is stored in a Gist and allows me to pull several repositories stored in the same working folder (e.g. /home/user/git).

Avoid some headaches and innecesary pulls just by executing this script in your git working folder (if you have one :)

```bash
bash multiple-git-pull.sh
```

I hope you like it ;)

<script src="https://gist.github.com/benizar/f192ea5a2d1d6f63f56345733788e16b.js"></script>



