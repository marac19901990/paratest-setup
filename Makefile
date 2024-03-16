phony: help #needed in case there is a file named "help"

default: help #execute "make help" in case no target is specified

help: ## Show this help.
	@awk 'BEGIN {FS = ":.*##"; printf "\nUsage:\n  make \033[36m\033[0m\n"} /^[a-zA-Z_-]+:.*?##/ { printf "  \033[36m%-15s\033[0m %s\n", $$1, $$2 } /^##@/ { printf "\n\033[1m%s\033[0m\n", substr($$0, 5) } ' $(MAKEFILE_LIST)

build: ## Install (or reset) & bootstrap local environment
	$(MAKE) down
	docker compose build
	$(MAKE) up
	$(MAKE) install
	$(MAKE) down

up: ## start the local environment
	docker compose up -d

down: ## stop the local environment
	docker compose down

install: ## install dependencies
	docker compose exec php composer install

test: ## run unit tests
	docker compose exec php bash -c './vendor/bin/phpunit tests/UnitTests --configuration phpunit.xml.dist'

integration: ## run integration tests
	docker compose exec php bash -c 'php vendor/bin/phpunit tests/IntegrationTests --configuration phpunit.xml.dist -dmemory_limit=1024M'

initial-fix: ## change all directory/file permissions to current user
	sudo chown -R $$USERNAME:$$USERNAME *
	sudo chown -R $$USERNAME:$$USERNAME .*
	$(MAKE) clean

clean: ## remove all temporary files, requires 'make install' afterwards
	rm -rf ./vendor/*
	rm -rf ./var/log/*
	rm -rf ./var/nginx/*
	rm -rf ./var/cache/*
	rm -rf ./var/coverage/*
	rm -rf ./composer/*
	rm -rf ./public/bundles/*
