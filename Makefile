include mks/*.mk

## Build and deploy your website
all: clean settings logs letters

.PHONY: new-draft
## Create a new draft in the _drafts folder
new-draft:
	bash mks/new-draft.sh

.PHONY: new-post
## Create a new post in the _posts folder
new-post:
	bash mks/new-post.sh
