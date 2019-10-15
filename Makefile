# Usage:
# make        	# compile all binary
# make clean  	# remove ALL binaries and objects
# make release  # add git TAG and push
VERSION					:= $(shell git describe --tags || echo "HEAD")
GOPATH					:= $(shell go env GOPATH)
HAS_GOVVV				:= $(shell command -v govvv 2> /dev/null)
HAS_KO					:= $(shell command -v ko 2> /dev/null)
CODECOV_FILE 		:= build/coverage.txt
TIMEOUT  				:= 60s
# DOCKER_CONTEXT_PATH 			:= my_project_id/micro-starter-kit
DOCKER_CONTEXT_PATH 			:= xmlking

# Type of service e.g api, fnc, srv, web (default: "srv")
TYPE = $(or $(word 2,$(subst -, ,$*)), srv)
override TYPES:= api srv
# Target for running the action
TARGET = $(word 1,$(subst -, ,$*))

override VERSION_PACKAGE = $(shell go list ./shared/config)
BUILD_FLAGS = $(shell govvv -flags -version $(VERSION) -pkg $(VERSION_PACKAGE))

# $(warning TYPES = $(TYPE), TARGET = $(TARGET))
# $(warning VERSION = $(VERSION), HAS_GOVVV = $(HAS_GOVVV), HAS_KO = $(HAS_KO))
# $(warning VERSION_PACKAGE = $(VERSION_PACKAGE), BUILD_FLAGS = $(BUILD_FLAGS))

.PHONY: clean update_deps docker docker_clean docker_push  start_deploy

start_deploy:
	@curl -H "Content-Type: application/json" \
		-H "Accept: application/vnd.github.ant-man-preview+json"  \
		-H "Authorization: token $(GITHUB_TOKEN)" \
    -XPOST https://api.github.com/repos/xmlking/micro-starter-kit/deployments \
    -d '{"ref": "develop", "environment": "production", "payload": { "what": "production deployment to GKE"}}'

clean:
	@echo "Deleting build/micro";
	@rm -f build/micro;


update_deps:
	go mod verify
	go mod tidy

docker:
	echo "Building micro image..."; \
	docker build --rm \
	--build-arg VERSION=$(VERSION) \
	--build-arg DOCKER_REGISTRY=${DOCKER_REGISTRY} \
	--build-arg DOCKER_CONTEXT_PATH=${DOCKER_CONTEXT_PATH} \
	--build-arg VCS_REF=$(shell git rev-parse --short HEAD) \
	--build-arg BUILD_DATE=$(shell date +%FT%T%Z) \
	-t $${DOCKER_REGISTRY:+${DOCKER_REGISTRY}/}${DOCKER_CONTEXT_PATH}/micro:${VERSION} -f Dockerfile .;


docker_clean:
	@echo "Cleaning dangling images..."
	@docker images -f "dangling=true" -q  | xargs docker rmi
	@echo "Removing microservice images..."
	@docker images -f "label=org.label-schema.vendor=sumo" -q | xargs docker rmi
	@echo "Pruneing images..."
	@docker image prune -f

docker_push:
	@echo "Piblishing images with VCS_REF=$(shell git rev-parse --short HEAD)"
	@docker images -f "label=org.label-schema.vcs-ref=$(shell git rev-parse --short HEAD)" --format {{.Repository}}:{{.Tag}} | \
	while read -r image; do \
		echo Now pushing $$image; \
		docker push $$image; \
	done;

