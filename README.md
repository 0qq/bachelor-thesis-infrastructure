# Bachelor thesis infrastructure
This repository contains infrastructure setup for my bachelor thesis.

This branch contains my experiments with kubeadm on AWS. All working except load balancer which
requires cloud controller manager I failed to setup in first time.
The second point is unexpired token managed by terraform which is huge security issue.
The third point is kops existing. With kops all I did here can be done easier.
Anyway that was fun experience.

## Requirements
- terraform

### Instructions
Export aws credentials
```
export AWS_ACCESS_KEY_ID=<YOUR_ACCESS_KEY>
export AWS_SECRET_ACCESS_KEY=<YOUR_SECRET_KEY>
```

#### Terraform
Terraform state file is stored in s3 bucket. Sadly, terraform can't neither manage
remote backend nor use vars to configure backend. To solve terraform chicken egg problem 
the very first terraform run initialize local backend, which creates "backend.tf"
with configured s3 backend, second init reconfigures backend to remote.
```
cd terraform/
terraform init
terraform apply
terraform init # configure remote backend
```

To destroy the infrastructure simply delete "backend.tf" and
reconfigure backend to local.
```
rm backend.tf
terraform init # configure local backend
terraform destroy
```
