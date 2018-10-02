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

minikube start --profile "${MINICUBE_PROFILE}" --extra-config=apiserver.authorization-mode=RBAC --memory 4096

echo "Sleeping for 10 seconds (waiting for minikube)..."
sleep 10

minikube addons enable ingress --profile "${MINICUBE_PROFILE}"

kubectl create clusterrolebinding add-on-cluster-admin --clusterrole=cluster-admin --serviceaccount=kube-system:default
kubectl -n kube-system create sa tiller
kubectl create clusterrolebinding tiller --clusterrole cluster-admin --serviceaccount=kube-system:tiller
helm init --service-account tiller --upgrade --force-upgrade

echo "Sleeping for 10 seconds (waiting for helm)..."
sleep 10

helm dep list incubator/demo/
helm install --dep-up --name demo --values incubator/demo/values.yml incubator/demo/

minikube ip --profile "${MINICUBE_PROFILE}"
