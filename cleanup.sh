#!/usr/bin/env bash

DEPS_LIST=("minikube" "kubectl" "helm")
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

if [ -d "java-docker-example" ]; then
  rm -rf ./java-docker-example
fi

helm delete --purge demo
minikube delete --profile "${MINICUBE_PROFILE}"
