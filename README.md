# Bachelor thesis infrastructure
This repository contains infrastructure for my bachelor thesis.

Currently WIP.

## Requirements
- terraform >=0.14
- aws-cli2

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
terraform init
terraform apply --var-file=example.tfvars
terraform init # configure remote backend
```

To destroy the infrastructure simply delete "backend.tf" and
reconfigure backend to local.
```
rm backend.tf
terraform init # configure local backend
terraform destroy
```
