# My first personal website

Powered by Jekyll & Minimal Mistakes (and some other nice tools :).


## Requirements

In order to reproduce this workflow it is necessary to have this software correctly installed:

- [make](https://www.gnu.org/software/make/)
- [git](https://git-scm.com/)
- [docker](https://www.docker.com/) and [docker-compose](https://docs.docker.com/compose/)
- My [benizar/jekyll](https://hub.docker.com/r/benizar/jekyll/) image from Docker Hub.

## Working with Git branches

This project has two git branches:

1. The `source` branch contains the Jekyll project.
2. The `master` branch publishes the website (gh-pages).

This approach is very convenient for using Jekyll plugins and deploy the website only when necessary.


## Using the Makefile

Use [Makefile](Makefile) as usual but, when you execute `make`, it shows info about the most common tasks of my workflow:

1. `make 1-new-draft`: Helps to create a new draft (and opens it in gedit).
2. `make 2-start-server`: Starts the jekyll server using dockers (and opens it in a web browser).
3. `make 3-stop-server`: Stops the docker and removes everything.
4. `make 4-push-source`: Pushes all edits to the source branch.
5. `make 5-deploy-website`: Pushes the updated .

## Publish the website to GitHub

**Watch out!** *It is very IMPORTANT to git commit and git push your edits to the source branch before deploying your website* (or you can do `make 4-push-source`)

For deploying your website to GitHub you can do it by hand or using the [deploy-website.sh](deploy-website.sh) script as follows:

```bash
bash deploy-website.sh
```

This script is going to:
1. Make sure you're on the SOURCE branch
2. `jekyll build` your site
3. Copy the _site to a temporary folder
4. Delete the remote and local MASTER branch
5. Create a new MASTER branch
6. Copy the temporary folder contents to this branch (MASTER)
7. Push your site to GitHub (MASTER)
8. Switch back to the SOURCE branch


## TODO

- Try to map users dynamically from Make and compose [Docker compose as non root user](https://medium.com/redbubble/running-a-docker-container-as-a-non-root-user-7d2e00f8ee15)


