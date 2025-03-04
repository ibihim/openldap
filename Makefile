RUNTIME ?= podman
CONTAINER_REGISTRY := dockerhub.com
IMAGE_NAME := openshift/openldap
IMAGE_PATH := $(CONTAINER_REGISTRY)/$(IMAGE_NAME)

ifeq ($(TARGET),rhel7)
	IMAGE_TAG := rhel7
	IMAGE_FILE := images/Dockerfile.rhel7
else
	IMAGE_TAG := fedora35
	IMAGE_FILE := images/Dockerfile
endif

IMAGE := $(IMAGE_PATH):$(IMAGE_TAG)

.PHONY: build
build:
	$(RUNTIME) build \
		-t "$(IMAGE)" \
		-f "$(IMAGE_FILE)" \
		.

.PHONY: test
test: build
	IMAGE="$(IMAGE)" \
	RUNTIME="$(RUNTIME)" \
		hack/test.sh

.PHONY: image_name
image_name:
	@echo "$(IMAGE)"
