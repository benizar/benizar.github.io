include mks/*.mk


.PHONY: 1-start-server
## Start a Jekyll server at port 4000
1-start-server:
	docker-compose -f jekyll-serve.yml up


.PHONY: 2-new-draft
## Create a new draft in the _drafts folder
2-new-draft:
	bash mks/new-draft.sh


.PHONY: 2-new-post
## Create a new post in the _posts folder
2-new-post:
	bash mks/new-post.sh


.PHONY: 3-stop-server
## Close the jekyll server
3-stop-server:
	docker-compose -f jekyll-serve.yml down


.PHONY: 4-deploy-website
## Deploy to ghpages
4-deploy-website:
	bash jekyll-deploy.sh
