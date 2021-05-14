PREFIX=paleozogt
IMAGE_NAME=$(shell basename $(shell git config remote.origin.url) .git)
IMAGE_VER=$(shell git describe)

ARCHES=amd64 i386 arm32v7 arm64v8 ppc ppc64 ppc64le
IMAGES=$(addprefix $(PREFIX)/$(IMAGE_NAME):$(IMAGE_VER)-, $(ARCHES))
IMAGES_LATEST=$(addprefix $(PREFIX)/$(IMAGE_NAME):latest-, $(ARCHES))

BUILD_TARGETS=$(addprefix image-, $(ARCHES))
images: $(BUILD_TARGETS)
$(BUILD_TARGETS): Dockerfile
	$(eval ARCH = $(word 2, $(subst -, ,$@)))
	docker build --build-arg ARCH=$(ARCH) -t $(PREFIX)/$(IMAGE_NAME):$(IMAGE_VER)-$(ARCH) .
	docker tag $(PREFIX)/$(IMAGE_NAME):$(IMAGE_VER)-$(ARCH) $(PREFIX)/$(IMAGE_NAME):latest-$(ARCH)

CLEAN_TARGETS=$(addprefix clean-, $(ARCHES))
clean: $(CLEAN_TARGETS)
$(CLEAN_TARGETS):
	$(eval ARCH = $(word 2, $(subst -, ,$@)))
	docker rmi $(PREFIX)/$(IMAGE_NAME):$(IMAGE_VER)-$(ARCH)

PUBLISH_TARGETS=$(addprefix publish-, $(ARCHES))
publish: $(PUBLISH_TARGETS)
	docker manifest create $(PREFIX)/$(IMAGE_NAME):$(IMAGE_VER) $(IMAGES)
	docker manifest create $(PREFIX)/$(IMAGE_NAME):latest $(IMAGES_LATEST)
	docker manifest push $(PREFIX)/$(IMAGE_NAME):$(IMAGE_VER)
	docker manifest push $(PREFIX)/$(IMAGE_NAME):latest
$(PUBLISH_TARGETS):
	$(eval ARCH = $(word 2, $(subst -, ,$@)))
	docker push $(PREFIX)/$(IMAGE_NAME):latest-$(ARCH)
	docker push $(PREFIX)/$(IMAGE_NAME):$(IMAGE_VER)-$(ARCH)
