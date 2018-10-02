#!/usr/bin/env bash

DEPS_LIST=("minikube" "kubectl" "helm")
for item in "${DEPS_LIST[@]}"; do
  if ! command -v "$item" &> /dev/null ; then
    echo "Error: required command '$item' was not found"
    exit 1
  fi
done

helm upgrade --install --force --values incubator/demo/values.yml demo incubator/demo/
