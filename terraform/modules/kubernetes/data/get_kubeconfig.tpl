#!/bin/bash


alias scp='scp -q -i ${private_key} -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null'
scp ubuntu@${master_public_ip}:/home/ubuntu/.kube/config ${kubeconfig_name} >/dev/null

# vim: filetype=sh
