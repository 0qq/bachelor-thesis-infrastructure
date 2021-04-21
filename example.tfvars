aws_region         = "eu-north-1"
availability_zones = ["eu-north-1a", "eu-north-1b"]

enable_terraform_remote_backend = true

cluster_name           = "this"
cluster_instance_types = ["t3.medium"]
cluster_desired_size   = 2
cluster_min_size       = 2
cluster_max_size       = 2

gitlab_project_id = "25999080"

container_registry_name = "server"
