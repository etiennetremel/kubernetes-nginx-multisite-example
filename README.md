Kubernetes NGINX multisite cluster
==================================

An NGINX instance used as a reverse proxy dispatch traffic to the corresponding Pod via service discovery.

Services should be created before the Proxy replication controller.


```
                                                   PUBLIC IP
                                                       |
                                                       |
                      +--------------------------------v--------------------------------+
                      | K8S CLUSTER                    |                                |
                      |                   +------------v------------+                   |
                      |                   | SERVICE PROXY           |                   |
                      |                   +-------------------------+                   |
                      |                   +-------------------------+                   |
                      |                   | REPLICATION CONTROLLER  |                   |
                      |                   |                         |                   |
                      |                   | POD         POD         |                   |
                      |                   | +---------+ +---------+ |                   |
                      |                   | |  PROXY  | |  PROXY  | |                   |
                      |                   | |  NGINX  | |  NGINX  | |                   |
                      |                   | +---------+ +---------+ |                   |
                      |                   +-------------------------+                   |
                      |                          |           |                          |
                      |  +-----------------------v---+   +---v-----------------------+  |
                      |  | SERVICE SITE ONE          |   | SERVICE SITE TWO          |  |
                      |  +---------------------------+   +---------------------------+  |
                      |  +---------------------------+   +---------------------------+  |
                      |  | REPLICATION CONTROLLER    |   | REPLICATION CONTROLLER    |  |
                      |  |                           |   |                           |  |
                      |  | POD          POD          |   | POD         POD           |  |
                      |  | +----------+ +----------+ |   | +----------+ +----------+ |  |
                      |  | | SITE ONE | | SITE ONE | |   | | SITE TWO | | SITE TWO | |  |
                      |  | |  NGINX   | |  NGINX   | |   | |  NGINX   | |  NGINX   | |  |
                      |  | +----------+ +----------+ |   | +----------+ +----------+ |  |
                      |  +---------------------------+   +---------------------------+  |
                      |                                                                 |
                      +-----------------------------------------------------------------+

```



### Getting started

##### 1. Run a Kubernetes cluster locally:

Make sure to have access to GCloud container registry, images will be pushed on their container registry.


###### a. Install dependencies, run cluster

[https://github.com/kubernetes/kubernetes/blob/master/docs/getting-started-guides/locally.md](https://github.com/kubernetes/kubernetes/blob/master/docs/getting-started-guides/locally.md)

Install necessary dependencies (Go, ETCD, Docker), clone the Kubernetes repo, then:

```bash
hack/local-up-cluster.sh
```


###### b. Setup K8S context

In a new shell:

Make sure Kubectl is in you path: (path/to/kubernetes/repo/cluster/kubectl.sh)

```bash
cluster/kubectl.sh config set-cluster local --server=http://127.0.0.1:8080 --insecure-skip-tls-verify=true
cluster/kubectl.sh config set-context local --cluster=local
cluster/kubectl.sh config use-context local
```


##### 2. Run startup script (build images, push to GCloud container registry, create replications controllers and services)

To how what is happening in your cluster, you can run the following command in a different terminal:

```bash
# Show available pods
watch -n1 'cluster/kubectl.sh get pods'
```

And in another terminal the startup script:

```bash
/bin/bash startup.sh
```


##### 3. Test

```bash
curl -k -H "Host: www.site-one.com" https://$(kubectl get svc | grep proxy | awk '{print $2}')
curl -k -H "Host: www.site-two.com" https://$(kubectl get svc | grep proxy | awk '{print $2}')

# This command get the proxy service IP:  kubectl get svc | grep proxy | awk '{print $2}'
```


##### 4. Clean up

Bring down replication controllers and services

```bash
/bin/bash cleanup.sh
```

