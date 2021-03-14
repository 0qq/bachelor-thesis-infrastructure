#!/bin/bash


alias ssh='ssh -q -i ${private_key} -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null'
while true; do
	sleep 2
	! ssh ubuntu@${master_public_ip} [[ -f /bootstrap_complete ]] >/dev/null && continue
	break
done

# vim: filetype=sh
