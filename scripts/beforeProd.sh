#! /usr/local/bin/bash -ex
# don't regenerate secrets for prod if they are already present
if kubectl get secret etcd-client-tls -n prod; then
  exit 0;
fi

export PATH=$PATH:/usr/local/go/bin:/go/bin
export GOPATH=/go

# setup tls for etcd
export GEN_CLUSTER_SIZE=3
export GEN_NAMESPACE="prod"
export GEN_SERVER_SECRET_NAME="etcd-server-tls"
export GEN_PEER_SECRET_NAME="etcd-peer-tls"
export GEN_CLIENT_SECRET_NAME="etcd-client-tls"
export GEN_STATEFULSET_NAME="etcd-vault"
export GEN_CLUSTER_DOMAIN="cluster.local"

# create the namespace
echo "Creating namespace ${GEN_NAMESPACE}"
kubectl create namespace ${GEN_NAMESPACE} || true

# generate tls secrets for vault in GEN_NAMESPACE
echo "Generating etcd TLS certificates"
${PIPELINE_WORKSPACE}/charts/vault-etcd/tls-generator/generate-certs.sh