#!/usr/bin/env bash

pushd () {
    command pushd "$@" > /dev/null
}

popd () {
    command popd "$@" > /dev/null
}

DEPS_LIST=("docker-machine" "docker" "git")
for item in "${DEPS_LIST[@]}"; do
  if ! command -v "$item" &> /dev/null ; then
    echo "Error: required command '$item' was not found"
    exit 1
  fi
done

if [ ! -f ".env" ]; then
  echo "environment definition is missing"
  exit 1
fi

source ./.env

git clone https://github.com/stantonk/java-docker-example.git

IS_RUN="$(docker-machine ls --filter "name=${MACHINE_NAME}" --filter "state=Running" -q)"
if [[ -n "${IS_RUN}" ]]; then
  echo "docker-machine ${MACHINE_NAME} already exist"
else
  docker-machine create "${MACHINE_NAME}"
fi

eval "$(docker-machine env "${MACHINE_NAME}")"

docker run -i --rm --name java-docker-example \
  -v "/$(pwd)/java-docker-example://builder" \
  -v "/$(pwd)/ep://ep" \
  --entrypoint "//ep/ep.sh" \
  -w "//builder" \
  maven:3.3-jdk-8

sed -i "s/^\\(FROM\\s\\).*$/\\1${DOCKERHUB_OWNER}\\/java-base:${VERSION_TAG}/" java-docker-example/Dockerfile

docker build --tag "${DOCKERHUB_OWNER}/java-docker-example:${VERSION_TAG}" java-docker-example
docker push "${DOCKERHUB_OWNER}/java-docker-example:${VERSION_TAG}"
