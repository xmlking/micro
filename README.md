# Micro

> Custom build for `micro/micro:latest` with

- [static selector go-plugins](https://github.com/micro/go-plugins/tree/master/client/selector/static) to use with k8s e2e testing.
- [cors go-plugins](https://github.com/micro/go-plugins/tree/master/micro/cors) to use as a `REST Gateway` for gRPC microservices. CORS enabled.
- [googlepubsub go-plugins](https://github.com/micro/go-plugins/tree/master/broker/googlepubsub) optionally, use `googlepubsub` as broker, along with micro-cli. i.e., `micro --broker=googlepubsub`

## Build

```bash
go build -o build/ ./cmd/...
# build and install micro-cli to ~/go/bin
go install ./cmd/micro/...
```

## Test

```bash
# health checking with micro. use correct target service gRPC port below
micro health --check_service=account-srv --check_address=0.0.0.0:55493
micro --selector static  call 10.60.1.101:8080 Debug.Health
```

## Run

```bash
make run-micro-cmd ARGS="api --enable_rpc=true"
# with plugins (cors, kubernetes )
go run cmd/micro/main.go cmd/micro/plugin.go  api --enable_rpc=true
# without plugins
go run cmd/micro/main.go  api --enable_rpc=true
```

## Using googlepubsub as broker

> overwrite plugin options via Environment variables `MICRO_(PLUGIN)_(OPTION)`

In Terminal 1, run

```bash
# start pubsub emulator
gcloud beta emulators pubsub start
```

In Terminal 2, run `micro` cli

````bash
export PUBSUB_EMULATOR_HOST=localhost:8432
export PUBSUB_PROJECT_ID=my-project-id
MICRO_GOOGLEPUBSUB_PROJECT_ID=my_project_id MICRO_BROKER=googlepubsub make run-micro-cmd ARGS="api --enable_rpc=true"
```

## Docker

> from project root directory, run following commands.

### Docker Build

> Simple

```bash
make docker DOCKER_REGISTRY=docker.pkg.github.com DOCKER_CONTEXT_PATH=xmlking/micro-starter-kit VERSION=v1.13.1
# push
docker push docker.pkg.github.com/xmlking/micro-starter-kit/micro:v1.13.1
```

> TL;DR

```bash
# build
VERSION=0.1.0-SNAPSHOT
# DOCKER_REGISTRY=gcr.io
DOCKER_CONTEXT_PATH=xmlking
docker build --rm \
--build-arg VERSION=$VERSION \
--build-arg DOCKER_REGISTRY=${DOCKER_REGISTRY} \
--build-arg DOCKER_CONTEXT_PATH=${DOCKER_CONTEXT_PATH} \
--build-arg VCS_REF=$(git rev-parse --short HEAD) \
--build-arg BUILD_DATE=$(date -u +'%Y-%m-%dT%H:%M:%SZ') \
-t ${DOCKER_REGISTRY:+${DOCKER_REGISTRY}/}${DOCKER_CONTEXT_PATH}/micro:${VERSION} -f cmd/micro/Dockerfile .

IMANGE_NAME=${DOCKER_REGISTRY:+${DOCKER_REGISTRY}/}${DOCKER_CONTEXT_PATH}/micro:${VERSION}

# push
docker push $IMANGE_NAME

# check
docker inspect  $IMANGE_NAME
# remove temp images after build
docker image prune -f
# Remove dangling images
docker rmi $(docker images -f "dangling=true" -q)
# Remove images tagged with vendor=sumo
docker rmi $(docker images -f "label=org.label-schema.vendor=sumo"  -q)
```

### Docker Run

> run just for testing image...

```bash
docker run -it \
-e MICRO_API_ADDRESS=0.0.0.0:8080 \
-e MICRO_BROKER_ADDRESS=0.0.0.0:10001 \
-e MICRO_REGISTRY=mdns \
-p 8080:8080 -p 10001:10001 $IMANGE_NAME api
```

```bash
CORS_ALLOWED_HEADERS="Authorization,Content-Type"
# CORS_ALLOWED_ORIGINS="*"
# important - don't  put a / at the end of the ORIGINS
CORS_ALLOWED_ORIGINS="http://localhost:4200,https://api.kashmora.com"
CORS_ALLOWED_METHODS="POST,GET"
```

### Ref

<https://micro.mu/docs/go-grpc.html>
````
