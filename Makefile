.PHONY: help all backup build login push remove run
.DEFAULT_GOAL := help

ifeq ($(wildcard .Makefile), .Makefile)
  -include .Makefile
endif

help:
	@awk 'BEGIN {FS = ":.*#"; printf "\nUsage:\n  make \033[36m<target>\033[0m\n\n"} /^[a-zA-Z0-9_-]+:.*?#/ { printf "  \033[36m%-27s\033[0m %s\n", $$1, $$2 } /^##@/ { printf "\n\033[1m%s\033[0m\n", substr($$0, 5) } ' $(MAKEFILE_LIST); printf "\n"

MAKEFILE_PATH := $(shell pwd)

all: ## Build all
all: build

backup: ## backup [BACKUP_TARGET_PATH=..]
backup: BACKUP_TARGET_PATH?=..
backup: source=$(shell basename $(CURDIR))
backup: target=$(shell echo `pwd`_`date +'%Y%m%d_%H%M'`.tar.gz)
backup: exclude_paths+=__pycache__
backup: exclude_options=$(foreach path,$(exclude_paths),--exclude=$(path))
backup:
	@cd .. && tar -czf $(target) $(exclude_options) $(source) && \
	if [ "$(BACKUP_TARGET_PATH)" != ".." ]; then \
		mv $(target) $(BACKUP_TARGET_PATH); \
	fi && \
	cd $(MAKEFILE_PATH) && \
	ls -l $(BACKUP_TARGET_PATH)/$(source)_*.tar.gz

build: ## Build docker image
	@docker build -t ricfio/python-selenium:3.12 .

login: ## Login docker container
login: pwd=`pwd`
login:
	@docker run -it --rm --net host -e DISPLAY=unix$(DISPLAY) --workdir=/workspaces/sandbox-selenium --volume=$(pwd):/workspaces/sandbox-selenium ricfio/python-selenium:3.12 bash

push: ## Push docker image
	@docker push ricfio/python-selenium:3.12

remove: ## Remove docker image
	@docker image rm --force ricfio/python-selenium:3.12

run: ## Run chrome from docker
	@docker run -it --rm --net host -e DISPLAY=unix$(DISPLAY) ricfio/python-selenium:3.12 google-chrome-stable --no-sandbox
