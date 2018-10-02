# K8s

## Java application

Target application might be found here:

```
https://github.com/stantonk/java-docker-example.git
```

## Requirements

1. docker
1. docker-machine
1. helm
1. kubectl
1. minikube

## Workflow

1. login to dockerhub `docker login`
1. change `.env` file and set `DOCKERHUB_OWNER` to username (the same as in previous login command)
1. `java.sh` - build java base image, upload to dockerhub
1. `build.sh` - build application image, upload to dockerhub
1. `deploy.sh` - spin up kubernetes on minikube, configure RBAC and initialize helm
1. change something in java code
1. `build.sh` - re-build images, re-upload to dockerhub
1. `refresh.sh` - refresh helm chart
1. `cleanup.sh` - clean everything up (excluding dockerhub images)

Resulting service will be available via NodePort at:

```
http:// < minikube ip > :30303/api/tweets
```

You may want to open it with:

```
minikube service demo-example-http --profile demo --namespace default
```

Or access with port-forward:

```
POD=$(kubectl get pods -n default --selector app=example \
    -o template --template '{{range .items}}{{.metadata.name}} {{.status.phase}}{{"\n"}}{{end}}' \
    | grep Running | head -1 | cut -f1 -d' ')

kubectl port-forward -n default ${POD} 8081:8080
```

Or via Ingress Controller:

```
echo "$(minikube ip --profile demo) jexmpl.example.com" | sudo tee -a /etc/hosts
```

Then open:

```
http://jexmpl.example.com/api/tweets
```

You may try [ngrok](https://ngrok.com/) as the last chance option

## FAQ

1. Can we do a HA of a database? Any way to keep the data persistent when pods are recreated?

We have stateless frontend, but stateful backend. Of course we can have HA configuration in such configuration.

We can set following option to helm to enable HA:

```
--set mysql.persistence.enabled=true
```

1. Add CI to the deployment process.

Just combine shell scripts from workflow above

1. Split your deployment into prd/qa/dev environment.

Tweak .env file

1. Please suggest a monitoring solutions for your system. How would you notify an admin
that the resources are scarce?

A lot of option, you may want to start from prometheus-operator from coreos

## Copyright

You may use my work or its parts as you wish, but only with proper credits to me like this:

Viacheslav - avoidik@gmail.com
