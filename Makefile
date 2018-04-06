include contrib/*.mk


.PHONY: 1-start-server
## Start a Jekyll server at port 4000
1-start-server:
	@docker-compose -f contrib/jekyll-serve.yml up -d
	@echo "Opening a web browser..."
	@sleep 15s
	@sensible-browser http://0.0.0.0:4000/
	


.PHONY: 2-new-draft
## Create a new draft in the _drafts folder
2-new-draft:
	bash contrib/new-draft.sh


#.PHONY: 3-promote-draft
## Promote draft to the _posts folder
#3-promote-draft:
#	bash contrib/promote-draft.sh


.PHONY: 3-stop-server
## Close the jekyll server
3-stop-server:
	@docker-compose -f contrib/jekyll-serve.yml down
	@echo "Removing '_site' ..."
	@docker-compose -f contrib/jekyll-rm.yml up -d
	@docker-compose -f contrib/jekyll-rm.yml down


.PHONY: 4-deploy-website
## Deploy to ghpages
4-deploy-website:
	bash contrib/jekyll-deploy.sh


