DEPLOY_PATH=/tmp
BIN_PATH=bin

help:
	@echo 'Makefile for a jekyll web site                                         '
	@echo '                                                                       '
	@echo 'Usage:                                                                 '
	@echo '    make new                  create new blog entry based on template  '
	@echo '    make draft               create new draft entry based on template  '
	@echo '    make clean                             remove the generated files  '
	@echo '    make deploy                    generate using production settings  '
	@echo '                                                                       '

clean:
	rm -r _site

draft:
	${BIN_PATH}/new_draft.sh

new:
	${BIN_PATH}/new_post.sh

deploy:
	git add -A
	git commit -m "update source"
	cp -r _site/ ${DEPLOY_PATH}/
	git branch -D master
	git push origin --delete master
	git checkout -b master
	rm -r ./*
	cp -r ${DEPLOY_PATH}/_site/* ./
	git add -A
	git commit -m "deploy blog"
	git push origin master
	git checkout source
	echo "deploy succeed"
	git push origin source
	echo "push source"


.PHONY: help clean draft new deploy
