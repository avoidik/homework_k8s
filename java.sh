#!/usr/bin/env bash

DEPS_LIST=("docker")
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

docker build --tag "${DOCKERHUB_OWNER}/java-base:${VERSION_TAG}" java-base
docker push "${DOCKERHUB_OWNER}/java-base:${VERSION_TAG}"
