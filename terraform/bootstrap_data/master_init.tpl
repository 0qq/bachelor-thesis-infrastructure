#!/bin/bash
# Run kubeadm
kubeadm init \
	--token "${token}" \
	--token-ttl 0 \
	--apiserver-cert-extra-sans ${master_public_ip} \
	--pod-network-cidr "10.244.0.0/16" # required for flannel


export KUBECONFIG_PATH=/home/ubuntu/.kube
export KUBECONFIG="$KUBECONFIG_PATH"/config

mkdir -p $KUBECONFIG_PATH
cp /etc/kubernetes/admin.conf $KUBECONFIG
chown ubuntu:ubuntu $KUBECONFIG
kubectl config set-cluster kubernetes --server https://${master_public_ip}:6443


# Install flannel pod network add-on
kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/master/Documentation/kube-flannel.yml

# Indicate completion of bootstrapping on this node
touch /bootstrap_complete


# vim: filetype=sh
