#!/bin/bash


alias ssh='ssh -q -i ${private_key} -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null'
while true; do
	sleep 2
	! ssh ubuntu@${master_public_ip} [[ -f /bootstrap_complete ]] >/dev/null && continue
	%{for worker_public_ip in worker_public_ips~}
	! ssh ubuntu@${worker_public_ip} [[ -f /bootstrap_complete  ]] >/dev/null && continue
	%{endfor~}
	break
done

# vim: filetype=sh
