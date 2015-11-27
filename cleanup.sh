#!/bin/sh
#
# Bring down Kubernetes replication controllers and services
#

set -e

echo "Deleting replications controllers..."
kubectl delete -f definitions/

echo "All done!"
