#!/bin/sh
#
# This script create docker images and deploy a local cluster

set -e

echo "Building Docker images..."
docker build -t site-one-container site-one.com
docker build -t site-two-container site-two.com
docker build -t proxy-container proxy

echo "Creating services..."
kubectl create -f definitions/proxy_svc.yaml
kubectl create -f definitions/site-one_svc.yaml
kubectl create -f definitions/site-two_svc.yaml

echo "Creating replications controllers..."
kubectl create -f definitions/proxy_rc.yaml
kubectl create -f definitions/site-one_rc.yaml
kubectl create -f definitions/site-two_rc.yaml

echo "All done!"

