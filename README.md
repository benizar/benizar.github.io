# My first personal website

Powered by Jekyll & Minimal Mistakes.

## Workflow

In order to reproduce this workflow you should have git, docker and docker-compose correctly installed.

This project is managed in two different git branches:
1. The `source` branch contains the Jekyll project
2. The `master` branch publishes the website using gh-pages.

Use [Docker Compose](https://docs.docker.com/compose/) and the [deploy.sh](deploy.sh) script as follows:

1. `docker-compose up` runs Jekyll with drafts and defaults.
2. Edit your website contents (pages, posts, etc) and see your edits in the browser.
3. Remember to `docker-compose down` when finished.
3. `git commit` and `git push` your edits. THIS IS IMPORTANT!!!
5. Finally, ***if you want to deploy your updated website*** do `bash deploy.sh` to deploy your *_site* to gh-pages (master branch).
