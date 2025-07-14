#!/bin/bash

set -euo pipefail

# Source environment variables

clean() {
	echo "Cleaning up previous builds..."
	docker buildx prune -f
}

build() {
	echo "Building Docker image..."
	source ./setup_env.sh
	echo "$NODE_VERSION"
	docker buildx build -t nativeit/agency-os:v${AGENCY_OS_VERSION} -f Dockerfile . \
		--build-arg NODE_VERSION=${NODE_VERSION} \
		--build-arg AGENCY_OS_VERSION=${AGENCY_OS_VERSION} \
		--build-arg AGENCY_OS_REPO_URL=${AGENCY_OS_REPO_URL} \
		--build-arg AGENCY_OS_REPO_BRANCH=${AGENCY_OS_REPO_BRANCH} \
		--build-arg DIRECTUS_URL=${DIRECTUS_URL} \
		--build-arg DIRECTUS_SERVER_PORT=${DIRECTUS_SERVER_PORT} \
		--build-arg DIRECTUS_SERVER_TOKEN=${DIRECTUS_SERVER_TOKEN}
}

push() {
	echo "Building and pushing Docker image..."
	source ./setup_env.sh
	docker buildx build -t nativeit/agency-os:v${AGENCY_OS_VERSION} -f Dockerfile . \
		--build-arg NODE_VERSION=${NODE_VERSION} \
		--build-arg AGENCY_OS_VERSION=${AGENCY_OS_VERSION} \
		--build-arg AGENCY_OS_REPO_URL=${AGENCY_OS_REPO_URL} \
		--build-arg AGENCY_OS_REPO_BRANCH=${AGENCY_OS_REPO_BRANCH} \
		--build-arg AGENCY_OS_REPO_NAME=${AGENCY_OS_REPO_NAME} \
		--build-arg DIRECTUS_URL=${DIRECTUS_URL} \
		--build-arg DIRECTUS_SERVER_PORT=${DIRECTUS_SERVER_PORT} \
		--build-arg DIRECTUS_SERVER_TOKEN=${DIRECTUS_SERVER_TOKEN} \
		--output "type=registry,dest=${DOCKER_REGISTRY_URL}/${DOCKER_REGISTRY_USERNAME}/${AGENCY_OS_REPO_NAME}"
	echo "Build completed, Docker image nativeit/agency-os:v${AGENCY_OS_VERSION} was pushed to ${DOCKER_REGISTRY_URL}/${DOCKER_REGISTRY_USERNAME}/${AGENCY_OS_REPO_NAME}:v${AGENCY_OS_VERSION}."
}

case "$1" in
	clean)
		clean
		;;
	build)
		build
		;;
	push)
		push
		;;
	*)
		echo "Usage: $0 {clean|build|push}"
		exit 1
		;;
esac
