#!/bin/bash
# Run kubeadm
kubeadm join ${master_private_ip}:6443 \
	--token ${token} \
	--discovery-token-unsafe-skip-ca-verification

# Indicate completion of bootstrapping on this node
touch /bootstrap_complete


# vim: filetype=sh
