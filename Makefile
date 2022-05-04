.PHONY: help all backup build login push remove run
.DEFAULT_GOAL := help

help:
	@awk 'BEGIN {FS = ":.*#"; printf "\nUsage:\n  make \033[36m<target>\033[0m\n\n"} /^[a-zA-Z0-9_-]+:.*?#/ { printf "  \033[36m%-27s\033[0m %s\n", $$1, $$2 } /^##@/ { printf "\n\033[1m%s\033[0m\n", substr($$0, 5) } ' $(MAKEFILE_LIST); printf "\n"

all: ## Build all
all: build

backup: ## Backup codebase (*_YYYYMMDD_HHMM.tar.gz)
backup: archive=`pwd`_`date +'%Y%m%d_%H%M'`.tar.gz
backup:
	@tar -czf $(archive) *
	@ls -l `pwd`*.tar.gz

build: ## Build docker image
	@docker build -t ricfio/python-selenium:3.10 .

login: ## Login docker container
login: pwd=`pwd`
login:
	@docker run -it --rm --workdir=/workspaces/sandbox-selenium --volume=$(pwd):/workspaces/sandbox-selenium ricfio/python-selenium:3.10 bash

push: ## Push docker image
	@docker push ricfio/python-selenium:3.10

remove: ## Remove docker image
	@docker image rm --force ricfio/python-selenium:3.10

run: ## Run chrome from docker
	@docker run --rm ricfio/python-selenium:3.10 bash -c 'google-chrome-stable --no-sandbox --display=host.docker.internal:0.0 --disable-dev-shm-usage'
