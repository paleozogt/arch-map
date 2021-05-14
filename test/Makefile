PREFIX=paleozogt
IMAGE_NAME=$(shell basename $(shell git config remote.origin.url) .git)
IMAGE_VER=$(shell git describe)

ARCHES=amd64 i386 arm32v7 arm64v8 ppc ppc64 ppc64le
IMAGES=$(addprefix $(PREFIX)/$(IMAGE_NAME):$(IMAGE_VER)-, $(ARCHES))

BUILD_TARGETS=$(addprefix image-, $(ARCHES))
images: $(BUILD_TARGETS)
$(BUILD_TARGETS): Dockerfile
	$(eval ARCH = $(word 2, $(subst -, ,$@)))
	$(eval $(if $(filter $(ARCH),ppc),DISTRO=xenial,DISTRO=bionic))
	$(eval $(if $(filter $(ARCH),ppc64),DISTRO=xenial,))
	docker build --build-arg ARCH=$(ARCH) --build-arg DISTRO=$(DISTRO) -t $(PREFIX)/$(IMAGE_NAME):$(IMAGE_VER)-$(ARCH) .

CLEAN_TARGETS=$(addprefix clean-, $(ARCHES))
clean: $(CLEAN_TARGETS)
$(CLEAN_TARGETS):
	$(eval ARCH = $(word 2, $(subst -, ,$@)))
	docker rmi $(PREFIX)/$(IMAGE_NAME):$(IMAGE_VER)-$(ARCH)
