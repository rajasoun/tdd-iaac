APP :=  $(shell basename $(CURDIR))
VERSION := $(shell git describe --tags --always --dirty)

# HELP
# This will output the help for each task
# thanks to https://marmelab.com/blog/2016/02/29/auto-documented-makefile.html
.PHONY: help
#.PHONY: bin/$(APP) bin clean start test

help: ## This help.
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)

.DEFAULT_GOAL := help

test:	## TDD Go
	gotestsum --format testname

terraform: ## Run Terraform 
	terraform -chdir=hello apply -auto-approve
