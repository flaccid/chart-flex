DOCKER_REGISTRY = index.docker.io
IMAGE_NAME = flex
IMAGE_VERSION = latest
IMAGE_ORG = flaccid
IMAGE_TAG = $(DOCKER_REGISTRY)/$(IMAGE_ORG)/$(IMAGE_NAME):$(IMAGE_VERSION)
export DOCKER_BUILDKIT = 1
export DOCKER_BUILD_PROGRESS_TYPE = plain

WORKING_DIR := $(shell pwd)

.DEFAULT_GOAL := helm-validate

.PHONY: helm-validate helm-render

helm-install:: ## installs using helm from chart in repo
		@helm install \
			-f helm-values.dev.yaml \
			--namespace default \
				flex .

helm-upgrade:: ## upgrades deployed helm release
		@helm upgrade \
			-f helm-values.dev.yaml \
			--namespace default \
				flex .

helm-uninstall:: ## deletes and purges deployed helm release
		@helm uninstall \
			--namespace default \
				flex

helm-render:: ## prints out the rendered chart
		@helm install \
			-f helm-values.dev.yaml \
			--namespace default \
			--dry-run \
			--debug \
				flex .

helm-validate:: ## runs a lint on the helm chart
		@helm lint \
			-f helm-values.dev.yaml \
			--namespace default \
				.

# a help target including self-documenting targets (see the awk statement)
define HELP_TEXT
Usage: make [TARGET]... [MAKEVAR1=SOMETHING]...

Available targets:
endef
export HELP_TEXT
help: ## this help target
	@cat .banner
	@echo
	@echo "$$HELP_TEXT"
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / \
		{printf "\033[36m%-30s\033[0m  %s\n", $$1, $$2}' $(MAKEFILE_LIST)
